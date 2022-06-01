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



_UpdatedEnemyList