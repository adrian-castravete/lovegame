(local mpath (: ... :gsub "%.[^%.]+$" ""))

(local enemy (require (.. mpath ".enemy")))
(local ship (require (.. mpath ".ship")))

(fn draw [o]
  (lg.setColor 0 1 0)
  (lg.rectangle :line -240 -180 480 360)
  (lg.setColor 1 1 1))

(fn progress [data v]
  (let [{:obj o
         : sx
         : sy
         : dx
         : dy} data]
    (set o.x (+ sx (* dx 8 v)))
    (set o.y (+ sy (* dy 8 v)))))

(fn plan-move [p o dx dy tout movement]
  (let [s p.state]
    (when o.alive
      (when (and (= movement :right) (>= o.x 212))
        (set s.next-state :down-left))
      (when (and (= movement :left) (<= o.x -212))
        (set s.next-state :down-right))
      (me.tween {:data {:obj o
                        :sx o.x
                        :sy o.y
                        : dx
                        : dy}
                 : progress  
                 :duration 0.1
                 :timeout (* tout 0.05)}))))

(fn go-right [o]
  (let [es o.enemies  
        h (length es)
        w (length (. es 1))]
    (for [i w 1 -1]
      (for [j 1 h]
        (plan-move o (. es j i) 1 0 (- (+ w 1) i) :right)))))
 
(fn go-left [o]
  (let [es o.enemies  
        h (length es)
        w (length (. es 1))]
    (for [i 1 w]
      (for [j 1 h]
        (plan-move o (. es j i) -1 0 i :left)))))

(fn go-down [o]
  (let [es o.enemies  
        h (length es)
        w (length (. es 1))]
    (for [j h 1 -1]
      (for [i 1 w]
        (plan-move o (. es j i) 0 1 (- (+ h 1) j) :down)))))

(fn update-action [o dt]
  (let [s o.state]
    (match s.state
      :right (go-right o)
      :left (go-left o)
      :down-left (go-down o)
      :down-right (go-down o))
    (when (= s.state :down-left)
      (set s.next-state :left))
    (when (= s.state :down-right)
      (set s.next-state :right))
    (when s.next-state
      (set s.state s.next-state)
      (set s.next-state nil))))

(fn update [o dt]
  (let [s o.state
        to s.timeout]
    (set s.timeout 
      (if (<= to 0)
          (do 
            (update-action o dt) 
            s.speed)
          (- to dt)))))

(let [nrows 5
      ncols 9
      enemies []
      enemies-a []]
  (for [j 1 nrows]
    (let [line []]
      (for [i 1 ncols]
        (let [x (* 32 (- i 1 (/ ncols 2)))
              y (- (* 32 (- j 1 (/ nrows 2))) 64)
              e (enemy j x y)]
          (table.insert line e)
          (table.insert enemies-a e)))
      (table.insert enemies line)))
      
  (let [scene 
    {:name "Playfield"
     :children 
     [{:id :enemies
       :name "Enemies"
       ;: draw
       : update
       :state 
       {:state :right
        :timeout 0
        :speed 1}
       :children enemies-a
       : enemies}
      (ship 0 128)]}]
    (me.scene :invaders scene)))
