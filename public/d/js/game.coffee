
class Game

  constructor: ->
    @_object_id = 0
#    @_wall = []

  _name: ->
    @_object_id++
    "o_#{@_object_id}"

  beam_source: ->
    beam = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
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

  mirror: (coors)->
    ob = BABYLON.Mesh.CreateSphere(@_name(), 10, 2, @_scene)
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob._type = 'mirror'
    ob

  beam: (angle)->
    if @_beam_angle_prev is angle
      return
    length = 200
    if @_beam
      @_beam.dispose()
    start = new BABYLON.Vector3(0, 0, 0)
    end = new BABYLON.Vector3(Math.cos(angle) * length, Math.sin(angle) * length, 0)
    pick_info = @_scene.pickWithRay new BABYLON.Ray(start, end, length), (m)-> ['mirror', 'target'].indexOf(m._type) > -1
    if pick_info.hit
      console.info pick_info
      end = pick_info.pickedMesh.position
    if pick_info.hit and pick_info.pickedMesh._type is 'target'
      console.info 'targeted'
    @_beam = BABYLON.Mesh.CreateLines(@_name(), [start, end], @_scene)
    @_beam_angle_prev = angle

  target: (position)->
    target = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    target.position.x = position[0]
    target.position.y = position[1]
    material.emissiveColor = new BABYLON.Color3(1.0, 0, 0)
    target.material = material
    target._type = 'target'
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
    @target([20, 0, 0])
    @mirror([10, -10, 0])
    @mirror([20, -20, 0])
    scene.render()
    @beam(Math.PI/4)


g = new Game()
g.render()