config = require '../config.js'
pjson = require('./package.json')

mailgun = require('mailgun-js')({apiKey: config.key, domain: config.domain})


data =
  from: 'Smart Raccoons <smart@raccoons.lv>'
  # to: "raccoobe@#{config.domain}"
  to: 'v@raccoons.lv'
  subject: 'Raccoobe - spēlīte'
  html: """Sveiks!
<br />
<br />
Mēs esam Smart Raccoons — tie, kas uztaisīja Zolīti ( <a href='http://zole.club'>zole.club</a> ).
<br />
<br />
Mēs taisām jaunu spēli — Raccoobe.<br />
Izmēģini svaigāko versiju adresē: <a href='http://raccoobe.raccoons.lv/?utm_source=email&utm_campaign=v.0.1.2'>raccoobe.raccoons.lv</a>
<br />
Šī spēle vēl nav gatavs variants, tikai prototips.
<br />
<br />
Būsim priecīgi dzirdēt Tavu viedokli. Ieteikumus vai uzlabojumus: droši atbildi uz šo e-pastu.
<br />
<br />
Pieseko mūsu lapai facebook: <a href='https://www.facebook.com/SmartRaccoons/'>www.facebook.com/SmartRaccoons</a>
<br />
<br />
<small>Ja nevēlies saņemt šāda tipa e-pastus, tad <a href='%mailing_list_unsubscribe_url%'>spied šeit</a></small>
   """
  'recipient-variables': '{}'
  "o:tag" : ['raccoobe', "v.#{pjson.version}"]
  # 'o:testmode': true

mailgun.messages().send data, (error, body) ->
  console.log error, body
  return
