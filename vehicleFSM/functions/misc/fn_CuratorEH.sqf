
{
_x addEventHandler ["CuratorObjectDeleted", {
	params ["_curator", "_entity"];
private _Evading = _entity GetVariable "Evading";
	if(FSMD3Bugger)
	then{
			
			if(!isnil "_Evading")
			then{
					private _Text = (parsetext format ["Be carefull deleting units while they are engaged / activated. <br/>This could lead to scripts not exiting properly<br/>**DCO Vehicle FSM**"]);
					
					[_Text] remoteExec ["Hint", 0];
				};
		};
		diag_log "*******************************";
		diag_log "A vehicle was deleted while script was running  (DCO Vehicle FSM)";
		diag_log "*******************************";
	
}];

_x addEventHandler ["CuratorObjectPlaced", {
	params ["_curator", "_entity"];
	/*_entity setOwner 2;*/
	
	Private _Group = Group _Entity;
	private _excluded = [_Group] call Tally_Fnc_ExcludeP_group;
	
	if(!Isnil "_Group"
	&&{!(_excluded)})
	then{
			_Group setGroupOwner 2;
		};
	
}];

}ForEach allCurators;