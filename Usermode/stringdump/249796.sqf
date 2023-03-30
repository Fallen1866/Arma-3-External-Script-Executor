{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleEffectsShells'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleEffectsShells';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsShells.sqf [BIS_fnc_moduleEffectsShells]"
#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsShells.sqf"














_logic = _this;
_emitterArray = _logic getVariable "effectEmitter";
_emitter = _emitterArray select 0;
_pos = getPos _logic;

_pos = [_pos select 0,_pos select 1,0.2];
_typeArray = [
"\A3\weapons_f\ammo\cartridge.p3d",
"\A3\weapons_f\ammo\cartridge_127.p3d",
"\A3\weapons_f\ammo\cartridge_65.p3d",
"\A3\weapons_f\ammo\cartridge_762.p3d",
"\A3\weapons_f\ammo\cartridge_slug.p3d",
"\A3\weapons_f\ammo\cartridge_small.p3d"
];

_emitter setPos _pos;


_typeId = parseNumber (_logic getVariable ["Type","0"]);
_size = _logic getVariable ["Size",1];
_number = _logic getVariable ["Density",20];
_lifeTime = _logic getVariable ["LifeTime",60];
_radius = _logic getVariable ["Radius",1];


_int = 0;
_intDrop = 0;
if (_number > 2000) then {	
_int = _number * 0.0001;
_intDrop = 0.0001;
} else {
_int = 0.2;
_intDrop = 0.2/_number;
};

_size = if !(_size < 0) then {_size} else {1};
_lifeTime = if !(_lifeTime <= 0) then {_lifeTime} else {60};
_lifeTimeVar = if (_lifeTime < 100) then {_lifeTime/10} else {10};
_type = if ((_typeId < (count _typeArray)) && !(_typeId < 0)) then {_typeArray select _typeId} else {_typeArray select 0};
_expectedNumber = if (isNil {BIS_fnc_moduleEffectsShells_count}) then {_number} else {BIS_fnc_moduleEffectsShells_count + _number};

if (_expectedNumber > 2000) then {
debugLog format ["PARTICLE MODULE - WARNING: Cartridge effect modules created %1 particles! Hard limit is 3000, there won't be more particles created!",_expectedNumber];
};

if ((_number > 0) && (_expectedNumber < 3000)) then {
if (isNil {BIS_fnc_moduleEffectsShells_count}) then {
BIS_fnc_moduleEffectsShells_count = _number;
publicVariable "BIS_fnc_moduleEffectsShells_count";
} else {
BIS_fnc_moduleEffectsShells_count = BIS_fnc_moduleEffectsShells_count + _number;
publicVariable "BIS_fnc_moduleEffectsShells_count";
};


_emitter setParticleParams [_type, "", "SpaceObject", 1, _lifeTime, [0, 0, 0], [0, 0, -5], 3, 6, 1, 0, [_size],
[[0.9,0.9,09.,1]], [1], 0.1, 0.05, "", "", "",0,false,0.1];


_emitter setParticleRandom [_lifeTimeVar, [_radius/2,_radius/2,0], [0.5,0.5,0], 0, 0, [0,0,0,1], 0, 0];

_emitter setParticleCircle [_radius/2,[0,0,0]];


_emitter setDropInterval _intDrop;
sleep _int;
[_lifeTime + _lifeTimeVar,_number] spawn {
scriptName "fn_moduleEffectsShells_effectLoop";
sleep (_this select 0); 
BIS_fnc_moduleEffectsShells_count = BIS_fnc_moduleEffectsShells_count - (_this select 1);
publicVariable "BIS_fnc_moduleEffectsShells_count";
};
};
deleteVehicle _emitter;}
