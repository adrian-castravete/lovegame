(local mpath (: ... :gsub "%.[^%.]+$" ""))

(local common (require (.. mpath ".common")))
(local copy common.copy)

(fn [e]
  (let [c {:x 0
           :y 0}
        s e.config]
    (fn c.viewport-size [width height]
      (let [height (or height width)]
        (copy s.viewport
          {: width
           : height})
        (copy e.viewport
          {: width
           : height})
        (e.resize)))
    
    (fn c.position [x y]
      (copy c {: x : y}))
    
    (fn c.move [x y]
      (set c.x (+ x c.x))
      (set c.y (+ y c.y)))

    c))