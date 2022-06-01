params["_Group"];
private	_Vehicles = [];

{
private _GroupVehicle = (Vehicle _X);
If!(_GroupVehicle isKindOf "man")then{

private _CrewCount = (count (crew _GroupVehicle));

If(_CrewCount > 0)then	{
							_Vehicles pushBackUnique _GroupVehicle;
						}};
	
}forEach units _Group;

_Vehicles