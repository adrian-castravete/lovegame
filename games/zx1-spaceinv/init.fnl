(local mpath (: ... :gsub "%.[^%.]+$" ""))
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
            :ship nil
            :objects []
            :shaders (build-shaders shader-files shaders)}]
  (fn start []
    (let [c g3d.camera]
      (each [k v (pairs cam-start)]
        (tset c k v))
      (c.updateOrthographicMatrix 20)
      (c.updateViewMatrix))
    (let [ship (ship.new {:x 0
                          :y -100})]
      (set root.ship ship)
      (table.insert root.objects ship))
  
    (for [j 1 5]
      (for [i 1 9]
        (table.insert root.objects
          (alien.new
            {:x (* (- i 5) 32)
             :y (- 100 (* 24 j))})))))
            
  (fn walk [elem fn-name enabler ...]
    (each [_ obj (ipairs elem.objects)]
      (when obj.objects (walk obj fn-name ...))
      (let [func (. obj fn-name)
            envar (. obj enabler)]
        (when (and func envar) 
          (func obj ...)))))

  (fn update [dt]
    (set root.delta (+ root.delta dt))
    (walk root :update :is-active dt root.delta))
   
  (fn draw []
    (love.graphics.clear 0 0 0.33)
    (walk root :draw :is-visible root.shaders))

  (fn pressed [btn]
    (root.ship:pressed btn))

  (fn released [btn]
    (root.ship:released btn))

  {: start
   : update
   : draw
   : pressed
   : released})
