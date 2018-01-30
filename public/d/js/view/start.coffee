window.o.ViewStart = class start extends window.o.View
  className: 'start'
  template: """
    <h1>Raccoobe</h1>
        <nav>
          <ul>
           <li><button data-action='continue'>#{_l('Continue')}</button></li>
           <% if(new_levels) {%>
            <li><button data-action='new_levels' data-count="<%= new_levels %>">#{_l('Uncompleted levels')}</button></li>
            <% } %>
           <% if (close) { %>
            <li><button data-action='close'>#{_l('Quit')}</button></li>
          <% } %>
         </ul>
        </nav>
        <span class='start-author'>#{_l('Credits')}<span>
  """

  events:
    'click .start-author': -> @trigger 'credits'

    'click li button': (e)->
      action = e.target.getAttribute('data-action')
      if action is 'close'
        return @options.close()
      @trigger action
