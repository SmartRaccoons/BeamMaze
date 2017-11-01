
class MirrorTubeIn extends window.o.Object
  name: 'mirrorTube'
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55)
    @mesh._class = @
    @_out = false

  rotate: (rotation)->
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), rotation * Math.PI / 2, BABYLON.Space.WORLD)

  mirror_id: ->
    @parent.options.parent_class._name()

  position: ->
    @options.parent.position

  reflect: (v)->
    @parent.activate()
    if @_out
      return new BABYLON.Vector3(-v.y, v.x , v.z)
    return new BABYLON.Vector3(v.y, -v.x , v.z)


class MirrorTubeOut extends MirrorTubeIn
  constructor: ->
    super
    @mesh.rotate(new BABYLON.Vector3(0, 1, 0), Math.PI, BABYLON.Space.WORLD)
    @mesh.rotate(new BABYLON.Vector3(0, 0, 1), Math.PI/2, BABYLON.Space.WORLD)
    @_out = true


class MirrorTube
  _color_active: window.o.ObjectBeam::_color
  constructor: (options)->
    @options = options
    tube_options = {parent_class: @, parent: @options.parent_class.mesh}
    @tubes = []
    @tubes.push new MirrorTubeIn(tube_options)
    @tubes.push new MirrorTubeOut(tube_options)
    @tubes.forEach (t)=> t.rotate(@options.rotation)
    @_color = @options.parent_class._color
    @color_default()

  activate: ->
    @active = true
    @tubes.forEach (t)=> t.color.apply(t, @_color_active.concat(0.5))

  color_default: -> @tubes.forEach (t)=> t.color.apply(t, @_color.concat(0.5))

  deactive: ->
    if !@active
      return
    @color_default()


window.o.ObjectMirror = class Mirror extends window.o.Object
  name: 'mirror'
  constructor: ->
    super
    @_color = [187, 230, 239] #[247, 192, 192]
    @color.apply(@, @_color.concat([0.4]))
    @mesh.scaling = new BABYLON.Vector3(4.2, 4.2, 4.2)
    @mesh.position = new BABYLON.Vector3(@options.pos[0], @options.pos[1], 0)
    @tubes = []
    for rotation in (if @options.reverse then [1, 3] else [0, 2])
      @tubes.push new MirrorTube({parent_class: @, rotation: rotation})
    @_blank = new window.o.ObjectBlank({parent: @mesh})

  deactive: ->
    @tubes.forEach (t)-> t.deactive()
