App.lang.active = 'lv'
App.session.get = ->
App.session.set = ->
App.platform_router_param = {
  share: true
}

App.events.bind 'router:init', ->
  App.router.bind 'share', (from)->
    App.user.share({
      title: 'Raccoobe'
      text: 'Atjautības spēlīte no Smart Raccoons. Nāc izmēģināt!'
      url: 'https://draugiem.lv/raccoobe'
    })
