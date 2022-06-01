params ["_enemies"];


private _highDanger 	= [];
private _mediumDanger 	= [];
private _lowDanger 		= [];
private _Enemies_Ordered_By_Capacity = [];

{
	if((typeOf vehicle _x) == (typeOf _X))
	then {
	private _dangerValue = [_x] call Tally_Fnc_GetUnitAtCapacity;
	
	if(_dangerValue < 3)
	then{
			_lowDanger pushBackUnique _x;
		}
	else{
	if(_dangerValue < 6)
	then{
			_mediumDanger pushBackUnique _x;
		}
	else{
			_highDanger pushBackUnique _x;
		}};
		
}}forEach 
 _enemies;

{
	_Enemies_Ordered_By_Capacity pushBackUnique _x;
}forEach 
_highDanger;

{
	_Enemies_Ordered_By_Capacity pushBackUnique _x;
}forEach 
_mediumDanger;

{
	_Enemies_Ordered_By_Capacity pushBackUnique _x;
}forEach 
_lowDanger;


_Enemies_Ordered_By_Capacity