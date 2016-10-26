


class Game
  _step: 10

  constructor: ->
    @_object_id = 0
    @_mirror = []
    @_platform = {}
    @_mirrors_correct = false
#    @_wall = []

  map: ->
    methods = {
      '0': null
      '1': 'mirror'
      '2': 'mirror_reverse'
      '8': 'beam_source'
      '9': 'target'
    }

    map_string = window.MAPS[0]
#    map = window.MAP(10, 4, [2, 4])
    map = map_string.split("\n").map (s)->
      s.trim().split('').map (ob)-> parseInt(ob)
    size = map[0].length
    middle = Math.floor(size/2)
    for fn in Object.keys(methods)
      methods[fn] = ((name, fn)=>
        (parent, x, y)=>
          console.info name, parent, x, y
          console.info fn
          if fn
            params = [[x*10, y*10, 0]]
            if parent
              params.unshift(parent)
            @[fn].apply(@, params)
      )(fn, methods[fn])

    methods[map[middle][middle]](null, middle, middle)
    for m in [1..middle]
      parent = @platform(m, middle * 10, m * 10)
      for x in [-m..m]
        methods[map[x + middle][m + middle]](parent, x + middle, m + middle)
        methods[map[x + middle][-m + middle]](parent, x + middle, -m + middle)
      for y in [(-m+1)...m]
        methods[map[m + middle][y + middle]](parent, m + middle, y + middle)
        methods[map[-m + middle][y + middle]](parent, -m + middle, y + middle)
    for m in [0...size]
      methods[map[size][m]](null, middle+1, size, m)

  _name: ->
    @_object_id++
    "o_#{@_object_id}"

  beam_source: (coors, angles...)->
    @_beam_coors = coors
    ob = BABYLON.Mesh.CreateSphere(@_name(), 5, 4, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    ob.material = material
    ob._type = 'source'
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob.material.emissiveColor = new BABYLON.Color3(1.0, 1.0, 0)

  platform: (name, center, size)->
    width = size * 2 + @_step
    depth = 2
    ob = BABYLON.MeshBuilder.CreateBox(@_name(), {
      width: width
      height: width
      depth: depth
    }, @_scene)
    ob.position.x = center
    ob.position.y = center
    ob.position.z = 0
    ob.material = new BABYLON.StandardMaterial(@_name(), @_scene)
    ob.material.alpha = 0.4
    for c in [{
      size: [@_step, @_step]
      position: [-size, -size]
      click: (ob)->
        console.info ob
        ob.rotation.z += Math.PI
#    }, {
#      size: [@_step, @_step]
#      position: [size, size]
#      click: (ob)->
#        console.info ob
#        ob.rotation.z -= Math.PI
    }]
      action = BABYLON.MeshBuilder.CreateBox(@_name(), {
        width: c.size[0]
        height: c.size[1]
        depth: depth
      }, @_scene)
      action.parent = ob
      action.position = new BABYLON.Vector3(-c.position[0], -c.position[1], 0)
      action.actionManager = new BABYLON.ActionManager(@_scene)
      action.actionManager.registerAction new BABYLON.ExecuteCodeAction BABYLON.ActionManager.OnPickTrigger, ((action)=>
        => c.click(action)
      )(action)
    ob

  mirror_reverse: (parent, coors)->
    @mirror(parent, coors, Math.PI/4 + Math.PI/2)

  mirror: (parent, coors, angle=Math.PI/4)->
    ob = BABYLON.MeshBuilder.CreateBox(@_name(), {
      width: 10
      height: 0.001
      depth: 10
    }, @_scene)
    ob.position.x = coors[0]
    ob.position.y = coors[1]
    ob.position.z = coors[2]
    ob._type = 'mirror'
    ob.rotation.z = angle + 3*Math.PI/2
    ob.__rotation_v = new BABYLON.Vector3(Math.cos(angle), Math.sin(angle), 0)
    @_mirror.push ob
    ob

  obstacle: (parent, coors)->
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

  beam: (angle = -Math.PI)->
    @text('')
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
        @text('Well done!')
      if pick_info.pickedMesh._type isnt 'mirror'
        break
      end = @_reflect(end, pick_info.pickedMesh)
      if end is null
        break
      last_mirror = pick_info.pickedMesh.id
    @_beam = BABYLON.Mesh.CreateLines(@_name(), points, @_scene)
    @_beam_angle_prev = angle

  target: (coors)->
    target = BABYLON.Mesh.CreateSphere(@_name(), 5, 2, @_scene)
    material = new BABYLON.StandardMaterial(@_name(), @_scene)
    target.position.x = coors[0]
    target.position.y = coors[1]
    material.emissiveColor = new BABYLON.Color3(1.0, 0, 0)
    target.material = material
    target._type = 'target'
    @_target = target
    target

  text: (t)->
    if t is @_text_last
      return
    @_text_last = t
    if not @_text_plane
      @_text_plane = BABYLON.Mesh.CreatePlane(@_name(), 60, @_scene, false)
#      @_text_plane.billboardMode = BABYLON.AbstractMesh.BILLBOARDMODE_ALL
      @_text_plane.position = new BABYLON.Vector3(0, 0, 10)
      @_text_plane.material = new BABYLON.StandardMaterial(@_name(), @_scene)
      @_text_plane.material.backFaceCulling = false
      @_text_plane.material.diffuseTexture = texture = new BABYLON.DynamicTexture(@_name(), {
        width: 512
        height: 512
      }, @_scene, true)
      texture.hasAlpha = true
    else
      texture = @_text_plane.material.diffuseTexture
    texture.getContext().clearRect(0, 0, 512, 512)
    texture.drawText(t, null, 256, "bold 40px verdana", '#11ee00', null)

  _render_loop: ->

  _render_before_loop: ->
    changes = false
#    @_mirror.forEach (ob)=>
#      if ob.__rotation isnt ob.__rotation_new
#        ob.__rotate(ob.__rotation_new)
#        changes = true
#    if changes
#      setTimeout =>
#        @beam()
#      , 0
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
    camera.setPosition(new BABYLON.Vector3(-50, -60, -200))
    camera.attachControl(canvas, false)
    @map()
    scene.render()
    @beam()


g = new Game()
g.render()