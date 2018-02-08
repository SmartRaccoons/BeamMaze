_scene = null
_camera = null

_meshes = {}
window.App.events.bind 'game:init', (scene, camera)->
  _scene = scene
  _camera = camera
  loader = new THREE.JSONLoader()
  for name, json of window.o.ObjectData
    _meshes[name] = new THREE.Mesh(loader.parse(json).geometry)

_axis = ['x', 'y' ,'z']

window.o.Object = class Object extends MicroEvent
  constructor: (options)->
    super
    @options = _.extend({}, @_default, options)
    @mesh = @_mesh_build()
    @mesh.name = @options.name
    _scene.add(@mesh)
    if @options.position
      @options.position.forEach (v, i)=> @mesh.position[_axis[i]] = v
    console.info @options.color
    @

  _mesh_build: -> _meshes[@options.name].clone()

  remove: ->
    super
    _scene.remove(@mesh)
    @mesh.geometry.dispose()
    @mesh.material.dispose()
