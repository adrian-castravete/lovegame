(local lg love.graphics)

(fn [me]
  (fn update [o dt]
    (let [b o.btns
          w (* dt 160)
          m (if b.btnB {:x 0 :y 0}
                {:x o.x :y o.y})]
      (when b.left (set m.x (- m.x w)))
      (when b.up (set m.y (- m.y w)))
      (when b.right (set m.x (+ m.x w)))
      (when b.down (set m.y (+ m.y w)))
      (if b.btnB (me.camera.move m.x m.y)
          (me.copy o m)))
    (set o.r (+ o.r (* o.speed dt math.pi))))
  
  (fn pressed [o b]
    (tset o.btns b true)
    (when (= b :btnA)
      (set o.speed (* -1 o.speed))))
  
  (fn released [o b]
    (tset o.btns b false))

  {:name "Default"
   :children 
   [(me.basic-obj
     {:image 
      (me.-new-image-internal "cursor")})
    (me.basic-obj
     {:image 
      (me.-new-image-internal "awesome")
      :anims
      {:eyes [0 0 2 3]}
      :anim :eyes
      :speed 1
      :sx 4
      :sy 4
      :btns []
      :after-basic-update update
      : pressed
      : released})]})