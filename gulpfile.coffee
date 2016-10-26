# -- Dependencies --------------------------------------------------------------

gulp        = require 'gulp'
gulpif      = require 'gulp-if'
gutil       = require 'gulp-util'
sass        = require 'gulp-sass'
concat      = require 'gulp-concat'
coffee      = require 'gulp-coffee'
header      = require 'gulp-header'
uglify      = require 'gulp-uglify'
cssnano     = require 'gulp-cssnano'
addsrc      = require 'gulp-add-src'
changed     = require 'gulp-changed'
pkg         = require './package.json'
_s          = require 'underscore.string'
prefix      = require 'gulp-autoprefixer'
strip       = require 'gulp-strip-css-comments'
browserSync = require 'browser-sync'
reload      = browserSync.reload

isProduction = process.env.NODE_ENV is 'production'

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
  .pipe sass().on('error', sass.logError)
  .pipe concat dist.name + '.css'
  .pipe gulpif(isProduction, prefix())
  .pipe gulpif(isProduction, strip all: true)
  .pipe gulpif(isProduction, cssnano())
  .pipe gulpif(isProduction, header banner, pkg: pkg)
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
    .pipe gulpif(isProduction, uglify())
    .pipe gulpif(isProduction, header banner, pkg: pkg)
    .pipe gulp.dest dist.js
    return

gulp.task 'js default', ->
  gulp.src src.js.main
  .pipe changed dist.js
  .pipe coffee().on 'error', gutil.log
  .pipe addsrc src.js.vendor
  .pipe concat dist.name + ".#{CONST.DEFAULT_LANG}.js"
  .pipe gulpif(isProduction, uglify())
  .pipe gulpif(isProduction, header banner, pkg: pkg)
  .pipe gulp.dest dist.js
  return

gulp.task 'server', ->
  browserSync.init null,
    proxy: "http://127.0.0.1:#{CONST.PORT.GHOST}"
    files: ["assets/**/*.*",
            "*.hbs",
            "partials/**/*.hbs"]
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
