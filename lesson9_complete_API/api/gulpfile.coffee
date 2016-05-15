gulp = require 'gulp'
coffee = require 'gulp-coffee' 
gutil = require 'gulp-util'
nodemon = require 'gulp-nodemon'

gulp.task 'start', -> 
  nodemon
    script: './src/server.coffee'
    ext: 'js coffee jade'
    env: { 'NODE_ENV': 'development' }
    watch: ["./src/*", "*/"]
    ignore: ["node_module"]

gulp.task 'build', ->
  gulp.src(['./src/*', '../*', '!node_modules'])
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build'))
