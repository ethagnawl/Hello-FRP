module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    srcDir: "./src"
    outputDir: "./dist"

    # Compile to JS first, then we will compile the JSX in another task and move to /dist
    coffee:
      options:
        # This is IMPORTANT, because the first line has to be a JSX comment
        bare: true
      all:
        files: [
          expand: true
          cwd: 'src/'
          src: ['**/*.coffee']
          dest: 'src/'
          ext: '.js'
        ]

    react:
      single_file_output:
        files:
          './dist/app.js': './src/app.js'

    regarde:
      coffee:
        files: "<%= srcDir %>/**/*.coffee"
        tasks: ["coffee", "spawn_react"]

    # Set up a static file server
    connect:
      server:
        options:
          hostname: "0.0.0.0"
          port: 9292
          base: "."
          keepalive: true

    clean:
      js: ["src/**/*.js", "!src/**/*.coffee"]

    # Execute server script
    exec:
      server:
        cmd: "./server.js"

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-regarde"
  grunt.loadNpmTasks "grunt-contrib-connect"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-exec"
  grunt.loadNpmTasks 'grunt-react'

  # Make sure we get an error on compilation instead of a hang
  grunt.registerTask 'spawn_react', 'Run React in a subprocess', () ->
    done = this.async()
    grunt.util.spawn grunt: true, args: ['react'], opts: {stdio: 'inherit'}, (err) ->
      if err
        grunt.log.writeln(">> Error compiling React JSX file!")
      done()

  grunt.registerTask "server", ["exec:server"]
  grunt.registerTask "build", ["coffee", "spawn_react", "clean"]
