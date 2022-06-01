params ["_vehicle"];
private _gunners = [];
for "_i" from 0 to ((count (allTurrets _Vehicle))-1) do {

private _unit = _Vehicle turretUnit (allTurrets _Vehicle select _I);
if (!isnil "_unit" 
&&{alive _unit
&&{!(_unit == driver _Vehicle)}}) 
then {
		_gunners pushBackUnique _unit;
	}};
_gunners