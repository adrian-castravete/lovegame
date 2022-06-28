(local mpath (: ... :gsub "%.[^%.]+$" ""))

(fn update [o dt]
  (let [bs o.buttons]
    (set o.anim
      (if (or bs.left bs.right) :walk :idle))))

(fn pressed [o b]
  (let [bs o.buttons]
    (tset bs b true)
    (when (= b :right) 
      (set o.sx 1))
    (when (= b :left) 
      (set o.sx -1))))

(fn released [o b]
  (let [bs o.buttons]
    (tset bs b false)))

(fn []
  (me.basic-obj
   {:x 0
    :y 0
    :w 16
    :h 16
    :buttons []
    :image (me.new-image "hero")
    :anim :idle
    :anims
    {:idle [0 0 12 0.4]
     :idle-indices [1 2 1 2 1 3 1 2 1 2 1 4]
     :walk [0 16 6 0.1]}
    :before-basic-update update
    : pressed
    : released}))