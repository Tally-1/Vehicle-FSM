params["_TargetPos", "_Vehicle"];

private _OldArr = (_Vehicle GetVariable "HidePositions");
private _NewArr = [];

if(isnil "_OldArr")exitWith{_NewArr};


private _Center				= [_TargetPos select 0,
							   _TargetPos select 1,
							  (_TargetPos select 2) + 2.5];
private _deletedEntries 	= 0;

{
	private _Pos = [_x select 0,
					_x select 1,
				   (_x select 2) + 2.5];
	
	if !([_Pos, _Center, 15] call Tally_Fnc_LOS_Light) 
										Then 	{
													_NewArr pushBackUnique _x;
												}
										else 	{
													_deletedEntries = (_deletedEntries + 1);
												};

}ForEach (_Vehicle GetVariable "HidePositions");

/*If (FSMD3Bugger) then {systemChat format["%1 deleted hiding-positions", (_deletedEntries)];};*/

_NewArr