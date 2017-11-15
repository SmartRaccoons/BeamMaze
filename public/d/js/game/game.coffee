


window.o.Game = class Game extends MicroEvent

  constructor: ->
    super
    @_rendered = false
    @canvas = document.createElement('canvas')
    @_engine = new BABYLON.Engine(@canvas, true)
    window.addEventListener 'resize', => @_engine.resize()
    @

  _render_loop: ->

  _render_before_loop: ->
    @_map.render()

  render: (options)->
    options.container.append(@canvas)
    @_engine.resize()
    @_engine.runRenderLoop =>
      @_render_loop()
      @_scene.render()
    @_map = new window.o.GameMap()
    @_map.bind 'beam', (mirrors)=>
      if not @_map.solved
        return
      @_map.remove_controls()
      @trigger 'solved', mirrors
    @_map.bind 'rotate', => @trigger 'rotate'

    @_scene = new BABYLON.Scene(@_engine)
    @_scene.registerBeforeRender @_render_before_loop.bind(@)
    @_scene.clearColor = new BABYLON.Color4(0, 0, 0, 0)
    @_camera = camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 100, BABYLON.Vector3.Zero(), @_scene)
    @_camera.setPosition(new BABYLON.Vector3(0, 0, -150))
    @_light = new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-40, 60, -100), @_scene)
    window.App.events.trigger('game:init', @_scene, @_engine, @_light, @_camera)

    map_size = @_map.load(window.o.GameMapData[options.stage - 1])
    max_size = Math.max(map_size[0], map_size[1])
    window.App.events.trigger 'map:animation', 'camera_anime', (m, steps)=>
      if steps is 0
        return @_camera.setPosition(new BABYLON.Vector3(0, 0, -80 - 20 * max_size))
      @_camera.setPosition(new BABYLON.Vector3(0, 0, -200 * Math.sin((1-m) * Math.PI/2) - 80 - 20 * max_size))
    , 20
    @_rendered = true

  clear: ->
    @unbind()
    if not @_rendered
      return
    @_rendered = false
    @_map.remove()
    @_camera.dispose()
    @_light.dispose()
    @_scene.dispose()
    @_engine.stopRenderLoop()
    @canvas.parentElement.removeChild(@canvas)
