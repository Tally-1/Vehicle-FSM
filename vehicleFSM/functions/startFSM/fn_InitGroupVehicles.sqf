params [ "_originator", "_Enemy", "_GroupVehicles", "_QuickReaction" ];
{
If ([_X] call Tally_Fnc_VehEligbleFSM) then {
												Private _Evading 		= (_X getVariable "Evading");
												private _Eligible			= ([_X] call Tally_Fnc_VehEligbleFSM);
												if(isNil "_Evading"
												&&{_Eligible})then{
																	private _NewDistance 	= (_X distance2d _Enemy) * 1.1;
																	[_x, _NewDistance, FSMD3Bugger, _Enemy, _originator, _QuickReaction] spawn Tally_Fnc_EvadeVEh;
																	sleep 0.1;
																};												
											};
}
ForEach _GroupVehicles;