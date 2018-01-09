window.o.ViewRouter = class Router extends window.o.View
  el: "<div class='container'>"
  template: """
    <button class='back-link'>#{_l('Menu')}</button>
    <button class='sound-switch' data-volume='<%= sound %>'></button>
  """
  events:
    'click .back-link': -> @start()
    'click .sound-switch': ->
      volume = if @$sound.attr('data-volume') is 'off' then 'on' else 'off'
      @$sound.attr('data-volume', volume)
      @trigger 'sound', volume

  constructor: ->
    super
    @$back = @$('.back-link')
    @$sound = @$('.sound-switch')
    @_active = null
    @game_stages = window.o.GameMapData.length
    @game_last = if @options.game_last > @game_stages then @game_stages else @options.game_last

  _new_levels: ->
    if @options.game_completed < @game_stages and @options.game_completed isnt @game_last
      return @game_stages - @options.game_completed
    return false

  run: ->
    if @_new_levels()
      return @start()
    @game()
    @

  start: ->
    App.events.trigger 'router:start'
    @_load('start', {
      close: @options.close
      new_levels: @_new_levels()
    })
    @_active.bind 'continue', => @game()
    @_active.bind 'new_levels', => @game(@options.game_completed)
    @_active.bind 'credits', =>
      @trigger 'router:credits'
      new window.o.ViewPopup({
        title: _l('Credits')
        content: _l('Credits description')
        actions: if !@options.share then [_l('Close')] else [
          [_l('Share'), => @trigger 'share', 'credits']
          _l('Share close')
        ]
        close: false
      })

  _game_completed: ->
    @game_last = 1
    @options.game_save(@game_last)
    new window.o.ViewPopup({
      title: _l('Game over')
      content: _l('Game over description')
      actions: if !@options.share then [_l('Close')] else [
        [_l('Share'), => @trigger 'share', 'last']
        _l('Share close')
      ]
      close: false
    }).bind 'remove', => @game()

  game: (id = @game_last)->
    App.events.trigger 'router:game', id
    @_load('game', {stage: id})
    @_active.bind 'solved', (data)=>
      App.events.trigger 'router:game-solved', id, data
      if id is @game_last and @game_last < @game_stages
        @game_last++
        @options.game_save(@game_last)
    @_active.bind 'next', =>
      if id < @game_last
        return @game(id + 1)
      if @game_last >= @game_stages
        return @_game_completed()
      @game()
    @_active.bind 'reset', (data)=>
      App.events.trigger 'router:game-reset', id, data
      @_active.load()
    @_active.bind 'move', (move)=> App.events.trigger 'router:game-move', move

  _load: (view, options)->
    if @_active
      @_active.remove()
    @$back.css('display', if view is 'start' then 'none' else '')
    @_active = new window.o['View' + view.charAt(0).toUpperCase() + view.slice(1)](_.extend({parent: @$el}, options))
    @_active._name = view
    @_active
