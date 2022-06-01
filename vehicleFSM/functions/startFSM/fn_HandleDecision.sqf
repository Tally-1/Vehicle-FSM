
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
																																				["no hiding positions found, rescanning"] call Tally_fnc_debugMessage;
																																			}
																																		else{
																																				["Cannot initiate hiding, no hiding positions found"] call Tally_fnc_debugMessage;
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
																					[_Vehicle, "Ending FSM"] spawn Tally_fnc_ExitEnd;
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
																					if ([_Vehicle] call Tally_Fnc_KnownEnemiesDead)exitWith{[_Vehicle, "Victory"] spawn Tally_fnc_ExitEnd};
																					
																					
																					[_Vehicle] spawn {
																										params ["_Vehicle"];
																										sleep 0.3;
																										_Vehicle SetVariable ["LastConditionCheck",	time - iterationTimer, true];
																										[_Vehicle] spawn Tally_Fnc_Check_EvasionVeh_Conditions;
																									};
																				};	