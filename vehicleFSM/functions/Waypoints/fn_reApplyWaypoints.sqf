params ["_Vehicle"];
/*private _CrewStatus 	 		= [_Vehicle] call Tally_Fnc_CheckCrewStatus;*/
private _PreviousWayPoints	= (_Vehicle getVariable "wayPoints");
private _Group				= group _Vehicle;
private _GroupVehicles		= (_Vehicle getVariable "GroupVehicles");
private _Wait				= 10;
private _reApply				= true;


/*If(_CrewStatus == -1)exitWith{["crew dead, could not re-apply wayPoints"] call Tally_fnc_debugMessage};*/

sleep 10;

Private _Evading 		= (_Vehicle getVariable "Evading");
		_Evading 		= (!IsNil "_Evading");
		_CrewStatus 	 	= [_Vehicle] call Tally_Fnc_CheckCrewStatus;

if	(isNil "_Vehicle")			exitWith{["vehicle undefined, could not re-apply wayPoints"] call Tally_fnc_debugMessage};
if	(isNil "_Group")			exitWith{["group undefined, could not re-apply wayPoints"] call Tally_fnc_debugMessage};
if	(isNil "_PreviousWayPoints")exitWith{["PreviousWayPoints undefined, could not re-apply wayPoints"] call Tally_fnc_debugMessage};
if 	(_Evading)					exitWith{["Cannot re-apply wayPoints, vehicle is still active"] call Tally_fnc_debugMessage};
if 	(!Alive _Vehicle)			exitWith{["Cannot re-apply wayPoints, vehicle Destroyed"] call Tally_fnc_debugMessage};
/*If(_CrewStatus == -1)			exitWith{["crew dead, could not re-apply wayPoints"] call Tally_fnc_debugMessage};*/

/*for some reason the GroupVehicles command is a bit slow, and might be undefined, will be called again here if needed*/
if	(isNil "_GroupVehicles")	then{_GroupVehicles = ([_Group] call Tally_Fnc_GetGroupVehicles); sleep 1};
if	(isNil "_GroupVehicles")	exitWith{["groupVehicles undefined, could not re-apply wayPoints"] call Tally_fnc_debugMessage};


for "_I" from 1 to _Wait 
do 	{
		/*sleep to apply waiting-time defined at start of function*/
		sleep 1;
		
		_reApply = [
					_Vehicle, 
					_PreviousWayPoints,
					_GroupVehicles
					] call Tally_Fnc_ReApplyConditions;
		
		if(_reApply)exitWith{["Leeets goooo"] call Tally_fnc_debugMessage};
		
		
	};

if(_reApply)
then{
		["re-applying wayPoints"] call Tally_fnc_debugMessage;
		[_Group] call Tally_Fnc_DeleteWP;
		
		{
			private _Position 	= _x select 0;
			private _Index 		= _x select 1;
			private _behaviour 	= _x select 2;
			private _speed 		= _x select 3;
			private _formation 	= _x select 4;
			
			private _wp = _Group addWaypoint [_Position, 0, _Index];
			_wp setWaypointBehaviour 	_behaviour;
			_wp setWaypointSpeed  		_speed;
			_wp setWaypointFormation 	_formation;
			
			
		}ForEach 
		_PreviousWayPoints;
	}
else{
		["could not re-apply wayPoints. Conditions not met"] call Tally_fnc_debugMessage;
	};