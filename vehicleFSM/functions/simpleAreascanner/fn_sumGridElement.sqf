params ["_GridHash", "_element"];
private _sum = 0;
{_sum = _sum + (_x get _element)} forEach _GridHash;

_sum