;(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local mpath ...)
(local apath (: mpath :gsub "%." "/"))

(local lg love.graphics)
(local g3d (require "g3d"))

(local cube (require (.. mpath ".cube")))

(let [cam-setup {:position [0 2 3]
                 :target [0 0 0]
                 :up [0 1 0]}
      root {:world 
            {:cube (cube.new [0 0 0]
                     {:diffuse [1.0 0.5 0.31]})
             :light (cube.new [-2 2 0] 
                      {:light? true})}}]
  (fn start []
    (let [c g3d.camera
          w root.world]
      (each [k v (pairs cam-setup)]
        (tset c k v))
      (c:updateProjectionMatrix)
      (c:updateViewMatrix)
      (set w.cube.light w.light)))
  
  (fn update [dt]
    (root.world.cube:update dt))
  
  (fn draw []
    (let [w root.world]
      (lg.clear 0.1 0.2 0.4)
      (lg.setColor 1 1 1)
      (w.cube:draw)
      (w.light:draw)))
      
  (fn pressed [btn]
    (root.world.cube:pressed btn))
  
  (fn released [btn]
    (root.world.cube:released btn))

  {: start
   : update
   : draw
   : pressed
   : released})
