private _Highest = true;
private _multiplier = 1;
params ["_GridHash", "_Highest"];
private _returnArr 	= [];
private _heights 	= [];
{_heights pushback (_x get "Altitude")} forEach _GridHash;
private _AvgHeight 	= [_heights] call Tally_Fnc_GetAVG;
private _Limit		= _AvgHeight * _multiplier;
	
	{	
		if(((_X get "Altitude") >= _Limit)
		&&{_Highest})then{
							_returnArr pushbackUnique _x;
						 };
						 
		if(((_X get "Altitude") <= _Limit)
		&&{!(_Highest)})then{
							  _returnArr pushbackUnique _x;
							};
		
	 }forEach _GridHash;

_returnArr