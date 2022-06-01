Params ["_Group"];

if(DCOnoGroupReset)exitWith{diag_log "Group-reset has been deActivated"};

if(isnil "_Group")exitWith{["Nil group passed to the reset-group function"] call Tally_fnc_debugMessage};
/*anti-overflow*/
if((_Group getVariable "lastGroupReset") > (time))
exitWith{["Double group-reset blocked"] call Tally_fnc_debugMessage; _Group};




private _KnownUnits = [];
private _Waypoints 	= count (waypoints _Group);

private _resettingWP = _Group getVariable "resettingWP";
private _initialized 	= _Group getVariable "initialized";
private _leader_Killed	= _Group getVariable "leader_Killed";
private _areaScan	= _Group getVariable "DCO_AreaScan";

private _CurrentIndex = (currentWaypoint _Group);
private _Formation	= formation _Group;



/*Store all known units in a array in order to transfer that knowledge once group-reset is done*/
	{
		if ((_Group knowsAbout _x) > 0)
			then{
					_KnownUnits PushBackUnique [(_Group knowsAbout _x), _X];
				};
	}ForEach allunits;
	
	{
		if ((_Group knowsAbout _x) > 0)
			then{
					_KnownUnits PushBackUnique [(_Group knowsAbout _x), _X];
				};
	}ForEach vehicles;
	
Private _NewGroup = createGroup (side _Group);
		_NewGroup copyWaypoints _Group;
		
if!((waypoints _Group)IsEqualTo(waypoints _NewGroup))
	then{
			_NewGroup copyWaypoints _Group;
		};

for "_I" from 1 to 2 do {
							{ [_x] joinSilent _NewGroup } forEach (units _Group);
						};

if(!IsNil "_resettingWP")	then{_NewGroup setVariable ["resettingWP", 	_resettingWP,	true]};
if(!IsNil "_initialized")	then{_NewGroup setVariable ["initialized",		_initialized, 		true]};
if(!IsNil "_leader_Killed")	then{_NewGroup setVariable ["leader_Killed",	_leader_Killed, 	true]};
if(!IsNil "_areaScan")		then{_NewGroup setVariable ["DCO_AreaScan", 	_areaScan, 		true]};


if(_CurrentIndex > 0)
then{
		for "_I" from 1 to (_CurrentIndex - 1) do {deleteWaypoint [_NewGroup, 0];};
	};


DeleteGroup _Group;
_NewGroup deleteGroupWhenEmpty true;

	{
		[_KnownUnits, _x] spawn Tally_Fnc_TransferGroupKnowledge;
	}ForEach (units _NewGroup);

_NewGroup setFormation _Formation;

_NewGroup SetVariable ["lastGroupReset", time + 3, true];

_NewGroup