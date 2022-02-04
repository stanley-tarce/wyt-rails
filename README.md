

# WYT

"WYT-Rails" is a Yahoo Fantasy Sports Tool Helper for all the users that wants to ask for an opinion about their current trade. Currently people send it to their friends by screenshot. One problem here is that the stats can differ day by day and it can be hard to track all the comments and opinions about the trade if they're going to search for it in their chat boxes. Our app solves it by creating a mock trade on our website and the users can send the link to their friends, and non-users can judge and share their opinions. Technically, only users with Yahoo Fantasy Teams on NBA are eligible to use most of the features.
### Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

Clone the repository inside your local directory and change your directory to the root of the file

```
git clone https://github.com/stanley-tarce/wyt-rails.git
```
```
cd wyt-rails
```
### Prerequisites
Make sure to have Ruby, Rails, NodeJs, Postgresql, and Yarn installed. The versions I used are as listed: 

    Rails 6.1.4.4
    ruby-3.0.2
    node v17.0.1
    yarn 1.22.17
    psql (PostgreSQL) 14.1 
  ### Installing
To get the API running, run the following command  

    bundle install 
Enable alternate role on Postgresql

    sudo -u postgres psql 
 Type this in the postresql console
 

    ALTER USER postgres WITH PASSWORD 'postgres;
    

Setup the database by running this command

    rails db:setup

Or you can run this

    rails db:create db:migrate 

For the authentication to work, you could create your own secret key by running this command on your terminal and save it to your .env file

    rails secret
    touch .env 
On your .env file, add the following line:

    DEVISE_JWT_SECRET_KEY=<"YOUR_SECRET_KEY_FROM_RAILS_SECRET">

 To check the routes use this command
 

    rails routes 
### Server 
Enable the server by running this command 

    rails s 
or you could run on a different server  

    rails s -p <YOUR_CUSTOM_SERVER> *example 3001

### RSpec Test
To run the test, simply do the following: 

    rails db:migrate RAILS_ENV=test
    rspec spec
I only checked the validity and the request endpoints for the tests since it's an api only application. 


        it 'is expected to create a new user without issues'  do
    
    expect(response).to  have_http_status(:success)
    
    end
    
      
    
    it 'is expected to have a message inside the body'  do
    
    (expect(response.body.include?('User Successfully Created')).to be true)
    
    end
    
      
    
    it 'is expected to login a user without issues'  do
    
    post '/login', params: sign_up[:user].except(:password_confirmation)
    
    expect(response).to  have_http_status(:success)
    
    end
    

