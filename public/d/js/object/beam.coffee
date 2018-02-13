window.o.ObjectBeam = class Beam extends window.o.Object
  mesh: THREE.Line
  _default: {
    color: [255, 243, 21]
  }

  material: -> new THREE.LineBasicMaterial()

  geometry: ->
    geometry = new THREE.Geometry()
    start = @options.start.clone()
    end = @options.end.clone()
    geometry.vertices.push(start, end)
    axis = if start.x is end.x then 'y' else 'x'
    (if start[axis] > end[axis] then [-2, 2] else [2, -2]).forEach (v, i)->
      geometry.vertices[i][axis] = geometry.vertices[i][axis] + v
    geometry


class BeamSphere extends window.o.ObjectSphere
  _default: {
    diameter: 2
    sheath_1: 0.5
    sheath_2: 0.2
  }
  constructor: ->
    super
    @sheath1 = new window.o.ObjectSphere({diameter: @options.diameter + 0.5, color: @options.color.concat(@options.sheath_1), parent: @})
    @sheath2 = new window.o.ObjectSphere({diameter: @options.diameter + 1, color: @options.color.concat(@options.sheath_2), parent: @})
    @


window.o.ObjectBeamSource = class BeamSource extends BeamSphere
  name: 'source'
  _default: _.extend {}, BeamSphere::_default,
    color: Beam::_default.color
  constructor: ->
    @_beam = []
    @_mirror = []
    super

  beam: ->
    @beam_remove()
    points = [new THREE.Vector3().fromArray(@options.position)]
    last_mirror = null
    direction = new THREE.Vector3(0, 1000, 0)
    _tube_name = 'mirror-tube'
    tube_check = (name)-> name and name.indexOf('mirror-tube') is 0
    for i in [0...100]
      objects = new THREE.Raycaster(points[points.length - 1], direction.clone().normalize())
      .intersectObjects(@scene().children, true).filter( (o)->
        name = o.object.name
        if (i is 0 and name is 'source') or (tube_check(name) and last_mirror is o.object._class.mirror_id())
          return false
        tube_check(name) or ['target', 'source'].indexOf(name) >= 0
      )
      object = null
      if objects.length is 0
        points.push points[points.length - 1].clone().add(direction)
      else
        object = objects[0].object._class
        coors = if object.name is 'target' then object.position else object.parent.position_get()
        points.push new THREE.Vector3(coors[0], coors[1], @options.position[2])
      @_beam.push new window.o.ObjectBeam({start: points[points.length - 2], end: points[points.length - 1]})
      if not object
        break
      if object.name is 'target'
        object._solved()
      if tube_check(object.name)
        direction = object.reflect(direction)
        last_mirror = object.mirror_id()
        @_mirror.push object.parent
      if ['mirror-tube-straight', 'mirror-tube'].indexOf(object.name) is -1
        break

  beam_remove: ->
    @_mirror.forEach (m)-> m.deactive()
    @_beam.forEach (b)-> b.remove()
    @_mirror = []
    @_beam = []

  remove: ->
    @beam_remove()
    super


window.o.ObjectBeamTarget = class BeamTarget extends BeamSphere
  _animation: true
  name: 'target'
  _default: _.extend {}, BeamSphere::_default,
    color: [195, 18, 24]
  constructor: ->
    super
    @reset()
    @

  reset: ->
    @_animation_reset()
    @solved = false
    @sheath1.color(@options.color, 0)
    @sheath2.color(@options.color, 0)
    @color()

  _solved: ->
    @solved = true
    c1 = @options.color
    c2 = Beam::_default.color
    color_diff = c1.slice(0, 3).map (v, i)-> c2[i] - v
    @_animation_add
      property: 'color'
      callback: (m, steps)=>
        color = color_diff.map (v, i)-> v * m + c1[i]
        @color(color)
        @sheath1.color(color.concat(@options.sheath_1))
        @sheath2.color(color.concat(@options.sheath_2))
