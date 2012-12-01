class @Main extends Echotron.Echo
  constructor: ->
    super
    @stack = new Echotron.LayerStack

    for i in [0..THREE.Math.randInt(2,6)]
      layer = new Tunnel
      layer.baseColor = new THREE.Color 0x000000 unless i == 0
      @add layer
      @stack.push layer

  beat: (beat) -> @stack.beat beat
  bar:  (bar)  -> @stack.bar  bar
  update: (elapsed) -> @stack.update(elapsed)

  alive: -> !@stack.isEmpty()

class Tunnel extends Echotron.Echo
  uniformAttrs:
    inward:         'f'
    brightness:     'f'
    ripples:        'fv1'
    ease:           'f'
    ringSize:       'f'
    baseColor:      'c'
    ringColor:      'c'
    ringIntensity:  'f'

  constructor: ->
    super

    @inward         = [1, 0].random()
    @brightness     = 1
    @ripples        = [1, 0, 0, 0, 0, 0, 0, 0]

    @baseColor ||= new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0.5, 1), THREE.Math.randFloat(0.5, 1)
    @ringColor =   new THREE.Color().setHSV Math.random(), THREE.Math.randFloat(0, 1), 1

    @spin = THREE.Math.randFloatSpread(180) * Math.PI/180
    @ease = [
      THREE.Math.randFloat(0.75, 1.2)
      THREE.Math.randFloat(1.2, 6)
    ].random()
    @ringSize = THREE.Math.randFloat(0.1, 1.0)
    @ringIntensity = THREE.Math.randFloat(0.05, 0.3)
    @fadeSpeed = THREE.Math.randFloat(0.3, 0.6)

    @sides =
      if Math.random() > 0.5
        40
      else
        [3, 4, 5, 6, 7].random()


    @mesh = new THREE.Mesh(
      new THREE.CylinderGeometry 0, THREE.Math.randFloat(150, 250), 2000, @sides, 50
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["tunnel.vshader"]
        fragmentShader: assets["tunnel.fshader"]
        transparent:    true
        blending:       THREE.AdditiveBlending
      )
    )
    @mesh.material.side = THREE.BackSide
    @mesh.material.depthWrite = no

    @rotation.x = 90 * Math.PI/180
    @position.z = Math.random()

    @add @mesh

  alive: ->
    @brightness > 0 || _.max(@ripples) > 0

  beat: (beat) ->
    @ripples.unshift 1
    @ripples = @ripples[0..7]

  bar: (bar) ->
    @brightness = 1

  update: (elapsed) ->
    @ripples =
      for ripple in @ripples
        ripple -= @fadeSpeed * elapsed
        if ripple > 0
          ripple
        else
          0

    @brightness -= 0.25 * elapsed
    @mesh.rotation.y += @spin * elapsed
