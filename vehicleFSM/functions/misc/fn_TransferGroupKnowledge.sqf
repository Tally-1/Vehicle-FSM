Params ["_KnownUnits", "_Recipient"];
	
	{
		private _Unit 		= (_X select 1);
		private _Knowledge 	= (_X select 0);
		
		_Recipient reveal [_Unit, _Knowledge];
		
	} ForEach _KnownUnits;