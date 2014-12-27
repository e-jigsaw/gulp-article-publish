gutil = require 'gulp-util'
through = require 'through2'
fs = require 'fs'
path = require 'path'
mkdir = require 'mkdirp'

module.exports = (dist)->
  transform = (file, encoding, callback)->
    if !dist? then dist = 'dist'
    if file.isNull() then return callback null, file
    if file.isStream() then return callback new gutil.PluginError('gulp-article-publish', 'Stream not supported')

    contents = JSON.parse file.contents.toString()
    if !contents.body? or !contents.date.year? or !contents.date.month? or !contents.date.day? or !contents.url? then return callback new gutil.PluginError('gulp-article-publish', 'Contents is not article format')
    {year, month, day} = contents.date
    dirpath = path.resolve process.cwd(), dist, "#{year}/#{month}/#{day}"
    mkdir.sync dirpath
    fs.writeFile "#{dirpath}/#{contents.url}.html", contents.body, (err)->
      if err? then return callback new gutil.PluginError('gulp-article-publish', 'File write failed')
      callback null, file

  flush = (callback)->

  through.obj transform, flush
