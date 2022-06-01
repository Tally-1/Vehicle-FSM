params ["_Vehicle", "_Minimum_Distance"];
private _Multiplier	 = 1;
private _VehicleType = ([_Vehicle] call Tally_Fnc_GetVehicleType);

if (_VehicleType == "APC") then {
									_Multiplier	 = 1.25;
								};

if (_VehicleType == "tank") then {
									_Multiplier	 = 1.5;
								};
								
if (_Vehicle isKindOf "helicopter") then {
											_Multiplier	 = 4;
										};

_Minimum_Distance = (_Minimum_Distance * _Multiplier);

_Minimum_Distance