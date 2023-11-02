params ["_Vehicle", "_EnemyForce", "_FriendlyForce"];
private _Action		= "hide";
Private _Nounits		= true;
private _EnemySide	= (Side(selectRandom (_Vehicle GetVariable "KnownEnemies")));
private _VehicleType	= (_Vehicle GetVariable "vehicleType");
private _Group		= (group _Vehicle);
private _Leader 		= leader _Group;
private _LeaderDead	= (_Group GetVariable "leader_Killed");

private _NoPushVar	= (_Vehicle GetVariable "noPush");
private _NoflankVar	= (_Vehicle GetVariable "noFlank");
private _NoHideVar	= (_Vehicle GetVariable "noHide");

Private _NoPush		= ((!Isnil "_NoPushVar"  &&{_NoPushVar})
					or (DCOnoPushGlobal));
Private _Noflank	= ((!Isnil "_NoflankVar" &&{_NoflankVar})
					or (DCOnoFlankGlobal));
Private _NoHide		= ((!Isnil "_NoHideVar"  &&{_NoHideVar})
					or (DCOnoHideGlobal));
					
private _NoOptions	= (_NoPush 
					&&{_Noflank 
					&& {_NoHide}});

private _UseCourage = (DCOCourageMultiplier
					&&{(!Isnil "_Leader")
					&&{(!Isnil "_LeaderDead")}});

if(IsNil "_EnemySide")exitWith{"scan"};

_EnemySide = ["enemy: ", _EnemySide] joinString "";

private _FriendSide	= (side _Vehicle);
_FriendSide = ["Friend: ", _FriendSide] joinString "";

if(isNil "_FriendlyForce"
&&{isNil "_FriendlyForce"})
then{_Nounits = false}
else{
		{if(Count _x > 0)then{_Nounits = false}}ForEach _EnemyForce;
		{if(Count _x > 0)then{_Nounits = false}}ForEach _FriendlyForce;
	};




/*The next 20+ lines calculate the odds and recalculate them based of multipliers defined in the init / CBA settings*/
if!(_Nounits)								then{

													private _ThreathLevel 		= ([(_Vehicle GetVariable "KnownEnemies"), _EnemySide] 	call Tally_Fnc_CalcAT2);/*([_EnemyForce] 	call Tally_Fnc_CalcATcapacity);*/
													private _DefensiveCapacity 	= ([(_Vehicle GetVariable "NearFriends"), _FriendSide] 	call Tally_Fnc_CalcAT2);/*([_FriendlyForce] call Tally_Fnc_CalcATcapacity);*/
													
													if(_DefensiveCapacity == 0)	then{_DefensiveCapacity = 0.01};
													if(_ThreathLevel == 0)		then{_ThreathLevel = 0.01};

													private _StrengthBalance	 = Round ((_DefensiveCapacity / _ThreathLevel) * 100);
															_StrengthBalance  = _StrengthBalance * globalAgressionMultiplier;
										
											if(_UseCourage)
											then{
													private _multiplier 	= 1;
													private _avgCourage = [_Group] call Tally_Fnc_GetAVGgroupCourage;
													
													if(_LeaderDead)then{
														
																_multiplier 	= 0.5 / _avgCourage;
																["Leader is dead, average courage is: ", (_avgCourage)] call Tally_fnc_debugMessage;
													}
													else{
															private _courage = (_Leader skill "courage");
															if(_courage == 0) then{_courage = 0.0001};
															_multiplier = 0.5 / _courage;
														};
													
													_StrengthBalance = _StrengthBalance * _multiplier;
													
												};
													


													If 	(_StrengthBalance > 70 
													&& 	{_StrengthBalance < 130})
													then{
															_Action	= "flank";
														};

													If 	(_StrengthBalance > 130)
													then{
															_Action	= "push";
															
															
														};

													if((_DefensiveCapacity 	==	1234567890)
													or (_ThreathLevel 		==	1234567890))
													then{
															_Action	= "scan";
														};
												}
										   else {
													_Action	= "end";
													if(FSMD3Bugger)
													then{
															Diag_Log "________________________________";
															Diag_Log FORMAT["side: %1", (side _Vehicle)];
															Diag_Log FORMAT["Enemies: %1", (_EnemyForce)];
															Diag_Log FORMAT["Friends: %1", (_FriendlyForce)];
															Diag_Log "________________________________";
														};
													
												};

If((_VehicleType == "Artillery")
or((_Vehicle IsKindof "Helicopter"))
or(count allTurrets _Vehicle < 1)
or((count crew _Vehicle) < 2))
then{
		_Action	= "hide";
	};


if(_Action == "push")
then 	{
			if(_NoPush)
			then{
				if!(_Noflank)
				then{
						_Action	= "flank";
					}
				else{
						if!(_NoHide)
						then{
								_Action	= "hide";
							};
					};
				};
		};

if(_Action == "flank")
then 	{
			if(_Noflank)
			then{
				if!(_NoPush)
				then{
						_Action	= "push";
					}
				else{
						if!(_NoHide)
						then{
								_Action	= "hide";
							};
					};
				};
		};

if(_Action == "hide")
then 	{
			if(_NoHide)
			then{
				if!(_Noflank)
				then{
						_Action	= "flank";
					}
				else{
						if!(_NoPush)
						then{
								_Action	= "push";
							};
					};
				};
		};



if(_NoOptions)
then{
		_Action = "end";
	};

_Action