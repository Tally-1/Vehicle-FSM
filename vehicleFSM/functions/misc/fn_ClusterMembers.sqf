Params ["_Unit", "_Radius"];
private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _NewList = [_Unit];

	{				
	if 	((Side _x) == (_Side))
	then 	{
			
				_NewList PushBackUnique _X;
			};
			
	}ForEach _list;
_NewList