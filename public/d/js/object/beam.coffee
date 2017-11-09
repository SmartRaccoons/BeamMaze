Object = window.o.Object

window.o.ObjectBeam = class Beam extends Object
  _color: [255, 243, 21]
  constructor: ->
    super
    @color(null, 0.5)
    width = 0.25
    start = @options.start
    end = @options.end
    if start.x is end.x
      @mesh.scaling = new BABYLON.Vector3(width, Math.abs(end.y - start.y) - 4, width)
      @mesh.position = new BABYLON.Vector3(start.x, (end.y + start.y) / 2, start.z)
    else
      @mesh.scaling = new BABYLON.Vector3(Math.abs(end.x - start.x) - 4, width, width)
      @mesh.position = new BABYLON.Vector3((end.x + start.x) / 2, start.y, start.z)
    @

  mesh_build: ->
    BABYLON.MeshBuilder.CreateBox(@_name(), {size: 1}, @scene())


class BeamSphere extends window.o.ObjectSphere
  _default: {
    diameter: 4
    color: Beam::_color
  }
  constructor: ->
    super
    @color(@options.color)
    @mesh.position = new BABYLON.Vector3(@options.position[0], @options.position[1], @options.position[2])
    @sheath = new window.o.ObjectSphere({diameter: @options.diameter + 1, parent: @})
    @sheath.color(@options.color.concat(0.5))
    @sheath2 = new window.o.ObjectSphere({diameter: @options.diameter + 2, parent: @})
    @sheath2.color(@options.color.concat(0.2))
    @


window.o.ObjectBeamSource = class BeamSource extends BeamSphere
  name: 'source'
  _default: {
    diameter: 4
    color: [255, 243, 21]
  }
  constructor: ->
    @_beam = []
    @_mirror = []
    super

  beam: ->
    @beam_remove()
    @solved = false
    @_beam = []
    @_mirror = []
    points = [new BABYLON.Vector3(@options.position[0], @options.position[1], @options.position[2])]
    last_mirror = null
    direction = new BABYLON.Vector3(0, 1000, 0)
    for i in [0...100]
      pick_info = @scene().pickWithRay new BABYLON.Ray(points[points.length - 1], direction, 100), ((i)->
        (m)->
          if (i is 0 and m._type is 'source') or (m._type is 'mirrorTube' and last_mirror is m._class.mirror_id())
            return false
          ['mirrorTube', 'target', 'mirrorTubeEmpty', 'source'].indexOf(m._type) > -1
      )(i)
      if not pick_info.pickedPoint
        points.push points[points.length - 1].add(direction)
      else
        points.push new BABYLON.Vector3(Math.round(pick_info.pickedPoint.x*0.1)*10, Math.round(pick_info.pickedPoint.y*0.1)*10, @options.position[2])
      @_beam.push new window.o.ObjectBeam({start: points[points.length - 2], end: points[points.length - 1]})
      if not pick_info.hit
        break
      if pick_info.pickedMesh._type is 'target'
        @solved = true
      if ['mirrorTubeEmpty', 'mirrorTube'].indexOf(pick_info.pickedMesh._type) > -1
        direction = pick_info.pickedMesh._class.reflect(direction)
        last_mirror = pick_info.pickedMesh._class.mirror_id()
        @_mirror.push pick_info.pickedMesh._class.parent
      if pick_info.pickedMesh._type isnt 'mirrorTube'
        break

  beam_remove: ->
    @_mirror.forEach (m)-> m.deactive()
    @_beam.forEach (b)-> b.remove()

  remove: ->
    @beam_remove()
    super


window.o.ObjectBeamTarget = class BeamTarget extends BeamSphere
  name: 'target'
  _default: {
    diameter: 4
    color: [195, 18, 24]
  }
  constructor: ->
    super
    @sheath.mesh.material.alpha = 0
    @sheath2.mesh.material.alpha = 0
    @
