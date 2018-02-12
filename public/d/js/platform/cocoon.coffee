
game = new window.o.Game()
mirror = new window.o.ObjectMirror({position: [0, 1], type: 'normal', params: []})
mirror = new window.o.ObjectMirror({position: [1, 1], type: 'normal', params: []})
mirror = new window.o.ObjectMirror({position: [1, 2], type: 'reverse', params: []})
mirror = new window.o.ObjectMirror({position: [0, 2], type: 'reverse', params: []})
mirror = new window.o.ObjectMirror({position: [0, 3], type: 'straight', params: []})
mirror = new window.o.ObjectBeamTarget({position: [0, 40]})
# new window.o.ObjectBeam({
#   start: new THREE.Vector3(0, 10, 0)
#   end: new THREE.Vector3(0, -20, 0)
# })

# geometry = new THREE.BoxBufferGeometry( 20, 20, 20 )
# m = new THREE.Mesh( geometry, new THREE.MeshLambertMaterial( { color: Math.random() * 0xffffff } ) );
# m.position.y = 40
# mirror.scene().add(m)

b = new window.o.ObjectBeamSource({
  position: [0, 0, 2.2]
  meshes: game.scene.children
})
setTimeout =>
  b.beam()
, 2000
# setTimeout =>
#   b.beam_remove()
# , 4000

# setTimeout =>
#   m.move()
# , 2000
# setTimeout =>
#   m.remove()
# , 2500
# m._connector.angle(m._move_positions[3])

# m = new window.o.ObjectMirrorTube({color: [255, 255, 255]})

# new window.o.ObjectBlank({position: [0, 0, 0]})
# game.load(1)
# b = new window.o.ObjectBlank()

# setTimeout =>
#   b.remove()
# , 4000
