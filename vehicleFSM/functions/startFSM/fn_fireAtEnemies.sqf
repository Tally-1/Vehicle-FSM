_maxEngagementTime = 10;
params ["_Vehicle", "_enemies", "_maxEngagementTime"];
if(count _enemies < 1)exitWith{["no enemies, cannot fire"] call Tally_fnc_debugMessage};
private _counter 		= 0;
private _orderedEnemies 	= [_enemies] call Tally_Fnc_prioritizeEnemies;
private _target 			= (_orderedEnemies select _counter);
private _currentTarget 	= _target;
_Vehicle setVariable ["currentAction", "Suppressing enemy",	true];
/*
for "_I" from 1 to 2
do	{
_counter 		= 0;
		{*/
			private _timer = time + 1.5;
			_target = (_orderedEnemies select 0);
			if(!Isnil "_target"
			&&{alive _target})
			then{
					_currentTarget 	= _target;
				};
			private _targetPos 	= [(getPos _currentTarget), 1] call Tally_Fnc_Add_Z;
			private _vehPos 	= [(getPos _Vehicle), 1.5] call Tally_Fnc_Add_Z;
			
			if([_vehPos, _targetPos, 10] call Tally_Fnc_LOS_Light)
			then{
					If((currentCommand _Vehicle) == "Suppress")
					then{
							/*_Vehicle doFire _currentTarget*/
						}
					else{
							_Vehicle doSuppressiveFire (getPos _currentTarget);
						};
					
					_counter = (_counter + 1);
					sleep 10;/*((_maxEngagementTime / 2) / (count _orderedEnemies))*/;
				};
			
			
	/*	}forEach _orderedEnemies;
	};*/
_Vehicle doFire _currentTarget;