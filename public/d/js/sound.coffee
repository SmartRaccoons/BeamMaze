random = (min, max, round = false)->
  r = Math.random() * (max - min) + min
  if !round
    return r
  Math.floor(r)


class Sound
  _music_effects: ['e1', 'e2', 'e3']

  load: (callback)->
    @_sounds = {}
    _loaded = 0
    _total = 0
    @_music_effects.concat(['move', 'laser', 'background']).forEach (name)=>
      _total++
      @_sounds[name] = new Howl({
        src: ["d/sound/#{name}.webm", "sound/#{name}.mp3"]
        volume: 0.2
      })
      @_sounds[name].once 'load', ->
        _loaded++
        if _loaded is _total
          callback()

  _play_back: (name, callback)->
    ratio = random(0.5, 1)
    sound = @_sounds[name]
    s = sound.play()
    sound.rate ratio, s
    sound.once 'end', callback, s

  play: (name)->
    if @_mute
      return
    @_sounds[name].play()

  background: ->
    if @_mute
      return
    background_music = => @_play_back('background', background_music)
    background_music()
    effect = =>
      @_effect_timeout = setTimeout (=> @_play_back(@_music_effects[random(0, @_music_effects.length, true)], effect)), random(40, 200) * 1000
    effect()

  _play_stop: ->
    clearTimeout(@_effect_timeout)
    for k, v of @_sounds
      v.stop()

  volume: (volume)->
    @_mute = volume is 'off'
    if @_mute
      @_play_stop()
    else
      @background()


App.events.bind 'router:init', ->
  sound = new Sound()
  sound.load ->
    sound.volume(App.router.options.sound)
  App.events.bind 'router:sound', (volume)-> sound.volume(volume)
  App.events.bind 'router:game-solved', -> sound.play('laser')
  App.events.bind 'router:game-move', -> sound.play('move')
