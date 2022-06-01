params["_unit", "_Vehicle"];
private _RepairMoves 		= ["REPAIR_VEH_STAND", "REPAIR_VEH_KNEEL", "REPAIR_VEH_PRONE"];
Private _RepairType	 		= 0;
private _VehicleType 		= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _VehicleDimensions 	= [_VehicleType] call Tally_Fnc_GetVehicle_Width_Length;
private _LoadOut 			= getUnitLoadout _unit;
private _RepairTime			= 40;
Private _DammageToRepair	= 1 - (GetDammage _Vehicle);
Private _IterationRepair	= _DammageToRepair / _RepairTime;
private _Success			= true;
private _FuelLevel			= true;


if (_RepairType == 0)then	{
								private _Width 		= _VehicleDimensions select 0;
								private _RepairPos 	= _Vehicle modelToWorld [-(_Width / 2),0,0];
										_RepairPos	= [_RepairPos select 0,
													   _RepairPos select 1,
													   0];
								Private _Timer		= time + 10;
								private _Move		= _RepairMoves select _RepairType;
								
								
								_unit DoMove _RepairPos;
								sleep 1;
								_Unit attachTo [_Vehicle, [+(_Width / 2),0,-2]];
								_Unit SetDir 270;
								_Timer = time + _RepairTime;
								_unit switchMove "amovPknlMstpSrasWrflDnon";
								sleep 0.1;
								detach _Unit;
								_unit disableAI "all";
								[_unit, _Move, "FULL"] RemoteExecCall ["BIS_fnc_ambientAnim", 0];
								for "_I" from 1 to _RepairTime
								do 	{
										if(!Alive _Unit
										or !Alive _Vehicle) exitWith{
																		_Success = false;
																	};
										private _VehDammage = (GetDammage _Vehicle);
										if(_VehDammage < 0.5
										&&{CanMove _Vehicle
										&&{CanFire _Vehicle}}) exitWith{_Success = true};
										
										_Vehicle SetDammage _VehDammage - _IterationRepair;
										sleep 1;
									};
								
								_unit enableAI "all";
								
								if (fuel _Vehicle == 0) then 	{
																	_Vehicle SetFuel 0.1;
																};
								[_unit] RemoteExecCall ["BIS_fnc_ambientAnim__terminate", 0];
							};
if(_Success)then{
					_Vehicle setVariable ["currentAction", "Repairs completed", true];
					
				}
			else{
					_Vehicle setVariable ["currentAction", "Repairs failed", true];
				};

sleep 0.1;
_Vehicle SetVariable ["lastRepair",	time, true];
_unit setUnitLoadout _LoadOut;