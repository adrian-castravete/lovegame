(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local common (require (.. mpath ".common")))

(let [alien []]
  (fn alien.new [custom]
    (let [r (math.random)
          start {:rot 0
                 :a (+ 0.1 (* 0.1 r))}
          o (common.newObject "alien1.obj" "alien1.png" start alien custom)]
      (o.model:makeNormals true)
      (o.model:setScale 2 2 2)
      (when (or custom.x custom.y)
        (o.model:setTranslation o.x o.y 0))
      o))
      
  (fn alien.update [e dt ti]
    (set e.rot (+ e.rot e.a))
    (e.model:setRotation 0 e.rot 0))
      
  (fn alien.draw [e shdrs]
    (e.model:draw shdrs.default))
  
  alien)