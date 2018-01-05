random = (min, max, round = false)->
  r = Math.random() * (max - min) + min
  if !round
    return r
  Math.floor(r)

sound = new Howl({
  # src: ['source/z.webm', 'source/z.mp3']
  src: ['source/z-long.wav']
})
play = (callback=->)->
  duration = sound.duration()
  ratio = random(0.5, 4)
  duration_total = duration / ratio
  in_out = duration_total / 10
  length = random(in_out * 2, duration_total / 2)
  start = random(0, duration_total - length - in_out * 2)
  console.info length, start, ratio
  s = sound.play()
  sound.seek start * ratio, s
  sound.rate(ratio, s)
  sound.fade 0, 1, in_out * 1000, s
  setTimeout ->
    sound.fade 1, 0, in_out * 1000, s
    setTimeout ->
      sound.stop(s)
      callback()
    , in_out * 1000
  , (start + length - in_out) * 1000

background = (callback=->)->
  duration = sound.duration()
  ratio = random(0.5, 1)
  s = sound.play()
  sound.rate ratio, s
  sound.once 'end', callback, s


sound.once 'load', ->
  background_music = -> background(background_music)
  background_music()
  main_play = ->
    setTimeout (-> play(main_play)), random(1, 20) * 1000
  main_play()
  # play()
