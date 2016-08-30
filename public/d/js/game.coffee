
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

  mirror: (coors, angle)->
    ob = BABYLON.Mesh.CreateGround(@_name(), 10, 2, 4, @_scene)
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob.rotation.z = angle + 3*Math.PI/2
    ob.__rotation = angle
    ob.__rotation_v = new BABYLON.Vector3(Math.cos(angle), Math.sin(angle), 0)
    ob._type = 'mirror'
    ob

  _reflect: (v, mesh)->
    dot = BABYLON.Vector3.Dot(v, mesh.__rotation_v)
    if Math.PI/2 > Math.acos(dot / (v.length() * mesh.__rotation_v.length()))
      return null
    v.subtract(mesh.__rotation_v.scale(2*dot))

  beam: (angle)->
    if @_beam_angle_prev is angle
      return
    length = 200
    if @_beam
      @_beam.dispose()
    points = [new BABYLON.Vector3(0, 0, 0)]
    last_mirror = ''
    end = new BABYLON.Vector3(Math.cos(angle) * length, Math.sin(angle) * length, 0)
    for i in [0..100]
      pick_info = @_scene.pickWithRay new BABYLON.Ray(points[points.length - 1], end, length), (m)->
        last_mirror isnt m.id and ['mirror', 'target'].indexOf(m._type) > -1
      points.push if pick_info.hit then pick_info.pickedMesh.position else end
      if not (pick_info.hit and pick_info.pickedMesh._type is 'mirror')
        break
      end = @_reflect(end, pick_info.pickedMesh)
      if end is null
        break
      last_mirror = pick_info.pickedMesh.id
    @_beam = BABYLON.Mesh.CreateLines(@_name(), points, @_scene)
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
    camera.setPosition(new BABYLON.Vector3(0, 0, -50))
    camera.attachControl(canvas, false)
    @beam_source()
    @target([20, 0, 0])
    @mirror([10, -10, 0], Math.PI/2)
    @mirror([-10, -10, 0], Math.PI/2)
    @mirror([-20, 0, 0], Math.PI/2)
    scene.render()
    @beam(5*Math.PI/4)


g = new Game()
g.render()