


window.Game = class Game extends MicroEvent

  constructor: (options)->
    @options = options
    @_before_render_fn = []
    @_map = new window.o.Map()
    @_map.bind 'beam', =>
      if @_map.solved
        alert 'solved'

  _render_loop: ->

  _render_before_loop: ->
    @_map.render()

  render: ->
    canvas = document.createElement('canvas')
    document.body.appendChild(canvas)
    engine = new BABYLON.Engine(canvas, true)
    engine.runRenderLoop =>
      @_render_loop()
      scene.render()
    window.addEventListener 'resize', ->
      engine.resize()

    scene = @_scene = new BABYLON.Scene(engine)
    scene.registerBeforeRender @_render_before_loop.bind(@)
    @_camera = camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 100, BABYLON.Vector3.Zero(), @_scene)
    @_camera.setPosition(new BABYLON.Vector3(0, 0, -150))
#    @_light = new BABYLON.SpotLight('Light', new BABYLON.Vector3(-10, 10, -50), new BABYLON.Vector3(0, 0, 0), 1, 20, @_scene)
    # @_light = new BABYLON.DirectionalLight('Light', new BABYLON.Vector3(10, -10, 10), @_scene)
    # @_light.position = new BABYLON.Vector3(-100, 100, -50)
    @_light = new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-40, 60, -100), @_scene)
    window.App.events.trigger('game:init', scene, engine, @_light, @_camera)
    @load_map()

  load_map: ->
    setTimeout =>
      @_map.load(window.MAPS[0])
    , 100
