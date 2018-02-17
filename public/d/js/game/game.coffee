window.o.Game = class Game extends MicroEvent
  constructor: ->
    super
    @scene = new (THREE.Scene)
    @camera = new window.o.GameCamera()
    @renderer = new THREE.WebGLRenderer({alpha: true})
    @renderer.setClearColor(0xefe4d1, 0)
    document.body.appendChild @renderer.domElement
    window.addEventListener 'resize', => @_resized()
    @_resized()

    do =>
      l = new THREE.DirectionalLight()
      l.position.set(-10, 50, 80 )
      @scene.add(l)

      hemiLight = new THREE.HemisphereLight(0xffffff, 0xffffff, 0.3)
      hemiLight.groundColor.setHSL( 1, 1, 1 )
      hemiLight.position.set(0, 0, 10)
      @scene.add( hemiLight )

    do =>
      ground = new THREE.Mesh(new THREE.PlaneBufferGeometry( 1000, 1000 ), new THREE.MeshPhongMaterial( { color: 0xefe4d1, specular: 0xfefefe } ))
      ground.position.set(0, 0, -100)
      @scene.add ground

    @render()
    window.App.events.trigger('game:init', @scene)
    @_event_raycaster = new THREE.Raycaster()
    document.addEventListener 'click', (event)=>
      object = @_event_get_class(event)
      if object
        object.events.click.call(object)
    document.addEventListener 'mousemove', (event)=>
      object = @_event_get_class(event)
      document.body.style.cursor = if object then 'pointer' else ''

  _event_get_class: (event)->
    @_event_raycaster.setFromCamera({
      x: (event.clientX / window.innerWidth) * 2 - 1
		  y: -(event.clientY / window.innerHeight) * 2 + 1
    }, @camera.get())
    for intersect in @_event_raycaster.intersectObjects(@scene.children, true)
      if intersect.object._class and intersect.object._class.events and intersect.object._class.events.click
        return intersect.object._class
    return false

  render: ->
    @renderer.render @scene, @camera.get()
    requestAnimationFrame => @render()

  _resized: ->
    @camera.resize(window.innerWidth, window.innerHeight)
    @renderer.setSize window.innerWidth, window.innerHeight

  load: (id)->
    if @map
      @map.remove()
    @camera.position_set([0, 0, 150])
    @map = new window.o.GameMap()
    params = @map.load(window.o.GameMapData[id - 1], _l('stage_desc')[id])
    @camera.position_calculate(params)
    @map.bind 'beam', =>
      if @map.solved
        @map.remove_controls()
        @trigger 'solved'
