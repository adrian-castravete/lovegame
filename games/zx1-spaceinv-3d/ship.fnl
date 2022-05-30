(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local common (require (.. mpath ".common")))
(local g3d (require :g3d))

(let [ship []]
  (fn ship.new [custom]
    (let [start {:keys []
                 :x 0
                 :y 0
                 :lean 0}
          o (common.newObject "ship.obj" "ship.png" start ship custom)
          f (common.newObject "ship-thrusters.obj" "ship.png")]
      (set o.thrusters f)
      (set o.objects [f])
      (o.model:makeNormals true)
      (when (or custom.x custom.y)
        (o.model:setTranslation o.x o.y 0)
        (f.model:setTranslation o.x o.y 0))
      o))
      
  (fn ship.update [e dt ti]
    (let [m e.model
          t e.thrusters.model
          k e.keys
          sm (* 64 dt)
          sr (* 2 dt)
          sd (* 2 sr)]
      (when k.left 
        (set e.x (- e.x sm))
        (set e.lean (math.max -1 (- e.lean sd))))
      (when k.right 
        (set e.x (+ e.x sm))
        (set e.lean (math.min 1 (+ e.lean sd))))
      (when (not (or k.left k.right))
        (set e.lean
          (if 
            (< e.lean (- sr))
            (+ e.lean sr)
            (> e.lean sr)
            (- e.lean sr)
            e.lean)))
            
      (m:setTranslation e.x e.y 0)
      (t:setTranslation e.x e.y 0)
      (m:setScale 2 2 2)
      (t:setScale 2 2 2)
      (m:setRotation 0 e.lean 0)
      (t:setRotation 0 e.lean 0)
      
      (set e.delta ti)))
      
  (fn ship.draw [e shdrs]
    (shdrs.default:send :cameraPosition g3d.camera.position)
    (e.model:draw shdrs.default)
    (shdrs.fire:send :ti e.delta)
    (e.thrusters.model:draw shdrs.fire))
    
  (fn ship.pressed [e btn]
    (tset e.keys btn true))
 
  (fn ship.released [e btn]
    (tset e.keys btn false))

  ship)
