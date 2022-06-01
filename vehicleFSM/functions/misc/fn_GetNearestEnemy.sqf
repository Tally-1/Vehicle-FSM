Private _Enemy = objnull; 
Params ["_Radius", "_Unit"];

if (IsNil "_Radius")then{_Radius = 1000};
if (IsNil "_Unit")exitWith{_Enemy};

Private _pos 	= (GetPos _Unit);
private _list 	= _pos nearObjects _Radius;
Private _Side 	= (Side _Unit);
private _Enemies = [];



	{
	if (_x iskindof "Land"
	&& {alive _x}) 			then {
									
									/*Excludes infantry, friendlies, helis and "objects"*/
									If ((side _x) in [west, east, Independent])/**/
									then{
									
									If (!((Side _x) == (_Side)))
									then {
									
									Private _Otherside = (Side _X);
									if !([_Side, _Otherside] call BIS_fnc_sideIsFriendly) 
									then {
									
									_Enemies PushbackUnique _x;
									
									}}}}}
									ForEach _list;

If ((count _Enemies) > 0) then {
									_Enemy = [_Pos, _Enemies] call Tally_Fnc_GetNearestObject;
								};



_Enemy