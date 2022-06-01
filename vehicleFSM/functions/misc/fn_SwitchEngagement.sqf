params ["_Vehicle", "_On_OFF"];

		{
		If(_On_OFF)then{
							_X enableAI "TARGET";
							_X enableAI "AUTOCOMBAT";
							_X enableAI "AUTOTARGET";
						}
				   else{
							_X disableAI "TARGET";
							_X disableAI "AUTOCOMBAT";
							_X disableAI "AUTOTARGET";
							_X doWatch objNull;
						};
		
		}ForEach 
		 crew _Vehicle;