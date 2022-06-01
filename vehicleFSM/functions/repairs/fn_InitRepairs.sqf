params["_Vehicle"];
private _Crew 	= (_Vehicle GetVariable "Crew");
private _Driver = driver _Vehicle;
if(IsNil "_Driver"
or IsNull _Driver)then	{_Driver = (_Vehicle GetVariable "driver")};
private _NeedRepairs 			= 	[_Vehicle] call Tally_Fnc_NeedRepairs;
private _EnemiesNearby			= false;
private _DangerClose			= false;
private _NearestEnemy 			= 	[400, _Driver] call Tally_Fnc_GetNearestEnemy;
Private _PreviousAction 		= (_Vehicle GetVariable "currentAction");
Private _timeSinceLastRepair	= time - (_Vehicle GetVariable "lastRepair");



		if!(IsNull _NearestEnemy)
		then{
				_EnemiesNearby	= true;
				
				if(_NearestEnemy distance2d _Vehicle < 120)
				then{
						_DangerClose = true;
					};
			};



If(!alive _Vehicle)	exitWith{};
if(_timeSinceLastRepair < 120)exitWith{};


If(alive _Vehicle
&&{!(IsNil "_Driver")
&&{alive _Driver
&&{_NeedRepairs
&&{!(_DangerClose)}}}})
then{
		
		_Vehicle setVariable ["repairing", true, true];
		_Vehicle setUnloadInCombat [false, false];
		_Vehicle setVariable ["currentAction", "Repairing", true];
		
		
		
		
		
		
		
		
		_Vehicle setVelocityModelSpace [0, 0, 0];
		private _Timer = time + 3;
		
		if(_EnemiesNearby)
		then{
				[_Vehicle] spawn Tally_Fnc_DeploySmoke;
				sleep 2;
			};
		
		
		private _Timer = time + 3;
		
		_Vehicle setVelocityModelSpace [0, 0, 0];
		_Driver	action ["Eject", _Vehicle];
		_Vehicle lock true;
		sleep 0.2;
			
		private _Script = [_Driver, _Vehicle] spawn Tally_Fnc_RepairVehicle;
		waituntil {scriptDone _Script};
		if(alive _Vehicle
		&&{alive _Driver})
		then{
				_Crew orderGetIn true;
				sleep 5;
				if!(vehicle _Driver == _Vehicle)
				then 	{
							_Driver MoveInDriver _Vehicle;
								
						};
				{
									private _CrewMember	= _X;
									if(alive _CrewMember
									&&{alive _Vehicle})
									then{
											if !(vehicle _CrewMember == _Vehicle)
											then{
													private _FoundPos	= false;
													
													if (_CrewMember == assignedGunner 	 _Vehicle)	then{_CrewMember MoveInGunner 		_Vehicle; _FoundPos = true};
													if (_CrewMember == assignedCommander _Vehicle)	then{_CrewMember MoveInCommander 	_Vehicle; _FoundPos = true};
													if (_CrewMember == assignedDriver 	_Vehicle)	then{_CrewMember MoveInDriver 		_Vehicle; _FoundPos = true};
													if !(_FoundPos)									then{_CrewMember MoveInCargo 		_Vehicle};
												};
										sleep 1;
										};
				}ForEach _Crew;
			};
		
		_Vehicle setVariable ["currentAction", _PreviousAction, true];
		_Vehicle setUnloadInCombat [true, false];
		_Vehicle setVariable ["repairing", false, true];
		_Vehicle lock false;
	};