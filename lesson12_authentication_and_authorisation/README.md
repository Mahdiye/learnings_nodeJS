# Lesson 12 (add authentication and authorisation to blog)

## Requirements
- install gulp globally 
  $npm instal gulp -g

- install nodemon globally
  $npm instal nodemon -g
- database : couchbase

## Installation
- download all other packages
  $ npm install

download devDependencies package
- $npm install gulp-coffee --save-dev
- $ npm install gulp-util --save-dev
- $ npm install gulp-nodemon --save-dev

-in user directory run : $npm link 
-in api run $npm link lesson12_authentication_and_authorisation.users

## Run 
- create a bucket in couchbase named "lesson12"

- start project automatically :
  $gulp start

-  build project in JS format:
  $ gulp build

## Features 
- see http://localhost:3100/docs (method: GET), for available routes



