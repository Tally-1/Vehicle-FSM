params ["_Vehicle"];
private _WayPointArr	= [];
private _Group			= group _Vehicle;
private _destroyed 		= [_Vehicle] call Tally_Fnc_crewDead;
if(_destroyed)exitWith{_WayPointArr};

private _CurrentIndex = (currentWaypoint _Group);
private _List 		 = waypoints _Group;

for "_I" from 1 to _CurrentIndex do{_List deleteAt 0};

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



_WayPointArr