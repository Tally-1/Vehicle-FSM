params ["_Group"];
private _excludeGroup = DCOexcludePlayerGroups;

if(_excludeGroup)
then{
		if(!isNil "_Group"
		&&{!isNull _Group})
		then{_excludeGroup = [_Group] call Tally_Fnc_PlayerGroup};
	};

_excludeGroup