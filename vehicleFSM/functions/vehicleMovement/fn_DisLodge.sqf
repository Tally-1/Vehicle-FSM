params ["_Vehicle"];
private _objects = nearestTerrainObjects [_Vehicle, [], 3, false];

if (count _objects > 0)then{_Vehicle setVelocityModelSpace [0, 10, 0]};