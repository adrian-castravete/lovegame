(local mpath ...)

(local lg love.graphics)

(local fv (require "fennel.view"))
(local common (require (.. mpath ".common")))
(local camera (require (.. mpath ".camera")))
(local default-scene (require (.. mpath ".default")))
(local tweens (require (.. mpath ".tweens")))

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
      
(fn resize [e]
  (let [(w h) (lg.getDimensions)
        v e.viewport
        z (math.min 
            (/ w v.width) 
            (/ h v.height))
        cx (* w 0.5)
        cy (* h 0.5)]
    (common.copy v
      {:center-x cx
       :center-y cy
       :zcx (/ cx z)
       :zcy (/ cy z)
       :zw (/ w z)
       :zh (/ h z)
       :zoom-f z
       :zoom
       (math.floor z)})))

(fn [game-module]
  (let [gapath (: game-module :gsub "%." "/")
        s []
        e {:config s
           :viewport
           {:width 320
            :height 200}
           :copy common.copy}]
    (e.copy e common)
    (e.copy s defaults)
    
    (set e.camera (camera e))
    
    (fn e.start []
      (common.copy e.viewport s.viewport)
      (resize e)
      (walk :init (. e.scenes s.scene)))
    
    (fn e.update [dt]
      (tweens.update-tweens dt)
      (walk :update (. e.scenes s.scene) dt))
    
    (fn e.draw []
      (let [bg s.background-color
            c e.camera
            v e.viewport]
        (when bg (lg.clear bg))
        (lg.setColor 1 1 1)
        (lg.push)
        (lg.translate v.center-x v.center-y)
        (lg.scale v.zoom v.zoom)
        (walk :draw (. e.scenes s.scene) c v)
        (lg.pop)))
    
    (fn e.pressed [btn]
      (when (= btn :start)
        (set e._start-hack true))
      (walk :pressed (. e.scenes s.scene) btn))
    
    (fn e.released [btn]
      (when (= btn :start)
        (set e._start-hack false))
      (walk :released (. e.scenes s.scene) btn))
  
    (fn e.resize []
      (resize e))
    
    (fn e.scene [sname data]
      (tset e.scenes sname data))
    
    (fn e.play [sn]
      (set s.scene sn)
      (walk :init (. e.scenes s.scene)))
    
    (fn e.set-bg [c]
      (set s.background-color c))
    
    (fn e.new-image [img-id ...]
      (common.new-image gapath img-id ...))

    (fn e.-new-image-internal [img-id ...]
      (common.new-image (: mpath :gsub "%." "/") img-id ...))

    (fn e.tween [config]
      (tweens.add-tween config))

    (fn e.rm-tween [tween]
      (tweens.del-tween tween))

    (fn e.cl-tweens []
      (tweens.clear-tweens))

    (fn e.pause-tweens []
      (tweens.pause))

    (fn e.unpause-tweens []
      (tweens.unpause))
    
    (set e.scenes {:_default (default-scene e)})
    
    e))
