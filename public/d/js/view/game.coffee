window.o.ViewGame = class Game extends window.o.View
  className: 'game'
  template: """
        <div class='game-container'></div>
        <span class='game-timer'></span>
        <span class='game-step'></span>
        <div class='game-controls'>
          <button class='game-controls-pause'>#{_l('Pause')}</button>
          <button class='game-controls-reset'>#{_l('Reset')}</button>
        </div>
        <div class='game-curtain'></div>
  """

  events:
    'click .game-controls-pause': ->
      @$el.toggleClass('game-paused')
      @_timer_stop()
    'click .game-curtain': ->
      @_timer_start()
      @$el.toggleClass('game-paused')
    'click .game-controls-next': -> @trigger 'next'
    'click .game-controls-reset': ->
      @trigger 'reset', {seconds_total: @_time().seconds_total}

  constructor: ->
    super
    @$timer = @$('.game-timer')
    @$step = @$('.game-step')
    @$game_controls = @$('.game-controls')
    @$game_controls_reset = @$('.game-controls-reset')
    @_steps = 0
    @timer_diff = 0
    @load()

  load: ->
    if @game
      @_timer_stop()
      @game.remove()
    @game = new window.o.Game({
      container: @$('.game-container')
    })
    @game.bind 'rotate', => @step()
    @game.bind 'solved', (mirrors)=>
      @_timer_stop()
      t = @_time()
      t['steps'] = @_steps
      t['mirrors'] = mirrors
      @_completed(t)
      @trigger 'solved', t

    @game.render()
    @game.load_map @options.stage, => @_timer_reset()

  _digit: (t, hu)->
    t = t + ''
    if hu
      if t.length is 1
        return t + '00'
      if t.length is 2
        return t + '0'
      return t
    if t.length is 1
      return '0' + t
    return t

  _timer_start: ->
    @_timer_count = true
    @timer_start = new Date().getTime()
    @_timer_fn = setInterval =>
      t = @_time()
      @$timer.html([@_digit(t.minutes), @_digit(t.seconds)].join(':'))
    , 1000

  _timer_stop: ->
    @_timer_count = false
    @timer_diff = new Date().getTime() - @timer_start + @timer_diff
    clearTimeout(@_timer_fn)

  _time: ->
    diff = if @_timer_count then (new Date().getTime() - @timer_start + @timer_diff) else @timer_diff
    data = {}
    data['mls'] = diff % 1000
    diff = (diff - data['mls']) / 1000
    data['seconds'] = diff % 60
    diff = diff - data['seconds']
    data['minutes'] = diff / 60
    data['seconds_total'] = data['minutes'] * 60 + data['seconds']
    data

  _timer_reset: ->
    @_steps = -1
    @step()
    @_timer_stop()
    @timer_diff = 0
    @$timer.html('00:00')
    @_timer_start()

  _completed: (t)->
    @$game_controls.html "<button class='game-controls-next'>#{_l('Next level')}</button>" +
     _l('Completed', _.extend(t, {
      minutes: @_digit(t['minutes'])
      seconds: @_digit(t['seconds'])
      mls: @_digit(t['mls'], 3)
    }))

  step: ->
    @_steps++
    @$step.html(@_steps)

  remove: ->
    @_timer_stop()
    @game.remove()
    super
