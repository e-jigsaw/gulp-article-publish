(function() {
  var fs, gutil, mkdir, path, through;

  gutil = require('gulp-util');

  through = require('through2');

  fs = require('fs');

  path = require('path');

  mkdir = require('mkdirp');

  module.exports = function(dist) {
    var flush, transform;
    transform = function(file, encoding, callback) {
      var contents, day, dirpath, month, year, _ref;
      if (dist == null) {
        dist = 'dist';
      }
      if (file.isNull()) {
        return callback(null, file);
      }
      if (file.isStream()) {
        return callback(new gutil.PluginError('gulp-article-publish', 'Stream not supported'));
      }
      contents = JSON.parse(file.contents.toString());
      if ((contents.body == null) || (contents.date.year == null) || (contents.date.month == null) || (contents.date.day == null) || (contents.url == null)) {
        return callback(new gutil.PluginError('gulp-article-publish', 'Contents is not article format'));
      }
      _ref = contents.date, year = _ref.year, month = _ref.month, day = _ref.day;
      dirpath = path.resolve(process.cwd(), dist, "" + year + "/" + month + "/" + day);
      mkdir.sync(dirpath);
      return fs.writeFile("" + dirpath + "/" + contents.url + ".html", contents.body, function(err) {
        if (err != null) {
          return callback(new gutil.PluginError('gulp-article-publish', 'File write failed'));
        }
        return callback(null, file);
      });
    };
    flush = function(callback) {};
    return through.obj(transform, flush);
  };

}).call(this);
