private _SecondScan = false;
params ["_Vehicle", "_SecondScan"];
private _HotsPot 	= (_Vehicle GetVariable "centro"); 
/*private _ScanSize 	= ((_Vehicle GetVariable "MinDistEnemy") / 2);*/
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
															/*[_Vehicle, "Victory"] spawn Tally_fnc_ExitEnd;*/
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
							["Re-scanning for Push-positions"] call Tally_fnc_debugMessage;
						};

private _PosCount = count (_Vehicle GetVariable "PushPositions");
If !([_Vehicle] call Tally_Fnc_Is_Evading)exitWith{};

if (_PosCount > 10)then {
							waituntil {(!(DCO_AreaScan)) 
									  or (time > _Timer)};
							DCO_AreaScan = true;
								{
									_Pos = [_X select 0,
											_X select 1,
											0];
									Private _AssessedPosition = [_Vehicle, _Pos, _SecondScan] call Tally_Fnc_AssessPushPos;
									_NewAssessment pushBack _AssessedPosition;
									sleep 0.001;
								}ForEach (_Vehicle GetVariable "PushPositions");
							DCO_AreaScan = false;
													

							/*making sure the two arrays are equal*/
							private _PosCount 		= (count (_Vehicle GetVariable "PushPositions"));
							private _AssPosCount 	= (count _NewAssessment);
							if(Isnil "_PosCount")exitWith{["Positions have not been defined"] call Tally_fnc_debugMessage;};
							if!(_PosCount == _AssPosCount) exitWith {
																		["Positions not properly assessed"] call Tally_fnc_debugMessage;
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
													["Could not load push-positions"] call Tally_fnc_debugMessage;
													
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
		["Push positions loaded in", (time - _StartTime)] call Tally_fnc_debugMessage;
	};