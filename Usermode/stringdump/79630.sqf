
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleDiary'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleDiary';
	scriptName _fnc_scriptName;

#line 1 "a3\modules_f_curator\intel\functions\fn_moduleDiary.sqf [BIS_fnc_moduleDiary]"
#line 1 "a3\modules_f_curator\intel\functions\fn_moduleDiary.sqf"
_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated) then {

if (_logic call bis_fnc_isCuratorEditable) then {
waituntil {!isnil {_logic getvariable "RscAttributeDiaryRecord_updated"} || isnull _logic};
};
if (isnull _logic) exitwith {};
sleep 0.1;

_owners = _logic getvariable ["RscAttributeOwners",[]];
_data = [_logic,"RscAttributeDiaryRecord",["","",""]] call bis_fnc_getServerVariable;
_title = _data select 0;
_text = _data select 1;
_texture = _logic getvariable ["RscAttributeDiaryRecord_texture",""];

if (_texture != "") then {_text = _text + format ["<br /><img image='%1' height='200px' />",_texture];};
if ((side group player in _owners || group player in _owners || player in _owners) && _title != "") then {
player creatediaryrecord ["Diary",[_title,_text]];
["intelAdded",[_title,_texture]] call bis_fnc_showNotification;
};


if (isserver) then {
{
_x removecuratoreditableobjects [[_logic]];
} foreach (objectcurators _logic);
};
};
