# Lesson 11 ( learn jwt based authentication)

## Requirements
- install gulp globally 
  $npm instal gulp -g

- install nodemon globally
  $npm instal nodemon -g
- database : couchbase

## Installation
- download all packages
  $ npm install

## Run 
- first : $cp secret.coffee.origin secret.coffee , and you can have your own secret key and also create a bucket in couchbase named "lesson11"
- start project automatically
  $gulp start

-  build project in JS format
  $ gulp build

## Features 
 -POST http://localhost:3100/signup : User can register with their email, password, fullname, dob, weight and height.

 -POST http://localhost:3100/login/{key} : user can login with email and password via payload and set Authorization: 'Your Token' in header.

 -GET localhost:3100/me : will bring detail of user ,  and set Authorization: 'Your Token' in header.

 -GET localhost:3100/feed: User can call GET /feed without being logged in which will return [ { card: ‘menu’ }, { card: ‘login’ } ]. For logged in user it should return [ { card: ‘menu’ }, { card: ‘profile’, name: current_logged_in_users_name } ]. (e.g. { card: ‘profile’, name: ‘Arash Kay’ } ] )

