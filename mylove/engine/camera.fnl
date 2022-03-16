(local mpath (: ... :gsub "%.[^%.]+$" ""))

(local common (require (.. mpath ".common")))
(local copy common.copy)

(fn viewport-size [e c width height]
  (let [height (or height width)]
    (copy e.viewport
      {: width
       : height})))

(fn position [c x y]
  (copy c {: x : y}))

(fn [e]
  (let [c {:x 0
           :y 0}]
    (copy c 
      {:viewport-size (fn [...] (viewport-size e ...))
       : position})
  
    c))
