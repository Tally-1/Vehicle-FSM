params ["_Vehicle"];
private _destroyed 	= [_Vehicle] call Tally_Fnc_crewDead;

if(_destroyed)exitWith{false};

private _Group 		= (group _Vehicle);
private _hasWP		= ((count waypoints _Group) > 0);
private _engaged	= [_Vehicle] call Tally_Fnc_GroupFsmActive;

private _Available 	= (_hasWP
					&&{!(_engaged)});

_Available