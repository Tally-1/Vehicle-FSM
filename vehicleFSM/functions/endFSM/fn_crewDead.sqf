private _AllDead = true;
params ["_Vehicle"];
private _Group = (group _Vehicle);

if(IsNil "_Vehicle")	exitWith{true};
if(IsNil "_Group")		exitWith{true};
if(!Alive _Vehicle)		exitWith{true};
if(IsNull _Group) 		exitWith{true};

{
	if(Alive _X)exitWith{_AllDead = false};
}ForEach 
(Crew _Vehicle);

if!((crew _Vehicle)isEqualTo([]))
then{_AllDead = false};



_AllDead