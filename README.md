# Example Simulation and Reduced Complexity Models for NetLogo
Online resources for the chapter on _Simulation and Reduced Complexity Models_ in Clifford _et al._ (2016) [_Key Methods in Geography_](https://uk.sagepub.com/en-gb/eur/key-methods-in-geography/book242938)

The model code provided here can be run in [NetLogo](http://ccl.northwestern.edu/netlogo/), a programmable environment for agent-based and multi-agent modelling. The NetLogo application can [downloaded](http://ccl.northwestern.edu/netlogo/download.shtml) and installed on your computer to run models offline, or you can run models online via [NetLogo Web](http://www.netlogoweb.org/launch). To get started with NetLogo, before interacting with the models mentioned in the chapter text, explore [the tutorials that are available for NetLogo](https://ccl.northwestern.edu/netlogo/docs/).

Once you understand the basics of how to interact with NetLogo you can try the models mentioned in the chapter text. First, you will need to download the model code files onto your computer. You can download files individually from the links below (e.g. on Windows right-click then 'Save As'):

- Model 1: [SimRed_Model1.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model1.nlogo)
- Model 2: [SimRed_Model2.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model2.nlogo)
- Model 3: [SimRed_Model3.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model3.nlogo)
- Model 4: [SimRed_Model4.nlogo](https://raw.githubusercontent.com/jamesdamillington/KeyMethodsInGeography/master/SimRed_Model4.nlogo)

Alternatively, you can download all model files at once by clicking the green 'Code' button near the top of this page, then Download ZIP, and finally unzip the downloaded file onto your computer.

Second, once you have the model files on your computer, you can explore them by either:
1. opening a model file directly with the NetLogo application (File -> Open)
2. uploading a model file to NetLogo Web (click _Browse_ in top right at)

See the suggested exercises below for ideas on how to explore the models.

## Exercises

### Model 1
- See how patterns vary for different establishment rules and random number generator seeds (i.e., different values of the `rand-seed` slider).

### Model 2
- Vary values of the `rainfall-rate` and `plant-water-req` sliders to examine the influence on number and patterns of plants that grow and spread.
- Vary the establishment option to see how this influences patterns of vegetation. For which option do you see fewer (but larger) clusters of vegetation?
- Use the `rand-seed` slider to enable consistent comparisons.

### Model 3
- Examine combinations of `p-dep`, `wind-strength` and `initial-depth` to see how different forms (spatial patterns of heights of sand) vary over time (>50,000 ticks).
- Also, examine how patterns differ for different `wind-direction`.

### Model 4
- Try changing the `log-alpha` value (producing different values for alpha, the memory parameter) to change the TSF Curve and the `ignition-rate` value to change the number of ignitions per timestep.
- Look at how these changes influence the size of fires and how restricted they are by patterns of vegetation.
