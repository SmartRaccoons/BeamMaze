window.o.ObjectBlank = class Blank extends window.o.Object
  _default: {
    color: [151, 153, 156]
  }
  name: 'blank'
  _step: 10

  constructor: ->
    super
    @position = {x: @options.position[0], y: @options.position[1], z: @options.position[2] or 0}
    @mesh.scaling = new BABYLON.Vector3(4, 4, 4)
    @_update_position(true)
    @color()
    @

  _update_position: (without_animation = false)->
    position_new = [@position.x * @_step, @position.y * @_step, @position.z]
    position_set = => @mesh.position = new BABYLON.Vector3(position_new[0], position_new[1], position_new[2])
    if without_animation
      return position_set()
    position = [@mesh.position.x, @mesh.position.y]
    position_diff = [position_new[0] - position[0], position_new[1] - position[1]]
    @_animation (m, steps)=>
      if steps is 0
        position_set()
        @trigger 'move_end'
        return
      @mesh.position = new BABYLON.Vector3(position[0] + position_diff[0] * m, position[1] + position_diff[1] * m, position_new[2])
    , 20
