/*Gets the average distance between one point and an array of positions*/
Params ["_PosArr", "_Center"];

Private _Distances = [];
private _AverageDistance = 0;

if (Count _PosArr > 1) then {
								{
											private _Dist = (_Center Distance2D _x);
											If (TypeName _Dist == "SCALAR") then {_Distances Pushback _Dist};
								
								}forEach _PosArr;


								If (Count _Distances > 0) then {_AverageDistance = ([_Distances, "Tally_Fnc_GetAVG_Distance"] call Tally_Fnc_GetAVG)};
							};

If (IsNil "_AverageDistance") then {_AverageDistance = 0};

_AverageDistance