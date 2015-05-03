;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                                                              ;;
;;              Vegetation-Moisture Feedback 2 - May 2015                       ;;
;;                                                                              ;;
;;  Code licenced by James D.A. Millington (http://www.landscapemodelling.net)  ;;
;;  under a Creative Commons Attribution-Noncommercial-Share Alike 3.0          ;;
;;  Unported License (see http://creativecommons.org/licenses/by-nc-sa/3.0/)    ;;
;;                                                                              ;;
;;  Model and documentation available from http://github.com                    ;;
;;                                                                              ;;
;;  Model used in:                                                              ;;
;;  Millington, J.D.A. (2015) Simulation and reduced complexity models          ;; 
;;  In Clifford et al. (Eds) Key Methods in Geography London: SAGE              ;;
;;                                                                              ;;
;;  Model based on ideas in HilleRisLambers et al., 2001                        ;;
;;                                                                              ;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


breed [plants plant]   ;create a breed called plants (this allows us to refer to 'plants' instead of turtles below)
breed [rain drop]      ;create a breed called rain [singular drop] (this allows us to refer to rain and drops instead of turtles below)

patches-own
[
  plant-density        ;patch variable is to record the density of plants on this an neighboring patches
  infiltration-rate    ;patch variable directly related to the plant-density variable
  soil-moisture       
]

rain-own
[
  volume               ;volume of water contained in each drop of rain
]



to setup 

  ca
  random-seed rand-seed              ;set the random number seed using the user-specified value
  reset-ticks
  
  ask patches 
  [ 
    set pcolor brown 
    set soil-moisture 0       ;initially soil-moisture is zero
    set infiltration-rate 1   ;initially patch infiltration-rate has a value of 1
  ]
end


to go

  rainfall    ;rain drops 'fall' and then drain across the on the soil surface
  
  seedfall    ;seeds scatter (randomly) across the soil surface
  
  die-spread    ;kill plants with insufficent water and spread vegetation across surface

  
  ;update soil conditions   
  ask patches [ calc-plant-density ]
  ask patches
  [ 
    calc-infiltration

    ifelse(any? plants-here) 
    [ set soil-moisture (soil-moisture - 0.05)]
    [ set soil-moisture (soil-moisture - 0.01)]
    
    if(soil-moisture < 0) [ set soil-moisture 0 ]
  ]
  
  update-display
  
  
  ;stopping rule
  if(count turtles >= 80) [ stop ]  

end

to rainfall
  
  ask n-of rainfall-rate patches    ;use rainfall-rate to determine how many rain drops falls on patches
  [ 
    sprout-rain 1                          ;for each patch on which a drop of rain falls...
    [
      ifelse(show-rain) [ pd ] [ ht ]   ;if the user wants to see the rain put the pen down (pd), otherwise hide (ht)
      set color 109
      set volume random 30            ;set the volume of this drop of rain (random from 0 to 29)
      set heading random 360          ;set a random direction for the drop of rain to run across the surface
      drain                           ;run the drain procedure (drain drops across the surface)
    ]
  ]
   
end



to drain  ;drop of rain (i.e. 'turtle') procedure (i.e. called by a drop of rain)
  
  if(volume <= 0) [ die ]      ;when all the water in the rain drop has drained into the soil, 'kill' the drop
  let v volume                 ;create a temporary variable to record the 
  
  ask patch-here
  [
    ifelse(infiltration-rate > v)  ;if infiltration-rate is greater than the current colume of the drop
    [ 
      set soil-moisture v          ;drain all the water in the drop into the soil
      ask myself [ set volume 0 ]  ;set volume of the draining drop to zero (it all drained into the soil)
    ]
    [ 
      set soil-moisture (soil-moisture + infiltration-rate)  ;otherwise, drain infiltration-rate amount of water into the soil 
      ask myself [ set volume (v - infiltration-rate) ]      ;reduce the volume of water in the drop by the amount that drained into the soil (i.e. the value of infiltration-rate)
    ]
  ]
  
  fd 1                        ;after draining water into the soil, if the drop is still 'alive' (i.e. has some water) move it forward onto the next patch
  set heading random 360      ;randomly change direction of the draining drop
  drain                       ;run this procedure again - recursive call!  
  
end
  

to seedfall
  
  ask one-of patches            ;for a randomly selected patch
  [
    if(not any? plants-here)    ;if there's not already a plant here
    [
      sprout-plants 1                  ;grow a plant
      [ 
        if(not show-plants) [ ht ]     ;hide the plant if the user does not want to see plants
        set shape "circle"
        set color green
      ]
    ]
  ]
  
end


to die-spread  

  ask plants          ;ask all plants living on the surface
  [
    if([soil-moisture] of patch-here <= plant-water-req)   ;if soil moisture is insufficient for the plant, kill it
    [ 
      die 
    ]
    
    
    ;next section spreads vegetation from existing plants
    ask patch-here
    [      
      let grow-location nobody  ;this is an agentset that will contain the patch where the next plant should grow

      ;first establish which neighbouring patches without existing plants have sufficient soil moisture 
      let possible-grow-locations neighbors with [not any? plants-here and soil-moisture >= plant-water-req] 
                
      if(any? possible-grow-locations)  ;if there are any suitable neighbouring patches
      [
        
        ;if user has selected 'random' establishment, set the grow-location patch to be a radomly selected possible-grow-location
        if(establishment = "Random") [ set grow-location one-of possible-grow-locations ] 
        
        ;if the user has selected 'wettest' establishment, set grow-location to the possible-grow-location with the greatest soil-moisture
        if(establishment = "Wettest") [ set grow-location max-one-of possible-grow-locations [ soil-moisture ]]
        
        ask grow-location 
        [
          sprout-plants 1                  ;grow a plant
          [ 
            if(not show-plants) [ ht ]     ;hide the plant if the user does not want to see plants
            set shape "circle"
            set color green
          ]
        ]
      ]
    ]

  ]

end
     



to calc-plant-density

  let neighbour-plants plants-on neighbors              ;an agent-set of plant on neighbouring patches
  let count-neighbour-plants count neighbour-plants     ;count the number of plants in the agent-set just created
  if any? plants-here [ set count-neighbour-plants count-neighbour-plants + 1 ]    ;include the plant on the focal patch (if there is one) in the count of plants
  
  ifelse (count-neighbour-plants > 0)                   ;if there are any plants in this neighbourhood
  [ set plant-density count-neighbour-plants / 9 ]      ;calculate the plant density by dividing the number of plants by the 9 patches in the neighbourhood
  [ set plant-density 0 ]                               ;otherwise (i.e. no plants here) set density to zero

end  
  
  
  

to calc-infiltration

  set infiltration-rate 100 * plant-density               ;infiltration rate is a function of plant density
  if(infiltration-rate = 0) [ set infiltration-rate 1 ]   ;minimum allowable infoltration-rate is value of 1
    
end

  
to update-display
  
  ifelse(show-plants)     ;show or hide the plants
  [ ask plants [ st ] ]
  [ ask plants [ ht ] ]

  if(not show-rain) [ clear-drawing ]  ;clear the lines showing tracks of rain drop that have drained across the surface
    
  if(patch-colour = "soil") [ ask patches [ set pcolor brown ] ]   ;if user has specified 'soil' for display, simply set all patches to be brown
  if(patch-colour = "soil-moisture")                               ;if user has specified soil moisture, use soil-moisture to scale the patch-colour a shade of blue
  [
    ask patches [
      ifelse(soil-moisture > 0)     ;if positive soil mosture
      [
        let val soil-moisture / 5   ;create a dummy value as a proportion of soil-moisture
        set pcolor 92 + val         ;add the dummy value to create a lighter shade of blue (92 = dark blue, see NetLogo Programming Guide)
      ]
      [ set pcolor 92 ]      ;else if soil moisture is zero, set dark blue
    ]
  ]
    
  if(patch-colour = "plant-density")   ;similar to scaling colour by soil-moisture but this time use plant-density and a green shade
  [
    ask patches [
      ifelse(plant-density > 0)
      [
        let val plant-density * 5 
        set pcolor 73 + val
      ]
      [ set pcolor 73 ]
    ]
  ]
  
  if(patch-colour = "infiltration-rate")  ;similar to scaling colour by soil-moisture but this time use infiltration-rate and an orange shade
  [
    ask patches [
      ifelse(infiltration-rate > 0)
      [
        let val infiltration-rate / 25
        set pcolor 33 + val 
      ]
      [ set pcolor 33 ]
    ]
  ]
  
end   
@#$#@#$#@
GRAPHICS-WINDOW
236
10
656
451
20
20
10.0
1
10
1
1
1
0
1
1
1
-20
20
-20
20
0
0
0
NIL
30.0

BUTTON
21
16
88
49
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
94
16
157
49
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
162
16
225
49
step
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SWITCH
21
92
131
125
show-plants
show-plants
0
1
-1000

BUTTON
21
54
134
87
update-display
update-display
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
21
132
159
177
patch-colour
patch-colour
"soil" "soil-moisture" "infiltration-rate" "plant-density"
1

SLIDER
21
179
158
212
rainfall-rate
rainfall-rate
0
5
5
1
1
NIL
HORIZONTAL

SLIDER
20
216
158
249
plant-water-req
plant-water-req
0
5
5
1
1
NIL
HORIZONTAL

SWITCH
133
92
230
125
show-rain
show-rain
1
1
-1000

CHOOSER
20
256
158
301
establishment
establishment
"Wettest" "Random"
1

SLIDER
20
308
158
341
rand-seed
rand-seed
0
10000
4018
1
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

This model demonstrates the findings of HilleRisLambers et al. (2001) that positive feedbacks between soil conditions and patches of vegetation can lead to spatial patterns of vegetation in the absence of any underlying spatial heterogeneity.  

## HOW IT WORKS

Rain drops fall randomly across a soil surface and then run overland in random directions (due to lack of slope) in a random walk process. As the rain-water runs overland it infiltrates into soil, increasing the moisture available for plants to grow, with infiltration rates in-turn influenced by plant density. Even with random rainfall, the modifications to infiltrations rates due to plant density results in clustering of plant patches across the simulated surface.

Rain drops fall at a rate specified by the _rainfall-rate_ slider. Plants require an amount of water to grow specified by the _plant-water-req_ slider. Water infiltrates into the soil, changing soil-moisture, at a rate dependent on plant density. Vegetation spreads as plants establish on patches neighbouring existing plants. The neighbouring patch on which establishment occurs is either random or that with the greatest soil-moisture (as determined by the _establishment_ chooser).  

## HOW TO USE IT

Select the values you want for the _rainfall-rate_ and _plant-water-req_ sliders and the option for the _establishment_ chooser (as described in the HOW IT WORKS section. Then click setup button, then click go button to run the model. 

To repeat identical runs use identical values for the sliders and choosers above AND the _rand-seed_ slider (this sets the random number generator seed). 

To vary what you can see in the model environment change values for _show-plants_, _show-rain_ and _patch-colour_. _show-rain_ will show the routes drops of water take as they run across the surface. Use the _Update Display_ button after changing these values. 
 
## THINGS TO NOTICE

Run the model with _show-rain_ on and notice how clusters of plants grow together despite rain running all over the surface. 

## THINGS TO TRY

Vary values of _rainfall-rate_ and _plant-water-req_ to examine the influence on number and patterns of plants that grow and spread. 

Vary the _establishment_ option to see how this influences patterns of vegetation. For which option do you see fewer (but larger) clusters of vegetation.

Use the _rand-seed_ slider to enable consistent comparisons.  

## CREDITS AND REFERENCES

HilleRisLambers, R., Rietkerk, M., van den Bosch, F., Prins, H. H., & de Kroon, H. (2001) Vegetation pattern formation in semi-arid grazing systems. _Ecology_ 82(1) 50-61

Millington, J.D.A. (2015) Simulation and reduced complexity models In Clifford et al. (Eds) _Key Methods in Geography_ London: SAGE                 

Code licenced by James D.A. Millington (http://www.landscapemodelling.net) under a Creative Commons Attribution-Noncommercial-Share Alike 3.0 Unported License (see http://creativecommons.org/licenses/by-nc-sa/3.0/)                                                                       

Model and documentation available on http://github.com                  
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
