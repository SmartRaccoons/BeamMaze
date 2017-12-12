map = '-102|91-22|-0008'
solution = '-102|91-22|-0008'
# '-': null
# '0': 'blank'
# '1': 'mirror'
# '2': 'mirror_reverse'
# '3': 'mirror_empty'
# '4': 'mirror_straight'
# '5': 'mirror_cross'
# '8': 'beam_source'
# '9': 'target'
_clone = (array)-> JSON.parse(JSON.stringify(array))
_combinations = (places, objects)->
  c = [0...places].map (v)-> [v]
  add = (c, l)->
    z = []
    for i in [0...c.length]
      for j in [0...l]
        if !(j in c[i])
          z.push c[i].concat(j)
    z
  for i in [0...(objects - 1)]
    c = add(c, places)
  c
_move = [[0, 1], [-1, 0], [0, -1], [1, 0]]
_permutations = (combs, deep)->
  c = []
  for i in [0..(1000 * 1000)]
    combination = i.toString(combs)
    if combination.length > deep
      break
    if combination.length < deep
      combination = '0000000000000000'.slice(0, deep-combination.length) + combination
    c.push combination
  return c

class Solve
  _mirrors: ['1', '2', '3', '4', '5']
  constructor: (o)->
    [map, mirrors, blanks] = @_map_to_array(o.map)
    maps = []
    _combinations(blanks.length, mirrors.length).forEach (places)=>
      m = _clone(map)
      places.forEach (p, i)->
        blank = blanks[p]
        mirror = mirrors[i]
        m[blank[0]][blank[1]] = mirror
      str = @_map_to_str(m)
      if !(str in maps) and o.map isnt str
        maps.push str
    solve = null
    notify_number = Math.round(maps.length/100)
    console.info "#{maps.length} maps"
    maps.forEach (m, i)=>
      if i % notify_number is 0
        console.info "#{Math.round(i*100/maps.length)}%"
      combination = @_solve m, o.solution, 5
      if combination and (!solve or (solve[0].length < combination.length))
        solve = [combination, m]
    console.info solve


  _solve: (map_str, map_solution, moves)->
    check = (map, mirrors)->
      mirrors.forEach (m)->
        for i in [0...4]
          p = (i + m.p) % 4
          x = m.coors[1] + _move[p][0]
          y = m.coors[0] + _move[p][1]
          if map[y] and map[y][x] and map[y][x].c is '0'
            m.move = true
            m.p = p
            return
        m.move = false
    move = (map, m, info=->)->
      if !m.move
        return false
      for i in [1..20]
        x = m.coors[1] + _move[m.p][0] * i
        y = m.coors[0] + _move[m.p][1] * i
        if !(map[y] and map[y][x] and map[y][x].c is '0')
          i--
          x = m.coors[1] + _move[m.p][0] * i
          y = m.coors[0] + _move[m.p][1] * i
          break
      [map[y][x], map[m.coors[0]][m.coors[1]] ] = [map[m.coors[0]][m.coors[1]], map[y][x] ]
      m.coors = [y, x]
      return true
    check_combination = (combination, map_str)=>
      [map, mirrors] = @_map_to_array(map_str)
      mirrors.forEach (m)-> map[m.coors[0]][m.coors[1]] = m
      check(map, mirrors)
      z = 0
      for c in combination.split('')
        z++
        move(map, mirrors[c])
        if @_map_compare(@_map_to_str(map), map_solution)
          return combination.slice(0, z)
        check(map, mirrors)
      return false
    [map, mirrors] = @_map_to_array(map_str)
    combination_right = null
    for combination in _permutations(mirrors.length, moves)
      result = check_combination(combination, map_str)
      if result and (!combination_right or combination_right.length > result.length)
        combination_right = result
    return combination_right

  _map_compare: (m1, m2)-> m1 is m2

  _map_to_array: (str)->
    map = []
    mirrors = []
    blanks = []
    str.split('|').map( (s)-> s.trim().split('') ).forEach (row, j)=>
      map[j] = []
      row.forEach (cell, i)=>
        if cell in @_mirrors
          mirrors.push({
            'c': cell
            'p': 0
            'coors': [j, i]
          })
          cell = '0'
        if cell is '0'
          blanks.push([j, i])
        map[j][i] = {
          'c': cell
        }
    [map, mirrors, blanks]

  _map_to_str: (map)->
    map.map( (row)->
      row.map( (c)-> c['c'] ).join('')
    ).join('|')

new Solve({map: map, solution: solution})
