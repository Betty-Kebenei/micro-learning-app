require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/activerecord'
require './config/environments'
require 'uri'
require 'news-api'
require 'json'

require_relative '../../app/models/user'

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
    File.open('transit_storage.txt', 'w') do |file|
      file.puts(article)
    end
  end

  def read_article
    File.read('transit_storage.txt')
  rescue Errno::ENOENT
    return nil
  end

  get '/' do
    @current_user = session[:user_id]
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

    @article = newsapi.get_everything(
        q: topic,
        language: 'en',
        sortBy: 'relevancy').sample
    save_article(@article.to_json)
    redirect '/article'
  end
  
  get '/article' do
    protected!
    @article = JSON.parse(read_article)
    if @article.empty?
      redirect '/'
    else
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

