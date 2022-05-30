(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(fn build-chunk [o]
  (let [c (lg.newCanvas 256 256)]
    (lg.setCanvas c)
    (for [j 0 15]
      (for [i 0 15]
        (let [v (math.random)]
          (lg.setColor v v v)
          (lg.draw o.src-image (* 16 i) (* 16 j)))))
    (lg.setCanvas)
    (set o.bg-image c)))

(fn init [o]
  (me.copy o
    {:src-image 
     (lg.newImage 
       (.. apath "/assets/" o.tiles ".png"))})
  (build-chunk o))

(fn draw [o c v]
  (let [sx (- c.x v.zcx)
        sy (- c.y v.zcy)
        fx (+ sx v.zw)
        fy (+ sy v.zh)
        x (* 256 (math.floor (/ sx 256)))
        y (* 256 (math.floor (/ sy 256)))]
    (for [j y fy 256]
      (for [i x fx 256]
        (lg.draw o.bg-image i j)))))

(fn []
  {:tiles "back-dirt"
   : init
   : draw})