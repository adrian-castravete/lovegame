(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local g3d (require "g3d"))

(fn local-path [fname part]
  (let [part (or part "/")]
    (if (and fname (= (type fname) "string"))
      (.. apath part fname)
      fname)))

(fn local-asset-path [fname]
  (local-path fname "/assets/"))
    
(fn tcopy [tfrom tto]
  (each [k v (pairs tfrom)]
    (tset tto k v)))

(let [cube []]
  (fn cube.new [pos setup]
    (let [o {:model
             (g3d.newModel
               (local-asset-path "cube.obj")
               (local-asset-path "white.png"))
             :diffuse [0.8 0.8 0.8]
             :angle 0.0
             :shader
             (love.graphics.newShader
               (local-path "default.vert")
               (local-path
                 (if setup.light? "light.frag" "default.frag")))}]
      (tcopy cube o)
      (tcopy setup o)
      (o.model:setTransform (or pos [0.0 0.0 0.0]))
      (when o.light?
        (o.model:setScale 0.2 0.2 0.2))
      o))

  (fn cube.draw [o]
    (when (not o.light?)
      (o.shader:send :cameraPosition [0 2 3])
      (o.shader:send :lightColor [1.0 1.0 1.0])
      (o.shader:send :lightPosition o.light.model.translation)
      (o.shader:send :diffuseColor o.diffuse))
    (o.model:draw o.shader))
    
  (fn cube.update [o dt]
    (set o.angle (+ dt o.angle))
    (o.model:setRotation (* 0.618 o.angle) o.angle 0))

  cube)