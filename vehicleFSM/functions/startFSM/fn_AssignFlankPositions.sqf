params["_Vehicle", "_EnAvgPos", "_Initiator"];

private _Timer = time;
if (IsNil "_Initiator")
then{
		private _script = [_Vehicle, _EnAvgPos] spawn Tally_Fnc_FlankPositions;
		Waituntil {sleep 0.02; 
						((ScriptDone _Script)
						or(time - _Timer > 3))
					 };
	}
else{
		waituntil{
					sleep 0.1;
					private _Loaded 	= (_Initiator GetVariable "FlankPosLoaded");
					private _TimedOut 	= (time - _Timer > 4);
					
					if(IsNil "_Loaded")exitWith{true};
					
					if(_TimedOut
					or _Loaded)
					exitWith{true};
					false
				  };
					 
		private _FlankPositions = (_Initiator GetVariable "Positions");
				if(IsNil "_FlankPositions")
				then{
						_FlankPositions = [];
					};
		
			if (count _FlankPositions > 4)then
			{
				_Vehicle SetVariable ["Positions", _FlankPositions, true];
				_Vehicle SetVariable ["FlankPosLoaded", true, 		true];
			}
		
		else{
				private _script = [_Vehicle, _EnAvgPos] spawn Tally_Fnc_FlankPositions;
				Waituntil 	{
							sleep 0.02; 
							((ScriptDone _Script)
							or(time - _Timer > 3))
							};
			};
		
		
	};