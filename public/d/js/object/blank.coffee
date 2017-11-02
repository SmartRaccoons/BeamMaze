
class Connector extends window.o.Object
  name: 'connector'


class ConnectorUp extends Connector
  constructor: ->
    super
    @mesh.rotation.z = 0
    @mesh.position = new BABYLON.Vector3(0, 1.05, 0)


class ConnectorDown extends Connector
  constructor: ->
    super
    @mesh.rotation.z = Math.PI
    @mesh.position = new BABYLON.Vector3(0, -1.05, 0)


class ConnectorLeft extends Connector
  constructor: ->
    super
    @mesh.rotation.z = Math.PI/2
    @mesh.position = new BABYLON.Vector3(-1.05, 0, 0)


class ConnectorRight extends Connector
  constructor: ->
    super
    @mesh.rotation.z = -Math.PI/2
    @mesh.position = new BABYLON.Vector3(1.05, 0, 0)


window.o.ObjectBlank = class Blank extends window.o.Object
  name: 'blank'
  _switch: true
  _step: 10
  clear: ->
    @_connectors = []

  constructor: ->
    super
    @position = {x: @options.pos[0], y: @options.pos[1]}
    @clear()
    # @color(187, 230, 239)
    @mesh.scaling = new BABYLON.Vector3(4.2, 4.2, 4.2)
    @_update_position()
    @out()
    @

  move: (position)->
    @position.x = @position.x + position.x
    @position.y = @position.y + position.y
    @_update_position()

  _update_position: ->
    @mesh.position = new BABYLON.Vector3(@position.x * @_step, @position.y * @_step, 0)

  _animate: (part, position)->
    axis = if position.x then 'x' else 'y'
    diff = position[axis] - @_position_prev[axis]
    @mesh.position[axis] = @_position_prev[axis] + diff * part

  over: ->
    @color(103, 181, 229)
    @_connectors.forEach (c)-> c.color(103, 181, 229)

  out: ->
    @color(151, 153, 156)
    @_connectors.forEach (c)-> c.color(151, 153, 156)
