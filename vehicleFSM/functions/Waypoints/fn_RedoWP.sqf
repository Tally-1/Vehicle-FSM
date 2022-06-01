params ["_Vehicle"];
if([_Vehicle] call Tally_Fnc_crewDead)exitWith{["Cannot re-initiate waypoints, crew is dead / nil / null / absent"]call Tally_fnc_debugMessage};

private _Group				= group _Vehicle;
private _PreviousWayPoints 	= [_Vehicle] call Tally_Fnc_GetWaypointInfo;
private _CurrentIndex 		= (currentWaypoint _Group);
private _Busy				= (_Group getVariable "resettingWP");

if(!isnil "_Busy")exitWith{};

["Re-applying waypoints"]call Tally_fnc_debugMessage;

_Group setVariable ["resettingWP", true, true];
[_Group] spawn Tally_Fnc_ResetGroup;

sleep 0.1;
[_Group] call Tally_Fnc_DeleteWP;
[_Group] call Tally_Fnc_DeleteWP;
[_Group] call Tally_Fnc_DeleteWP;
sleep 0.1;

		{
			
			private _Index 		= _x select 1;
			
			
			If(_Index > _CurrentIndex)
			then 	{
						private _Position 	= _x select 0;
						private _behaviour 	= _x select 2;
						private _speed 		= _x select 3;
						private _formation 	= _x select 4;
						
						private _wp = _Group addWaypoint [_Position, 0];
						_wp setWaypointBehaviour 	_behaviour;
						_wp setWaypointSpeed  		_speed;
						_wp setWaypointFormation 	_formation;
						_wp setWaypointCompletionRadius 60;
						sleep 0.1;
					
					};
			
			
			
			
		}ForEach 
		_PreviousWayPoints;

_Group setCurrentWaypoint [_Group, _CurrentIndex];
_Group setVariable ["resettingWP", nil, true];