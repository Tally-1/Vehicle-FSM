
params["_Vehicle"];


/*This function checks the status of land-vehicles with a 2-3 man crew, returning a number from -1 to 8. The number indicates how big the crew is, and who is killed*/
private _returnValue		= -2;
private _OriginalCrew 		= _Vehicle getVariable "Crew";
if(isnil "_OriginalCrew")exitWith{-1};
private _OriginalDriver 	= _Vehicle getVariable "driver";
private _OriginalGunner 	= _Vehicle getVariable "gunner";
private _thirdMan			= "";
private _CrewSize 			= count _OriginalCrew;
private _AllDead 			= true;
private _AllAlive 			= true;

{if( Alive _x)then{ _AllDead  = false; }}ForEach _OriginalCrew;
{if(!Alive _x)then{ _AllAlive = false; }}ForEach _OriginalCrew;

if(_AllDead)then {_returnValue = -1};
if(_AllAlive)then{_returnValue =  0};

if (_CrewSize == 2)then {
							if(!alive 		_OriginalDriver							
							&& (alive 		_OriginalGunner))
							then{_returnValue =  1};
							
							if(!alive 		_OriginalGunner							
							&& (alive 		_OriginalDriver))
							then{_returnValue =  2};
						};




if (_CrewSize == 3)then {

{
if!(_x == _OriginalDriver 
or  _x == _OriginalGunner)then{_thirdMan = _x};
}ForEach _OriginalCrew;

							if	(!alive 	_OriginalDriver
							
							&& 	(alive 		_OriginalGunner)
							&& 	(alive 		_thirdMan))
							then{_returnValue =  3};
							
							
							
							if	(!alive 	_OriginalGunner 
							
							&& 	(alive 		_OriginalDriver)
							&& 	(alive 		_thirdMan))
							then{_returnValue =  4};
							
							
							
							if	(!alive 	_thirdMan
							
							&& 	(alive 		_OriginalDriver)
							&& 	(alive 		_OriginalGunner))
							then{_returnValue =  5};
							
							
							if	(!alive 	_thirdMan
							&& 	(!alive 	_OriginalGunner)
							
							&& 	(alive 		_OriginalDriver))
							then{_returnValue =  6};
							
							
							if	(!alive 	_OriginalDriver
							&& 	(!alive 	_thirdMan)
							
							&& 	(alive 		_OriginalGunner))
							then{_returnValue =  7};
							
							
							if	(!alive 	_OriginalDriver
							&& 	(!alive 	_OriginalGunner)
							
							&& 	(alive 		_thirdMan))
							then{_returnValue =  8};
						
						};




_returnValue