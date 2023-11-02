params["_Chopper", "_EvasionPos", "_EnAvgPos"];

_Chopper SetVariable ["EvadePos", _EvasionPos, true];

private _Time		= 2;
private _Brake_I		= 20;
private _Sleep		= _Time / _Brake_I;
Private _speed 		= (velocityModelSpace _chopper) select 1;
private _DriftX = (velocityModelSpace _chopper) select 0;
private _DriftZ = (velocityModelSpace _chopper) select 2;
Private _Reduction 	= _speed / _Brake_I;
private _Pilot		= (driver _Chopper);
private _Group		= group _Chopper;


[_Chopper, false] spawn Tally_Fnc_SwitchEngagement;
[_Chopper, _EvasionPos] call Tally_Fnc_SoftMove;
_Chopper setVariable ["currentAction", 	"Hide", 		true];
_Chopper setVariable ["HiddenPosLoaded", true, 			true];
_Chopper SetVariable ["EvadePos", 		_EvasionPos, 	true];
_Chopper SetVariable ["HidePositions",	[_EvasionPos],	true];
_Chopper SetVariable ["ready", 			true, 			true];

for "_I" from 1 to _Brake_I do{
	if(!alive _Chopper) exitwith{};
	[_Chopper, false] spawn Tally_Fnc_SwitchEngagement;
	_speed = (velocityModelSpace _chopper) select 1;
	_DriftX = (velocityModelSpace _chopper) select 0;
	_DriftZ = (velocityModelSpace _chopper) select 2;
	_Chopper setVelocityModelSpace [_DriftX, (_speed - _Reduction), _DriftZ];
	sleep _Sleep;
	_Pilot 			setBehaviourStrong "AWARE";
	(Group _Pilot) 	setBehaviourStrong "AWARE";
	_Group 			setCombatMode 	   "YELLOW";
};
for "_I" from 1 to 180 do		{
		if(!alive _Chopper) exitwith{};
		private _Dir = (Getdir _Chopper);
		_Chopper setDir (_Dir -1);
		sleep (2 / 180);
	};
if(alive _Chopper)
then{
		_speed = (velocityModelSpace _chopper) select 1;
		_DriftX = (velocityModelSpace _chopper) select 0;
		_DriftZ = (velocityModelSpace _chopper) select 2;
		
		for "_I" from 1 to _Brake_I do{_Chopper setVelocityModelSpace [_DriftX, (_speed - _Reduction), _DriftZ]; sleep _Sleep};
		[_Chopper, _EvasionPos] call Tally_Fnc_SoftMove;
	};