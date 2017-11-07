class MirrorTube extends window.o.Object
  _color: window.o.ObjectMirror::_color
  _color_active: window.o.ObjectBeam::_color
  name: 'mirrorTubeEmpty'
  constructor: ->
    super
    @color.apply(@, @_color.concat(0.5))
    @mesh._class = @
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), @options.rotation * Math.PI / 2, BABYLON.Space.WORLD)

  reflect: ->
    @color.apply(@, @_color_active.concat(0.5))


window.o.ObjectObstacle = class Mirror extends window.o.ObjectBlank
  _color: window.o.ObjectMirror::_color
  constructor: ->
    super
    @tubes = []
    # @color.apply(@, @_color.concat([0]))
    for rotation in [0..3]
      @tubes.push new MirrorTube({parent: @mesh, rotation: rotation})
