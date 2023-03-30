{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleEffectsEmitterCreator'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleEffectsEmitterCreator';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsEmitterCreator.sqf [BIS_fnc_moduleEffectsEmitterCreator]"
#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsEmitterCreator.sqf"
















_logic = _this param [0,objnull,[objnull]];
_params = getArray (configFile >> "CfgVehicles" >> (typeOf _logic) >> "effectFunction");

_fnc = "";
_nr = 1;
if ((count _params) > 1) then {
_fnc = _params param [0,"",[""]];
_nr = _params param [1,1,[1]];
} else {
_fnc = _params param [0,"",[""]];
};
if (_nr < 1) then {_nr = 1};


if ((_fnc != "") && !(isNull _logic)) then {
_emitterArray = [];
while {_nr > 0} do {
_source = "#particlesource" createVehicle (getPos _logic);
_emitterArray = _emitterArray + [_source];
_nr = _nr - 1;
};
_logic setVariable ["effectEmitter",_emitterArray,true];

if (isMultiplayer) then {
[_logic,_fnc,nil,true] call BIS_fnc_MP;
} else {
_logic call (missionnamespace getvariable _fnc);
};


[_logic] spawn {
scriptName "fn_moduleEffectsEmitterCreator_triggerLoop";
_logic = _this select 0;
_triggerList = synchronizedObjects _logic;
_emitterList = _logic getVariable "effectEmitter";

if ((count _triggerList) > 0) then {
while {(!isNull _logic) && (({!(triggerActivated _x)} count _triggerList) == 0)} do {
sleep (0.8 + random 0.2);
};
{deleteVehicle _x} forEach _emitterList;
};
};
} else {
["No particle emitter created! Missing module logic or function name."] call BIS_fnc_log;
};}
