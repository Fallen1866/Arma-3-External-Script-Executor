#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_diagPreview.sqf"















private ["_mode","_parentName","_distance","_initPos","_createobject","_container","_containerCount","_container","_posX","_posY","_classes","_class","_scope","_parents","_objectpos","_classname","_object"];

_mode = _this param [0,"cfgVehicles",[""]];
_parentName = _this param [1,typeof player,[""]];
_distance = _this param [2,10,[0]];
_initPos = _this param [3,if (is3den) then {screentoworld [0.5,0.5]} else {position player}];
_initPos = _initPos call bis_fnc_position;
_initPosX = _initPos select 0;
_initPosY = _initPos select 1;

_createObject = switch (tolower _mode) do {
	case "cfgvehicles": {
		{
			if (is3DEN) then {
				create3denentity ["Object",_classname,_objectpos,true];
			} else {
				createvehicle [_classname,_objectpos,[],0,"none"];
			};
		};
	};
	case "cfgweapons": {
		{
			private ["_holder"];
			_holder = createvehicle ["weaponholder",_objectpos,[],0,"none"];
			_holder addweaponcargo [_classname,1];
			{
				_holder addmagazinecargo [_x,1];
			} foreach getarray (_class >> "magazines");
			_holder
		};
	};
	default {0}
};

if (typename _createObject != typename {}) exitwith {["Mode '%1' is incorrect. Must be one of 'CfgVehicles', 'CfgWeapons'",_mode] call bis_fnc_error; []};


_container = configfile >> _mode;
_containerCount = count _container - 1;
_parent = _container >> _parentName;
if !(isclass _parent) exitwith {["Parent class '%1' not found in %2",_parentName,_mode] call bis_fnc_error};


_posX = 1;
_posY = 0;
if !(isnil "bis_fnc_diagPreview_objects") then {
	if (is3den) then {
		delete3denentities bis_fnc_diagPreview_objects;
	} else {
		{deletevehicle _x} foreach bis_fnc_diagPreview_objects;
	};
};
bis_fnc_diagPreview_objects = [];
_classes = [];


_fnc_spawn = {
startloadingscreen [""];
	for "_i" from 0 to _containerCount do {

		_class = _container select _i;
		if (isclass _class) then {
			_scope = getnumber (_class >> "scope");
			if (_scope > 0) then {
				_parents = [_class] call bis_fnc_returnparents;
				if (_parent in _parents) then {

					_objectPosX = [_initPos,_distance * _posX,direction player] call bis_fnc_relpos;
					_objectPos = [_objectPosX,_distance * _posY,direction player + 90] call bis_fnc_relpos;

					_classname = configname _class;
					_object = call _createObject;
					_object setpos _objectpos;
					_object setdir direction player;
					player reveal _object;
					bis_fnc_diagPreview_objects set [count bis_fnc_diagPreview_objects,_object];
					_classes set [count _classes,_classname];

					_posX = _posX + 1;
					if (_posX > 10) then {_posX = 0; _posY = _posY + 1};
				};
			};
		};
		progressloadingscreen (_i / _containerCount);
	};
	endloadingscreen;
};
if (is3den) then {
	collect3denhistory {call _fnc_spawn};
} else {
	call _fnc_spawn;
};
_classes
