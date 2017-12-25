App.session.get = ->
App.session.set = ->

window.UniversalApi = class UniversalApiOffline extends UniversalApi
  authorize: (callback)-> callback({session: 'dummy-data'})

  session: -> false

  get: (v)->
    Cookies.get("data.#{v}")

  save: (ob, callback=->)->
    for k, v of ob
      Cookies.set("data.#{k}", v)
