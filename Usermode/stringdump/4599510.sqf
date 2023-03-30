{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleGrenade'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleGrenade';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Effects\functions\fn_moduleGrenade.sqf [BIS_fnc_moduleGrenade]"
#line 1 "A3\modules_f\Effects\functions\fn_moduleGrenade.sqf"
_mode = _this select 0;
_params = _this select 1;
_logic = _params select 0;

switch _mode do {

case "attributesChanged3DEN";


case "registeredToWorld3DEN": {
_ammo = _logic getvariable ["type",gettext (configfile >> "cfgvehicles" >> typeof _logic >> "ammo")];
if (_ammo != "") then {


_projectile = _logic getvariable ["bis_fnc_moduleGrenade_projectile",objnull];
deletevehicle _projectile;


if (is3DEN || (_logic getvariable ["repeat",0] > 0)) then {

_ammoInfinite = _ammo + "_Infinite";
if (isclass (configfile >> "cfgammo" >> _ammoInfinite)) then {_ammo = _ammoInfinite;};
};
_pos = getposatl _logic;
_projectile = createvehicle [_ammo,_pos,[],0,"none"];
_projectile setposatl _pos;

if (is3DEN) then {

_logic setvariable ["bis_fnc_moduleGrenade_projectile",_projectile];
} else {

_projectile attachto [_logic,[0,0,0]];


waituntil {
sleep 1;
isnull _projectile || isnull _logic
};

deletevehicle _projectile;
deletevehicle _logic;
};
} else {
["Cannot create projectile, 'ammo' config attribute is missing in %1",typeof _logic] call bis_fnc_error;
};
};


case "unregisteredFromWorld3DEN": {
_projectile = _logic getvariable ["bis_fnc_moduleGrenade_projectile",objnull];
deletevehicle _projectile;
};


case "init": {
_activated = _params select 1;
_isCuratorPlaced = _params select 2;


if (_isCuratorPlaced && {local _x} count (objectcurators _logic) > 0) then {

_logic hideobject false;
_logic setpos position _logic;
};


if !(isserver) exitwith {};


if (_activated && !is3DEN) then {
["registeredToWorld3DEN",[_logic]] spawn bis_fnc_moduleGrenade;
};
};
};}
