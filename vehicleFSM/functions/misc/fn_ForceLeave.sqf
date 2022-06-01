params ["_Unit", "_NewGroup"];
private _OldGroup = (group _Unit);
private _Timer = time + 3;

_OldGroup  setGroupOwner 2;
_NewGroup setGroupOwner 2;

[_Unit] joinSilent _NewGroup;

while
		{(Group _Unit == _OldGroup)
		&& 
		(_Timer > time)}	Do	{
									[_Unit] joinSilent _NewGroup;
									sleep 0.02;
								};
[_Unit] joinSilent _NewGroup;
