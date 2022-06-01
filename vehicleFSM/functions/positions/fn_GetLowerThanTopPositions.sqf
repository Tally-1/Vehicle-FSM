params ["_Vehicle"];
private _FlankPositions 	= (_Vehicle GetVariable "Positions");
private _HidePositions 		= (_Vehicle GetVariable "HidePositions");

	if(IsNil "_FlankPositions") exitWith 	{
												_HidePositions
											};

private _AverageFlankHeight = [_FlankPositions] call Tally_Fnc_GetAVGheight;
private _newArr				= [];


{
	private _elevation = (round getTerrainHeightASL _x);
	if(_elevation < _AverageFlankHeight)then{
												_newArr pushBackUnique _X;
											};
}forEach _HidePositions;


_newArr