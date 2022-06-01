private _multiplier = 1;
params ["_GridHash", "_Vehicle"];
private _returnArr	= [];
private _Distances 	= [];

{_Distances pushback ((_x get "position") distance2d _Vehicle)} forEach _GridHash;
private _AvgDistance = [_Distances] call Tally_Fnc_GetAVG;
private _Limit		= _AvgDistance * _multiplier;

	{	
		if(((_X get "position") distance2d _Vehicle) <= _Limit)
		then{
				_returnArr pushbackUnique _x
			};
		
	 }forEach _GridHash;

_returnArr