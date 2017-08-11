
window.MicroEvent.prototype.remove = ->
  if this._events
    for ev, fn in this._events
      @unbind(ev, fn)

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
