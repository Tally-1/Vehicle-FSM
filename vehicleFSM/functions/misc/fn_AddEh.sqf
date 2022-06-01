
params ["_Vehicle"];

/*Anti-overFlow function*/
private _EventHandlers = (_Vehicle GetVariable "EventHandlers");

if(!Isnil "_EventHandlers")	exitWith{};
if (Isnil "_Vehicle") 		exitWith{};
if (!alive _Vehicle) 		exitWith{};

_Vehicle setVariable ["EventHandlers", 0, true];
/*[_Vehicle] call Tally_Fnc_VerifyData;*/


_Vehicle addMagazineTurret ["SmokeLauncherMag",[0,0], 4];

_Vehicle addEventHandler ["Fired", {
	params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
	
If ([_unit] call Tally_Fnc_VehEligbleFSM) then 	{
	
	Private _Enemy =  getAttackTarget _unit;
	if(Isnil "_Enemy")then{_Enemy = getAttackTarget _gunner};
	
	private _Side		= (Side _unit);
	private _Otherside	= (Side _Enemy);
	private _Distance = (_unit distance2d _Enemy);
	private _LastShotHash = (_Vehicle getvariable "LastShotHash");
	
	if(Isnil "_LastShotHash")
	then{
			_LastShotHash = createHashMap;
			_Vehicle setvariable ["LastShotHash", _LastShotHash, true];
		};

_LastShotHash set ["time", time];
_LastShotHash set ["weapon", _weapon];

	
	if!([_Side, _Otherside] call BIS_fnc_sideIsFriendly)then
	{
		[_unit, _Distance, FSMD3Bugger, _Enemy, nil, true] spawn Tally_Fnc_EvadeVEh;
	};
	
}}];


_Vehicle addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint"];

if (_projectile == "")exitWith{};


Private _Enemy = _source;
if(Isnil "_Enemy")then{_Enemy = _instigator};
private _Side		= (Side _unit);
private _Otherside	= (Side _Enemy);
private _Distance 	= (_unit distance2d _Enemy);
private _hostile		= !([_Side, _Otherside] call BIS_fnc_sideIsFriendly);
private _engaged = _Vehicle getvariable "Evading";

If ([_unit] call Tally_Fnc_VehEligbleFSM) then 	{
	if(_hostile)then
	{
		[_unit, _Distance, FSMD3Bugger, _Enemy, nil, true] spawn Tally_Fnc_EvadeVEh;
	};
}
else{
if(!isnil "_engaged")
then{
[_unit, _Enemy]
spawn	{
			params[_Vehicle, _Enemy];
			_Vehicle disableAI "TARGET";
			if(alive (gunner _Vehicle))
			then{
					private _Script = [_Vehicle , (getPos _Enemy)] spawn Tally_Fnc_FacePos;
					for "_I" from 1 to 3 do{_Vehicle dofire _Enemy; sleep 1};
					waituntil{sleep 0.25; scriptDone _Script};
					[_Vehicle] spawn Tally_Fnc_DeploySmoke;
					sleep 1;
				};
			
			private _engaged = _Vehicle getvariable "Evading";
			if(!isnil "_engaged")
			then{
					private _destination = _Vehicle getvariable "EvadePos";
					if(!isnil "_destination")
					then{for "_I" from 1 to 3 do{_Vehicle doMove _destination};
				}};
			_Vehicle enableAI "TARGET";
			}}};

}];

_Vehicle addEventHandler ["Killed", {
	params ["_unit", "_killer", "_instigator", "_useEffects"];
	private _Evading = _unit getvariable "Evading";
	_unit removeEventHandler ["Killed", _thisEventHandler];
	
	if(!isNil "_Evading")
	then{
			[_unit] spawn Tally_Fnc_Check_EvasionVeh_Conditions;
		};
	
	
	
}];