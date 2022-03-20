(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (: mpath :gsub "%." "/"))

(local lg love.graphics)

(local common (require (.. mpath ".common")))

(fn init [o]
  (let [image (lg.newImage (.. apath "/awesome.png"))
        (iw ih) (image:getDimensions)]
    (common.copy o 
      {:x 0
       :y 0
       :angle 0
       : image
       : iw
       : ih})))

(fn update [o dt]
  (set o.angle (+ o.angle (* dt math.pi))))

(fn draw [o c]
  (let [(sw sh) (lg.getDimensions)
        cx (* sw 0.5)
        cy (* sh 0.5)]
    (lg.clear 0.1 0.2 0.4)
    (lg.push)
    (lg.translate (+ o.x cx) (+ o.y cy))
    (lg.scale 4 4)
    (lg.rotate o.angle)
    (lg.draw o.image (- 0 (* o.iw 0.5)) (- 0 (* o.ih 0.5)))
    (lg.pop)))

(fn pressed [o b])

(fn released [o b])

(fn []
  {:name "Default"
   :children 
   [{: init
     : draw
     : update
     : pressed
     : released}]})
