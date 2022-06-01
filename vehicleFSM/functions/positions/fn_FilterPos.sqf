Params ["_Vehicle", "_Center"];

private _PosCount = (count (_Vehicle GetVariable "Positions"));
if (Isnil "_PosCount"
or Isnil "_Vehicle"
or Isnil "_Center")exitWith{["Could not filter flanking positions because values were undefined"] call Tally_fnc_debugMessage};

//If (FSMD3Bugger) then {[_Vehicle, "ELLIPSE", _Center, 0, 150, "Colorblue", "SOLID"] call Tally_Fnc_VehMarkers}; /*MARKS A area containing the approx enemy position*/


if(_PosCount > 10)then{
						_FinalPositions = [(_Vehicle GetVariable "Positions")] Call Tally_Fnc_GetTopHeights;
						_Vehicle SetVariable ["Positions", _FinalPositions, true];
						_PosCount = (count (_Vehicle GetVariable "Positions"));

if(_PosCount > 5)then{
						_FinalPositions = [(_Vehicle GetVariable "Positions"), _Center] Call Tally_Fnc_GetClosePosArr;
						_Vehicle SetVariable ["Positions", _FinalPositions, true];
					  }};

If (FSMD3Bugger) then {
								{
								//[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorRed", "SOLID"] call Tally_Fnc_VehMarkers;
								} ForEach (_Vehicle GetVariable "Positions");
								
								systemChat format ["%1 flank positions left", (count (_Vehicle GetVariable "Positions"))];
						};