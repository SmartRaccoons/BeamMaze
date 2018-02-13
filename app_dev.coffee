express = require('express')
pjson = require('./package.json')
template = require('./template/generate')

port = 8111
app = express()
app.listen(port)
app.get '/', (req, res)->
  res.send template.generate({dev: true, js: req.query.js})

app.use('/public', express.static(__dirname + '/public'))
app.use('/bower_components', express.static(__dirname + '/bower_components'))

console.info 'http://localhost:' + port
