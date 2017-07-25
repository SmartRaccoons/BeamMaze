

r = new window.o.ViewRouter({
  user: 'free' #free, shared, full
  # close: ->
  #   alert('close')
  user_types: {free: 2, shared: 3}
  game_last: 1
  game_save: (stage)->
    # console.info 'save stage: ' + stage
})

r.bind 'share-last', ->
  alert 'share last'
r.bind 'share-user', ->
  r.options.user = 'shared'
  r.game()
r.bind 'buy', ->
  r.options.user = 'full'
  r.game()
