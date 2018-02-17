fs = require('fs')
pjson = require('../package.json')
exec = require('child_process').exec
_ = require('lodash')

javascripts = {
  all: [
    "bower_components/three.js/build/three.js"
    # "bower_components/THREE.GUI/button.js"
    # "bower_components/THREE.GUI/droid_sans_regular.typeface.js"
    "bower_components/lodash/lodash.js"
    "public/d/js/init.js"
    # "public/d/js/font.js"
    "public/d/locale/en.js"
    "public/d/locale/lv.js"
    "public/d/js/object/animation.js"
    "public/d/js/object/object.js"
    "public/d/js/object/data.js"
    "public/d/js/object/blank.js"
    "public/d/js/object/beam.js"
    "public/d/js/object/mirror.js"
    "public/d/js/game/map.js"
    "public/d/js/game/map.data.js"
    "public/d/js/game/game.js"
    "public/d/js/game/camera.js"
    "public/d/js/router.js"
  ],
  dev: [
    "bower_components/three.js/examples/js/controls/OrbitControls.js"
    "public/d/js/debug.js"
  ]
  master: []
  index: []
  cocoon: ["public/d/js/platform/cocoon.js"]
}
js_get = (platform, dev=false)->
  js = javascripts.all.concat(javascripts[if dev then 'dev' else 'master'])
  if platform
    js = js.concat(javascripts[platform])
  return js

module.exports.js_get = js_get
module.exports.generate = (params, write=false)->
  rf = (name)-> fs.readFileSync("#{__dirname}/#{name}.html", 'utf8')
  wf = (name, html)-> fs.writeFileSync("#{__dirname}/../public/#{name}.html", html)
  str = _.template(rf('index'))({
    version: pjson.version
    name: pjson.name
    dev: params.dev
    platform: params.platform
    javascripts: js_get(params.js, params.dev)
  })
  if write
    wf(write, str)
  else
    return str
