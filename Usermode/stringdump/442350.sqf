
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_modulePostprocess'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_modulePostprocess';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f_curator\effects\functions\fn_modulePostprocess.sqf [BIS_fnc_modulePostprocess]"
#line 1 "a3\modules_f_curator\effects\functions\fn_modulePostprocess.sqf"
_input = _this param [0,"",[objnull,""]];
if (typename _input == typename objnull) then {
private ["_logic","_year","_delay","_overcast","_fog","_rain"];

_logic = _input;
_activated = _this param [2,true,[true]];

if (_activated) then {
if !(_logic call bis_fnc_isCuratorEditable) then {
_commitTime = _logic getvariable ["commitTime",0];
_template = _logic getvariable ["template",""];
_cfgTemplate = configfile >> "CfgPostProcessTemplates" >> _template;
[_cfgTemplate,_commitTime,true] call bis_fnc_setPPeffectTemplate;
};
};
true
} else {
switch (tolower _input) do {
case "enabledelay": {
private ["_enable"];
_enable = _this param [1,true,[true]];
missionnamespace setvariable ["BIS_fnc_modulePostprocess_delay",_enable];
if (isserver) then {publicvariable "BIS_fnc_modulePostprocess_delay";};
};
case "isdelayenabled": {
missionnamespace getvariable ["BIS_fnc_modulePostprocess_delay",false];
};
case "seteffect": {
private ["_value"];
_value = _this param [1,"",["",configfile]];
missionnamespace setvariable ["BIS_fnc_modulePostprocess_value",_value];
publicvariableserver "BIS_fnc_modulePostprocess_value";
};
case "commit": {
_value = missionnamespace getvariable ["BIS_fnc_modulePostprocess_value",""];
_value spawn bis_fnc_setppeffecttemplate;
};
};
};

