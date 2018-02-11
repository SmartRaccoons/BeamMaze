window.o.Game = class Game extends MicroEvent
  constructor: ->
    super
    @scene = new (THREE.Scene)
    @camera = new (THREE.PerspectiveCamera)(75, 1, 0.1, 1000)
    @camera.position.z = 100
    @renderer = new THREE.WebGLRenderer({alpha: !true})
    # @renderer.setClearColor(0xffffff, 0)
    document.body.appendChild @renderer.domElement
    window.addEventListener 'resize', => @_resized()
    @_resized()

    # hemiLight = new THREE.HemisphereLight( 0xffffff, 0xffffff, 0.6 )
    # hemiLight.color.setHSL( 0.6, 1, 0.6 )
    # hemiLight.groundColor.setHSL( 0.095, 1, 0.75 )
    # hemiLight.position.set( 0, 0, 10 )
    # scene.add( hemiLight )

    l = new THREE.DirectionalLight()
    @scene.add(l)

    # l = new THREE.HemisphereLight()
    # scene.add(l)
    l.position.x = -50
    l.position.y = 50
    l.position.z = 80

    @render()
    window.App.events.trigger('game:init', @scene)

  render: ->
    @renderer.render @scene, @camera
    requestAnimationFrame => @render()

  _resized: ->
    @camera.aspect = window.innerWidth / window.innerHeight;
    @camera.updateProjectionMatrix()
    @renderer.setSize window.innerWidth, window.innerHeight

  load: (id)->
    if @map
      @map.remove()
    @map = new window.o.GameMap()
    map_size = @map.load(window.o.GameMapData[id - 1], _l('stage_desc')[id])
    # @camera.position.z = 60 + 20 * Math.max(map_size[0], map_size[1])
    @camera.position.z = 20 + 20 * Math.max(map_size[0], map_size[1])
