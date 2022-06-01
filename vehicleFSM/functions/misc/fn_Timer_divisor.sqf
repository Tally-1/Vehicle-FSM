params ["_Vehicle"];
private _divisor		= 6;
private _VehicleType 	= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _SlowVehicles 	= ["APC", "TANK"];

if(_VehicleType in _SlowVehicles)then{_divisor = 3};

_divisor