params["_PreScan"];
{						
	if !(_X == DCO_deathGroup)
	then{
	
		if(Units _X IsEqualTo [] 
		or IsNull _X)
		then{
			 deleteGroup _X;
			};
																	
		if(!(Units _X IsEqualTo []))
		then{
				[_X] call Tally_Fnc_GroupInit;/*Sets variables and eventHandler used for courage calculation*/
			};
	};
	if(_PreScan)
	then{
			private _scanning = [_X] spawn Tally_Fnc_Scheduled_AreaPrescan;
			waituntil{sleep 0.1; scriptDone _scanning};
		
		}
	else{
			["Prescan stopped to save resources"] call Tally_fnc_debugMessage;
		};
	
}ForEach AllGroups;