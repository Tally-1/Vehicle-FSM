params ["_Vehicle", "_EndStatus"];
private _ScriptRunning 	= (_Vehicle GetVariable "EndingNow");
private _Action 			= (_Vehicle GetVariable "currentAction");
private _Attempts 		= (_Vehicle GetVariable "EndAttempts");
private _Ended 			= (_Vehicle GetVariable "endedAlready");
private _lastOutro		= (_Vehicle GetVariable "lastOutro");


if(!Isnil "_lastOutro"
&&{time - _lastOutro < iterationTimer}) exitWith {["End script double-fired"] call Tally_fnc_debugMessage};

if (IsNil "_Ended")then{_Ended = false};
if (IsNil "_Action")then{_Action = "flank"};
if (IsNil "_Attempts")	then{
								_Vehicle setVariable ["EndAttempts", 	1, true];
							}
						else{
								_Vehicle setVariable ["EndAttempts", 	_Attempts + 1, true];
							};
if(isNil "_EndStatus")then{_EndStatus = "unknown"};

_Vehicle SetVariable ["lastOutro", time, true];
_Vehicle setVariable ["currentAction", 	_EndStatus, true];
private _Timer = time + 3;

if!(_Ended)
then{
		private _Script = [_Vehicle, _EndStatus, _Action] spawn Tally_Fnc_PostScriptActions;
		waituntil{
				 private _timedOut 	= _Timer < time;
				 private _ScriptDone = scriptDone _Script;
				 private _Nil		= isnil "_ScriptDone";
					
					sleep 0.1;
					if (_Nil)	exitWith{true};
					if(_timedOut
					or _ScriptDone)exitWith{true};
					
					false
				 };
	};
/*[_vehicle] spawn Tally_Fnc_reApplyWaypoints;*/

[_Vehicle] call Tally_Fnc_RemoveVehicleVars;
_vehicle allowCrewInImmobile true;
(Gunner _Vehicle) doWatch objNull;

/*This part might need some re-writing to get it exact and avoid unNecesary scripts running*/

sleep iterationTimer * 5;

if([_vehicle] call Tally_Fnc_Available_And_Wp)
				then{
						[(group _vehicle)] call Tally_Fnc_ResetGroup;
					};
/*
[_vehicle] spawn Tally_Fnc_ResumeOriginalPath;
*/