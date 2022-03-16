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

{: copy}