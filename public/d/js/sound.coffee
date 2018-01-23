random = (min, max, round = false)->
  r = Math.random() * (max - min) + min
  if !round
    return r
  Math.floor(r)


class Sound
  load: (callback)->
    @_sounds = {}
    _loaded = 0
    _total = 0
    ['move', 'laser'].forEach (name)=>
      _total++
      @_sounds[name] = new Howl({
        src: ["d/sound/#{name}.webm", "d/sound/#{name}.mp3"]
        volume: 0.3
      })
      @_sounds[name].once 'load', ->
        _loaded++
        if _loaded is _total
          callback()

  play: (name)->
    if @_mute
      return
    @_sounds[name].play()

  volume: (volume)->
    @_mute = volume is 'off'
    for name, sound of @_sounds
      sound.mute(@_mute)


App.events.bind 'router:init', ->
  sound = new Sound()
  sound.load ->
    sound.volume(App.router.options.sound)
  App.events.bind 'router:sound', (volume)-> sound.volume(volume)
  App.events.bind 'router:game-solved', -> sound.play('laser')
  App.events.bind 'router:game-move', -> sound.play('move')
