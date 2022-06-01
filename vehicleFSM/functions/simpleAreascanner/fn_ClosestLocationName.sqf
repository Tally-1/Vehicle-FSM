params ["_position", "_Radius"];
private _ret = "Wilderness";
private _allLocationTypes = ["NameCity", /*"NameVillage", "NameLocal",*/ "NameCityCapital"];
{
    if ((text _x) isNotEqualTo "") exitWith {_ret = text _x; _ret};
} forEach nearestLocations [_position, _allLocationTypes, _Radius];



_ret