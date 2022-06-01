Params ["_Reciever", "_TargetArr"];
if(IsNil "_TargetArr")exitWith{};
Private _Side = (Side _Reciever);
{_Reciever reveal [_x, (_Side knowsAbout _x)]} ForEach _TargetArr;
