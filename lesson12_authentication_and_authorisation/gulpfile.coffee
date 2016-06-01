gulp = require 'gulp'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
nodemon = require 'gulp-nodemon'

gulp.task 'start', ->
  nodemon({
    script: './src/server.coffee'
  })

gulp.task 'build', ->
  return gulp.src('./src/*')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build'))
