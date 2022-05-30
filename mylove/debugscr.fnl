(local mpath (: ... :gsub "%.[^%.]+$" ""))
(local apath (mpath:gsub "%." "/"))

(local lg love.graphics)
(local fv (require "fennel.view"))

(let [fnt (lg.newFont (.. apath "/assets/cm.ttf"))]
  (var obj nil)
  
  (fn draw []
    (when obj
      (let [ds (fv obj)]
        (lg.push)
        (lg.scale 2 2)
        (lg.setColor 0 0 0)
        (lg.print ds fnt 1 25)
        (lg.setColor 1 1 1)
        (lg.print ds fnt 0 24)
        (lg.pop))))
  
  (fn set-obj [o]
    (set obj o))
  
  {: draw
   :set set-obj})
