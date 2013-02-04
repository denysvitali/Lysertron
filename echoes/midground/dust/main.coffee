module.exports = class Dust extends Echotron.Echo
  uniformAttrs:
    baseColor:     'c'
    size:          'f'
    particleAlpha: 'f'

  initialize: ->
    @direction = 1
    @speed = THREE.Math.randFloat(2, 4)
    @damp  = THREE.Math.randFloat(1, 4)
    @vel   = 3

    @size = THREE.Math.randFloat(3, 8)
    @position.z = Math.random()
    @scale.setLength 0

    @particleAlpha = THREE.Math.randFloat(0.4, 0.75)

    @baseColor = new THREE.Color().setHSV(
      THREE.Math.randFloat(0, 1)
      THREE.Math.randFloat(0, 0.25)
      1
    )

    @spin = new THREE.Vector3(
      THREE.Math.randFloatSpread(30).degToRad
      THREE.Math.randFloatSpread(30).degToRad
      THREE.Math.randFloatSpread(30).degToRad
    )

    @geom = new THREE.Geometry
    for i in [0..THREE.Math.randFloat(250, 1000)]
      @geom.vertices.push new THREE.Vector3(
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
        THREE.Math.randFloat(-1, 1)
      ).setLength THREE.Math.randFloat(4, 70)

    @particles = new THREE.ParticleSystem(
      @geom
      new THREE.ShaderMaterial(
        uniforms:       @uniforms
        vertexShader:   assets["vert.glsl"]
        fragmentShader: assets["frag.glsl"]
        transparent:    yes
        depthWrite:     no
      )
    )

    @add @particles

  onBeat: ->
    @vel = @speed * @direction
    @direction *= -1

  update: (elapsed) ->
    super
    
    @vel -= @vel * @damp * elapsed
    @scale.add THREE.Vector3.temp(1,1,1).multiplyScalar(@vel * elapsed)

    @rotation.add THREE.Vector3.temp(@spin).multiplyScalar(elapsed)

  kill: ->
    super
    @vel = @speed * 2
    @damp = 0

  alive: ->
    @scale.length() < 50