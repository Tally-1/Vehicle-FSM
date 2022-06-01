params["_Vehicle"];
Private _Crew = [];
Private _CrewIsDead = true;

	{
			If (Alive _X)then{ _Crew PushBackUnique _X };
	}ForEach 
	Crew _Vehicle;
	if(count _Crew > 0)then{_CrewIsDead = false};

_CrewIsDead