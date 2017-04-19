
# g = new window.o.Game({
#   path: window.location.pathname.substr(0,window.location.pathname.lastIndexOf('/')) + '/d'
# })
# g.render()


r = new window.o.ViewRouter({
  user: 'shared' #free, shared, full
  # close: ->
  #   alert('close')
})

r.bind 'share-last', ->
  alert 'share last'
r.bind 'share-user', ->
  alert 'share user'
r.bind 'buy', ->
  alert 'buy'
