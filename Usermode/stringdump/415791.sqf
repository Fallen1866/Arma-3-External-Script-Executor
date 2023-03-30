
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_3DENEntityMenu'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_3DENEntityMenu';
	scriptName _fnc_scriptName;

#line 1 "A3\3DEN\Functions\fn_3DENEntityMenu.sqf [BIS_fnc_3DENEntityMenu]"
#line 1 "A3\3DEN\Functions\fn_3DENEntityMenu.sqf"
#line 1 "a3\3DEN\UI\resincl.inc"












































































































































































































































































































































































































































































































































#line 1 "A3\3DEN\Functions\fn_3DENEntityMenu.sqf"


_mode = _this param [0,"",[""]];

switch (tolower _mode) do {
case "onentitymenu": {
_input = _this param [1,[],[[]]];
uinamespace setvariable ["bis_fnc_3DENEntityMenu_data",_input];
};
case "reset": {
uinamespace setvariable ["bis_fnc_3DENEntityMenu_data",nil];
uinamespace setvariable ["bis_fnc_3DENEntityMenu_entityID",nil];
};

case "movecamera": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_pos = _input param [0,[]];
move3DENCamera [_pos,true]
};
case "playfromhere": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_pos = _input param [0,[]];
uinamespace setvariable ["bis_fnc_3DENMissionPreview_pos",_pos];
{'MissionPreviewCustom' call bis_fnc_3DENMissionPreview;} call bis_fnc_3DENMissionPreview;
};
case "playasentity": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
uinamespace setvariable ["bis_fnc_3DENEntityMenu_entityID",get3DENEntityID _entity];
{
_id = uinamespace getvariable ["bis_fnc_3DENEntityMenu_entityID",-1];
_objects = _this param [0,[],[[]]];
for "_i" from 0 to (count _objects - 1) step 2 do {
_object = _objects select _i;
_objectID = _objects select (_i + 1);
if (_objectID == _id) then {
selectplayer _object;
_role = assignedvehiclerole _object;
switch (tolower (_role select 0)) do {
case "turret": {
_veh = vehicle _object;
_rolePath = _role select 1;
_weapons = _veh weaponsturret _rolePath;
if (count _weapons > 0) then {
_veh selectweaponturret [_weapons select 0,_rolePath];
};
};
};
};
};
} call bis_fnc_3DENMissionPreview;
setstatvalue ["3DENPuppeteer",1];

};
case "grid": {
_gridType = _this param [1,"translation",[""]];
_posIndex = _this param [2,0,[0]];
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
_bbox = boundingboxreal _entity;
set3dengrid [_gridType,abs(_bbox select 0 select _posIndex) + abs(_bbox select 1 select _posIndex)];
};
case "arsenal": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
["Open",[true,objnull,_entity]] call bis_fnc_arsenal;
};
case "arsenalreset": {
clear3DENInventory (get3DENSelected "object");
{
[_x,configfile >> "cfgvehicles" >> typeof _x] call bis_fnc_loadInventory;
} foreach (get3DENSelected "object")
};
case "garage": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
["Open",[true,_entity]] call bis_fnc_garage3DEN;
};
case "garagereset": {

collect3DENHistory {
set3DENAttributes [[get3DENSelected "object","VehicleCustomization",[[],[]]]];
set3DENAttributes [[get3DENSelected "object","ObjectTexture",""]];
};
{
_veh = _x;


{
_veh animate [configname _x,getnumber (_x >> "initPhase"),true];
} foreach configproperties [configfile >> "CfgVehicles" >> typeof _veh >> "AnimationSources"];


[_veh,true,true] call bis_fnc_initVehicle;
} foreach get3DENSelected "object";
};
case "findcreate": {
disableserialization;
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
_name = "";
_editmode = "";
_editsubmode = "";
switch (typename _entity) do {
case (typename objnull): {
_type = (_entity get3DENAttribute "ItemClass") select 0;
_cfg = configfile >> "cfgvehicles" >> _type;
_side = getnumber (_cfg >> "side");
_name = "class " + configname _cfg;
if (isnull group _entity && !(typeof _entity iskindof "AllVehicles")) then {
_editmode = "SelectObjectMode";
_editsubmode = "SelectSubmode5";

} else {
switch _side do {
case 0;
case 1;
case 2;
case 3: {
_editmode = "SelectObjectMode";
_editsubmode = ["SelectSubmode2","SelectSubmode1","SelectSubmode3","SelectSubmode4"] select _side;
};
case 7: {
_editmode = "SelectModuleMode";
_editsubmode = ["SelectSubmode1","SelectSubmode2"] select (gettext (_cfg >> "vehicleClass") == "Modules");
};
};
};
};
case (typename []): {
scopename "findcreate_waypoint";
_editmode = "SelectWaypointMode";
_editsubmode = "SelectSubmode1";
_type = (_entity get3DENAttribute "ItemClass") select 0;
{
{
if (configname _x == _type) then {
_name = gettext (_x >> "displayName");
breakto "findcreate_waypoint";
};
} foreach (configproperties [_x,"isclass _x"]);
} foreach (configproperties [configfile >> "cfgwaypoints","isclass _x"]);
};
case (typename ""): {
_editmode = "SelectMarkerMode";
_type = (_entity get3DENAttribute "markerType") select 0;
switch _type do {
case 0: {
_editsubmode = "SelectSubmode1";
_name = gettext (configfile >> "CfgMarkers" >> ((_entity get3DENAttribute "itemClass") select 0) >> "name");
};
case 1: {
_editsubmode = "SelectSubmode2";
_name = localize "str_disp_arcmark_ellipse";
};
case 2: {
_editsubmode = "SelectSubmode2";
_name = localize "str_disp_arcmark_rect";
};
};
};
};
if (_name != "") then {
do3DENAction _editmode;
do3DENAction _editsubmode;
_display = finddisplay 					313;
_ctrlSearch = _display displayctrl 			82;
_ctrlSearch ctrlsettext _name;
};
};
case "findconfig": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_entity = _input param [1,objnull];
switch (typename _entity) do {
case (typename objnull): {
BIS_fnc_configviewer_path = ['configfile','CfgVehicles'];
BIS_fnc_configviewer_selected = (_entity get3DENAttribute "ItemClass") select 0;
[] call bis_fnc_configviewer;
};
case (typename []): {
scopename "findconfig_waypoint";
_type = (_entity get3DENAttribute "ItemClass") select 0;
{
_category = configname  _x;
{
if (configname _x == _type) then {
BIS_fnc_configviewer_path = ['configfile','CfgWaypoints',_category];
BIS_fnc_configviewer_selected = _type;
[] call bis_fnc_configviewer;
breakto "findconfig_waypoint";
};
} foreach (configproperties [_x,"isclass _x"]);
} foreach (configproperties [configfile >> "cfgwaypoints","isclass _x"]);
};
case (typename ""): {
[] call bis_fnc_configviewer;

_type = (_entity get3DENAttribute "markerType") select 0;
if (_type == 0) then {
BIS_fnc_configviewer_path = ['configfile','CfgMarkers'];
BIS_fnc_configviewer_selected = (_entity get3DENAttribute "ItemClass") select 0;
} else {
BIS_fnc_configviewer_path = ['configfile','CfgMarkersBrushes'];
BIS_fnc_configviewer_selected = (_entity get3DENAttribute "MarkerBrush") select 0;
};
};
};
};
case "logclasses": {
_text = "";
_br = tostring [13,10];
_n = 0;
_entityTypes = ["object","logic","waypoint","marker"];
_entities = [get3DENSelected "object",get3DENSelected "logic",get3DENSelected "waypoint",get3DENSelected "marker"];
_showTypes = {count _x > 0} count _entities > 1;
{
_typeID = _foreachindex;
if (count _x > 0) then {
if (_n > 0) then {_text = _text + _br + _br;};
if (_showTypes) then {
_text = _text + format ["[%1]" + _br,gettext (configfile >> "cfg3DEN" >> (_entityTypes select _typeID) >> "textPlural")];
};
{
if (_foreachindex > 0) then {_text = _text + _br;};
_class = ((_x get3DENAttribute "itemclass") select 0);
if (_typeID == 2 && {isclass (configfile >> "cfgwaypoints" >> "default" >> _class)}) then {_class = str gettext(configfile >> "cfgwaypoints" >> "default" >> _class >> "type");};
_name = ((_x get3DENAttribute "name") select 0);
if (_name == "") then {
_text = _text + _class;
} else {
_text = _text + format ["%1 (%2)",_class,_name];
};
} foreach _x;
_n = _n + 1;
};
} foreach _entities;

copytoclipboard _text;
};
case "logposition": {
_input = uinamespace getvariable ["bis_fnc_3DENEntityMenu_data",[]];
_pos = _input param [0,[]];
_pos set [2,0];
_entity = _input param [1,nil];
if !(isnil "_entity") then {
_pos = switch true do {
case (_entity isequaltype grpnull): {(leader _entity get3DENAttribute "position") select 0};
case (_entity isequaltype ""): {_pos = (_entity get3DENAttribute "position") select 0; _pos resize 2; _pos};
default {(_entity get3DENAttribute "position") select 0};
};
};
copytoclipboard str _pos;
};
};
