window.o.GameMap = class Map extends MicroEvent
  constructor: ->
    @clear()
    @_before_render_fn = []
    super

  clear: ->
    @_blank = []
    @_mirror = []
    @_platform = []
    @_rotations = null
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
        @[methods[method]]([x * 10, y * 10])

    map = map_string.split("\n").map (s)-> s.trim().split('')
    middle = Math.floor(map[0].length/2)
    map.forEach (row, y)->
      row.forEach (cell, x)->
        call(cell, x - middle, -y + middle)

  remove_controls: ->
    @_platform.forEach (ob)-> ob.remove_controls()

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

  render: ->
    if @_before_render_fn.length > 0
      @_before_render_fn.pop()()
    if @_mirror.length is 0
      return
    changes = false
    if @_rotations isnt changes
      @_rotations = changes
      if changes
        @_source.beam_remove()
      else
        @_before_render_fn.push =>
          @_source.beam()
          @solved = @_source.solved
          @trigger 'beam', @_source._mirror.length

  beam_source: (coors)-> @_source = new window.o.ObjectBeamSource({position: [coors[0], coors[1], -0.55 * 4.2]})

  target: (coors)-> @_target = new window.o.ObjectBeamTarget({position: [coors[0], coors[1], -0.55 * 4.2]})

  blank: (coors)-> @_blank.push new window.o.ObjectBlank({pos: coors})

  mirror_reverse: (coors)-> @_mirror.push new window.o.ObjectMirror({pos: [coors[0], coors[1]], reverse: true})

  mirror: (coors)-> @_mirror.push new window.o.ObjectMirror({pos: [coors[0], coors[1]]})

  obstacle: (parent, coors)->
