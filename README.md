# Ciclon
### A Matlab toolbox for fixed-wing aircraft analysis and optimization,covering Aerodynamics, Performance, Stability and Control.
### Work in progress...

![cover](https://raw.githubusercontent.com/manrd/Ciclon/main/Images/ImEx1.PNG) 

## How to contribute

- Fork the project
- Code!

## How does it work?

-Have Matlab R2018b (or newer, but it may not work if Matworks changes something significant)
-Have the aerospace toolset installed.
-Set matlab to the main folder that contains the repository.
-Type in the command window "GoCiclon" (without the "", of course).
-Create or load an aircraft geometry (details on how to do this to be added to the readme)
-From here on it is possible to do a VLM analisys using Tornado or AVL from Ciclon's GUI, use these results to generate a Flight Dynamics Model, run flight simulations with a basic autopilot (or you can fly manually to get a "feel" of the aircraft), perform some performance, stability and control computations using either the VLM data or the dynamic model, or optimize the geometry if you define a fitness function.

The dynamic model can output data to FlightGear if you want to have a visual representation of the aircraft, else you can just plot the data and use it as you need in matlab.

Details on how to do these things are yet to be written... but you might be able to figure some of those out if you take a look at the code.

## Expect bugs!!
and also expect a mix of English, Spanish and Portuguese in the code and the GUI.




## Contact
Developed with :heart: by [Manuel Alejandro Rodriguez Diaz](https://github.com/manrd) (manuelrd@ita.br)

**Special thanks to:** Leonardo Mariga, and every participant of the SAE Aerodeisgn :D. 
