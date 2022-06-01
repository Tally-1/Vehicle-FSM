params ["_Vehicle"];
private _Crew = (_Vehicle getVariable "crew");
private _Group = group _Vehicle;
if(Isnil "_Group") exitWith{};
units _group doFollow leader _group;