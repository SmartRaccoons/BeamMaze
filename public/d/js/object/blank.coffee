window.o.ObjectBlank = class Blank extends window.o.Object
  name: 'blank'
  _default: {
    color: [189, 186, 180]
  }
  _position_scale: 10

  constructor: ->
    super
    @group.scale.set(4, 4, 4)
    @position = @options.position
    @
