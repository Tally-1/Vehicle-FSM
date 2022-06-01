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
										
										if([_Pos, _EnemyPos, 10] call Tally_Fnc_LOS_Light)/* !(terrainIntersect [_Pos, _EnemyPos] call Tally_Fnc_TerrainIntersects) */
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




[_NearbyObjects, _HigherThanEn, _LOSrank]