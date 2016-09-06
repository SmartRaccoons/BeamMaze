
class Game

  constructor: ->
    @_object_id = 0
    @_mirror = []
#    @_wall = []

  map: ->
    methods = {
      'o': (coors)=> @obstacle(coors)
      'm': (coors, degrees=0)=> @mirror(coors, Math.PI * degrees / 180)
      't': (coors)=> @target(coors)
      's': (coors, degrees=0)=> @beam_source(coors, Math.PI * degrees / 180)
    }
    map = [
      ['', '', '', 'm243', '', '', '']
      ['s-45', '', '', '', '', '', '']
      ['', 'm90', '', '', '', '', '']
      ['', '', '', '', '', '', '']
      ['', '', '', '', '', 'm256', '']
      ['', '', '', '', '', '', '']
      ['', '', 'm237.8', '', '', '', 't']
    ]
    height = map.length
    map.forEach (l, y)->
      width = l.length
      l.forEach (v, x)->
        coors = [10 * (x - width / 2), -10 * (y - height / 2), 0]
        if v and methods[v.substr(0, 1)]
          methods[v.substr(0, 1)].apply(@, [coors].concat(v.substr(1).split('|')))

  _name: ->
    @_object_id++
    "o_#{@_object_id}"

  beam_source: (coors, angle)->
    @_beam_coors = coors
    @_beam_angle_prev = angle
    ob = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    ob.material = material
    ob._type = 'source'
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob.material.emissiveColor = new BABYLON.Color3(1.0, 1.0, 0)
    ob.actionManager = new BABYLON.ActionManager(@_scene)
    ob.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPickTrigger, =>
      @beam(@_beam_angle_prev - Math.PI/4)

  mirror: (coors, angle)->
    ob = BABYLON.MeshBuilder.CreateBox(@_name(), {
      width: 8
      height: 0.1
      depth: 2
    }, @_scene)
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob._type = 'mirror'
    ob.__rotate = (angle)->
      ob.rotation.z = angle + 3*Math.PI/2
      ob.__rotation = angle
      ob.__rotation_v = new BABYLON.Vector3(Math.cos(angle), Math.sin(angle), 0)
    click = BABYLON.MeshBuilder.CreateCylinder(@_name(), {
      height: 2.2
      diameter: 8
    }, @_scene)
    click.rotation.x = Math.PI/2
    click.material = new BABYLON.StandardMaterial(@_name(), @_scene)
    click.material.alpha = 0.3
    click.parent = ob
    click.actionManager = new BABYLON.ActionManager(@_scene)
    click.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPickTrigger, =>
      ob.__rotation_new = ob.__rotation_new + Math.PI/4
    ob.__rotation_new = angle
    @_mirror.push ob
#    mirrorMaterial = new BABYLON.StandardMaterial(@_name(), @_scene)
#    mirrorMaterial.reflectionTexture = new BABYLON.MirrorTexture("mirror", 512, @_scene, true)
#    mirrorMaterial.reflectionTexture.mirrorPlane = new BABYLON.Plane(0, -1.0, 0, -10.0)
#    mirrorMaterial.reflectionTexture.renderList = @_list
#    mirrorMaterial.reflectionTexture.level = 0.6
#    ob.material = mirrorMaterial
    ob

  obstacle: (coors)->
    ob = BABYLON.Mesh.CreateBox(@_name(), 4, @_scene)
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob._type = 'obstacle'
    ob

  _reflect: (v, mesh)->
    dot = BABYLON.Vector3.Dot(v, mesh.__rotation_v)
#    if -0.01 < Math.PI/2 - Math.acos(dot / (v.length() * mesh.__rotation_v.length())) < 0.01
#      return null
    v.subtract(mesh.__rotation_v.scale(2*dot))

  beam: (angle = @_beam_angle_prev)->
    length = 200
    if @_beam
      @_beam.dispose()
    points = [new BABYLON.Vector3(@_beam_coors[0], @_beam_coors[1], @_beam_coors[2])]
    last_mirror = ''
    end = new BABYLON.Vector3(Math.cos(angle) * length, Math.sin(angle) * length, 0)
    for i in [0..100]
      pick_info = @_scene.pickWithRay new BABYLON.Ray(points[points.length - 1], end, 1000), ((i)->
        (m)->
          if (i is 0 and m._type is 'source') or last_mirror is m.id
            return false
          ['mirror', 'target', 'obstacle', 'source'].indexOf(m._type) > -1
      )(i)
      points.push if pick_info.hit then pick_info.pickedPoint else end
      if not pick_info.hit
        break
      if pick_info.pickedMesh._type is 'target'
        console.info 'TARGET'
      if pick_info.pickedMesh._type isnt 'mirror'
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

  _render_before_loop: ->
    changes = false
    @_mirror.forEach (ob)=>
      if ob.__rotation isnt ob.__rotation_new
        ob.__rotate(ob.__rotation_new)
        changes = true
    if changes
      setTimeout =>
        @beam()
      , 0
#    console.info @_target


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
    scene.registerBeforeRender @_render_before_loop.bind(@)
    camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 200, BABYLON.Vector3.Zero(), scene)
    camera.setPosition(new BABYLON.Vector3(0, 0, -150))
    camera.attachControl(canvas, false)
    @map()
    scene.render()
    @beam()


g = new Game()
g.render()