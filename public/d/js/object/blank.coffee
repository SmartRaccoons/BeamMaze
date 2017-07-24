
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
    xabs = Math.abs(@options.pos[0])
    yabs = Math.abs(@options.pos[1])
    if xabs is yabs
      if @options.pos[0] < 0
        if @options.pos[1] > 0
          @_connectors.push new ConnectorDown({parent: @mesh})
          @_connectors.push new ConnectorRight({parent: @mesh})
        else
          @_connectors.push new ConnectorUp({parent: @mesh})
          @_connectors.push new ConnectorRight({parent: @mesh})
      else
        if @options.pos[1] > 0
          @_connectors.push new ConnectorDown({parent: @mesh})
          @_connectors.push new ConnectorLeft({parent: @mesh})
        else
          @_connectors.push new ConnectorUp({parent: @mesh})
          @_connectors.push new ConnectorLeft({parent: @mesh})
    else if xabs < yabs
      @_connectors.push new ConnectorRight({parent: @mesh})
      @_connectors.push new ConnectorLeft({parent: @mesh})
    else
      @_connectors.push new ConnectorDown({parent: @mesh})
      @_connectors.push new ConnectorUp({parent: @mesh})
    @out()
    @

  over: ->
    @color(103, 181, 229)
    @_connectors.forEach (c)-> c.color(103, 181, 229)

  out: ->
    @color(151, 153, 156)
    @_connectors.forEach (c)-> c.color(151, 153, 156)
