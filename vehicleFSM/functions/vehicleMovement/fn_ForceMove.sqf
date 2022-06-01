
params ["_Vehicle"];
private _ForcingMove 		= (_Vehicle getVariable "IsForcingMove");
if(!IsNil "_ForcingMove")	exitWith {};
_Vehicle SetVariable ["IsForcingMove", true, true];
[_Vehicle] spawn Tally_Fnc_DisLodge;

private _Driver				= (Driver _Vehicle);
private _Group				= (group _Driver);
private _Leader				= leader _Group;
private _previousPosition 	= (getPos _Vehicle);
Private _TargetPos 			= (_Vehicle getVariable "EvadePos");

if (Isnil "_TargetPos") exitWith{};




_Driver setBehaviourStrong "AWARE";
(Group _Driver) setSpeedMode "FULL";
[_Vehicle, _TargetPos] spawn Tally_Fnc_SoftMove;

sleep 6;


If ((_previousPosition distance2d (getPos _Vehicle)) < 1 
&& {[_Vehicle] call Tally_Fnc_Is_Evading})										  
then {
		private _Pushing		= ((_Vehicle getVariable "currentAction") == "push");
		private _Crew			= (_Vehicle getVariable "crew");
		private _Attempts 		= (_Vehicle getVariable "moveAttempts");
		private _MoveDir 		= ((_Vehicle getRelDir _TargetPos) + (Getdir _Vehicle));
		private _HalfWayDist 	= (_previousPosition distance2d _TargetPos) / 2;
		private _HalfWayPos 	= [	_previousPosition select 0, 
									_previousPosition select 1, 
									_MoveDir, 
									_HalfWayDist] call Tally_Fnc_CalcAreaLoc;
																							
																					
		_Vehicle SetVariable ["moveAttempts", 	(_Attempts + 1), true];
		if(_Attempts > 0 
		&& {FSMD3Bugger}) 
		then {
				systemChat format ["Attempting to force movement"];
			};	
																							
		if(_Attempts == 0) then {
									_Vehicle setVelocityModelSpace [0, 5, 0];
									[_Vehicle, _HalfWayPos] spawn Tally_Fnc_SoftMove;
								};																												
		if(_Attempts == 1) then {
									private _Script = [_Vehicle] spawn Tally_Fnc_RemoveAutoCombat;
									waituntil{scriptDone _Script};
									_Driver setBehaviourStrong "AWARE";
									(Group _Driver) setSpeedMode "FULL";
									sleep 0.1;
									[_Vehicle, _HalfWayPos] spawn Tally_Fnc_SoftMove;
								};
		if(_Attempts == 2) then {
									private _Script = [_Group] spawn Tally_Fnc_ResetGroup;
									waituntil{scriptDone _Script};
									private _NewGroup = (Group _Vehicle);
									/*[_NewGroup] call Tally_Fnc_DeleteWP;*/
									[_Vehicle] 	call Tally_Fnc_RemoveAutoCombat;
									_NewGroup setBehaviour 			"Aware";
									_NewGroup setBehaviourStrong	"Aware";
									_NewGroup setCombatBehaviour	"Aware";
									_NewGroup setCombatMode 		"YELLOW";
									[_Vehicle, _HalfWayPos] spawn Tally_Fnc_SoftMove;																														
								};
		if(_Attempts == 3) then {
									private _Script = [_Vehicle, _Group, _HalfWayPos, _TargetPos] spawn Tally_Fnc_HardMove;
									waituntil{scriptDone _Script};
									If(FSMD3Bugger)   then	{systemChat format ["movement is forced"];};
								};
		if(_Attempts > 3
		&&{!(_Pushing)}) then 	{
									private _Script = [_Vehicle, _Group, _HalfWayPos, _TargetPos] spawn Tally_Fnc_HardMove;
									waituntil{scriptDone _Script};
									If(FSMD3Bugger)   then	{systemChat format ["movement is forced"]};
								};
		if(_Attempts == 6)
		exitWith				{
									[_Vehicle, "No brain driver"] spawn Tally_Fnc_EndEvasionVeh;
								};
																					
		If(FSMD3Bugger)   then	{
									systemChat format ["Vehicle is not moving. Attempt %1", (_Attempts)];
								};
	};
_Vehicle SetVariable ["IsForcingMove", nil, true];