(local mpath ...)

(local common (require (.. mpath ".common")))
(local camera (require (.. mpath ".camera")))

(local defaults
  {:viewport
   {:width 320
    :height 200}})

(fn [c]
  (let [e []]
    (common.copy e defaults)
    (set e.camera (camera e))
    
    (fn e.start [])
    
    (fn e.update [dt])
    
    (fn e.draw [])
    
    (fn e.pressed [btn])
    
    (fn e.released [btn])
    
    e))
