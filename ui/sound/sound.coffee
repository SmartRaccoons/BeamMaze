AudioContext = window.AudioContext or window.webkitAudioContext

random = (min, max, round = false)->
  r = Math.random() * (max - min) + min
  if !round
    return r
  Math.floor(r)

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
    @gain = @options.context.createGain()
    @gain.gain.setTargetAtTime(0, 0, 0)
    @gain.connect(@options.context.destination)

    @source = @options.context.createBufferSource()
    @source.buffer = @options.buffer
    if @options.speed
      @source.playbackRate.value = @options.speed
    @source.connect(@gain)
    # @source.connect(@options.context.destination)

    @source.onended = => @options.end()

  start: ->
    console.info @options.buffer.duration / @options.speed
    console.info @options.offset
    @source.start(0)#@options.offset or 0)

  stop: ->
    @source.stop(0)

  volume: (v, time = 5)->
    console.info "time: ", @options.context.currentTime
    @gain.gain.setTargetAtTime(v, @options.context.currentTime, time)

  remove: (callback)->
    if @gain
      @gain.disconnect(@options.context.destination)
      @source.disconnect(@gain)
    @source.disconnect(@options.context.destination)


context = new AudioContext()

load_buffer 'source/z.mp3', context, (buffer)->
  sound = ->
    # s = new Sound({context: context, buffer: buffer, speed: random(0.2, 0.7), offset: random(0, 20)})
    # s.start()
    setTimeout ->
      s = new Sound({context: context, buffer: buffer, speed: random(0.2, 0.7), offset: random(10, 20)})
      s.start()
      s.volume(1, 10)
      # s.gain.gain.value = 0
      # s.volume(1)
      # setInterval =>
      #   console.info s.gain.gain.value
      # , 1000
      setTimeout ->
        s.remove()
      , 50000
    , 40
  sound()
