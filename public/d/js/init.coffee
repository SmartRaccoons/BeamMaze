
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
  events: new MicroEvent()
  classes: {}
  lang:
    active: 'lv'
    strings:
      'en': {}
      'lv': {}
