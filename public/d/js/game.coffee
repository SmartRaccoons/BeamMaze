

class Game
  render: ->
    canvas = document.createElement('canvas')
    document.body.appendChild(canvas)
    engine = new BABYLON.Engine(canvas, true)
    engine.runRenderLoop ->
      scene.render()
    window.addEventListener 'resize', ->
      engine.resize()

    scene = new BABYLON.Scene(engine)
    camera = new BABYLON.FreeCamera('camera', new BABYLON.Vector3(0, 100,0), scene)
    camera.setTarget(BABYLON.Vector3.Zero())

    BABYLON.Mesh.CreateLines("itsName", [
      new BABYLON.Vector3(-5, 0, 5),
      new BABYLON.Vector3(5, 0, 5),
      new BABYLON.Vector3(0, 0, -5)
    ], scene)

#    sphere = BABYLON.Mesh.CreateSphere('sphere1', 16, 2, scene)
##    sphere.position.y = 1
#    ground = BABYLON.Mesh.CreateGround('ground1', 6, 6, 2, scene)


g = new Game()
g.render()