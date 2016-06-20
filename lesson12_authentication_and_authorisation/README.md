# Lesson 12 (add authentication and authorisation to blog)

## Requirements
- install gulp globally 
  $npm instal gulp -g

- install nodemon globally
  $npm instal nodemon -g

- database : couchbase , bucket name : lesson12

## Installation
- download all other packages
  $ npm install

download devDependencies package
- $npm install gulp-coffee --save-dev
- $ npm install gulp-util --save-dev
- $ npm install gulp-nodemon --save-dev

-in user and post directory(plugin) run : $npm link 
-in api run $npm link lesson12_authentication_and_authorisation.users
-in api run $npm link lesson12_authentication_and_authorisation.posts

##setup elasticsearch
add users config to elasticsearch.yml:

- couchbase.typeSelector: org.elasticsearch.transport.couchbase.capi.RegexTypeSelector
- couchbase.typeSelector.documentTypesRegex.users: ^u_[^:]+$
- couchbase.typeSelector.documentTypesRegex.posts: ^p_[^:]+:u_[^:]+$

## Run 
- start project automatically :
  $gulp start

-  build project in JS format:
  $ gulp build

## Features 
- see http://localhost:3100/docs (method: GET), for available routes



