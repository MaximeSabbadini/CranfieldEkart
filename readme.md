## Code and Simulink Model for the Cranfield e-Kart ##
##### Code written by Maxime Sabbadini, Automotive Mechatronics MSc #####

To execute the simulink model, run before the "CreateAllControllers.m" script.
Then, the Simulink Model is ready to be uploaded on the e-kart. 
Attention : It might happen that sometime the Raspberry Pi does not pick up the data from the CAN Bus.If it is the case, upload "Currentreqtest.slx" to the raspberry-Pi and then upload back again the "Main_ekart.slx". If there is some packet loss in the system, simply raise the sampling frequency of the Pi (set to 500Hz now). Feel free to change the control strategy in the Simulink file but bear in mind that you have to give a particular attention to the signals that would be sent to the motors in order not to damage them. Also, there needs to be some work done on the safety side of the project. The code for the arduino is given in the Arduinocode folder


Enjoy !


#### Maxime Sabbadini, maxime.sabbadini7@gmail.com 
