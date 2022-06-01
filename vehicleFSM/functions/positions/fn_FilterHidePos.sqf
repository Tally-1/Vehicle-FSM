Params ["_Vehicle", "_Center"];

private _FilteredPositions = [_Center, _Vehicle] call Tally_Fnc_Remove_NonTerrain_IntersectPos;
_Vehicle SetVariable ["HidePositions", 
					  _FilteredPositions, 
					  true];
					  
private _PosCount = count _FilteredPositions;


if (_PosCount > 10)then	{
							private _FinalPositions = [_Vehicle] Call Tally_Fnc_GetLowerThanTopPositions;
							_Vehicle SetVariable ["HidePositions", _FinalPositions, true];
							_PosCount = (count (_Vehicle GetVariable "HidePositions"));
						
if (_PosCount > 10)then	{
							_FinalPositions = [(_Vehicle GetVariable "HidePositions"), (_Vehicle GetVariable "EvadePos")] Call Tally_Fnc_GetClosePosArr;
							_Vehicle SetVariable ["HidePositions", _FinalPositions, true];
						}};





If (FSMD3Bugger) then {
								{
								//[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorWhite", "SOLID"] call Tally_Fnc_VehMarkers;
								} ForEach (_Vehicle GetVariable "HidePositions");
						};

_Vehicle SetVariable ["HiddenPosLoaded",true, true];

if(FSMD3Bugger)
then{
		systemChat format ["%1 Hide-Positions left", (count (_Vehicle GetVariable "HidePositions"))];
	};