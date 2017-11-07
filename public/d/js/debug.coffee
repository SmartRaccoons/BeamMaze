window.o.GameMap = class GameMap extends window.o.GameMap
  remove_controls: ->


window.o.ViewRouter = class Router extends window.o.ViewRouter
  constructor: ->
    super

  run: -> @game(1)
