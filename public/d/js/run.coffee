
window.loading.done(95)
App.user = new UniversalApi({
  session: App.session.get()
  app_id: 1
  url: 'https://uniapi.raccoons.lv/user.json'
})

App.user.authorize (user)->
  window.loading.done(98)
  window.loading.remove()
  if !user.session
    return new window.o.ViewPopup({
      content: _l('Authorize error')
      close: false
    })
  App.session.set(App.user.session())
  game_completed = parseInt(App.user.data('game_completed') or 1)
  App.router = new window.o.ViewRouter(_.extend({
    game_last: parseInt(App.user.data('game_last') or 1)
    game_completed: game_completed
    game_save: (stage)->
      if stage > game_completed
        game_completed = stage
        App.user.data('game_completed', stage)
      App.user.data('game_last', stage)
  }, App.platform_router_param))

  App.router.bind 'share', (from)->
    App.events.trigger 'router:share', from

  App.events.trigger 'router:init'

  App.router.run()
