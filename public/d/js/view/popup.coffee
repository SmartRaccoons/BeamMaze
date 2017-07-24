window.o.ViewPopup = class Popup extends window.o.View
  className: 'popup'
  template: """
    <div>
      <% if(typeof title !== "undefined"){%>
        <h1><%- title %></h1>
      <% } %>
      <div class='popup-content'>
        <%= content %>
      </div>
      <% if(typeof actions !== "undefined"){%>
        <nav>
        <% actions.forEach(function (action, i) { %>
          <button data-action='<%= i %>'><%- Array.isArray(action) ? action[0] : action %></button>
        <% }); %>
        </nav>
      <% } %>
      <% if (options.close){ %>
        <button class='popup-close'></button>
      <% } %>
    </div>
  """
  events:
    'click .popup-close': -> @remove()
    'click button[data-action]': (e)->
      action = @options.actions[$(e.target).attr('data-action')]
      if Array.isArray(action)
        action[1]()
      if @options.actions_leave
        @remove()

  constructor: ->
    @options =
      parent: $('.container')
      close: true
      actions_leave: true
    super
