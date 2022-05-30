(local mpath ...)

(local my-love-engine (require "mylove.engine"))
(global me (my-love-engine))
(global lg love.graphics)

(me.camera:viewport-size 180)
(me.camera:position 0 0)

(require (.. mpath ".world"))

(me.set-bg [0.1 0.2 0.4])
(me.play :world)

me