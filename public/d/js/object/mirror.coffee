class MirrorTube extends window.o.Object
  _color: [187, 230, 239]
  _color_active: window.o.ObjectBeam::_color
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh._class = @
    @deactive()
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), @options.rotation * Math.PI / 2, BABYLON.Space.WORLD)
    @

  mirror_id: -> @parent.options.parent._name()

  active: (silent=false)->
    @color(@_color_active.concat(0.5))
    if !silent
      @trigger 'active'

  deactive: -> @color(@_color.concat(0.5))

  reflect: (v)->
    @active()


class MirrorTubeConnect extends MirrorTube
  name: 'mirrorTube'
  mesh_build: ->
    mesh = super
    if @options.out
      mesh.rotate(new BABYLON.Vector3(0, 1, 0), Math.PI, BABYLON.Space.WORLD)
      mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI/2, BABYLON.Space.WORLD)
      @_out = true
    return mesh

  reflect: (v)->
    super
    if @_out
      return new BABYLON.Vector3(-v.y, v.x , v.z)
    return new BABYLON.Vector3(v.y, -v.x , v.z)


class MirrorTubeEmpty extends MirrorTube
  name: 'mirrorTubeEmpty'


class MirrorNormal extends window.o.Object
  name: 'mirror'
  _rotations: [0, 2]
  _out: true
  connector: MirrorTubeConnect
  constructor: ->
    super
    @color(null, 0)
    @tubes = []
    @_rotations.forEach (rotation)=>
      t1 = new @connector({parent: @, rotation: rotation})
      @tubes.push(t1)
      if not @_out
        return
      t2 = new @connector({parent: @, rotation: rotation, out: true})
      @tubes.push(t2)
      t1.bind('active', -> t2.active(true) )
      t2.bind('active', -> t1.active(true) )

  deactive: -> @tubes.forEach (t)-> t.deactive()


class MirrorReverse extends MirrorNormal
  _rotations: [1, 3]


class MirrorEmpty extends MirrorNormal
  connector: MirrorTubeEmpty
  _rotations: [0..3]


_move_positions = [Math.PI*3/2, Math.PI, Math.PI/2, 0]
_move_positions_coors = _move_positions.map (angle)-> {y: Math.round(Math.sin(angle)), x: Math.round(Math.cos(angle))}

window.o.ObjectMirror = class MirrorContainer extends window.o.ObjectBlank
  _switch: false
  classes:
    'normal': MirrorNormal
    'reverse': MirrorReverse
    'empty': MirrorEmpty
  constructor: ->
    super
    @mirror = new @classes[@options.type]({parent: @})
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
