# Vehicle-FSM

BUilt by [P] Tally (Leo Hartgen) On behalf of Dragon Company.

Vehicle AI for A3
A small FSM function for arma 3,

Will make any armed vehicle avoid driving into a known enemy and try to find highground in the nearby area, no dependencies.

To Init the FSM do:

1) Place the file in the mission folder.
2) write the following into "Init.sqf"   (Or "InitServer.sqf" for MP)

[300, false, 1] execFSM "DCO_Fsm.fsm";

[300,   = the radius that the vehicle will avoid the enemy group by. Increase or decrease as you see fit
false,  = Debug-Mode. (If true will create markers indicating all desirable positions considered by the AI)
1]      = refresh-rate for the FSM in seconds. Lower number leads to better reaction-time, but may affect performance.
