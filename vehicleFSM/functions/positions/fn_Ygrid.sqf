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
if (isNil "_Center") exitWith{diag_log "center is nil, fn_Ygrid.sqf"};
					
	for "_i" from 1 to _Final_Height do {
	
	if!(typeName (_Pos select 0) == "SCALAR")
	exitWith{diag_log "non-number position caused conflict while scanning"};
											
											If !(surfaceIsWater 
												[(_Pos select 0), 
												(_Pos select 1)]) 
												then {
												If !(_GetPushPos) then	{
														if ([_Pos, _Center, 10] call Tally_Fnc_LOS_Light) /*!(terrainIntersect [_Pos, _Center])  */
																			then 	{
															
																						(_Vehicle GetVariable "Positions") PushbackUnique  _Pos;
																						//If (FSMD3Bugger) then 	{[_Vehicle, "RECTANGLE", _Pos, 0, _Spacing, "ColorOrange", "SolidBorder"] call Tally_Fnc_VehMarkers;};
																					
																					}
																				else{
																				if (_GetHidePos)then{
																										(_Vehicle GetVariable "HidePositions") PushbackUnique  _Pos;
																									};
																					};	
																				
																		}/*the next segment is executed when searching for push Positions*/
																	else{
																			
																			(_Vehicle GetVariable "PushPositions") PushbackUnique  _Pos;
																			
																		};
																												
													 };
										_Pos = [_Pos select 0, (_Pos select 1) + (_Spacing * 2), 1];
										};