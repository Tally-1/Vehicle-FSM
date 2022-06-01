params["_vehicle", "_targetPos"];
private _underCommand 	= _vehicle getVariable "customMoving";
private _timer 			= time + 3;
private _currentDIr 		= getDir _Vehicle;
private _targetDir		= _vehicle getDir _targetPos;
private _isFacingTarget 	= [_currentDIr, _targetDir] call Tally_Fnc_isFacingTargetDir;
private _status = (vehicleMoveInfo _vehicle select 1);

if(!isNil "_underCommand")
exitWith{};
_vehicle setVariable ["customMoving", true, true];

if(_status == "LEFT"
or _status == "RIGHT")then{
							private _script = [_vehicle] spawn Tally_Fnc_forceTurnStop;
							waituntil{sleep 0.1; scriptDone _script};
						};


if(!(_isFacingTarget))
then{
		_vehicle sendSimpleCommand "STOPTURNING";
	if(speed _Vehicle > 5)then{
								_Vehicle sendSimpleCommand "STOP";
								private _script = [_Vehicle, 1, true] spawn Tally_Fnc_landBrake;
								waituntil{sleep 0.1; scriptDone _script};
							 };

/*
The turn command causes the "wheel" to stay in position even tho the vehicle is no longer moving / turning. 
And this is relative to the vehicle, tracked / wheeled / APC's / TANKS all behave differently 
*/

private _turnTo			= [_vehicle, _targetPos] call Tally_Fnc_TurnDir;
private __neutralizeDir	= [_turnTo] call Tally_Fnc_getOpositeTurndir;
_Vehicle sendSimpleCommand _turnTo;
sleep 1;
_isFacingTarget 	= [getDir _Vehicle, (_vehicle getDir _targetPos), 45] call Tally_Fnc_isFacingTargetDir;
hint (parsetext format["turn %1<br/>is facing target = %2", _turnTo, ([getDir _Vehicle, (_vehicle getDir _targetPos)] call Tally_Fnc_isFacingTargetDir)]);
	
	
	if(!(_isFacingTarget))then{
								if(_Vehicle isKindOf "car")then{_Vehicle sendSimpleCommand _turnTo};
								
								for "_i" from 1 to 20 do
								{
									sleep 0.5;
									private _newDir			= [_vehicle, _targetPos] call Tally_Fnc_TurnDir;
									private _passedTurnPoint	= !(_newDir == _turnTo);
											_isFacingTarget	= [getDir _Vehicle, (_vehicle getDir _targetPos), 28] call Tally_Fnc_isFacingTargetDir;
									
									if(_passedTurnPoint
									or _isFacingTarget)exitWith{
																[_Vehicle, 0.1, true] spawn Tally_Fnc_landBrake;
																_Vehicle sendSimpleCommand "STOPTURNING";
																_vehicle doMove (_Vehicle modelToWorld [0,10,0]);
															};
									
									if(_Vehicle isKindOf "car")	then{_Vehicle sendSimpleCommand "FORWARD"}
																else{_Vehicle sendSimpleCommand "SLOW"};
									
								};
								
								
								if(_Vehicle isKindOf "car")then{_Vehicle sendSimpleCommand __neutralizeDir};
							};
	
	

		_Vehicle sendSimpleCommand "STOPTURNING";
		private _script = [_Vehicle, 1, true] spawn Tally_Fnc_landBrake;
		_script = [_vehicle] spawn Tally_Fnc_forceTurnStop;
		waituntil{sleep 0.1; scriptDone _script};
		_Vehicle sendSimpleCommand __neutralizeDir;
		
	};

_Vehicle sendSimpleCommand "STOP";
_script = [_vehicle] spawn Tally_Fnc_forceTurnStop;
waituntil{sleep 0.05; scriptDone _script};
_vehicle setVariable ["customMoving", nil, true];