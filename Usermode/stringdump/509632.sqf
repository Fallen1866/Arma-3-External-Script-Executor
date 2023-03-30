
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_garage3DEN'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_garage3DEN';
	scriptName _fnc_scriptName;

#line 1 "A3\functions_f_mark\Vehicles\fn_garage3DEN.sqf [BIS_fnc_garage3DEN]"
#line 1 "A3\functions_f_mark\Vehicles\fn_garage3DEN.sqf"

#line 1 "A3\functions_f_mark\Vehicles\fn_garage.sqf"
if (is3DEN && {_fnc_scriptName == "bis_fnc_garage"}) exitwith {_this call bis_fnc_garage3DEN;};

#line 1 "A3\ui_f\hpp\defineDIKCodes.inc"






























































































































































































#line 3 "A3\functions_f_mark\Vehicles\fn_garage.sqf"

#line 1 "A3\Ui_f\hpp\defineResinclDesign.inc"







































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































#line 4 "A3\functions_f_mark\Vehicles\fn_garage.sqf"




disableserialization;

_mode = [_this,0,"Open",[displaynull,""]] call bis_fnc_param;
_this = [_this,1,[]] call bis_fnc_param;
_fullVersion = missionnamespace getvariable ["BIS_fnc_arsenal_fullGarage",false];

















































private _fnc_compareTextures = 
{
params ["_vehtex", "_cfgtex"];
if (_cfgtex isEqualTo "") exitWith { true }; 
if (_vehtex find "\" != 0) then {_vehtex = "\" + _vehtex};
if (_cfgtex find "\" != 0) then {_cfgtex = "\" + _cfgtex};
_vehtex == _cfgtex
};

private _checkboxTextures = 
[
tolower gettext (configfile >> "RscCheckBox" >> "textureUnchecked"),
tolower gettext (configfile >> "RscCheckBox" >> "textureChecked")
];

switch _mode do {


case "Open": {
if !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull])) exitwith {"Garage Viewer is already running" call bis_fnc_logFormat;};
missionnamespace setvariable ["BIS_fnc_arsenal_fullGarage",[_this,0,false,[false]] call bis_fnc_param];

with missionnamespace do {
BIS_fnc_garage_center = [_this,1,missionnamespace getvariable ["BIS_fnc_garage_center",player],[objnull]] call bis_fnc_param;
};
with uinamespace do {
_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
_displayClass = "RscDisplayGarage";
if !(isnull finddisplay 312) then {_displayMission = finddisplay 312;};
if (is3DEN) then {_displayMission = finddisplay 313; _displayClass = "RscDisplayGarage3DEN";};
_displayMission createdisplay _displayClass;
};
};


case "Init": {
["BIS_fnc_arsenal"] call bis_fnc_startloadingscreen;
_display = _this select 0;
_toggleSpace = uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false];
BIS_fnc_arsenal_type = 1; 
BIS_fnc_arsenal_toggleSpace = nil;
BIS_fnc_garage_turretPaths = [];
if (isnil "BIS_fnc_garage_centerType") then {BIS_fnc_garage_centerType = "";};
setstatvalue ["MarkVirtualVehicleInspection",1];

with missionnamespace do {
BIS_fnc_arsenal_group = creategroup side group player;
BIS_fnc_arsenal_center = missionnamespace getvariable ["BIS_fnc_garage_center",player];
};


_classDefault = uinamespace getvariable ["bis_fnc_garage_defaultClass",""];
if (isclass (configfile >> "cfgvehicles" >> _classDefault)) then {
_vehModel = gettext (configfile >> "cfgvehicles" >> _classDefault >> "model");
if (getnumber (configfile >> "cfgvehicles" >> _classDefault >> "forceInGarage") > 0) then {_vehModel = _vehModel + ":" + _classDefault;};
bis_fnc_garage_centerType = _vehModel;
};
uinamespace setvariable ["bis_fnc_garage_defaultClass",nil];


if (isnil {uinamespace getvariable "BIS_fnc_garage_stats"}) then {
_defaultCrew = gettext (configfile >> "cfgvehicles" >> "all" >> "crew");
uinamespace setvariable [
"BIS_fnc_garage_stats",
[

("isclass _x && {getnumber (_x >> 'scope') == 2} && {gettext (_x >> 'crew') != _defaultCrew}" configclasses (configfile >> "cfgvehicles")),
	["maxspeed","armor","fuelcapacity","threat"],	[false,true,false,false]
] call bis_fnc_configExtremes
];
};


["InitGUI",[_display,"bis_fnc_garage"]] call bis_fnc_arsenal;
["Preload"] call BIS_fnc_garage;
["ListAdd",[_display]] call BIS_fnc_garage;

if (BIS_fnc_garage_centerType == "") then {["buttonRandom",[_display]] call BIS_fnc_garage;};
["MouseZChanged",[controlnull,0]] call BIS_fnc_arsenal; 
{
_ctrl = _display displayctrl _x;
_ctrl ctrlsetfade 0;
} foreach [		1804];

_ctrl = _display displayctrl 			1803;
_ctrl ctrlshow false;

with missionnamespace do {
[missionnamespace,"garageOpened",[_display,_toggleSpace]] call bis_fnc_callscriptedeventhandler;
};
["BIS_fnc_arsenal"] call bis_fnc_endloadingscreen;
};


case "Exit": {
with missionnamespace do {
BIS_fnc_garage_center = BIS_fnc_arsenal_center;







};
BIS_fnc_garage_turretPaths = nil;

with missionnamespace do {
[missionnamespace,"garageClosed",[displaynull,uinamespace getvariable ["BIS_fnc_arsenal_toggleSpace",false]]] call bis_fnc_callscriptedeventhandler;
};
"Exit" call bis_fnc_arsenal;
};


case "Preload": {
if (is3DEN) then {


["bis_fnc_garage_preload"] call bis_fnc_startloadingscreen;
private ["_data"];
_data = [];
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerFaction = faction _center;
{
_items = [];
{
_configName = configname _x;
_displayName = gettext (_x >> "displayName");
_factions = getarray (_x >> "factions");
if (count _factions == 0) then {_factions = [_centerFaction];};
if (
_displayName != ""
&&
{getnumber (_x >> "scope") > 1 || !isnumber (_x >> "scope")}
&&
{{_x == _centerFaction} count _factions > 0}
) then {
_items pushback [_x,_displayName];
};
} foreach (configproperties [_x,"isclass _x",true]);
_data pushback _items;
} foreach [
configfile >> "cfgvehicles" >> typeof _center >> "animationSources",
configfile >> "cfgvehicles" >> typeof _center >> "textureSources"
];

missionnamespace setvariable ["bis_fnc_garage_data",_data];
["bis_fnc_garage_preload"] call bis_fnc_endloadingscreen;
BIS_fnc_garage_centerType = typeof _center;
true
} else {


if (isnil "_data" || cheatsenabled) then {
["bis_fnc_garage_preload"] call bis_fnc_startloadingscreen;

_data = [];
{
_data set [_x,[]];
} foreach [				0,					1];
_defaultCrew = gettext (configfile >> "cfgvehicles" >> "all" >> "crew");

{
_simulation = gettext (_x >> "simulation");
_items = switch tolower _simulation do {
case "car";
case "carx": {
_data select 		-1;
};
case "tank";
case "tankx": {
if (getnumber (_x >> "maxspeed") > 0) then {
_data select 		-1;
} else {
_data select 		-1;
};
};
case "helicopter";
case "helicopterx";
case "helicopterrtd": {
_data select 		-1;
};
case "airplane";
case "airplanex": {
_data select 		-1;
};
case "ship";
case "shipx";
case "submarinex": {
_data select 		-1;
};
default {[]};
};


_model = tolower gettext (_x >> "model");
if (getnumber (_x >> "forceInGarage") > 0) then {_model = _model + ":" + configname _x;}; 
_modelID = _items find _model;
if (_modelID < 0) then {
_modelID = count _items;
_items pushback _model;
_items pushback [];
};
_modelData = _items select (_modelID + 1);
_modelData pushback _x;

} foreach ("isclass _x && {getnumber (_x >> 'scope') == 2} && {gettext (_x >> 'crew') != _defaultCrew}" configclasses (configfile >> "cfgvehicles"));

missionnamespace setvariable ["bis_fnc_garage_data",_data];
["bis_fnc_garage_preload"] call bis_fnc_endloadingscreen;
true
} else {
false
};
};
};


case "ListAdd": {
_display = _this select 0;
_data = missionnamespace getvariable "bis_fnc_garage_data";
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
if (is3DEN) then {
_centerTextures = getobjecttextures _center;
_ctrlList = controlnull; 
_cursel = -1; 
{
_items = _x;
_idc = _foreachindex;
_ctrlList = _display displayctrl (			960 + _foreachindex);
{
_configName = configname (_x select 0);
_displayName = _x select 1;
_lbAdd = _ctrlList lbadd _displayName;
_ctrlList lbsetdata [_lbAdd,_configName];
_ctrlList lbsettooltip [_lbAdd,_displayName];
if (_idc == 0) then 
{
_ctrlList lbsetpicture [_lbAdd,_checkboxTextures select ((_center animationphase _configName) max 0)];
} 
else 
{
private _cfg = configfile >> "cfgvehicles" >> typeof _center >> "texturesources" >> _configName;

private _configTextures = getarray (_cfg >> "textures");
private _decals = getarray (_cfg >> "decals");
private _selected = 
({
if !(_forEachIndex in _decals || { [_x, _configTextures param [_forEachIndex, ""]] call _fnc_compareTextures }) exitWith { false };
true
}
forEach _centerTextures);

_ctrlList lbsetpicture [_lbAdd,_checkboxTextures select _selected];
};
} 
foreach _items;
lbsort _ctrlList;

_ctrlListDisabled = _display displayctrl (		860 + _foreachindex);
_ctrlListDisabled ctrlshow (lbsize _ctrlList == 0);
} foreach _data;

_cfg = configfile >> "cfgvehicles" >> typeof _center;
["ShowItemInfo",[_cfg,gettext (_cfg >> "displayName")]] call bis_fnc_arsenal;
["ShowItemStats",[_cfg]] call bis_fnc_garage;
} else {
{
_items = _x;
_ctrlList = _display displayctrl (			960 + _foreachindex);
for "_i" from 0 to (count _items - 1) step 2 do {
_model = _items select _i;
_modelData = _items select (_i + 1);
_modelExample = _modelData select 0;
_displayName = gettext (_modelExample >> "displayName");
_lbAdd = _ctrlList lbadd _displayName;
_ctrlList lbsetpicture [_lbAdd,gettext (_modelExample >> "picture")];
_ctrlList lbsetdata [_lbAdd,_model];
_ctrlList lbsetvalue [_lbAdd,_i];
_ctrlList lbsettooltip [_lbAdd,_displayName];
if (_fullVersion) then {
_addons = configsourceaddonlist _modelExample;
if (count _addons > 0) then {
_dlcs = configsourcemodlist (configfile >> "CfgPatches" >> _addons select 0);
if (count _dlcs > 0) then {
private _dlcName = _dlcs select 0;
if (_dlcName != "") then {
_ctrlList lbsetpictureright [_lbAdd,(modParams [_dlcName,["logo"]]) param [0,""]];
}else{
_ctrlList lbsetpictureright [_lbAdd,gettext ((configfile >> "cfgMods" >> gettext (_modelExample >> "dlc")) >> "logo")];
};
};
};
};
};
lbsort _ctrlList;


for "_i" from 0 to (lbsize _ctrlList - 1) do {
if ((_ctrlList lbdata _i) == bis_fnc_garage_centerType) then {
_ctrlList lbsetcursel _i;
};
} foreach _data;
} foreach _data;
};
};


case "TabSelectLeft": {
_display = _this select 0;
_index = _this select 1;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);







{
_idc = _x;
_active = _idc == _index;

{
_ctrlList = _display displayctrl (_x + _idc);
_ctrlList ctrlenable _active;
_ctrlList ctrlsetfade ([1,0] select _active);
_ctrlList ctrlcommit 	0.15;
} foreach [			960,		860];

_ctrlTab = _display displayctrl (			930 + _idc);
_ctrlTab ctrlenable !_active;

_ctrlList = _display displayctrl (			960 + _idc);
if (_active) then {
_ctrlLineTabLeft = _display displayctrl 		1804;
_ctrlLineTabLeft ctrlsetfade 0;
_ctrlTabPos = ctrlposition _ctrlTab;
_ctrlLineTabPosX = (_ctrlTabPos select 0) + (_ctrlTabPos select 2) - 0.01;
_ctrlLineTabPosY = (_ctrlTabPos select 1);
_ctrlLineTabLeft ctrlsetposition [
safezoneX,
_ctrlLineTabPosY,
(ctrlposition _ctrlList select 0) - safezoneX,
ctrlposition _ctrlTab select 3
];
_ctrlLineTabLeft ctrlcommit 0;
ctrlsetfocus _ctrlList;
if (_idc != 		0) then { 
['SelectItem',[_display,_display displayctrl (			960 + _idc),_idc]] call bis_fnc_garage;
};
} else {
if ((_center getvariable "bis_fnc_arsenal_idc") != _idc) then {_ctrlList lbsetcursel -1;};
};

_ctrlIcon = _display displayctrl (			900 + _idc);

_ctrlIcon ctrlshow _active;
_ctrlIcon ctrlenable !_active;
} foreach [				0,					1];

{
_ctrl = _display displayctrl _x;
_ctrl ctrlsetfade 0;
_ctrl ctrlcommit 	0.15;
} foreach [

			1801,
		994
];


{
_idc = _x;
_ctrl = _display displayctrl (			930 + _x);
_ctrl ctrlenable true;
_ctrl ctrlsetfade 0;
_ctrl ctrlcommit 0;
{
_ctrlList = _display displayctrl (_idc + _x);
_ctrlList ctrlenable true;
_ctrlList ctrlsetfade 0;
_ctrlList ctrlcommit 	0.15;
} foreach [			960,		860];
} foreach [];


if !(is3DEN) then {
{
_ctrl = _display displayctrl _x;
_ctrl ctrlsetfade 0;
_ctrl ctrlcommit 	0.15;
} foreach [
		1806,
		1802,
		995
];
};

['TabSelectRight',[_display,	-1]] call bis_fnc_garage;
};


case "TabSelectRight": {
_display = _this select 0;
_index = _this select 1;
_ctrFrameRight = _display displayctrl 		1802;
_ctrBackgroundRight = _display displayctrl 		995;

{
_idc = _x;
_active = _idc == _index;

{
_ctrlList = _display displayctrl (_x + _idc);
_ctrlList ctrlenable _active;
_ctrlList ctrlsetfade ([1,0] select _active);
_ctrlList ctrlcommit 	0.15;
} foreach [			960,		860];

_ctrlTab = _display displayctrl (			930 + _idc);
_ctrlTab ctrlenable (!_active && ctrlfade _ctrlTab == 0);

if (_active) then {
_ctrlList = _display displayctrl (			960 + _idc);
_ctrlLineTabRight = _display displayctrl 		1806;
_ctrlLineTabRight ctrlsetfade 0;
_ctrlTabPos = ctrlposition _ctrlTab;
_ctrlLineTabPosX = (ctrlposition _ctrlList select 0) + (ctrlposition _ctrlList select 2);
_ctrlLineTabPosY = (_ctrlTabPos select 1);
_ctrlLineTabRight ctrlsetposition [
_ctrlLineTabPosX,
_ctrlLineTabPosY,
safezoneX + safezoneW - _ctrlLineTabPosX,
ctrlposition _ctrlTab select 3
];
_ctrlLineTabRight ctrlcommit 0;
ctrlsetfocus _ctrlList;

_ctrlLoadCargo = _display displayctrl 			991;
_ctrlListPos = ctrlposition _ctrlList;
_ctrlListPos set [3,(_ctrlListPos select 3) + (ctrlposition _ctrlLoadCargo select 3)];
{
_x ctrlsetposition _ctrlListPos;
_x ctrlcommit 0;
} foreach [_ctrFrameRight,_ctrBackgroundRight];

if (_idc in [		21,		22,		23,		24]) then {
["SelectItemRight",[_display,_ctrlList,_index]] call bis_fnc_arsenal;
};
};

_ctrlIcon = _display displayctrl (			900 + _idc);

_ctrlIcon ctrlshow _active;
_ctrlIcon ctrlenable (!_active && ctrlfade _ctrlTab == 0);
} foreach [];
};


case "SelectItem": {
private ["_ctrlList","_index","_cursel"];
_display = _this select 0;
_ctrlList = _this select 1;
_idc = _this select 2;
_cursel = lbcursel _ctrlList;
if (_cursel < 0) exitwith {};
_index = _ctrlList lbvalue _cursel;

_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_group = (missionnamespace getvariable ["BIS_fnc_arsenal_group",group player]);
_cfg = configfile >> "dummy";

_cfgStats = _cfg;
_colors = [[1,1,1,1],[1,1,1,0.25]];
_initVehicle = false;

switch _idc do {
case 		-1;
case 		-1;
case 		-1;
case 		-1;
case 		-1;
case 		-1: {
_item = if (ctrltype _ctrlList == 102) then {_ctrlList lnbdata [_cursel,0]} else {_ctrlList lbdata _cursel};
_target = (missionnamespace getvariable ["BIS_fnc_arsenal_target",player]);
_centerType = if !(simulationenabled _center) then {""} else {typeof _center}; 
_centerSizeOld = ((boundingboxreal _center select 0) vectordistance (boundingboxreal _center select 1));
_data = missionnamespace getvariable "bis_fnc_garage_data";
_modelData = (_data select _idc) select (_index + 1);
_cfg = _modelData select 0;
_cfgStats = _cfg;
_class = configname _cfg;

if (_class != _centerType || !alive _center) then {
_centerPos = position _center;
_centerPos set [2,0];
_players = [];
_crew = [];
{
_member = _x select 0;
_role = _x select 1;
_index = if (_role == "turret") then {_x select 3} else {_x select 2};
_crew pushback [typeof _member,_role,_index];
} foreach fullcrew _center;
{
if (isplayer _x) then {
_players pushback [_x,assignedvehiclerole _x];
moveout _x;
} else {
_center deletevehiclecrew _x;
};
} foreach crew _center;
if (getnumber (configfile >> "cfgvehicles" >> typeof _center >> "isUAV") > 0) then {_crew = [];}; 

if (_center != player) then {_center setpos [10,10,00];};
deletevehicle _center;
_center = _class createvehiclelocal _centerPos;
_center setVariable ["bis_fnc_arsenal_isGarageCenter", true];
[_center, "", []] call bis_fnc_initVehicle;
if (_center isKindOf "C_Kart_01_F") then { [_center] call bis_fnc_initVehicleKart };
_center setpos _centerPos;
if ((_center getvariable ["bis_fnc_arsenal_idc",-1]) >= 0) then {_center setpos _centerPos;}; 
_center allowdamage false;
_center setvelocity [0,0,0];
_center setvariable ["bis_fnc_arsenal_idc",_idc];
if (_fullVersion) then {_center setvehicletipars [0.5,0.5,0.5];}; 
bis_fnc_garage_centerType = _item;
missionnamespace setvariable ["BIS_fnc_arsenal_center",_center];
_target attachto [_center,BIS_fnc_arsenal_campos select 3,""];


{
_player = _x select 0;
_roleArray = _x select 1;
_role = _roleArray select 0;
switch (tolower _role) do {
case "driver": {
if (_center emptypositions _role > 0) then {_player moveindriver _center;} else {_player moveinany _center;};
};
case "gunner";
case "commander";
case "turret": {
if (count (allturrets _center) > 0) then {_player moveinturret [_center,(allturrets _center) select 0];} else {_player moveinany _center;};
};
case "cargo": {
if (_center emptypositions _role > 0) then {_player moveincargo _center;} else {_player moveinany _center;};
};
};
} foreach _players;
if (getnumber (_cfg >> "isUAV") < 1) then {
_crewUnits = [_center,_crew,true,nil,true] call bis_fnc_initVehicleCrew;
{

_x setbehaviour "careless";
_x call bis_fnc_vrHitpart;
} foreach _crewUnits;
};


_centerSize = ((boundingboxreal _center select 0) vectordistance (boundingboxreal _center select 1));
if (_centerSizeOld != 0) then {
_dis = BIS_fnc_arsenal_campos select 0;
_disCoef = _dis / _centerSizeOld;
BIS_fnc_arsenal_campos set [0,_centerSize * _disCoef];

_targetPos = BIS_fnc_arsenal_campos select 3;
_coefX = (_targetPos select 0) / _centerSizeOld;
_coefY = (_targetPos select 1) / _centerSizeOld;
_coefZ = (_targetPos select 2) / _centerSizeOld;
BIS_fnc_arsenal_campos set [3,[_centerSize * _coefX,_centerSize * _coefY,_centerSize * _coefZ]];
};
};


_center setdir direction _center;
_center setvelocity [0,0,0];


_ctrlButtonTry = _display displayctrl 		44347;
_ctrlListCrew = _display displayctrl (			960 + 	-1);
lbclear _ctrlListCrew;

if (getnumber (_cfg >> "isUAV") < 1) then {




_colorMe = getarray (configfile >> "CfgInGameUI" >> "IslandMap" >> "colorMe");


if (getnumber (_cfg >> "hasdriver") > 0) then {
_text = if (_center iskindof "air") then {localize "str_pilot"} else {localize "str_driver"};
_isPlayer = isplayer driver _center;
if (_isPlayer) then {_text = format ["%1 (%2)",_text,name player];};
_lbAdd = _ctrlListCrew lbadd _text;
_ctrlListCrew lbsetdata [_lbAdd,"Driver"];
_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select !(isnull driver _center)];
if (_isPlayer) then {_ctrlListCrew lbsetcolor [_lbAdd,_colorMe];};
};


BIS_fnc_garage_turretPaths = [];
_proxyIndexes = [];
{
_value = _foreachindex;
_value = _value + 1; 
_cfgTurret = _cfg;
{_cfgTurret = (_cfgTurret >> "turrets") select _x;} foreach _x;
_lbAdd = _ctrlListCrew lbadd gettext (_cfgTurret >> "gunnerName");
_locked = _center lockedturret _x;
_ctrlListCrew lbsetdata [_lbAdd,"Turret"];
_ctrlListCrew lbsetvalue [_lbAdd,if (_locked) then {-_value} else {_value}];
_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select !(isnull (_center turretunit _x))];
BIS_fnc_garage_turretPaths pushback _x;



if (getnumber (_cfgTurret >> "isPersonTurret") > 0 && getnumber (_cfg >> "hideProxyInCombat") == 0) then { 

_proxyIndexes pushback getnumber (_cfgTurret >> "proxyIndex");
};
} foreach (allturrets [_center,true]);


_occupiedSeats = [];
{
if ((_x select 1) == "cargo") then {_occupiedSeats pushback (_x select 2);};
} foreach fullcrew _center;
_getInProxyOrder = getarray (_cfg >> "getInProxyOrder");
_transportSoldier = getnumber (_cfg >> "transportSoldier");

_cargoProxyIndexes = [];
if (count _getInProxyOrder == 0) then {
for "_i" from 1 to _transportSoldier do {_getInProxyOrder pushback _i;};
_turretCount = count _proxyIndexes;
for "_i" from (1 + _turretCount) to (_transportSoldier + _turretCount) do {_cargoProxyIndexes pushback _i;};
} else {
{
if !(_x in _proxyIndexes) then {_cargoProxyIndexes pushback (_foreachindex + 1);};
} foreach _getInProxyOrder;
};
_cargoProxyIndexes resize (_transportSoldier min (count _cargoProxyIndexes)); 
{
_locked = _center lockedcargo (_x - 1);
_lbAdd = _ctrlListCrew lbadd format ["%1 %2",localize "STR_GETIN_POS_PASSENGER",_foreachindex + 1];
_ctrlListCrew lbsetdata [_lbAdd,"Cargo"];
_ctrlListCrew lbsetvalue [_lbAdd,if (_locked) then {-_x} else {_x}];
_ctrlListCrew lbsetpicture [_lbAdd,_checkboxTextures select ((_x - 1) in _occupiedSeats)];
_ctrlListCrew lbsetcolor [_lbAdd,_colors select _locked];
_ctrlListCrew lbsetpicturecolor [_lbAdd,_colors select _locked];
} foreach _cargoProxyIndexes;

_ctrlButtonTry ctrlenable _fullVersion;
} else {
createvehiclecrew _center;
if (_fullVersion) then {{_x setbehaviour "careless";} foreach crew _center;};
_ctrlButtonTry ctrlenable false;
};
_ctrlListCrewDisabled = _display displayctrl (		860 + 	-1);
_ctrlListCrewDisabled ctrlshow (lbsize _ctrlListCrew == 0);


_ctrlListAnimations = _display displayctrl (			960 + 		0);
lbclear _ctrlListAnimations;
{
_configName = configname _x;
_displayName = gettext (_x >> "displayName");
if (_displayName != "" && {getnumber (_x >> "scope") > 1 || !isnumber (_x >> "scope")}) then {
_lbAdd = _ctrlListAnimations lbadd _displayName;
_ctrlListAnimations lbsetdata [_lbAdd,_configName];
_ctrlListAnimations lbsetpicture [_lbAdd,_checkboxTextures select ((_center animationphase _configName) max 0)];
};
} foreach (configproperties [_cfg >> "animationSources","isclass _x",true]);
lbsort _ctrlListAnimations;
_ctrlListAnimationsDisabled = _display displayctrl (		860 + 		0);
_ctrlListAnimationsDisabled ctrlshow (lbsize _ctrlListAnimations == 0);


_currentTextures = getobjecttextures _center;
_current = "";
_ctrlListTextures = _display displayctrl (			960 + 			1);
lbclear _ctrlListTextures;
{
_displayName = gettext (_x >> "displayName");
if (_displayName != "") then 
{					
private _textures = getarray (_x >> "textures");
private _decals = getarray (_x >> "decals");
private _selected = 
({
if !(_forEachIndex in _decals || { [_x, _textures param [_forEachIndex, ""]] call _fnc_compareTextures }) exitWith { false };
true
}
forEach _currentTextures);

_lbAdd = _ctrlListTextures lbadd _displayName;
_ctrlListTextures lbsetdata [_lbAdd,configname _x];
_ctrlListTextures lbsetpicture [_lbAdd,_checkboxTextures select 0];
if (_selected) then {_current = configname _x;};
};
} foreach (configproperties [_cfg >> "textureSources","isclass _x",true]);
lbsort _ctrlListTextures;
for "_i" from 0 to (lbsize _ctrlListTextures - 1) do {
if ((_ctrlListTextures lbdata _i) == _current) then {
_ctrlListTextures lbsetcursel _i;
};
};
_ctrlListTexturesDisabled = _display displayctrl (		860 + 			1);
_ctrlListTexturesDisabled ctrlshow (lbsize _ctrlListTextures == 0);


_ctrlTab = _display displayctrl (			930 + _idc);
_ctrlLineTab = _display displayctrl 	1805;
_ctrlLineTabPos = ctrlposition _ctrlLineTab;
_ctrlLineTabPos set [1,ctrlposition _ctrlTab select 1];
_ctrlLineTab ctrlsetposition _ctrlLineTabPos;
_ctrlLineTab ctrlcommit 0;
};
case 	-1: {
_role = _ctrlList lbdata _cursel;
_roleIndex = _ctrlList lbvalue _cursel;
if (_roleIndex < 0) exitwith {};
_roleIndex = _roleIndex - 1; 

_checked = false;
_fnc_createUnit = {

_unit = createagent ["B_soldier_vr_f",position _center,[],0,"none"];
_unit call bis_fnc_vrHitpart;
if (_fullVersion) then {_unit setbehaviour "careless";}; 
_unit
};
_fnc_deleteUnit = {
_group = group _unit;
_center deletevehiclecrew _unit;
deletegroup _group;
};
switch _role do {
case "Driver": {
_unit = driver _center;
if !(isplayer _unit) then {
if (isnull _unit) then {
_unit = call _fnc_createUnit;
_unit moveindriver _center;
_checked = true;
} else {
call _fnc_deleteUnit;
};
} else {
_checked = true;
};
};
case "Turret": {
_roleIndexArray = BIS_fnc_garage_turretPaths select _roleIndex;
_unit = _center turretunit _roleIndexArray;
if !(isplayer _unit) then {
if (isnull _unit) then {
_unit = call _fnc_createUnit;
_unit moveinturret [_center,_roleIndexArray];
_checked = true;
} else {
call _fnc_deleteUnit;
};
} else {
_checked = true;
};
};
case "Cargo": {
_unit = objnull;
{
if ((_x select 1) == "cargo" && (_x select 2) == _roleIndex) exitwith {_unit = _x select 0;};
} foreach fullcrew _center;
if !(isplayer _unit) then {
if (isnull _unit) then {
_unit = call _fnc_createUnit;
_unit moveincargo [_center,_roleIndex];
_checked = true;
} else {
call _fnc_deleteUnit;
};
} else {
_checked = true;
};
};
};

_ctrlList lbsetpicture [_cursel,_checkboxTextures select _checked];
};

case 		0: {
_selected = _checkboxTextures find (_ctrlList lbpicture _cursel);
_ctrlList lbsetpicture [_cursel,_checkboxTextures select ((_selected + 1) % 2)];
_initVehicle = true;
};
case 			1: {
_selected = _checkboxTextures find (_ctrlList lbpicture _cursel);
for "_i" from 0 to (lbsize _ctrlList - 1) do {
_ctrlList lbsetpicture [_i,_checkboxTextures select 0];
};
_ctrlList lbsetpicture [_cursel,_checkboxTextures select 1];
_initVehicle = true;
};
















};
if (_initVehicle) then {
_ctrlListTextures = _display displayctrl (			960 + 			1);
_ctrlListAnimations = _display displayctrl (			960 + 		0);
_textures = "";
_animations = [];
for "_i" from 0 to (lbsize _ctrlListTextures - 1) do {
if ((_ctrlListTextures lbpicture _i) == (_checkboxTextures select 1)) exitwith {_textures = [_ctrlListTextures lbdata _i,1];};
};
for "_i" from 0 to (lbsize _ctrlListAnimations - 1) do {
_animations pushback (_ctrlListAnimations lbdata _i);
_animations pushback (_checkboxTextures find (_ctrlListAnimations lbpicture _i));
};

[_center,_textures,_animations,true] call bis_fnc_initVehicle;
};

["SetCrewStatus",[_display]] call bis_fnc_garage;
["SetAnimationStatus",[_display]] call bis_fnc_garage;
["SetTextureStatus",[_display]] call bis_fnc_garage;
if (isclass _cfg) then {
["ShowItemInfo",[_cfg]] call bis_fnc_arsenal;
["ShowItemStats",[_cfgStats]] call bis_fnc_garage;
};
};


case "SetAnimationStatus": 
{
_display = _this select 0;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_ctrlListAnimations = _display displayctrl (			960 + 		0);
for "_i" from 0 to (lbsize _ctrlListAnimations - 1) do {
_selected = _center animationphase (_ctrlListAnimations lbdata _i);
_ctrlListAnimations lbsetpicture [_i,_checkboxTextures select _selected];
};
};


case "SetTextureStatus": 
{
private _display = _this select 0;
private _center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
private _ctrlListTextures = _display displayctrl (			960 + 			1);
private _centerTextures = getObjectTextures _center;

for "_i" from 0 to (lbsize _ctrlListTextures - 1) do 
{
private _cfg = configfile >> "cfgvehicles" >> typeof _center >> "texturesources" >> (_ctrlListTextures lbdata _i);

private _configTextures = getarray (_cfg >> "textures");
private _decals = getarray (_cfg >> "decals");
private _selected = 
({
if !(_forEachIndex in _decals || { [_x, _configTextures param [_forEachIndex, ""]] call _fnc_compareTextures }) exitWith { false };
true
}
forEach _centerTextures);

_ctrlListTextures lbsetpicture [_i,_checkboxTextures select _selected];
};
};


case "SetCrewStatus": {
_display = _this select 0;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_colors = [[1,1,1,1],[1,1,1,0.25]];

_ctrlListCrew = _display displayctrl (			960 + 	-1);
_lockedIndexes = [];
_colorMe = getarray (configfile >> "CfgInGameUI" >> "IslandMap" >> "colorMe");
_iconPlayer = gettext (configfile >> "CfgInGameUI" >> "IslandMap" >> "iconPlayer");
_emptyPositions = 0;
for "_i" from 0 to (lbsize _ctrlListCrew - 1) do {
_role = _ctrlListCrew lbdata _i;
_roleIndex = abs (_ctrlListCrew lbvalue _i) - 1;
_value = abs (_ctrlListCrew lbvalue _i);
_locked = false;
_unit = objnull;


switch (tolower _role) do {
case "cargo": {
_unit = objnull;
{if ((_x select 2) == _roleIndex) exitwith {_unit = _x select 0;};} foreach fullcrew _center;
_locked = _center lockedcargo _roleIndex;
if (_locked) then {_lockedIndexes pushback _roleIndex;};
};
case "gunner";
case "commander";
case "turret": {
_turretPath = BIS_fnc_garage_turretPaths select _roleIndex;
_unit = _center turretunit _turretPath;
_locked = _center lockedturret _turretPath;
if (_locked) then {_lockedIndexes pushback _turretPath;};
};
case "driver": {
_unit = driver _center;
_locked = lockeddriver _center;
};
};
_isPlayer = isplayer _unit;
if (_locked && !isnull _unit) then {
moveout _unit;
_isPlayer = false;
if (_fullVersion) then {
if (_unit == player) then {_unit hideobject true;} else {deletevehicle _unit;};
};
};
_ctrlListCrew lbsetcolor [_i,_colors select _locked];
_ctrlListCrew lbsetvalue [_i,[_value,-_value] select _locked];
if (_isPlayer) then {
_ctrlListCrew lbsetpicture [_i,_iconPlayer];
_ctrlListCrew lbsetpicturecolor [_i,_colorMe];
_emptyPositions = _emptyPositions + 1;
} else {
_isOccupied = !isnull _unit && !_locked;
_ctrlListCrew lbsetpicturecolor [_i,_colors select _locked];
_ctrlListCrew lbsetpicture [_i,_checkboxTextures select _isOccupied];
if !(_isOccupied) then {_emptyPositions = _emptyPositions + 1;};
};
};


{
_delete = switch (tolower (_x select 1)) do {
case "cargo": {(_x select 2) in _lockedIndexes};
case "gunner";
case "commander";
case "turret": {(_x select 3) in _lockedIndexes};
default {false}
};
if (_delete) then {
_center deletevehiclecrew (_x select 0);
};
} foreach (fullcrew _center);


_ctrlButtonTry = _display displayctrl 		44347;
_ctrlButtonTry ctrlenable (_emptyPositions > 0);
};


case "ShowItemStats": {
_itemCfg = _this select 0;
if (isclass _itemCfg) then {
_ctrlStats = _display displayctrl 		28644;
_ctrlStatsPos = ctrlposition _ctrlStats;
_ctrlStatsPos set [0,0];
_ctrlStatsPos set [1,0];
_ctrlBackground = _display displayctrl 	27347;
_barMin = 0.01;
_barMax = 1;

_statControls = [
[		27348,		27353],
[		27349,		27354],
[		27350,		27355],
[		27351,		27356],
[		27352,		27357]
];
_rowH = 1 / (count _statControls + 1);
_fnc_showStats = {
_h = _rowH;
{
_ctrlStat = _display displayctrl ((_statControls select _foreachindex) select 0);
_ctrlText = _display displayctrl ((_statControls select _foreachindex) select 1);
if (count _x > 0) then {
_ctrlStat progresssetposition (_x select 0);
_ctrlText ctrlsettext toupper (_x select 1);
_ctrlText ctrlsetfade 0;
_ctrlText ctrlcommit 0;

_h = _h + _rowH;
} else {
_ctrlStat progresssetposition 0;
_ctrlText ctrlsetfade 1;
_ctrlText ctrlcommit 0;

};
} foreach _this;
_ctrlStatsPos set [1,(_ctrlStatsPos select 3) * (1 - _h)];
_ctrlStatsPos set [3,(_ctrlStatsPos select 3) * _h];
_ctrlBackground ctrlsetposition _ctrlStatsPos;
_ctrlBackground ctrlcommit 0;
};

_ctrlStats ctrlsetfade 0;
_statsExtremes = uinamespace getvariable "BIS_fnc_garage_stats";
if !(isnil "_statsExtremes") then {
_statsMin = _statsExtremes select 0;
_statsMax = _statsExtremes select 1;

_stats = [
[_itemCfg],
	["maxspeed","armor","fuelcapacity","threat"],	[false,true,false,false],
_statsMin
] call bis_fnc_configExtremes;
_stats = _stats select 1;

_statMaxSpeed = linearConversion [_statsMin select 0,_statsMax select 0,_stats select 0,_barMin,_barMax];
_statArmor = linearConversion [_statsMin select 1,_statsMax select 1,_stats select 1,_barMin,_barMax];
_statFuelCapacity = linearConversion [_statsMin select 2,_statsMax select 2,_stats select 2,_barMin,_barMax];
_statThreat = linearConversion [_statsMin select 3,_statsMax select 3,_stats select 3,_barMin,_barMax];
[
[],[],[],
[_statMaxSpeed,localize "STR_A3_RSCDISPLAYGARAGE_STAT_MAX_SPEED"],
[_statArmor,localize "STR_UI_ABAR"]


] call _fnc_showStats;
};

_ctrlStats ctrlcommit 	0.15;
} else {
_ctrlStats = _display displayctrl 		28644;
_ctrlStats ctrlsetfade 1;
_ctrlStats ctrlcommit 	0.15;
};
};


case "buttonImport": {
startloadingscreen [""];
_display = _this select 0;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerCfg = configfile >> "cfgvehicles" >> typeof _center;

_import = copyfromclipboard;
_importArray = [_import," 	;='"",[]" + tostring [13,10]] call bis_fnc_splitString;

_textures = [];
_animations = [];
_crew = [];

if (count _importArray == 1) then {

_class = _importArray select 0;
} else {

_importArray = _importArray + [""];
_isVehicle = false;
{
if (_x == "createvehicle" && !_isVehicle) then {
_vehClass = _importArray select _foreachindex + 1; 
_vehModel = tolower gettext (configfile >> "cfgvehicles" >> _vehClass >> "model");
if (is3DEN) then {

if (_vehModel == gettext (_centerCfg >> "model")) then {
_isVehicle = true;
} else {


[
"showMessage",
[
_display,
format [
"Cannot import settings of %1 to %2!", 
gettext (configfile >> "cfgvehicles" >> _vehClass >> "displayName"),
gettext (_centerCfg >> "displayName")
]
]
] call bis_fnc_arsenal;
};
} else {
_vehModelForced = _vehModel + ":" + _vehClass;
_isVehicle = false;
{
_ctrlList = _display displayctrl (			960 + _x);
for "_l" from 0 to (lbsize _ctrlList - 1) do {
if ((_ctrlList lbdata _l) == _vehModel) then {
_ctrlList lbsetcursel _l;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerCfg = configfile >> "cfgvehicles" >> typeof _center;
_isVehicle = true;
};
if ((_ctrlList lbdata _l) == _vehModelForced) exitwith {
_ctrlList lbsetcursel _l;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerCfg = configfile >> "cfgvehicles" >> typeof _center;
_isVehicle = true;
};
};
if (_isVehicle) exitwith {};
} foreach [				0,					1];
};
};
if (_isVehicle) then {
switch true do {
case (isclass (_centerCfg >> "animationsources" >> _x)): {
_probability = parsenumber (_importArray select _foreachindex + 1);
_animations pushback _x;
_animations pushback _probability;
};
case (isclass (_centerCfg >> "texturesources" >> _x)): {
_probability = parsenumber (_importArray select _foreachindex + 1);
_textures pushback _x;
_textures pushback _probability;
};
case (_x == "driver"): {
_crew pushback ["B_Soldier_VR_F",_x];
};
case ((tolower _x) in ["turret","commander","gunner"]): {
_turretPath = [];
_maxTurretSize = 0;
{_maxTurretSize = _maxTurretSize max (count _x)} foreach (allturrets _center);
for "_t" from (_foreachindex + 1) to (_foreachindex + _maxTurretSize) do {
if (_t < count _importArray) then {
_turretPathValue = _importArray select _t;
if (_turretPathValue in ["0","1","2","3","4","5","6","7","8","9"]) then {
_turretPath pushback parsenumber _turretPathValue;
};
};
};
_crew pushback ["B_Soldier_VR_F",_x,_turretPath];
};
case (_x == "cargo"): {
_crew pushback ["B_Soldier_VR_F",_x,parsenumber (_importArray select _foreachindex + 1)];
};
};
};
} foreach _importArray;

[_center,_textures,_animations] call bis_fnc_initVehicle;
if !(is3DEN) then {
{_center deletevehiclecrew _x;} foreach (crew _center);
[_center,_crew] call bis_fnc_initVehicleCrew;
{_x setbehaviour "careless";} foreach (crew _center);
["SetCrewStatus",[_display]] call bis_fnc_garage;
["SetAnimationStatus",[_display]] call bis_fnc_garage;
["SetTextureStatus",[_display]] call bis_fnc_garage;
};
};
endloadingscreen;
};


case "buttonExport": {
_display = _this select 0;
_exportMode = _this select 1;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerType = "";

_br = tostring [13,10];
_export = "";
if (_exportMode == "init" && !is3den) then {


_export = "comment ""Related vehicle classes:"";" + _br;
_data = missionnamespace getvariable "bis_fnc_garage_data";
_modelData = [];

_currentTextures = getobjecttextures _center;
{_currentTextures set [_foreachindex,tolower _x];} foreach _currentTextures;

{
_items = _x;
_ctrlList = _display displayctrl (			960 + _foreachindex);
if (lbcursel _ctrlList >= 0) then {
_i = _ctrlList lbvalue lbcursel _ctrlList;
_modelData = _items select (_i + 1);
{
_export = _export + format ["comment ""%1"";" + _br,configname _x];
if (_centerType == "") then {
_textureList = getarray (_x >> "textureList");
for "_i" from 0 to (count _textureList - 1) step 2 do 
{
private _textures = getarray (_x >> "textureSources" >> (_textureList select _i) >> "textures");
private _decals = getarray (_cfg >> "decals");
private _selected = 
({
if !(_forEachIndex in _decals || { [_x, _textures param [_forEachIndex, ""]] call _fnc_compareTextures }) exitWith { false };
true
}
forEach _currentTextures);

if (_selected) then {_centerType = configname _x;};
};
};
} foreach _modelData;
};
} foreach _data;
_export = _export + _br;
if (count _modelData == 1) then {
_export = "";
};
};
if (_centerType == "") then {_centerType = typeof _center;};
_export = _export + ([_center,_centerType] call bis_fnc_exportVehicle);
_export spawn {copytoclipboard _this;};
['showMessage',[_display,localize "STR_a3_RscDisplayArsenal_message_clipboard"]] call bis_fnc_arsenal;
};


case "buttonRandom": {
_display = _this select 0;

if (is3DEN) then {


_ctrlList = _display displayctrl (			960 + 		0);
for "_i" from 0 to (lbsize _ctrlList - 1) do {
if (random 1 > 0.5) then {_ctrlList lbsetcursel _i;};
};


_ctrlList = _display displayctrl (			960 + 			1);
_ctrlList lbsetcursel floor random (lbsize _ctrlList);

} else {

{
_ctrlList = _display displayctrl (			960 + _x);
_ctrlList lbsetcursel -1;
} foreach [				0,					1];


_ctrlList = _display displayctrl (			960 + (floor random (count [				0,					1] - 1)));
_ctrlList lbsetcursel (floor random (lbsize _ctrlList - 1));
};
};


case "showTemplates": {
_display = _this select 0;
_ctrlList = _display displayctrl 		35119;
lnbclear _ctrlList;
_data = missionnamespace getvariable ["bis_fnc_garage_data",[]];
_savedData = profilenamespace getvariable ["bis_fnc_saveVehicle_data",[]];
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerType = typeof _center;

for "_i" from 0 to (count _savedData - 1) step 2 do {
_name = _savedData select _i;
_vehData = _savedData select (_i + 1);
_vehType = _vehData select 0;
if (!is3DEN || {is3DEN && _vehType == _centerType}) then {
_vehModel = tolower gettext (configfile >> "cfgvehicles" >> _vehType >> "model");
if (getnumber (configfile >> "cfgvehicles" >> _vehType >> "forceInGarage") > 0) then {_vehModel = _vehModel + ":" + _vehType;};
_lbAdd = _ctrlList lnbaddrow [_name];
_categoryIndex = -1;
if (is3DEN) then {_categoryIndex = 0;} else {{if (_vehModel in _x) exitwith {_categoryIndex = _foreachindex;}} foreach _data;};
_ctrlList lbsetvalue [_lbAdd,_categoryIndex];

if (_categoryIndex < 0) then {_ctrlList lnbsetcolor [[_lbAdd,0],[1,1,1,0.25]];};
};
};
["templateSelChanged",[_display]] call bis_fnc_arsenal;
};


case "buttonTemplateOK": {
_display = _this select 0;
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_hideTemplate = true;

_ctrlTemplateName = _display displayctrl 		35020;
if (ctrlenabled _ctrlTemplateName) then {

[
_center,
[profilenamespace,ctrltext _ctrlTemplateName]
] call bis_fnc_saveVehicle;
} else {

_ctrlTemplateValue = _display displayctrl 		35119;
_categoryIndex = _ctrlTemplateValue lbvalue lnbcurselrow _ctrlTemplateValue;

if (_categoryIndex >= 0) then {
_savedData = profilenamespace getvariable ["bis_fnc_saveVehicle_data",[]];
_name = _ctrlTemplateValue lnbtext [lnbcurselrow _ctrlTemplateValue,0];
_nameID = _savedData find _name;
if (_nameID >= 0) then {
_vehData = _savedData select (_nameID + 1);
_vehType = _vehData select 0;
_vehModel = tolower gettext (configfile >> "cfgvehicles" >> _vehType >> "model");
if (getnumber (configfile >> "cfgvehicles" >> _vehType >> "forceInGarage") > 0) then {_vehModel = _vehModel + ":" + _vehType;};
_ctrlList = _display displayctrl (			960 + _categoryIndex);
for "_i" from 0 to (lbsize _ctrlList - 1) do {
if (_ctrlList lbdata _i == _vehModel) exitwith {_ctrlList lbsetcursel _i;};
};

_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
[_center,_name,_categoryIndex,_display] spawn { 
disableserialization;
_center = _this select 0;
_name = _this select 1;
_categoryIndex = _this select 2;
_display = _this select 3;

[_center,[profilenamespace,_name]] call bis_fnc_loadvehicle;
if (is3DEN) then {
['SelectItem',[_display,_display displayctrl (			960 + _categoryIndex),_categoryIndex]] call bis_fnc_garage;
} else {
["SetCrewStatus",[_display]] call bis_fnc_garage;
["SetAnimationStatus",[_display]] call bis_fnc_garage;
["SetTextureStatus",[_display]] call bis_fnc_garage;
};
};
};
} else {
_hideTemplate = false;
};
};
if (_hideTemplate) then {
_ctrlTemplate = _display displayctrl 		35919;
_ctrlTemplate ctrlsetfade 1;
_ctrlTemplate ctrlcommit 0;
_ctrlTemplate ctrlenable false;

_ctrlMouseBlock = _display displayctrl 		898;
_ctrlMouseBlock ctrlenable false;
};
};


case "buttonTry": {
_display = _this select 0;
_display closedisplay 2;

["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;

_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
if (_fullVersion && vehicle player != _center) then {
player setpos ([_center,135,(sizeof typeof _center) / 2] call bis_fnc_relpos);
player setdir (direction _center - 45);
player moveinany _center;
};
};


case "buttonOK": {
_display = _this select 0;
_display closedisplay 2;
["#(argb,8,8,3)color(0,0,0,1)",false,nil,0,[0,0.5]] call bis_fnc_textTiles;



if (is3DEN) then {
_center = (missionnamespace getvariable ["BIS_fnc_arsenal_center",player]);
_centerType = typeof _center;
_customization = _center call bis_fnc_getVehicleCustomization;
_variant = _customization select 0;
_texture = _variant select 0;
_anims = _customization select 1;
_objects = [];
{
if (_centerType == typeof _x) then {_objects pushback _x;}; 
} foreach get3DENSelected "object";
set3DENAttributes [[_objects,"VehicleCustomization",[_variant,_anims]]];
set3DENAttributes [[_objects,"ObjectTexture",_texture]];
};

};


case "loadVehicle": {
disableserialization;
_vehClass = [_this,0,"",[""]] call bis_fnc_param;
_vehCfg = configfile >> "cfgvehicles" >> _vehClass;
if (isclass _vehCfg) then {
_vehID = -1;
_vehModel = tolower gettext (_vehCfg >> "model");
_vehModelForced = _vehModel + ":" + _vehClass;
_isVehicle = false;
_display = uinamespace getvariable ["bis_fnc_arsenal_display",displaynull];
{
_ctrlList = _display displayctrl (			960 + _x);
for "_l" from 0 to (lbsize _ctrlList - 1) do {
_lbData = _ctrlList lbdata _l;
if (_lbData == _vehModel && !_isVehicle) then {_vehID = _l; _isVehicle = true;};
if (_lbData == _vehModelForced) exitwith {_vehID = _l; _isVehicle = true;};
};
if (_isVehicle) exitwith {
if (_vehID >= 0) then {_ctrlList lbsetcursel _vehID;};
};
} foreach [				0,					1];
};
};
};#line 2 "A3\functions_f_mark\Vehicles\fn_garage3DEN.sqf"

