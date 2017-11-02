
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
  clear: ->
    @_connectors = []

  constructor: ->
    super
    @clear()
    # @color(187, 230, 239)
    @mesh.scaling = new BABYLON.Vector3(4.2, 4.2, 4.2)
    @mesh.position = new BABYLON.Vector3(@options.pos[0], @options.pos[1], 0)
    @out()
    @

  move: (where)->
    if where is 'down'
      @mesh.position.y = @mesh.position.y - 10
    if where is 'up'
      @mesh.position.y = @mesh.position.y + 10
    if where is 'left'
      @mesh.position.y = @mesh.position.x - 10
    if where is 'right'
      @mesh.position.y = @mesh.position.x + 10

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
