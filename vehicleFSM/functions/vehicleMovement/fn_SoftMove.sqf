
params ["_Vehicle", "_TargetPos"];
private _LastMove = (_Vehicle getVariable "LastMove");
private _Crew = (_Vehicle getVariable "crew");
private _Driver = (driver _Vehicle);

if(isnil "_Driver")ExitwITH{};
if(isnil "_TargetPos")ExitwITH{};

if(isnil "_Crew")then	{
							_Crew = crew _Vehicle;
						};
if(isnil "_LastMove")then	{
								_LastMove = 0;
							};
if (Time < _LastMove) exitWith{};

_Vehicle 			SetVariable ["LastMove", time + iterationTimer,	true];
_Driver 		 	setBehaviourStrong "AWARE";
(Group _Driver) 	setBehaviourStrong "AWARE";
(Group _Driver) 	setSpeedMode "FULL";


_Driver 	moveTo 		_TargetPos;
_Crew 		DoMove 		_TargetPos;
_Crew 		CommandMove _TargetPos;
_Vehicle	DoMove 		_TargetPos;