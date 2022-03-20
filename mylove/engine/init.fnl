(local mpath ...)

(local lg love.graphics)

(local fv (require "fennel.view"))
(local common (require (.. mpath ".common")))
(local camera (require (.. mpath ".camera")))
(local default-scene (require (.. mpath ".default")))

(local defaults
  {:viewport
   {:width 320
    :height 200}
   :scene :_default})
 
(fn walk [n e ...]
  (let [kids (. e :children)]
    (when kids
      (each [_ o (ipairs kids)]
        (let [func (. o n)]
          (when func (func o ...)))
        (walk n o ...)))))

(fn [c]
  (let [s []
        e {:config s
           :scenes
           {:_default (default-scene)}}]
    (common.copy s defaults)
    (set e.camera (camera e))
    
    (fn e.start []
      (walk :init (. e.scenes s.scene)))
    
    (fn e.update [dt]
      (walk :update (. e.scenes s.scene) dt))
    
    (fn e.draw []
      (let [bg s.background-color]
        (when bg (lg.clear bg)))
      (walk :draw (. e.scenes s.scene) e.camera))
    
    (fn e.pressed [btn]
      (walk :pressed (. e.scenes s.scene) btn))
    
    (fn e.released [btn]
      (walk :released (. e.scenes s.scene) btn))
    
    (fn e.scene [sname data]
      (tset e.scenes sname data))
    
    (fn e.play [sn]
      (set s.scene sn)
      (walk :init e)
      (print (fv (. e.scenes s.scene))))
    
    e))
