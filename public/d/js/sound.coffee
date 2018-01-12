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
    ['move', 'laser', 'background1', 'background2'].forEach (name)=>
      _total++
      @_sounds[name] = new Howl({
        src: [ "d/sound/#{name}.mp3", "d/sound/#{name}.webm"]
        volume: 0.2
      })
      @_sounds[name].once 'load', ->
        _loaded++
        if _loaded is _total
          callback()

  _play_back: (name, callback)->
    ratio = random(0.7, 1.3)
    sound = @_sounds[name]
    s = sound.play()
    sound.rate ratio, s
    sound.once 'end', callback, s

  play: (name)->
    if @_mute
      return
    @_sounds[name].play()

  background: ->
    background_music = => @_play_back('background' + random(1, 3, true), background_music)
    background_music()

  volume: (volume)->
    @_mute = volume is 'off'
    for name, sound of @_sounds
      sound.mute(@_mute)


App.events.bind 'router:init', ->
  sound = new Sound()
  sound.load ->
    sound.volume(App.router.options.sound)
    sound.background()
  App.events.bind 'router:sound', (volume)-> sound.volume(volume)
  App.events.bind 'router:game-solved', -> sound.play('laser')
  App.events.bind 'router:game-move', -> sound.play('move')
