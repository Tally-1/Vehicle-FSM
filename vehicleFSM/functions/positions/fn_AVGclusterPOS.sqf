params ["_unit", "_Radius"];
private _AllowedDataTypes = ["OBJECT", "GROUP", "LOCATION"];

if!((TypeName _Unit) in _AllowedDataTypes)exitWith	{
														If(FSMD3Bugger)then{systemChat "cannot retrieve cluster position, unit not defined";};
														-1
													};

private _Side 	= (Side _Unit);
Private _Pos 	= (GetPos _Unit);
private _list 	= (nearestObjects [_Pos, ["land"], _Radius, true]);
Private _Yarr 	= [];
Private _Xarr 	= [];

_list PushBackUnique _unit;

{
	if 	((Side _x) == (_Side))
	then 	{
			
				Private _Xpos   = (round ((Getpos _x) select 0));
				Private _Ypos   = (round ((Getpos _x) select 1));
				_Yarr PushBackUnique _Ypos;
				_Xarr PushBackUnique _Xpos;
			};
}ForEach _list;

if(count _list < 2)exitWith{_Pos};


Private _Returnpos = [(round ([_Xarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), (round ([_Yarr, "Tally_Fnc_AVGclusterPOS"] Call Tally_Fnc_GetAVG)), 1];
If (Isnil "_Returnpos") then {
								_Returnpos = _Pos;
							};

_Returnpos