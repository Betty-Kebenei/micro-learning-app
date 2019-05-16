require 'sinatra'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'sinatra/activerecord'
require './config/environments'
require 'uri'

require_relative '../../app/models/user'

class ApplicationController < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  helpers Sinatra::RedirectWithFlash

  configure do
    set :views, 'app/views'
    set :public_folder, 'app/public'
  end

  get '/' do
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
      if user.password == password
        redirect '/', notice: 'User login was successful!'
      else
        redirect '/login', error: 'Wrong password!'
      end
    else
      redirect '/login', error: 'User with that email does not exist!'
    end
  end

end

