params ["_Vehicle", "_EnAvgPos"];
private _Timer = time;
		{
			Private _arr = _x;
			private _Script =  _arr spawn Tally_Fnc_Scan_Area;
	
			Waituntil {	
						sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					  };
		} ForEach (_Vehicle GetVariable "Areas");
		
		_Script = [_Vehicle, _EnAvgPos] Spawn Tally_Fnc_FilterPos;
		Waituntil {	
						sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					  };
		["Flank positions loaded in seconds:", (time-_Timer)] call Tally_fnc_debugMessage;
		_Vehicle SetVariable ["FlankPosLoaded", true, true];