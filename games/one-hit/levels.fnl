(local mpath (: ... :gsub "%.[^%.]+$" ""))

(local hero (require (.. mpath ".hero")))

(local coord-mapping
 {"+" [4 2]
  "=" [10 3]
  "(" [9 3]
  ")" [13 3]
  "-" [2 3]
  "," [1 3]
  "." [7 3]
  "[" [3 2]
  "]" [5 2]
  ">" [3 3]
  "<" [5 3]
  "_" [3 4]})

(local quad-cache [])

(local image (me.new-image :grass))

(fn get-quad [coords x y]
  (let [[cx cy] coords
        key (string.format "%d:%d" cx cy)
        (w h) (image:getDimensions)]
    (when (not (. quad-cache key))
      (tset quad-cache key (lg.newQuad (* cx 16) (* cy 16) 16 16 w h)))
    (. quad-cache key)))
        
(fn new-level [level-name data]
  (let [h (length data)
        w (length (. data 1))
        bg (lg.newCanvas (* w 16) (* h 16))
        bg-obj []]
    (lg.setCanvas bg)
    (each [j line (ipairs data)]
      (for [i 1 (length line)]
        (let [cell (line:sub i i)
              coords (. coord-mapping cell)]
          (when coords
            (let [quad (get-quad coords i j)]
              (lg.draw image quad (* i 16) (* j 16)))))))
    (lg.setCanvas)
    (set bg-obj.background bg)

    (fn bg-obj.draw [o]
      (lg.draw o.background -128 -96))
              
    (me.scene level-name
     {:children
      [bg-obj
       (hero)]})))
  
(fn new-level-wfc [level-name data])
  ;(let [new-data []]
  ;  (new-level level-name new-data)))
  
(new-level :level1
  ["            "
   " (========) "
   "            "
   "            "
   "    ,--.    "
   "    [++]    "
   " ,-->++<--. "
   " `________' "
   "            "])
 
(new-level-wfc :level1
  ["            "
   " ++++++++++ "
   "            "
   "            "
   "    ++++    "
   "    ++++    "
   " ++++++++++ "
   " ++++++++++ "
   "            "])
