(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local common (require (.. mpath ".common")))

(let [ship []]
  (fn ship.new [custom]
    (let [o (common.newObject "ship.obj" "ship.png" ship custom)
          f (common.newObject "ship-thrusters.obj" "ship.png")
          start {:yaw 0
                 :roll 0
                 :keys []}]
      (each [k v (pairs start)]
        (tset o k v))
      (set o.thrusters f)
      (set o.objects [f])
      (when (or custom.x custom.y)
        (o.model:setTranslation o.x o.y 0)
        (f.model:setTranslation o.x o.y 0))
      o))
      
  (fn ship.update [e dt ti]
    (let [m e.model
          t e.thrusters.model
          k e.keys]
      (when k.left (set e.roll (- e.roll dt)))
      (when k.up (set e.yaw (- e.yaw dt)))
      (when k.right (set e.roll (+ e.roll dt)))
      (when k.down (set e.yaw (+ e.yaw dt)))
      (m:setRotation e.yaw e.roll 0)
      (t:setRotation e.yaw e.roll 0)
      (set e.delta ti)))
      
  (fn ship.draw [e shdrs]
    (e.model:draw shdrs.default)
    (when e.keys.btnA
      (shdrs.fire:send :ti e.delta)
      (e.thrusters.model:draw shdrs.fire)))
    
  (fn ship.pressed [e btn]
    (tset e.keys btn true))
 
  (fn ship.released [e btn]
    (tset e.keys btn false))

  ship)