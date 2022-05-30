(local mpath (: ... :gsub "%.[^%.]+$" ""))

(local lg love.graphics)

(fn copy [dst src]
  (when (and 
          (= (type dst) :table)
          (= (type src) :table))
    (each [k s (pairs src)]
      (let [t (= (type s) :table)
            d (. dst k)]
        (when (and t 
                (or (not d) (= (type d) :table)))
          (let [n []]
            (copy n s)
            (tset dst k n)))
        (when (not t)
          (tset dst k s))))))
        
(var cache [])
(fn new-image [apath img-id ...]
  (let [fname (.. apath "/assets/" img-id ".png")]
    (var img (. cache img-id))
    (when (not img)
      (set img (lg.newImage fname ...))
      (tset cache img-id img))
    img))

(fn clear-cache []
  (set cache []))

(fn basic-spr-draw [o c v]
  (let [bbd o.before-basic-draw
        abd o.after-basic-draw
        ox (- (/ o.w 2))
        oy (- (/ o.h 2))
        ad o.-anim-data]
    (when bbd (bbd o))
    (when o.image
      (lg.push)
      (lg.translate (+ c.x o.x) (+ c.y o.y))
      (lg.scale o.sx o.sy)
      (lg.rotate o.r)
      (if ad
        (lg.draw o.image ad.quad ox oy)
        (lg.draw o.image ox oy))
      (lg.pop))
    (when abd (abd o))))
  
(fn basic-spr-update [o dt]
  (let [bbu o.before-basic-update
        abu o.after-basic-update]
    (when bbu (bbu o dt))
    (when (and o.image o.anim o.anims)
      (let [[start-x start-y max-frames frame-delay] (. o.anims o.anim)
            (iw ih) (o.image:getDimensions)
            anim-data 
            (or o.-anim-data
              {:frame 0
               :time 0
               :quad
               (lg.newQuad 
                 start-x start-y o.w o.h iw ih)})
            {: frame 
             :time ti
             : quad} anim-data
            new-ti (+ ti dt)
            extra-frames (math.floor (/ new-ti frame-delay))
            new-frame 
            (% (+ frame extra-frames) max-frames)]
        (when (~= frame new-frame)
          (quad:setViewport
            (+ (* new-frame o.w) start-x)
            start-y
            o.w o.h))
        (tset o :-anim-data
          {:frame new-frame
           :time (- new-ti (* extra-frames frame-delay))
           : quad})))
    (when abu (abu o dt))))

(var obj-index 1)
(fn basic-obj [over]
  (let [obj {:id obj-index
             :x 0
             :y 0
             :w 16
             :h 16
             :r 0
             :sx 1
             :sy 1
             :draw basic-spr-draw
             :update basic-spr-update}]
    (copy obj over)
    
    (set obj-index (+ 1 obj-index))
    obj))

{: copy
 : clear-cache
 : new-image
 : basic-obj}