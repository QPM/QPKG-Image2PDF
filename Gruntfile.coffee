module.exports = (grunt) ->
  require("load-grunt-tasks") grunt

  appConfig =
    dev: "app"
    dist: "."

  # Project configuration.
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    app: appConfig
    # Put JavaScript
    coffee:
      options:
        bare: true
        sourceMap: true
        sourceRoot: ""
      dist:
        files: [
          expand: true
          cwd: "<%= app.dev %>/scripts"
          src: "{,*/}*.coffee"
          dest: "<%= app.dist %>/scripts"
          ext: ".js"
        ]
    # Put Jade
    jade:
      options:
        pretty: true
      dist:
        files: [
          expand: true
          cwd: "<%= app.dev %>"
          src: "{,*/}*.jade"
          dest: "<%= app.dist %>"
          ext: ".html"
        ]
    # Put Stylus
    stylus:
      options:
        compress: true
      dist:
        files: [
          expand: true
          cwd: "<%= app.dev %>/styles"
          src: "{,*/}*.styl"
          dest: "<%= app.dist %>/styles"
          ext: ".css"
        ]
    concurrent:
      dist: ["jade","coffee","stylus"]
    watch:
      files: ["**/*.jade", "**/*.coffee", "**/*.styl"]
      tasks: ["concurrent:dist"]

  grunt.registerTask "default", ["concurrent:dist", "watch"]