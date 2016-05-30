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
 post this user :
{
  "email": "m.hosseinyzade@gmail.com",
  "password": "1234",
  "fullname": "Mahdieh",
  "weight": "53",
  "height": "167",
}
 -POST http://localhost:3100/login/{key} : user can login with email and password via payload and set Authorization: 'Your Token' in header.
