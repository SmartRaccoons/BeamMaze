config = require '../config.js'

mailgun = require('mailgun-js')({apiKey: config.key, domain: config.domain})

mailgun.get "/#{config.domain}/unsubscribes", (error, body)=>
  console.info body
