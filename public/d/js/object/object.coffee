_scene = null

_geometries = {}
window.App.events.bind 'game:init', (scene)->
  _scene = scene
  loader = new THREE.JSONLoader()
  for name, json of window.o.ObjectData
    _geometries[name] = loader.parse(json).geometry
    # _geometries[name].center()

_axis = ['x', 'y' ,'z']
_color = (c)-> c.map (v)-> v/255
_object_id = 0
window.o.Object = class Object extends MicroEvent
  _position_scale: 1

  constructor: (options)->
    _object_id++
    @_id = _object_id
    super
    @options = _.extend({
      color: [255, 255, 255, 0.2]
    }, @_default, options)
    @group = new THREE.Group()
    @mesh = @mesh_build()
    @mesh.name = @name
    if @options.parent
      @parent = @options.parent
    if @parent
      @parent.group.add(@mesh)
    else
      @group = new THREE.Group()
      @group.add(@mesh)
      _scene.add(@group)
    if @options.position
      @position_set(@options.position)
    # console.info @options.color, new THREE.Color().fromArray(@options.color)
    # @mesh.material = new THREE.MeshLambertMaterial({ color: new THREE.Color().fromArray(_color(@options.color)) } )
    @mesh.material = new THREE.MeshLambertMaterial()
    @color()
    @

  position_set: (position)-> position.forEach (v, i)=>
    (@group or @mesh).position[_axis[i]] = v * @_position_scale

  color: (color = @options.color, opacity = 1)->
    @mesh.material.color.fromArray(_color(color.slice(0, 3)))
    if color[3]?
      opacity = color[3]
    if opacity isnt 1
      @mesh.material.transparent = true
      @mesh.material.opacity = opacity

  hide: -> @mesh.visible = false

  show: -> @mesh.visible = true

  mesh_build: -> new THREE.Mesh(_geometries[@name])

  remove: ->
    super
    # _scene.remove(@mesh)
    # @mesh.geometry.dispose()
    # @mesh.material.dispose()


window.o.ObjectSphere = class ObjectSphere extends Object
