loading = do ->
  el = document.getElementById('loading')
  text = document.getElementById('loading-text')
  {
    remove: -> el.parentNode.removeChild(el)
    done: (p)-> text.innerText = "#{p}%"
  }
loading.done(55)
App.user = new UniversalApi({
  session: Cookies.get('session')
  app_id: 1
  url: 'http://uniapi.raccoons.lv/user.json'
})

App.user.authorize (user)->
  loading.done(95)
  loading.remove()
  if !user.session
    return new window.o.ViewPopup({
      content: _l('Authorize error')
      close: false
    })
  Cookies.set('session', App.user.session())
  game_completed = parseInt(App.user.data('game_completed') or 1)
  App.router = new window.o.ViewRouter({
    game_last: parseInt(App.user.data('game_last') or 1)
    game_completed: game_completed
    game_save: (stage)->
      if stage > game_completed
        game_completed = stage
        App.user.data('game_completed', stage)
      App.user.data('game_last', stage)
  })

  App.router.bind 'share', (from)->
    App.user.share({
      title: 'Spēlīte'
      text: 'Atjautības spēlīte no Smart Raccoons. Nāc izmēģināt!'
      url: 'https://draugiem.lv/raccoobe'
    })
    App.events.trigger 'router:share', from

  App.events.trigger 'router:init'

  App.router.run()
