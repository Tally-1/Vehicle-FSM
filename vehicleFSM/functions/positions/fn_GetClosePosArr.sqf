
Params ["_PosArr", "_Center"];
Private _NewArr = [];

if (isNil "_Center")exitWith{_PosArr};

Private _AverageDistance = (Round ([_PosArr, _Center] call Tally_Fnc_GetAVG_Distance));
		
if(isNil "_Center")exitWith{_PosArr};
		
{
	Private _Distance = (Round(_Center Distance2D _X));
										
	If (_Distance < _AverageDistance) Then	{
												_NewArr pushBackUnique _X;
											};
}ForEach _PosArr;



_NewArr