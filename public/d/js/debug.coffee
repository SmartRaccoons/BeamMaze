# el = (id)-> document.getElementById(id)
#
# window.o.Game = class GameDebug extends window.o.Game
  # constructor: ->
  #   super
  #   @href = window.location.href.split('?')
  #   el('map-url').onfocus = -> @select()
  #
  #   update = =>
  #     map = @get_map()
  #     el('map-actual').value = map.join("\n")
  #     el('map-url').value = @href[0] + '?' + map.join('|')
  #   @bind 'beam', update
  #   setTimeout update, 1000
  #   el('map-solve').onclick = =>
  #     el('map-right').value = 'calculate...'
  #     @find_right (right)->
  #       el('map-right').value = right.join("\n\n")
  #
  #
  #   el('map-load').onclick = =>
  #     @map(el('map-actual').value)
  #
  # get_map: ->
  #   map = []
  #   for y in [0..@_map_size]
  #     map[y] = []
  #     for x in [0...@_map_size]
  #       map[y][x] = '0'
  #   middle = Math.floor(@_map_size/2)
  #   map[middle + 1][middle] = '9'
  #   @_mirror.forEach (m)=>
  #     # map[Math.round(m.mesh._absolutePosition.y / @_step) + middle + 1][Math.round(m.mesh._absolutePosition.x / @_step) + middle] = if @_mirror_position(m) then '2' else '1'
  #   # map[0][@_beam_coors[0] / @_step  + middle] = '8'
  #   map.map (line)-> line.join ''
  #     .reverse()
  #
  # find_right: (callback)->
  #   directions = [
  #     new BABYLON.Vector3(0, 0, 0)
  #     new BABYLON.Vector3(0, 0, 1.5)
  #     new BABYLON.Vector3(0, 0, 1)
  #     new BABYLON.Vector3(0, 0, 0.5)
  #     new BABYLON.Vector3(1, 0, 0)
  #     new BABYLON.Vector3(-1, 1, 0)
  #     new BABYLON.Vector3(0, 1, 0)
  #     new BABYLON.Vector3(1, 1, 0)
  #   ]
  #   right = []
  #   rotate = (p, v, negate = false)=>
  #     angle = Math.PI
  #     v2 = new BABYLON.Vector3(v.x, v.y, v.z)
  #     if v.z isnt 0
  #       angle = angle * v.z
  #       v2.z = 1
  #     if v.x is 0 and v.y is 0 and v.z is 0
  #       return
  #     p.__rotate((if negate then v2.negate() else v2), angle, true)
  #   check_combination = (c, callback)=>
  #     c.forEach (combination)=> rotate(@_platform[combination[0]], directions[combination[1]])
  #     setTimeout =>
  #       @beam()
  #       if @_solved
  #         right_map = @get_map().join "\n"
  #         if right.indexOf(right_map) is -1
  #           right.push right_map
  #       c.forEach (combination)=> rotate(@_platform[combination[0]], directions[combination[1]], true)
  #       callback()
  #     , 10
  #   combinations = []
  #   combination = (prev, i, max)=>
  #     if i < 0
  #       return combinations.push(prev)
  #     for j in [0...max]
  #       combination(prev.concat([[i, j]]), i - 1, max)
  #
  #   combination([], @_platform.length - 1, directions.length)
  #
  #   check = (callback)=>
  #     if combinations.length is 0
  #       return callback()
  #     check_combination combinations.pop(), => check(callback)
  #   check => callback(right)
  #
  # load_map: ->
  #   if @href[1]
  #     return setTimeout =>
  #       @map(@href[1].split('|').join("\n"))
  #     , 20
  #   super
  #
  # render: ->
  #   super
  #   @_camera.attachControl(document.body, true)
  #
  # showAxis: (size = 10)->
  #   scene = @_scene
  #   makeTextPlane = (text, color, size) ->
  #     dynamicTexture = new (BABYLON.DynamicTexture)('DynamicTexture', 50, scene, true)
  #     dynamicTexture.hasAlpha = true
  #     dynamicTexture.drawText text, 5, 40, 'bold 36px Arial', color, 'transparent', true
  #     plane = new (BABYLON.Mesh.CreatePlane)('TextPlane', size, scene, true)
  #     plane.material = new (BABYLON.StandardMaterial)('TextPlaneMaterial', scene)
  #     plane.material.backFaceCulling = false
  #     plane.material.specularColor = new (BABYLON.Color3)(0, 0, 0)
  #     plane.material.diffuseTexture = dynamicTexture
  #     plane
  #
  #   axisX = BABYLON.Mesh.CreateLines('axisX', [
  #     new (BABYLON.Vector3.Zero)
  #     new (BABYLON.Vector3)(size, 0, 0)
  #     new (BABYLON.Vector3)(size * 0.95, 0.05 * size, 0)
  #     new (BABYLON.Vector3)(size, 0, 0)
  #     new (BABYLON.Vector3)(size * 0.95, -0.05 * size, 0)
  #   ], scene)
  #   axisX.color = new (BABYLON.Color3)(1, 0, 0)
  #   xChar = makeTextPlane('X', 'red', size / 10)
  #   xChar.position = new (BABYLON.Vector3)(0.9 * size, -0.05 * size, 0)
  #   axisY = BABYLON.Mesh.CreateLines('axisY', [
  #     new (BABYLON.Vector3.Zero)
  #     new (BABYLON.Vector3)(0, size, 0)
  #     new (BABYLON.Vector3)(-0.05 * size, size * 0.95, 0)
  #     new (BABYLON.Vector3)(0, size, 0)
  #     new (BABYLON.Vector3)(0.05 * size, size * 0.95, 0)
  #   ], scene)
  #   axisY.color = new (BABYLON.Color3)(0, 1, 0)
  #   yChar = makeTextPlane('Y', 'green', size / 10)
  #   yChar.position = new (BABYLON.Vector3)(0, 0.9 * size, -0.05 * size)
  #   axisZ = BABYLON.Mesh.CreateLines('axisZ', [
  #     new (BABYLON.Vector3.Zero)
  #     new (BABYLON.Vector3)(0, 0, size)
  #     new (BABYLON.Vector3)(0, -0.05 * size, size * 0.95)
  #     new (BABYLON.Vector3)(0, 0, size)
  #     new (BABYLON.Vector3)(0, 0.05 * size, size * 0.95)
  #   ], scene)
  #   axisZ.color = new (BABYLON.Color3)(0, 0, 1)
  #   zChar = makeTextPlane('Z', 'blue', size / 10)
  #   zChar.position = new (BABYLON.Vector3)(0, 0.05 * size, 0.9 * size)
