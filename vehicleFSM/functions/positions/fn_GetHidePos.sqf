private _secondTry = false;
params ["_Vehicle", "_Initiator", "_secondTry"];
private _EvasionPos 	= ( _Vehicle GetVariable "EvadePos");
Private _EnAvgPos 		= (_Vehicle GetVariable "Centro");
private _SelectedArea 	= ((_Vehicle GetVariable "Areas") select 0);
private _SecondArea 	= ((_Vehicle GetVariable "Areas") select 1);
private _ThirdArea 		= ((_Vehicle GetVariable "Areas") select 2);
private _Timer			= time + 3;
private _Nil				= false;
private _CopiedPos		= false;

/*
if (IsNil "_SelectedArea")exitWith	{
										["Cannot get Hide-Positions because the search-area is not defined"] call Tally_fnc_debugMessage;
									};*/

If(_secondTry)
then{
		_Vehicle SetVariable ["TwoTimesHideSearch",	true, true];
	};

If(!IsNil "_Initiator")
then{
Private _InitDistance = (_Initiator distance2d _Vehicle);
if (IsNil "_InitDistance")exitWith{};
if(_InitDistance > 200) exitWith{};
		waituntil{
					sleep 0.1;
					private _Loaded 	= (_Initiator GetVariable "HiddenPosLoaded");
					private _TimedOut 	= (_Timer < time);
					
					if(IsNil "_Loaded")exitWith{true};
					
					if(_TimedOut
					or _Loaded)
					exitWith{true};
					false
				  };
		
		private _FriendlyHidePositions = (_Initiator GetVariable "HidePositions");
		
		if(Isnil "_FriendlyHidePositions")exitWith{};
		
		if(((count _FriendlyHidePositions) > 5)
		&&{(_Initiator GetVariable "HiddenPosLoaded")})
		then{
				_Vehicle SetVariable ["HidePositions", _FriendlyHidePositions, 	true];
				_Vehicle SetVariable ["HiddenPosLoaded",true, 				true];
				_CopiedPos = true;
				["Hiding positions were copied from ", _Initiator] call Tally_fnc_debugMessage;
			};
	};

if!(_CopiedPos)
then{
		
		private _Script = [_SelectedArea 	select 0,
						  _SelectedArea		select 1,
						  _Vehicle,
						  true] spawn Tally_Fnc_Scan_Area;
		waituntil	{
						sleep 0.05;
						private _ScriptDone = (scriptDone _Script);
						private _TimedOut 	= (time > _Timer);
								_Nil		= (IsNil "_ScriptDone");
								
						if(_Nil 
						or _ScriptDone
						or _TimedOut) 
						exitWith {
									true
								};
						false
					};



		if (count (_Vehicle GetVariable "HidePositions") < 1)
		then 	{
					["No hiding positions was found, scanning second area"] call Tally_fnc_debugMessage;
					
					_Script = [_SecondArea 	select 0,
								_SecondArea	select 1,
								_Vehicle,
								true] spawn Tally_Fnc_Scan_Area;
						
						waituntil	{
						sleep 0.05;
						private _ScriptDone = (scriptDone _Script);
						private _TimedOut 	= (time > _Timer);
								_Nil		= (IsNil "_ScriptDone");
								
						if(_Nil 
						or _ScriptDone
						or _TimedOut) 
						exitWith {
									true
								};
						false
					};
		
					if (count (_Vehicle GetVariable "HidePositions") < 1)
					then 	{
								["No hiding positions was found, scanning third area"] call Tally_fnc_debugMessage;
								
								_Script = [_ThirdArea 	select 0,
											_ThirdArea	select 1,
											_Vehicle,
											true] spawn Tally_Fnc_Scan_Area;
									
									waituntil	{
									sleep 0.05;
									private _ScriptDone = (scriptDone _Script);
									private _TimedOut 	= (time > _Timer);
											_Nil		= (IsNil "_ScriptDone");
											
									if(_Nil 
									or _ScriptDone
									or _TimedOut) 
									exitWith {
												true
											};
									false
								};
		
							};
			};

	};


[_Vehicle, _EnAvgPos] 	call Tally_Fnc_FilterHidePos;