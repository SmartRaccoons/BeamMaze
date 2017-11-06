


window.o.Game = class Game extends MicroEvent

  constructor: (options)->
    @options = options
    @_before_render_fn = []
    @_map = new window.o.GameMap()
    @_map.bind 'beam', (mirrors)=>
      if @_map.solved
        @_map.remove_controls()
        @trigger 'solved', mirrors
    @_map.bind 'rotate', => @trigger 'rotate'

  _render_loop: ->

  _render_before_loop: ->
    @_map.render()

  render: ->
    @canvas = document.createElement('canvas')
    @options.container.append(@canvas)
    engine = @_engine = new BABYLON.Engine(@canvas, true)
    engine.runRenderLoop =>
      @_render_loop()
      scene.render()
    window.addEventListener 'resize', ->
      engine.resize()

    scene = @_scene = new BABYLON.Scene(engine)
    scene.registerBeforeRender @_render_before_loop.bind(@)
    scene.clearColor = new BABYLON.Color4(0, 0, 0, 0)
    @_camera = camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 100, BABYLON.Vector3.Zero(), @_scene)
    @_camera.setPosition(new BABYLON.Vector3(0, 0, -150))
    @_light = new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-40, 60, -100), @_scene)
    window.App.events.trigger('game:init', scene, engine, @_light, @_camera)

  load_map: (id, callback)->
    setTimeout =>
      if window.o.GameMapData[id - 1].length < 20
        @_camera.setPosition(new BABYLON.Vector3(0, 0, -100))
      else if window.o.GameMapData[id - 1].length < 50
        @_camera.setPosition(new BABYLON.Vector3(0, 0, -120))
      @_map.load(window.o.GameMapData[id - 1])
      callback()
    , 1000

  remove: ->
    @_map.remove()
    @_camera.dispose()
    @_light.dispose()
    @_scene.dispose()
    @_engine.stopRenderLoop()
    @_engine.dispose()
    @canvas.parentElement.removeChild(@canvas)
