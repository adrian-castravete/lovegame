(local mpath (: ... :gsub "%.[^%.]+$" ""))

(fn pressed [o b]
  (tset o.btns b true))

(fn released [o b]
  (tset o.btns b false))

(fn before-basic-update [o dt]
  (let [bs o.btns
        v (* dt 4)]
    (set o.vx
      (if 
        bs.left (math.max -8 (- o.vx v))
        bs.right (math.min 8 (+ o.vx v))
        (if 
          (< (math.abs o.vx) 0.01) 0
          (* o.vx 0.95)))))
  (set o.x (+ o.x o.vx))
  (when (< o.x -224)
    (set o.x -224)
    (set o.vx 0))
  (when (> o.x 224)
    (set o.x 224)
    (set o.vx 0)))

(fn [x y]
  (let [w 64
        img (me.new-image "ship")]
    (me.basic-obj 
     {: x
      : y
      : w
      :h w
      :vx 0
      :vy 0
      :image img
      :btns []
      : pressed
      : released
      : before-basic-update})))
