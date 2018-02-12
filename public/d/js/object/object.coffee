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
  mesh: THREE.Mesh

  constructor: (options)->
    super
    if @_animation
      _.extend @, window.o.ObjectAnimation::
      @_animation_reset()
    _object_id++
    @_id = _object_id
    @options = _.extend({
      color: [255, 255, 255, 0.2]
    }, @_default, options)
    @mesh = @mesh_build()
    if @name
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
    @color()
    @

  position_get: ->
    @position.map (v)=> v * @_position_scale

  position_set: (position)->
    @position = position
    @position_get().forEach (v, i)=>
      (@group or @mesh).position[_axis[i]] = v

  color: (color = @options.color, opacity = 1, material = @mesh.material)->
    if color
      @mesh.material.color.fromArray(_color(color.slice(0, 3)))
    if color[3]?
      opacity = color[3]
    if opacity isnt 1
      @mesh.material.transparent = true
      @mesh.material.opacity = opacity

  hide: -> @mesh.visible = false

  show: -> @mesh.visible = true

  material: -> new THREE.MeshLambertMaterial()

  mesh_build: -> new @mesh(@geometry(), @material())

  geometry: -> _geometries[@name].clone()

  scene: -> _scene

  remove: ->
    if @_animation
      @_animation_reset()
    super
    _scene.remove(@mesh)
    @mesh.geometry.dispose()
    @mesh.material.dispose()


window.o.ObjectSphere = class ObjectSphere extends Object
  geometry: -> new THREE.SphereBufferGeometry( @options.diameter, 16, 16 )
