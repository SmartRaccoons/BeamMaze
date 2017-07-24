fs = require('fs')
pjson = require('./package.json')
exec = require('child_process').exec

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-watch')
  coffee = [
    'public/d/js/*/*.coffee'
    'public/d/js/*.coffee'
    'public/d/locale/*.coffee'
  ]
  coffee_command = "coffee -m -c"
  exec_callback = (error, stdout, stderr)->
    if error
      console.log('exec error: ' + error)

  grunt.registerTask 'compile', ->
    html = fs.readFileSync(__dirname + '/public/index.html', 'utf8')
    [
      [/(\d+\.\d+\.\d+)/g, pjson.version]
      [/<title>(.+)<\/title>/, "<title>#{pjson.name}</title>"]
    ].forEach (params)->
      html = html.replace(params[0], params[1])
    fs.writeFileSync(__dirname + '/public/index.html', html)

    for file in coffee
      exec("#{coffee_command} #{file}", exec_callback)

  grunt.registerTask 'version', ->
    dir = __dirname + '/public/v/' + pjson.version
    if !fs.existsSync(dir)
      fs.mkdirSync(dir)
      fs.mkdirSync("#{dir}/d")
      fs.mkdirSync("#{dir}/d/css")
      fs.mkdirSync("#{dir}/d/images")
    exec "cp -r public/d/font/ #{dir}/d/font/"
    exec "find public/d/images -maxdepth 1 -type f -exec cp {} #{dir}/d/images/ \\;"
    exec "cp -r public/stage/ #{dir}/stage/"
    ['index.html',
      'd/j.js',
      'd/css/c.css'
    ].forEach (f)->
      exec "cp public/#{f} #{dir}/#{f}"

  grunt.initConfig
    watch:
      coffee:
        files: coffee
      sass:
        files: ['public/d/sass/screen.sass']
      static:
        files: ['public/d/**/*.css',
          'public/**/*.html',
          'public/**/*.js'],
        options:
          livereload: true
    compile:
      coffee:
        files: coffee

  grunt.event.on 'watch', (event, file, ext)->
    if ext == 'coffee'
#      console.info("compiling: #{file}")
      exec("#{coffee_command} #{file}", exec_callback)
    if ext == 'sass'
#      console.info("compiling: #{file}")
      exec("cd public/d && compass compile --sourcemap sass/screen.sass", exec_callback)

  grunt.registerTask('default', ['watch'])
