class Connector extends window.o.Object
  name: 'connector'
  constructor: ->
    super
    @mesh.rotation.z = Math.PI
    @color()
    @hide()

  angle: (angle, reverse)->
    @show()
    angle = -Math.PI/2 + angle
    if angle is @mesh.rotation.z
      return
    angle_diff = angle - @mesh.rotation.z
    if angle_diff > 0 and !reverse
      angle_diff = angle_diff - 2 * Math.PI
    if angle_diff < 0 and reverse
      angle_diff = angle_diff + 2 * Math.PI
    angle_start = @mesh.rotation.z
    @_animation (m, steps)=>
      if steps is 0
        return @mesh.rotation.z = angle
      @mesh.rotation.z = angle_start + angle_diff * m


class MirrorTube extends window.o.Object
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh._class = @
    @deactive()
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), @options.rotation * Math.PI / 2, BABYLON.Space.WORLD)
    @

  mirror_id: -> @parent.options.parent._name()

  active: (silent=false)->
    @color(@options.color_active)
    if !silent
      @trigger 'active'

  deactive: -> @color()

  reflect: (v)->
    @active()


class MirrorTubeConnect extends MirrorTube
  name: 'mirrorTube'

  reflect: (v)->
    super
    new BABYLON.Vector3(v.y, -v.x , v.z)


class MirrorTubeConnectOut extends MirrorTube
  name: 'mirrorTube'
  mesh_build: ->
    mesh = super
    mesh.rotate(new BABYLON.Vector3(0, 1, 0), Math.PI, BABYLON.Space.WORLD)
    mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI/2, BABYLON.Space.WORLD)
    return mesh

  reflect: (v)->
    super
    new BABYLON.Vector3(-v.y, v.x , v.z)


class MirrorTubeEmpty extends MirrorTube
  name: 'mirrorTubeEmpty'


class MirrorTubeStraight extends MirrorTube
  name: 'mirrorTubeStraight'

  reflect: (v)->
    super
    new BABYLON.Vector3(v.x, v.y , v.z)


class MirrorTubeStraightOut extends MirrorTubeStraight
  mesh_build: ->
    mesh = super
    mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI, BABYLON.Space.WORLD)
    mesh


class MirrorNormal extends window.o.Object
  name: 'mirror'
  connectors: [[MirrorTubeConnect, MirrorTubeConnectOut], null, [MirrorTubeConnect, MirrorTubeConnectOut]]
  constructor: ->
    super
    @color()
    @tubes = []
    @connectors.forEach (connectors, i)=>
      if !connectors
        return
      tubes = (if Array.isArray(connectors) then connectors else [connectors]).map (connector)=>
        new connector({
          parent: @
          color: @options.color_tube
          color_active: window.o.ObjectBeam::_default.color
          rotation: i
        })
      tubes.forEach (t1, i)->
        tubes.forEach (t2, j)->
          if i is j
            return
          t1.bind('active', -> t2.active(true) )
          t2.bind('active', -> t1.active(true) )
      @tubes = @tubes.concat(tubes)

  deactive: -> @tubes.forEach (t)-> t.deactive()


class MirrorReverse extends MirrorNormal
  connectors: [null, [MirrorTubeConnect, MirrorTubeConnectOut], null, [MirrorTubeConnect, MirrorTubeConnectOut]]


class MirrorEmpty extends MirrorNormal
  connectors: [MirrorTubeEmpty, MirrorTubeEmpty, MirrorTubeEmpty, MirrorTubeEmpty]


class MirrorStraight extends MirrorNormal
  connectors: [[MirrorTubeStraight, MirrorTubeStraightOut], MirrorTubeEmpty, null, MirrorTubeEmpty]


class MirrorCross extends MirrorNormal
  connectors: [MirrorTubeEmpty, [MirrorTubeStraight, MirrorTubeStraightOut], MirrorTubeEmpty]

_angle_to_xy = (angle)-> {y: Math.round(Math.sin(angle)), x: Math.round(Math.cos(angle))}
_move_positions = [Math.PI*3/2, Math.PI, Math.PI/2, 0]
_move_positions_coors = _move_positions.map _angle_to_xy

window.o.ObjectMirror = class MirrorContainer extends window.o.ObjectBlank
  _default: {
    color: [37, 169, 245, 0.6]
    color_tube: [255, 255, 255, 0.9]
  }
  _move_reverse: false
  _move_positions: _move_positions
  _move_positions_coors: _move_positions_coors
  classes:
    'normal': MirrorNormal
    'reverse': MirrorReverse
    'empty': MirrorEmpty
    'straight': MirrorStraight
    'cross': MirrorCross
  constructor: ->
    super
    @_static = 's' in @options.params
    @_move_position = 0
    @mirror = new @classes[@options.type]({
      parent: @
      color_tube: @options.color_tube
    })
    if @_static
      @color([0, 0, 0, 0])
    if !@_static
      @_connector = new Connector({parent: @, color: @options.color.slice(0, 3)})

  _controls_add: ->
    if @_controls_added
      return
    @_controls_added = true
    @mirror._action
      mouseover: =>
      mouseout: =>
      click: => @trigger 'move', @get_move_position()

  _controls_remove: ->
    @_controls_added = false
    @mirror._action_remove()

  get_move_position: (n = @_move_position, full = false)->
    p = @_move_positions_coors[n]
    if !full
      return p
    {x: p.x + @position.x, y: p.y + @position.y}

  set_move_position: (nr)->
    if nr is null
      @_controls_remove()
      return @_connector.hide()
    @_controls_add()
    @_move_position = nr
    @_connector.angle(@_move_positions[nr], @_move_reverse)

  move: (position)->
    @position.x = @position.x + position.x
    @position.y = @position.y + position.y
    @_update_position()


_move_positions_reverse = [_move_positions[0], _move_positions[3], _move_positions[2], _move_positions[1]]
_move_positions_coors_reverse = _move_positions_reverse.map _angle_to_xy

window.o.ObjectMirrorReverse = class MirrorContainerReverse extends MirrorContainer
  _move_reverse: true
  _default: _.extend({}, MirrorContainer::_default, {
    color: [239, 107, 0, 0.6]
  })
  _move_positions: _move_positions_reverse
  _move_positions_coors: _move_positions_coors_reverse
