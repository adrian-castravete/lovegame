(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local g3d (require "g3d"))

(local common [])

(fn local-asset-path [fname]
  (if (and fname (= (type fname) "string"))
    (.. apath "/assets/" fname)
    fname))

(fn common.newObject [mesh tex ...]
  (let [o {:is-active true
           :is-visible true
           :model (g3d.newModel
                    (local-asset-path mesh)
                    (local-asset-path tex))}]
    (let [tables [...]]
      (when tables
        (each [_ tbl (ipairs tables)]
          (each [k v (pairs tbl)]
            (tset o k v)))))
    o))

common