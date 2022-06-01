params ["_unit"];
Private _AT_Capacity		= 0;
if(isNil "_unit") exitWith {_AT_Capacity};

if (alive _unit) then {
								if(_unit iskindof "man" 
								&& {(typeOf _unit) Isequalto typeof (vehicle _unit)})
								then	{
																				
											if(secondaryWeapon _unit == "")then{
																				_AT_Capacity = (DCO_AT_Values get "Infantry");
																			}
																		else{
																				_AT_Capacity = (DCO_AT_Values get "AT Infantry");
																			};
										}
								else	{
											private _VehicleType = [_unit] call Tally_Fnc_GetVehicleType;
											_AT_Capacity = (DCO_AT_Values get _VehicleType);
										};
										
										
							};

_AT_Capacity