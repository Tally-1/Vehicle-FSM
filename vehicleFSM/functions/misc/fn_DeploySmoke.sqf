Params ["_Vehicle"];

if((!Isnil "DCOnoSmoke"
&&{DCOnoSmoke})
or (diag_Fps < 19))exitWith{["FPS too low to deploy smoke"] call Tally_fnc_debugMessage};

Private _Commander1 			= (_Vehicle getVariable "commander");
Private _Commander2			= (commander _Vehicle);
Private _TimeSinceLastSmoke		= (time - (_Vehicle getVariable "LastSmoke"));
Private _DistanceToLastSmoke 	= ((GetPos _Vehicle) distance2d (_Vehicle getVariable "LastSmokePos"));
private _GroupVehicles 			= ([group (driver _Vehicle)] call Tally_Fnc_GetGroupVehicles);
private _SmokeNear				= false;
private _VehiclePos				= (GetPos _Vehicle);

if(Isnil "_Commander1")			then{_Commander1 			= _Commander2};
if(Isnil "_TimeSinceLastSmoke")	then{_TimeSinceLastSmoke 	= 300};
if(Isnil "_DistanceToLastSmoke")then{_DistanceToLastSmoke 	= 300};

if (!Isnil "_GroupVehicles")
	then{
			{
				private _LastSmokePos 		= (_x getVariable "LastSmokePos");
				private _TimeLastSmoke 		= (_x getVariable "LastSmoke");
				if (!Isnil "_LastSmokePos")
				then{
						private _SmokeDistance 	= (_LastSmokePos distance2d _VehiclePos);
						Private _TimeSinceSmoke = (time - _TimeLastSmoke);
						
						if(_SmokeDistance < 100
						&&{_TimeSinceSmoke < 30})
							then{
									_SmokeNear = true;
								};
					};
			}ForEach _GroupVehicles;
		};


If (Isnil "_Commander1"
&& {Isnil "_Commander2"}) exitWith{};

if((_TimeSinceLastSmoke > 120
or _DistanceToLastSmoke > 100)
&&{!(_SmokeNear)})then{

									If (!Isnil "_Commander1")exitWith	{
																			["attempting to deploy smoke"] call Tally_fnc_debugMessage;
																			
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 	5];
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 	0];
																			_Vehicle action ["UseWeapon", _Vehicle, (driver _Vehicle), 5];
																			_Vehicle action ["UseWeapon", _Vehicle, (driver _Vehicle), 0];
																			_Vehicle SetVariable ["LastSmoke",	time, true];
																			_Vehicle SetVariable ["LastSmokePos", _VehiclePos, true];
																		};

									If (!Isnil "_Commander2")exitWith	{
																			["attempting to deploy smoke"] call Tally_fnc_debugMessage;
																			
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander2, 5];
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 0];
																			_Vehicle SetVariable ["LastSmoke",	time, true];
																			_Vehicle SetVariable ["LastSmokePos", _VehiclePos, true];
																		};

								};