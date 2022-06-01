params ["_group"];
private _initialized = _group getVariable "initialized";
if(!IsNil "_initialized")exitWith{};
if(IsNil  "_group")		 exitWith{};

private _Leader = leader _group;

_group setVariable ["initialized", true, true];
_group setVariable ["leader_Killed", false, true];


_Leader addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	(group _unit) setVariable ["leader_Killed", true, true];
	["A squadLeader died"] 				call Tally_fnc_debugMessage;
	_unit removeEventHandler ["Killed", _thisEventHandler];
}];

if(time > 30)then{
["initialized group ", (_group)] 				call Tally_fnc_debugMessage;
};