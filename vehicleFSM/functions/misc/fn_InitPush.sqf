params ["_Vehicle"];

private _ProcessingPush = (_Vehicle GetVariable "ProcessingPush");
if (!isnil "_ProcessingPush")exitWith{};
_Vehicle setVariable ["ProcessingPush", true, true];

private _PushPos 	= (selectRandom (_Vehicle GetVariable "PushPositions"));
private _Commander 	= (commander _Vehicle);
private _Driver		= (driver _Vehicle);
private _Group 		= (group _Driver);
private _Timer		= time + 5;
private _EndingFSM	= (_Vehicle GetVariable "EndingNow");


_Vehicle setVariable [	"currentAction", 	
						"Attempting to locate push-positions", 
						true];

if (Isnil "_PushPos") then {
								Private _Enemy = [500, _Driver] call Tally_Fnc_GetNearestEnemy;
								[_Vehicle, (getPos _Enemy)] spawn Tally_Fnc_SoftMove;
								private _Script = [_Vehicle] Spawn Tally_Fnc_PushPositions;
								
								waituntil	{
											sleep 0.02; 
													_EndingFSM	= (_Vehicle GetVariable "EndingNow");
											private _EndingNow	= (!Isnil "_EndingFSM");
											private _ScriptDone = (scriptDone _Script);
											Private _TimedOut	= (_Timer > time);
											Private _NilVeh		= (IsNil "_Vehicle");
											private _DeadVeh	= (!Alive _Vehicle);
											
											if (_ScriptDone
											or  	_TimedOut
											or	_NilVeh
											or	_DeadVeh
											or 	_EndingNow)
											Exitwith
											{ true };
											
											false
											};
											
											
											
								_PushPos 	= (selectRandom (_Vehicle GetVariable "PushPositions"));
							};

if (Isnil "_PushPos")exitWith	{
									_Vehicle setVariable ["PushPosLoaded", false, true];
									_Vehicle setVariable ["ProcessingPush", nil, true];
								};

/*[_Group] call Tally_Fnc_DeleteWP;*/
[_Group] spawn Tally_Fnc_ResetGroup;

_Vehicle setVariable ["currentAction", 	"push", true];
_Vehicle SetVariable ["EvadePos", 		_PushPos, true];

[_Vehicle, _PushPos] spawn Tally_Fnc_SoftMove;

if (!Isnil "_Commander") then 	{
									_Commander DoMove _PushPos;
								};

If (FSMD3Bugger) then 	{
							[_Vehicle] call Tally_Fnc_SelectedPositionMarkers;
							SystemChat format ["initiating push"];
						};

_Vehicle setVariable ["ProcessingPush", nil, true];