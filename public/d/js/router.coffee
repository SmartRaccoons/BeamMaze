window.o.Router = class Router extends MicroEvent
  constructor: (options)->
    @level = options.level or 1
    @game = new window.o.Game()
    @game.bind 'solved', =>
      @level++
      setTimeout =>
        @game_level(@level)
      , 2 * 1000
    @game_level()

  game_level: ->
    @game.load(@level)
