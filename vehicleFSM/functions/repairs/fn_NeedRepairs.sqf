params["_Vehicle"];
private _NeedRepairs = false;
private _Damage		 = (GetDammage _Vehicle);

if (!CanMove _Vehicle
or !CanFire _Vehicle
or _Damage > 0.5)
then{
	if(Alive _Vehicle)
	then{
			_NeedRepairs = true;
		};
	};

_NeedRepairs