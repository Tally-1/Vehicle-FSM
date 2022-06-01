
params ["_EntityArray"];
private _Infantry 		= [];
private _InfLaunchers	= [];
private _UnarmedCars	= [];
private _Cars			= [];
private _APC			= [];
private _Tanks			= [];

	{
		if (alive _x) then {
		
								if(_x iskindof "man" && {(typeOf _x) Isequalto typeof (vehicle _x)})
								then	{
											_Infantry pushBackUnique _x;
											if!(secondaryWeapon _x == "")then{_InfLaunchers pushBackUnique _x};
										}
								else	{
											private _VehicleType = [_X] call Tally_Fnc_GetVehicleType;
											
											if(_VehicleType == "unarmedCar")then{_UnarmedCars 	pushBackUnique _x};
											if(_VehicleType == "armedCar")	then{_Cars 			pushBackUnique _x};
											if(_VehicleType == "APC")		then{_APC 			pushBackUnique _x};
											if(_VehicleType == "tank")		then{_Tanks 		pushBackUnique _x};
										
										};
								
								
							};
	
	} forEach _EntityArray;


private _ReturnValue = [_Infantry,
						_InfLaunchers,
						_Cars,
						_APC,
						_Tanks];

_ReturnValue