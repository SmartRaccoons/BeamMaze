window.o.ObjectText = class Text extends window.o.Object
  constructor: ->
    super
    texture = new (BABYLON.DynamicTexture)("texture_#{@_name()}", 512, @scene(), true)
    texture.hasAlpha = true
    size_font = 40
    context = texture.getContext()
    context.fillStyle = '#ffffff'
    context.font = "#{size_font}px retro"
    context.textAlign = 'center'
    context.textBaseline = 'middle'
    size = texture.getSize()
    text_parts = @options.text.split("\n")
    text_parts_total = text_parts.length
    text_parts.forEach (text, i)->
      context.fillText(text.trim(), size.width/2, (size.height/2) + (i - text_parts_total) * size_font)
    texture.update()
    @mesh.material = new (BABYLON.StandardMaterial)("material_#{@_name()}", @scene())
    @mesh.material.backFaceCulling = false
    @mesh.material.specularColor = new (BABYLON.Color3)(0, 0, 0)
    @mesh.material.diffuseTexture = texture

  mesh_build: ->
    new (BABYLON.Mesh.CreatePlane)(@_name(), 50, @scene(), true)
