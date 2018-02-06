


window.o.Game = class Game extends MicroEvent

  constructor: ->
    super
    @_rendered = false
    @canvas = document.createElement('canvas')
    @_engine = new BABYLON.Engine(@canvas, true)
    window.addEventListener 'resize', => @_engine.resize()
    @

  render: (options)->
    options.container.appendChild(@canvas)
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
    @_camera = new BABYLON.ArcRotateCamera('camera', 0, 0, 0, BABYLON.Vector3.Zero(), @_scene)
    @_light = new BABYLON.HemisphericLight('Light', new BABYLON.Vector3(-50, 50, -80), @_scene)
    window.App.events.trigger('game:init', @_scene, @_engine, @_light, @_camera)
    map_size = @_map.load(window.o.GameMapData[options.stage - 1], _l('stage_desc')[options.stage])
    @_camera_animation(-60 - 20 * Math.max(map_size[0], map_size[1]))
    @_rendered = true

  _camera_animation: (z)->
    @_camera.setPosition(new BABYLON.Vector3(0, 0, -100 + z))
    window.App.events.trigger 'map:animation', 'camera_anime', false, 30, false, 'sin', {
      position: new BABYLON.Vector3(0, 0, z)
      object: @_camera
      fn: (position)=> @_camera.setPosition(BABYLON.Vector3.FromArray(position))
      callback: => @_camera_little_moving(z)
    }

  _camera_little_moving: (z)->
    r = -> (Math.random() - 0.5) * 10
    window.App.events.trigger 'map:animation', 'camera_anime', false, 200, false, 'linear', {
      position: new BABYLON.Vector3(r(), r(), z)
      object: @_camera
      fn: (position)=> @_camera.setPosition(BABYLON.Vector3.FromArray(position))
      callback: => @_camera_little_moving(z)
    }

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
