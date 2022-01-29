# Simulation and Reduced Complexity Models
Online resources for chapter on _Simulation and Reduced Complexity Models_ in Clifford _et al._ (2016) [_Key Methods in Geography_](https://uk.sagepub.com/en-gb/eur/key-methods-in-geography/book242938)

Model code can be run in [NetLogo](http://ccl.northwestern.edu/netlogo/), a programmable modeling environment for agent-based and multi-agent modelling. The NetLogo application can [downloaded](http://ccl.northwestern.edu/netlogo/download.shtml) and installed on your computer to run models offline, or you can run models online via [NetLogo web](http://www.netlogoweb.org/launch). To get started with NetLogo, before interacting with the models mentioned in the chapter text, explore [the tutorials that are available for NetLogo](https://ccl.northwestern.edu/netlogo/docs/). 

Once you understand the basics of how to interact with NetLogo you can try the models mention in the chapter text. First, you will need to download the model code files. You can download files individually from the links below (e.g. right-click then 'Save As' on Windows), or download all model files at once by clicking the green code button above, then Download ZIP.

- Model 1: [SimRed_Model1.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model1.nlogo)
- Model 2: [SimRed_Model2.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model2.nlogo)
- Model 3: [SimRed_Model3.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model3.nlogo)
- Model 4: [SimRed_Model4.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model4.nlogo)

Once downloaded you can open with the NetLogo application or upload to NetLogo Web and work with the model there. 

See the suggested exercises below for ideas on how to explore the models.

## Exercises

### Model 1
- See how patterns vary for different establishment rules and random number generator seeds (i.e., different values of `rand-seed`).

### Model 2
- Vary values of `rainfall-rate` and `plant-water-req` to examine the influence on number and patterns of plants that grow and spread.
- Vary the establishment option to see how this influences patterns of vegetation. For which option do you see fewer (but larger) clusters of vegetation?
- Use the `rand-seed` slider to enable consistent comparisons.

### Model 3
- Examine combinations of `p-dep`, `wind-strength` and `initial-depth` to see how different forms (spatial patterns of heights of sand) vary over time (>50,000 ticks).
- Also, examine how patterns differ for different `wind-direction`.

### Model 4
- Try changing the `log-alpha` value (producing different values for alpha, the memory parameter) to change the TSF Curve and the `ignition-rate` value to change the number of ignitions per timestep.
- Look at how these changes influence the size of fires and how restricted they are by patterns of vegetation.
