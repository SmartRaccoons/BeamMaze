_split_params = (a)->
  b = {}
  if a is ''
    return b
  for pr in a
    p = pr.split('=')
    if p.length is 2
      b[p[0]] = decodeURIComponent(p[1].replace(/\+/g, " "))
  b
GET = window.GET = _split_params(window.location.search.substr(1).split('&'))
GET_hash = window.GET_hash = _split_params(window.location.hash.substr(1).split('&'))


window.o.Game = class Game extends window.o.Game
  render: ->
    super
    @_camera.attachControl(document.body, true)
    if 'axis' of GET
      @show_axis(30)

  show_axis: (size = 10)->
    scene = @_scene
    makeTextPlane = (text, color, size) ->
      dynamicTexture = new (BABYLON.DynamicTexture)('DynamicTexture', 50, scene, true)
      dynamicTexture.hasAlpha = true
      dynamicTexture.drawText text, 5, 40, 'bold 36px Arial', color, 'transparent', true
      plane = new (BABYLON.Mesh.CreatePlane)('TextPlane', size, scene, true)
      plane.material = new (BABYLON.StandardMaterial)('TextPlaneMaterial', scene)
      plane.material.backFaceCulling = false
      plane.material.specularColor = new (BABYLON.Color3)(0, 0, 0)
      plane.material.diffuseTexture = dynamicTexture
      plane

    axisX = BABYLON.Mesh.CreateLines('axisX', [
      new (BABYLON.Vector3.Zero)
      new (BABYLON.Vector3)(size, 0, 0)
      new (BABYLON.Vector3)(size * 0.95, 0.05 * size, 0)
      new (BABYLON.Vector3)(size, 0, 0)
      new (BABYLON.Vector3)(size * 0.95, -0.05 * size, 0)
    ], scene)
    axisX.color = new (BABYLON.Color3)(1, 0, 0)
    xChar = makeTextPlane('X', 'red', size / 10)
    xChar.position = new (BABYLON.Vector3)(0.9 * size, -0.05 * size, 0)
    axisY = BABYLON.Mesh.CreateLines('axisY', [
      new (BABYLON.Vector3.Zero)
      new (BABYLON.Vector3)(0, size, 0)
      new (BABYLON.Vector3)(-0.05 * size, size * 0.95, 0)
      new (BABYLON.Vector3)(0, size, 0)
      new (BABYLON.Vector3)(0.05 * size, size * 0.95, 0)
    ], scene)
    axisY.color = new (BABYLON.Color3)(0, 1, 0)
    yChar = makeTextPlane('Y', 'green', size / 10)
    yChar.position = new (BABYLON.Vector3)(0, 0.9 * size, -0.05 * size)
    axisZ = BABYLON.Mesh.CreateLines('axisZ', [
      new (BABYLON.Vector3.Zero)
      new (BABYLON.Vector3)(0, 0, size)
      new (BABYLON.Vector3)(0, -0.05 * size, size * 0.95)
      new (BABYLON.Vector3)(0, 0, size)
      new (BABYLON.Vector3)(0, 0.05 * size, size * 0.95)
    ], scene)
    axisZ.color = new (BABYLON.Color3)(0, 0, 1)
    zChar = makeTextPlane('Z', 'blue', size / 10)
    zChar.position = new (BABYLON.Vector3)(0, 0.05 * size, 0.9 * size)


if not ('anime' of GET)
  window.o.ObjectBlank::_animation = (fn)-> fn(1, 0)
  window.o.ObjectMirror::_animation = (fn)-> fn(1, 0)

if 'color_mirror' of GET
  window.o.ObjectMirror::_default.color = GET['color_mirror'].split(',')
if 'color_tube' of GET
  window.o.ObjectMirror::_default.color_tube = GET['color_tube'].split(',')
if 'color_mirror_reverse' of GET
  window.o.ObjectMirrorReverse::_default.color = GET['color_mirror_reverse'].split(',')
if 'color_blank' of GET
  window.o.ObjectBlank::_default.color = GET['color_blank'].split(',')
if 'color_beam' of GET
  window.o.ObjectBeamSource::_default.color = window.o.ObjectBeam::_default.color = GET['color_beam'].split(',')
if 'color_beam_target' of GET
  window.o.ObjectBeamTarget::_default.color = GET['color_beam_target'].split(',')
if 'color_text' of GET
  window.o.ObjectText::_default.color = GET['color_text'].split(',')


window.o.GameMap = class GameMap extends window.o.GameMap
  remove_controls: ->
    if not ('map' of GET)
      super

window.o.ViewGame = class ViewGame extends window.o.ViewGame
  _solved: ->
    if not ('map' of GET)
      super


window.o.ViewRouter = class Router extends window.o.ViewRouter
  constructor: ->
    if 'map' of GET
      window.o.GameMapData = [GET['map']]
      GET['stage'] = 1
    super
    if 'color_body' of GET
      color = GET['color_body'].split(',').map( (v)-> '#' + v.split('-')[0] + ' ' + v.split('-')[1] + '%').join(',')
      $('.container').css('background',  "radial-gradient(ellipse at center, #{color})")
      $('.container').css('background',  "-webkit-radial-gradient(ellipse at center, #{color})")

  run: ->
    if 'stage' of GET
      @game_last = parseInt(GET['stage'])
      return @game()
    super
