config = require '../config.js'
pjson = require('../package.json')

mailgun = require('mailgun-js')({apiKey: config.key, domain: config.domain})

mailgun.validate 'smart@raccoons.lv', (error, body)->
  console.info(error, body)
