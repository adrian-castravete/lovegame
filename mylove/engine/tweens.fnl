(fn tween-coroutine [config]
  (let [{: duration
         : timeout
         : progress
         : done
         : data} config 
        timeout (or timeout 0)]
    (var accum 0)
    (while (< accum timeout)
      (let [dt (coroutine.yield)]
        (set accum (+ accum dt))))
    (set accum 0)
    (while (< accum duration)
      (let [dt (coroutine.yield)]
        (set accum (+ accum dt))
        (when progress
          (progress data (math.max 0 (math.min 1 (/ accum duration)))))))
    (when done
      (done data))))
        

(let [tw {:active true
          :index 1
          :tweens []}]

  (fn tw.update-tweens [dt]
    (when tw.active
      (let [new-cos []]
        (each [name co (pairs tw.tweens)]
          (when (= :suspended (coroutine.status co))
            (let [(ok err) (coroutine.resume co dt)]
              (when (not ok)
                (error err)))
            (tset new-cos name co)))
        (set tw.tweens new-cos))))

  (fn tw.add-tween [config] 
    (let [co (coroutine.create tween-coroutine)
          tween-name (.. :tween tw.index)]
      (let [(ok err) (coroutine.resume co config)]
        (when (not ok)
          (error err)))
      (tset tw.tweens tween-name co)
      (set tw.index (+ 1 tw.index))
      tween-name))

  (fn tw.del-tween [tween-name]
    (tset tw.tweens tween-name nil))

  (fn tw.clear-tweens []
    (set tw.tweens []))

  (fn tw.pause []
    (set tw.active false))

  (fn tw.unpause []
    (set tw.active true))

  tw)
