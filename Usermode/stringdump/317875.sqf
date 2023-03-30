
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_addVirtualItemCargo'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_addVirtualItemCargo';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_bootcamp\Inventory\fn_addVirtualItemCargo.sqf [BIS_fnc_addVirtualItemCargo]"
#line 1 "A3\functions_f_bootcamp\Inventory\fn_addVirtualItemCargo.sqf"




















params
[
["_object", missionnamespace,[missionnamespace,objnull]],
["_classes",[],["",true,[]]],
["_isGlobal",false,[false]],
["_initAction",true,[true]],
["_add",1,[1]],
["_type",0,[0]]
];


private _cargo = _object getvariable ["bis_addVirtualWeaponCargo_cargo",[[],[],[],[]]];
private _cargoArray = _cargo select _type;

if (_add == 0) exitwith { _cargoArray };


private _save = false;

if !(_classes isEqualType []) then {_classes = [_classes]};

if (count _classes == 0 && _add < 0) then 
{
_cargoArray = [];
_save = true;
} 
else 
{
{

_x = _x param [0,"",["",true]];

if (_x isEqualType true) then { _x = "%ALL" } else { if (_x == "%all") then { _x = "%ALL" } }; 

private _class = switch _type do 
{
case 0;
case 1: { configname (configfile >> "cfgweapons" >> _x) };
case 2: { configname (configfile >> "cfgmagazines" >> _x) };
case 3: { configname (configfile >> "cfgvehicles" >> _x) };
default { "" };
};

if (_class == "") then { _class = _x };

if (_add > 0) then 
{
if (_class != "") then { _cargoArray pushBackUnique _class };
} 
else 
{
_cargoArray = _cargoArray - [_class];
};

_save = true;
} 
foreach _classes;
};

_cargo set [_type, _cargoArray];

if (_save) then { _object setvariable ["bis_addVirtualWeaponCargo_cargo",_cargo,_isGlobal] };

if (!is3DEN && _initAction && _object isEqualType objnull) then 
{
[["AmmoboxExit", "AmmoboxInit"] select ({ count _x > 0 } count _cargo > 0), _object] call bis_fnc_arsenal;
};

_cargoArray 
