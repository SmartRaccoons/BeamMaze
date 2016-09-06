
map = (size, mirrors_total, source, target)->

  map = []
  for y in [0...size]
    map_x = []
    for x in [0...size]
      if y is source[1] and x is source[0]
        map_x.push('s')
      else if y is target[1] and x is target[0]
        map_x.push('t')
      else
        map_x.push('')
    map.push(map_x)

  random = -> Math.floor(Math.random() * size)
  angle_cal = (p1, p2=[0,0])->
    a = Math.atan2(p1[1] - p2[1], p1[0] - p2[0])
    if a < 0
      a = 2*Math.PI + a
    Math.round((a * 180/Math.PI) * 10)/10

  mirrors = []
  i = 0
  while i <= mirrors_total
    if i is mirrors_total
      x = target[0]
      y = target[1]
    else
      x = random()
      y = random()
    if map[y][x] is '' or i is mirrors_total
      mirror_prev = if mirrors.length > 0 then mirrors[mirrors.length - 1] else null
      if mirror_prev
        map[mirror_prev[1]][mirror_prev[0]] = 'm' + ((angle_cal([x - mirror_prev[0], mirror_prev[1] - y]) + angle) / 2) + ';' + i
        angle = angle_cal([mirror_prev[0] - x, y - mirror_prev[1]])
      else
        map[source[1]][source[0]] = 's' + angle_cal([x - source[0], source[1] - y])
        angle = angle_cal([source[0] - x, y - source[1]])
      mirrors.push([x, y])
      i++
#  console.info map
  map
if window?
  window.MAP = map
map(10, 5, [3, 5], [9, 9])
