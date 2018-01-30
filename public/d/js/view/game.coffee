game = null

window.o.ViewGame = class Game extends window.o.View
  className: 'game'
  template: """
        <div class='game-container'></div>
        <div class='game-controls'>
          <button class='game-controls-reset'>#{_l('Reset')}</button>
        </div>
  """

  events:
    'click .game-controls-reset': ->
      @trigger 'reset', {seconds_total: @_time()}

  constructor: ->
    super
    if !game
      game = new window.o.Game()
    @_timeouts = []

  render: ->
    super
    @load()
    @

  load: ->
    @_timeouts.forEach (t)-> clearTimeout(t)
    @_timeouts = []
    @$('.game-controls-reset').attr('data-level', @options.stage).css('display', 'none')
    game.clear()
    game.bind 'solved', => @_solved()
    game.render({stage: @options.stage, container: @$('.game-container')})
    game.bind 'move', (move)=>
      if move is 1 and @options.stage isnt 1
        @$('.game-controls-reset').css('display', '')
      @trigger 'move', move
    @_timer_start = new Date().getTime()

  _solved: ->
    @trigger 'solved', {seconds_total: @_time()}
    @_timeouts.push setTimeout =>
      @trigger 'next'
    , 2000

  _time: -> Math.round((new Date().getTime() - @_timer_start) / 1000)

  remove: ->
    game.clear()
    super
