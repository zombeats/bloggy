# -- Dependencies --------------------------------------------------------------

gulp        = require 'gulp'
gutil       = require 'gulp-util'
sass        = require 'gulp-sass'
concat      = require 'gulp-concat'
coffee      = require 'gulp-coffee'
header      = require 'gulp-header'
uglify      = require 'gulp-uglify'
cssmin      = require 'gulp-cssmin'
addsrc      = require 'gulp-add-src'
changed     = require 'gulp-changed'
shorthand    = require 'gulp-shorthand'
pkg         = require './package.json'
_s          = require 'underscore.string'
prefix      = require 'gulp-autoprefixer'
strip       = require 'gulp-strip-css-comments'
browserSync = require 'browser-sync'
reload      = browserSync.reload

CONST =
  DEFAULT_LANG : 'en_US'
  SUPPORTED_LANGS : [ 'en_ES' ]
  PORT:
    GHOST: 2368
    BROWSERSYNC: 3000

# -- Files ---------------------------------------------------------------------

dist =
  name     : _s.slugify(pkg.name)
  css      : 'assets/css'
  js       : 'assets/js'

src =
  sass:
    main   : 'assets/scss/bloggy.scss'
    files  : ['assets/scss/**/**']

  js       :
    i18n   :
      main : 'assets/js/src/i18n/index.coffee'
      languages :
        path: 'assets/js/src/i18n'

    main   : [ 'assets/js/src/__init.coffee'
               'assets/js/src/main.coffee' ]
    vendor : ['assets/js/src/application.js'
              'assets/js/src/jquery.smartresize.js'
              'assets/js/src/prism.js'
              'assets/vendor/fitvids/jquery.fitvids.js'
              'assets/vendor/fastclick/lib/fastclick.js']
  css      :
    main   : 'assets/css/' + dist.name + '.css'
    vendor : []

banner = [ "/**"
           " * <%= pkg.name %> - <%= pkg.description %>"
           " * @version <%= pkg.version %>"
           " * @link    <%= pkg.homepage %>"
           " * @author  <%= pkg.author.name %> (<%= pkg.author.url %>)"
           " * @license <%= pkg.license %>"
           " */"
           "" ].join("\n")

gulp.task 'css', ->
  gulp.src src.css.vendor
  .pipe changed dist.css
  .pipe addsrc src.sass.main
  .pipe sass().on "error", gutil.log
  .pipe concat dist.name + '.css'
  .pipe prefix()
  .pipe strip all: true
  .pipe shorthand()
  .pipe cssmin()
  .pipe header banner, pkg: pkg
  .pipe gulp.dest dist.css
  return

gulp.task 'js i18n', ->
  CONST.SUPPORTED_LANGS.forEach (lang) ->
    gulp.src src.js.main
    .pipe addsrc "#{src.js.i18n.languages.path}/index.coffee"
    .pipe addsrc "#{src.js.i18n.languages.path}/#{lang}.coffee"
    .pipe changed dist.js
    .pipe coffee().on 'error', gutil.log
    .pipe addsrc src.js.vendor
    .pipe concat dist.name + ".#{lang}.js"
    .pipe uglify()
    .pipe header banner, pkg: pkg
    .pipe gulp.dest dist.js
    return

gulp.task 'js default', ->
  gulp.src src.js.main
  .pipe changed dist.js
  .pipe coffee().on 'error', gutil.log
  .pipe addsrc src.js.vendor
  .pipe concat dist.name + ".#{CONST.DEFAULT_LANG}.js"
  .pipe uglify()
  .pipe header banner, pkg: pkg
  .pipe gulp.dest dist.js
  return

gulp.task 'server', ->
  browserSync.init null,
    proxy: "http://127.0.0.1:#{CONST.PORT.GHOST}"
    files: ["assets/**/*.*"]
    reloadDelay: 300
    port: CONST.PORT.BROWSERSYNC
  return

gulp.task 'build', ['css', 'js']
gulp.task 'js', ['js default', 'js i18n']

gulp.task 'watch', -> gulp.watch 'assets/js/src/i18n/**/*', ['js']

gulp.task "default", ->
  gulp.start ["build", "watch", "server"]
  gulp.watch src.sass.files, ["css"]
  gulp.watch src.js.main, ["js"]
  gulp.watch src.js.vendor, ["js"]
