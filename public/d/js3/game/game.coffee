window.o.Game = class Game extends MicroEvent
  constructor: ->
    scene = new (THREE.Scene)
    camera = new (THREE.PerspectiveCamera)(75, 1, 0.1, 1000)
    camera.position.z = 10
    renderer = new (THREE.WebGLRenderer)
    resized = =>
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix()
      renderer.setSize window.innerWidth, window.innerHeight
    window.addEventListener 'resize', resized
    resized()
    document.body.appendChild renderer.domElement
    hemiLight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 0.6 )
    hemiLight.color.setHSL( 0.6, 1, 0.6 )
    hemiLight.groundColor.setHSL( 0.095, 1, 0.75 )
    hemiLight.position.set( 0, 5, 0 )
    scene.add( hemiLight )
    animate = ->
      renderer.render scene, camera
      requestAnimationFrame animate
    animate()
    window.App.events.trigger('game:init', scene, camera)

  load: (id)->
    if @map
      @map.remove()
    @map = new window.o.GameMap()
    @map.load(window.o.GameMapData[id - 1], _l('stage_desc')[id])
