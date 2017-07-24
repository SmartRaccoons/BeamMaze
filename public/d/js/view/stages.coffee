window.o.ViewStages = class Stages extends window.o.View
  className: 'stages'
  template: """
    <nav>
      <ul>
        <% for(var i=0; i<stages; i++) {%>
        <% if(i % 9 == 0 && i > 0){
          if (i > last) { break; }
          %>
          </ul><ul>
        <% } %>
          <li data-id='<%= (i+1) %>'<% if(i >= last){ %> class='stages-locked'<% } %>><img src='stage/example.png' /></li>
        <% } %>
      </ul>
    </nav>
    <button class='stages-next'></button>
    <button class='stages-previous'></button>
  """

  events:
    'click .stages-next': -> @page(1)
    'click .stages-previous': -> @page(-1)
    'click li': (event)->
      @trigger 'stage', parseInt($(event.target).closest('li').attr('data-id'))

  constructor: ->
    super
    @total = @active = Math.ceil((@options.last + 1) / 9)
    if Math.ceil(@options.last / 9) isnt @total
      @active--
    @page(0)

  page: (move)->
    @active = @active + move
    @$el.attr('data-page', if @active is @total then 'last' else @active)
