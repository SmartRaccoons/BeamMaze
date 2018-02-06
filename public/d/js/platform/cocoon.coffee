
# game = new window.o.Game()
canvas = document.createElement('canvas')
document.body.appendChild(canvas)
canvas.screencanvas = true
engine = new BABYLON.Engine(canvas, true)
scene = new BABYLON.Scene(engine)
camera = new BABYLON.ArcRotateCamera('camera', 0, 0, 0, BABYLON.Vector3.Zero(), scene)
camera.setPosition(new BABYLON.Vector3(0, 20, -50))
new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-50, 50, -80), scene)
scene.clearColor = new BABYLON.Color4(255, 255, 0, 0)
# engine.runRenderLoop => scene.render()
engine.setSize(window.innerWidth, window.innerHeight)
mesh = BABYLON.MeshBuilder.CreateBox('asdf', {
  width: 10
  height: 10
  depth: 10
}, scene)
scene.render()

# console.info(window.devicePixelRatio)
# console.info(window.innerWidth)
# console.info(window.innerHeight)
# # game.canvas.width = 300
# # game.canvas.height = 400
# game.render({stage: 1, container: document.body})
# game.canvas.width = 300
# game.canvas.height = 400
# setTimeout =>
#   game._engine.resize()
# , 5000
# document.addEventListener 'deviceready', ->
#   console.info('device')
#   setTimeout ->
#     navigator.splashscreen.hide()
#     game = new window.o.Game()
#     game.render({stage: 1, container: document.body})
#     game.canvas.screencanvas = true
#     alert(window.devicePixelRatio)
#     alert(window.innerWidth)
#     alert(window.innerHeight)
#     game.canvas.width = window.innerWidth * window.devicePixelRatio
#     game.canvas.height = window.innerHeight * window.devicePixelRatio
#   , 5000, false
