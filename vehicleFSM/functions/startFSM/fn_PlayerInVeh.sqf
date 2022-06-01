params["_Vehicle"];
Private _InVeh = false;

{
If (!((_X Getvariable "bis_fnc_moduleRemoteControl_owner") isEqualTo "")
or (IsPlayer _X))
then {_InVeh = true};
}ForEach (Crew _Vehicle);

if!(_InVeh)
then{
				{
					if((vehicle _X) == _Vehicle)
					exitwith{
								_InVeh = true;
							};
				} ForEach 
				AllPlayers;
	};

_InVeh