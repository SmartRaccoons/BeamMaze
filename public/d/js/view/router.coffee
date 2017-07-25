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
    @game_stages_limit = @options.user_types
    @game_last = @options.game_last
    if @game_last is 1
      @game()
    else
      @start()
    @

  start: ->
    @_load('start', {close: @options.close})
    @_active.bind 'continue', => @game()
    @_active.bind 'stages', => @stages()

  stages: ->
    @_load('stages', {stages: @game_stages, last: @game_last})
    @_active.bind 'stage', (id)=> @game(id)

  _game_stage_available: (stage, callback)->
    if @options.user is 'full'
      return callback()
    if @options.user is 'shared' and @game_stages_limit.shared < stage
      return new window.o.ViewPopup({
          content: _l('Game shared over description', {levels: @game_last, price: '0,99 €'})
          actions: [
            [_l('Buy game shared', {price: '0,99 €'}), => @trigger 'buy']
          ]
        }).bind 'remove', (action)=>
          if !action
            @start()
    if @options.user is 'free' and @game_stages_limit.free < stage
      return new window.o.ViewPopup({
          content: _l('Game free over description', {levels: @game_last})
          actions: [
            [_l('Share'), => @trigger 'share-user']
            [_l('Buy game', {price: '0,99 €'}), => @trigger 'buy']
          ]
        }).bind 'remove', (action)=>
          if !action
            @start()
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

  game: (id = @game_last, check = true)->
    if check
      return @_game_stage_available id, => @game(id, false)
    @_load('game' + (if id is 1 then 'Help' else ''), {stage: id})
    @_active.bind 'solved', =>
      if id is @game_last and @game_last isnt @game_stages
        @game_last++
        @options.game_save(@game_last)
    @_active.bind 'next', =>
      if id isnt @game_last
        return @game(id + 1)
      if @game_last is @game_stages
        return @_game_completed()
      @game()
    @_active.bind 'reset', => @_active.load()

  _load: (view, options)->
    if @_active
      @_active.remove()
    @$back.css('display', if view is 'start' then 'none' else '')
    @_active = new window.o['View' + view.charAt(0).toUpperCase() + view.slice(1)](_.extend({parent: @$el}, options))
    @_active
