#line 0 "/temp/bin/A3/Functions_F/Inventory/fn_limitWeaponItems.sqf"































params
[
	["_unit",objNull,[objNull]],
	["_mode",0,[999]],
	["_opticsChance",50,[999,[]]],
	["_sideChance",50,[999,[]]],
	["_muzzleChance",50,[999,[]]],
	["_underChance",50,[999,[]]]
];


if (isNull _unit) exitWith {["Weapon items removal: unit %1 does not exist.",_unit] call BIS_fnc_logFormat; false};
if (!(_mode in [0,1,2])) exitWith {["Wrong mode %1, use 0, 1 or 2",_mode] call BIS_fnc_logFormat; false};
if ((_muzzleChance isEqualType 999) and {(_muzzleChance < 0) or (_muzzleChance > 100)}) exitWith {["Weapon items removal: muzzle chance %1 not 0-100.",_muzzleChance] call BIS_fnc_logFormat; false};
if ((_muzzleChance isEqualType []) and {count _muzzleChance != 2}) exitWith {["Weapon items removal: wrong format for muzzle attachment: %1.",_muzzleChance] call BIS_fnc_logFormat; false};
if ((_sideChance isEqualType 999) and {(_sideChance < 0) or (_sideChance > 100)}) exitWith {["Weapon items removal: side attachment chance %1 not 0-100.",_sideChance] call BIS_fnc_logFormat; false};
if ((_sideChance isEqualType []) and {count _sideChance != 2}) exitWith {["Weapon items removal: wrong format for side attachment: %1.",_sideChance] call BIS_fnc_logFormat; false};
if ((_opticsChance isEqualType 999) and {(_opticsChance < 0) or (_opticsChance > 100)}) exitWith {["Weapon items removal: optics chance %1 not 0-100.",_opticsChance] call BIS_fnc_logFormat; false};
if ((_opticsChance isEqualType []) and {count _opticsChance != 2}) exitWith {["Weapon items removal: wrong format for optics: %1.",_opticsChance] call BIS_fnc_logFormat; false};
if ((_underChance isEqualType 999) and {(_underChance < 0) or (_underChance > 100)}) exitWith {["Weapon items removal: underbarrel chance %1 not 0-100.",_underChance] call BIS_fnc_logFormat; false};
if ((_underChance isEqualType []) and {count _underChance != 2}) exitWith {["Weapon items removal: wrong format for underbarrel attachment: %1.",_underChance] call BIS_fnc_logFormat; false};


if (count (getUnitLoadout _unit select _mode) > 0)
then
{
	_unitWeaponInfo = getUnitLoadout _unit select _mode;

	private _unitWeapon = _unitWeaponInfo select 0;
	private _unitWeaponMuzzle = _unitWeaponInfo select 1;
	private _unitWeaponSide = _unitWeaponInfo select 2;
	private _unitWeaponOptics = _unitWeaponInfo select 3;
	private _unitWeaponPMag = _unitWeaponInfo select 4;
	private _unitWeaponSMag = _unitWeaponInfo select 5;
	private _unitWeaponUnder = _unitWeaponInfo select 6;

	
	if ((_muzzleChance isEqualType 999) and {(_unitWeaponMuzzle != "")}) then
		{
		_random = random 100;
		if (_random > _muzzleChance)
		then
		{
			_unitWeaponMuzzle = "";
		};
	};

	
	if (_muzzleChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _muzzleChance select 1)
		then
		{
			_unitWeaponMuzzle = "";
		}
		else
		{
			_unitWeaponMuzzle = _muzzleChance select 0;
		};
	};

	
	if ((_sideChance isEqualType 999) and {(_unitWeaponSide != "")}) then
		{
		_random = random 100;
		if (_random > _sideChance)
		then
		{
			_unitWeaponSide = "";
		};
	};

	
	if (_sideChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _sideChance select 1)
		then
		{
			_unitWeaponSide = "";
		}
		else
		{
			_unitWeaponSide = _sideChance select 0;
		};
	};

	
	if ((_opticsChance isEqualType 999) and {(_unitWeaponOptics != "")}) then
		{
		_random = random 100;
		if (_random > _opticsChance)
		then
		{
			_unitWeaponOptics = "";
		};
	};

	
	if (_opticsChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _opticsChance select 1)
		then
		{
			_unitWeaponOptics = "";
		}
		else
		{
			_unitWeaponOptics = _opticsChance select 0;
		};
	};

	
	if ((_underChance isEqualType 999) and {(_unitWeaponUnder != "")}) then
		{
		_random = random 100;
		if (_random > _underChance)
		then
		{
			_unitWeaponUnder = "";
		};
	};

	
	if (_underChance isEqualType []) then
	{
		_random = random 100;
		if (_random > _underChance select 1)
		then
		{
			_unitWeaponUnder = "";
		}
		else
		{
			_unitWeaponUnder = _underChance select 0;
		};
	};

	
	_unitWeaponFinal = [_unitWeapon, _unitWeaponMuzzle, _unitWeaponSide, _unitWeaponOptics, _unitWeaponPMag, _unitWeaponSMag, _unitWeaponUnder];

	
	if (_mode == 0) then {_unit setUnitLoadout [_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil,nil,nil]};
	if (_mode == 1) then {_unit setUnitLoadout [nil,_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil,nil]};
	if (_mode == 2) then {_unit setUnitLoadout [nil,nil,_unitWeaponFinal,nil,nil,nil,nil,nil,nil,nil]};
}
else
{
	["Unit %1 doesn't have needed weapon",_unit] call BIS_fnc_logFormat;
	false
};

true

