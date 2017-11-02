window.o.GameMap = class Map extends MicroEvent
  _step_animation: 30
  constructor: ->
    @clear()
    @_before_render_fn = []
    super

  clear: ->
    @_blank = []
    @_mirror = []
    @_platform = []
    @_rotation = null
    @_rotation_animation = []
    @solved = false

  load: (map_string)->
    methods = {
      '-': null
      '0': 'blank'
      '1': 'mirror'
      '2': 'mirror_reverse'
      '8': 'beam_source'
      '9': 'target'
    }
    call = (method, x=0, y=0)=>
      if methods[method]
        @[methods[method]]([x, y])

    map = map_string.split("\n").map (s)-> s.trim().split('')
    middle = Math.floor(map[0].length/2)
    @_map = {}
    map.forEach (row, j)=>
      row.forEach (cell, i)=>
        y = -j + middle
        x = i - middle
        if not @_map[y]
          @_map[y] = {}
        @_map[y][x] = call(cell, x, y)

  remove_controls: ->

  remove: ->
    super
    if @_source
      @_source.remove()
    if @_target
      @_target.remove()
    @_blank.forEach (ob)-> ob.remove()
    @_mirror.forEach (ob)-> ob.remove()
    @_platform.forEach (ob)-> ob.remove()
    @clear()

  _animation: ->
    if @_rotation_animation.length is 0
      return false
    if @_rotation_animation[0].steps is 0
      @_rotation_animation.shift()
    # if not @_rotation_animation
    #   if @_rotation_animations.length is 0
    #     return false
    #   @_rotation_animation = @_rotation_animations.shift()
    # @mesh.rotate(@_rotation_animation.vector, @_rotation_animation.step, BABYLON.Space.WORLD)
    # @_rotation_animation.steps--
    # if @_rotation_animation.steps is 0
    #   @_rotation_animation.callback()
    #   @_rotation_animation = null
    return true

  render: ->
    if @_before_render_fn.length > 0
      @_before_render_fn.pop()()
    if @_mirror.length is 0
      return
    changes = @_animation()
    if @_rotation is changes
      return
    @_rotation = changes
    if changes
      return @_source.beam_remove()
    @_before_render_fn.push =>
      @_source.beam()
      @solved = @_source.solved
      @trigger 'beam', @_source._mirror.length

  beam_source: (coors)->
    @_source = new window.o.ObjectBeamSource({position: [coors[0] * 10, coors[1] * 10, -0.55 * 4.2]})
    @_source

  target: (coors)->
    @_target = new window.o.ObjectBeamTarget({position: [coors[0] * 10, coors[1] * 10, -0.55 * 4.2]})
    @_target

  blank: (coors)-> new window.o.ObjectBlank({pos: coors})

  mirror_reverse: (coors)-> @mirror(coors, reverse)

  mirror: (coors, reverse=false)->
    m = new window.o.ObjectMirror({pos: [coors[0], coors[1]], reverse: reverse})
    position = [m.mesh.position.x, m.mesh.position.y]
    m.bind 'move', (position)=>
      blank = @_map[m.position.y + position.y][m.position.x + position.x]
      @_map[m.position.y][m.position.x] = blank
      @_map[m.position.y + position.y][m.position.x + position.x] = m
      blank.move({x: -position.x, y: -position.y})
      m.move(position)
      @_mirror.forEach (m)=>
        for i in [0..3]
          nr = (m._move_position + i) % 4
          p = m.get_position(nr, true)
          if @_map[p.y] and @_map[p.y][p.x] and @_map[p.y][p.x]._switch
            m.set_position(nr)
            break
      # @_rotation_animation.push {
      #   steps: @_step_animation
      #   callback: (part)->
      #     m.position()
      # }
    @_mirror.push m
    m
