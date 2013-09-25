# Generated on 2013-09-17 using generator-angular 0.4.0
"use strict"
LIVERELOAD_PORT = 35729
lrSnippet = require("connect-livereload")(port: LIVERELOAD_PORT)
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to recursively match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->
  require("load-grunt-tasks") grunt
  require("time-grunt") grunt
  
  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"

  try
    yeomanConfig.app = require("./bower.json").appPath or yeomanConfig.app
  grunt.initConfig
    yeoman: yeomanConfig
    watch:
      jade:
        files: ["<%= yeoman.app %>/{,*/}*.jade"]
        tasks: ["jade:dist"]
      coffee:
        files: ["<%= yeoman.app %>/scripts/{,*/}*.coffee"]
        tasks: ["coffee:dist"]
      stylus:
        files: ["<%= yeoman.app %>/styles/{,*/}*.styl"]
        tasks: ["stylus:dist"]
      livereload:
        options:
          livereload: LIVERELOAD_PORT
        files: [
          "<%= yeoman.app %>/{,*/}*.jade",
          "<%= yeoman.app %>/styles/{,*/}*.styl",
          "<%= yeoman.app %>/scripts/{,*/}*.coffee",
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
    connect:
      options:
        port: 9000
        # Change this to '0.0.0.0' to access the server from outside.
        hostname: "localhost"
      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, yeomanConfig.app)]
      test:
        options:
          middleware: (connect) ->
            [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]
      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, yeomanConfig.dist)]
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
    ###
      $$$$$$$\              $$\           $$$$$$$$\ $$\ $$\                     
      $$  __$$\             $$ |          $$  _____|\__|$$ |                    
      $$ |  $$ |$$\   $$\ $$$$$$\         $$ |      $$\ $$ | $$$$$$\   $$$$$$$\ 
      $$$$$$$  |$$ |  $$ |\_$$  _|        $$$$$\    $$ |$$ |$$  __$$\ $$  _____|
      $$  ____/ $$ |  $$ |  $$ |          $$  __|   $$ |$$ |$$$$$$$$ |\$$$$$$\  
      $$ |      $$ |  $$ |  $$ |$$\       $$ |      $$ |$$ |$$   ____| \____$$\ 
      $$ |      \$$$$$$  |  \$$$$  |      $$ |      $$ |$$ |\$$$$$$$\ $$$$$$$  |
      \__|       \______/    \____/       \__|      \__|\__| \_______|\_______/ 
    ###
    # Put JavaScript
    coffee:
      options:
        bare: true
        sourceMap: true
        sourceRoot: ""
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/scripts"
          src: "{,*/}*.coffee"
          dest: ".tmp/scripts"
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
    # Put Jade
    jade:
      options:
        pretty: true
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "{,*/}*.jade"
          dest: ".tmp"
          ext: ".html"
        ]
      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "{,*/}*.jade"
          dest: ".tmp/spec"
          ext: ".html"
        ]
    # Put Stylus
    stylus:
      options:
        compress: true
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/styles"
          src: "{,*/}*.styl"
          dest: ".tmp/styles"
          ext: ".css"
        ]
      test:
        files: [
          expand: true
          cwd: "test/spec"
          src: "/styles/{,*/}*.styl"
          dest: "<%= yeoman.dist %>"
          ext: ".css"
        ]
    # Put Image
    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]
    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]
    # Put Other Files
    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,png,txt}", ".htaccess", "bower_components/**/*", "images/{,*/}*.{gif,webp}", "styles/fonts/*"]
        ,
          expand: true
          cwd: ".tmp"
          dest: "<%= yeoman.dist %>"
          src: ["{,*/}*"]
        ]
    htmlmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>"
          src: ["*.html", "views/*.html"]
          dest: "<%= yeoman.dist %>"
        ]
    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}", "<%= yeoman.dist %>/styles/fonts/*"]
    useminPrepare:
      html: "<%= yeoman.dist %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"
    karma:
      unit:
        configFile: "karma.conf.js"
        singleRun: true
    # Use Min
    ngmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.dist %>/scripts"
          src: "*.js"
          dest: "<%= yeoman.dist %>/scripts"
        ]
    cdnify:
      dist:
        html: ["<%= yeoman.dist %>/*.html"]
    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]
    uglify:
      dist:
        files:
          "<%= yeoman.dist %>/scripts/scripts.js": ["<%= yeoman.dist %>/scripts/scripts.js"]
    concurrent:
      server: ["jade:dist","coffee:dist","stylus:dist"]
      test: ["coffee"]
      dist: ["jade:dist", "coffee:dist", "imagemin", "svgmin"]
      dist_min: ["ngmin","cssmin","usemin"]

  grunt.registerTask "server", (target) ->
    return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:server", "concurrent:server", "connect:livereload", "open", "watch"]

  grunt.registerTask "test", ["clean:server", "concurrent:test", "connect:test", "karma"]
  grunt.registerTask "default", ["clean:dist", "concurrent:dist", "copy:dist", "useminPrepare", "concat", "cdnify", "ngmin", "cssmin", "uglify", "rev", "usemin"]
