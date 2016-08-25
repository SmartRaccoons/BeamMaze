
class Game

  constructor: ->
    @_object_id = 0
#    @_wall = []

  _name: ->
    @_object_id++
    'o_#{@_object_id}'

  beam_source: ->
    beam = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    beam.isPickable = true
    beam.material = material
    beam.actionManager = new BABYLON.ActionManager(@_scene)
    beam.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPickTrigger, =>
      @beam(@_beam_angle_prev - Math.PI/4)
    beam.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPointerOverTrigger, ->
      beam.material.emissiveColor = new BABYLON.Color3(1.0, 0, 1.0)
    out = ->
      beam.material.emissiveColor = new BABYLON.Color3(1.0, 1.0, 0)
    beam.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPointerOutTrigger, out
    out()

  beam: (angle)->
    if @_beam_angle_prev is angle
      return
    length = 200
    if @_beam
      @_beam.dispose()
    coors = [[0, 0, 0]]
    coors.push([Math.cos(angle) * length, Math.sin(angle) * length, 0])

    @_beam = BABYLON.Mesh.CreateLines(@_name(), coors.map( (c)-> new BABYLON.Vector3(c[0], c[1], c[2]) ), @_scene)
    @_beam_angle_prev = angle

  target: (position)->
    target = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    target.position.x = position[0]
    target.position.y = position[1]
    material.emissiveColor = new BABYLON.Color3(1.0, 0, 0)
    target.material = material
    @_target = target
    target

  _render_loop: ->


  render: ->
    canvas = document.createElement('canvas')
    document.body.appendChild(canvas)
    engine = new BABYLON.Engine(canvas, true)
    engine.runRenderLoop =>
      @_render_loop()
      scene.render()
    window.addEventListener 'resize', ->
      engine.resize()

    scene = @_scene = new BABYLON.Scene(engine)
    camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 100, BABYLON.Vector3.Zero(), scene)
    camera.setPosition(new BABYLON.Vector3(0, 0, -100))
    camera.attachControl(canvas, false)
    @beam_source()
    @beam(0)
    @target([20, 0, 0])


g = new Game()
g.render()