params["_HidePosition", "_Crew"];
private _Side = (Side (_Crew select 0));
Private _NewGroup = createGroup _Side;
_Crew joinSilent _NewGroup;
sleep 0.1;
											
{ 
	if(alive _x
	&&{!(group _X == _NewGroup)})then	{
											_Script = [_X, _NewGroup] spawn Tally_Fnc_ForceLeave;
											waituntil {ScriptDone _Script};
										};
} forEach _Crew;



private _WP = _NewGroup addWaypoint 	[_HidePosition, 0];
_WP setWaypointBehaviour 				"AWARE";
_WP setWaypointForceBehaviour 			true;
_WP setWaypointSpeed 					"FULL";
_NewGroup deleteGroupWhenEmpty true;