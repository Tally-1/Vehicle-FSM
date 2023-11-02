/*this script is activated if an enemy is within the minimum distance*/
Private _Minimum_Distance 		= 400; /*Default if nothing is selected*/
Private _DeBug 					= false;
Private _Enemy 					= nil;
private _QuickReaction			= false;

Params ["_Vehicle", "_Minimum_Distance", "_DeBug", "_Enemy", "_Initiator", "_QuickReaction"];


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

private _debug = format ["side Vehicle %1 Has %2 TargetKnowledge", _Vehicle, (_Side knowsAbout _Enemy)];
[_DeBug] call Tally_fnc_debugMessage;

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
Private _GoDistance 			= ((_Minimum_Distance - (_Vehicle Distance2D _Enemy)) + (_Minimum_Distance / 5)); /*added 1 / 5th of min distance account for completion radius checked in the end function*/
private _VehicleType 		= ([_Vehicle] call Tally_Fnc_GetVehicleType);
private _VehPos		 		= (GetPos _Vehicle);
private _AvgEnemyAltitude 	= [_enemyPositions] call Tally_Fnc_GetAVGheight;
private _Timer				= (round((time) + (_Minimum_Distance / ([_Vehicle] call Tally_Fnc_Timer_divisor))));
private _LastSmoke			= (_Vehicle getVariable "LastSmoke");
private _LastEngagement		= (_Vehicle getVariable "DCO_VFSM_END");
private _GroupVehicles 		= ([(Group _Vehicle)] call Tally_Fnc_GetGroupVehicles);
private _recentlyEngaged		= false;
sleep 0.1;
/*private _Waypoints 			= ([_Vehicle] call Tally_Fnc_GetWaypointInfo);*/
sleep 0.1;
/*private _PreviousWaypoints	= (_Vehicle getVariable "wayPoints");*/
sleep 0.1;



private _HidePos 			=  [_VehPos select 0, 
								_VehPos select 1, 
							(_EnAvgPos getDir _VehPos), 
							(_Minimum_Distance / 4)] 
							call Tally_Fnc_CalcAreaLoc;
							
If (_EnemyDist < 100) then {_evasionDir = _EnemyDir};

Private _EvasionPos = [_VehPos select 0, _VehPos select 1, _evasionDir, _GoDistance] call Tally_Fnc_CalcAreaLoc;
/*
if(Isnil "_PreviousWaypoints")
then{
if(IsNil "_Initiator")
then{
		_Vehicle SetVariable ["wayPoints",_Waypoints, true];
	}
else{
		_Waypoints = (_Initiator getVariable "wayPoints");
		_Vehicle SetVariable ["wayPoints",_Waypoints, true];
	};
};
*/
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
_Vehicle setVariable ["crewStatus", 			"Operational",									true]; /*this variable needs to be called through a more precise function*/
_Vehicle setVariable ["vehicleType", 		_VehicleType,									true];
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
_Vehicle setVariable ["currentAction", 		"Reacting",										true]; 
_Group SetVariable 	["lastGroupReset",		time,											true];
_Vehicle SetVariable ["ready", 				false, 											true];

if(isnil "_LastSmoke")then	{
								_Vehicle SetVariable ["LastSmoke", 		time - 120,			true];
								_Vehicle SetVariable ["LastSmokePos",	[0,0,0], 	true];
							}; 
if(isnil "_LastEngagement")
then{_LastEngagement = time - 30};
 							
if(time - _LastEngagement < 10)
then{
		if(_QuickReaction)then{["QuickReaction blocked, less than 10 seconds have passed since last engagement."] call Tally_fnc_debugMessage};
		_recentlyEngaged = true;
		_QuickReaction	= false;
	};

private _Timer = time;
Private _Areas = [(getpos _Enemy), _Minimum_Distance, _Vehicle, _evasionDir] call Tally_Fnc_SearchAreas;
_Vehicle SetVariable ["Areas", 	_Areas, true];
sleep 0.1;

private _ReactionTime = 0;
private _reactionScript = "";

if(_QuickReaction)then{
						_ReactionTime 	= 20;
						_reactionScript 	= [_Vehicle, _ReactionTime] spawn Tally_Fnc_QuickDecision;
					};



if(_vehicle IskindOf "HeliCopter")
exitwith{
			// [_vehicle, 
			// _HidePos,
			// _EnAvgPos] spawn Tally_Fnc_ChopperEvasion;
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
/*Remember to remove this*/
/*sleep _ReactionTime;*/




private _GroupUnits = (Units (Group (Driver _Vehicle)));
Private _EvasionPos2 = (SelectRandom (_Vehicle GetVariable "Positions"));

If !(IsNil "_EvasionPos2") then {_EvasionPos = _EvasionPos2};
_Vehicle SetVariable ["EvadePos", 				_EvasionPos, true];
_Vehicle SetVariable ["DCO_LastEngagementTime",	time, 		true];


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
	{_X SetVariable ["Spotted", true, true]}ForEach(_Vehicle GetVariable "AllSpotted");

If (FSMD3Bugger) then 	{
							[_Vehicle] call Tally_Fnc_SelectedPositionMarkers;
						};


/*waitUntil{ sleep 0.1; scriptDone _ReactionScript };*/



{
_X setVariable ["Vehicle", 	_Vehicle,  true];
}ForEach _Crew;

if (_VehicleType == "tank"
or	_VehicleType == "APC") 
then{
		if(VehicleAutoRepair)
		then{
				_vehicle allowCrewInImmobile true;
			};
			
		/*_Vehicle setEffectiveCommander driver _Vehicle*/
	};


[_Vehicle, _Enemy, _GroupVehicles, _QuickReaction] spawn Tally_Fnc_InitGroupVehicles;

if!(typeName _reactionScript == "STRING")then	{
												["waiting for initial reaction"] call Tally_fnc_debugMessage;
												waitUntil{ sleep 0.1; scriptDone _ReactionScript };
											};

sleep 0.1;
_Vehicle setVariable ["currentAction", "Assesing situation",	true]; 
_Vehicle SetVariable ["ready", true, true];
[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions;