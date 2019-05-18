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

  def logged_in
    if session[:user_id]
      return true
    end
  end

  def current_user
    user_id = session[:user_id]
    user = User.find_by(id: user_id)
    return user
  end

  def save_articles_to_select(articles)
    File.open('transit_storage.txt', 'w') do |file|
      file.puts(articles)
    end
  end

  def read_articles
    File.read('transit_storage.txt')
  rescue Errno::ENOENT
    return nil
  end

  get '/' do
    @current_user = session[:user_id]
    erb :home
  end

  get '/register' do
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
    session.delete(:user_id)
    redirect '/', notice: 'User logout was successful!'
  end

  post '/search_articles' do
    @articles = []
    topic = params['article']['topic']

    API_KEY = ENV['API_KEY']
    newsapi = News.new(API_KEY)

    newsapi.get_everything(
        q: topic,
        sortBy: 'relevancy').take(10).each do |article|
      article_hash = {}
      article_hash[:title] = article.title
      article_hash[:description] = article.description
      article_hash[:url] = article.url
      @articles.push(article_hash)
    end
    save_articles_to_select(@articles.to_json)
    redirect '/select_article'
  end

  get '/select_article' do
    @select_articles = JSON.parse(read_articles)
    erb :select
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
    erb :not_found
  end
end

