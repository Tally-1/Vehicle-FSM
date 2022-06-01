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
			_Vehicle SetVariable ["DCO_VFSM_END",	time, true];
			
			

{_X SetVariable ["Spotted", nil, true];}ForEach(_Vehicle GetVariable "AllSpotted");
_Vehicle setVariable ["AllSpotted", 	nil, true];
{deleteMarker _X} ForEach (_Vehicle GetVariable "Markers");
_Vehicle SetVariable ["Markers", 		nil, true];

If !(alive _Vehicle) then{
							_Vehicle removeAllEventHandlers 	"Fired";
							_Vehicle removeAllEventHandlers 	"HandleDamage";
							_Vehicle setVariable 			["EventHandlers", 	nil, true];
							_Vehicle SetVariable 			["DCO_VFSM_END",	nil, true];
						};