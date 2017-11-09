
class MirrorTubeIn extends window.o.Object
  _color: [187, 230, 239]
  _color_active: window.o.ObjectBeam::_color
  name: 'mirrorTube'
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh._class = @
    @deactive()
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), @options.rotation * Math.PI / 2, BABYLON.Space.WORLD)
    @

  mirror_id: -> @parent.options.parent._name()

  reflect: (v)->
    @active()
    if @_out
      return new BABYLON.Vector3(-v.y, v.x , v.z)
    return new BABYLON.Vector3(v.y, -v.x , v.z)

  active: (silent=false)->
    @color(@_color_active.concat(0.5))
    if !silent
      @trigger 'active'

  deactive: -> @color(@_color.concat(0.5))


class MirrorTubeOut extends MirrorTubeIn
  mesh_build: ->
    mesh = super
    mesh.rotate(new BABYLON.Vector3(0, 1, 0), Math.PI, BABYLON.Space.WORLD)
    mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI/2, BABYLON.Space.WORLD)
    @_out = true
    mesh


class Mirror extends window.o.Object
  name: 'mirror'
  constructor: ->
    super
    @color(null, 0)
    @tubes = []
    (if @options.reverse then [1, 3] else [0, 2]).forEach (rotation)=>
      t1 = new MirrorTubeIn({parent: @, rotation: rotation})
      t1.bind('active', -> t2.active(true) )
      t2 = new MirrorTubeOut({parent: @, rotation: rotation})
      t2.bind('active', -> t1.active(true) )
      @tubes.push(t1)
      @tubes.push(t2)

  deactive: -> @tubes.forEach (t)-> t.deactive()


_move_positions = [Math.PI*3/2, Math.PI, Math.PI/2, 0]
_move_positions_coors = [{y: -1, x: 0}, {y: 0, x: -1}, {y: 1, x: 0}, {y: 0, x: 1}]

window.o.ObjectMirror = class MirrorContainer extends window.o.ObjectBlank
  _switch: false
  constructor: ->
    super
    @mirror = new Mirror({parent: @, reverse: @options.reverse})
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
