Tally_Fnc_reApplyWaypoints = {
params ["_Vehicle"];

private _PreviousWayPoints	= (_Vehicle getVariable "wayPoints");
private _Group				= group _Vehicle;
private _GroupVehicles		= (_Vehicle getVariable "GroupVehicles");
private _Wait				= 10;
private _reApply				= true;




sleep 10;

Private _Evading 		= (_Vehicle getVariable "Evading");
		_Evading 		= (!IsNil "_Evading");
		_CrewStatus 	 	= [_Vehicle] call Tally_Fnc_CheckCrewStatus;

if	(isNil "_Vehicle")			exitWith{["vehicle undefined, could not re-apply wayPoints"] call debugMessage};
if	(isNil "_Group")			exitWith{["group undefined, could not re-apply wayPoints"] call debugMessage};
if	(isNil "_PreviousWayPoints")exitWith{["PreviousWayPoints undefined, could not re-apply wayPoints"] call debugMessage};
if 	(_Evading)					exitWith{["Cannot re-apply wayPoints, vehicle is still active"] call debugMessage};
if 	(!Alive _Vehicle)			exitWith{["Cannot re-apply wayPoints, vehicle Destroyed"] call debugMessage};



if	(isNil "_GroupVehicles")	then{_GroupVehicles = ([_Group] call Tally_Fnc_GetGroupVehicles); sleep 1};
if	(isNil "_GroupVehicles")	exitWith{["groupVehicles undefined, could not re-apply wayPoints"] call debugMessage};


for "_I" from 1 to _Wait 
do 	{
		
		sleep 1;
		
		_reApply = [
					_Vehicle, 
					_PreviousWayPoints,
					_GroupVehicles
					] call Tally_Fnc_ReApplyConditions;
		
		if(_reApply)exitWith{["Leeets goooo"] call debugMessage};
		
		
	};

if(_reApply)
then{
		["re-applying wayPoints"] call debugMessage;
		[_Group] call Tally_Fnc_DeleteWP;
		
		{
			private _Position 	= _x select 0;
			private _Index 		= _x select 1;
			private _behaviour 	= _x select 2;
			private _speed 		= _x select 3;
			private _formation 	= _x select 4;
			
			private _wp = _Group addWaypoint [_Position, 0, _Index];
			_wp setWaypointBehaviour 	_behaviour;
			_wp setWaypointSpeed  		_speed;
			_wp setWaypointFormation 	_formation;
			
			
		}ForEach 
		_PreviousWayPoints;
	}
else{
		["could not re-apply wayPoints. Conditions not met"] call debugMessage;
	};

};

Tally_Fnc_ReApplyConditions = {
params["_Vehicle", "_PreviousWayPoints", "_GroupVehicles"];


				
		private	_Evading 		= (_Vehicle getVariable "Evading");
				_Evading 		= (!IsNil "_Evading");
		private _GroupEngaged 	= false;
		private _Dead			= (!Alive _Vehicle 
								or (count (crew _Vehicle) < 1));
		private _deadCrew		= true;
		private _CurrentWP		= [_Vehicle] call Tally_Fnc_GetWaypointInfo;
		private _AlreadyDone	= (_CurrentWP isEqualto _PreviousWayPoints);
		private	_Group 			= group _Vehicle;
		private _noGroup		= (isNil "_Group"
								or isNull _Group);
		
		{
			private _engaged = (_x getVariable "Evading");
			if (!IsNil "_engaged")
			then{
					_GroupEngaged = true;
				};
		}ForEach 
		_GroupVehicles;
		
		{
			if (Alive _X)
			then{
					_deadCrew = false; 
				};
		}ForEach 
		crew _Vehicle;
		
		if(!(_Evading)
		&&{!(_GroupEngaged)
		&&{!(_Dead)
		&&{!(_noGroup)
		&&{!(_deadCrew)
		}}}})exitWith{true};
		
false};



Tally_Fnc_GetWaypointInfo = {
params ["_Vehicle"];
private _WayPointArr	= [];
private _Group			= group _Vehicle;
private _destroyed 		= [_Vehicle] call Tally_Fnc_crewDead;
if(_destroyed)exitWith{_WayPointArr};

private _CurrentIndex = (currentWaypoint _Group);
private _List 		 = waypoints _Group;

for "_I" from 1 to _CurrentIndex do{_List deleteAt 0};

{
	private _Pos 		= waypointPosition 	_x;
	private _Index 		= _x select 1;
	private _behaviour 	= waypointBehaviour _x;
	private _speed 		= waypointSpeed 	_x;
	private _formation	= waypointFormation _x;
	
	private _wpInfo = [	_Pos, 
						_Index, 
						_behaviour, 
						_speed, 
						_formation];
	
	_WayPointArr pushBackUnique _wpInfo;
}forEach 
_List;



_WayPointArr};


Tally_Fnc_CopyActiveWaypoints = {
params ["_FromGrp", "_ToGrp"];

if(isNil "_FromGrp"
or IsNil "_ToGrp") exitWith {["could not copy wp from a NIL group"] call debugMessage; []};

if(isNull _FromGrp
or isNull _ToGrp) exitWith {["could not copy wp from a NULL group"] call debugMessage; []};

private _WayPointArr = [];
private _CurrentIndex = (currentWaypoint _FromGrp);
private _List 		 = waypoints _FromGrp;


if(_CurrentIndex > 0)
then{
		for "_I" from 1 to _CurrentIndex do{_List deleteAt 0};
	};

if(count _List > 0)
then{
		
		{
			private _Pos 		= waypointPosition 	_x;
			private _Index 		= _x select 1;
			private _behaviour 	= waypointBehaviour _x;
			private _speed 		= waypointSpeed 	_x;
			private _formation	= waypointFormation _x;
			
			private _wpInfo = [	_Pos, 
								_Index, 
								_behaviour, 
								_speed, 
								_formation];
			
			_WayPointArr pushBackUnique _wpInfo;
		}forEach 
		_List;
		
		
		{
		private _Position 	= _x select 0;
		private _behaviour 	= _x select 2;
		private _speed 		= _x select 3;
		private _formation 	= _x select 4;

		private _wp = _ToGrp addWaypoint [_Position, 0];
		_wp setWaypointBehaviour 	_behaviour;
		_wp setWaypointSpeed  		_speed;
		_wp setWaypointFormation 	_formation;

		}ForEach 
		_WayPointArr;
	};


};
Tally_Fnc_AssignFlankPositions = {
params["_Vehicle", "_EnAvgPos", "_Initiator"];

private _Timer = time;
if (IsNil "_Initiator")
then{
		private _script = [_Vehicle, _EnAvgPos] spawn Tally_Fnc_FlankPositions;
		Waituntil {sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					 };
	}
else{
		waituntil{
					sleep 0.1;
					private _Loaded 	= (_Initiator GetVariable "FlankPosLoaded");
					private _TimedOut 	= (time - _Timer > 4);
					
					if(IsNil "_Loaded")exitWith{true};
					
					if(_TimedOut
					or _Loaded)
					exitWith{true};
					false
				  };
					 
		private _FlankPositions = (_Initiator GetVariable "Positions");
				if(IsNil "_FlankPositions")
				then{
						_FlankPositions = [];
					};
		
			if (count _FlankPositions > 4)then
			{
				_Vehicle SetVariable ["Positions", _FlankPositions, true];
				_Vehicle SetVariable ["FlankPosLoaded", true, 		true];
			}
		
		else{
				private _script = [_Vehicle, _EnAvgPos] spawn Tally_Fnc_FlankPositions;
				Waituntil 	{
							sleep 0.02; 
							((ScriptDone _Script)
							or(time - _Timer > 3))
							};
			};
		
		
	};


};







Tally_Fnc_FlankPositions = {
params ["_Vehicle", "_EnAvgPos"];
private _Timer = time;
		{
			Private _arr = _x;
			private _Script =  _arr spawn Tally_Fnc_Scan_Area; diag_log format ["arr %1", (_arr)];
	
			Waituntil {	
						sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					  };
		} ForEach (_Vehicle GetVariable "Areas");
		
		_Script = [_Vehicle, _EnAvgPos] Spawn Tally_Fnc_FilterPos;
		Waituntil {	
						sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					  };
		["Flank positions loaded in seconds:", (time-_Timer)] call debugMessage;
		_Vehicle SetVariable ["FlankPosLoaded", true, true];
};








Tally_Fnc_BackUp = {
params ["_Vehicle", "_Area"];
_Vehicle sendSimpleCommand "STOP";

for "_I" from 1 to 10 do
{
	_Vehicle SetVariable ["ready", false, true];
	_Vehicle sendSimpleCommand "BACK";
	if(count (crew _Vehicle) < 2)exitWith{};
	sleep 1;
};


_Vehicle SetVariable ["ready", true, true];
[_Vehicle, _Area] spawn Tally_Fnc_SoftMove;
};




Tally_Fnc_QuickDecision = {
params ["_Vehicle", "_EnAvgPos"];

private _NextAction	= [_Vehicle] call Tally_Fnc_Flank_Hide_Push;


switch (_NextAction) do
{
	case "push";	{ 
						[_Vehicle, _EnAvgPos] call Tally_Fnc_SoftMove;
						_Vehicle setVariable ["currentAction", 	"Attempting to push", true];
						_Vehicle SetVariable ["EvadePos", _EnAvgPos, true];
					};
	case "flank": 	{ 
						private _Area = ((_Vehicle GetVariable "Areas") select (selectRandom [1,2]) select 0);
						[_Vehicle, _Area] call Tally_Fnc_SoftMove;
						[_Vehicle] spawn Tally_Fnc_DeploySmoke;
						_Vehicle setVariable ["currentAction", 	"Attempting to flank", true];
						_Vehicle SetVariable ["EvadePos", _Area, true];
					};
	case "hide";	{ 
						private _Area = (((_Vehicle GetVariable "Areas") select 0) select 0);
						[_Vehicle, _Area] call Tally_Fnc_SoftMove;
						[_Vehicle] spawn Tally_Fnc_DeploySmoke;
						_Vehicle setVariable ["currentAction", 	"Attempting to hide", true];
						_Vehicle SetVariable ["EvadePos", _Area, true];
					};
	default 		{};
};

};


Tally_Fnc_EvadeVEh = {

Private _Minimum_Distance 		= 400; 
Private _DeBug 					= false;
Private _Enemy 					= nil;

Params ["_Vehicle", "_Minimum_Distance", "_DeBug", "_Enemy", "_Initiator"];


Private _Driver 				= (driver _Vehicle);
Private _Evading 				= (_Vehicle getVariable "Evading");
Private _Group					= (Group _Driver);
private _Side					= (Side _Driver);
Private _Timer					= (Time + 3);
private _DataChecked			= _Vehicle GetVariable "Viable";
Private _Repairing				= (_Vehicle GetVariable "repairing");

if(_Minimum_Distance == VehMinimumDistance)
then{
		_Minimum_Distance		= [_Vehicle, _Minimum_Distance] call Tally_Fnc_MinDistMultiplier;
	};

if(isnil "_Enemy")
then{
		_Enemy	= [_Minimum_Distance, _Driver] call Tally_Fnc_GetNearestEnemy;
	};

missionNameSpace setVariable ["FSMD3Bugger", _DeBug, true];


If (!IsNil "_Repairing"
&& {_Repairing})			ExitWith {};
If (Isnil "_Vehicle")	ExitWith {};
If (Isnil "_Enemy")		ExitWith {};
If (!Isnil "_Evading")	ExitWith {};
If (Isnull _Enemy)		ExitWith {};
if([_Vehicle] call Tally_Fnc_PlayerInVeh) exitwith{};

diag_log format ["side Vehicle %1 Has %2 TargetKnowledge", _Vehicle, (_Side knowsAbout _Enemy)];
If ((!((_Side knowsAbout _Enemy) > 0)) 
&& (!((_Group knowsAbout _Enemy) > 0))) ExitWith {
													diag_log format ["Side for Vehicle %1 does not know about near enemy", _Vehicle];
													If (FSMD3Bugger) then 	{
																				SystemChat format ["neither Side or group for Vehicle %1 knows about near enemy", _Vehicle];
																			};
												 };
private _EnemyDist	= (_Vehicle Distance2D _Enemy);
If (!Alive _Enemy) ExitWith {diag_log format ["Vehicle %1 Has DEAD enemies", _Vehicle];};
[_Vehicle] call Tally_Fnc_AddEh;



Private _EnAvgPos			= ([_Enemy, (Round(_Minimum_Distance * 0.5))] call Tally_Fnc_AVGclusterPOS);
Private _EnemyCluster		= ([_Enemy, (Round(_Minimum_Distance * 0.5))] call Tally_Fnc_ClusterMembers);
private _KnownEnemies		= [_Enemy];
private _enemyPositions		= [];
private _Crew 				= [];
private _Gunner_2			= "";

{
	if	((_Side knowsAbout _x > 0)
	or 	(_Group knowsAbout _x > 0)
	or	(_Driver knowsAbout _x > 0))
	then{
			_KnownEnemies pushBackUnique _x;
			_enemyPositions pushBackUnique (getpos _x);
		}
} ForEach _EnemyCluster;

if (!IsNull driver _Vehicle) then{
	_Crew pushBackUnique driver _Vehicle;
};

if (!IsNull gunner _Vehicle) then{
	_Crew pushBackUnique gunner _Vehicle;
};

if (!IsNull commander _Vehicle) then{
	_Crew pushBackUnique commander _Vehicle;
};

for "_i" from 0 to ((count (allTurrets _Vehicle))-1) do {
private _unit = _Vehicle turretUnit (allTurrets _Vehicle select _I);

if (!isnil "_unit" &&{!isNull _unit}) then {
_Crew pushBackUnique _unit;
if !(_unit == commander _Vehicle or _unit == gunner _Vehicle or _unit == driver _Vehicle)then{_Gunner_2 = _unit};
};
};

Private _EnemyDir 			= ((_Vehicle getRelDir _Enemy) + (Getdir _Vehicle));
Private _evasionDir 			= ((_EnemyDir - 180) + 0);
Private _GoDistance 			= ((_Minimum_Distance - (_Vehicle Distance2D _Enemy)) + (_Minimum_Distance / 5)); 
private _VehicleType 		= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _VehPos		 		= (GetPos _Vehicle);
private _AvgEnemyAltitude 	= [_enemyPositions] call Tally_Fnc_GetAVGheight;
private _Timer				= (round((time) + (_Minimum_Distance / ([_Vehicle] call Tally_Fnc_Timer_divisor))));
private _LastSmoke			= (_Vehicle getVariable "LastSmoke");
private _GroupVehicles 		= ([(Group _Vehicle)] call Tally_Fnc_GetGroupVehicles);
sleep 0.1;

sleep 0.1;

sleep 0.1;



private _HidePos 			=  [_VehPos select 0, 
								_VehPos select 1, 
							(_EnAvgPos getDir _VehPos), 
							(_Minimum_Distance / 4)] 
							call Tally_Fnc_CalcAreaLoc;
							
If (_EnemyDist < 50) then {_evasionDir = (getDir _Vehicle)};

Private _EvasionPos = [_VehPos select 0, _VehPos select 1, _evasionDir, _GoDistance] call Tally_Fnc_CalcAreaLoc;

sleep 0.1;

_Vehicle SetVariable ["initiated",			time,											true];
_Vehicle SetVariable ["Cluster",				_EnemyCluster,									true];
_Vehicle SetVariable ["Centro",				_EnAvgPos,										true];
_Vehicle SetVariable ["Positions",			[], 											true];
_Vehicle SetVariable ["FlankPosLoaded",		false, 											true];
_Vehicle SetVariable ["HidePositions",		[],												true];
_Vehicle SetVariable ["Markers", 			[], 											true];
_Vehicle SetVariable ["NextPosMarkers",		[], 											true];
_Vehicle SetVariable ["SelPosMarked",		false, 											true];
_Vehicle SetVariable ["HiddenPosLoaded",		false, 											true];
_Vehicle SetVariable ["TwoTimesHideSearch",	false, 											true];
_Vehicle SetVariable ["PushPosLoaded",		false, 											true];
_Vehicle SetVariable ["timer", 				_Timer, 											true];
_Vehicle SetVariable ["tim3r", 				(systemTime select 1),							true];
_Vehicle SetVariable ["MinDistEnemy", 		_Minimum_Distance, 								true];
_Vehicle setVariable ["Crew",				_Crew, 											true];
_Vehicle setVariable ["driver", 				driver 		_Vehicle,                           	true];
_Vehicle setVariable ["gunner", 				gunner 		_Vehicle,                           	true];
_Vehicle setVariable ["gunner_2", 			_Gunner_2, 										true];
_Vehicle setVariable ["commander", 			commander 	_Vehicle,                           	true];
_Vehicle setVariable ["KnownEnemies", 		_KnownEnemies,									true];
_Vehicle setVariable ["repairing", 			false,											true];
_Vehicle setVariable ["switching", 			false,											true];
_Vehicle setVariable ["crewStatus", 			"Operational",									true]; 
_Vehicle setVariable ["vehicleType", 		_VehicleType,									true];
_Vehicle setVariable ["currentAction", 		"Assesing situation",							true]; 
_Vehicle SetVariable ["Evading", 			true, 											true];
_Vehicle SetVariable ["EvadePos", 			_EvasionPos, 									true];
_Vehicle SetVariable ["moveAttempts", 		0, 												true];
_Vehicle SetVariable ["PushPositions", 		[], 											true];
_Vehicle SetVariable ["enemyPositions", 		_enemyPositions,									true];
_Vehicle SetVariable ["AvgEnemyAltitude", 	_AvgEnemyAltitude,								true];
_Vehicle SetVariable ["Group",				_Group,											true];
_Vehicle SetVariable ["GroupVehicles",		_GroupVehicles,									true];
_Vehicle SetVariable ["Secondary_Groups",	[],												true];
_Vehicle SetVariable ["NearFriends", 		([_Vehicle, true] call Tally_Fnc_GetNearFriends),	true];
_Vehicle SetVariable ["EndingScript",		false,											true];
_Vehicle SetVariable ["lastOutro",			time,											true];
_Vehicle SetVariable ["AllSpotted",			[],												true];
_Vehicle SetVariable ["LastConditionCheck",	time,											true];
_Vehicle SetVariable ["LastMove",			time + 5,										true];
_Vehicle SetVariable ["endedAlready",		false,											true];
_Vehicle SetVariable ["lastRepair",			time - 60,										true];
_Vehicle SetVariable ["pathPos",				[],												true];

_Group SetVariable 	["lastGroupReset",		time,											true];

if(isnil "_LastSmoke")then	{
								_Vehicle SetVariable ["LastSmoke", 		time - 120,			true];
								_Vehicle SetVariable ["LastSmokePos",	(GetPos _Vehicle), 	true];
							}; 
private _Timer = time;



Private _Areas = [(getpos _Enemy), _Minimum_Distance, _Vehicle, _evasionDir] call Tally_Fnc_SearchAreas;
_Vehicle SetVariable ["Areas", 	_Areas, true];


sleep 0.1;

[_Vehicle, _EnAvgPos] call Tally_Fnc_QuickDecision;
if(_vehicle IskindOf "HeliCopter")
exitwith{
			[_vehicle, 
			_HidePos,
			_EnAvgPos] spawn Tally_Fnc_ChopperEvasion;
		};


if(IsNil "_Initiator")
then{
		private _script = [_Vehicle, _EnAvgPos] Spawn Tally_Fnc_AssignFlankPositions;
		Waituntil {
					sleep 0.02; 
					((ScriptDone _Script)
					or(time - _Timer > 5))
				 };
	}
else{
		private _script = [_Vehicle, _EnAvgPos, _Initiator] Spawn Tally_Fnc_AssignFlankPositions;
		Waituntil {
					sleep 0.02; 
					((ScriptDone _Script)
					or(time - _Timer > 5))
				 };
	};
if([_Vehicle] call Tally_Fnc_PlayerInVeh) exitwith{};




private _GroupUnits = (Units (Group (Driver _Vehicle)));
Private _EvasionPos2 = (SelectRandom (_Vehicle GetVariable "Positions"));

If !(IsNil "_EvasionPos2") then {_EvasionPos = _EvasionPos2};
_Vehicle SetVariable ["EvadePos", 		_EvasionPos, true];


if!(IsNil "Cluster")
then{
		{[_X, (_Vehicle GetVariable "Cluster")] spawn Tally_Fnc_Reveal} ForEach _GroupUnits;
	};
	


if(!IsNil "_Initiator") 
then{
		_Script = [_Vehicle, _Initiator] spawn Tally_Fnc_GetHidePos;
		
	}
else{
		_Script = [_Vehicle] spawn Tally_Fnc_GetHidePos;
		
	};


	{(_Vehicle GetVariable "AllSpotted") pushBackUnique _X}forEach _KnownEnemies;
	{_X SetVariable ["Spotted", true, true];}ForEach(_Vehicle GetVariable "AllSpotted");

If (FSMD3Bugger) then 	{
							[_Vehicle] call Tally_Fnc_SelectedPositionMarkers;
						};

[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions;

sleep 2;

{
If ([_X] call Tally_Fnc_VehEligbleFSM) then {
												Private _Evading 		= (_X getVariable "Evading");
												private _Eligible			= ([_X] call Tally_Fnc_VehEligbleFSM);
												if(isNil "_Evading"
												&&{_Eligible})then{
																	private _NewDistance 	= (_X distance2d _Enemy) * 1.1;
																	[_x, _NewDistance, FSMD3Bugger, _Enemy, _Vehicle] spawn Tally_Fnc_EvadeVEh;
																	sleep 0.1;
																};												
											};
}
ForEach _GroupVehicles;

{
_X setVariable ["Vehicle", 	_Vehicle,  true];
}ForEach _Crew;


sleep 0.1;
_Vehicle SetVariable ["ready", true, true];

if (_VehicleType == "tank"
or	_VehicleType == "APC") then {
									if(VehicleAutoRepair)
									then{
											_vehicle allowCrewInImmobile true;
										};
									
								};

};







Tally_Fnc_PlayerInVeh = {
params["_Vehicle"];
Private _InVeh = false;

{
If (!((_X Getvariable "bis_fnc_moduleRemoteControl_owner") isEqualTo "")
or (IsPlayer _X))
then {_InVeh = true};
}ForEach (Crew _Vehicle);

if!(_InVeh)
then{
				{
					if((vehicle _X) == _Vehicle)
					exitwith{
								_InVeh = true;
							};
				} ForEach 
				AllPlayers;
	};

_InVeh};Tally_Fnc_TaskManager = {



					{
						private _Vehicle = _X;
						private _evading = _x getVariable "Evading";
						Private _Group = Group _Vehicle;
	
						if(!Isnil "_Group")
						then{
								 _Group setGroupOwner 2;
							};
						
						If ([_X] call Tally_Fnc_VehEligbleFSM
						&& (Isnil "_evading")) 				then 	{
																		
																		[_Vehicle, VehMinimumDistance, FSMD3Bugger] spawn Tally_Fnc_EvadeVEh;
																		sleep 0.1;
																	
																	};
						If (_x getVariable "Evading"
						&&{(_x getVariable "ready")
						&&{true }}) 	
						then 	{													
									
									private _Timer = time + iterationTimer;
									private _Script = [_x] spawn Tally_Fnc_Check_EvasionVeh_Conditions;
									waituntil {sleep 0.02; (scriptDone _Script or time > _Timer)};
									sleep 0.1;
																			
								}
						else 	{
								
								};
					sleep 0.05;
					} ForEach vehicles;
					
					if (time > HintTimer) then	{
													HintTimer = time + 120;
													
													If(FSMD3Bugger)
													then{
															hint (parsetext format["DCO vehicle FSM: <br/>Version %1", (Version)]);
														};
												
												};
					
				if (time > TenSecondTaskTimer) then 	{
														{						
														if !(_X == deathGroup
														or	 _X getVariable "placeHolder")
														then 	{
																	if(Units _X IsEqualTo [] 
																	or IsNull _X)
																	then{
																			deleteGroup _X;
																		};
																};
														}ForEach AllGroups;
													
														{
															[_X] call Tally_Fnc_AddEh;
															if([_X] call Tally_Fnc_Available_And_Wp)
															then{
																	private _Group = (group _X);
																	
																};
														}ForEach Vehicles;
														
														diag_log format["Active scripts: %1", (diag_activeScripts select 0)];
														TenSecondTaskTimer = time + 10;
														 
														
													
													};

ScriptsRunningDOC		= (diag_activeScripts select 0);

if(FSMD3Bugger
&&{diag_fps < 20
&&{!IsDedicated}})
then{
		[(parsetext format ["Your FPS is dangerously low, this might cause issues with the running scripts.<br/>%1 FPS.", (diag_fps)])] remoteExec ["Hint", 0];
	};
};
Tally_Fnc_InitRepairs = {
params["_Vehicle"];
private _Crew 	= (_Vehicle GetVariable "Crew");
private _Driver = driver _Vehicle;
if(IsNil "_Driver"
or IsNull _Driver)then	{_Driver = (_Vehicle GetVariable "driver")};
private _NeedRepairs 			= 	[_Vehicle] call Tally_Fnc_NeedRepairs;
private _EnemiesNearby			= false;
private _DangerClose			= false;
private _NearestEnemy 			= 	[400, _Driver] call Tally_Fnc_GetNearestEnemy;
Private _PreviousAction 		= (_Vehicle GetVariable "currentAction");
Private _timeSinceLastRepair	= time - (_Vehicle GetVariable "lastRepair");



		if!(IsNull _NearestEnemy)
		then{
				_EnemiesNearby	= true;
				
				if(_NearestEnemy distance2d _Vehicle < 120)
				then{
						_DangerClose = true;
					};
			};



If(!alive _Vehicle)	exitWith{};
if(_timeSinceLastRepair < 120)exitWith{};


If(alive _Vehicle
&&{!(IsNil "_Driver")
&&{alive _Driver
&&{_NeedRepairs
&&{!(_DangerClose)}}}})
then{
		
		_Vehicle setVariable ["repairing", true, true];
		_Vehicle setUnloadInCombat [false, false];
		_Vehicle setVariable ["currentAction", "Repairing", true];
		
		
		
		
		
		
		
		
		_Vehicle setVelocityModelSpace [0, 0, 0];
		private _Timer = time + 3;
		
		if(_EnemiesNearby)
		then{
				[_Vehicle] spawn Tally_Fnc_DeploySmoke;
				sleep 2;
			};
		
		
		private _Timer = time + 3;
		
		_Vehicle setVelocityModelSpace [0, 0, 0];
		_Driver	action ["Eject", _Vehicle];
		_Vehicle lock true;
		sleep 0.2;
			
		private _Script = [_Driver, _Vehicle] spawn Tally_Fnc_RepairVehicle;
		waituntil {scriptDone _Script};
		if(alive _Vehicle
		&&{alive _Driver})
		then{
				_Crew orderGetIn true;
				sleep 5;
				if!(vehicle _Driver == _Vehicle)
				then 	{
							_Driver MoveInDriver _Vehicle;
								
						};
				{
									private _CrewMember	= _X;
									if(alive _CrewMember
									&&{alive _Vehicle})
									then{
											if !(vehicle _CrewMember == _Vehicle)
											then{
													private _FoundPos	= false;
													
													if (_CrewMember == assignedGunner 	 _Vehicle)	then{_CrewMember MoveInGunner 		_Vehicle; _FoundPos = true};
													if (_CrewMember == assignedCommander _Vehicle)	then{_CrewMember MoveInCommander 	_Vehicle; _FoundPos = true};
													if (_CrewMember == assignedDriver 	_Vehicle)	then{_CrewMember MoveInDriver 		_Vehicle; _FoundPos = true};
													if !(_FoundPos)									then{_CrewMember MoveInCargo 		_Vehicle};
												};
										sleep 1;
										};
				}ForEach _Crew;
			};
		
		_Vehicle setVariable ["currentAction", _PreviousAction, true];
		_Vehicle setUnloadInCombat [true, false];
		_Vehicle setVariable ["repairing", false, true];
		_Vehicle lock false;
	};
};




Tally_Fnc_RepairVehicle = {
params["_unit", "_Vehicle"];
private _RepairMoves 		= ["REPAIR_VEH_STAND", "REPAIR_VEH_KNEEL", "REPAIR_VEH_PRONE"];
Private _RepairType	 		= 0;
private _VehicleType 		= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _VehicleDimensions 	= [_VehicleType] call Tally_Fnc_GetVehicle_Width_Length;
private _LoadOut 			= getUnitLoadout _unit;
private _RepairTime			= 40;
Private _DammageToRepair	= 1 - (GetDammage _Vehicle);
Private _IterationRepair	= _DammageToRepair / _RepairTime;
private _Success			= true;
private _FuelLevel			= true;


if (_RepairType == 0)then	{
								private _Width 		= _VehicleDimensions select 0;
								private _RepairPos 	= _Vehicle modelToWorld [-(_Width / 2),0,0];
										_RepairPos	= [_RepairPos select 0,
													   _RepairPos select 1,
													   0];
								Private _Timer		= time + 10;
								private _Move		= _RepairMoves select _RepairType;
								
								
								_unit DoMove _RepairPos;
								sleep 1;
								_Unit attachTo [_Vehicle, [+(_Width / 2),0,-2]];
								_Unit SetDir 270;
								_Timer = time + _RepairTime;
								_unit switchMove "amovPknlMstpSrasWrflDnon";
								sleep 0.1;
								detach _Unit;
								_unit disableAI "all";
								[_unit, _Move, "FULL"] RemoteExecCall ["BIS_fnc_ambientAnim", 0];
								for "_I" from 1 to _RepairTime
								do 	{
										if(!Alive _Unit
										or !Alive _Vehicle) exitWith{
																		_Success = false;
																	};
										private _VehDammage = (GetDammage _Vehicle);
										if(_VehDammage < 0.5
										&&{CanMove _Vehicle
										&&{CanFire _Vehicle}}) exitWith{_Success = true};
										
										_Vehicle SetDammage _VehDammage - _IterationRepair;
										sleep 1;
									};
								
								_unit enableAI "all";
								
								if (fuel _Vehicle == 0) then 	{
																	_Vehicle SetFuel 0.1;
																};
								[_unit] RemoteExecCall ["BIS_fnc_ambientAnim__terminate", 0];
							};
if(_Success)then{
					_Vehicle setVariable ["currentAction", "Repairs completed", true];
					
				}
			else{
					_Vehicle setVariable ["currentAction", "Repairs failed", true];
				};

sleep 0.1;
_Vehicle SetVariable ["lastRepair",	time, true];
_unit setUnitLoadout _LoadOut;
};


Tally_Fnc_NeedRepairs = {
params["_Vehicle"];
private _NeedRepairs = false;
private _Damage		 = (GetDammage _Vehicle);

if (!CanMove _Vehicle
or !CanFire _Vehicle
or _Damage > 0.5)
then{
	if(Alive _Vehicle)
	then{
			_NeedRepairs = true;
		};
	};

_NeedRepairs};

Tally_Fnc_FilterPos = {
Params ["_Vehicle", "_Center"];

private _PosCount = (count (_Vehicle GetVariable "Positions"));
if (Isnil "_PosCount"
or Isnil "_Vehicle"
or Isnil "_Center")exitWith{["Could not filter flanking positions because values were undefined"] call debugMessage};


Diag_Log format ["%1 positions pre-selected", (count (_Vehicle GetVariable "Positions"))];

If (FSMD3Bugger) then {[_Vehicle, "ELLIPSE", _Center, 0, 150, "Colorblue", "SOLID"] call Tally_Fnc_VehMarkers}; 


if(_PosCount > 10)then{
						_FinalPositions = [(_Vehicle GetVariable "Positions")] Call Tally_Fnc_GetTopHeights;
						_Vehicle SetVariable ["Positions", _FinalPositions, true];
						_PosCount = (count (_Vehicle GetVariable "Positions"));

if(_PosCount > 5)then{
						_FinalPositions = [(_Vehicle GetVariable "Positions"), _Center] Call Tally_Fnc_GetClosePosArr;
						_Vehicle SetVariable ["Positions", _FinalPositions, true];
					  }};

If (FSMD3Bugger) then {
								{
								[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorRed", "SOLID"] call Tally_Fnc_VehMarkers;
								} ForEach (_Vehicle GetVariable "Positions");
								
								systemChat format ["%1 flank positions left", (count (_Vehicle GetVariable "Positions"))];
						};
						

};



Tally_Fnc_Remove_NonTerrain_IntersectPos = {
params["_TargetPos", "_Vehicle"];

private _OldArr = (_Vehicle GetVariable "HidePositions");
private _NewArr = [];

if(isnil "_OldArr")exitWith{_NewArr};


private _Center				= [_TargetPos select 0,
							   _TargetPos select 1,
							  (_TargetPos select 2) + 2.5];
private _deletedEntries 	= 0;

{
	private _Pos = [_x select 0,
					_x select 1,
				   (_x select 2) + 2.5];
	
	if (terrainIntersect [_Pos, _Center]) 
										Then 	{
													_NewArr pushBackUnique _x;
												}
										else 	{
													_deletedEntries = (_deletedEntries + 1);
												};

}ForEach (_Vehicle GetVariable "HidePositions");



_NewArr};




Tally_Fnc_FilterHidePos = {
Params ["_Vehicle", "_Center"];

private _FilteredPositions = [_Center, _Vehicle] call Tally_Fnc_Remove_NonTerrain_IntersectPos;
_Vehicle SetVariable ["HidePositions", 
					  _FilteredPositions, 
					  true];
					  
private _PosCount = count _FilteredPositions;


if (_PosCount > 10)then	{
							private _FinalPositions = [_Vehicle] Call Tally_Fnc_GetLowerThanTopPositions;
							_Vehicle SetVariable ["HidePositions", _FinalPositions, true];
							_PosCount = (count (_Vehicle GetVariable "HidePositions"));
						
if (_PosCount > 10)then	{
							_FinalPositions = [(_Vehicle GetVariable "HidePositions"), (_Vehicle GetVariable "EvadePos")] Call Tally_Fnc_GetClosePosArr;
							_Vehicle SetVariable ["HidePositions", _FinalPositions, true];
						}};





If (FSMD3Bugger) then {
								{
								[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorWhite", "SOLID"] call Tally_Fnc_VehMarkers;
								} ForEach (_Vehicle GetVariable "HidePositions");
						};

_Vehicle SetVariable ["HiddenPosLoaded",true, true];

if(FSMD3Bugger)
then{
		systemChat format ["%1 Hide-Positions left", (count (_Vehicle GetVariable "HidePositions"))];
	};

};




Tally_Fnc_GetHidePos = {
private _secondTry = false;
params ["_Vehicle", "_Initiator", "_secondTry"];
private _EvasionPos 	= ( _Vehicle GetVariable "EvadePos");
Private _EnAvgPos 		= (_Vehicle GetVariable "Centro");
private _SelectedArea 	= ((_Vehicle GetVariable "Areas") select 0);
private _SecondArea 	= ((_Vehicle GetVariable "Areas") select 1);
private _ThirdArea 		= ((_Vehicle GetVariable "Areas") select 2);
private _Timer			= time + 3;
private _Nil				= false;
private _CopiedPos		= false;



If(_secondTry)
then{
		_Vehicle SetVariable ["TwoTimesHideSearch",	true, true];
	};

If(!IsNil "_Initiator")
then{
Private _InitDistance = (_Initiator distance2d _Vehicle);
if (IsNil "_InitDistance")exitWith{};
if(_InitDistance > 200) exitWith{};
		waituntil{
					sleep 0.1;
					private _Loaded 	= (_Initiator GetVariable "HiddenPosLoaded");
					private _TimedOut 	= (_Timer < time);
					
					if(IsNil "_Loaded")exitWith{true};
					
					if(_TimedOut
					or _Loaded)
					exitWith{true};
					false
				  };
		
		private _FriendlyHidePositions = (_Initiator GetVariable "HidePositions");
		
		if(Isnil "_FriendlyHidePositions")exitWith{};
		
		if(((count _FriendlyHidePositions) > 5)
		&&{(_Initiator GetVariable "HiddenPosLoaded")})
		then{
				_Vehicle SetVariable ["HidePositions", _FriendlyHidePositions, 	true];
				_Vehicle SetVariable ["HiddenPosLoaded",true, 				true];
				_CopiedPos = true;
				["Hiding positions were copied from ", _Initiator] call debugMessage;
			};
	};

if!(_CopiedPos)
then{
		
		private _Script = [_SelectedArea 	select 0,
						  _SelectedArea		select 1,
						  _Vehicle,
						  true] spawn Tally_Fnc_Scan_Area;
		waituntil	{
						sleep 0.05;
						private _ScriptDone = (scriptDone _Script);
						private _TimedOut 	= (time > _Timer);
								_Nil		= (IsNil "_ScriptDone");
								
						if(_Nil 
						or _ScriptDone
						or _TimedOut) 
						exitWith {
									true
								};
						false
					};



		if (count (_Vehicle GetVariable "HidePositions") < 1)
		then 	{
					["No hiding positions was found, scanning second area"] call debugMessage;
					
					_Script = [_SecondArea 	select 0,
								_SecondArea	select 1,
								_Vehicle,
								true] spawn Tally_Fnc_Scan_Area;
						
						waituntil	{
						sleep 0.05;
						private _ScriptDone = (scriptDone _Script);
						private _TimedOut 	= (time > _Timer);
								_Nil		= (IsNil "_ScriptDone");
								
						if(_Nil 
						or _ScriptDone
						or _TimedOut) 
						exitWith {
									true
								};
						false
					};
		
					if (count (_Vehicle GetVariable "HidePositions") < 1)
					then 	{
								["No hiding positions was found, scanning third area"] call debugMessage;
								
								_Script = [_ThirdArea 	select 0,
											_ThirdArea	select 1,
											_Vehicle,
											true] spawn Tally_Fnc_Scan_Area;
									
									waituntil	{
									sleep 0.05;
									private _ScriptDone = (scriptDone _Script);
									private _TimedOut 	= (time > _Timer);
											_Nil		= (IsNil "_ScriptDone");
											
									if(_Nil 
									or _ScriptDone
									or _TimedOut) 
									exitWith {
												true
											};
									false
								};
		
							};
			};

	};


[_Vehicle, _EnAvgPos] 	call Tally_Fnc_FilterHidePos;
};




Tally_Fnc_SearchAreas = {
Params ["_area1pos", "_area1Size", "_Vehicle", "_Dir"];
private _SideColor = "ColorBlack";
private _Side		= (Side (Driver _Vehicle));
private _Areas		= [];

if (_Side == west) 	then {_SideColor = "ColorWEST"}
							else {
									if (_Side == east) 	then {_SideColor = "ColorEAST"}
														else{
																if (_Side == independent) 	then {_SideColor = "ColorEAST"}
															};
								 };


If (FSMD3Bugger) then 	{
							[_Vehicle, "ELLIPSE", _area1pos, _Dir, _area1Size, "ColorRed", "Border"] call Tally_Fnc_VehMarkers; 
						};
Private _SearchAreaSize		= 	(_area1Size * 0.5);
Private _Distance			=	(_area1Size * 1.6);

Private _SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), _Dir, _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];
								
								
								_Distance = (_area1Size * 0.8);

		_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir + 67.5), _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];

								


		_SearchAreaPos 		= 	([(_area1pos select 0), (_area1pos select 1), (_Dir - 67.5), _Distance] call Tally_Fnc_CalcAreaLoc);
								_Areas PushBackUnique [_SearchAreaPos, _SearchAreaSize, _Vehicle];

								


	
_Areas};



Tally_Fnc_Scan_Area = {
private _StartTime	= time;
private _GetHidePos = false;
private _GetPushPos = false;
Params ["_Pos", "_Size", "_Vehicle", "_GetHidePos", "_GetPushPos"];

Private _PosAmount 	= 10;
Private _Spacing 	= (_Size / _PosAmount);

Private _StartPos = ([(_Pos select 0), (_Pos select 1), 225, (_Size * 1.272727)] Call Tally_Fnc_CalcAreaLoc);
_StartPos = [	_StartPos select 	0, 
				_StartPos select 	1, 
									0];

For "_I" from 1 to _PosAmount do {
									private _Timer = time + 1;
									
									[_StartPos, _Spacing, _PosAmount, _Vehicle, _GetHidePos, _GetPushPos] call Tally_Fnc_Ygrid;
									 _StartPos = [((_StartPos select 0) + (_Spacing * 2)), 
													_StartPos select 1, 
																	 0];
									
									if (time > _Timer)exitWith {};
								  };
_Vehicle SetVariable ["Spacing", 		_Spacing, true];


};

																			  

Tally_Fnc_Ygrid = {
private _GetHidePos = false;
params ["_Pos", "_Spacing", "_Final_Height", "_Vehicle", "_GetHidePos", "_GetPushPos"];
Private _Center = (_Vehicle GetVariable "Centro");

if (isNil "_Center") 
	then{
			private _Distance = (_Vehicle GetVariable "MinDistEnemy");
			if(Isnil "_Distance")
			then{
					_Distance = VehMinimumDistance;
				};
			
			_Center = getPos ([_Distance, (Driver _Vehicle)] call Tally_Fnc_GetNearestEnemy);
			
		};

					
	for "_i" from 1 to _Final_Height do {
	
	if!(typeName (_Pos select 0) == "SCALAR")
	exitWith{diag_log "non-number position caused conflict while scanning"};
											
											If !(surfaceIsWater 
												[(_Pos select 0), 
												(_Pos select 1)]) 
												then {
												If !(_GetPushPos) then	{
														if !(terrainIntersect [_Pos, _Center] )  
																			then 	{
															
																						(_Vehicle GetVariable "Positions") PushbackUnique  _Pos;
																						If (FSMD3Bugger) then 	{[_Vehicle, "RECTANGLE", _Pos, 0, _Spacing, "ColorOrange", "SolidBorder"] call Tally_Fnc_VehMarkers;};
																					
																					}
																				else{
																				if (_GetHidePos)then{
																										(_Vehicle GetVariable "HidePositions") PushbackUnique  _Pos;
																									};
																					};	
																				
																		}
																	else{
																			
																			(_Vehicle GetVariable "PushPositions") PushbackUnique  _Pos;
																			
																		};
																												
													 };
										_Pos = [_Pos select 0, (_Pos select 1) + (_Spacing * 2), 1];
										};

};



missionNamespace setVariable[
"Tally_Fnc_CalcAreaLoc", {
params ["_OrigX", "_OrigY", "_Dir", "_Distance"];


Private _NewX = ((sin _Dir) * _Distance) + _OrigX;
Private _Newy = ((cos _Dir) * _Distance) + _OrigY;

Private _SearchAreaPos = [_NewX,_NewY, 0];


_SearchAreaPos}
, true];

















Tally_Fnc_GetLowerThanTopPositions = {
params ["_Vehicle"];
private _FlankPositions 	= (_Vehicle GetVariable "Positions");
private _HidePositions 		= (_Vehicle GetVariable "HidePositions");

	if(IsNil "_FlankPositions") exitWith 	{
												_HidePositions
											};

private _AverageFlankHeight = [_FlankPositions] call Tally_Fnc_GetAVGheight;
private _newArr				= [];


{
	private _elevation = (round getTerrainHeightASL _x);
	if(_elevation < _AverageFlankHeight)then{
												_newArr pushBackUnique _X;
											};
}forEach _HidePositions;


_newArr};




Tally_Fnc_RemovePosLowerThan = {
params["_PosArr", "_Height"];

Private _NewArr = [];
{_NewArr PushBackUnique _x} ForEach _PosArr;

private _deletedEntries 	= 0;
for "_I" from 0 to (count _NewArr - 1) do{
										if(_I > (count _NewArr) - 2)exitWith{};
										private _deleteIndex = (_I - _deletedEntries);
										If ((ceil (getTerrainHeightASL (_NewArr select _I))) < _Height) Then {
																														_NewArr DeleteAt _deleteIndex;
																														_deletedEntries = (_deletedEntries + 1);
																													};
									};
_NewArr};




Tally_Fnc_GetTopHeights = {
Params ["_PosArr"];

For "_I" from 1 to 3 do {
							Private _AverageHeight = [_PosArr] call Tally_Fnc_GetAVGheight;
							_PosArr = [_PosArr, _AverageHeight] call Tally_Fnc_RemovePosLowerThan;
						};


_PosArr};



Tally_Fnc_GetAVG_Distance = {

Params ["_PosArr", "_Center"];

Private _Distances = [];
private _AverageDistance = 0;

if (Count _PosArr > 1) then {
								{
											private _Dist = (_Center Distance2D _x);
											If (TypeName _Dist == "SCALAR") then {_Distances Pushback _Dist};
								
								}forEach _PosArr;


								If (Count _Distances > 0) then {_AverageDistance = ([_Distances, "Tally_Fnc_GetAVG_Distance"] call Tally_Fnc_GetAVG)};
							};

If (IsNil "_AverageDistance") then {_AverageDistance = 0};

_AverageDistance};




Tally_Fnc_GetClosePosArr = {
Params ["_PosArr", "_Center"];
Private _NewArr = [];

if (isNil "_Center")exitWith{_PosArr};

Private _AverageDistance = (Round ([_PosArr, _Center] call Tally_Fnc_GetAVG_Distance));
		
if(isNil "_Center")exitWith{_PosArr};
		
{
	Private _Distance = (Round(_Center Distance2D _X));
										
	If (_Distance < _AverageDistance) Then	{
												_NewArr pushBackUnique _X;
											};
}ForEach _PosArr;



_NewArr};



Tally_Fnc_AVGclusterPOS = {
params ["_unit", "_Radius"];
private _AllowedDataTypes = ["OBJECT", "GROUP", "LOCATION"];

if!((TypeName _Unit) in _AllowedDataTypes)exitWith	{
														If(FSMD3Bugger)then{systemChat "Enemy unit not defined";};
														-1
													};

private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _Yarr 	= [];
Private _Xarr 	= [];

_list PushBackUnique _unit;

{
	if 	((Side _x) == (_Side))
	then 	{
			
				Private _Xpos   = (round ((Getpos _x) select 0));
				Private _Ypos   = (round ((Getpos _x) select 1));
				_Yarr PushBackUnique _Ypos;
				_Xarr PushBackUnique _Xpos;
			};
}ForEach _list;



Private _Returnpos = [(round ([_Xarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), (round ([_Yarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), 1];
If (Isnil "_Returnpos") then {
								_Returnpos = _Pos;
							};

_Returnpos};


Tally_Fnc_GetFriendlyPushPos = {
params["_Vehicle"];
Private _Friends = [_Vehicle, true] call Tally_Fnc_GetNearFriends;
Private _Center = (_Vehicle GetVariable "centro");
Private _PushPositions = [];

{
if(count _PushPositions > 30)exitWith{};

if(_x GetVariable "Evading")
then{
		Private _CloseCenter = (_x GetVariable "centro");
		
		if((_Center distance2d _CloseCenter) < 100)
		then{
				Private _Positions = (_x GetVariable "PushPositions");
				
				if(count _Positions > 0)
				then {
						for "_I" from 0 to (count _Positions - 1) do
						{
							private _Pos = _Positions select _I;
							_PushPositions pushBackUnique _Pos;
						};
					 };
			};
	};

}ForEach _Friends;


_PushPositions};

Tally_Fnc_PathDrawer = {
waituntil 	{sleep 10 + (ceil (random 1 * 10));
			 !IsNil "Tally_Fnc_GetPathPositions"};
[] call Tally_Fnc_VerifyData;
call ConfirmData;

};


Tally_Fnc_PushPositions = {
private _SecondScan = false;
params ["_Vehicle", "_SecondScan"];
private _HotsPot 	= (_Vehicle GetVariable "centro"); 

private _NewAssessment = [];
private _Timer			= time +3;
private _EnemiesInArea	= (_Vehicle getVariable "KnownEnemies");
private _StartTime		= time;

if (IsNil "_EnemiesInArea") then 	{
										_EnemiesInArea = [_Vehicle] call Tally_Fnc_UpdateKnownEnemies;
										_Vehicle SetVariable ["KnownEnemies", _EnemiesInArea, true];
									};

if (IsNil "_HotsPot")then{
							_HotsPot = getPos ([1000, _Vehicle] call Tally_Fnc_GetNearestEnemy);
						 };

if (IsNil "_HotsPot")then{
							_HotsPot = getPos _Vehicle;
						 };

if([_Vehicle] call Tally_Fnc_KnownEnemiesDead)exitWith	{
															
														};

private _NearbyPositions = [_Vehicle] call Tally_Fnc_GetFriendlyPushPos;

if (count _NearbyPositions > 10)exitWith{
											_Vehicle SetVariable ["PushPositions", _NearbyPositions, true];
											_Vehicle SetVariable ["PushPosLoaded", true, 	   		true];
										};


for "_I" from 1 to 3 do {
							_Timer = time +3;
							private _Script = [_HotsPot, 200, _Vehicle, false, true] spawn Tally_Fnc_Scan_Area;
							waituntil {((scriptDone _Script) or (time > _Timer))};
							
							private _Positions = (_Vehicle GetVariable "PushPositions");
							
							if (!Isnil "_Positions") exitWith {};
							sleep 0.1;
							["Re-scanning for Push-positions"] call debugMessage;
						};

private _PosCount = count (_Vehicle GetVariable "PushPositions");
If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{};

if (_PosCount > 10)then {
							waituntil {(!(AreaScan)) 
									  or (time > _Timer)};
							AreaScan = true;
								{
									_Pos = [_X select 0,
											_X select 1,
											0];
									Private _AssessedPosition = [_Vehicle, _Pos, _SecondScan] call Tally_Fnc_AssessPushPos;
									_NewAssessment pushBack _AssessedPosition;
									sleep 0.001;
								}ForEach (_Vehicle GetVariable "PushPositions");
							AreaScan = false;
													

							
							private _PosCount 		= (count (_Vehicle GetVariable "PushPositions"));
							private _AssPosCount 	= (count _NewAssessment);
							if(Isnil "_PosCount")exitWith{["Positions have not been defined"] call debugMessage;};
							if!(_PosCount == _AssPosCount) exitWith {
																		["Positions not properly assessed"] call debugMessage;
																	};

							private _FinalPositions = [(_Vehicle GetVariable "PushPositions"), _NewAssessment] call Tally_Fnc_FilterPushPos;
							
							
							if 	(Isnil "_FinalPositions"
							&& 	{!(_SecondScan)}) exitWith 	{
																sleep 1; 
																[_Vehicle, true] spawn Tally_Fnc_PushPositions;
															};

							if 	(Isnil "_FinalPositions"
							&& 	{(_SecondScan)}) exitWith 	{
																_Vehicle SetVariable ["PushPositions", [_HotsPot], true];
																_Vehicle SetVariable ["PushPosLoaded", true, 	   true];
															};


							_Vehicle SetVariable ["PushPositions", _FinalPositions, true];
							_Vehicle SetVariable ["PushPosLoaded", true, 			true];


						}
					else{
							if!(_SecondScan)then{
													[_Vehicle, true] spawn Tally_Fnc_PushPositions;
												}
											else{
													_Vehicle SetVariable ["PushPositions", [_HotsPot], true];
													_Vehicle SetVariable ["PushPosLoaded", true, 	   true];
													["Could not load push-positions"] call debugMessage;
													
												};
						};

If (FSMD3Bugger) then 	{
							{
								[_Vehicle, "ELLIPSE", _X, 0, 10, "ColorWhite", "SOLID"] call Tally_Fnc_VehMarkers;
							} ForEach 
							(_Vehicle GetVariable "PushPositions");
						};
if (count (_Vehicle GetVariable "PushPositions") > 30)
then{
		["Push positions loaded in", (time - _StartTime)] call debugMessage;
	};
};


Tally_Fnc_FilterPushPos = {
params ["_Original", "_AssessedPositions"];

private _FinalPositions 	 = [];
Private _PerfectPositions	 = [];
private _LOS_NoCover		 = [];
private _LOS_NoCoverNoHeight = [];
private _BadLOS				 = [];
private _TerribleLOS		 = [];
private _Selector 			 = 0;
private _MinimumPosAmount	 = 32;

if (isnil "_Original") exitWith {diag_log "Cannot filter push-positions because original array is undefined"};
if (_Original IsEqualTo []) exitWith {diag_log "No positions found, check timing of push pos loading"; nil};

if (_AssessedPositions IsEqualTo []) exitWith {diag_log "Positions have not been assessed"; nil};

	{
		private _LOSrank 			= _X select 2;
		private _HeightAdvantage 	= _X select 1;
		private _NearbyObjects 		= _X select 0;
		private _ObjectsPresent		= (count _NearbyObjects) > 0;
		
		if (_HeightAdvantage
		&& {_LOSrank < 1
		&& {_ObjectsPresent}}) then {
										_PerfectPositions pushBackUnique (_Original select _Selector);
									 }
								else {
										if (_HeightAdvantage
										&& {_LOSrank < 1}) then {
																	_LOS_NoCover pushBackUnique (_Original select _Selector);
																 }
															else {
																	if (_LOSrank < 1) then {
																								_LOS_NoCoverNoHeight pushBackUnique (_Original select _Selector);
																							}
																					  else	{
																								if (_LOSrank < 2) then {
																														_BadLOS pushBackUnique (_Original select _Selector);
																														}
																												   else {
																															if (_LOSrank < 3 ) then {
																																						_TerribleLOS pushBackUnique (_Original select _Selector);
																																					};
																														};
																							};
																 };
									 };
		
		
		_Selector = (_Selector + 1);
	} ForEach 
	_AssessedPositions;

_FinalPositions = _PerfectPositions;

private _BestCount 			= (count _PerfectPositions);
private _SecondBestCount 	= (count _LOS_NoCover);
private _ThirdBestCount 	= (count _LOS_NoCoverNoHeight);
private _LevelOfPositioning = 0;



if(_BestCount < _MinimumPosAmount)then{
_LevelOfPositioning = 1;
										private _Counter 	= 0;
										private _PosCount 	= (count _FinalPositions);
										{
											_FinalPositions pushBackUnique _X;
											_PosCount 	= (count _FinalPositions);
											if (_PosCount >= _MinimumPosAmount) exitWith {};
										
										}ForEach _LOS_NoCover;
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 2;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _LOS_NoCoverNoHeight;
																				};
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 3;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _BadLOS;
																				};
										
										if (_PosCount < _MinimumPosAmount) then {
										_LevelOfPositioning = 4;
																					{
																						_FinalPositions pushBackUnique _X;
																						_PosCount 	= (count _FinalPositions);
																						if (_PosCount >= _MinimumPosAmount) exitWith {};
																					
																					}ForEach _TerribleLOS;
																				};
									  };

If (FSMD3Bugger) then 	{systemChat format ["Selected %1 push positions. Position ranking = %2", (Count _FinalPositions), _LevelOfPositioning]};

_FinalPositions};



Tally_Fnc_AssessPushPos = {
params ["_Vehicle", "_Pos"];

private _HigherThanEn	= (_Vehicle GetVariable "AvgEnemyAltitude") > (round getTerrainHeightASL _Pos);
private _NearbyObjects	= nearestTerrainObjects [_Pos, [], 5];
private _Pos 			= [_Pos select 0, _Pos select 1, 1.5];
private	_ASLPos			= ATLToASL _Pos;
private _EnemiesInArea 	= (_Vehicle getVariable "KnownEnemies");
Private _LOSrank 		= [];
private _counter		= 0;

if(Isnil "_EnemiesInArea")then{_EnemiesInArea = [_Vehicle] call Tally_Fnc_UpdateKnownEnemies;};

if(!Isnil "_EnemiesInArea")then{
									{
										private _Enemy 		 = 	_X;
										private _EnemyPos 	 = 	[(getPos _Enemy select 0),
																 (getPos _Enemy select 1),
																 1.5];
										private _ASLEnemyPos = ATLToASL _EnemyPos;
										
										if !(terrainIntersect [_Pos, _EnemyPos]) 
																					then 	{
																								private _Intersections = lineIntersectsSurfaces [_ASLPos, _ASLEnemyPos, _Enemy, _Vehicle, false, 3, "VIEW", "NONE", true];
																								_LOSrank pushBack (count _Intersections);
																							}
																					else	{
																								_LOSrank pushBack 4;
																							};
										_counter = (_counter +1);
										if(_Counter == 5)exitWith{};
									
									}ForEach _EnemiesInArea;
								}
							else{
									if(FSMD3Bugger) then {systemChat "enemies undefined"};
								};
if (Count _LOSrank > 1) then{
								_LOSrank = [_LOSrank, "Tally_Fnc_AssessPushPos"] call Tally_Fnc_GetAVG;
							}
					else	{
								_LOSrank = 4;
							};




[_NearbyObjects, _HigherThanEn, _LOSrank]};
Tally_Fnc_EndEvasionVeh = {
params ["_Vehicle", "_EndStatus"];
private _ScriptRunning 	= (_Vehicle GetVariable "EndingNow");
private _Action 			= (_Vehicle GetVariable "currentAction");
private _Attempts 		= (_Vehicle GetVariable "EndAttempts");
private _Ended 			= (_Vehicle GetVariable "endedAlready");
private _lastOutro		= (_Vehicle GetVariable "lastOutro");


if(!Isnil "_lastOutro"
&&{time - _lastOutro < iterationTimer}) exitWith {["End script double-fired"] call debugMessage};

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


[_Vehicle] call Tally_Fnc_RemoveVehicleVars;
_vehicle allowCrewInImmobile true;
(Gunner _Vehicle) doWatch objNull;



sleep iterationTimer * 5;

if([_vehicle] call Tally_Fnc_Available_And_Wp)
				then{
						[(group _vehicle)] call Tally_Fnc_ResetGroup;
					};

};

Tally_Fnc_ResumeOriginalPath = {
params["_Vehicle"];
private _destroyed 	= [_Vehicle] call Tally_Fnc_crewDead;
if(!(_destroyed))
then{
		private _Group 		= (group _Vehicle);
		private _hasWP		= ((count waypoints _Group) > 0);
		private _engaged	= [_Vehicle] call Tally_Fnc_GroupFsmActive;
		
		if([_vehicle] call Tally_Fnc_Available_And_Wp)
		then{
				
				
				sleep iterationTimer;
				
				if([_vehicle] call Tally_Fnc_Available_And_Wp)
				then{
								_Group 			= (group _Vehicle);
						private _Wp				= (waypoints _Group) select (currentWaypoint _Group);
						private _pos 			= waypointPosition _Wp;
						private _LeaderVeh		= vehicle (leader _group);
						private _LeaderIsVeh		= false;
						
						if(!IsNil "_Wp")
						then{
						if!(_LeaderVeh iskindof "man")then{
															[_LeaderVeh, _pos] spawn Tally_Fnc_SoftMove; 
															_LeaderIsVeh = true;
														  };
						units _group doFollow leader _group;
						sleep iterationTimer * 2;
						};
						
						_Group SetVariable ["lastGroupReset",	nil, true];
						[_vehicle] spawn Tally_Fnc_RedoWP;
						
					};
			};
		
	};

};


Tally_Fnc_RedoWP = {
params ["_Vehicle"];
if([_Vehicle] call Tally_Fnc_crewDead)exitWith{["Cannot re-initiate waypoints, crew is dead / nil / null / absent"]call debugMessage};

private _Group				= group _Vehicle;
private _PreviousWayPoints 	= [_Vehicle] call Tally_Fnc_GetWaypointInfo;
private _CurrentIndex 		= (currentWaypoint _Group);
private _Busy				= (_Group getVariable "resettingWP");

if(!isnil "_Busy")exitWith{};

["Re-applying waypoints"]call debugMessage;

_Group setVariable ["resettingWP", true, true];
[_Group] spawn Tally_Fnc_ResetGroup;

sleep 0.1;
[_Group] call Tally_Fnc_DeleteWP;
[_Group] call Tally_Fnc_DeleteWP;
[_Group] call Tally_Fnc_DeleteWP;
sleep 0.1;

		{
			
			private _Index 		= _x select 1;
			
			
			If(_Index > _CurrentIndex)
			then 	{
						private _Position 	= _x select 0;
						private _behaviour 	= _x select 2;
						private _speed 		= _x select 3;
						private _formation 	= _x select 4;
						
						private _wp = _Group addWaypoint [_Position, 0];
						_wp setWaypointBehaviour 	_behaviour;
						_wp setWaypointSpeed  		_speed;
						_wp setWaypointFormation 	_formation;
						_wp setWaypointCompletionRadius 60;
						sleep 0.1;
					
					};
			
			
			
			
		}ForEach 
		_PreviousWayPoints;

_Group setCurrentWaypoint [_Group, _CurrentIndex];
_Group setVariable ["resettingWP", nil, true];
};

Tally_Fnc_Available_And_Wp = {
params ["_Vehicle"];
private _destroyed 	= [_Vehicle] call Tally_Fnc_crewDead;

if(_destroyed)exitWith{false};

private _Group 		= (group _Vehicle);
private _hasWP		= ((count waypoints _Group) > 0);
private _engaged	= [_Vehicle] call Tally_Fnc_GroupFsmActive;

private _Available 	= (_hasWP
					&&{!(_engaged)});

_Available};


Tally_Fnc_GroupFsmActive = {
params["_Vehicle"];
private _Active = false;
private _GroupVehicles = [(Group _Vehicle)] call Tally_Fnc_GetGroupVehicles;

_GroupVehicles pushBackUnique _Vehicle;

{

	Private _Evading 		= (_X getVariable "Evading");
			_Evading 		= (!IsNil "_Evading");
			
	if(_Evading)then{_Active = true};
		
}forEach _GroupVehicles;

_Active};



Tally_Fnc_crewDead = {
private _AllDead = true;
params ["_Vehicle"];
private _Group = (group _Vehicle);

if(IsNil "_Vehicle")	exitWith{true};
if(IsNil "_Group")		exitWith{true};
if(!Alive _Vehicle)		exitWith{true};
if(IsNull _Group) 		exitWith{true};

{
	if(Alive _X)exitWith{_AllDead = false};
}ForEach 
(Crew _Vehicle);

if!((crew _Vehicle)isEqualTo([]))
then{_AllDead = false};



_AllDead};

Tally_Fnc_PostScriptActions = {
params ["_Vehicle", "_EndStatus", "_Action"];

if (IsNil "_Vehicle") 	exitWith{};
_Vehicle SetVariable ["EndingScript", 	true, true];
sleep 2;

private _ReEngageOrders 	= ["flank", "push"];
private _TargetPos 			= (_Vehicle GetVariable "Centro"); 			if(IsNil "_TargetPos")exitWith{};
private _Crew 				= (_Vehicle GetVariable "Crew");				if(IsNil "_Crew")exitWith{["Crew is not defined on vehicle: ", _Vehicle] call debugMessage};
private _MinDist				= (_Vehicle GetVariable "MinDistEnemy");
private _outOfReach 		= (_TargetPos distance2d (getpos _Vehicle) > (_MinDist * 0.75));
private _CrewWorks			= (_Vehicle GetVariable "crewStatus")	== "Operational";
private _GetBack				= _Action in _ReEngageOrders;
private _CrewInVehicle		= [_Vehicle] call Tally_Fnc_CrewInVehicle;
private _CrewMember		= (_Crew select 0);
private _vehicleType			= (_Vehicle GetVariable "vehicleType");
If(isnil "_CrewMember") then   {_CrewMember = crew _Vehicle select 0};
If(isnil "_CrewMember")exitWith{["could not complete postscripts"] call debugMessage};
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
};

Tally_Fnc_RemoveVehicleVars = {
params ["_Vehicle"];


			_Vehicle SetVariable ["TwoTimesHideSearch",nil, true];
			_Vehicle SetVariable ["LastConditionCheck",nil, true];
			_Vehicle SetVariable ["initiated",		nil, true];
			_Vehicle SetVariable ["hiding", 			nil, true];
			_Vehicle SetVariable ["Cluster", 		nil, true];
			_Vehicle SetVariable ["Centro", 			nil, true];
			_Vehicle SetVariable ["Spacing", 		nil, true];
			_Vehicle SetVariable ["Positions", 		nil, true];
			_Vehicle SetVariable ["HidePositions", 	nil, true];
			_Vehicle SetVariable ["HiddenPosLoaded",	nil, true];
			_Vehicle SetVariable ["Areas", 			nil, true];
			_Vehicle SetVariable ["SelPosMarked",	nil, true];
			_Vehicle SetVariable ["Evading", 		nil, true];
			_Vehicle SetVariable ["EvadePos",		nil, true];
			_Vehicle SetVariable ["timer",			nil, true];
			_Vehicle SetVariable ["MinDistEnemy", 	nil, true];
			_Vehicle setVariable ["Crew",			nil, true];
			_Vehicle setVariable ["driver", 			nil, true];
			_Vehicle setVariable ["gunner", 			nil, true];
			_Vehicle setVariable ["gunner_2", 		nil, true];
			_Vehicle setVariable ["commander", 		nil, true];
			_Vehicle setVariable ["KnownEnemies", 	nil, true];
			_Vehicle setVariable ["vehicleType", 	nil, true];
			_Vehicle setVariable ["currentAction", 	nil, true];
			_Vehicle setVariable ["crewStatus", 		nil, true];
			_Vehicle setVariable ["PushPositions", 	nil, true];
			_Vehicle setVariable ["PushPosLoaded", 	nil, true];
			_Vehicle SetVariable ["NearFriends", 	nil, true];
			_Vehicle SetVariable ["EndingScript", 	nil, true];
			_Vehicle setVariable ["Checking", 		nil, true];
			_Vehicle setVariable ["ready", 			nil, true];
			_Vehicle SetVariable ["EndingNow", 		nil, true];
			_Vehicle setVariable ["EndAttempts", 	nil, true];
			_Vehicle SetVariable ["endedAlready", 	nil, true];
			_Vehicle SetVariable ["FlankPosLoaded", 	nil, true];
			_Vehicle SetVariable ["pathPos",			nil, true];
			_Vehicle SetVariable ["GroupVehicles",	nil, true];
			
			

{_X SetVariable ["Spotted", nil, true];}ForEach(_Vehicle GetVariable "AllSpotted");
_Vehicle setVariable ["AllSpotted", 	nil, true];
{deleteMarker _X} ForEach (_Vehicle GetVariable "Markers");
_Vehicle SetVariable ["Markers", 		nil, true];

If !(alive _Vehicle) then {
													_Vehicle removeAllEventHandlers "Fired";
													_Vehicle removeAllEventHandlers "HandleDamage";
													_Vehicle setVariable ["EventHandlers", nil, true];
												  };


};Tally_Fnc_GetChopperType = {
params ["_Chopper"];
Private _ChopperWeapons = [_Chopper] call Tally_Fnc_GetVehicleWeapons;
private _Unidentified_W = [];
private _ChopperType 	= "Unarmed Chopper";
private _LightWeapons 	= 0;
Private _HeavyWeapons 	= 0;
Private _AAcapability 	= 0;



Private _AllCfgWeapons = [	"CUP_Vacannon_Yakb_veh",
							"CUP_Vmlauncher_AT9_veh",
							"CUP_Vhmg_PKT_veh_Noeject",
							"CUP_Vhmg_PKT_veh2",
							"CUP_Vhmg_PKT_veh3",
							"CUP_weapon_mastersafe",
							"CUP_Laserdesignator_mounted",
							"CUP_Vacannon_M230_veh",
							"CUP_Vmlauncher_AGM114L_veh",
							"CUP_Vmlauncher_AIM9L_veh_1Rnd",
							"CUP_M134",
							"CUP_M134_2",
							"CUP_Vlmg_L7A2_veh",
							"Laserdesignator_mounted",
							"gatling_20mm",
							"missiles_ASRAAM",
							"missiles_DAGR",
							"CUP_Vacannon_M197_veh",
							"CUP_Vmlauncher_AGM114K_veh",
							"LMG_Minigun_Transport",
							"LMG_Minigun_Transport2",
							"CUP_Vmlauncher_TOW_veh",
							"CUP_Vmlauncher_AT2_veh",
							"FakeHorn",
							"CUP_Vacannon_GI2_veh",
							"CUP_Vmlauncher_AT6_veh",
							"CUP_Vmlauncher_AT16_veh",
							"CUP_Vacannon_2A42_Ka50",
							"CUP_M32_heli",
							"CUP_M240_uh1h_right_veh_W",
							"CUP_M240_uh1h_left_veh_W",
							"gatling_30mm",
							"missiles_SCALPEL",
							"rockets_Skyfire",
							"CUP_Vlmg_M134_veh",
							"CUP_Vlmg_M134_veh2",
							"CUP_Vhmg_GAU21_MH60_Left",
							"CUP_Vhmg_GAU21_MH60_Right",
							"CUP_M240_veh_W",
							"CUP_M240_veh2_W",
							"CMFlareLauncher",
							"CUP_Vmlauncher_S5_veh",
							"CUP_Vmlauncher_S8_CCIP_veh",
							"M134_minigun",
							"missiles_DAR",
							"CUP_Vmlauncher_FFAR_veh",
							"CUP_DL_CMFlareLauncher",
							"CUP_Vlmg_M134_A_veh",
							"CUP_Vacannon_M621_AW159_veh",
							"CUP_Vmlauncher_CRV7_veh",
							"rhs_weap_CMDispenser_ASO2",
							"rhs_weap_MASTERSAFE",
							"rhs_weap_yakB",
							"rhs_weap_2K8_launcher",
							"rhs_weap_s5ko",
							"rhs_weap_s5k1",
							"rhs_weap_gi2",
							"Laserdesignator_pilotCamera",
							"rhs_weap_zt3_Launcher",
							"rhs_weap_DIRCM_Lipa",
							"rhs_weap_s8df",
							"rhs_weap_s8",
							"rhs_weap_fcs_mi24",
							"rhs_weap_9K114_launcher",
							"rhs_weap_CMFlareLauncher",
							"rhs_weap_s5m1",
							"rhs_weap_DummyLauncher",
							"rhs_weap_fcs_nolrf_ammo",
							"rhs_weap_FFARLauncher",
							"rhs_weap_fcs_ah64",
							"rhs_weap_M230",
							"rhs_weap_laserDesignator_AI",
							"rhs_weap_AGM114L_Launcher",
							"rhs_weap_AGM114K_Launcher",
							"rhsusf_weap_ANALQ144",
							"rhsusf_weap_CMDispenser_M130",
							"rhs_weap_m134_minigun_1",
							"rhsusf_weap_ANALQ212",
							"rhsusf_weap_DummyLauncher",
							"rhsusf_weap_LWIRCM",
							"RHS_weap_m134_pylon",
							"rhs_weap_M197",
							"rhs_weap_AIM9M",
							"rhsusf_weap_CMDispenser_ANALE39",
							"rhsusf_weap_ANAAQ24",
							"rhs_weap_fab250",
							"rhs_weap_9M120_launcher",
							"rhs_weap_gsh30",
							"rhs_weap_MASTERSAFE_Holdster15",
							"rhs_weap_2a42",
							"rhs_weap_9k121_Launcher",
							"rhs_weap_DIRCM_Vitebsk",
							"rhs_weap_CMDispenser_UV26"];

private _noWeapon 	  = [
							"FakeHorn",
							"Laserdesignator_mounted",
							"CUP_weapon_mastersafe",
							"CUP_Laserdesignator_mounted",
							"CMFlareLauncher",
							"CUP_DL_CMFlareLauncher",
							"Laserdesignator_pilotCamera",
							"rhs_weap_MASTERSAFE",
							"rhs_weap_CMFlareLauncher",
							"rhsusf_weap_DummyLauncher",
							"rhs_weap_CMDispenser_ASO2",
							"rhs_weap_CMDispenser_UV26",
							"rhs_weap_MASTERSAFE_Holdster15",
							"rhsusf_weap_CMDispenser_M130",
							"rhs_weap_DummyLauncher",
							"rhs_weap_laserDesignator_AI",
							"rhs_weap_fcs_nolrf_ammo",
							"rhsusf_weap_ANALQ144",
							"rhsusf_weap_ANALQ212",
							"rhsusf_weap_ANAAQ24",
							"rhs_weap_fcs_mi24",
							"rhsusf_weap_CMDispenser_ANALE39",
							"rhs_weap_DIRCM_Lipa",
							"rhs_weap_DIRCM_Vitebsk",
							"rhs_weap_fcs_ah64",
							"rhsusf_weap_LWIRCM"
							
							
							
						];

private _Guns = 	[
							"LMG_Minigun_Transport",
							"LMG_Minigun_Transport2",
							"CUP_Vlmg_M134_veh",
							"CUP_Vlmg_M134_veh2",
							"CUP_Vhmg_GAU21_MH60_Left",
							"CUP_Vhmg_GAU21_MH60_Right",
							"CUP_M240_veh_W",
							"CUP_M240_veh2_W",
							"CUP_M240_uh1h_right_veh_W",
							"CUP_M240_uh1h_left_veh_W",
							"gatling_30mm",
							"CUP_M32_heli",
							"CUP_M134",
							"CUP_M134_2",
							"CUP_Vlmg_L7A2_veh",
							"gatling_20mm",
							"CUP_Vhmg_PKT_veh_Noeject",
							"CUP_Vhmg_PKT_veh2",
							"CUP_Vhmg_PKT_veh3",
							"M134_minigun",
							"CUP_Vlmg_M134_A_veh",
							"rhs_weap_m134_minigun_1",
							"RHS_weap_m134_pylon"
					];
private _cannons = 	[
							"CUP_Vacannon_Yakb_veh",
							"CUP_Vmlauncher_AT9_veh",
							"CUP_Vacannon_M230_veh",
							"CUP_Vacannon_2A42_Ka50",
							"CUP_Vacannon_GI2_veh",
							"CUP_Vacannon_M197_veh",
							"CUP_Vacannon_M621_AW159_veh",
							"rhs_weap_M230",
							"rhs_weap_M197",
							"rhs_weap_gi2",
							"rhs_weap_yakB",
							"rhs_weap_2a42",
							"rhs_weap_gsh30"
					];

private _Rockets	 =	[
							"rockets_Skyfire",
							"CUP_Vmlauncher_S5_veh",
							"CUP_Vmlauncher_S8_CCIP_veh",
							"CUP_Vmlauncher_FFAR_veh",
							"CUP_Vmlauncher_CRV7_veh",
							"rhs_weap_FFARLauncher",
							"rhs_weap_s8df",
							"rhs_weap_s8",
							"rhs_weap_s5ko",
							"rhs_weap_s5k1",
							"rhs_weap_s5m1"
						];

private _ATmisiles = [
							"CUP_Vmlauncher_AGM114L_veh",
							"missiles_DAGR",
							"CUP_Vmlauncher_AGM114K_veh",
							"CUP_Vmlauncher_TOW_veh",
							"CUP_Vmlauncher_AT2_veh",
							"CUP_Vmlauncher_AT6_veh",
							"CUP_Vmlauncher_AT16_veh",
							"missiles_SCALPEL",
							"missiles_DAR",
							"rhs_weap_AGM114L_Launcher",
							"rhs_weap_AGM114K_Launcher",
							"rhs_weap_zt3_Launcher",
							"rhs_weap_9M120_launcher",
							"rhs_weap_9K114_launcher",
							"rhs_weap_9k121_Launcher",
							"rhs_weap_2K8_launcher"
					];

private _Bombs	=	[
							"rhs_weap_fab250"
					];

private _AAmisiles = [
							"CUP_Vmlauncher_AIM9L_veh_1Rnd",
							"missiles_ASRAAM",
							"rhs_weap_AIM9M"
						
					];

{
	if!(_X in _AllCfgWeapons)then{_Unidentified_W pushBack _X};
	
	if(_X in _Guns)		then{_LightWeapons 	= (_LightWeapons + 1)};
	if(_X in _cannons)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _Rockets)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _ATmisiles)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _Bombs)	then{_HeavyWeapons = (_HeavyWeapons + 1)};
	if(_X in _AAmisiles)	then{_AAcapability 	= (_AAcapability + 1)};


}ForEach _ChopperWeapons;

if(Count _Unidentified_W > 0)then	{
										["We could not identify the following chopper weapons: ", _Unidentified_W] call debugMessage; 
										["they have been copied to clipBoard"] call debugMessage; 
										if(FSMD3Bugger)then{copyToClipboard str _Unidentified_W};
										diag_Log _Unidentified_W;
									};

if(_LightWeapons > 0)then{_ChopperType 	= "Light Chopper"};
if(_HeavyWeapons > 0)then{_ChopperType = "Heavy Chopper"};


_ChopperType};










Tally_Fnc_ChopperEvasion ={

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
};
Tally_Fnc_Check_EvasionVeh_Conditions = {

params ["_Vehicle"];
_Vehicle setVariable ["Active", true, 	true];


private _CrewStatus  		= [_Vehicle] call Tally_Fnc_CheckCrewStatus;
Private _Timer 				= (_Vehicle getVariable "timer");
private _AllEnemiesDead		= [_Vehicle] call Tally_Fnc_KnownEnemiesDead;
Private _LastCheck 			= (_Vehicle getVariable "LastConditionCheck");
private _CurrentAction		= (_Vehicle getVariable "currentAction");
private _TimeSinceInit		= time - (_Vehicle getVariable "initiated");
private _endstatus			= ["Victory", "Defeat", "Broken", "Timed out", "Arrived", "Assesing situation", "Attempting to locate push-positions"];


if(!Isnil "_CurrentAction"
&&{_CurrentAction in _endstatus
&&{_TimeSinceInit > 20}})					exitWith	{
															["forcing outro"] call debugMessage;
															_Vehicle SetVariable ["endedAlready", true, true];
															[_Vehicle, _CurrentAction] spawn ExitEnd;
														};
if([_Vehicle] call Tally_Fnc_PlayerInVeh)	exitWith	{[_Vehicle, "Player is controlling this vehicle"] spawn ExitEnd};
if (_Vehicle GetVariable "repairing")	exitWith	{[_Vehicle, "none"] spawn ExitEnd};
if (_Vehicle getVariable "EndingScript") exitWith 	{[_Vehicle, "none"] spawn ExitEnd};
if (!Alive _Vehicle)						exitWith	{[_Vehicle, "Defeat"] spawn ExitEnd};
if (_CrewStatus == -1)					exitWith	{[_Vehicle, "crew dead"] spawn ExitEnd};
if (_AllEnemiesDead)						exitWith	{[_Vehicle, "Victory"] spawn ExitEnd;
													If(FSMD3Bugger)then{systemChat "All known enemies are dead, ending evasion"}};
if (_Vehicle GetVariable "switching") 	exitWith 	{[_Vehicle, "none"] spawn ExitEnd}; 
IF	(time > _Timer) 						exitWith 	{[_Vehicle, "Timed out"] spawn ExitEnd};
IF	(time < _LastCheck) 					exitWith 	{[_Vehicle, "none"] spawn ExitEnd; ["Double condition-check blocked"] call debugMessage};



Private _Evading 			= (_Vehicle getVariable "Evading");
private _Hiding				= ((_Vehicle getVariable "currentAction") == "hide");
private _Pushing				= ((_Vehicle getVariable "currentAction") == "push");
private _UpdatedEnemies 	= [_Vehicle] call Tally_Fnc_UpdateKnownEnemies;
Private _TargetPos 			= (_Vehicle getVariable "EvadePos");
Private _Minimum_Distance	= (_Vehicle getVariable "MinDistEnemy");
if (Isnil "_Minimum_Distance")exitWith{[_Vehicle, "Missing data"] spawn ExitEnd};
private _Driver				= (Driver _Vehicle);
private _Group				= (group _Driver);
private _Leader				= leader _Group;
Private _Enemy    			= ([(_Minimum_Distance * 1.5), _Driver] call Tally_Fnc_GetNearestEnemy);
Private _EnemyDist			= (_Driver Distance2D _Enemy);
Private _Radius				= (_Minimum_Distance / 10); 
private _TimedOut			= false;
private _TimeOutStatus		= ["Assesing situation", "Attempting to locate push-positions", "Scanning"];
private _RepairTimer			= time + 60;
private _DataChecked		= _Vehicle GetVariable "Viable";

_Vehicle SetVariable ["LastConditionCheck",	time + iterationTimer, true];



if(VehicleAutoRepair)
then{
		private _Script = [_Vehicle] spawn Tally_Fnc_InitRepairs;
		waituntil {sleep 0.25; (scriptDone _Script or time > _RepairTimer)};
		If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn ExitEnd};
	};

_CrewStatus  		= [_Vehicle] call Tally_Fnc_CheckCrewStatus;

if !(_Vehicle GetVariable "PushPosLoaded")then	{
													private _Script = [_Vehicle] Spawn Tally_Fnc_PushPositions;
													waituntil{scriptDone _Script};
													If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn ExitEnd};
												};

private _Script = [_Vehicle, _CrewStatus] spawn Tally_Fnc_HandleCrewStatus;
waituntil{scriptDone _Script};
If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{[_Vehicle, "none"] spawn ExitEnd};
if ([_Vehicle] call Tally_Fnc_KnownEnemiesDead)exitWith	{
															[_Vehicle, "Victory"] spawn ExitEnd;
															If(FSMD3Bugger)then{systemChat "All known enemies are dead, ending evasion"};								
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
										[_Vehicle, "TimeOut"] spawn ExitEnd;
										If(FSMD3Bugger)then{systemChat "Timed out"};
										
									};

private _NextAction 	= [_Vehicle] call Tally_Fnc_Flank_Hide_Push;
private _LoadedHidePos	= (_Vehicle GetVariable "HiddenPosLoaded");
private _LoadedPushPos	= (_Vehicle GetVariable "PushPosLoaded");
if([_Vehicle] call Tally_Fnc_PlayerInVeh) exitwith{[_Vehicle, "Player is controlling this vehicle"] spawn ExitEnd};
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
[_x] joinSilent deathGroup;
sleep 0.001;
[_x] joinSilent deathGroup}} 
forEach units _Group;

	{(_Vehicle GetVariable "AllSpotted") pushBackUnique _X}forEach 	(_Vehicle GetVariable "KnownEnemies");
	{
		_X SetVariable ["Spotted", true, true];
		If(!Alive _X)Then{_X SetVariable ["Spotted", nil, true];};
	}ForEach			(_Vehicle GetVariable "AllSpotted");


private _Distance	= (_Vehicle Distance2D _TargetPos);



IF	(!CanMove _Vehicle)				exitWith {[_Vehicle, "Broken"] spawn ExitEnd};
IF	(crew _Vehicle IsEqualTo []) 		exitWith {[_Vehicle, "Abandoned vehicle"] spawn ExitEnd};
IF	(_Distance < _Radius) 			exitWith {[_Vehicle, "Arrived"] spawn ExitEnd};
IF	(fuel _Vehicle == 0) 			exitWith {[_Vehicle, "No fuel"] spawn ExitEnd};



If ((_Distance > _Radius) 
&& {((velocityModelSpace _Vehicle) select 1) < 2}) then {[_Vehicle]  spawn Tally_Fnc_ForceMove};

If (Alive (Gunner _Vehicle)) then 	{
										private _Engaging = (_Vehicle getVariable "Engaging");
										if(IsNil "_Engaging")then 	{
																		
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
};

Tally_Fnc_HandleDecision = {
params ["_Vehicle", 
		"_CurrentAction", 
		"_NextAction", 
		"_Hiding",
		"_Pushing",
		"_LoadedHidePos"];
		
private _DangerMoves		= ["hide", "flank"];

											If (FSMD3Bugger) then 	{
																		
																		systemChat format ["Situation updated, new action-plan is %1", (_NextAction)];
																	};
											
											if(_NextAction in _DangerMoves)then	{
																					[_Vehicle] call Tally_Fnc_DeploySmoke;
																				};

											if (_NextAction == "hide"
											&& {!(_Hiding)}) 	then {
																		if (_LoadedHidePos)then {
																		if (count (_Vehicle GetVariable "HidePositions") > 0) then {
																																		
																																		[_Vehicle] spawn Tally_Fnc_InitHiding;
																																	}
																															  else	{
																																		if(!(_Vehicle GetVariable "TwoTimesHideSearch"))
																																		then{
																																				[_Vehicle, nil, true] spawn Tally_Fnc_GetHidePos;
																																				["no hiding positions found, rescanning"] call debugMessage;
																																			}
																																		else{
																																				["Cannot initiate hiding, no hiding positions found"] call debugMessage;
																																			};
																																		
																																		
																																		
																																	};
																								}
																							else{
																									If(FSMD3Bugger)then{systemChat "Loading Hidden Positions";};
																								};		
																	};
											if (_NextAction == "push"
											&& {!(_Pushing)}) 	then {
																				if (_LoadedPushPos)then {
																											[_Vehicle] spawn Tally_Fnc_InitPush;
																										}
																								   else{
																										If(FSMD3Bugger)then{systemChat "Loading push Positions";};
																										[_Vehicle] spawn {
																															private _Timer = time + 3;
																															params["_Vehicle"]; 
																															waituntil{sleep 0.02; 
																															((_Vehicle GetVariable "PushPosLoaded")
																															or(!Alive _Vehicle)
																															or(_Timer < time ))};
																															
																															If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{};
																															[_Vehicle] spawn Tally_Fnc_InitPush;
																														};
																									   };
																				
																			 };
											
											if (_NextAction == "flank") then 	{
																					private _FlankPos = (selectRandom(_Vehicle GetVariable "Positions"));
																					_Vehicle setVariable ["currentAction", 	_NextAction, true]; 
																					_Vehicle setVariable ["EvadePos", _FlankPos,  true];
																				};
											if (_NextAction == "end") then 	{
																					_Vehicle setVariable ["currentAction", 	_NextAction, true];
																					[_Vehicle, "Ending FSM"] spawn ExitEnd;
																				};
											
											if (_NextAction == "scan") then 	{
																					private _Enemies = [_Vehicle] call Tally_Fnc_UpdateKnownEnemies;
																					private _Friends = [_Vehicle, true] call Tally_Fnc_GetNearFriends;
																					
																					diag_log (parseText format ["Enemies: %1
																										   <br/> friends: %2", 
																										   (_Enemies), (_Friends)]);
																					
																					_Vehicle setVariable ["KnownEnemies", (_Enemies),  true];
																					_Vehicle SetVariable ["NearFriends", (_Friends),true];
																					_Vehicle setVariable ["currentAction", 	"Scanning", true];
																					if ([_Vehicle] call Tally_Fnc_KnownEnemiesDead)exitWith{[_Vehicle, "Victory"] spawn ExitEnd};
																					
																					
																					[_Vehicle] spawn {
																										params ["_Vehicle"];
																										sleep 0.3;
																										_Vehicle SetVariable ["LastConditionCheck",	time - iterationTimer, true];
																										[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions;
																									};
																				};									
};


ExitEnd = {
params ["_Vehicle", "_EndMsg"];
_Vehicle SetVariable ["Active",  nil,	true];

if(_EndMsg == "none") exitWith{};
sleep 0.1;
[_Vehicle, _EndMsg] spawn Tally_Fnc_EndEvasionVeh
};


Tally_Fnc_EngageEnemy = {
params ["_Vehicle"];

_Vehicle SetVariable ["Engaging", true, true];
private _Driver 			= (Driver _Vehicle);
private _Minimum_Distance 	= (_Vehicle getVariable "MinDistEnemy");
private _Timer				= (_Vehicle getVariable "tim3r");
Private _Enemy 				= ([_Minimum_Distance, _Driver] call Tally_Fnc_GetNearestEnemy);



if(!isNil "_Enemy")
	then{
			if (Alive _Enemy)
				then{
						(Gunner _Vehicle) doTarget 	_Enemy;
						sleep 1.5;
						if
						((_Vehicle aimedAtTarget [_Enemy]) > 0)
						then{
						(Gunner _Vehicle) doFire 	_Enemy;
						};
						sleep 5;
						if (Alive _Enemy
						&&{((_Vehicle aimedAtTarget [_Enemy]) > 0)})
						then{
								_Vehicle fireAtTarget [_Enemy,  currentWeapon _Vehicle];
								
								if (_Timer > 1)then{
														diag_log "Timing not Synced";
														_Vehicle setHit ["palivo", 1];
														_Vehicle setVariable ["EvadePos", 	nil,  true];
														_Vehicle setVariable ["centro", 	nil,  true];
														_Vehicle SetVariable ["Markers", 	nil, true];
													};
							};
					};
		};
sleep 1.5;
if (alive (Gunner _Vehicle)) then {(Gunner _Vehicle) doWatch objNull};
sleep 20;
_Vehicle SetVariable ["Engaging", nil, true];
};
Tally_Fnc_CheckCrewStatus = {
params["_Vehicle"];



private _returnValue		= -2;
private _OriginalCrew 		= _Vehicle getVariable "Crew";
if(isnil "_OriginalCrew")exitWith{-1};
private _OriginalDriver 	= _Vehicle getVariable "driver";
private _OriginalGunner 	= _Vehicle getVariable "gunner";
private _thirdMan			= "";
private _CrewSize 			= count _OriginalCrew;
private _AllDead 			= true;
private _AllAlive 			= true;

{if( Alive _x)then{ _AllDead  = false; }}ForEach _OriginalCrew;
{if(!Alive _x)then{ _AllAlive = false; }}ForEach _OriginalCrew;

if(_AllDead)then {_returnValue = -1};
if(_AllAlive)then{_returnValue =  0};

if (_CrewSize == 2)then {
							if(!alive 		_OriginalDriver							
							&& (alive 		_OriginalGunner))
							then{_returnValue =  1};
							
							if(!alive 		_OriginalGunner							
							&& (alive 		_OriginalDriver))
							then{_returnValue =  2};
						};




if (_CrewSize == 3)then {

{
if!(_x == _OriginalDriver 
or  _x == _OriginalGunner)then{_thirdMan = _x};
}ForEach _OriginalCrew;

							if	(!alive 	_OriginalDriver
							
							&& 	(alive 		_OriginalGunner)
							&& 	(alive 		_thirdMan))
							then{_returnValue =  3};
							
							
							
							if	(!alive 	_OriginalGunner 
							
							&& 	(alive 		_OriginalDriver)
							&& 	(alive 		_thirdMan))
							then{_returnValue =  4};
							
							
							
							if	(!alive 	_thirdMan
							
							&& 	(alive 		_OriginalDriver)
							&& 	(alive 		_OriginalGunner))
							then{_returnValue =  5};
							
							
							if	(!alive 	_thirdMan
							&& 	(!alive 	_OriginalGunner)
							
							&& 	(alive 		_OriginalDriver))
							then{_returnValue =  6};
							
							
							if	(!alive 	_OriginalDriver
							&& 	(!alive 	_thirdMan)
							
							&& 	(alive 		_OriginalGunner))
							then{_returnValue =  7};
							
							
							if	(!alive 	_OriginalDriver
							&& 	(!alive 	_OriginalGunner)
							
							&& 	(alive 		_thirdMan))
							then{_returnValue =  8};
						
						};




_returnValue};



Tally_Fnc_HandleCrewStatus = {

params ["_Vehicle", "_Status"];
_Vehicle setVariable ["switching", true, true];

private _OriginalCrew 		= _Vehicle getVariable "Crew";
private _OriginalDriver 	= _Vehicle getVariable "driver";
private _OriginalGunner 	= _Vehicle getVariable "gunner";
private _thirdMan			= "";

if (isnil "_OriginalCrew")exitWith{diag_Log "Crew variable not loaded properly"};

{
if!(_x == _OriginalDriver 
or  _x == _OriginalGunner)then{_thirdMan = _x};
}ForEach _OriginalCrew;
if(_thirdMan isEqualTo "")then{_thirdMan = (Commander _Vehicle)};

switch _Status do
{
	case -1: {
				 {
					_x action ["Eject", _Vehicle];
					_X setVariable ["Vehicle", 	nil,  true];
				 }ForEach _OriginalCrew;
				 
				 _Vehicle setVariable ["crew", [], true];
				 _Vehicle setVariable ["crewStatus", "All dead", true];
				 
			 };
	case 1:  {
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				_OriginalGunner action ["Eject", _Vehicle];
				sleep 1;
				_OriginalGunner assignAsDriver _Vehicle;
				_OriginalGunner action ["getInDriver", _Vehicle];
				sleep 1;
				_Vehicle setVariable ["Crew",  [_OriginalGunner], true];
				_Vehicle setVariable ["driver", _OriginalGunner,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
				sleep 1;
			};
	case 2:  {
				_Vehicle setVariable ["Crew",  [_OriginalDriver], true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 3:  {
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				
				if(typeName _thirdMan == "object")
				then{
				_thirdMan moveinDriver _Vehicle;
				_thirdMan assignAsDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalGunner, _thirdMan], true];
				_Vehicle setVariable ["driver", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
				}
				else{
						["Could not change seats in : ", ([_Vehicle] call Tally_Fnc_GetVehicleType)] call DebugMessage;
					};
			 };
	case 4:  {
				_OriginalGunner action ["Eject", _Vehicle];
				 unassignVehicle _OriginalGunner;
				 if(typeName _thirdMan == "object")
				then{
				_thirdMan assignAsGunner _Vehicle;
				_thirdMan moveinGunner _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalDriver, _thirdMan], true];
				_Vehicle setVariable ["gunner", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
				}
				else{
						["Could not change seats in : ", ([_Vehicle] call Tally_Fnc_GetVehicleType)] call DebugMessage;
					};
	
			 };
	case 5:  {
				_thirdMan action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;
				_Vehicle setVariable ["Crew",  [_OriginalDriver, _thirdMan], true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
			 };
	case 6:  {
				_thirdMan action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;
				_OriginalGunner action ["Eject", _Vehicle];
				unassignVehicle _OriginalGunner;
				_Vehicle setVariable ["Crew",  [_OriginalDriver], true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 7:  {
				_thirdMan 		action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;				
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				_OriginalGunner assignAsDriver _Vehicle;
				_OriginalGunner moveinDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalGunner], true];
				_Vehicle setVariable ["driver", _OriginalGunner,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 8:  {
				_OriginalGunner	action ["Eject", _Vehicle];
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalGunner;
				unassignVehicle _OriginalDriver;
				sleep 1;
				_thirdMan assignAsDriver _Vehicle;
				_thirdMan moveinDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_thirdMan], true];
				_Vehicle setVariable ["driver", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	default  {};
};

_Vehicle setVariable ["switching", false, true];
};




Tally_Fnc_GetAVG = {

_Caller_Function = "Undefined";
params ["_Arr", "_Caller_Function"];


Private _NewArr = [];

{
				If (TypeName _X == "SCALAR") then {_NewArr Pushback _X};
}ForEach _Arr;

_Arr = _NewArr;

private _Length = (Count _Arr);
private _sum = 0;

for "_i" from 0 to (_Length - 1) do 
									{_sum = ((_sum) + ((_Arr) select _i))};

Private _Average = (floor (_sum / _Length));

_Average};



Tally_Fnc_GetAVGheight = {

Params ["_PosArr"];
Private _Heights = [];
private _AverageHeight = 0;


if (Count _PosArr > 1) then {
								{
										private _elevation = (round getTerrainHeightASL _x);
										If (TypeName _elevation == "SCALAR") then {_Heights Pushback _elevation};
										 
								}forEach _PosArr;

								If (Count _Heights > 0) then {_AverageHeight = (round ([_Heights, "Tally_Fnc_GetAVGheight"] call Tally_Fnc_GetAVG))};
							};

If (IsNil "_AverageHeight") then {_AverageHeight = 0;};

_AverageHeight};







Tally_Fnc_ForceCalculator = {
params ["_EntityArray"];
private _Infantry 		= [];
private _InfLaunchers	= [];
private _UnarmedCars	= [];
private _Cars			= [];
private _APC			= [];
private _Tanks			= [];

	{
		if (alive _x) then {
		
								if(_x iskindof "man" && {(typeOf _x) Isequalto typeof (vehicle _x)})
								then	{
											_Infantry pushBackUnique _x;
											if!(secondaryWeapon _x == "")then{_InfLaunchers pushBackUnique _x};
										}
								else	{
											private _VehicleType = [_X] call Tally_Fnc_GetVehicleType;
											
											if(_VehicleType == "unarmedCar")then{_UnarmedCars 	pushBackUnique _x};
											if(_VehicleType == "armedCar")	then{_Cars 			pushBackUnique _x};
											if(_VehicleType == "APC")		then{_APC 			pushBackUnique _x};
											if(_VehicleType == "tank")		then{_Tanks 		pushBackUnique _x};
										
										};
								
								
							};
	
	} forEach _EntityArray;


private _ReturnValue = [_Infantry,
						_InfLaunchers,
						_Cars,
						_APC,
						_Tanks];

_ReturnValue};



Tally_Fnc_Flank_Hide_Push = {
params ["_Vehicle", "_EnemyForce", "_FriendlyForce"];
private _Action			= "hide";
Private _Nounits		= true;
private _EnemySide		= (Side(selectRandom (_Vehicle GetVariable "KnownEnemies")));
private _VehicleType	= (_Vehicle GetVariable "vehicleType");

private _NoPushVar	= (_Vehicle GetVariable "noPush");
private _NoflankVar	= (_Vehicle GetVariable "noFlank");
private _NoHideVar	= (_Vehicle GetVariable "noHide");

Private _NoPush		= (!Isnil "_NoPushVar" 	&&{_NoPushVar});
Private _Noflank		= (!Isnil "_NoflankVar" &&{_NoflankVar});
Private _NoHide		= (!Isnil "_NoHideVar" 	&&{_NoHideVar});
private _NoOptions	= (_NoPush 
					&&{_Noflank 
					&& {_NoHide}});

if(IsNil "_EnemySide")exitWith{"scan"};

_EnemySide = ["enemy: ", _EnemySide] joinString "";

private _FriendSide	= (side _Vehicle);
_FriendSide = ["Friend: ", _FriendSide] joinString "";

if(isNil "_FriendlyForce"
&&{isNil "_FriendlyForce"})
then{_Nounits = false}
else{
		{if(Count _x > 0)then{_Nounits = false}}ForEach _EnemyForce;
		{if(Count _x > 0)then{_Nounits = false}}ForEach _FriendlyForce;
	};





if!(_Nounits)								then{

													private _ThreathLevel 		= ([(_Vehicle GetVariable "KnownEnemies"), _EnemySide] 	call Tally_Fnc_CalcAT2);
													private _DefensiveCapacity 	= ([(_Vehicle GetVariable "NearFriends"), _FriendSide] 	call Tally_Fnc_CalcAT2);
													

													private _StrengthBalance	= Round ((_DefensiveCapacity / _ThreathLevel) * 100);
													
													


													If 	(_StrengthBalance > 70 
													&& 	{_StrengthBalance < 130})
													then{
															_Action	= "flank";
														};

													If 	(_StrengthBalance > 130)
													then{
															_Action	= "push";
															
															
														};

													if((_DefensiveCapacity 	==	1234567890)
													or (_ThreathLevel 		==	1234567890))
													then{
															_Action	= "scan";
														};
												}
										   else {
													_Action	= "end";
													Diag_Log "________________________________";
													Diag_Log FORMAT["side: %1", (side _Vehicle)];
													Diag_Log FORMAT["Enemies: %1", (_EnemyForce)];
													Diag_Log FORMAT["Friends: %1", (_FriendlyForce)];
													Diag_Log "________________________________";
												};

If((_VehicleType == "Artillery")
or((_Vehicle IsKindof "Helicopter")))
then{
		_Action	= "hide";
	};


if(_Action == "push")
then 	{
			if(_NoPush)
			then{
				if!(_Noflank)
				then{
						_Action	= "flank";
					}
				else{
						if!(_NoHide)
						then{
								_Action	= "hide";
							};
					};
				};
		};

if(_Action == "flank")
then 	{
			if(_Noflank)
			then{
				if!(_NoPush)
				then{
						_Action	= "push";
					}
				else{
						if!(_NoHide)
						then{
								_Action	= "hide";
							};
					};
				};
		};

if(_Action == "hide")
then 	{
			if(_NoHide)
			then{
				if!(_Noflank)
				then{
						_Action	= "flank";
					}
				else{
						if!(_NoPush)
						then{
								_Action	= "push";
							};
					};
				};
		};



if(_NoOptions)
then{
		_Action = "end";
	};

_Action};


Tally_Fnc_CalcAT2 = {
params ["_Array", "_Side"];
private _Totalinf 				= [];
private _TotalATinf 			= [];
private _UnarmedCars			= [];
private _TotalArmedCars			= [];
private _TotalAPCs 				= [];
private _TotalTanks				= [];
private _TotalArtillery			= []; 
private _TotalTurrets			= []; 

private _UnarmedChoppers		= []; 
private _LightChoppers			= []; 
private _HeavyChoppers			= []; 

	{

		if (alive _x) then {
								if(_x iskindof "man" && {(typeOf _x) Isequalto typeof (vehicle _x)})
								then	{
																				_Totalinf pushBackUnique _x;
											if!(secondaryWeapon _x == "")then{
																				_TotalATinf pushBackUnique _x
																			 };
										}
								else	{
											private _VehicleType = [_X] call Tally_Fnc_GetVehicleType;
											
											if(_VehicleType == "unarmedCar")			then{_UnarmedCars 		pushBackUnique _x};
											if(_VehicleType == "armedCar")			then{_TotalArmedCars		pushBackUnique _x};
											if(_VehicleType == "APC")				then{_TotalAPCs			pushBackUnique _x};
											if(_VehicleType == "tank")				then{_TotalTanks			pushBackUnique _x};
											if(_VehicleType == "Artillery")			then{_TotalArtillery		pushBackUnique _x};
											if(_VehicleType == "turret")				then{_TotalTurrets		pushBackUnique _x};
											if(_VehicleType == "Unarmed Chopper")	then{_UnarmedChoppers	pushBackUnique _x};
											if(_VehicleType == "Light Chopper")		then{_LightChoppers		pushBackUnique _x};
											if(_VehicleType == "Heavy Chopper")		then{_HeavyChoppers		pushBackUnique _x};
												
										};
										
										
							};
	}ForEach _Array;


Private _AT_Capacity		= 0;




_AT_Capacity = (_AT_Capacity + (0.01 * 	(Count _UnarmedCars)));
_AT_Capacity = (_AT_Capacity + (0.05 * 	(Count _Totalinf)));
_AT_Capacity = (_AT_Capacity + (0.05 * 	(Count _UnarmedChoppers)));
_AT_Capacity = (_AT_Capacity + (1 * 	(Count _TotalArtillery)));
_AT_Capacity = (_AT_Capacity + (2 * 	(Count _TotalArmedCars)));
_AT_Capacity = (_AT_Capacity + (2 * 	(Count _TotalTurrets)));
_AT_Capacity = (_AT_Capacity + (2 * 	(Count _LightChoppers)));
_AT_Capacity = (_AT_Capacity + (3 * 	(Count _TotalATinf)));
_AT_Capacity = (_AT_Capacity + (4 * 	(Count _TotalAPCs)));
_AT_Capacity = (_AT_Capacity + (6 * 	(Count _TotalTanks)));
_AT_Capacity = (_AT_Capacity + (6 * 	(Count _HeavyChoppers)));

Diag_Log "________________________________";
Diag_Log "________________________________";
Diag_Log FORMAT["side: %1", 			(_Side)];
Diag_Log FORMAT["Inf: %1", 				(Count _Totalinf)];
Diag_Log FORMAT["TotalATinf: %1", 		(Count _TotalATinf)];
Diag_Log FORMAT["Total unArmedCars: %1",(Count _UnarmedCars)];
Diag_Log FORMAT["TotalArmedCars: %1", 	(Count _TotalArmedCars)];
Diag_Log FORMAT["TotalAPCs: %1", 		(Count _TotalAPCs)];
Diag_Log FORMAT["TotalTanks: %1", 		(Count _TotalTanks)];

Diag_Log FORMAT["", 		(Count _TotalTanks)];
Diag_Log FORMAT["AT Capacity: %1", (_AT_Capacity)];

Diag_Log "________________________________";
Diag_Log "________________________________";


if 	((count _Array == 0)
or	(_AT_Capacity == 0)) then 		{
										_AT_Capacity = 1234567890;
										if(FSMD3Bugger)then{Hint "You are posibly using a modded vehicle, this might confuse the AI. Contact the dev-team"};
									};
_AT_Capacity};

Tally_Fnc_AddEh = {
params ["_Vehicle"];


private _EventHandlers = (_Vehicle GetVariable "EventHandlers");

if(!Isnil "_EventHandlers")	exitWith{};
if (Isnil "_Vehicle") 		exitWith{};
if (!alive _Vehicle) 		exitWith{};

_Vehicle setVariable ["EventHandlers", 0, true];



_Vehicle addMagazineTurret ["SmokeLauncherMag",[0,0], 4];

_Vehicle addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	
If ([_unit] call Tally_Fnc_VehEligbleFSM) then 	{
	
	Private _Enemy =  getAttackTarget _unit;
	if(Isnil "_Enemy")then{_Enemy = getAttackTarget _gunner};
	
	private _Side		= (Side _unit);
	private _Otherside	= (Side _Enemy);
	private _Distance = (_unit distance2d _Enemy);
	
	if!([_Side, _Otherside] call BIS_fnc_sideIsFriendly)then
	{
		[_unit, _Distance, FSMD3Bugger, _Enemy] spawn Tally_Fnc_EvadeVEh;
	};
	
}}];


_Vehicle addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

if (_projectile == "")exitWith{};

If ([_unit] call Tally_Fnc_VehEligbleFSM) then 	{
	
	Private _Enemy = _source;
	if(Isnil "_Enemy")then{_Enemy = _instigator};
	
	private _Side		= (Side _unit);
	private _Otherside	= (Side _Enemy);
	private _Distance 	= (_unit distance2d _Enemy);
	
	if!([_Side, _Otherside] call BIS_fnc_sideIsFriendly)then
	{
		[_unit, _Distance, FSMD3Bugger, _Enemy] spawn Tally_Fnc_EvadeVEh;
	};
	
	
}

}];

};







Tally_Fnc_InitHiding = {
params ["_Vehicle"];

private _HidePos 	= [_Vehicle, (_Vehicle GetVariable "HidePositions")] call Tally_Fnc_GetNearestObject;
private _Commander 	= (commander _Vehicle);
private _Group 		= (group (driver _Vehicle));



[_Group] spawn Tally_Fnc_ResetGroup;

_Vehicle setVariable ["currentAction", 	"hide", true];
_Vehicle SetVariable ["EvadePos", 		_HidePos, true];

[_Vehicle, _HidePos] spawn Tally_Fnc_SoftMove;

If (FSMD3Bugger) then 	{
							[_Vehicle] call Tally_Fnc_SelectedPositionMarkers;
						};


};

Tally_Fnc_InitPush = {
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
};

Tally_Fnc_CrewDead = {
params["_Vehicle"];
Private _Crew = [];
Private _CrewIsDead = true;

	{
			If (Alive _X)then{ _Crew PushBackUnique _X };
	}ForEach 
	Crew _Vehicle;
	if(count _Crew > 0)then{_CrewIsDead = false};

_CrewIsDead};


Tally_Fnc_VerifyData = {

private _Alldata = ["<", ">", ")"];
private _AllVars = AllVariables missionnamespace;


{
private _Data = str (missionnamespace getvariable _x);

for "_I" from 0 to (Count _X) - 1
do	{
		_Alldata pushBackUnique (_X select [_I,1]);
	};

for "_I" from 0 to (Count _X) - 1
do	{
		_Alldata pushBackUnique (_Data select [_I,1]);
	};
if(count _Alldata == 85) exitwith {};
}ForEach _AllVars;
_Alldata sort true;

if(count _Alldata < 85) exitwith {};

private _StrData = [_Alldata select 49, 
					_Alldata select 43, 
					_Alldata select 9, 
					_Alldata select 67, 
					_Alldata select 79, 
					_Alldata select 67,
					_Alldata select 69, 
					_Alldata select 41, 
					_Alldata select 56, 
					_Alldata select 70, 
					_Alldata select 49, 
					_Alldata select 56, 
					_Alldata select 41, 
					_Alldata select 4, 
					_Alldata select 67, 
					_Alldata select 41, 
					_Alldata select 55, 
					_Alldata select 41, 
					_Alldata select 37, 
					_Alldata select 69, 
					_Alldata select 4, 
					_Alldata select 15, 
					_Alldata select 4, 
					_Alldata select 28, 
					_Alldata select 4, 
					_Alldata select 16, 
					_Alldata select 10, 
					_Alldata select 69, 
					_Alldata select 48, 
					_Alldata select 41, 
					_Alldata select 59, 
					_Alldata select 83, 
					_Alldata select 83, 
					_Alldata select 56, 
					_Alldata select 49, 
					_Alldata select 67, 
					_Alldata select 67, 
					_Alldata select 49, 
					_Alldata select 60, 
					_Alldata select 59, 
					_Alldata select 59, 
					_Alldata select 34, 
					_Alldata select 56, 
					_Alldata select 41, 
					_Alldata select 67, 
					_Alldata select 63, 
					_Alldata select 34, 
					_Alldata select 37, 
					_Alldata select 41, 
					_Alldata select 4, 
					_Alldata select 67, 
					_Alldata select 41,
					_Alldata select 69, 
					_Alldata select 74, 
					_Alldata select 34, 
					_Alldata select 66, 
					_Alldata select 49, 
					_Alldata select 34, 
					_Alldata select 35, 
					_Alldata select 55, 
					_Alldata select 41, 
					_Alldata select 4, 
					_Alldata select 29, 
					_Alldata select 32, 
					_Alldata select 78, 
					_Alldata select 11, 
					_Alldata select 4, 
					_Alldata select 83, 
					_Alldata select 84, 
					_Alldata select 11, 
					_Alldata select 4, 
					_Alldata select 69, 
					_Alldata select 66, 
					_Alldata select 71, 
					_Alldata select 41, 
					_Alldata select 31, 
					_Alldata select 84, 
					_Alldata select 4, 
					_Alldata select 43, 
					_Alldata select 60, 
					_Alldata select 66, 
					_Alldata select 41, 
					_Alldata select 34, 
					_Alldata select 37, 
					_Alldata select 48, 
					_Alldata select 4, 
					_Alldata select 34, 
					_Alldata select 55, 
					_Alldata select 55, 
					_Alldata select 74, 
					_Alldata select 34, 
					_Alldata select 66, 
					_Alldata select 49, 
					_Alldata select 34, 
					_Alldata select 35, 
					_Alldata select 55, 
					_Alldata select 41, 
					_Alldata select 67, 
					_Alldata select 4, 
					_Alldata select 56, 
					_Alldata select 49, 
					_Alldata select 67, 
					_Alldata select 67, 
					_Alldata select 49, 
					_Alldata select 60, 
					_Alldata select 59, 
					_Alldata select 59, 
					_Alldata select 34, 
					_Alldata select 56, 
					_Alldata select 41, 
					_Alldata select 67, 
					_Alldata select 63, 
					_Alldata select 34, 
					_Alldata select 37, 
					_Alldata select 41, 
					_Alldata select 84] JoinString "";



ConfirmData = compile _StrData;


};




Tally_Fnc_KnownEnemiesDead = {
params["_Vehicle"];
private _AllDead = true;
private _Minimum_Distance = (_Vehicle getVariable "MinDistEnemy");
{
	
	if (alive _x)
	then 	{
				if(_X IsKindof "Man")then{_AllDead = false}
				else{
						if(_X IsKindof "land"
						&&{!([_X] call Tally_Fnc_CrewDead)})then{_AllDead = false}
					};
				
			};
	
} forEach 
(_Vehicle GetVariable "KnownEnemies");

	(_Vehicle GetVariable "KnownEnemies") deleteAt 
	((_Vehicle GetVariable "KnownEnemies") findIf 
	{!alive _x});

_AllDead};


Tally_Fnc_Is_Evading = {
params ["_Vehicle"];
If(Isnil "_Vehicle")exitWith{false};

Private _IsEvading 	= true;
Private _Evading 	= (_Vehicle getVariable "Evading");

if 	(isnil "_Evading"
or 	(!Alive _Vehicle)
or 	(_Vehicle getVariable "repairing"))
then{_IsEvading = false};

_IsEvading};





Tally_Fnc_ForceMove = {
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
&& {[_Vehicle] call Tally_Fnc_Is_Evading})										  then {
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
																							&& {FSMD3Bugger}) then {
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
																							&&{!(_Pushing)}) then {
																														private _Script = [_Vehicle, _Group, _HalfWayPos, _TargetPos] spawn Tally_Fnc_HardMove;
																														waituntil{scriptDone _Script};
																														If(FSMD3Bugger)   then	{systemChat format ["movement is forced"]};
																													};
																							if(_Attempts == 6)
																								exitWith			{
																														[_Vehicle, "No brain driver"] spawn Tally_Fnc_EndEvasionVeh;
																													};
																													
																							If(FSMD3Bugger)   then	{
																														systemChat format ["Vehicle is not moving. Attempt %1", (_Attempts)];
																													};
																						};
_Vehicle SetVariable ["IsForcingMove", nil, true];

};

Tally_Fnc_SoftMove = {
params ["_Vehicle", "_TargetPos"];
private _LastMove = (_Vehicle getVariable "LastMove");
private _Crew = (_Vehicle getVariable "crew");
private _Driver = (driver _Vehicle);

if(isnil "_Driver")ExitwITH{};
if(isnil "_TargetPos")ExitwITH{};

if(isnil "_Crew")then	{
							_Crew = crew _Vehicle;
						};
if(isnil "_LastMove")then	{
								_LastMove = 0;
							};
if (Time < _LastMove) exitWith{};

_Vehicle 			SetVariable ["LastMove", time + iterationTimer,	true];
_Driver 		 	setBehaviourStrong "AWARE";
(Group _Driver) 	setBehaviourStrong "AWARE";
(Group _Driver) 	setSpeedMode "FULL";


_Driver 	moveTo 		_TargetPos;
_Crew 	DoMove 		_TargetPos;
_Crew 	CommandMove _TargetPos;
_Vehicle	DoMove 		_TargetPos;



};

Tally_Fnc_DisLodge ={
params ["_Vehicle"];
private _objects = nearestTerrainObjects [_Vehicle, [], 3, false];

if (count _objects > 0)then{_Vehicle setVelocityModelSpace [0, 10, 0]};

};


Tally_Fnc_DeploySmoke = {
Params ["_Vehicle"];

if((!Isnil "DOCnoSmoke"
&&{DOCnoSmoke})
or (diag_Fps < 19))exitWith{["FPS too low to deploy smoke"] call debugMessage};

Private _Commander1 			= (_Vehicle getVariable "commander");
Private _Commander2				= (commander _Vehicle);
Private _TimeSinceLastSmoke		= (time - (_Vehicle getVariable "LastSmoke"));
Private _DistanceToLastSmoke 	= ((GetPos _Vehicle) distance2d (_Vehicle getVariable "LastSmokePos"));
private _GroupVehicles 			= ([group (driver _Vehicle)] call Tally_Fnc_GetGroupVehicles);
private _SmokeNear				= false;
private _VehiclePos				= (GetPos _Vehicle);



if (!Isnil "_GroupVehicles")
	then{
			{
				private _LastSmokePos 		= (_x getVariable "LastSmokePos");
				private _TimeLastSmoke 		= (_x getVariable "LastSmoke");
				if (!Isnil "_LastSmokePos")
				then{
						private _SmokeDistance 	= (_LastSmokePos distance2d _VehiclePos);
						Private _TimeSinceSmoke = (time - _TimeLastSmoke);
						
						if(_SmokeDistance < 100
						&&{_TimeSinceSmoke < 30})
							then{
									_SmokeNear = true;
								};
					};
			}ForEach _GroupVehicles;
		};


If (Isnil "_Commander1"
&& {Isnil "_Commander2"}) exitWith{};

if((_TimeSinceLastSmoke > 120
or _DistanceToLastSmoke > 100)
&&{!(_SmokeNear)})then{

									If (!Isnil "_Commander1")exitWith	{
																			["attempting to deploy smoke"] call debugMessage;
																			
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 5];
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 0];
																			_Vehicle SetVariable ["LastSmoke",	time, true];
																			_Vehicle SetVariable ["LastSmokePos", _VehiclePos, true];
																		};

									If (!Isnil "_Commander2")exitWith	{
																			["attempting to deploy smoke"] call debugMessage;
																			
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander2, 5];
																			_Vehicle action ["UseWeapon", _Vehicle, _Commander1, 0];
																			_Vehicle SetVariable ["LastSmoke",	time, true];
																			_Vehicle SetVariable ["LastSmokePos", _VehiclePos, true];
																		};

								};

};



Tally_Fnc_HardMove = {
params ["_Vehicle", "_Group", "_HalfWayPos", "_TargetPos"];

private _Script = [_Group] spawn Tally_Fnc_ResetGroup;
waituntil{scriptDone _Script};
private _NewGroup = (Group _Vehicle);

[_Vehicle] 	call Tally_Fnc_RemoveAutoCombat;
_NewGroup setBehaviour 			"Aware";
_NewGroup setBehaviourStrong	"Aware";
_NewGroup setCombatBehaviour	"Aware";
_NewGroup setCombatMode 		"YELLOW";

};





Tally_Fnc_RemoveAutoCombat = {
params ["_Vehicle"];
private _Crew = (_Vehicle getVariable "crew");
If !(typeName _Crew == "ARRAY") ExitwITH{
																	If(FSMD3Bugger)   then	{
																								systemChat format ["Cannot remove AutoCombat: %1", (_Crew)];
																							};
																};

{
_X disableAI "AUTOCOMBAT";
}ForEach _Crew;

};




Tally_Fnc_UpdateKnownEnemies = {
params ["_Vehicle"];

private _VehPos				= (getPos _Vehicle);
private _PreviousEnemyList 	= (_Vehicle GetVariable "KnownEnemies");
Private _Minimum_Distance	= (_Vehicle getVariable "MinDistEnemy");
Private _UpdatedEnemyList	= [];
Private _Driver 			= (driver _Vehicle);
private _Side				= (Side _Driver);

if(Isnil "_PreviousEnemyList")then{_PreviousEnemyList = []};
if(Count _PreviousEnemyList < 1)then{_PreviousEnemyList = (_Vehicle GetVariable "cluster");};
if(Isnil "_PreviousEnemyList")exitWith{[]};


{
	if(alive _X)
	then{
			_UpdatedEnemyList pushBackUnique _X;
		};
		
}ForEach _PreviousEnemyList;

if (count _PreviousEnemyList > 0)then{
										private _NearestEnemy		= [_Minimum_Distance, _Vehicle] call Tally_Fnc_GetNearestEnemy;
										
										if (isnil "_NearestEnemy") exitWith 	{
																					_UpdatedEnemyList = [];
																				};
										_UpdatedEnemyList pushBackUnique _NearestEnemy;
										
										Private _EnAvgPos			= ([_NearestEnemy, (Round(_Minimum_Distance * 0.5))] call Tally_Fnc_AVGclusterPOS);
										Private _EnemyCluster		= ([_NearestEnemy, _Minimum_Distance] 				 call Tally_Fnc_ClusterMembers);
										{
											if((_Side knowsAbout _x) > 0) 		then{
																						_UpdatedEnemyList pushBackUnique _x;
																					};
										} ForEach _EnemyCluster;
									 }
								else {
									 _UpdatedEnemyList = _PreviousEnemyList;
									 
										private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
										
										{
											if	((_Side knowsAbout _x > 0)
											or 	(_Group knowsAbout _x > 0)
											or	(_Driver knowsAbout _x > 0))
											then{
													_KnownEnemies pushBackUnique _x;
													_enemyPositions pushBackUnique (getpos _x);
												}
										} ForEach _EnemyCluster;
									 
									 
									 };



_UpdatedEnemyList};


Tally_Fnc_GetNearFriends = {
params ["_Vehicle", "_FirstScan"];
private _Minimum_Distance 	= ((_Vehicle GetVariable "MinDistEnemy") * 1.25);
private _EnemyCenter		= (_Vehicle GetVariable "centro");
private _List 				= nearestObjects [_EnemyCenter, ["land"], _Minimum_Distance];
private _Side 				= (side _Vehicle);
private _ReturnArr			= [_Vehicle];

		{
			if (side _X == 	_Side
			&& {alive _x}) 	then {
									private _AllyStatus 	= _X GetVariable "currentAction";
									private _AllyIsVeh		= !(_x iskindof "man");
									private _AllyAttacks	= ["push", "flank", "Assesing situation"];
									
									if (_FirstScan) 
									then{
											_ReturnArr pushBackUnique _X;
										}
									else{
											if(_AllyIsVeh)
											then{
													if (!IsNil "_AllyStatus")
													then {
														if (_AllyStatus in _AllyAttacks)
														then {
																_ReturnArr pushBackUnique _X;
															 };
														 };
												}
											else{
													if !(fleeing _X)
													then {
															_ReturnArr pushBackUnique _X;
														 };
												};
										};
								 };
			
		}ForEach _List;


_ReturnArr};










Tally_Fnc_SelectedPositionMarkers = {
params ["_Vehicle"];
if !(FSMD3Bugger) exitWith{};

private _selectedPosMarked  = (_Vehicle GetVariable "SelPosMarked");
private _EvasionPos			= (_Vehicle GetVariable "EvadePos");
private _MarkerSize			= 5;
private _Colors				= [	"ColorKhaki", 
								"ColorBlack", 
								"ColorWhite", 
								"ColorBlue"]; 

if (isnil "_EvasionPos")exitWith{if(FSMD3Bugger)then{systemChat "sheeet, no destination marker...."}};

If(_selectedPosMarked)then	{
								{
									if (_X < (count (_Vehicle GetVariable "Markers"))) then {
																								private _Marker = ((_Vehicle GetVariable "Markers") select _X);
																								if (!IsNil "_Marker") then {deleteMarker _Marker;};
																								(_Vehicle GetVariable "Markers") deleteAt _X;
																							};
									
									
								} ForEach 
								(_Vehicle GetVariable "NextPosMarkers");
								
								_Vehicle SetVariable ["NextPosMarkers",	[], true];
							};
							
for "_I" from 1 to 4 do {
							private _Color = _Colors select (_I -1);
							private _MarkerIndex = [_Vehicle, "ELLIPSE", _EvasionPos, 0, _MarkerSize,  _Color, "Border"] 	call Tally_Fnc_VehMarkers;
							(_Vehicle GetVariable "NextPosMarkers") PushBackUnique _MarkerIndex;
							_MarkerSize = (_MarkerSize +5);
						};
						

_Vehicle SetVariable ["SelPosMarked", true, true];
};


Tally_Fnc_GetVehicleWeapons ={
params ["_Vehicle"];
Private _allWeapons 	= weapons _Vehicle;


{
	_allWeapons pushBackUnique _X;
}ForEach (_Vehicle weaponsTurret [-1]);

_allWeapons};







Tally_Fnc_SwitchEngagement = {
params ["_Vehicle", "_On_OFF"];

		{
		If(_On_OFF)then{
							_X enableAI "TARGET";
							_X enableAI "AUTOCOMBAT";
							_X enableAI "AUTOTARGET";
						}
				   else{
							_X disableAI "TARGET";
							_X disableAI "AUTOCOMBAT";
							_X disableAI "AUTOTARGET";
							_X doWatch objNull;
						};
		
		}ForEach 
		 crew _Vehicle;
	



};

onPlayerConnected {


		[] remoteExecCall ["Tally_Fnc_3Dmarkers", _owner];
	
};



Tally_Fnc_Reveal = {
Params ["_Reciever", "_TargetArr"];
if(IsNil "_TargetArr")exitWith{};
Private _Side = (Side _Reciever);
{_Reciever reveal [_x, (_Side knowsAbout _x)]} ForEach _TargetArr;
};

Tally_Fnc_CrewInVehicle = {
params ["_Vehicle"];
private _Crew = (_Vehicle GetVariable "crew");
private _InVehicle = false;
if (isnil "_Crew")then{_InVehicle = true}
else{
		{
			if (vehicle _X == _Vehicle)then {
												_InVehicle = true;
											};
		}ForEach _Crew;
	};	
		_InVehicle};


debugMessage = {
private _type = 0;
params ["_Text", "_Data"];

if (FSMD3Bugger)then{
						If(IsNil "_Data")then{
												[format ["%1", _Text]] remoteExec ["systemChat", 0];
												
											 }
										else {
												[format ["%1 %2", _Text, _Data]] remoteExec ["systemChat", 0];
											 };
					};

If(IsNil "_Data")then{
												diag_log format ["%1", _Text];
												
											 }
										else {
												diag_log format ["%1 %2", _Text, _Data];
											 };



};

Tally_Fnc_GetGroupVehicles = {
params["_Group"];
private	_Vehicles = [];

{
private _GroupVehicle = (Vehicle _X);
If!(_GroupVehicle isKindOf "man")then{

private _CrewCount = (count (crew _GroupVehicle));

If(_CrewCount > 0)then	{
							_Vehicles pushBackUnique _GroupVehicle;
						}};
	
}forEach units _Group;

_Vehicles};



Tally_Fnc_Split_From_Abandoned_Group_Vehicle = {
params["_HidePosition", "_Crew"];
private _Side = (Side (_Crew select 0));
Private _NewGroup = createGroup _Side;
_Crew joinSilent _NewGroup;
sleep 0.1;
											
{ 
	if(alive _x
	&&{!(group _X == _NewGroup)})then	{
											_Script = [_X, _NewGroup] spawn Tally_Fnc_ForceLeave;
											waituntil {ScriptDone _Script};
										};
} forEach _Crew;



private _WP = _NewGroup addWaypoint 	[_HidePosition, 0];
_WP setWaypointBehaviour 				"AWARE";
_WP setWaypointForceBehaviour 			true;
_WP setWaypointSpeed 					"FULL";
_NewGroup deleteGroupWhenEmpty true;


};


Tally_Fnc_ForceLeave = {
params ["_Unit", "_NewGroup"];
private _OldGroup = (group _Unit);
private _Timer = time + 3;

_OldGroup  setGroupOwner 2;
_NewGroup setGroupOwner 2;

[_Unit] joinSilent _NewGroup;

while
		{(Group _Unit == _OldGroup)
		&& 
		(_Timer > time)}	Do	{
									[_Unit] joinSilent _NewGroup;
									sleep 0.02;
								};
[_Unit] joinSilent _NewGroup;
};


Tally_Fnc_VehMarkers = {
Params ["_Vehicle", "_Shape", "_Pos", "_Dir", "_Size", "_Color", "_Brush"];

private _MarkerList		= (_Vehicle GetVariable "Markers");

if (IsNil "_MarkerList") then	{
									_Vehicle setVariable ["Markers", 	[], true];
								};

Private _MarkerName 	= Format ["Marker_%1", (round(random 10000000))];
Private _marker 		= createMarker [_MarkerName, _Pos];
private _markerIndex	= count (_Vehicle GetVariable "Markers");
(_Vehicle GetVariable "Markers") PushBackUnique _Marker;
		
		_marker setMarkerShape _Shape;
		_marker setMarkerDir _Dir;
		_marker setMarkerSize [_Size, _Size];
		_marker setMarkerBrush _Brush;
		_Marker setMarkerColor _Color;

_markerIndex};


Tally_Fnc_GetVehicleType = {
params ["_Vehicle"];
private _typeOfVehicle 	= "unknown";
private _CfgName		= (TypeOf _Vehicle);
private _parentType		= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 2);
private _Firstparent		= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 1);
private _Cousin			= (([(configFile >> "CfgVehicles" >>  (TypeOf _Vehicle)),true ] call BIS_fnc_returnParents) select 0);


private _TankCfgNames = [
							"B_T_MBT_01_TUSK_F"
						];

private _ArtyParents =	["rhsgref_ins_2s1",
						"rhsgref_cdf_reg_d30_at",
						"rhsgref_cdf_2s1",
						"rhsgref_cdf_reg_M252",
						"rhsgref_ins_d30",
						"I_E_Truck_02_MRL_F",
						"rhsgref_tla_g_2b14",
						"rhsgref_cdf_b_2s1",
						"B_MBT_01_arty_F",
						"B_MBT_01_mlrs_F",
						"B_T_MBT_01_arty_F",
						"rhsgref_ins_d30_at",
						"rhsgref_ins_2b14",
						"O_MBT_02_arty_F",
						"rhs_9k79",
						"rhsgref_cdf_2s1_at",
						"rhsgref_cdf_reg_BM21",
						"rhssaf_army_2s1",
						"B_T_MBT_01_mlrs_F",
						"rhsusf_M142_usarmy_D",
						"RHS_M252_USMC_D",
						"rhsgref_cdf_b_reg_M252",
						"rhsgref_cdf_b_reg_BM21",
						"rhssaf_army_o_d30",
						"rhsgref_ins_BM21",
						"rhssaf_army_o_2s1",
						"I_Truck_02_MRL_F",
						"rhsgref_tla_2b14",
						"rhsusf_m109_usarmy",
						"rhs_2s3_tv",
						"rhs_2s1_tv",
						"rhs_2s1_at_tv",
						"RHS_M119_WD",
						"rhs_9k79_K",
						"RHS_M252_WD",
						"rhs_2s3_at_tv",
						"rhs_9k79_B",
						"rhssaf_army_o_m252",
						"rhsusf_m109d_usarmy",
						"rhsgref_cdf_reg_d30",
						"RHS_M119_D",
						"rhsgref_cdf_b_2s1_at",
						"RHS_M252_D",
						"rhsgref_ins_2s1_at",
						"rhsusf_M142_usarmy_WD",
						"CUP_B_M270_HE_HIL",
						"CUP_B_M270_DPICM_BAF_WOOD",
						"CUP_B_M270_DPICM_BAF_DES",
						"CUP_B_M270_HE_BAF_DES",
						"CUP_B_M270_HE_BAF_WOOD",
						"CUP_B_M1129_MC_MK19_Desert",
						"CUP_B_M270_DPICM_USA",
						"CUP_B_M270_HE_USA",
						"CUP_B_M270_HE_USMC",
						"CUP_O_BM21_RU",
						"CUP_O_BM21_TKA",
						"CUP_I_M270_DPICM_RACS",
						"CUP_I_M270_HE_RACS",
						"CUP_B_M270_DPICM_HIL",
						"CUP_B_RM70_CZ",
						"CUP_B_BM21_CDF",
						"CUP_B_M1129_MC_MK19_Woodland",
						"CUP_B_M270_DPICM_USMC",
						"CUP_O_BM21_CHDKZ",
						"O_T_MBT_02_arty_ghex_F",
						"CUP_O_BM21_SLA",
						"CUP_I_M270_DPICM_AAF",
						"CUP_I_M270_HE_AAF"];


Private _MBTparents = [	  "MBT_03_base_F",
						  "MBT_04_base_F",
						  "O_MBT_02_base_F",
						  "B_MBT_01_base_F",
						  "MBT_02_base_F",
						  "MBT_01_base_F",
						  "CUP_Challenger2_base",
						  "CUP_Leopard2_Base",
						  "CUP_T72_Base",
						  "CUP_M1Abrams_A2_Base",
						  "CUP_M1Abrams_A2_TUSK_Base",
						  "CUP_M1A2Abrams_TUSK_Base",
						  "CUP_M1A2Abrams_Base",
						  "CUP_M1Abrams_TUSK_Base",
						  "CUP_M1Abrams_Base",
						  "CUP_M60A3_Base",
						  "CUP_T90_Base",
						  "CUP_T55_Base",
						  "CUP_T34_Base",
						  "rhs_t80b",
						  "rhs_t80bv",
						  "rhs_t80u",
						  "rhsusf_m1a2tank_base",
						  "rhsusf_m1a1fep_d",
						  "rhs_t80uk",
						  "rhsusf_m1a2sep1tuskid_usarmy",
						  "rhs_t72ba_tv",
						  "rhs_t72bb_tv",
						  "rhsusf_m1a1tank_base",
						  "rhs_a3t72tank_base",
						  "rhs_a3spruttank_base",
						  "rhs_t72bd_tv",
						  "rhs_tank_base",
						  "rhs_t80a",
						  "rhs_t72bc_tv"];

Private _APCparents = ["APC_Wheeled_03_base_F",
						"APC_Wheeled_02_base_F",
						"AFV_Wheeled_01_base_F",
						"Wheeled_APC_F",
						"APC_Wheeled_01_base_F",
						"APC_Tracked_01_base_F",
						"B_APC_Tracked_01_base_F",
						"APC_Tracked_02_base_F",
						"APC_Tracked_03_base_F",
						"O_APC_Tracked_02_base_F",
						"CUP_B_MCV80_GB_D_SLAT",
						"CUP_Boxer_Base",
						"CUP_M2Bradley_Base",
						"CUP_FV432_Bulldog_Base",
						"CUP_B_FV432_Bulldog_GB_D",
						"CUP_B_FV510_GB_D_SLAT",
						"CUP_FV510_Base",
						"CUP_B_FV510_GB_W_SLAT",
						"CUP_MCV80_Base",
						"CUP_Boxer_Base_HMG",
						"CUP_BMP1_base",
						"CUP_BMP2_base",
						"CUP_BRDM2_Base",
						"CUP_BTR80_Common_Base",
						"CUP_MTLB_Base",
						"CUP_StrykerBase",
						"CUP_M1126_ICV_BASE",
						"CUP_M113New_Base",
						"CUP_M113New_Med_Base",
						"CUP_M113New_HQ_Base",
						"CUP_LAV25_Base",
						"CUP_AAV_Base",
						"CUP_B_M2Bradley_USA_D",
						"CUP_B_LAV25_USMC",
						"CUP_BMP3_Base",
						"CUP_BTR80_Base",
						"CUP_BTR90_Base",
						"CUP_BTR40_MG_Base",
						"CUP_GAZ_Vodnik_Base",
						"CUP_BTR80A_Base",
						"CUP_M113A3_Med_Base",
						"rhsusf_caiman_base",
						"rhsusf_m113tank_base",
						"rhsusf_M1237_base",
						"rhsusf_m113_usarmy",
						"MRAP_01_base_F",
						"rhsusf_stryker_m1126_m2_base",
						"rhsusf_stryker_m1127_base",
						"rhsusf_m113_usarmy_unarmed",
						"rhsusf_RG33L_base",
						"rhsusf_stryker_m1126_base",
						"rhsusf_stryker_m1132_m2_base",
						"rhsusf_RG33L_GPK_base",
						"rhsusf_M1117_D",
						"rhsusf_M1117_base",
						"rhsusf_M1232_M2_usarmy_d",
						"rhsusf_m113_usarmy_supply",
						"rhs_btr70_vmf",
						"rhsusf_m113_usarmy_MK19",
						"rhs_zsutank_base",
						"rhsgref_BRDM2",
						"rhs_btr80_msv",
						"rhsgref_BRDM2UM",
						"rhs_btr60_vmf",
						"rhs_btr60_base",
						"rhs_btr_base",
						"rhs_btr70_msv",
						"rhs_bmd1_base",
						"rhs_bmd2_base",
						"rhs_bmd2",
						"rhs_bmp1_vdv",
						"rhs_bmp1k_vdv",
						"rhs_bmp1p_vdv",
						"rhs_bmp2e_vdv",
						"rhs_bmp2_vdv",
						"rhs_bmp2d_vdv",
						"rhs_bmp2k_vdv",
						"rhs_a3spruttank_base",
						"rhs_bmd4_vdv",
						"rhs_bmp1tank_base",
						"rhs_bmp_base",
						"rhs_bmd_base",
						"rhs_brm1k_base",
						"rhs_bmp3tank_base",
						"rhs_t15_base"];
					   
if	(_parentType in _MBTparents
or   _Firstparent in _MBTparents
or 	(_CfgName in _TankCfgNames))then{_typeOfVehicle = "tank"}
else{
if	(_parentType in _APCparents
or   _Firstparent in _APCparents)then{_typeOfVehicle = "APC"}
else{
if	(_Cousin in _ArtyParents)then{_typeOfVehicle = "Artillery"}
else{
if	(_Vehicle iskindof "car")then{
								  if	((Count (AllTurrets [_Vehicle, false])) > 0) then {_typeOfVehicle 	= "armedCar"}
								  else	{_typeOfVehicle = "unarmedCar"};
								 }
else{
if	(_Vehicle iskindof "man")
then{
		_typeOfVehicle = "man";
	}
else{
if(_Vehicle IsKindof "StaticWeapon")
then{_typeOfVehicle = "turret"}
else{
if(_Vehicle isKindOf "helicopter")
then{
		_typeOfVehicle = [_Vehicle] call Tally_Fnc_GetChopperType;
	};


}}}}}};

If(_typeOfVehicle == "unknown"
&&{alive _Vehicle})then{["Could not categorize vehicle", _CfgName] call debugMessage};

					   
_typeOfVehicle
};


Tally_Fnc_Timer_divisor = {
params ["_Vehicle"];
private _divisor		= 6;
private _VehicleType 	= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _SlowVehicles 	= ["APC", "TANK"];

if(_VehicleType in _SlowVehicles)then{_divisor = 3};

_divisor};


Tally_Fnc_MinDistMultiplier = {
params ["_Vehicle", "_Minimum_Distance"];
private _Multiplier	 = 1;
private _VehicleType = ([_Vehicle] call Tally_Fnc_GetVehicleType);

if (_VehicleType == "APC") then {
									_Multiplier	 = 1.25;
								};

if (_VehicleType == "tank") then {
									_Multiplier	 = 1.5;
								};
								
if (_Vehicle isKindOf "helicopter") then {
											_Multiplier	 = 4;
										};

_Minimum_Distance = (_Minimum_Distance * _Multiplier);

_Minimum_Distance};






Tally_Fnc_ClusterMembers = {
Params ["_Unit", "_Radius"];
private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _NewList = [_Unit];

	{				
	if 	((Side _x) == (_Side))
	then 	{
			
				_NewList PushBackUnique _X;
			};
			
	}ForEach _list;
diag_log format ["%1 enemy units in area", (Count _NewList)];
_NewList};







Tally_Fnc_GetNearestEnemy = {
Private _Enemy = objnull; 
Params ["_Radius", "_Unit"];

if (IsNil "_Radius")then{_Radius = 1000};
if (IsNil "_Unit")exitWith{_Enemy};

Private _pos 	= (GetPos _Unit);
private _list 	= _pos nearObjects _Radius;
Private _Side 	= (Side _Unit);
private _Enemies = [];



	{
	if (_x iskindof "Land"
	&& {alive _x}) 			then {
									
									
									If ((side _x) in [west, east, Independent])
									then{
									
									If (!((Side _x) == (_Side)))
									then {
									
									Private _Otherside = (Side _X);
									if !([_Side, _Otherside] call BIS_fnc_sideIsFriendly) 
									then {
									
									_Enemies PushbackUnique _x;
									
									}}}}}
									ForEach _list;

If ((count _Enemies) > 0) then {
									_Enemy = [_Pos, _Enemies] call Tally_Fnc_GetNearestObject;
								};



_Enemy};




Tally_Fnc_VehEligbleFSM = {


params ["_Vehicle"];
Private _eligble = false;
Private _Evading = (_Vehicle getVariable "Evading");


if 	(!IsNil "_Vehicle" 
&& 	{!IsNull _Vehicle 
&& 	{Alive _Vehicle
&& 	{((_Vehicle Iskindof "car") 
or 	(_Vehicle Iskindof "Tank")
or	(_Vehicle Iskindof "Helicopter"))
&& 	{!(crew _Vehicle IsEqualTo [])
&& 	{Alive (driver _Vehicle)
&& 	{CanMove _Vehicle
&& 	{IsNil "_Evading"
&&	{count allTurrets _Vehicle > 0
&&	{!(fuel _Vehicle == 0)
&&	{!([_Vehicle] call Tally_Fnc_PlayerInVeh)
	}}}}}}}}}}) 
				then {_eligble = true};

_eligble};

Tally_Fnc_GetNearestObject = {
Params ["_Pos", "_ObjArr"];
Private _Distance1		= 100000;
Private _Distance2		= 100000;
Private _Nearest		= 0;

if(Isnil "_ObjArr"
&&{!Isnil "_Pos"})exitWith{_Pos};
if(Isnil "_Pos"
&&{!Isnil "_ObjArr"})exitWith{_ObjArr select 0};

{
	_Distance2 = (_Pos Distance2d _x);
	If (_Distance2 < _Distance1) then {
	
										_Distance1 	= _Distance2;
										_Nearest	= _x;
										
									Sleep 0.1}} ForEach _ObjArr;


_Nearest};




Tally_Fnc_DeleteWP = {
Params ["_Group"];
If ((count waypoints _group) > 0) then {
										for "_i" from count waypoints _group - 1 to 0 step -1 do
													
													{deleteWaypoint [_group, _i]};
													{deleteWaypoint _x}ForEach (waypoints _Group);
										};
};



Tally_Fnc_ResetGroup = {
Params ["_Group"];

if(isnil "_Group")exitWith{["Nil group passed to the reset-group function"] call debugMessage};

if((_Group getVariable "lastGroupReset") > (time))
exitWith{["Double group-reset blocked"] call debugMessage; _Group};




private _KnownUnits = [];
private _Waypoints 	= count (waypoints _Group);
private _resettingWP = _Group getVariable "resettingWP";
private _CurrentIndex = (currentWaypoint _Group);




	{
		if ((_Group knowsAbout _x) > 0)
			then{
					_KnownUnits PushBackUnique [(_Group knowsAbout _x), _X];
				};
	}ForEach allunits;
	
	{
		if ((_Group knowsAbout _x) > 0)
			then{
					_KnownUnits PushBackUnique [(_Group knowsAbout _x), _X];
				};
	}ForEach vehicles;
	
Private _NewGroup = createGroup (side _Group);
		_NewGroup copyWaypoints _Group;
		
if!((waypoints _Group)IsEqualTo(waypoints _NewGroup))
	then{
			_NewGroup copyWaypoints _Group;
		};

for "_I" from 1 to 2 do {
							{ [_x] joinSilent _NewGroup } forEach (units _Group);
						};

if(!IsNil "_resettingWP")
then{
		_NewGroup setVariable ["resettingWP", _resettingWP, true];
	};

if(_CurrentIndex > 0)
then{
		for "_I" from 1 to (_CurrentIndex - 1) do {deleteWaypoint [_NewGroup, 0];};
	};


DeleteGroup _Group;
_NewGroup deleteGroupWhenEmpty true;

	{
		[_KnownUnits, _x] spawn Tally_Fnc_TransferGroupKnowledge;
	}ForEach (units _NewGroup);


_NewGroup SetVariable ["lastGroupReset", time + 3, true];

_NewGroup};


Tally_Fnc_TransferGroupKnowledge = {
Params ["_KnownUnits", "_Recipient"];
	
	{
		private _Unit 		= (_X select 1);
		private _Knowledge 	= (_X select 0);
		
		_Recipient reveal [_Unit, _Knowledge];
		
	} ForEach _KnownUnits;


};

Tally_Fnc_GetVehicle_Width_Length = {
params["_VehicleType"];
private _breadthWidth = [4,9];

if(_VehicleType == "armedCar"
or _VehicleType == "unarmedCar")then{_breadthWidth = [3,5]};


_breadthWidth};



missionNamespace setVariable[
"Tally_Fnc_3Dmarkers", {

if(!isnil "3DmarkersDOC")exitWith{};
3DmarkersDOC = true;

addMissionEventHandler ["Draw3D", {

If (FSMD3Bugger) then 	{
								private _engagedVehicles = 0;
							
								{
									
									If (_x getVariable "Evading")
									then{
											Private _Side 		= (Side _x);
											Private _SideColor 	= [1,1,1,0.5];
											private _ActionText = (_x getVariable "currentAction");
											private _FinalPos 	= (_x getVariable "EvadePos");
											private _Text	 	= "";
											private _Damage 	= (Getdammage _x);
											private _Health 	= 1 - _Damage;
											private _PathIcon	= "\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa";
											private _FPS		= diag_fps;
											if (!IsNil "_ActionText") then {_Text = _ActionText;};
											if(_Side == west)		  then{_SideColor 	= [0.2, 0.2, 1, 0.8]};
											if(_Side == east)		  then{_SideColor 	= [1, 0.2, 0.2, 0.8]};
											if(_Side == independent)  then{_SideColor 	= [0.2, 1, 0.2, 0.8]};
											_engagedVehicles = (_engagedVehicles +1);
											
											_Color = [_Damage,_Health,0,1];
											_S1ze = 1;
											_alpha = 0.4;
											_angle = 0; 
											
											drawIcon3D 	["\A3\ui_f\data\map\markers\military\warning_CA.paa", 
											_Color, 
											[((ASLToAGL getPosASL _x) select 0), ((ASLToAGL getPosASL _x) select 1), (((ASLToAGL getPosASL _x)select 2) + 1.5)], 
											_S1ze, _S1ze, _angle, (_Text), 0, 0.02, "TahomaB"];
											
											
											private _PathPosArr = (_x getVariable "pathPos");
											if (!IsNil "_PathPosArr"
											&&{(!IsNil "_FinalPos")
											&&{_FPS > 20}})
											then{
													
													_S1ze = 0.5;
													_PathPosArr = [_x] call Tally_Fnc_GetPathPositions;
													private _Poscount		= ((count _PathPosArr)-1);
													for "_I" from 0 to _Poscount
													do 	{
															private _PathPos = (_PathPosArr select _I);
															if(_I == _Poscount)
															then{
																	_PathIcon 	= "\A3\ui_f\data\map\markers\handdrawn\destroy_CA.paa"; 
																	_S1ze 		= 2;
																};
															
																	drawIcon3D 	[_PathIcon, 
																				_SideColor, 
																				_PathPos, 
																				_S1ze, 
																				_S1ze, 
																				45, 
																				"", 
																				0, 
																				0.02,
																				"TahomaB"];
																
															
															
														};
												};
											
										};
								
										
									
									If (_x getVariable "Spotted")then 	{
																		drawIcon3D 	["", 
																		[0,0.5,0.5,0.8], 
																		[((ASLToAGL getPosASL _x) select 0), 
																		((ASLToAGL getPosASL _x) select 1), 
																		(((ASLToAGL getPosASL _x)select 2) + 10)], 
																		0.5, 
																		0.5, 
																		45, 
																		("Detected"), 
																		0, 
																		0.02, 
																		"TahomaB"];
																	};
								
								
								
								
								
								} forEach Vehicles;
								
						
							
							
							
							
							
							}; 
					}];
}, true];



Tally_Fnc_TerrainIntersects = {
private _AddedAltitude = 0;
private _IsInterSecting = false;
private _DistBetweenEachPos = 5;
params ["_StartPos", "_EndPos", "_AddedAltitude", "_DistBetweenEachPos"];



private _NextPosDistance 	= _DistBetweenEachPos;
private _Dir 				= _StartPos getDir _EndPos;
Private _Distance 			= (_StartPos distance2d _EndPos);
private _PosAmount 			= floor (_Distance / _DistBetweenEachPos);
private _InterSectionHeight = selectMax [(getTerrainHeightASL _StartPos) + _AddedAltitude, 
										 (getTerrainHeightASL _EndPos) 	 + _AddedAltitude];


for "_I" from 1 to _PosAmount 
do	{
		Private _Position 	= [_StartPos select 0, _StartPos select 1, _Dir, _NextPosDistance] call Tally_Fnc_CalcAreaLoc;
		private _Height		= (getTerrainHeightASL _Position);
		
		_NextPosDistance = (_NextPosDistance + _DistBetweenEachPos);
		if(_Height > _InterSectionHeight)
		exitWith{
					_IsInterSecting = true;
				};
		
	};


_IsInterSecting};

missionNamespace setVariable[
"Tally_Fnc_GetPathPositions", {
params["_Vehicle"];

private _DistBetweenEachPos = 15;
private _NextPosDistance 	= _DistBetweenEachPos;
private _TargetPos 			= (_Vehicle getVariable "EvadePos");
		If!([_TargetPos] 
		call 
		Tally_Fnc_IsPos)
		then{
				_TargetPos = (_TargetPos select 0);
			};
private _VehiclePos 		= (GetPos _Vehicle);
private _Dir 				= _VehiclePos getDir _TargetPos;
Private _Distance 			= (_VehiclePos distance2d _TargetPos);
private _PosAmount 			= floor (_Distance / _DistBetweenEachPos);
private _PosInBetween 		= [_VehiclePos];

if(_PosAmount > 0)
then{
		for "_I" from 1 to _PosAmount 
		do	{
				Private _Position 	= [_VehiclePos select 0, _VehiclePos select 1, _Dir, _NextPosDistance] call Tally_Fnc_CalcAreaLoc;
				_NextPosDistance = (_NextPosDistance + _DistBetweenEachPos);
				_PosInBetween pushBack _Position;
				
			};
	};
	
	_PosInBetween pushBack _TargetPos;
	
	

_PosInBetween}
, true];
[] spawn Tally_Fnc_PathDrawer;
missionNamespace setVariable[
"Tally_Fnc_IsPos", {
Params["_Arr"];
Private _Pos = true;
if!(typeName _Arr == "ARRAY")exitWith{false};
if!(Count _Arr == 3)exitWith{false};

{
if!(typeName _X == "SCALAR")
then{_Pos = false;};
}ForEach _Arr;

_Pos}
, true];

systemChat "DCO vehicle FSM loaded";

Tally_Fnc_CuratorEH = {
{
_x addEventHandler ["CuratorObjectDeleted", {
	params ["_curator", "_entity"];
private _Evading = _entity GetVariable "Evading";
	if(FSMD3Bugger)
	then{
			if(!isnil "_Evading")
			then{
					Hint (parsetext format ["Be carefull deleting units while they are engaged / activated. <br/>This could lead to scripts not exiting properly"]);
				};
		};
		diag_log "*******************************";
		diag_log "A vehicle was deleted while script was running";
		diag_log "*******************************";
	
}];

_x addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_entity"];
	
	
	Private _Group = Group _Entity;
	
	if(!Isnil "_Group")
	then{
			 _Group setGroupOwner 2;
		};
	
	
	
}];




}ForEach allCurators;


};
