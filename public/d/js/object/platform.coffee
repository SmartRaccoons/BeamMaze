
window.o.Platform = class Platform extends window.o.ObjectBox
  _step: 10
  clear: ->
    @_controls = []
    @_blanks = {}
    @_blanks_position = {
      'l': []
      'r': []
      't': []
      'b': []
    }

  constructor: (options)->
    width = options.size * 2 + @_step
    super(_.extend({dimension: [width, width, 0]}, options))
    @color(0, 0, 0, 0)
    size = @options.size
    @_rotation_animations = []
    @clear()
    @blank_put new window.o.Blank({pos: [-size, size], parent: @mesh}), ['l', 't']
    @blank_put new window.o.Blank({pos: [-size, -size], parent: @mesh}), ['l', 'b']
    @blank_put new window.o.Blank({pos: [size, size], parent: @mesh}), ['r', 't']
    @blank_put new window.o.Blank({pos: [size, -size], parent: @mesh}), ['r', 'b']
    for s in [(-size + @_step)...size] by @_step
      @blank_put new window.o.Blank({pos: [-size, s], parent: @mesh}), ['l']
      @blank_put new window.o.Blank({pos: [size, s], parent: @mesh}), ['r']
      @blank_put new window.o.Blank({pos: [s, -size], parent: @mesh}), ['b']
      @blank_put new window.o.Blank({pos: [s, size], parent: @mesh}), ['t']

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
          mouseover: =>
            c._mouseover = true
            @blank_change(c.vector, true)
          mouseout: =>
            c._mouseover = false
            @blank_change(c.vector, false)
          click: =>
            @_rotate c.vector, =>
              @blank_change(c.vector, false)
              @blank_rotate(c.vector)
              if c._mouseover
                @blank_change(c.vector, true)
        }
      })
      @_controls.push action
      action.color(0, 0, 0, 0)

  blank_put: (blank, positions)->
    @_blanks[blank._id] = blank
    positions.forEach (p)=>
      @_blanks_position[p].push blank._id

  _blank_direction: (v)->
    d = []
    if v.x is 1
      d.push 't'
    if v.x is -1
      d.push 'b'
    if v.y is -1
      d.push 'r'
    if v.y is 1
      d.push 'l'
    d

  blank_change: (v, over)->
    direction = @_blank_direction(v)
    direction.forEach (d)=>
      @_blanks_position[d].forEach (id)=>
        @_blanks[id][if over then 'over' else 'out']()

  blank_rotate: (v)->
    direction = @_blank_direction(v)
    if direction.length > 1
      if v.x is v.y
        change = {
          't': 'r'
          'r': 't'
          'l': 'b'
          'b': 'l'
        }
      else
        change = {
          'b': 'r'
          'r': 'b'
          't': 'l'
          'l': 't'
        }
    else
      change = {
        't': 'b'
        'b': 't'
        'l': 'r'
        'r': 'l'
      }

    direction.forEach (d)=>
      [@_blanks_position[d], @_blanks_position[change[d]]] = [@_blanks_position[change[d]], @_blanks_position[d]]

  dispose: ->
    @_controls.forEach (c)-> dispose()
    @_clear()
    super

  _rotate: (vector, callback)->
    angle = Math.PI
    steps = 30
    @_rotation_animations.push {
        vector: new BABYLON.Vector3(vector.x, vector.y, vector.z)
        steps: steps
        step: angle/steps
        callback: callback
      }

  _rotation_check: ->
    if not @_rotation_animation
      if @_rotation_animations.length is 0
        return false
      @_rotation_animation = @_rotation_animations.shift()
    @mesh.rotate(@_rotation_animation.vector, @_rotation_animation.step, BABYLON.Space.WORLD)
    @_rotation_animation.steps--
    if @_rotation_animation.steps is 0
      @_rotation_animation.callback()
      @_rotation_animation = null
    return true
