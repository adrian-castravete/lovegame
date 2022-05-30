(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local sizes [16 16 32 32 32])
(local frames [2 4 4 2 2])

(fn [j x y]
  (let [f (. frames j)
        w (. sizes j)
        img (me.new-image (.. "alien" j))]
    (me.basic-obj 
     {: x
      : y
      : w
      :h w
      :alive true
      :anim :idle
      :anims
      {:idle [0 0 f (/ (+ 1 (math.random)) 8)]}
      :image img})))
