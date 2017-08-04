
App.user = new UniversalApi({
  session: Cookies.get('session')
  app_id: 1
})

App.user.authorize (user)->
  if !user.session
    return new window.o.ViewPopup({
      content: _l('Authorize error')
      close: false
    })
  Cookies.set('session', App.user.session())
  App.router = new window.o.ViewRouter({
    user: App.user.data('type') or 'free' #free, shared, full
    # close: -> alert('close')
    author_link: false
    user_types: {free: 20, shared: 30}
    game_last: parseInt(App.user.data('game_last') or 1)
    game_save: (stage)-> App.user.data('game_last', stage)
  })

  App.router.bind 'share-last', ->
    alert 'share last'
    App.events.trigger 'router:share', 'last'
  App.router.bind 'share-user', (from)->
    App.user.data('type', 'shared')
    App.router.options.user = 'shared'
    App.router.game()
    App.events.trigger 'router:share', from
  App.router.bind 'buy', (from, popup_type)->
    App.user.data('type', 'full')
    App.router.options.user = 'full'
    App.router.game()
    App.events.trigger 'router:buy', from, popup_type

  App.events.trigger 'router:init'

  App.router.run()
