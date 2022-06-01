private _StartTime	= time;
private _GetHidePos = false;
private _GetPushPos = false;
Params ["_Pos", "_Size", "_Vehicle", "_GetHidePos", "_GetPushPos"];

Private _PosAmount 	= 10;
Private _Spacing 	= (_Size / _PosAmount);

Private _StartPos = ([(_Pos select 0), (_Pos select 1), 225, (_Size * 1.272727)] Call Tally_Fnc_CalcAreaLoc);
_StartPos = [	_StartPos select 	0, 
				_StartPos select 	1, 
									0];

For "_I" from 1 to _PosAmount do {
									private _Timer = time + 1;
									
									[_StartPos, _Spacing, _PosAmount, _Vehicle, _GetHidePos, _GetPushPos] call Tally_Fnc_Ygrid;
									 _StartPos = [((_StartPos select 0) + (_Spacing * 2)), 
													_StartPos select 1, 
																	 0];
									
									if (time > _Timer)exitWith {};
								  };
_Vehicle SetVariable ["Spacing", 		_Spacing, true];

/*["Scanned area in seconds", (time -_StartTime)] call Tally_fnc_debugMessage;*/