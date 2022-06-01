params["_Vehicle", "_PreviousWayPoints", "_GroupVehicles"];

/*defining conditions to avoid re-applying waypoints prematurly*/
				
		private	_Evading 		= (_Vehicle getVariable "Evading");
				_Evading 		= (!IsNil "_Evading");
		private _GroupEngaged 	= false;
		private _Dead			= (!Alive _Vehicle 
								or (count (crew _Vehicle) < 1));
		private _deadCrew		= true;
		private _CurrentWP		= [_Vehicle] call Tally_Fnc_GetWaypointInfo;
		private _AlreadyDone	= (_CurrentWP isEqualto _PreviousWayPoints);
		private	_Group 			= group _Vehicle;
		private _noGroup		= (isNil "_Group"
								or isNull _Group);
		
		{
			private _engaged = (_x getVariable "Evading");
			if (!IsNil "_engaged")
			then{
					_GroupEngaged = true;
				};
		}ForEach 
		_GroupVehicles;
		
		{
			if (Alive _X)
			then{
					_deadCrew = false; 
				};
		}ForEach 
		crew _Vehicle;
		
		if(!(_Evading)
		&&{!(_GroupEngaged)
		&&{!(_Dead)
		&&{!(_noGroup)
		&&{!(_deadCrew)
		}}}})exitWith{true};
		
false