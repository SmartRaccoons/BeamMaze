window.o.GameMap = class Map extends MicroEvent
  _clear_ob: ['_mirror', '_blank', '_target', '_source', '_text']

  constructor: ->
    super
    @_clear_ob.forEach (n)=> @[n] = []
    @solved = false

  clear: ->
    super
    @_clear_ob.forEach (n)=> @[n] = []
    @solved = false

  load: (map_string, text)->
    methods = {
      '-': null
      '0': 'blank'
      '1': 'mirror_normal'
      '2': 'mirror_reverse'
      '3': 'mirror_empty'
      '4': 'mirror_straight'
      '5': 'mirror_cross'
      '8': 'beam_source'
      '9': 'target'
    }
    call = (method, x=0, y=0, params = [])=>
      if methods[method]
        @[methods[method]]([x, y], params)

    map = map_string.split('|').map (s)-> s.trim().split('')
    params = ['s', 'r']
    map_size = [Math.floor(map.reduce( ((max, v)-> Math.max(max, v.filter( (v)-> !(params in v)).length)), 0)/2), Math.floor(map.length/2)]
    @_map = {}
    map.forEach (row, j)=>
      found = 0
      params_found = []
      row.forEach (cell, i)=>
        y = -j + map_size[1]
        x = i - map_size[0] - found
        if cell in params
          params_found.push cell
          found += 1
          return
        if not @_map[y]
          @_map[y] = {}
        call(cell, x, y, params_found)
        params_found = []
        @_map[y][x] = cell
    # setTimeout =>
    #   @beam_show()
    # , 100
    # if text
    #   @_text.push new window.o.ObjectText({text: text, position: [0, map_size[1] * 10 + 10, -2.5]})
    return map_size

  position_check: ->
    @_mirror.forEach (m)=>
      for i in [0, 1, 2, 3]
        nr = (m._move_position + i) % 4
        p = m.get_move_position(nr, true)
        if @_map[p.y] and @_map[p.y][p.x] and @_map[p.y][p.x] is '0'
          m.set_move_position(nr)
          return
      m.set_move_position(null)

  beam_show: ->
    @_render_after_cl =>
      @position_check()
      @_source.forEach (s)-> s.beam()
      @solved = @_target.length is @_target.filter( (t)-> t.solved).length
      @trigger 'beam'

  beam_remove: ->
    @_target.forEach (t)-> t.reset()
    @_source.forEach (s)-> s.beam_remove()

  beam_source: (coors)->
    # @_source.push new window.o.ObjectBeamSource({position: [coors[0] * 10, coors[1] * 10, -0.55 * 4]})

  target: (coors)->
    # @_target.push new window.o.ObjectBeamTarget({position: [coors[0] * 10, coors[1] * 10, -0.55 * 4]})

  blank: (coors)->
    @_blank.push new window.o.ObjectBlank({position: coors})

  mirror: (coors, type, params)->
    @blank(coors)
    # m = new window.o[if 'r' in params then 'ObjectMirrorReverse' else 'ObjectMirror']({position: coors, type: type, params: params})
    # if m._static
    #   return
    # m.bind 'move', (position)=>
    #   @trigger 'move'
    #   @beam_remove()
    #   for i in [1..20]
    #     y = m.position.y + position.y * i
    #     x = m.position.x + position.x * i
    #     if !(@_map[y] and @_map[y][x] and @_map[y][x] is '0')
    #       i--
    #       y = m.position.y + position.y * i
    #       x = m.position.x + position.x * i
    #       break
    #   [@_map[m.position.y][m.position.x], @_map[y][x]] = [@_map[y][x], @_map[m.position.y][m.position.x]]
    #   m.move({x: position.x * i, y: position.y * i})
    #
    # m.bind 'move_end', => @beam_show()
    # @_mirror.push m

  mirror_normal: (coors, p)-> @mirror(coors, 'normal', p)
  mirror_reverse: (coors, p)-> @mirror(coors, 'reverse', p)
  mirror_empty: (coors, p)-> @mirror(coors, 'empty', p)
  mirror_straight: (coors, p)-> @mirror(coors, 'straight', p)
  mirror_cross: (coors, p)-> @mirror(coors, 'cross', p)

  remove_controls: ->
    @_mirror.forEach (m)-> m._controls_remove()

  remove: ->
    super
    @_clear_ob.forEach (n)=>
      while a = @[n].shift()
        a.remove()
    @clear()