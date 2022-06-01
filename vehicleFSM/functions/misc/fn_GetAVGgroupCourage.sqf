
params ["_group"];
if(isnil "_group")exitWith{0.5};
private _courageArr = [];
{
if (alive _x)then{
					_courageArr pushback (_X skill "courage");
				 };

}forEach (units _group);

if(count _courageArr < 1)exitWith{0.5};

private _courage = [_courageArr, "GetAVGgroupCourage", true] call Tally_Fnc_GetAVG;

_courage