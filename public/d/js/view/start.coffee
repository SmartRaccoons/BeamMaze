window.o.ViewStart = class start extends window.o.View
  className: 'start'
  template: """
    <h1>Raccoobe</h1>
        <nav>
          <ul>
           <li><button>#{_l('Continue')}</button></li>
           <li><button>#{_l('Choose stage')}</button></li>
           <% if (close) { %>
            <li><button>#{_l('Quit')}</button></li>
          <% } %>
         </ul>
        </nav>
        <a target='_parent' href='http://raccoons.lv'>#{_l('Credits')}</a>
  """

  events:
    'click li:nth-child(1) button': -> @trigger 'continue'
    'click li:nth-child(2) button': -> @trigger 'stages'
    'click li:nth-child(3) button': -> @options.close()
