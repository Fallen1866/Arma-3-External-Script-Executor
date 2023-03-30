
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleStrategicMapMission'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleStrategicMapMission';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\StrategicMap\functions\fn_moduleStrategicMapMission.sqf [BIS_fnc_moduleStrategicMapMission]"
#line 1 "A3\modules_f\StrategicMap\functions\fn_moduleStrategicMapMission.sqf"
_logic = _this param [0,objnull,[objnull]];
_units = _this param [1,[],[[]]];
_activated = _this param [2,true,[true]];

if (_activated) then {
_pos = position _logic;
_code = _logic getvariable ["Code",""];
_title = _logic getvariable ["Title",""];
_description = _logic getvariable ["Description",""];
_player = _logic getvariable ["Player",""];
_image = _logic getvariable ["Image",""];
_size = _logic getvariable ["Size","1"];
_size = parsenumber _size;

if (typename _code == typename "") then {_code = compile _code;};


_title = _title call bis_fnc_localize;
_description = _description call bis_fnc_localize;

_logic setvariable ["data",[_pos,_code,_title,_description,_player,_image,_size]];
};
