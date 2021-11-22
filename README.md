# Vehicle-FSM

Built by [P] Tally (Leo Hartgen) On behalf of Dragon Company.

A small FSM function for arma 3,

Will make any armed vehicle avoid driving into a known enemy and try to find highground in the nearby area, no dependencies.
Can be seen in the arma 3 tools for a visual display of the function.

To Init the FSM do:

1) Place the "DCO_Fsm.fsm" in the mission folder.
2) write the following into "Init.sqf"   (Or "InitServer.sqf" for MP)

[300, false, 1] execFSM "DCO_Fsm.fsm";


To end the FSM ingame pass the following argument in script or in debug-consoloe:

EndVehicleFSM_now = true;


-------------------------------------------------------------------
EXPLANATION:

[300,   = the radius that the vehicle will avoid the enemy group by. Increase or decrease as you see fit.


false,  = Debug-Mode. (If true will create markers indicating all desirable positions considered by the AI)


1]      = refresh-rate for the FSM in seconds. Lower number leads to better reaction-time, but may affect overall performance.


------------------------------------------------------------------
The file named "DevFile.sqf" is only for reviewing the functions declared in the FSM file.
