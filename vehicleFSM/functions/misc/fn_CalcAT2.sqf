params ["_Array"];
Private _AT_Capacity_Final = 0;


	{
		Private _AT_Capacity		= 0;
		
		if (alive _x) then {
								if(_x iskindof "man" && {(typeOf _x) Isequalto typeof (vehicle _x)})
								then	{
																				
											if(secondaryWeapon _x == "")then{
																				_AT_Capacity = (_AT_Capacity + (DCO_AT_Values get "Infantry"));
																			}
																		else{
																				_AT_Capacity = (_AT_Capacity + (DCO_AT_Values get "AT Infantry"));
																			};
										}
								else	{
											private _VehicleType = [_X] call Tally_Fnc_GetVehicleType;
											_AT_Capacity = (_AT_Capacity + (DCO_AT_Values get _VehicleType));
										};
										
										
							};
							
		if(isnil "_AT_Capacity")then{_AT_Capacity = 0};	
		_AT_Capacity_Final = (_AT_Capacity_Final + _AT_Capacity);
		
	}ForEach _Array;


if 	((count _Array == 0)
or	(_AT_Capacity_Final == 0)) then 		{
										_AT_Capacity = 1234567890;
										["AT capacity could not be calculated"] call Tally_fnc_debugMessage;
									};
_AT_Capacity_Final