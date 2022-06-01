private _revDistance	= 50;
private _time 		= 7;
params ["_vehicle", "_revDistance", "_time"];
private _revScript = [_vehicle, _revDistance, _time] spawn Tally_Fnc_cmnd_Reverse;
_Vehicle setVariable ["currentAction", "Reversing",	true];
sleep 1;
if(speed _vehicle > -1)
then{
		terminate _revScript;
		/*_revScript = [_vehicle, _revDistance, _time] spawn Tally_Fnc_ForcedReverse;*/
	};

while{sleep 0.02; !scriptDone _revScript}
do	{
		private _vehR_Pos 		= (_Vehicle modelToWorld [0,-8,0]);
		private _objectsInPath 	= nearestObjects [_vehR_Pos, ["land", "house"], 7];
		if(count _objectsInPath > 0)exitWith{
											terminate _revScript;
											_revScript = [_vehicle, 0.5] spawn Tally_Fnc_landBrake;
										  };
	};
waituntil{sleep 0.1; scriptDone _revScript};