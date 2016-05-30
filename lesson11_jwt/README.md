# Lesson 11 ( learn jwt based authentication)

## Requirements
- install gulp globally 
  $npm instal gulp -g

- install nodemon globally
  $npm instal nodemon -g

## Installation
- download all packages
  $ npm install

## Run 
- first : $cp secret.coffee.origin secret.coffee , and you can have your own secret key
- start project automatically
  $gulp start

-  build project in JS format
  $ gulp build

## Features 
 -POST http://localhost:3100/signup : User can register with their email, password, fullname, dob, weight and height.
 -POST http://localhost:3100/login/{key} : Each user can with email and password
