params ["_Vehicle", "_EndStatus", "_Action"];

if (IsNil "_Vehicle") 	exitWith{};
_Vehicle SetVariable ["EndingScript", 	true, true];
sleep 2;

private _ReEngageOrders 	= ["flank", "push"];
private _TargetPos 			= (_Vehicle GetVariable "Centro"); 			if(IsNil "_TargetPos")exitWith{};
private _Crew 				= (_Vehicle GetVariable "Crew");				if(IsNil "_Crew")exitWith{["Crew is not defined on vehicle: ", _Vehicle] call Tally_fnc_debugMessage};
private _MinDist				= (_Vehicle GetVariable "MinDistEnemy");
private _outOfReach 		= (_TargetPos distance2d (getpos _Vehicle) > (_MinDist * 0.75));
private _CrewWorks			= (_Vehicle GetVariable "crewStatus")	== "Operational";
private _GetBack				= _Action in _ReEngageOrders;
private _CrewInVehicle		= [_Vehicle] call Tally_Fnc_CrewInVehicle;
private _CrewMember		= (_Crew select 0);
private _vehicleType			= (_Vehicle GetVariable "vehicleType");
If(isnil "_CrewMember") then   {_CrewMember = crew _Vehicle select 0};
If(isnil "_CrewMember")exitWith{["could not complete postscripts"] call Tally_fnc_debugMessage};
private _Group 				= (group _CrewMember);
private _Side				= (side _CrewMember);
private _HiddenPositions 		= (_Vehicle GetVariable "HidePositions");
private _HidePosition			= (_Vehicle GetVariable "EvadePos");
private _Driver 				= (driver _Vehicle);
private _Timer	 			= (Time + 5);
private _LiveCrew	 		= [];
private _Chopper	 		= (_vehicle IskindOf "HeliCopter"
							&&{((_vehicleType == "Light Chopper")
							or (_vehicleType == "Heavy Chopper"))});


{if (Alive _X)
then{_LiveCrew 
pushBackUnique _X}}
ForEach _Crew;

if (IsNil "_Group") 	then 	{
									_Group = (_Vehicle GetVariable "group")
								};

if (IsNil "_Group")	exitWith 	{};
if (IsNull _Group) 	exitWith 	{};


/*[_Group] call Tally_Fnc_DeleteWP;*/
sleep 0.1;

{_X enableAI "AUTOCOMBAT"} ForEach (_Vehicle getVariable "crew");

if (!IsNil "_HiddenPositions") then {
If (count _HiddenPositions > 0)then {
										_HidePosition = [_CrewMember, _HiddenPositions] call Tally_Fnc_GetNearestObject;
									}}
								else{
											Private _EnemyDir 			= ((_Vehicle getRelDir _TargetPos) + (Getdir _Vehicle));
											Private _evasionDir 		= ((_EnemyDir - 180) + 0);
											private _VehPos				= (getpos _Vehicle);
											
											_HidePosition = [_VehPos select 0, _VehPos select 1, _evasionDir, (_MinDist * 1.5)] call Tally_Fnc_CalcAreaLoc;
									};

if 	(!(_CrewInVehicle) 
or	(crew _Vehicle IsEqualTo [])) then 	{
											if(count _LiveCrew > 0)
											then{
													[_HidePosition, _Crew] spawn Tally_Fnc_Split_From_Abandoned_Group_Vehicle
												}
											
											
										};
										



If	(_CrewWorks
&& {((_GetBack)
or	(_Chopper))
&& {_outOfReach}}) then{
							
							/*Private _Script = [(group _Driver)] spawn Tally_Fnc_ResetGroup;
							waituntil {	sleep 0.02; 
										((ScriptDone _Script) 
										or (_Timer < time))};*/
							
							
							[_Vehicle, _TargetPos] spawn Tally_Fnc_SoftMove;
							If(FSMD3Bugger)then{systemChat format ["attempting to move back in to combat"]};
						}
					else{
						If(FSMD3Bugger)then{
												if !(_outOfReach)	then	{};
												if !(_CrewWorks)	then	{systemChat format ["The crew is either dead or to few too re-engage"]};
												if !(_GetBack)		then	{};
											};
						};

if(_vehicle IskindOf "HeliCopter")
then{
		[_Vehicle, true] 		call Tally_Fnc_SwitchEngagement;
		[_Vehicle, _TargetPos] 	spawn Tally_Fnc_SoftMove;
	};

_Vehicle SetVariable ["EndingScript", 	false, true];