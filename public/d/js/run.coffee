
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
  App.router = new window.o.ViewRouter(_.extend({
    game_last: parseInt(App.user.get('game_last') or 1)
    sound: App.user.get('sound') or 'on'
    game_completed: parseInt(App.user.get('game_completed') or 1)
    game_save: -> App.user.save({game_last: App.router.game_last, game_completed: App.router.options.game_completed})
  }, App.platform_router_param)).render()
  App.router.$el.appendTo('body')

  App.router.bind 'sound', (volume)->
    App.user.save({sound: volume})
    App.events.trigger 'router:sound', volume

  App.router.bind 'share', (from)->
    App.events.trigger 'router:share', from

  App.events.trigger 'router:init'

  App.router.run()
