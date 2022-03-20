(local mpath (: ... :gsub "%.[^%.]+" ""))

(fn draw-bg [o c])

(fn draw-spr [o c])

(fn update-spr [o dt])

(me.scene :world
  {:name "World"
   :children
   [{:id :bg
     :name "Background"
     :draw draw-bg}
    {:id :spr
     :name "Sprites"
     :children 
     [{:id :pl1
       :name "Player"
       :draw draw-spr
       :update update-spr}]}]})