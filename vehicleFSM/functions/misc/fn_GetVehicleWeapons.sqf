params ["_Vehicle"];
Private _allWeapons 	= weapons _Vehicle;


{
	_allWeapons pushBackUnique _X;
}ForEach (_Vehicle weaponsTurret [-1]);

_allWeapons