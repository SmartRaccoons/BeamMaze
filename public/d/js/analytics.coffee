
App.events.bind 'router:init', ->
  ga('create', 'UA-24527026-16', 'auto')
  if App.user.user and App.user.user.id
    ga('set', '&uid', App.user.user.id)
  ga('set', 'contentGroup1', App.version_media)

  GameAnalytics("setEnabledInfoLog", App.version_dev)
  GameAnalytics("setEnabledVerboseLog", App.version_dev)

  GameAnalytics("configureBuild", "#{App.version_media}.#{App.version}")
  if App.user.user and App.user.user.id
    GameAnalytics("configureUserId", "#{App.user.user.id}")
  GameAnalytics("initialize", "6cbc7e51b3786c24cc780fcd1fe367a2", "697a173d885cd4063e50a81f7da2466b2e1dd139")

  progression = (event, id, seconds)->
    GameAnalytics("addProgressionEvent", event, "level" + (if id < 10 then "0#{id}" else id), "", "", seconds)
    ga('send', 'pageview', ['game', id, event].join('/'))
  track_view = (view)->
    ga('send', 'pageview', view)
  track_design = (view, action)->
    GameAnalytics("addDesignEvent", "#{view}:#{action}")
    ga('send', 'pageview', [view, action].join('/'))

  App.events.bind 'router:game', (id)-> progression('Start', id)
  App.events.bind 'router:game-solved', (id, data)-> progression('Complete', id, data.seconds_total)
  App.events.bind 'router:game-reset', (id, data)-> progression('Fail', id, data.seconds_total)

  App.events.bind 'router:start', -> track_view('start')
  App.events.bind 'router:credits', -> track_view('credits')

  # App.events.bind 'router:buy', (from, type)->
  #   GameAnalytics("addBusinessEvent", "EUR", 99, "game", "full", "#{from}:#{type}")
  #   ga_wrap -> ga('send', 'pageview', ['buy', from, type].join('/'))

  App.events.bind 'router:sound', (volume)-> track_design('sound', volume)

  App.events.bind 'router:share', (from)-> track_design('share', from)
