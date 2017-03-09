
class MirrorTubeIn extends window.o.Object
  name: 'mirrorTube'
  constructor: ->
    super
    @mesh.position = new BABYLON.Vector3(0, 0, -0.55 * (if @options.back then -1 else 1))
    @mesh._class = @
    @_out = @options.back

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
    @_out = !@options.back


class MirrorTube
  constructor: (options)->
    @options = options
    tube_options = {parent_class: @, parent: @options.parent_class.mesh, back: @options.back}
    @tube_in = new MirrorTubeIn(tube_options)
    @tube_out = new MirrorTubeOut(tube_options)
    @tube_in.rotate(@options.rotation)
    @tube_out.rotate(@options.rotation)
    @color_default()

  activate: ->
    @active = true
    @tube_in.color(255, 243, 21)
    @tube_out.color(255, 243, 21)

  color_default: ->
    # (108, 141, 150)
    @tube_in.color(187, 230, 239)
    @tube_out.color(187, 230, 239)

  deactive: ->
    if !@active
      return
    @color_default()


window.o.Mirror = class Mirror extends window.o.Object
  name: 'mirror'
  constructor: ->
    super
    @color(187, 230, 239, 0.5)
    @mesh.scaling = new BABYLON.Vector3(4.2, 4.2, 4.2)
    @mesh.position = new BABYLON.Vector3(@options.pos[0], @options.pos[1], 0)
    @tubes = []
    for rotation in (if @options.reverse then [1, 3] else [0, 2])
      @tubes.push new MirrorTube({parent_class: @, rotation: rotation})
      @tubes.push new MirrorTube({parent_class: @, rotation: rotation, back: true})

  deactive: ->
    @tubes.forEach (t)-> t.deactive()
