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
    @game_last = if @options.game_last > @game_stages then @game_stages else @options.game_last

  run: ->
    if @game_last is 1
      @game()
    else
      @start()
    @

  start: ->
    App.events.trigger 'router:start'
    @_load('start', {close: @options.close, author_link: @options.author_link})
    @_active.bind 'continue', => @game()
    @_active.bind 'stages', => @stages()

  stages: ->
    App.events.trigger 'router:stages'
    @_load('stages', {stages: @game_stages, last: @game_last})
    @_active.bind 'stage', (id)=> @game(id)

  _game_stage_available: (stage, callback)->
    if @options.user is 'full'
      return callback()
    if @options.user is 'shared' and @options.user_types.shared < stage
      return new window.o.ViewPopup({
          content: _l('Game shared over description', {levels: @game_last, price: '0,99 €'})
          actions: [
            [_l('Buy game shared', {price: '0,99 €'}), => @trigger('buy', @_active._name, 'buy')]
          ]
        }).bind 'remove', (action)=>
          if !action
            @start()
    if @options.user is 'free' and @options.user_types.free < stage
      return new window.o.ViewPopup({
          content: _l('Game free over description', {levels: @game_last})
          actions: [
            [_l('Share'), => @trigger('share-user', @_active._name)]
            [_l('Buy game', {price: '0,99 €'}), => @trigger('buy', @_active._name, 'share')]
          ]
        }).bind 'remove', (action)=>
          if !action
            @start()
    return callback()

  _game_completed: ->
    return @start()
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
    App.events.trigger 'router:game', id
    # @_load('game' + (if id is 1 then 'Help' else ''), {stage: id})
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

  _load: (view, options)->
    if @_active
      @_active.remove()
    @$back.css('display', if view is 'start' then 'none' else '')
    @_active = new window.o['View' + view.charAt(0).toUpperCase() + view.slice(1)](_.extend({parent: @$el}, options))
    @_active._name = view
    @_active
