(local mpath ...)
(local apath (: mpath :gsub "%." "/"))

(local g3d (require "g3d"))

(local common (require (.. mpath ".common")))
(local ship (require (.. mpath ".ship")))
(local alien (require (.. mpath ".alien")))

(fn build-shaders [files shaders]
  (let [output []]
    (each [name cfg (pairs shaders)]
      (tset output name 
        (love.graphics.newShader
          (.. apath "/" (. files (. cfg 1)))
          (.. apath "/" (. files (. cfg 2))))))
    output))

(let [cam-start {:position [0 0 180]
                 :target [0 0 0]
                 :up [0 1 0]}
      shader-files {:vDefault "default.vert"
                    :fDefault "default.frag"
                    :fFire "fire.frag"}
      shaders {:default [:vDefault :fDefault]
               :fire [:vDefault :fFire]}
      root {:delta 0
            :zoom 120
            :ship nil
            :buttons []
            :objects []
            :shaders (build-shaders shader-files shaders)}]
  (fn start []
    (let [c g3d.camera]
      (each [k v (pairs cam-start)]
        (tset c k v))
      (c.updateOrthographicMatrix root.zoom)
      (c.updateViewMatrix))
    (let [ship (ship.new {:x 0
                          :y -100})]
      (set root.ship ship)
      (table.insert root.objects ship))
  
    (for [j 1 5]
      (for [i 1 9]
        (table.insert root.objects
          (alien.new
            {:kind j
             :x (* (- i 5) 32)
             :y (- 100 (* 24 j))})))))
            
  (fn walk [elem fn-name enabler ...]
    (each [_ obj (ipairs elem.objects)]
      (when obj.objects (walk obj fn-name ...))
      (let [func (. obj fn-name)
            envar (. obj enabler)]
        (when (and func envar) 
          (func obj ...)))))

  (fn update [dt]
    (let [r root
          c g3d.camera
          b r.buttons]
      (var [x y z] c.position)
      (set r.delta (+ r.delta dt))
      (when b.start
        (let [m (* 60 dt)]
          (when b.up (set r.zoom (math.max 10 (- r.zoom m))))
          (when b.down (set r.zoom (math.min 120 (+ r.zoom m)))))
        (c.updateOrthographicMatrix r.zoom))
      (when b.btnB
        (let [m (/ r.zoom 120)]
          (when b.left (set x (- x m)))
          (when b.up (set y (+ y m)))
          (when b.right (set x (+ x m)))
          (when b.down (set y (- y m))))
        (set x (math.max -160 (math.min 160 x)))
        (set y (math.max -120 (math.min 120 y)))
        (set c.position [x y z])
        (set c.target [x y 0])
        (c.updateViewMatrix)))
    (walk root :update :is-active dt root.delta))
   
  (fn draw []
    (love.graphics.clear 0 0 0.33)
    (walk root :draw :is-visible root.shaders))

  (fn pressed [btn]
    (let [b root.buttons]
      (tset b btn true)
      (when (not (or b.btnB b.start))
        (root.ship:pressed btn))))

  (fn released [btn]
    (let [b root.buttons]
      (tset b btn false)
      (when (not (or b.bntB b.start))
        (root.ship:released btn))))

  {: start
   : update
   : draw
   : pressed
   : released})