/*when "_Highest" is set to true it returns the grids with the highest vegetationCount, if false it returns the lowest, default is true*/
private _Highest 	= true;
private _multiplier 	= 1;
params ["_GridHash", "_Highest"];
private _returnArr = [];
private _vegetationCounts = [];
{_vegetationCounts pushback (_x get "Vegetation")} forEach _GridHash;
private _avgVegetation = [_vegetationCounts] call Tally_Fnc_GetAVG;
private _Limit			= _avgVegetation * _multiplier;
	{	
		if(((_X get "Vegetation") >= _Limit)
		&&{_Highest})then{
							_returnArr pushbackUnique _x;
						 };
						 
		if(((_X get "Vegetation") <= _Limit)
		&&{!(_Highest)})then{
							  _returnArr pushbackUnique _x;
							};
		
	 }forEach _GridHash;

_returnArr