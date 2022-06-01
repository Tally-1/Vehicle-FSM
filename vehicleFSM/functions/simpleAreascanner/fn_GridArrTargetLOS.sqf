private _noLos 		= true;
params ["_GridHash", "_noLos"];
private _returnArr = [];
{
	if((_x get "terrainIntersects targetPos") == (_noLos))
		then{
				_returnArr pushbackUnique _X;
			};
}forEach _GridHash;
_returnArr