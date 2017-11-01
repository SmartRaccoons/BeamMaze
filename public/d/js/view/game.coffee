game = new window.o.Game()

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
    @load()

  load: ->
    game.clear()
    game.bind 'solved', =>
      @trigger 'solved', {seconds_total: @_time()}
      setTimeout =>
        @trigger 'next'
      , 1000

    game.render({container: @$('.game-container')})
    game.load_map @options.stage
    @_timer_start = new Date().getTime()

  _time: -> Math.round((new Date().getTime() - @_timer_start) / 1000)

  remove: ->
    game.clear()
    super
