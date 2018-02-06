window.MicroEvent = class Events
  constructor: ->
    @_events = {}

  bind: (event, fct) ->
    @_events[event] = @_events[event] or []
    @_events[event].push fct

  unbind: (event, fct) ->
    if not event
      return @_events = {}
    if not fct
      return delete @_events[event]
    if not @_events[event]
      return
    @_events[event].splice @_events[event].indexOf(fct), 1

  trigger: (event) ->
    if not @_events[event]
      return
    args = Array::slice.call(arguments, 1)
    @_events[event].forEach (fn)=> fn.apply @, args

  remove: ->
    @trigger 'remove'
    @unbind()


window._l = (key, subparams) ->
  res = App.lang.strings[App.lang.active][key]
  if subparams
    res = res.replace(/\\?\{([^{}]+)\}/g, (match, name) ->
      if match.charAt(0) == '\\'
        return match.slice(1)
      if subparams[name] != null then subparams[name] else ''
    )
  res

window.o = {}

window.App =
  version: document.body.getAttribute('data-version')
  version_dev: document.body.getAttribute('data-version') is 'dev'
  version_media: 'web'
  events: new MicroEvent()
  session: {
    get: -> Cookies.get('session')
    set: -> Cookies.set('session', App.user.session())
  }
  platform_router_param: {}
  lang:
    strings:
      'en': {}
      'lv': {}
    active: do ->
      return if window.location.href.indexOf('lang=lv')>-1 then 'lv' else 'en'
