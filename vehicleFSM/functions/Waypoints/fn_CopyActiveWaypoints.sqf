params ["_FromGrp", "_ToGrp"];

if(isNil "_FromGrp"
or IsNil "_ToGrp") exitWith {["could not copy wp from a NIL group"] call Tally_fnc_debugMessage; []};

if(isNull _FromGrp
or isNull _ToGrp) exitWith {["could not copy wp from a NULL group"] call Tally_fnc_debugMessage; []};

private _WayPointArr = [];
private _CurrentIndex = (currentWaypoint _FromGrp);
private _List 		 = waypoints _FromGrp;

/*delete waypoints that already passed*/
if(_CurrentIndex > 0)
then{
		for "_I" from 1 to _CurrentIndex do{_List deleteAt 0};
	};

if(count _List > 0)
then{
		/*get essential information*/
		{
			private _Pos 		= waypointPosition 	_x;
			private _Index 		= _x select 1;
			private _behaviour 	= waypointBehaviour _x;
			private _speed 		= waypointSpeed 	_x;
			private _formation	= waypointFormation _x;
			
			private _wpInfo = [	_Pos, 
								_Index, 
								_behaviour, 
								_speed, 
								_formation];
			
			_WayPointArr pushBackUnique _wpInfo;
		}forEach 
		_List;
		
		/*reapply waypoints*/
		{
		private _Position 	= _x select 0;
		private _behaviour 	= _x select 2;
		private _speed 		= _x select 3;
		private _formation 	= _x select 4;

		private _wp = _ToGrp addWaypoint [_Position, 0];
		_wp setWaypointBehaviour 	_behaviour;
		_wp setWaypointSpeed  		_speed;
		_wp setWaypointFormation 	_formation;

		}ForEach 
		_WayPointArr;
	};