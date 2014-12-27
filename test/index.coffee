assert = require 'power-assert'
publish = require '../src/index.coffee'
gutil = require 'gulp-util'
fs = require 'fs'

it 'should write article to collect dir', (callback)->
  article =
    body: '<h1>title</h1><p>article</p>'
    date:
      year: '2014'
      month: '12'
      day: '27'
    url: 'test'
  stream = publish 'test/output'

  stream.once 'data', (file)-> fs.readFile 'test/output/2014/12/27/test.html', (err, file)->
    assert.equal file.toString(), '<h1>title</h1><p>article</p>'
    callback()

  stream.write new gutil.File
    contents: new Buffer JSON.stringify article
