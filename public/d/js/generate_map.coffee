
map = (size, mirrors_total, source)->

  map = []
  for y in [0...size]
    map_x = []
    for x in [0...size]
      map_x.push('')
    map.push(map_x)
  map[source[1]][source[0]] = 's'

  random = -> Math.floor(Math.random() * size)
  angle_cal = (p1, p2=[0,0])->
    a = Math.atan2(p1[1] - p2[1], p1[0] - p2[0])
    if a < 0
      a = 2*Math.PI + a
    a

  round = (n)-> Math.round(n * 10000) / 10000

  random_angle = (n)-> Math.floor(Math.random() * 4) * (Math.PI / 4)

  check_mirror = (angle)->
    accept = [0, 1, -1]#, 0.70710, -0.70710]
    for a in accept
      if -0.01 < Math.sin(angle) - a < 0.01
        return true
    return false


  i = 0
  source_angles = []
  mirror_prev = source
  angle = null
  while i <= mirrors_total
    x = random()
    y = random()
    if map[y][x] isnt ''
      continue
    mirror_angle = angle_cal([x - mirror_prev[0], mirror_prev[1] - y])
    if angle
      mirror_angle = (mirror_angle + angle)/2
    if not check_mirror(mirror_angle)
      continue
    if i > 0
      map[mirror_prev[1]][mirror_prev[0]] = 'm' + [round(mirror_angle), round(random_angle(mirror_angle)), i].join(';')
    mirror_angle = angle_cal([x - source[0], source[1] - y])
    if i is 0 and not check_mirror(mirror_angle)
      continue
    if i isnt mirrors_total and check_mirror(mirror_angle)
      source_angles.push round(mirror_angle)
    angle = angle_cal([mirror_prev[0] - x, y - mirror_prev[1]])
    mirror_prev = [x, y]
    i++
  map[y][x] = 't'
  source_angles_correct = source_angles[0]
  source_angles = source_angles.sort()
  map[source[1]][source[0]] += source_angles.join(';') + ';' + source_angles.indexOf(source_angles_correct)
  console.info map
  map
if window?
  window.MAP = map
  return
map(10, 5, [3, 5], [9, 9])
