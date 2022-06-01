
params["_Vehicle"];
private _AllDead = true;
private _Minimum_Distance = (_Vehicle getVariable "MinDistEnemy");
{
	
	if (alive _x)
	then 	{
				if(_X IsKindof "Man")then{_AllDead = false}
				else{
						if(_X IsKindof "land"
						&&{!([_X] call Tally_Fnc_CrewDead)})then{_AllDead = false}
					};
				
			};
	
} forEach 
(_Vehicle GetVariable "KnownEnemies");

	(_Vehicle GetVariable "KnownEnemies") deleteAt 
	((_Vehicle GetVariable "KnownEnemies") findIf 
	{!alive _x});

_AllDead