


window.o.Game = class Game extends MicroEvent

  constructor: ->
    super
    @_rendered = false
    @canvas = document.createElement('canvas')
    @_engine = new BABYLON.Engine(@canvas, true)
    window.addEventListener 'resize', => @_engine.resize()
    @

  render: (options)->
    options.container.append(@canvas)
    @_engine.resize()
    @_engine.runRenderLoop =>
      @_map.render_before()
      @_scene.render()
      @_map.render_after()
    @_map = new window.o.GameMap()
    moves = 0
    @_map.bind 'move', =>
      moves++
      @trigger 'move', moves
    @_map.bind 'beam', (mirrors)=>
      if @_map.solved
        @_map.remove_controls()
        @trigger 'solved', mirrors
        return


    @_scene = new BABYLON.Scene(@_engine)
    @_scene.clearColor = new BABYLON.Color4(0, 0, 0, 0)
    @_camera = camera = new BABYLON.ArcRotateCamera("Camera", 0, 0, 100, BABYLON.Vector3.Zero(), @_scene)
    @_camera.setPosition(new BABYLON.Vector3(0, 0, -150))
    @_light = new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-30, 30, -50), @_scene)
    window.App.events.trigger('game:init', @_scene, @_engine, @_light, @_camera)

    map_size = @_map.load(window.o.GameMapData[options.stage - 1], _l('stage_desc')[options.stage])
    max_size = Math.max(map_size[0], map_size[1])
    window.App.events.trigger 'map:animation', 'camera_anime', (m, steps)=>
      if steps is 0
        return @_camera.setPosition(new BABYLON.Vector3(0, 0, -60 - 20 * max_size))
      @_camera.setPosition(new BABYLON.Vector3(0, 0, -200 * Math.sin((1-m) * Math.PI/2) - 60 - 20 * max_size))
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
