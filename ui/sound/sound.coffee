AudioContext = window.AudioContext or window.webkitAudioContext

load = (src, callback)->
  request = new XMLHttpRequest
  request.open 'GET', src, true
  request.responseType = 'arraybuffer'
  request.onload = -> callback request.response
  request.send()

load_buffer = (url, context, callback)->
  load url, (response)=>
    context.decodeAudioData response, (buffer)->
      if !buffer
        return
      callback(buffer)

class Sound
  constructor: (@options=options)->
    @source = @options.context.createBufferSource()
    @source.buffer = @options.buffer
    if @options.speed
      @source.playbackRate.value = @options.speed
    @source.connect(@options.context.destination)
    @source.onended = -> console.info 'ended'

  start: ->
    console.info @options.buffer.duration / @options.speed
    console.info @options.offset
    @source.start(0, @options.offset)

  stop: ->
    @source.stop(0)

  volume: (v)->
    if !@gain
      @gain = @options.context.createGain()
      @source.connect(@gain)
      @gain.connect(@options.context.destination)
    @gain.gain.value = (v)


context = new AudioContext()
load_buffer 'source/z.wav', context, (buffer)->
  random = (min, max, round = false)->
    r = Math.random() * (max - min) + min
    if !round
      return r
    Math.floor(r)
  console.info buffer
  sound = ->
    s = new Sound({context: context, buffer: buffer, speed: random(0.2, 0.7), offset: random(0, 20)})
    s.start()
    setTimeout ->
      s = new Sound({context: context, buffer: buffer, speed: random(0.2, 0.7), offset: random(0, 30)})
      s.start()
    , 4000
  sound()
