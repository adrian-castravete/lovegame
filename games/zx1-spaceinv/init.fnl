(local mpath ...)

(require (.. mpath ".playfield"))

(me.scene :startup
 {:children
  [{:init 
    (fn []
     (me.camera.viewport-size 360)
     (me.play :invaders))}]})

;(me.set-bg [0.1 0.2 0.4])
(me.play :startup)

me