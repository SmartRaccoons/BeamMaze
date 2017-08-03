Game = window.o.ViewGame

className = 'game-help'
window.o.ViewGameHelp = class GameHelp extends Game
  className: [Game.prototype.className, className].join(' ')

  constructor: ->
    @_timeouts = []
    super

  _tooltip: (txt, mesh, reverse=false, correction=30)->
    position = BABYLON.Vector3.Project(mesh.position,
      BABYLON.Matrix.Identity(),
      @game._scene.getTransformMatrix(),
      @game._camera.viewport.toGlobal(@$el.width(), @$el.height()))
    position.x = Math.round(position.x)
    position.y = Math.round(position.y)
    el = $("<span class='#{if reverse then 'game-tooltip-reverse' else 'game-tooltip'}'>#{txt}")
    @$el.append el
    el.css('top', position.y)
    @_t =>
      el.css((if reverse then "left" else "right"), if reverse then position.x + correction else @$el.width() - position.x + correction)
    , 10

  _t: (fn, timeout)->
    @_timeouts.push setTimeout(fn, timeout)

  _t_clear: -> @_timeouts.forEach (t)-> clearTimeout(t)

  _timer_start: ->
    source = @game._map._source.mesh
    mirror = @game._map._mirror[0].mesh
    window.platform = platform = @game._map._platform[0]
    vector = new BABYLON.Vector3(0, 1, 0)
    for i in [0..6]
      platform._controls[i].mesh.actionManager.actions.splice(0, 3)
    @_t (=> @_tooltip(_l('Light'), source, false)), 1000
    @_t (=> @_tooltip(_l('Mirror'), mirror, true)), 2000
    @_t =>
      @_tooltip(_l('Rotate platform'), platform._controls[7].mesh, false)
      blink = setInterval =>
        platform.blank_change(vector, true)
        @_t (=> platform.blank_change(vector, false)), 500
      , 1000
      @_timeouts.push blink
      @_t =>
        clearTimeout(blink)
        platform.blank_change(vector, false)
      , 4000
    , 3000
    super

  _completed: ->
    @_t_clear()
    @$el.removeClass className
    super

  remove: ->
    @_t_clear()
    super
