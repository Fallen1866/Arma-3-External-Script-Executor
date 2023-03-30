
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_formatCuratorChallengeObjects'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_formatCuratorChallengeObjects';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_curator\CuratorChallenges\fn_formatCuratorChallengeObjects.sqf [BIS_fnc_formatCuratorChallengeObjects]"
#line 1 "A3\functions_f_curator\CuratorChallenges\fn_formatCuratorChallengeObjects.sqf"













private ["_selectedObjects","_factionObjects","_factions","_text"];

_selectedObjects = [_this] param [0,[],[[]]];
_factionObjects = [];
_factions = [];
{
private ["_faction","_factionID"];
_faction = gettext (configfile >> "cfgvehicles" >> _x >> "faction");
_factionID = _factions find _faction;
if (_factionID < 0) then {
_factionID = count _factions;
_factions set [_factionID,_faction];
_factionObjects set [_factionID,[]];
};
_objects = _factionObjects select _factionID;
_objects set [count _objects,_x];
} foreach _selectedObjects;

_text = "";
{
private ["_cfgFaction","_icon","_displayname"];
_cfgFaction = configfile >> "cfgfactionclasses" >> _x;
_icon = gettext (_cfgFaction >> "icon");
_displayname = gettext (_cfgFaction >> "displayname");
if (_icon != "") then {_text = _text + format ["<img image='%1' height='16' /> ",_icon];};
_text = _text + format ["<font size='16'>%1</font><br />",_displayname];
{
_cfgObject = configfile >> "cfgvehicles" >> _x;
_vehicleclass = gettext (configfile >> "cfgvehicleclasses" >> gettext (_cfgObject >> "vehicleclass") >> "displayname");
if (_vehicleclass == "Modules") then {
_category = gettext (configfile >> "cfgfactionclasses" >> gettext (_cfgObject >> "category") >> "displayname");
_text = _text + "- " + _vehicleclass + " / " + _category + " / " + gettext (_cfgObject >> "displayname") + "<br />";
} else {
_text = _text + "- " + _vehicleclass + " / " + gettext (_cfgObject >> "displayname") + "<br />";
};
} foreach (_factionObjects select _foreachindex);
_text = _text + "<br />";
} foreach _factions;
_text
