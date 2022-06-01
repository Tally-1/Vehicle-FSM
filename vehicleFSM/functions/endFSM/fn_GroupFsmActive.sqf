params["_Vehicle"];
private _Active = false;
private _GroupVehicles = [(Group _Vehicle)] call Tally_Fnc_GetGroupVehicles;

_GroupVehicles pushBackUnique _Vehicle;

{

	Private _Evading 		= (_X getVariable "Evading");
			_Evading 		= (!IsNil "_Evading");
			
	if(_Evading)then{_Active = true};
		
}forEach _GroupVehicles;

_Active