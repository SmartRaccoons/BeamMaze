window._l = (key, subparams) ->
  res = App.lang.strings[App.lang.active][key]
  if subparams
    res = res.replace(/\\?\{([^{}]+)\}/g, (match, name) ->
      if match.charAt(0) == '\\'
        return match.slice(1)
      if subparams[name] != null then subparams[name] else ''
    )
  res

window.App =
  lang:
    active: 'en'
    strings:
      'en': {}