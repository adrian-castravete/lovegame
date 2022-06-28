(local mpath ...)

(require (.. mpath ".levels"))

(me.scene :startup
 {:children
  [{:init 
    (fn []
     (me.camera.viewport-size 144)
     (me.play :level1))}]})

(me.set-bg [0.1 0.2 0.4])
(me.play :startup)

me