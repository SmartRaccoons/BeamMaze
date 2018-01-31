fs = require('fs')
pjson = require('./package.json')
exec = require('child_process').exec
_ = require('lodash')
node_ssh = require('node-ssh')

module.exports = (grunt) ->
  grunt.loadNpmTasks('grunt-contrib-watch')
  coffee = [
    'public/d/js/*/*.coffee'
    'public/d/js/*.coffee'
    'public/d/locale/*.coffee'
    'public/d/*.coffee'
  ]
  coffee_command = "coffee -m -c"
  exec_callback = (error, stdout, stderr)->
    if error
      console.log('exec error: ' + error)

  grunt.registerTask 'termi', ->
    done = @async()
    ssh = new node_ssh()
    ssh.connect({
      host: 'termi.lv'
      username: 'piisiitiis'
      privateKey: '/Users/bambis/.ssh/id_rsa'
    })
    .then =>
      ssh.execCommand('git pull', { cwd:'/www/raccoobe/master/' }).then (result)->
        if result.stdout
          console.log(result.stdout)
        if result.stderr
          console.log('STDERR: ' + result.stderr)
        done()
    .catch =>
      console.info arguments
      done()

  grunt.registerTask 'compile', ->
    rf = (name)-> fs.readFileSync("#{__dirname}/template/#{name}.html", 'utf8')
    wf = (name, html)-> fs.writeFileSync("#{__dirname}/public/#{name}.html", html)
    template = _.template rf('index'), {imports: {
      loading: rf('loading')
      version: pjson.version
      name: pjson.name
    }}
    ['dev', 'index', 'draugiem', 'offline'].forEach (f)-> wf(f, template({platform: f}))

    for file in coffee
      exec("#{coffee_command} #{file}", exec_callback)

  grunt.registerTask 'version', ->
    dir = __dirname + '/public/v/' + pjson.version
    if !fs.existsSync(dir)
      fs.mkdirSync(dir)
      fs.mkdirSync("#{dir}/d")
      fs.mkdirSync("#{dir}/d/css")
      fs.mkdirSync("#{dir}/d/images")
      fs.mkdirSync("#{dir}/d/sound")
    exec "cp -r public/d/font/ #{dir}/d/font/"
    exec "find public/d/images -maxdepth 1 -type f -exec cp {} #{dir}/d/images/ \\;"
    exec "cp -r public/stage/ #{dir}/stage/"
    exec "cp -r public/d/sound/ #{dir}/d/sound/"
    ['index.html',
      'offline.html',
      'd/j.js',
      'd/j-offline.js',
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
