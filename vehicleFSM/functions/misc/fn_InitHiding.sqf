params ["_Vehicle"];

private _HidePos 	= [_Vehicle, (_Vehicle GetVariable "HidePositions")] call Tally_Fnc_GetNearestObject;
private _Commander 	= (commander _Vehicle);
private _Group 		= (group (driver _Vehicle));


/*[_Group] call Tally_Fnc_DeleteWP;*/
[_Group] spawn Tally_Fnc_ResetGroup;

_Vehicle setVariable ["currentAction", 	"hide", true];
_Vehicle SetVariable ["EvadePos", 		_HidePos, true];

[_Vehicle, _HidePos] spawn Tally_Fnc_SoftMove;

If (FSMD3Bugger) then 	{
							[_Vehicle] call Tally_Fnc_SelectedPositionMarkers;
						};