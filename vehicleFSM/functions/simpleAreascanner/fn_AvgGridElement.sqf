params ["_GridHash", "_element"];
private _values 	= [];
{_values pushback (_x get _element)} forEach _GridHash;
private _Average 	= [_values] call Tally_Fnc_GetAVG;
_Average