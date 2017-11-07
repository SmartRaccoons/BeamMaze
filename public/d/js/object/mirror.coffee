color_mirror = [187, 230, 239]


class MirrorTubeIn extends window.o.Object
  name: 'mirrorTube'
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh._class = @
    @_out = false

  rotate: (rotation)->
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), rotation * Math.PI / 2, BABYLON.Space.WORLD)

  mirror_id: ->
    @parent.options.parent_class._name()

  position: ->
    @options.parent.position

  reflect: (v)->
    @parent.activate()
    if @_out
      return new BABYLON.Vector3(-v.y, v.x , v.z)
    return new BABYLON.Vector3(v.y, -v.x , v.z)


class MirrorTubeOut extends MirrorTubeIn
  constructor: ->
    super
    @mesh.rotate(new BABYLON.Vector3(0, 1, 0), Math.PI, BABYLON.Space.WORLD)
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI/2, BABYLON.Space.WORLD)
    @_out = true


class MirrorTube
  _color_active: window.o.ObjectBeam::_color
  constructor: (options)->
    @options = options
    tube_options = {parent_class: @, parent: @options.parent_class.mesh}
    @tubes = []
    @tubes.push new MirrorTubeIn(tube_options)
    @tubes.push new MirrorTubeOut(tube_options)
    @tubes.forEach (t)=> t.rotate(@options.rotation)
    @_color = @options.parent_class._color
    @color_default()

  activate: ->
    @active = true
    @tubes.forEach (t)=> t.color(@_color_active.concat(0.5))

  color_default: -> @tubes.forEach (t)=> t.color(@_color.concat(0.5))

  deactive: ->
    if !@active
      return
    @color_default()


window.o.ObjectMirrorParent = class Mirror extends window.o.Object
  _color: color_mirror
  name: 'mirror'
  constructor: ->
    super
    @color(null, 0)
    @tubes = []
    for rotation in (if @options.reverse then [1, 3] else [0, 2])
      @tubes.push new MirrorTube({parent_class: @, rotation: rotation})

  deactive: ->
    @tubes.forEach (t)-> t.deactive()


_move_positions = [Math.PI*3/2, Math.PI, Math.PI/2, 0]
_move_positions_coors = [{y: -1, x: 0}, {y: 0, x: -1}, {y: 1, x: 0}, {y: 0, x: 1}]

window.o.ObjectMirror = class MirrorContainer extends window.o.ObjectBlank
  _switch: false
  constructor: ->
    super
    @mirror = new Mirror({parent: @mesh, reverse: @options.reverse})
    @_move_position = 0

  _controls_add: ->
    if @_controls_added
      return
    @_controls_added = true
    @mirror._action
      mouseover: => @over()
      mouseout: => @out()
      click: => @trigger 'move', @get_move_position()

  _controls_remove: ->
    @_controls_added = false
    @out()
    @mirror._action_remove()

  get_move_position: (n = @_move_position, full = false)->
    p = _move_positions_coors[n]
    if !full
      return p
    {x: p.x + @position.x, y: p.y + @position.y}

  set_move_position: (nr)->
    if nr is null
      @_controls_remove()
      return @_connector.hide()
    @_controls_add()
    @_move_position = nr
    @_connector.angle(_move_positions[nr])
