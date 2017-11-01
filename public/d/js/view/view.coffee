view_id = 0

window.o.View = class View extends MicroEvent
  className: null
  el: '<div>'
  template: ''
  events: {}

  constructor: (options)->
    super
    @options = _.extend(@options or {}, options)
    view_id++
    @_id = view_id
    @render(options)
    @

  render: (data = {})->
    @$el = $(@el).appendTo(@options.parent or document.body)
    if @className
      @$el.addClass(@className)
    if @template
      data.options = @options
      @$el.html(_.template(@template)(data))
    if @events
      for k, v of @events
        m = k.match /^(\S+)\s*(.*)$/
        @$el.on m[1] + '.delegateEvents' + @_id, m[2], _.bind v, @
    @

  remove: (params)->
    @trigger 'remove', params
    super
    @$el.off('.delegateEvents' + @_id)
    @$el.remove()

  $: (selector)->
    @$el.find(selector)
