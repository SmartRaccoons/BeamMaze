App.events.bind 'router:init', ->
  ga_wrap = (f)->
    try
      f.apply(this, arguments)
    catch e

  ga_wrap ->
    ga('create', 'UA-24527026-16', 'auto')
    if App.user.user and App.user.user.id
      ga('set', '&uid', App.user.user.id)
    ga('set', 'contentGroup1', App.version_media)
    ga('set', 'appVersion', App.version)


  GameAnalytics("setEnabledInfoLog", App.version_dev)
  GameAnalytics("setEnabledVerboseLog", App.version_dev)

  GameAnalytics("configureBuild", "#{App.version_media}.#{App.version}")
  if App.user.user and App.user.user.id
    GameAnalytics("configureUserId", "#{App.user.user.id}")
  GameAnalytics("initialize", "6cbc7e51b3786c24cc780fcd1fe367a2", "697a173d885cd4063e50a81f7da2466b2e1dd139")

  ga_track_view = (view)-> ga_wrap -> ga('send', 'pageview', view)
  progression = (event, id, seconds)->
    GameAnalytics("addProgressionEvent", event, "level" + (if id < 10 then "0#{id}" else id), "", "", seconds)
    ga_track_view(['game', id, event].join('/'))

  App.events.bind 'router:game', (id)->
    progression('Start', id)
  App.events.bind 'router:game-solved', (id, data)->
    progression('Complete', id, data.seconds_total)
  App.events.bind 'router:game-reset', (id, data)->
    progression('Fail', id, data.seconds_total)

  App.events.bind 'router:start', -> ga_track_view('start')
  App.events.bind 'router:credits', -> ga_track_view('credits')

  # App.events.bind 'router:buy', (from, type)->
  #   GameAnalytics("addBusinessEvent", "EUR", 99, "game", "full", "#{from}:#{type}")
  #   ga_wrap -> ga('send', 'pageview', ['buy', from, type].join('/'))

  App.events.bind 'router:sound', (volume)->
    GameAnalytics("addDesignEvent", "sound:#{volume}")
    ga_track_view(['sound', volume].join('/'))

  App.events.bind 'router:share', (from)->
    GameAnalytics("addDesignEvent", "share:#{from}")
    ga_track_view(['share', from].join('/'))
