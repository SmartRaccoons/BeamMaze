window.o.Game = class Game extends window.o.Game
  constructor: ->
    super
    @controls = new THREE.OrbitControls( @camera.get() )

    @scene.add(new THREE.AxesHelper(10))

  _resized: ->
    super
    if @controls
      @controls.update()
