private _PreScan = (diag_fps > 20);

					{
						private _Vehicle 			= _X;
						private _evading 			= _x getVariable "Evading";
						Private _Group 				= Group _Vehicle;
						private _excluded 			= [_Group] call Tally_Fnc_ExcludeP_group;
						private _NoTacticsAvailable 	= (DCOnoHideGlobal
													&&{DCOnoFlankGlobal
													&&{DCOnoPushGlobal}});
	
						If ([_X] call Tally_Fnc_VehEligbleFSM
						&& {Isnil "_evading"
						&& !(_NoTacticsAvailable)}) 			then 	{
																		if(!Isnil "_Group")
																		then{
																				 _Group setGroupOwner 2;
																			};
																		
																		[_Vehicle, VehMinimumDistance, FSMD3Bugger] spawn Tally_Fnc_EvadeVEh;
																		sleep 0.1;
																	
																	};
						If (_x getVariable "Evading"
						&&{(_x getVariable "ready")
						&&{true /*!(_x getVariable "EndingScript")*/}}) 	
						then 	{													
									/*Private _Active = (_x getVariable "Active");*/
									private _Timer = time + iterationTimer;
									private _Script = [_x] spawn Tally_Fnc_Check_EvasionVeh_Conditions;
									waituntil {sleep 0.02; (scriptDone _Script or time > _Timer)};
									sleep 0.1;
																			
								}
						else 	{
								
								};
					sleep 0.05;
					} ForEach vehicles;
					
					if (time > DCO_HintTimer) then	{
													DCO_HintTimer = time + 120;
													
													If(FSMD3Bugger)
													then{
															hint (parsetext format["DCO vehicle FSM: <br/>Version: %1", (DCO_Version)]);
														};
												
												};
					
				if (time > DCO_TenSecondTaskTimer) then{
															[_PreScan] spawn Tally_Fnc_scheduledGroupTasks;
													
															{
																[_X] call Tally_Fnc_AddEh;
																if([_X] call Tally_Fnc_Available_And_Wp)
																then{
																		private _Group = (group _X);
																		/*units _group doFollow leader _group;*/
																	};
															}ForEach Vehicles;
															
															if(FSMD3Bugger)then{diag_log format["Active scripts: %1", (diag_activeScripts select 0)]};
															
															DCO_TenSecondTaskTimer = time + 10;
													
														};

ScriptsRunningDOC		= (diag_activeScripts select 0);

if(FSMD3Bugger
&&{diag_fps < 20
&&{!IsDedicated}})
then{
		[(parsetext format ["%1 FPS.", (diag_fps)])] remoteExec ["Hint", 0];
	};