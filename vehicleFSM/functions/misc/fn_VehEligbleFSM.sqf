params ["_Vehicle"];
Private _eligble = false;
Private _Evading = (_Vehicle getVariable "Evading");
private _excludeGroup = [(group _vehicle)] call Tally_Fnc_ExcludeP_group;

if(_Vehicle GetVariable "noPush"
&&{_Vehicle GetVariable "noFlank"
&&{_Vehicle GetVariable "noHide"

}})exitwith{false;};


if 	(!IsNil "_Vehicle" 
&& 	{!(_excludeGroup)
&& 	{Alive _Vehicle
&& 	{((_Vehicle Iskindof "car") 
or 	(_Vehicle Iskindof "Tank"))
&& 	{!(crew _Vehicle IsEqualTo [])
&& 	{Alive (driver _Vehicle)
&& 	{true /*CanMove _Vehicle*/
&& 	{IsNil "_Evading"
&&	{true /*count allTurrets _Vehicle > 0*/
&&	{!(fuel _Vehicle == 0)
&&	{!([_Vehicle] call Tally_Fnc_PlayerInVeh)
&&  {!isNull (group _vehicle)}}}}}}}}}}}) 
				then {_eligble = true};

_eligble