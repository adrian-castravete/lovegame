(local mpath ...)

(local my-love-engine (require "mylove.engine"))
(global me (my-love-engine))

(me.camera:viewport-size 180)
(me.camera:position 0 0)

me
