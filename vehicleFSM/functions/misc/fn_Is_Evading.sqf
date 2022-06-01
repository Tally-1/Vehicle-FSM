params ["_Vehicle"];
If(Isnil "_Vehicle")exitWith{false};

Private _IsEvading 	= true;
Private _Evading 	= (_Vehicle getVariable "Evading");

if 	(isnil "_Evading"
or 	(!Alive _Vehicle)
or 	(_Vehicle getVariable "repairing"))
then{_IsEvading = false};

_IsEvading