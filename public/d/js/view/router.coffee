window.o.ViewRouter = class Router extends window.o.View
  el: "<div class='container'>"
  template: """
    <button class='back-link'>#{_l('Menu')}</button>
  """
  events:
    'click .back-link': -> @start()

  constructor: ->
    super
    @$back = @$('.back-link')
    @_active = null
    @game_stages = window.o.GameMapData.length
    @game_stages_limit = {free: 2, shared: 3}
    @game_last = @_game_last_get()
    if @game_last is 1
      @game()
    else
      @start()
    @

  start: ->
    @_load('start', {close: @options.close})
    @_active.bind 'continue', =>
      @_game_stage_available => @game()
    @_active.bind 'stages', => @stages()

  stages: ->
    @_load('stages', {stages: @game_stages, last: @game_last})
    @_active.bind 'stage', (id)=> @game(id)

  _game_last_get: ->
    # @game_stages - 1
    3

  _game_stage_available: (callback)->
    if @options.user is 'full'
      return callback()
    if @options.user is 'shared' and @game_stages_limit.shared <= @game_last
      return new window.o.ViewPopup({
          content: _l('Game shared over description', {levels: @game_last, price: '0,99 €'})
          actions: [
            [_l('Buy game shared', {price: '0,99 €'}), => @trigger 'buy']
          ]
        }).bind 'remove', => @start()
    if @options.user is 'free' and @game_stages_limit.free <= @game_last
      return new window.o.ViewPopup({
          content: _l('Game free over description', {levels: @game_last})
          actions: [
            [_l('Share'), => @trigger 'share-user']
            [_l('Buy game', {price: '0,99 €'}), => @trigger 'buy']
          ]
        }).bind 'remove', => @start()
    return callback()

  _game_completed: ->
    new window.o.ViewPopup({
      title: _l('Game over')
      content: _l('Game over description')
      actions: [
        [_l('Share'), => @trigger 'share-last']
        _l('Share close')
      ]
      close: false
    }).bind 'remove', => @start()

  game: (id = @game_last)->
    @_load('game' + (if id is 1 then 'Help' else ''), {stage: id})
    @_active.bind 'solved', =>
    @_active.bind 'next', =>
      if id isnt @game_last
        return @game(id + 1)
      if @game_last is @game_stages
        return @_game_completed()
      @_game_stage_available =>
        @game_last++
        @game()
    @_active.bind 'reset', => @_active.load()

  _load: (view, options)->
    if @_active
      @_active.remove()
    @$back.css('display', if view is 'start' then 'none' else '')
    @_active = new window.o['View' + view.charAt(0).toUpperCase() + view.slice(1)](_.extend({parent: @$el}, options))
    @_active
