(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local background (require (.. mpath ".background")))

(fn init-pl1 [o]
  (set o.buttons []))

(fn draw-spr [o c v])

(fn update-spr [o dt]
  (me.camera:move
    (if b.left (- dt) b.right dt 0)
    (if b.up (- dt) b.down dt 0)))

(fn pressed [o b]
  (tset o.buttons b true))

(fn released [o b]
  (tset o.buttons b false))

(me.scene :world
  {:name "World"
   :children
   [(background)
    {:id :spr
     :name "Sprites"
     :children 
     [{:id :pl1
       :name "Player"
       :init init-pl1
       :draw draw-spr
       :update update-spr
       :pressed pressed
       :released released}]}]})