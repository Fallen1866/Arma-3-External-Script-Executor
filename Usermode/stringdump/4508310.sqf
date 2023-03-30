{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleEffectsPlankton'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleEffectsPlankton';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsPlankton.sqf [BIS_fnc_moduleEffectsPlankton]"
#line 1 "A3\modules_f\Effects\functions\fn_moduleEffectsPlankton.sqf"














_logic = _this;
_player = player;

_emitter = (_logic getVariable "effectEmitter") select 0;
_emitter setParticleClass "PlanktonEffect";
_emitter attachto [player,[0,2,1.3]];

[_logic,_player,_emitter] spawn {
scriptName "fn_moduleEffectsPlankton_loop";
_logic = _this select 0;
_player = _this select 1;
_emitter = _this select 2;
_vehicle = vehicle player;

while {_player == player} do {
sleep 2;
if (_vehicle != (vehicle player)) then {
_vehicle = vehicle player;

if (player != vehicle player) then {
_emitter attachto [_vehicle,[0,3,1.3]];
} else {
_emitter attachto [player,[0,2,1.3]];
};
};
};
};}
