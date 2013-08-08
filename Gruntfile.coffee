"use strict"

lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
  grunt.loadNpmTasks 'rosetta'
  #grunt.loadTasks 'node_modules/rosetta/tasks'

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"

  try
    yeomanConfig.app = require("./component.json").appPath or yeomanConfig.app

# grunt.initConfig({
#   less: {
#     signup: {
#       src: 'signup.less',
#       dest: 'signup.css'
#     },
#     homepage: {
#       src: ['banner.less', 'app.less'],
#       dest: 'homepage.css',
#       options: {
#         yuicompress: true
#       }
#     },
#     all: {
#       src: '*.less',
#       dest: 'all.css',
#       options: {
#         compress: true
#       }
#     }
#   }
#});

  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:server"]

      coffeeTest:
        files: ["test/spec/{,*/}*.coffee"]
        tasks: ["coffee:test"]

      rosetta:
        files: ["<%= yeoman.app %>/styles/{,*/}*.rose"]
        tasks: ["rosetta", "less", "compass:server"]

      less:
        files: ["<%= yeoman.app %>/styles/{,*/}*.less"]
        tasks: ["less"]

      compass:
        files: ["<%= yeoman.app %>/styles/{,*/}*.{scss,sass}"]
        tasks: ["compass:server"]

      jade:
        files: ["<%= yeoman.app %>/{,*/}*.jade"]
        tasks: ["jade:server"]

      livereload:
        files: [".tmp/{,*/}*.html", "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css", "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]
        tasks: ["livereload"]

    connect:
      options:
        port: 9000

        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder connect, "./"  # So we can access the CoffeeScript files referenced in the source maps
              mountFolder connect, ".tmp"
              mountFolder connect, yeomanConfig.app
            ]

      test:
        options:
          middleware: (connect) ->
            [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]

    open:
      server:
        url: "http://localhost:<%= connect.options.port %>"

    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: ".tmp"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js"]

    karma:
      options:
        configFile: "test/karma.conf.js"
      unit: {}
      unitwatch:
        autoWatch: true
        singleRun: false
      jenkins:
        singleRun: true  # already defined in karma.conf.js, but since this target is likely to be used in a script, let's make sure.
        reporters: ["dots", "junit"]
        junitReporter:
          outputFile: "test/test-results.xml"
      e2e:
        configFile: "test/karma-e2e.conf.js"
        autoWatch: true
        singleRun: false
        proxies:
          "/": "http://<%= connect.options.hostname %>:<%= connect.options.port %>/"

    coffee:
      server:
        options:
          sourceMap: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
          ext: ".js"
        ]
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: "<%= yeoman.dist %>/scripts"
          ext: ".js"
        ]
      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.coffee"
          dest: ".tmp/spec"
          ext: ".js"
        ]

    rosetta:
      less:
        src: ["<%= yeoman.app %>/styles/{,*/}*.rose"]
        options:
          cssFormat: 'less'
          cssOut: ".tmp/styles/rosetta.less"
          jsFormat: 'requirejs'
          jsOut: ".tmp/scripts/rosetta.js"
      sass:
        src: ["<%= yeoman.app %>/styles/{,*/}*.rose"]
        options:
          cssFormat: 'sass'
          #cssOut: ".tmp/styles/{{ns}}.sass" # filename from namespace
          cssOut: ".tmp/styles/rosetta.sass"
          jsFormat: 'requirejs'
          jsOut: ".tmp/scripts/rosetta.js"

    less:
      dist:
        options:
          paths: ["<%= yeoman.app %>/components", ".tmp/styles", "<%= yeoman.app %>/styles"]
          yuicompress: true
        files:
          # HACK: Name the output .scss to force SASS to embed it
          ".tmp/styles/less.scss": "<%= yeoman.app %>/styles/{,*/}*.less"

    compass:
      options:
        sassDir: "<%= yeoman.app %>/styles"
        cssDir: ".tmp/styles"
        imagesDir: "<%= yeoman.app %>/images"
        javascriptsDir: "<%= yeoman.app %>/scripts"
        fontsDir: "<%= yeoman.app %>/styles/fonts"
        importPath: ["<%= yeoman.app %>/components", ".tmp/styles"]
        relativeAssets: true

      dist:
        options:
          debugInfo: false
          outputStyle: "compressed"
          noLineComments: true
      server:
        options:
          debugInfo: true

    jade:
      dist:
        options:
          pretty: true
          data:
            debug: false
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/"
          src: ['**/*.jade']
          dest: "<%= yeoman.dist %>"
          ext: ".html"
        ]
      server:
        options:
          pretty: true
          compileDebug: true
          data:
            debug: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/"
          src: ['**/*.jade']
          dest: ".tmp/"
          ext: ".html"
        ]

    concat:
      dist:
        files:
          "<%= yeoman.dist %>/scripts/scripts.js": [".tmp/scripts/{,*/}*.js", "<%= yeoman.app %>/scripts/{,*/}*.js"]

    useminPrepare:
      html: "<%= yeoman.dist %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]
        #basedir: "styles"

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>/styles/main.css": [".tmp/styles/{,*/}*.css", "<%= yeoman.app %>/styles/{,*/}*.css"]

    htmlmin:
      dist:
        options: {}
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          #cwd: "./tmp"
          src: ["*.html", "views/*.html"]
          dest: "<%= yeoman.dist %>"
        ]
      # In separate target due to https://github.com/yeoman/grunt-usemin/issues/44
      deploy:
        options:
          removeCommentsFromCDATA: true
          # https://github.com/yeoman/grunt-usemin/issues/44
          collapseWhitespace: true
          collapseBooleanAttributes: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          #removeEmptyAttributes: true
          #removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: "{,*/}*.html"
          dest: "<%= yeoman.dist %>"
        ]



    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]

    ngmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/scripts"
          src: "*.js"
          dest: "<%= yeoman.dist %>/scripts"
        ]

    uglify:
      dist:
        files:
          "<%= yeoman.dist %>/scripts/scripts.js": ["<%= yeoman.dist %>/scripts/scripts.js"]

    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}", "<%= yeoman.dist %>/styles/fonts/*"]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,txt}", ".htaccess", "components/**/*", "images/{,*/}*.{gif,webp}"]
        ]

  grunt.renameTask "regarde", "watch"

  # Build steps
  grunt.registerTask "build:server"  , ["coffee:server", "rosetta:less", "rosetta:sass", "less", "compass:server", "jade:server"]
  grunt.registerTask "build:dist"    , ["coffee:dist"  , "rosetta:less", "rosetta:sass", "less", "compass:dist"  , "jade:dist"  ]
  grunt.registerTask "build:optimise", ["useminPrepare", "imagemin", "cssmin", "htmlmin:dist", "concat", "copy", "cdnify", "ngmin", "uglify", "rev", "usemin", "htmlmin:deploy"]

  # Livereload server shortcut
  grunt.registerTask "init-livereload", ["livereload-start", "connect:livereload"]

  # Temp server
  grunt.registerTask "server", ["clean:server", "build:server", "init-livereload", "open", "watch"]

  # Build
  grunt.registerTask "build", ["clean:dist", "jshint", "test", "build:dist", "build:optimise"]


  # Testing
  grunt.registerTask "test"        , ["clean:server", "build:server", "connect:test", "karma:unit"]
  grunt.registerTask "test:watch"  , ["clean:server", "build:server", "connect:test", "karma:unit"]
  grunt.registerTask "test:jenkins", ["clean:server", "build:server", "connect:test", "karma:unit"]

  grunt.registerTask "test:e2e"    , ["clean:server", "build:server", "init-livereload", "karma:e2e"]


  # grunt.registerTask "server:build", ["clean:server", "coffee:server", "rosetta", "less", "compass:server", "jade:server", "livereload-start", "connect:livereload"]
  # grunt.registerTask "server:serve", ["clean:server", "coffee:server", "rosetta", "less", "compass:server", "jade:server", "livereload-start", "connect:livereload"]
  # grunt.registerTask "server"      , ["clean:server", "coffee:server", "rosetta", "less", "compass:server", "jade:server", "livereload-start", "connect:livereload", "open", "watch"]
  # grunt.registerTask "test:build", ["clean:server", "coffee", "rosetta", "less", "compass"]
  # grunt.registerTask "test"        , ["test:build", "connect:test", "karma:unit"]
  # grunt.registerTask "test:watch"  , ["test:build", "connect:test", "karma:unitwatch"]
  # grunt.registerTask "test:jenkins", ["test:build", "connect:test", "karma:jenkins"]
  # grunt.registerTask "test:e2e"    , ["test:build", "livereload-start", "connect:livereload", "watch"]#", karma:e2e"]
  # grunt.registerTask "build", [
  #   # Init
  #   "clean:dist", "jshint", "test"
  #   # JS Compilation
  #   "coffee:dist"
  #   # CSS Compilation
  #   "less", "compass:dist"
  #   # HTML Compilation
  #   "jade:dist"
  #   # Optimisation
  #   "useminPrepare", "imagemin", "cssmin", "htmlmin:dist", "concat", "copy", "cdnify", "ngmin", "uglify", "rev", "usemin", "htmlmin:deploy"
  # ]
  grunt.registerTask "default", ["build"]
