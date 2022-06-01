
/*returns the average height from a array of positions (above sea-level)*/
Params ["_PosArr"];
Private _Heights = [];
private _AverageHeight = 0;


if (Count _PosArr > 1) then {
								{
										private _elevation = (round getTerrainHeightASL _x);
										If (TypeName _elevation == "SCALAR") then {_Heights Pushback _elevation};
										 
								}forEach _PosArr;

								If (Count _Heights > 0) then {_AverageHeight = (round ([_Heights, "Tally_Fnc_GetAVGheight"] call Tally_Fnc_GetAVG))};
							};

If (IsNil "_AverageHeight") then {_AverageHeight = 0;};

_AverageHeight