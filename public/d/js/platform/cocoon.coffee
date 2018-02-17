
# game = new window.o.Game()
# game.load(5)


r = new window.o.Router({level: 1})


#
# loader = new THREE.FontLoader()
#
# loader.load 'public/d/js/font.js', (font)=>
#   geometry = new THREE.TextGeometry( 'restārt', {
#     font: font,
#     size: 5,
#     height: 0.1,
#     curveSegments: 4,
#     bevelEnabled: true,
#     bevelThickness: 0.1,
#     bevelSize: 0.01
#   })
#   geometry.center()
#   geometry.computeBoundingBox()
#   material = new THREE.MeshPhongMaterial({color: 0x000000})
#   m = new THREE.Mesh(geometry, material)
#   x = geometry.boundingBox.max.x - geometry.boundingBox.min.x
#   y = geometry.boundingBox.max.y - geometry.boundingBox.min.y
#   box = new THREE.Mesh(new THREE.CubeGeometry(x, y, 0.1), new THREE.MeshLambertMaterial({color: 0xff00ff}))
#   console.info x, y
#   r.game.scene.add(m)
#   r.game.scene.add(box)
