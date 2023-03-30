#line 0 "/temp/bin/A3/Functions_F/Arrays/fn_setToPairs.sqf"














#line 1 "//temp/bin/A3/Functions_F/paramsCheck.inc"
#line 0 "//temp/bin/A3/Functions_F/paramsCheck.inc"


#line 15 "/temp/bin/A3/Functions_F/Arrays/fn_setToPairs.sqf"

if !(_this isEqualTypeParams [[],""]) exitWith {[_this, "isEqualTypeParams", [[],""]] call (missionNamespace getVariable "BIS_fnc_errorParamsType")};

params ["_pairsArray", "_findKey", ["_newValue", 1]];

private _index = {if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_forEachIndex}} forEach _pairsArray;

if (isNil "_index") exitWith 
{
	_pairsArray pushBack [_findKey, _newValue];
	_pairsArray
};

_pairsArray set [_index, [_findKey, _newValue]];

_pairsArray
