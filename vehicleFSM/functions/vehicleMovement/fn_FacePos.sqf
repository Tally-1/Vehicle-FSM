params["_vehicle", "_targetPos"];
private _timer 			= time +3;
private _VehPos			= getPos _vehicle;
private _targetDir		= _vehicle getDir _targetPos;
private _newPos 		= [_VehPos select 0, _VehPos select 1, _targetDir, 20] call Tally_Fnc_CalcAreaLoc;
_Vehicle setVariable ["currentAction", "Facing enemy",	true];
_vehicle doMove _newPos;

waituntil	{
				sleep 0.1;
				(([getDir _Vehicle, (_vehicle getDir _targetPos), 15] call Tally_Fnc_isFacingTargetDir)
				or(_timer < time))
			};
_vehicle doMove (getPos _vehicle);
private _script = [_Vehicle, 0.5, true] spawn Tally_Fnc_landBrake;
waituntil{sleep 0.1; scriptDone _script};