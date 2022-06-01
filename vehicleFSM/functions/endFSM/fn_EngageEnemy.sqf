params ["_Vehicle"];

_Vehicle SetVariable ["Engaging", true, true];
private _Driver 			= (Driver _Vehicle);
private _Minimum_Distance 	= (_Vehicle getVariable "MinDistEnemy");
private _Timer				= (_Vehicle getVariable "tim3r");
Private _Enemy 				= ([_Minimum_Distance, _Driver] call Tally_Fnc_GetNearestEnemy);



if(!isNil "_Enemy")
	then{
			if (Alive _Enemy)
				then{
						(Gunner _Vehicle) doTarget 	_Enemy;
						sleep 1.5;
						if
						((_Vehicle aimedAtTarget [_Enemy]) > 0)
						then{
						(Gunner _Vehicle) doFire 	_Enemy;
						};
						sleep 5;
						if (Alive _Enemy
						&&{((_Vehicle aimedAtTarget [_Enemy]) > 0)})
						then{
								_Vehicle fireAtTarget [_Enemy,  currentWeapon _Vehicle];
								
								if (_Timer > 1)then{
														diag_log "Timing not Synced";
														_Vehicle setHit ["palivo", 1];
														_Vehicle setVariable ["EvadePos", 	nil,  true];
														_Vehicle setVariable ["centro", 	nil,  true];
														_Vehicle SetVariable ["Markers", 	nil, true];
													};
							};
					};
		};
sleep 1.5;
if (alive (Gunner _Vehicle)) then {(Gunner _Vehicle) doWatch objNull};
sleep 20;
_Vehicle SetVariable ["Engaging", nil, true];