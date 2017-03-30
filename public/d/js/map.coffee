window.o.Map = class Map extends MicroEvent
  constructor: ->
    @clear()
    @_before_render_fn = []
    super

  clear: ->
    @_mirror = []
    @_platform = []
    @_rotations = null
    @solved = false

  load: (map_string)->
    methods = {
      '-': null
      '0': null
      '1': 'mirror'
      '2': 'mirror_reverse'
      '8': 'beam_source'
      '9': 'target'
    }

    map = map_string.split("\n").map (s)->
      s.trim().split('').map (ob)-> ob
    @_map_size = size = map[0].length
    middle = Math.floor(size/2)
    for fn in Object.keys(methods)
      methods[fn] = ((name, fn)=>
        (parent=null, x=0, y=0)=>
          if fn
            params = [[x*10, y*10, 0]]
            if parent
              params.unshift(parent)
            @[fn].apply(@, params)
      )(fn, methods[fn])

    methods[map[middle][middle]]()
    map.reverse()
    for m in [0...size]
      methods[map[0][m]](null, m - middle, -middle - 1)
    map.shift()
    for m in [1..middle]
      parent = @platform(m * 10)
      for y in [-m..m]
        methods[map[(y + middle)][m + middle]](parent.mesh, m, y)
        methods[map[(y + middle)][-m + middle]](parent.mesh, -m, y)
      for x in [(-m+1)...m]
        methods[map[m + middle][x + middle]](parent.mesh, x, m)
        methods[map[-m + middle][x + middle]](parent.mesh, x, -m)

  unload: ->
    if @_source
      @_source.dispose()
    if @_target
      @_target.dispose()
    @_mirror.forEach (ob)-> ob.dispose()
    @_platform.forEach (ob)-> ob.dispose()
    @_clear()

  render: ->
    if @_before_render_fn.length > 0
      @_before_render_fn.pop()()
    if @_platform.length is 0
      return
    changes = @_platform.map( (ob)-> ob._rotation_check()).some (res)-> res
    if @_rotations isnt changes
      @_rotations = changes
      if changes
        @_source.beam_remove()
      else
        @_before_render_fn.push =>
          @_source.beam()
          @solved = @_source.solved
          @trigger 'beam'

  beam_source: (coors)-> @_source = new window.o.BeamSource({position: [coors[0], coors[1], -0.55 * 4.2]})

  target: -> @_target = new window.o.BeamTarget({position: [0, 0, -0.55 * 4.2]})

  platform: (size)->
    ob = new window.o.Platform({size: size})
    @_platform.push ob
    return ob

  mirror_reverse: (parent, coors)-> @_mirror.push new window.o.Mirror({pos: [coors[0], coors[1]], parent: parent, reverse: true})

  mirror: (parent, coors)-> @_mirror.push new window.o.Mirror({pos: [coors[0], coors[1]], parent: parent})

  obstacle: (parent, coors)->
