params ["_Vehicle", "_actionTime"];

if(DCOquickReaction == 0)exitWith{};

private _Group 				= group _Vehicle;
private _Driver 				= driver _Vehicle;
private _LastPreScan 		= _Group getVariable "DCO_AreaScan";
private _enemies			= _Vehicle getVariable "KnownEnemies";
private _enemyPos			= _Vehicle getVariable "centro";
private _Minimum_Distance 	= _Vehicle getVariable "MinDistEnemy";
private _EvasionPos			= _Vehicle getVariable "EvadePos";
private _enemyCapacity 		= [_enemies] call Tally_Fnc_CalcAT2;
private _timer				= time + _actionTime;
private _deploySmoke		= false;
private _vehicleType			= [_Vehicle] call Tally_Fnc_GetVehicleType;
private _cars				= ["unknown", "unarmedCar", "armedCar"];
		_Vehicle setVariable ["currentAction", "Evasive manouvers",	true];

if(!isNil "_enemies"
&&{!isNil "_enemyCapacity"})
then{
		if(_enemyCapacity >= 3)then{_deploySmoke = true};
	};

if(!IsNil "_LastPreScan"
&&{(_Vehicle distance2d (_LastPreScan get "center")) < DCO_GridSize})
then{
		private _gridPos = [_LastPreScan, _Vehicle] call Tally_Fnc_CoverPosFromGrid;
		_EvasionPos	= _gridPos get "position";
		_Vehicle setVariable ["EvadePos", _EvasionPos, true];
	}
else{["**DCO** No prescan found, using default position"] call Tally_fnc_debugMessage};

if(_vehicleType in _cars
or DCOquickReaction == 1)
exitWith{
			_Vehicle doFire	([_Minimum_Distance, _Driver] call Tally_Fnc_GetNearestEnemy);
			sleep 0.1;
			for "_I" from 1 to 3 do{_Vehicle doMove _EvasionPos};
			{_X disableAI "AUTOCOMBAT"} ForEach (_Vehicle getVariable "crew");
			{_X disableAI "TARGET"} ForEach (_Vehicle getVariable "crew");
			_Vehicle forceSpeed 40;/*meters pr second*/
			[_Vehicle, _EvasionPos] 	call Tally_Fnc_SoftMove;
			sleep (_actionTime / 2);
			{_X enableAI "AUTOCOMBAT"} ForEach (_Vehicle getVariable "crew");
			{_X enableAI "TARGET"} ForEach (_Vehicle getVariable "crew");
			_Vehicle forceSpeed -1;/*return to normal*/
		
		};

private _moveScript = [_vehicle, _enemyPos, _enemies, 100, (_actionTime / 2), _deploySmoke] spawn Tally_Fnc_FacePos_And_Reverse;
waituntil { sleep 1; scriptDone _moveScript};
for "_I" from 1 to 3 do{_Vehicle doMove _EvasionPos};

if([_Vehicle] call Tally_Fnc_CheckCrewStatus == -1)exitWith{[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions};

_script = [_Vehicle, _enemies, (_actionTime / 2)] spawn Tally_Fnc_fireAtEnemies;
waituntil{sleep 0.1; scriptDone _script};
for "_I" from 1 to 3 do{_Vehicle doMove _EvasionPos};

if([_Vehicle] call Tally_Fnc_CheckCrewStatus == -1)exitWith{[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions};






for "_I" from 1 to 3 do{_Vehicle doMove _EvasionPos};
waituntil{sleep 1; time > _timer};