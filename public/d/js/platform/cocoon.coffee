
game = new window.o.Game()
m = new window.o.ObjectMirror({position: [0, 0], type: 'straight', params: []})
setTimeout =>
  m.move([1, 1])
, 5000
# m._connector.angle(m._move_positions[3])

# m = new window.o.ObjectMirrorTube({color: [255, 255, 255]})

# new window.o.ObjectBlank({position: [0, 0, 0]})
# game.load(1)
# b = new window.o.ObjectBlank()

# setTimeout =>
#   b.remove()
# , 4000
