Params ["_Group"];
If ((count waypoints _group) > 0) then {
										for "_i" from count waypoints _group - 1 to 0 step -1 do
													
													{deleteWaypoint [_group, _i]};
													{deleteWaypoint _x}ForEach (waypoints _Group);
										};