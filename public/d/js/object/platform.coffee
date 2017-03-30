
window.o.Platform = class Platform extends window.o.ObjectBox
  _step: 10
  constructor: (options)->
    width = options.size * 2 + @_step
    super(_.extend({dimension: [width, width, 0]}, options))
    @color(0, 0, 0, 0)
    size = @options.size
    @_controls = []
    @_rotation_animations = []
    new window.o.Blank({pos: [-size, size], parent: @mesh})
    new window.o.Blank({pos: [-size, -size], parent: @mesh})
    new window.o.Blank({pos: [size, size], parent: @mesh})
    new window.o.Blank({pos: [size, -size], parent: @mesh})
    for s in [-size...size] by @_step
      new window.o.Blank({pos: [-size, s], parent: @mesh})
      new window.o.Blank({pos: [size, s], parent: @mesh})
      new window.o.Blank({pos: [s, -size], parent: @mesh})
      new window.o.Blank({pos: [s, size], parent: @mesh})
    [{
      size: [@_step, @_step]
      position: [-size, -size]
      vector: new BABYLON.Vector3(-1, 1, 0)
    }, {
      size: [@_step, @_step]
      position: [size, size]
      vector: new BABYLON.Vector3(1, -1, 0)
    }, {
      size: [@_step, @_step]
      position: [-size, size]
      vector: new BABYLON.Vector3(1, 1, 0)
    }, {
      size: [@_step, @_step]
      position: [size, -size]
      vector: new BABYLON.Vector3(-1, -1, 0)
    }, {
      size: [width - 2 * @_step, @_step]
      position: [0, -size]
      vector: new BABYLON.Vector3(-1, 0, 0)
    }, {
      size: [width - 2 * @_step, @_step]
      position: [0, size]
      vector: new BABYLON.Vector3(1, 0, 0)
    }, {
      size: [@_step, width - 2 * @_step]
      position: [size, 0]
      vector: new BABYLON.Vector3(0, -1, 0)
    }, {
      size: [@_step, width - 2 * @_step]
      position: [-size, 0]
      vector: new BABYLON.Vector3(0, 1, 0)
    }].forEach (c)=>
      action  = new window.o.ObjectBox({
        dimension: [c.size[0], c.size[1], @_step],
        position: c.position
        action: {
          mouseover: -> action.color(0, 0, 0, 0.2)
          mouseout: -> action.color(0, 0, 0, 0)
          click: => @_rotate(c.vector)
        }
      })
      @_controls.push action
      action.color(0, 0, 0, 0)

  dispose: ->
    @_controls.forEach (c)-> dispose()
    @_controls = []
    super

  _rotate: (vector, angle = Math.PI, steps = 30)->
    @_rotation_animations.push {
        vector: vector
        steps: steps
        step: angle/steps
      }

  _rotation_check: ->
    if not @_rotation_animation
      if @_rotation_animations.length is 0
        return false
      @_rotation_animation = @_rotation_animations.shift()
    @mesh.rotate(@_rotation_animation.vector, @_rotation_animation.step, BABYLON.Space.WORLD)
    @_rotation_animation.steps--
    if @_rotation_animation.steps is 0
      @_rotation_animation = null
    return true
