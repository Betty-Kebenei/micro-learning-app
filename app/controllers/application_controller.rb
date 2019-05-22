require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/activerecord'
require './config/environments'
require 'uri'
require 'news-api'
require 'json'
require 'date'
require 'httparty'

require_relative '../../app/models/user'
require_relative '../../app/models/article'

class ApplicationController < Sinatra::Base
  use Rack::Session::Cookie
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash

  configure do
    set :views, 'app/views'
    set :public_folder, 'app/public'
  end

  def protected!
    unless logged_in
      redirect '/'
    end
  end

  def unprotected!
    if logged_in
      redirect '/'
    end
  end

  def logged_in
    if session[:user_id]
      return true
    end
  end

  def save_article(article)
    user_id = session[:user_id]
    if File.file?("#{user_id}.txt")
      File.delete("#{user_id}.txt")
    end
    File.open("#{user_id}.txt", 'w') do |file|
      file.puts(article)
    end
  end

  def read_article
    user_id = session[:user_id]
    File.read("#{user_id}.txt")
  rescue Errno::ENOENT
    return nil
  end

  get '/' do
    @current_user = session[:user_id]
    read_article = Article.find_by(
        user_id: @current_user, updated_at: Date.today)
    if read_article
      @read = true
    end
    erb :home
  end

  get '/register' do
    unprotected!
    erb :register
  end

  post '/create_user' do
    email = params['user']['email']
    password = params['user']['password']
    con_password = params['user']['con_password']

    if password == con_password
      user = User.new(email: email, password: password)
      user_exists = User.find_by(email: email)
      if user_exists || !user.valid?
        error = user_exists ?
                    'User with that email already exists!' :
                    'Invalid email or password'
        redirect '/register', error: error
      else
        user.save
        session[:user_id] = user.id
        redirect '/', notice: 'User registration was successful!'
      end
    else
      redirect '/register', error:  'Passwords do not match!'
    end
  end

  get '/login' do
    unprotected!
    erb :login
  end

  post '/login_user' do
    email = params['user']['email']
    password = params['user']['password']

    user = User.find_by(email: email)
    if user
      if user.authenticate(password)
        session[:user_id] = user.id
        redirect '/', notice: 'User login was successful!'
      else
        redirect '/login', error: 'Wrong password!'
      end
    else
      redirect '/login', error: 'User with that email does not exist!'
    end
  end

  get '/logout' do
    protected!
    session.delete(:user_id)
    redirect '/', notice: 'User logout was successful!'
  end

  post '/search_articles' do
    topic = params['article']['topic']

    API_KEY = ENV['API_KEY']
    newsapi = News.new(API_KEY)

    x_frame_option = true
   while x_frame_option do
     @article = newsapi.get_everything(q: topic, language: 'en', sortBy: 'relevancy').sample
     url = JSON.parse(@article.to_json).fetch('url')
     frame = HTTParty.get(url).headers['X-Frame-Options']
     if frame == 'DENY' || frame == 'SAMEORIGIN' || frame == 'ALLOW-FROM'
       x_frame_option = true
     else
       x_frame_option = false
     end
   end
    save_article(@article.to_json)
    redirect '/article'
  end
  
  get '/article' do
    protected!
    @current_user = session[:user_id]
    @article = JSON.parse(read_article)
    if @article.empty?
      redirect '/'
    else
      article = Article.new(
          url: @article.fetch('url'),
          user_id: session[:user_id])
      article.save
      erb :select
    end
  end

  not_found do
    puts logged_in
    if logged_in
      redirect '/404'
    else
      redirect '/'
    end
  end

  get '/404' do
    protected!
    erb :not_found
  end
end

