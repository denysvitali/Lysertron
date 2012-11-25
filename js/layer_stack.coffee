class window.LayerStack
  constructor: (@layers = []) ->

  beat:     (data) -> layer.beat(data)     for layer in @layers when layer.active; return
  bar:      (data) -> layer.bar(data)      for layer in @layers when layer.active; return
  segment:  (data) -> layer.segment(data)  for layer in @layers when layer.active; return
  tatum:    (data) -> layer.tatum(data)    for layer in @layers when layer.active; return

  update: (elapsed) ->

    # Prune expired layers.
    livingLayers = []
    for layer in @layers
      if layer.expired()
        stage.scene.remove layer
      else
        livingLayers.push layer

    @layers = livingLayers

    # Update non expired layers.
    for layer in @layers
      layer.update elapsed

  transition: ->
    layer.kill() for layer in @layers
    @push(
      new Layers.Tunnel stage.scene
      new Layers.Cubes stage.scene
    )

  push: (layers...) ->
    for layer in layers
      throw "object is not a Layers.Base" unless layer instanceof Layers.Base
      @layers.push layer

  isEmpty: ->
    @layers.length is 0