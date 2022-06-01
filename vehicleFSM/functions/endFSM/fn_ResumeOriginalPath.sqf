params["_Vehicle"];
private _destroyed 	= [_Vehicle] call Tally_Fnc_crewDead;
if(!(_destroyed))
then{
		private _Group 		= (group _Vehicle);
		private _hasWP		= ((count waypoints _Group) > 0);
		private _engaged	= [_Vehicle] call Tally_Fnc_GroupFsmActive;
		
		if([_vehicle] call Tally_Fnc_Available_And_Wp)
		then{
				/*Adding some sleep and re-checking that the fight is actually over before ordering the vehicle to move to the next WP*/
				
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