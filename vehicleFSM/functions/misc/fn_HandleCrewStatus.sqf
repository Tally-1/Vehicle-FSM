
/*This function has the crew react in accordance with losses, making sure that the vehicle stays operational even if a crew-member is killed*/
params ["_Vehicle", "_Status"];
_Vehicle setVariable ["switching", true, true];

private _OriginalCrew 		= _Vehicle getVariable "Crew";
private _OriginalDriver 	= _Vehicle getVariable "driver";
private _OriginalGunner 	= _Vehicle getVariable "gunner";
private _thirdMan			= "";

if (isnil "_OriginalCrew")exitWith{["Crew variable not loaded properly"] call Tally_fnc_debugMessage};

{
if!(_x == _OriginalDriver 
or  _x == _OriginalGunner)then{_thirdMan = _x};
}ForEach _OriginalCrew;
if(_thirdMan isEqualTo "")then{_thirdMan = (Commander _Vehicle)};

switch _Status do
{
	case -1: {
				 {
					_x action ["Eject", _Vehicle];
					_X setVariable ["Vehicle", 	nil,  true];
				 }ForEach _OriginalCrew;
				 
				 _Vehicle setVariable ["crew", [], true];
				 _Vehicle setVariable ["crewStatus", "All dead", true];
				 
			 };
	case 1:  {
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				_OriginalGunner action ["Eject", _Vehicle];
				sleep 1;
				_OriginalGunner assignAsDriver _Vehicle;
				_OriginalGunner action ["getInDriver", _Vehicle];
				sleep 1;
				_Vehicle setVariable ["Crew",  [_OriginalGunner], true];
				_Vehicle setVariable ["driver", _OriginalGunner,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
				sleep 1;
			};
	case 2:  {
				_Vehicle setVariable ["Crew",  [_OriginalDriver], true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 3:  {
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				
				if(typeName _thirdMan == "object")
				then{
				_thirdMan moveinDriver _Vehicle;
				_thirdMan assignAsDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalGunner, _thirdMan], true];
				_Vehicle setVariable ["driver", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
				}
				else{
						["Could not change seats in : ", ([_Vehicle] call Tally_Fnc_GetVehicleType)] call Tally_fnc_debugMessage;
					};
			 };
	case 4:  {
				_OriginalGunner action ["Eject", _Vehicle];
				 unassignVehicle _OriginalGunner;
				 if(typeName _thirdMan == "object")
				then{
				_thirdMan assignAsGunner _Vehicle;
				_thirdMan moveinGunner _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalDriver, _thirdMan], true];
				_Vehicle setVariable ["gunner", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
				}
				else{
						["Could not change seats in : ", ([_Vehicle] call Tally_Fnc_GetVehicleType)] call Tally_fnc_debugMessage;
					};
	
			 };
	case 5:  {
				_thirdMan action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;
				_Vehicle setVariable ["Crew",  [_OriginalDriver, _thirdMan], true];
				_Vehicle setVariable ["crewStatus", "Operational", true];
			 };
	case 6:  {
				_thirdMan action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;
				_OriginalGunner action ["Eject", _Vehicle];
				unassignVehicle _OriginalGunner;
				_Vehicle setVariable ["Crew",  [_OriginalDriver], true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 7:  {
				_thirdMan 		action ["Eject", _Vehicle];
				unassignVehicle _thirdMan;				
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalDriver;
				sleep 1;
				_OriginalGunner assignAsDriver _Vehicle;
				_OriginalGunner moveinDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_OriginalGunner], true];
				_Vehicle setVariable ["driver", _OriginalGunner,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	case 8:  {
				_OriginalGunner	action ["Eject", _Vehicle];
				_OriginalDriver action ["Eject", _Vehicle];
				unassignVehicle _OriginalGunner;
				unassignVehicle _OriginalDriver;
				sleep 1;
				_thirdMan assignAsDriver _Vehicle;
				_thirdMan moveinDriver _Vehicle;
				_Vehicle setVariable ["Crew",  [_thirdMan], true];
				_Vehicle setVariable ["driver", _thirdMan,  true];
				_Vehicle setVariable ["crewStatus", "driver alive", true];
			 };
	default  {};
};

_Vehicle setVariable ["switching", false, true];