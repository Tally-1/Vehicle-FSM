params ["_Vehicle"];
private _Crew = (_Vehicle GetVariable "crew");
private _InVehicle = false;
if (isnil "_Crew")then{_InVehicle = true}
else{
		{
			if (vehicle _X == _Vehicle)then {
												_InVehicle = true;
											};
		}ForEach _Crew;
	};	
_InVehicle