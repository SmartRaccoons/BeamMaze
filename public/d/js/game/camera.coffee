window.o.GameCamera = class Camera extends window.o.ObjectAnimation
  constructor: ->
    @_animation_reset()
    @camera = new THREE.PerspectiveCamera(50, 1, 0.1, 1000)
    @position = [0, 0, 0]
    @position_set(@position)

  get: -> @camera

  resize: (w, h)->
    @camera.aspect = w / h
    @camera.updateProjectionMatrix()

  position_set: (position)->
    @position = position
    @camera.position.set(position[0], position[1], position[2])

  position_calculate: (params)->
    @position_animate(params.center.concat(params.size), {easing: 'sin'})
