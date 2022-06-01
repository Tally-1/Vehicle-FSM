private _deployCounterMeasures 	= false;
private _reverseDistance 			= 100;
private _maxReverseTime			= 120;
private _iterations				= 3;
params ["_vehicle", "_Pos", "_enemies", "_reverseDistance", "_maxReverseTime", "_deployCounterMeasures", "_iterations"];



private _script = [_Vehicle ,_Pos] spawn Tally_Fnc_FacePos;
waituntil{sleep 0.1; scriptDone _Script};

if(!alive _vehicle)exitWith{/*[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions*/};

if(_deployCounterMeasures)
then{[_Vehicle] spawn Tally_Fnc_DeploySmoke};

for "_I" from 1 to _iterations
do	{
		if([getDir _Vehicle, (_vehicle getDir _Pos), 23] call Tally_Fnc_isFacingTargetDir)
		then{
				_script = [_vehicle, (_reverseDistance / _iterations), (_maxReverseTime / _iterations)] spawn Tally_Fnc_reverse;
				waituntil{sleep 0.1; scriptDone _Script};
			}
		else{
				private _script = [_Vehicle ,_Pos] spawn Tally_Fnc_FacePos;
				waituntil{sleep 0.1; scriptDone _Script};
			};
		sleep 1;
	};