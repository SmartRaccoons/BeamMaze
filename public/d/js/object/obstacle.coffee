class MirrorTube extends window.o.Object
  _color: window.o.ObjectMirrorParent::_color
  _color_active: window.o.ObjectBeam::_color
  name: 'mirrorTubeEmpty'
  constructor: ->
    super
    @color(null, 0.5)
    @mesh._class = @
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), @options.rotation * Math.PI / 2, BABYLON.Space.WORLD)

  reflect: ->
    @color(@_color_active.concat(0.5))

  deactive: -> @color(null, 0.5)

  mirror_id: ->


window.o.ObjectObstacle = class Mirror extends window.o.ObjectBlank
  _color: window.o.ObjectMirror::_color
  constructor: ->
    super
    return
    @tubes = []
    for rotation in [0..3]
      @tubes.push new MirrorTube({parent: @mesh, parent_class: @, rotation: rotation})

  deactive: -> @tubes.forEach (t)-> t.deactive()
