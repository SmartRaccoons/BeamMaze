class ObjectAnime extends window.o.Object
  _animation: (fn, fr=30)=>
    window.App.events.trigger 'map:animation', @_name(), fn, fr


class Connector extends ObjectAnime
  name: 'connector'
  constructor: ->
    super
    @mesh.rotation.z = Math.PI
    @hide()

  angle: (angle)->
    @show()
    angle = -Math.PI/2 + angle
    if angle is @mesh.rotation.z
      return
    angle_diff = angle - @mesh.rotation.z
    if angle_diff > 0
      angle_diff = angle_diff - 2 * Math.PI
    angle_start = @mesh.rotation.z
    @_animation (m, steps)=>
      if steps is 0
        return @mesh.rotation.z = angle
      @mesh.rotation.z = angle_start + angle_diff * m


window.o.ObjectBlank = class Blank extends ObjectAnime
  _connector: Connector
  _color: [151, 153, 156]
  _color_active: [103, 181, 229]
  name: 'blank'
  _switch: true
  _step: 10

  constructor: ->
    super
    @position = {x: @options.position[0], y: @options.position[1]}
    @_connector = new @_connector({parent: @})
    @mesh.scaling = new BABYLON.Vector3(4, 4, 4)
    @_update_position(true)
    @out()
    @

  move: (position)->
    @position.x = @position.x + position.x
    @position.y = @position.y + position.y
    @_update_position()

  _update_position: (without_animation = false)->
    position_new = [@position.x * @_step, @position.y * @_step]
    position_set = => @mesh.position = new BABYLON.Vector3(position_new[0], position_new[1], 0)
    if without_animation
      return position_set()
    position = [@mesh.position.x, @mesh.position.y]
    position_diff = [position_new[0] - position[0], position_new[1] - position[1]]
    @_animation (m, steps)=>
      if steps is 0
        position_set()
        @trigger 'move_end'
        return
      @mesh.position = new BABYLON.Vector3(position[0] + position_diff[0] * m, position[1] + position_diff[1] * m, (if @_switch then -1 else 1) * 5 * Math.sin(Math.PI * m))
    , 20

  over: ->
    @color(@_color_active)
    @_connector.color(@_color_active)

  out: ->
    @color(@_color)
    @_connector.color(@_color)
