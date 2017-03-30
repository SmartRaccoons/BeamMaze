
class Connector extends window.o.Object
  name: 'connector'
  constructor: ->
    super
    @color(151, 153, 156)

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


window.o.Blank = class Blank extends window.o.Object
  name: 'blank'
  constructor: ->
    super
    @color(151, 153, 156)
    # @color(187, 230, 239)
    @mesh.scaling = new BABYLON.Vector3(4.2, 4.2, 4.2)
    @mesh.position = new BABYLON.Vector3(@options.pos[0], @options.pos[1], 0)
    xabs = Math.abs(@options.pos[0])
    yabs = Math.abs(@options.pos[1])
    if xabs is yabs
      if @options.pos[0] < 0
        if @options.pos[1] > 0
          new ConnectorDown({parent: @mesh})
          new ConnectorRight({parent: @mesh})
        else
          new ConnectorUp({parent: @mesh})
          new ConnectorRight({parent: @mesh})
      else
        if @options.pos[1] > 0
          new ConnectorDown({parent: @mesh})
          new ConnectorLeft({parent: @mesh})
        else
          new ConnectorUp({parent: @mesh})
          new ConnectorLeft({parent: @mesh})
    else if xabs < yabs
      new ConnectorRight({parent: @mesh})
      new ConnectorLeft({parent: @mesh})
    else
      new ConnectorDown({parent: @mesh})
      new ConnectorUp({parent: @mesh})
