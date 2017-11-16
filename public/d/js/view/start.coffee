window.o.ViewStart = class start extends window.o.View
  className: 'start'
  template: """
    <h1>Raccoobe</h1>
        <nav>
          <ul>
           <li><button>#{_l('Continue')}</button></li>
           <!--<li><button>#{_l('Choose stage')}</button></li>-->
           <% if (close) { %>
            <li><button>#{_l('Quit')}</button></li>
          <% } %>
         </ul>
        </nav>
        <%= author_link ? "<a class='start-author' target='_parent' href='http://raccoons.lv'>" : "<span class='start-author'>" %>
        #{_l('Credits')}
        <%= author_link ? "</a>" : '<span>' %>
  """

  events:
    'click li:nth-child(1) button': -> @trigger 'continue'
    'click li:nth-child(2) button': -> @trigger 'stages'
    'click li:nth-child(3) button': -> @options.close()
