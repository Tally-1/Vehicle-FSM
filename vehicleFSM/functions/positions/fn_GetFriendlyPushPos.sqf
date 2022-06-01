params["_Vehicle"];
Private _Friends = [_Vehicle, true] call Tally_Fnc_GetNearFriends;
Private _Center = (_Vehicle GetVariable "centro");
Private _PushPositions = [];

{
if(count _PushPositions > 30)exitWith{};

if(_x GetVariable "Evading")
then{
		Private _CloseCenter = (_x GetVariable "centro");
		
		if((_Center distance2d _CloseCenter) < 100)
		then{
				Private _Positions = (_x GetVariable "PushPositions");
				
				if(count _Positions > 0)
				then {
						for "_I" from 0 to (count _Positions - 1) do
						{
							private _Pos = _Positions select _I;
							_PushPositions pushBackUnique _Pos;
						};
					 };
			};
	};

}ForEach _Friends;


_PushPositions