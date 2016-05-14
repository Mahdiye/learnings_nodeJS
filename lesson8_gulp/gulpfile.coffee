gulp = require 'gulp'
coffee = require 'gulp-coffee'
gutil = require 'gulp-util'
nodemon = require 'gulp-nodemon'

gulp.task 'start', ->
  nodemon({
    script: 'src/methods.coffee'
  })

gulp.task 'build', ->
  return gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./build'))
