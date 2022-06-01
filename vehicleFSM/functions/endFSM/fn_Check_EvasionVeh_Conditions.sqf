
/*	
	This function checks wether or not the vehicle has fulfilled the conditions to end the evasion manuver.
	Also checks crew-status and takes action accordingly
*/
params ["_Vehicle"];
_Vehicle setVariable ["Active", true, 	true];


private _CrewStatus  		= [_Vehicle] call Tally_Fnc_CheckCrewStatus;
Private _Timer 				= (_Vehicle getVariable "timer");
private _AllEnemiesDead		= [_Vehicle] call Tally_Fnc_KnownEnemiesDead;
Private _LastCheck 			= (_Vehicle getVariable "LastConditionCheck");
private _CurrentAction		= (_Vehicle getVariable "currentAction");
private _TimeSinceInit		= time - (_Vehicle getVariable "initiated");
private _endstatus			= ["Victory", "Defeat", "Broken", "Timed out", "Arrived", "Assesing situation", "Attempting to locate push-positions"];

if(isNil "_LastCheck")						then	{_LastCheck = 0};
if(isNil "_TimeSinceInit")					exitWith	{
															["forcing outro"] call Tally_fnc_debugMessage;
															_Vehicle SetVariable ["endedAlready", true, true];
															[_Vehicle, "init-time is undefined"] spawn Tally_fnc_ExitEnd;
														};
if((!Isnil "_CurrentAction"
&&{_CurrentAction in _endstatus
&&{_TimeSinceInit > 20}}))					exitWith	{
															["forcing outro"] call Tally_fnc_debugMessage;
															_Vehicle SetVariable ["endedAlready", true, true];
															[_Vehicle, _CurrentAction] spawn Tally_fnc_ExitEnd;
														};

														
if([_Vehicle] call Tally_Fnc_PlayerInVeh)	exitWith	{[_Vehicle, "Player is controlling this vehicle"] spawn Tally_fnc_ExitEnd};
if (_Vehicle GetVariable "repairing")	exitWith	{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd};
if (_Vehicle getVariable "EndingScript") exitWith 	{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd};
if (!Alive _Vehicle)						exitWith	{[_Vehicle, "Defeat"] spawn Tally_fnc_ExitEnd};
if (_CrewStatus == -1)					exitWith	{[_Vehicle, "crew dead"] spawn Tally_fnc_ExitEnd};
if (_AllEnemiesDead)						exitWith	{[_Vehicle, "Victory"] spawn Tally_fnc_ExitEnd;
													If(FSMD3Bugger)then{systemChat "All known enemies are dead, ending evasion"}};
if (_Vehicle GetVariable "switching") 	exitWith 	{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd}; /*Exit the script if one of the crew-members are currently switching seats*/
IF	(time > _Timer) 						exitWith 	{[_Vehicle, "Timed out"] spawn Tally_fnc_ExitEnd};
IF	(time < _LastCheck) 					exitWith 	{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd; ["Double condition-check blocked"] call Tally_fnc_debugMessage};



Private _Evading 			= (_Vehicle getVariable "Evading");
private _Hiding				= ((_Vehicle getVariable "currentAction") == "hide");
private _Pushing				= ((_Vehicle getVariable "currentAction") == "push");
private _UpdatedEnemies 	= [_Vehicle] call Tally_Fnc_UpdateKnownEnemies;
Private _TargetPos 			= (_Vehicle getVariable "EvadePos");
Private _Minimum_Distance	= (_Vehicle getVariable "MinDistEnemy");
if (Isnil "_Minimum_Distance")exitWith{[_Vehicle, "Missing data"] spawn Tally_fnc_ExitEnd};
private _Driver				= (Driver _Vehicle);
private _Group				= (group _Driver);
private _Leader				= leader _Group;
Private _Enemy    			= ([(_Minimum_Distance * 1.5), _Driver] call Tally_Fnc_GetNearestEnemy);
Private _EnemyDist			= (_Driver Distance2D _Enemy);
Private _Radius				= (_Minimum_Distance / 10); /*This is the maximum distance the vehicle can be from it's target-Position before ending evasion*/
private _TimedOut			= false;
private _TimeOutStatus		= ["Assesing situation", "Attempting to locate push-positions", "Scanning"];
private _RepairTimer			= time + 60;
private _DataChecked		= _Vehicle GetVariable "Viable";

_Vehicle SetVariable ["LastConditionCheck",	time + iterationTimer, true];


if(VehicleAutoRepair)
then{
		private _Script = [_Vehicle] spawn Tally_Fnc_InitRepairs;
		waituntil {sleep 0.25; (scriptDone _Script or time > _RepairTimer)};
		If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd};
	};

_CrewStatus  		= [_Vehicle] call Tally_Fnc_CheckCrewStatus;

if !(_Vehicle GetVariable "PushPosLoaded")then	{
													private _Script = [_Vehicle] Spawn Tally_Fnc_PushPositions;
													waituntil{scriptDone _Script};
													If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd};
												};

private _Script = [_Vehicle, _CrewStatus] spawn Tally_Fnc_HandleCrewStatus;
waituntil{scriptDone _Script};
If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn Tally_fnc_ExitEnd};
if ([_Vehicle] call Tally_Fnc_KnownEnemiesDead)exitWith	{
															[_Vehicle, "Victory"] spawn Tally_fnc_ExitEnd;
															
														};


_Vehicle setVariable ["KnownEnemies", _UpdatedEnemies, 	true];

If (_TimeSinceInit > 60) then {
								private _UpdatedFriends = ([_Vehicle, false] call Tally_Fnc_GetNearFriends);
								_Vehicle SetVariable ["NearFriends",  _UpdatedFriends,	true];
								
								if ((_Vehicle getVariable "currentAction") in _TimeOutStatus)
								then 	{
											_TimedOut = true;
										};
							 };

if(_TimedOut
or (_TimeSinceInit > 300))ExitWith	{
										[_Vehicle, "TimeOut"] spawn Tally_fnc_ExitEnd;
										If(FSMD3Bugger)then{systemChat "Timed out"};
										
									};

private _NextAction 	= [_Vehicle] call Tally_Fnc_Flank_Hide_Push;
private _LoadedHidePos	= (_Vehicle GetVariable "HiddenPosLoaded");
private _LoadedPushPos	= (_Vehicle GetVariable "PushPosLoaded");
if([_Vehicle] call Tally_Fnc_PlayerInVeh) exitwith{[_Vehicle, "Player is controlling this vehicle"] spawn Tally_fnc_ExitEnd};
if !(_CurrentAction == _NextAction) 	then 	{
												[_Vehicle, 
												_CurrentAction, 
												_NextAction, 
												_Hiding,
												_Pushing,
												_LoadedHidePos] 
											call Tally_Fnc_HandleDecision;
											};



_TargetPos 			= (_Vehicle getVariable "EvadePos");

if (Isnil "_TargetPos")then{
								_TargetPos = getpos _Vehicle;
								hint "TargetPos not found";
							}
						else{
							
							[_Vehicle, _TargetPos] call Tally_Fnc_SoftMove;
							
						if(((velocityModelSpace _Vehicle) select 1) < 1)
							then{
										for "_I" from 1 to 3 do{
																	[_Vehicle, _TargetPos] call Tally_Fnc_SoftMove;
																	sleep 0.5;
																};
								};								
							};

{if (!alive _x)then{
[_x] joinSilent DCO_deathGroup;
sleep 0.001;
[_x] joinSilent DCO_deathGroup}} 
forEach units _Group;

	{(_Vehicle GetVariable "AllSpotted") pushBackUnique _X}forEach 	(_Vehicle GetVariable "KnownEnemies");
	{
		_X SetVariable ["Spotted", true, true];
		If(!Alive _X)Then{_X SetVariable ["Spotted", nil, true];};
	}ForEach			(_Vehicle GetVariable "AllSpotted");


private _Distance	= (_Vehicle Distance2D _TargetPos);



IF	(!CanMove _Vehicle)				exitWith {[_Vehicle, "Broken"] spawn Tally_fnc_ExitEnd};
IF	(crew _Vehicle IsEqualTo []) 		exitWith {[_Vehicle, "Abandoned vehicle"] spawn Tally_fnc_ExitEnd};
IF	(_Distance < _Radius) 			exitWith {[_Vehicle, "Arrived"] spawn Tally_fnc_ExitEnd};
IF	(fuel _Vehicle == 0) 			exitWith {[_Vehicle, "No fuel"] spawn Tally_fnc_ExitEnd};


/*repeat the command to move towards the target position in case he is outside the minimum radius*/
If ((_Distance > _Radius) 
&& {((velocityModelSpace _Vehicle) select 1) < 2}) then {[_Vehicle]  spawn Tally_Fnc_ForceMove};

If (Alive (Gunner _Vehicle)) then 	{
										private _Engaging = (_Vehicle getVariable "Engaging");
										if(IsNil "_Engaging")then 	{
																		/*[_Vehicle] spawn Tally_Fnc_EngageEnemy;*/
																	};
									};

if(_Hiding)then {
					[_Vehicle] call Tally_Fnc_DeploySmoke;
					_Driver 			setBehaviourStrong "AWARE";
					(Group _Driver) 	setBehaviourStrong "AWARE";
					(Group _Driver) 	setSpeedMode "FULL";
					sleep 0.1;
					[_Vehicle, _TargetPos] spawn Tally_Fnc_SoftMove;
				
				};