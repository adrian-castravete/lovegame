(local mpath (: ... :gsub "%.[^%.]+" ""))

(local common (require (.. mpath ".common")))
(local bg (require (.. mpath ".background")))

(let [world []]
  (fn world.new []
    (let [w {:x 0
             :y 0}]
      (common.add-child w (bg.new))
      w))
  world)