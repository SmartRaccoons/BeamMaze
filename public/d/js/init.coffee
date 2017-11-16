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
  version: $('body').attr('data-version')
  version_dev: $('body').attr('data-version') is 'dev'
  events: new MicroEvent()
  classes: {}
  lang:
    strings:
      'en': {}
      'lv': {}
    active: (->
      return if window.location.href.indexOf('lang=en')>-1 then 'en' else 'lv'
    )()
