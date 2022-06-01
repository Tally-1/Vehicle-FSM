params["_group"];
Private _PlayerGroup = false;

{
If (!((_X Getvariable "bis_fnc_moduleRemoteControl_owner") isEqualTo "")
or (IsPlayer _X))
then {_PlayerGroup = true};
}ForEach (units _group);

if!(_PlayerGroup)
then{
				{
					if((group _X) == _group)
					exitwith{
								_PlayerGroup = true;
							};
				} ForEach 
				AllPlayers;
	};

_PlayerGroup