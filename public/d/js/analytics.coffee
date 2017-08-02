App.events.bind 'router:init', ->
  ga_wrap = (f)->
    try
      f.apply(this, arguments)
    catch e

  ga_wrap ->
    ga('create', 'UA-24527026-16', 'auto')
    ga('set', '&uid', App.user.user.id)

  GameAnalytics("setEnabledInfoLog", App.version_dev)
  GameAnalytics("setEnabledVerboseLog", App.version_dev)

  GameAnalytics("configureBuild", "web #{App.version}")
  GameAnalytics("configureUserId", App.user.user.id)

  GameAnalytics("initialize", "6cbc7e51b3786c24cc780fcd1fe367a2", "697a173d885cd4063e50a81f7da2466b2e1dd139")

  progression = (event, id, seconds)->
    GameAnalytics("addProgressionEvent", event, "level" + (if id < 10 then "0#{id}" else id), "", "", seconds)
    ga_wrap -> ga('send', 'pageview', ['game', id, event].join('/'))

  App.events.bind 'router:game', (id)->
    progression('Start', id)
  App.events.bind 'router:game-solved', (id, data)->
    progression('Complete', id, data.seconds_total)
  App.events.bind 'router:game-reset', (id, data)->
    progression('Fail', id, data.seconds_total)

  App.events.bind 'router:start', ->
    ga_wrap -> ga('send', 'pageview', 'start')
  App.events.bind 'router:stages', ->
    ga_wrap -> ga('send', 'pageview', 'stages')

  App.events.bind 'router:buy', (from, type)->
    GameAnalytics("addBusinessEvent", "EUR", 99, "game", "full", "#{from}:#{type}")
    ga_wrap -> ga('send', 'pageview', ['buy', from, type].join('/'))

  App.events.bind 'router:share', (from)->
    GameAnalytics("addDesignEvent", "share:#{from}")
    ga_wrap -> ga('send', 'pageview', ['share', from].join('/'))
