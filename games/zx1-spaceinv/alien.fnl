(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local lg love.graphics)
(local common (require (.. mpath ".common")))
(local g3d (require :g3d))

(let [f-counts [2 1 1 1 4]
      alien []]
  (fn alien.new [custom]
    (let [r (math.random)
          aname (.. "alien" custom.kind)
          img (lg.newImage (common.asset-path (.. aname ".png")))
          (iw ih) (values (img:getDimensions))
          dw (/ iw (. f-counts custom.kind))
          t (lg.newCanvas dw ih)
          start {:rot 0
                 :texture t
                 :image img
                 :frame 0
                 :gene r
                 : iw
                 : ih
                 : dw
                 :a (+ 0.1 (* 0.1 r))}
          o (common.newObject (.. aname ".obj") t start alien custom)]
      (o:draw-texture-frame)
      (o.model:makeNormals true)
      (o.model:setScale 2 2 2)
      (when (or custom.x custom.y)
        (o.model:setTranslation o.x o.y 0))
      o))
      
  (fn alien.update [e dt ti]
    (set e.rot (+ e.rot e.a))
    (set e.frame (% (math.floor (* ti e.gene 4)) (. f-counts e.kind)))
    (e:draw-texture-frame)
    (let [a  (* 0.25 (math.sin e.rot))
          a e.rot]
      (e.model:setRotation 0 a 0)))
      
  (fn alien.draw [e shdrs]
    (shdrs.default:send :cameraPosition g3d.camera.position)
    (e.model:draw shdrs.default))
    
  (fn alien.draw-texture-frame [e]
    (lg.setCanvas e.texture)
    (lg.clear 0 0 0 0)
    (lg.setColor 1 1 1)
    (lg.draw e.image
      (lg.newQuad 
        (* e.dw e.frame)
          0 e.dw e.ih e.iw e.ih) 0 0)
    (lg.setCanvas))
  
  alien)