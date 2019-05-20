[![Build Status](https://travis-ci.com/Betty-Kebenei/micro-learning-app.svg?branch=master)](https://travis-ci.com/Betty-Kebenei/micro-learning-app)
[![Coverage Status](https://coveralls.io/repos/github/Betty-Kebenei/micro-learning-app/badge.svg?branch=master)](https://coveralls.io/github/Betty-Kebenei/micro-learning-app?branch=master)

# Micro-Learning App
Micro-Learning Application that sends a user one page per day about something the user wants to learn. Built using Ruby with Sinatra.

## Getting Started
### Prerequisites
- Ruby
- Postgres

### Installing
- Clone this repo using the following command:
`git clone https://github.com/Betty-Kebenei/micro-learning-app.git`
- Navigate into the application's directory:
`cd micro-learning app`
- Install the gems required for the application:
`bundle`
- Ensure you have the following environment variables set:

       i. DATABASE_URL :- Set different URL for development and for testing.
 
       ii. API_KEY :- This is the News API key.
 
 - Create database:
 `rake db:create`
 - Make migrations:
 `rake db:migrate`
 - Start the application:
 `shotgun`
 - You can access the application on your browser using the port given after running `shotgun`.
 
 ### Running the test
 - Ensure the DATABASE_URL for test environment is given.
 - Create database for testing:
  `rake db:create`
  - Make migrations:
  `rake db:migrate`
 - Run:
 `rspec`
 
 ### Deployment
 This application is running on [Heroku](https://micro-learning-application-v2.herokuapp.com/)
 
 ### Built With
 - Sinatra
 - ActiveRecord
 - Postgres
 - News API
 - Brcypt
 - Rake
 - Sinatra-Flash
 
 ### Authors
 Betty Kebenei
 
 ### Acknowledgments
 [News API](https://newsapi.org/docs/client-libraries/ruby)
 


