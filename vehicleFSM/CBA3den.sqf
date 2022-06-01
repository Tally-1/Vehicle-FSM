
[
	"VehMinimumDistance",
	"SLIDER",
	["Minimum distance", "Distance between two enemies needed to activate the FSM. If a vehicle fires its weapons, then that will override this setting and initiate the Vehicle FSM regardless of distance. The recomended setting is 450 meters"],
	"DCO Vehicle FSM",
	[
		150,   //minimum 
		1500, //max
		450, //default
		0,
		false
	],
	1
] call cba_settings_fnc_init;


[
	"iterationTimer",
	"SLIDER",
	["Iteration Timer", "sets the time(seconds) between every iteration of the FSM. You may tweak this to get the best balance between overall performance and reaction time of the ai. What seems to work best on my slightly aged laptop is 2 seconds"],
	"DCO Vehicle FSM",
	[
		0.4, //minimum 
		10, //max
		2, //default
		1,
		false
	],
	1
] call cba_settings_fnc_init;


[
	"globalAgressionMultiplier",
	"SLIDER",
	["Agression multiplier", "The higher the more likely the vehicles are to push the enemy, the lower the more likely the vehicles are to hide when in contact."],
	"DCO Vehicle FSM",
	[
		0.1, //minimum 
		3, //max
		1, //default
		1,
		false
	],
	1
] call cba_settings_fnc_init;


[
	"FSMD3Bugger",
	"CHECKBOX",
	["Enable Debug mode", "Will show ai-pathing and status, as well as markers showing the areas the ai is calculating"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"VehicleAutoRepair",
	"CHECKBOX",
	["Enable crew Auto Repair", "if checked the crew will fix the vehicle when needed"],
	"DCO Vehicle FSM",
	true
] call cba_settings_fnc_init;

[
	"DCOquickReaction",
	"LIST",
	["Quick reaction", "Sets the behaviour of a vehicle if it gets hit or fires its weapon when not previously engaged"],
	"DCO Vehicle FSM",
	[
		[0, 1, 2], 
		["No quick reaction", "Move out only", "Face enemy, supressive fire then move."], 
		1
	]
] call cba_settings_fnc_init;

[
	"DCOCourageMultiplier",
	"CHECKBOX",
	["Courage affects decisions", "if checked the decisions will be weighed by the courage of the squad-leader, if he dies it is then the average courage of the remaining units in the group that decides. The higher the courage, the more likely he is to push, and vice versa."],
	"DCO Vehicle FSM",
	true
] call cba_settings_fnc_init;

[
	"DCOnoSmoke",
	"CHECKBOX",
	["Disable extra smoke", "this option stops crews from using smoke as a evasive tactic (may help performance)"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"DCOnoGroupReset",
	"CHECKBOX",
	["Disable group reset", "Stops groups from reseting when in contact. Disable this option if you experience trouble with other ai-mods (will in some cases make vehicles less responsive)"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"DCOexcludePlayerGroups",
	"CHECKBOX",
	["Exclude player groups", "Any group with a player in it, or containing a zeus-controlled unit will not be affected by the vehicle FSM."],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"DCOnoHideGlobal",
	"CHECKBOX",
	["Disable hiding", "Stops all vehicles from hiding"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"DCOnoFlankGlobal",
	"CHECKBOX",
	["Disable flanking", "Stops all vehicles from flanking"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;

[
	"DCOnoPushGlobal",
	"CHECKBOX",
	["Disable pushing", "Stops all vehicles from pushing"],
	"DCO Vehicle FSM",
	false
] call cba_settings_fnc_init;