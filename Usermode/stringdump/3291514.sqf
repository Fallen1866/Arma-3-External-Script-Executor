
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_3DENExportSQF'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_3DENExportSQF';
	scriptName _fnc_scriptName;

#line 1 "A3\3DEN\Functions\fn_3DENExportSQF.sqf [BIS_fnc_3DENExportSQF]"
#line 1 "A3\3DEN\Functions\fn_3DENExportSQF.sqf"

















#line 1 "a3\3DEN\UI\resincl.inc"












































































































































































































































































































































































































































































































































#line 4 "A3\3DEN\Functions\fn_3DENExportSQF.sqf"


if (!is3den) exitwith {"The function can run only in Eden Editor workspace!"};
if (missionname == "") exitwith {"MissionExportError" call bis_fnc_3DENNotification;};

disableserialization;
params [
["_showWindow",true,[true]],
["_exportLayers",true,[true]],
["_posCenter",[0,0,0],[[]]],
["_exportIdBlacklist",false,[false]]
];

_posCenter = _posCenter vectormultiply -1;
_isRelative = !(_posCenter isequalto [0,0,0]);


private _attributes = [[],[],[],[],[],[]];
{
private _type = _x;
private _null = [objnull,grpnull,objnull,objnull,[],""] # _foreachindex;
private _array = _attributes # _foreachindex;
{
{
private _expression = gettext (_x >> "expression");
if (_expression != "") then {
while {_expression find "_value" >= 0} do {
private _index = _expression find "_value";
_expression = (_expression select [0,_index]) + "%1" + (_expression select [_index + 6,count _expression - _index - 1]);
};
};

private _defaultValue = _null call compile gettext (_x >> "defaultValue");
if (isnil "_defaultValue") then {_defaultValue = {};};
if (configname _x == "ammoBox") then {_defaultValue = "";}; 

private _condition = gettext (_x >> "condition");
if (_condition in ["","0"]) then {_condition = "1";};
_array pushback [
configname _x,
tolower gettext (_x >> "data"),
tolower gettext (_x >> "property"),
_expression + ";",
_defaultValue,
compile _condition
];
} foreach ("true" configclasses (_x >> "Attributes"));
} foreach ("true" configclasses (configfile >> "Cfg3DEN" >> _type >> "AttributeCategories"));
} foreach ["object","group","trigger","logic","waypoint","marker"];
private _vehicles = [];
private _allConnections = [];


private _export = "";
private _tab = "";
private _tabCount = 0;
private _fnc_setTab = {
_tab = "";
_tabCount = _tabCount + _this;
for "_i" from 1 to _tabCount do {_tab = _tab + "	";};
};
private _fnc_addLine = {
_export = _export + _tab + _this + endl;
};
private _fnc_addConnections = {
params ["_entity"];
private _connections = get3denconnections _entity;
{
_x params ["_type","_target"];
if (_type isequaltype "") then { 
_type = tolower _type;
private _typeID = _allConnections find _type;
if (_typeID < 0) then {
_typeID = _allConnections pushback _type;
_allConnections pushback [];
};
private _data = _allConnections # (_typeID + 1);
if !([_target,_entity] in _data) then {_data pushback [_entity,_target];};
};
} foreach _connections;
};
private _fnc_addCustomArea = {
params ["_entity"];
private _size3 = (_entity get3denattribute "size3") # 0;
if !(_size3 isequalto [0,0,0]) then {
format [
if (_isRelative) then {
"_this setVariable [""objectArea"",[%1,%2,%3 - _dir,%4,%5]];"
} else {
"_this setVariable [""objectArea"",[%1,%2,%3,%4,%5]];"
},
_size3 # 0,
_size3 # 1,
direction _entity,
(_entity get3denattribute "IsRectangle") # 0,
if ((_size3 # 2) > 0) then {_size3 # 2} else {-1}
] call _fnc_addLine;
};
};
private _fnc_getRandomStart = {
params ["_entity"];
private _randomStarts = "";
{
if ((_x param [0,""]) isequalto "RandomStart") then {
if (_randomStarts != "") then {_randomStarts = _randomStarts + ",";};
_randomStarts = _randomStarts + format ["_item%1",get3DENEntityID (_x # 1)];
};
} foreach get3denconnections _entity;
"[" + _randomStarts + "]"
};
_fnc_setObjectAttributes = {
params ["_entity","_cfg"];
if (isclass (_cfg >> "Attributes")) then {
{
private _property = gettext (_x >> "property");
if (_property != "") then {
private _expression = gettext (_x >> "expression");
if (_expression != "") then {
private _value = (_entity get3denattribute _property) # 0;
if !(isnil "_value") then {
private _valueStr = str _value;


while {_expression find "%s" >= 0} do {
private _index = _expression find "%s";
_expression = (_expression select [0,_index]) + "%1" + (_expression select [_index + 2,count _expression - _index - 1]);
};
_expression = format [_expression,configname _x];


private _expressionArray = [];
while {_expression find "_value" >= 0} do {
private _index = _expression find "_value";
_expressionArray append [_expression select [0,_index],_valueStr];
_expression = _expression select [_index + 6,count _expression - _index - 1];
};
_expressionArray pushback _expression;
((_expressionArray joinstring "") + ";") call _fnc_addLine;






};
};
};
} foreach ("true" configclasses (_cfg >> "Attributes"));
} else {
{
_property = format ["%1_%2",typeof _entity,configname _x];
private _value = (_entity get3denattribute _property) # 0;
format [_argumentExpression,configname _x,str _value] call _fnc_addLine;
} foreach ("true" configclasses (_cfg >> "Arguments"));
};
};
private _formatLayer = if (_exportIdBlacklist) then {"if (%2 && {!(%1 in _idBlacklist)}) then {"} else {"if (%2) then {"};
private _formatLayerRoot = if (_exportIdBlacklist) then {"if (_layerRoot && {!(%1 in _idBlacklist)}) then {"} else {"if (_layerRoot) then {"};
_fnc_layerCondition = {
if !(_exportLayers) exitwith {false};
params ["_itemID","_null"];
private _itemLayers = [];
{if (_itemID in _x) then {_itemLayers pushback (_layers # _foreachindex);};} foreach _layerEntities;
private _isLayer = !(_itemLayers isequalto []);
if (_isLayer) then {
format ["private %1 = %2;",_var,_null] call _fnc_addLine;
_layerCondition = "";
{
if (_foreachindex > 0) then {_layerCondition = _layerCondition + " && ";};
_layerCondition = _layerCondition + "_layer" + str _x;
} foreach _itemLayers;
format [_formatLayer,_itemID,_layerCondition] call _fnc_addLine;
+1 call _fnc_setTab;
} else {
format ["private %1 = %2;",_var,_null] call _fnc_addLine;
format [_formatLayerRoot,_itemID] call _fnc_addLine;
+1 call _fnc_setTab;
_isLayer = true;
};
_isLayer
};
private _argumentExpression = gettext (configfile >> "Cfg3DEN" >> "Logic" >> "AttributeCategoryCustom" >> "expression");
if (_argumentExpression != "") then {
while {_argumentExpression find "%s" >= 0} do {
private _index = _argumentExpression find "%s";
_argumentExpression = (_argumentExpression select [0,_index]) + "%1" + (_argumentExpression select [_index + 2,count _argumentExpression - _index - 1]);
};
while {_argumentExpression find "_value" >= 0} do {
private _index = _argumentExpression find "_value";
_argumentExpression = (_argumentExpression select [0,_index]) + "%2" + (_argumentExpression select [_index + 6,count _argumentExpression - _index - 1]);
};
};
_argumentExpression = _argumentExpression + ";";


format ["// Export of '%1.%2' by %3 on v%4",missionname,worldname,profilename,	0.9] call _fnc_addLine;
if (_isRelative) then {
"#define ROTATE_VECTOR(POS_X,POS_Y,POS_Z)	[POS_X * _cD - POS_Y * _sD,POS_X * _sD + POS_Y * _cD,POS_Z]" call _fnc_addLine;
};


all3DENEntities params ["_objects","_groups","_triggers","_logics","_waypoints","_markers","_layers"];


reverse _layers; 
private _allEntities = [];
private _layerEntities = [];
_layerEntities resize count _layers;
_layerEntities = _layerEntities apply {[]};
if (_exportLayers) then {
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Init" call _fnc_addLine;
"params [[""_layerWhiteList"",[],[[]]],[""_layerBlacklist"",[],[[]]],[""_posCenter"",[0,0,0],[[]]],[""_dir"",0,[0]],[""_idBlacklist"",[],[[]]]];" call _fnc_addLine;
"private _allWhitelisted = _layerWhiteList isEqualTo [];" call _fnc_addLine;
"private _layerRoot = (_allWhitelisted || {true in _layerWhiteList}) && {!(true in _layerBlackList)};" call _fnc_addLine;
if (_isRelative) then {
"private _sD = sin _dir;" call _fnc_addLine;
"private _cD = cos _dir;" call _fnc_addLine;
};
{
private _layerID = get3denentityID _x;
private _entities = _layerEntities # _foreachindex;
{
private _entityID = get3denentityID _x;
if (_x isequaltype grpnull) then {
_entities append (units _x apply {get3denentityID _x});
} else {
if (_entityID in _layers) then {
_entities append (_layerEntities # (_layers find _entityID));
};
};
_entities pushback _entityID;
} foreach get3DENLayerEntities _x;
if !(_entities isequalto []) then {
_allEntities append (_entities - _allEntities);
format ["private _layer%1 = (_allWhitelisted || {""%2"" in _layerWhiteList}) && {!(""%2"" in _layerBlackList)};",_x,tolower ((_x get3denattribute "name") # 0)] call _fnc_addLine;
};
} foreach _layers;
};



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Markers" call _fnc_addLine;
"private _markers = [];" call _fnc_addLine;
"private _markerIDs = [];" call _fnc_addLine;
{
private _marker = _x;
private _markerID = get3DENEntityID _marker;
private _var = "_item" + str _markerID;


"" call _fnc_addLine;
private _isLayer = [_markerID,""""""] call _fnc_layerCondition;


private _pos = ((_marker get3denattribute "position") # 0) vectoradd _posCenter;
_pos set [2,0]; 
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
format [
"%1 = createMarker [""%2"",%3];",
_var,
(_marker get3denattribute "markerName") # 0,
_pos
] call _fnc_addLine;
format ["_this = %1;",_var] call _fnc_addLine;
"_markers pushback _this;" call _fnc_addLine;
format ["_markerIDs pushback %1;",_markerID] call _fnc_addLine;


if (_isRelative) then {
format ["_this setMarkerDir (%1 - _dir);",(_marker get3denattribute "rotation") # 0] call _fnc_addLine;
};


{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue"];
private _value = (if (_attData != "") then {_marker get3denattribute _attData} else {_marker get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "itemclass": {
if (_value != "ellipse" && _value != "rectangle") then {format ["_this setMarkerType ""%1"";",_value] call _fnc_addLine;};
};
case "text": {
format ["_this setMarkerText %1;",str _value] call _fnc_addLine;
};
case "size2": {
if !(_value isequalto [1,1]) then {format ["_this setMarkerSize %1;",_value] call _fnc_addLine;};
};
case "rotation": {
if (!_isRelative && _value != 0) then {format ["_this setMarkerDir %1;",_value] call _fnc_addLine;};
};
case "markertype": {
format ["_this setMarkerShape ""%1"";",["ICON","RECTANGLE","ELLIPSE"] select (_value + 1)] call _fnc_addLine;
};
case "brush": {
if (_value != "solid") then {format ["_this setMarkerBrush ""%1"";",_value] call _fnc_addLine;};
};
case "basecolor": {
if (_value != "default") then {format ["_this setMarkerColor ""%1"";",_value] call _fnc_addLine;};
};
case "alpha": {
if (_value != 1) then {format ["_this setMarkerAlpha %1;",_value] call _fnc_addLine;};
};
};
};
} foreach (_attributes # 5);

if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach _markers;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Groups" call _fnc_addLine;
"private _groups = [];" call _fnc_addLine;
"private _groupIDs = [];" call _fnc_addLine;
{
private _group = _x;
private _groupID = get3DENEntityID _group;
private _var = "_item" + str _groupID;


"" call _fnc_addLine;
private _isLayer = [_groupID,"grpNull"] call _fnc_layerCondition;


format [
"%1 = createGroup %2;",
_var,
["east","west","resistance","civilian","sideUnknown","sideEnemy","sideFriendly","sideLogic","sideEmpty","sideAmbientLife"] select (side _group call bis_fnc_sideID)
] call _fnc_addLine;
format ["_this = %1;",_var] call _fnc_addLine;
"_groups pushback _this;" call _fnc_addLine;
format ["_groupIDs pushback %1;",_groupID] call _fnc_addLine;

if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach _groups;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Objects" call _fnc_addLine;
"private _objects = [];" call _fnc_addLine;
"private _objectIDs = [];" call _fnc_addLine;
{
private _object = _x;
private _objectID = get3DENEntityID _object;
private _var = "_item" + str _objectID;

private _cfg = configfile >> "CfgVehicles" >> typeof _object;
private _simulation = gettext (_cfg >> "simulation");
if (_simulation != "uavpilot") then { 

private _valuePresence = (_object get3denattribute "presence") # 0;
private _valuePresenceCondition = (_object get3denattribute "presenceCondition") # 0;
private _isPresence = _valuePresence != 1;
private _isPresenceCondition = _valuePresenceCondition != "true";
private _isSimpleObject = (_object get3denattribute "objectIsSimple") # 0;

objectBrain = parseNumber (_simulation == "soldier" && !_isSimpleObject);
objectControllable = parseNumber (_object iskindof "CAManBase" && !_isSimpleObject);
objectAgent = parseNumber (count getarray (_cfg >> "agentTasks") > 0 && !_isSimpleObject);
objectVehicle = parseNumber (_object iskindof "AllVehicles" && objectBrain == 0 && !_isSimpleObject);
objectSimulated = parseNumber (!_isSimpleObject); 
objectHasInventoryCargo = parseNumber (!(_object iskindof "WeaponHolder") && {getnumber (_cfg >> "maximumLoad") > 0 && !_isSimpleObject});
objectDestructable = parseNumber (gettext (_cfg >> "destrType ") != "DestructNo" && !_isSimpleObject);


"" call _fnc_addLine;
private _isLayer = [_objectID,"objNull"] call _fnc_layerCondition;

if (_isPresence || _isPresenceCondition) then {
format ["%1 = objNull;",_var] call _fnc_addLine;
switch true do {
case (_isPresence && _isPresenceCondition): {format ["if (%1 && {random 1 < %2}) then {",_valuePresenceCondition,_valuePresence] call _fnc_addLine;};
case (_isPresence): {format ["if (random 1 < %1) then {",_valuePresence] call _fnc_addLine;};
case (_isPresenceCondition): {format ["if (%1) then {",_valuePresenceCondition] call _fnc_addLine;};
};
+1 call _fnc_setTab;
};


private _randomStart = "[]";
private "_pos";
if (_isSimpleObject) then {

_pos = getposaslvisual _object vectoradd _posCenter;
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
format [
"%1 = createSimpleObject [""%2"",%3];",
_var,
typeof _object,
_pos
] call _fnc_addLine;
} else {
_randomStart = _object call _fnc_getRandomStart;
_pos = ((_object get3denattribute "position") # 0) vectoradd _posCenter;
private _spawnType = if (objectVehicle > 0 && {(_pos # 2) >= 18.23}) then {"FLY"} else {"CAN_COLLIDE"};
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
if (isnull group _object || objectVehicle > 0) then {

if (gettext (_cfg >> "vehicleClass") == "Mines") then {

format [
"%1 = createMine [""%2"",%3,%4,%5];",
_var,
typeof _object,
_pos,
_randomStart,
(_object get3denattribute "placementRadius") # 0
] call _fnc_addLine;
} else {

format [
"%1 = createVehicle [""%2"",%3,%4,%5,""%6""];",
_var,
typeof _object,
_pos,
_randomStart,
(_object get3denattribute "placementRadius") # 0,
_spawnType
] call _fnc_addLine;
if (objectVehicle > 0) then {_vehicles pushback _object;};

if (unitisuav _object && count crew _object > 0) then {

format ["createVehicleCrew %1;",_var] call _fnc_addLine;
format ["private _crew = crew %1;",_var] call _fnc_addLine;
format ["_crew joinsilent _item%1;",get3DENEntityID group _object] call _fnc_addLine;
"_objects append _crew;" call _fnc_addLine;
"_objectIDs append (_crew apply {-1});" call _fnc_addLine;
};
};
} else {

format [
"%1 = _item%6 createUnit [""%2"",%3,%4,%5,""%7""];",
_var,
typeof _object,
_pos,
_randomStart,
(_object get3denattribute "placementRadius") # 0,
get3DENEntityID group _object,
_spawnType
] call _fnc_addLine;
if (_object == leader _object) then {format ["_item%1 selectLeader %2;",get3DENEntityID group _object,_var] call _fnc_addLine;};
};
};
format ["_this = %1;",_var] call _fnc_addLine;
"_objects pushback _this;" call _fnc_addLine;
format ["_objectIDs pushback %1;",_objectID] call _fnc_addLine;


if (_isRelative) then {
format ["_this setDir (%1 - _dir);",direction _object] call _fnc_addLine;
} else {
if (_randomStart == "[]") then {
format ["_this setPosWorld %1;",getposworld _object vectoradd _posCenter] call _fnc_addLine;
format ["_this setVectorDirAndUp %1;",[vectordir _object,vectorup _object]] call _fnc_addLine;
} else {
format ["_this setDir %1;",direction _object] call _fnc_addLine;
};
};
_object call _fnc_addCustomArea;


if (objectControllable > 0) then {
private _loadout = getunitloadout _object;
private _loadoutConfig = getunitloadout typeof _object;
_loadoutConfig set [7,_loadout  # 7]; 
if !(_loadout isequalto _loadoutConfig) then {
format ["_this setUnitLoadout %1;",_loadout] call _fnc_addLine;
};
};
private _objectTexture = (_object get3DENAttribute "objecttexture") # 0;
if (_objectTexture != "") then {format ["[_this,%1] call bis_fnc_initVehicle;",str _objectTexture] call _fnc_addLine;};


{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue","_attCondition"];
if (call _attCondition > 0) then { 
private _value = (if (_attData != "") then {_object get3denattribute _attData} else {_object get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "name": {
format ["%1 = _this;",_value] call _fnc_addLine;
format ["_this setVehicleVarName ""%1"";",_value] call _fnc_addLine;
};




case "controlsp": {
if (_value) then {format ["selectPlayer _this;",_var] call _fnc_addLine;};
};
case "controlmp": {
if (_value) then {format ["addSwitchableUnit _this;",_var] call _fnc_addLine;};
};
case "lock": {
if (objectVehicle > 0 && _value != 1) then {format ["_this lock %1;",_value] call _fnc_addLine;};
};
case "skill": {
if (objectBrain > 0 && _value != 0.5) then {format ["_this setSkill %1;",_value] call _fnc_addLine;};
};
case "health": {
if (_value != 1) then {format ["_this setDamage [%1,false];",1 - _value] call _fnc_addLine;};
};
case "fuel": {
if (objectVehicle > 0 && _value != 1) then {format ["_this setFuel %1;",_value] call _fnc_addLine;};
};
case "ammo": {
if (_value != 1) then {format ["_this setVehicleAmmo %1;",_value] call _fnc_addLine;};
};
case "rank": {
if (objectBrain > 0 && _value != "PRIVATE") then {format ["_this setRank ""%1"";",_value] call _fnc_addLine;};
};
case "unitpos": {
if (objectBrain > 0 && _value != 3) then {format ["_this setUnitPos ""%1"";",["UP","MIDDLE","DOWN","AUTO"] select _value] call _fnc_addLine;};
};
case "dynamicsimulation": {
if (_value) then {format ["_this enableDynamicSimulation %1;",_value] call _fnc_addLine;};
};
case "enablesimulation": {
if !(_value) then {format ["_this enableSimulation %1;",_value] call _fnc_addLine;};
};
case "hideobject": {
if (_value) then {format ["_this hideObject %1;",_value] call _fnc_addLine;};
};
case "reportremotetargets": {
if (_value) then {format ["_this setVehicleReportRemoteTargets %1;",_value] call _fnc_addLine;};
};
case "receiveremotetargets": {
if (_value) then {format ["_this setVehicleReceiveRemoteTargets %1;",_value] call _fnc_addLine;};
};
case "reportownposition": {
if (_value) then {format ["_this setVehicleReportOwnPosition %1;",_value] call _fnc_addLine;};
};
case "radarusageai": {
if (_value > 0) then {format ["_this setVehicleRadar %1;",_value] call _fnc_addLine;};
};
case "pylons": {
private _pylons = [];
while {_value != ""} do {
private _index = _value find ";";
if (_index < 0) then {_index = count _value - 1;};
private _pylon = _value select [0,_index];
private _turretIndex = _pylon find "[";
if (_turretIndex >= 0) then {_pylon = _pylon select [0,_turretIndex];};
_pylons pushback _pylon;
_value = _value select [_index + 1,count _value - 1];
};
{
format ["_this setPylonLoadout [%1,""%2""];",_foreachindex + 1,_x] call _fnc_addLine;
} foreach _pylons;
};
};
};
};
} foreach (_attributes # 0);


[_object,_cfg] call _fnc_setObjectAttributes;

if (_isPresence || _isPresenceCondition) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};

_object call _fnc_addConnections;
};
} foreach _objects;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Triggers" call _fnc_addLine;
"private _triggers = [];" call _fnc_addLine;
"private _triggerIDs = [];" call _fnc_addLine;
{
private _trigger = _x;
private _triggerID = get3DENEntityID _trigger;
private _var = "_item" + str _triggerID;


"" call _fnc_addLine;
private _isLayer = [_triggerID,"objNull"] call _fnc_layerCondition;

private _type = tolower ((_trigger get3denattribute "TriggerType") # 0);
private _pos = ((_trigger get3denattribute "position") # 0) vectoradd _posCenter;
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
if (_type in ["east g","west g","guer g"]) then {
format [
"createGuardedPoint [%1,%2,-1,objNull];",
["east","west","resistance"] # (["east g","west g","guer g"] find _type),
_pos
] call _fnc_addLine;
} else {


format [
"%1 = createTrigger [""%2"",%3,%4];",
_var,
typeof _trigger,
_pos,
!((_trigger get3denattribute "isServerOnly") # 0)
] call _fnc_addLine;
format ["_this = %1;",_var] call _fnc_addLine;
"_triggers pushback _this;" call _fnc_addLine;
format ["_triggerIDs pushback %1;",_triggerID] call _fnc_addLine;


format ["%1 setPosATL %2;",_var,_pos] call _fnc_addLine;
private _area = triggerarea _trigger;
if !(_area isequalto [0,0,0,false,-1]) then {
if (_isRelative) then {_area = format ["[%1,%2,%3 - _dir,%4,%5]",_area # 0,_area # 1,_area # 2,_area # 3,_area # 4]};
format ["_this setTriggerArea %1;",_area] call _fnc_addLine;
};

private _connections = get3DENConnections _trigger;
private _activation = [
if (_connections findif {(_x # 0) == "TriggerOwner"} >= 0) then {
(_trigger get3denattribute "ActivationByOwner") # 0
} else {
(_trigger get3denattribute "ActivationBy") # 0
},
["PRESENT","NOT PRESENT","WEST D","EAST D","GUER D","CIV D"] select ((_trigger get3denattribute "activationType") # 0),
(_trigger get3denattribute "repeatable") # 0
];
if !(_activation isequalto ["NONE","PRESENT",false]) then {
format (["_this setTriggerActivation [""%1"",""%2"",%3];"] + _activation) call _fnc_addLine;
};

private _statements = [
str ((_trigger get3denattribute "condition") # 0),
str ((_trigger get3denattribute "onActivation") # 0),
str ((_trigger get3denattribute "onDeactivation") # 0)
];
if !(_statements isequalto [str "this",str "",str ""]) then {
format (["_this setTriggerStatements [%1,%2,%3];"] + _statements) call _fnc_addLine;
};

private _triggerInterval = str ((_trigger get3DENAttribute "triggerInterval") # 0);
if (_triggerInterval isNotEqualTo "0.5") then 
{
format ["_this setTriggerInterval %1;", _triggerInterval] call _fnc_addLine;
};

private _sounds = [
((_trigger get3denattribute "sound") # 0),
((_trigger get3denattribute "voice") # 0),
((_trigger get3denattribute "soundEnvironment") # 0),
((_trigger get3denattribute "soundTrigger") # 0)
];
if !(_sounds isequalto ["$NONE$","","",""]) then {
format (["_this setSoundEffect [""%1"",""%2"",""%3"",""%4""];"] + _sounds) call _fnc_addLine;
};


{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue"];

private _value = (if (_attData != "") then {_trigger get3denattribute _attData} else {_trigger get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "name": {
format ["%1 = _this;",_value] call _fnc_addLine;
};
case "text": {
format ["_this setTriggerText %1;",str _value] call _fnc_addLine;
};
case "timeout": {
if !(_value isequalto [0,0,0]) then {
format [
"_this setTriggerTimeout %1;",
_value + (_trigger get3denattribute "interuptable")
] call _fnc_addLine;
};
};
case "effectcondition": {
if (_value != "true") then {format ["_this setEffectCondition ""%1"";",_value] call _fnc_addLine;};
};
case "music": {
if (_value != "$NONE$") then {format ["_this setMusicEffect ""%1"";",_value] call _fnc_addLine;};
};
case "title": {
if (true) then {format ["_this setTitleEffect [""RES"",""PLAIN"",""%1""];",_value] call _fnc_addLine;};
};
};
};
} foreach (_attributes # 2);

_trigger call _fnc_addConnections;
};

if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach _triggers;





"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Group attributes (applied only once group units exist)" call _fnc_addLine;
{
private _group = _x;
private _groupID = get3DENEntityID _group;
private _var = "_item" + str _groupID;

format ["_this = %1;",_var] call _fnc_addLine;
"if !(units _this isEqualTo []) then {" call _fnc_addLine;
+1 call _fnc_setTab;
"[_this,0] setWaypointPosition [position leader _this,0];" call _fnc_addLine;

{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue"];

private _value = (if (_attData != "") then {_groupID get3denattribute _attData} else {_groupID get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "name": {
format ["%1 = _this;",_value] call _fnc_addLine;
};




case "combatmode": {
if (_value != "YELLOW") then {format ["_this setCombatMode ""%1"";",_value] call _fnc_addLine;};
};
case "behaviour": {
if (_value != "AWARE") then {format ["_this setBehaviour ""%1"";",_value] call _fnc_addLine;};
};
case "formation": {
if (_value != 0) then {format ["_this setFormation ""%1"";",["WEDGE","VEE","LINE","COLUMN","FILE","STAG COLUMN","ECH LEFT","ECH RIGHT","DIAMOND"] select _value] call _fnc_addLine;};
};
case "speedmode": {
if (_value != 1) then {format ["_this setSpeedMode ""%1"";",["LIMITED","NORMAL","FULL"] select _value] call _fnc_addLine;};
};
case "dynamicsimulation": {
if (_value) then {format ["_this enableDynamicSimulation %1;",_value] call _fnc_addLine;};
};
case "deletewhenempty": {
if (_value) then {format ["_this deleteWhenEmpty %1;",_value] call _fnc_addLine;};
};
};
};
} foreach (_attributes # 1);

-1 call _fnc_setTab;
"};" call _fnc_addLine;
} foreach _groups;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Waypoints" call _fnc_addLine;
"private _waypoints = [];" call _fnc_addLine;
"private _waypointIDs = [];" call _fnc_addLine;
{
private _wp = _x;
private _wpID = get3denentityID _wp;
private _groupID = get3DENEntityID (_wp # 0);
private _var = "_item" + str _wpID;


"" call _fnc_addLine;
private _isLayer = [_groupID,"[]"] call _fnc_layerCondition;


private _pos = ((_wpID get3denattribute "position") # 0) vectoradd _posCenter;
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
format [
"%1 = _item%2 addWaypoint [%3,%4];",
_var,
_groupID,
_pos,
(_wpID get3denattribute "PlacementRadius") # 0
] call _fnc_addLine;
format ["_this = %1;",_var] call _fnc_addLine;
"_waypoints pushback _this;" call _fnc_addLine;
format ["_waypointIDs pushback %1;",_wpID] call _fnc_addLine;


private _statements = [
str ((_wpID get3denattribute "condition") # 0),
str ((_wpID get3denattribute "onActivation") # 0)
];
if !(_statements isequalto [str "true",str ""]) then {
format (["_this setWaypointStatements [%1,%2];"] + _statements) call _fnc_addLine;
};

private _sounds = [
((_wpID get3denattribute "sound") # 0),
((_wpID get3denattribute "voice") # 0),
((_wpID get3denattribute "soundEnvironment") # 0),
((_wpID get3denattribute "soundTrigger") # 0)
];
if !(_sounds isequalto ["$NONE$","","",""]) then {
format (["_this setSoundEffect [""%1"",""%2"",""%3"",""%4""];"] + _sounds) call _fnc_addLine;
};

if (((_wpID get3denattribute "itemClass") # 0) == "Loiter") then {
private _loiterDirection = (_wpID get3denattribute "loiterdirection") # 0;
private _loiterRadius = (_wpID get3denattribute "loiterradius") # 0;
if !(_loiterDirection) then {format ["_this setWaypointLoiterType ""%1"";",if (_loiterDirection) then {"CIRCLE"} else {"CIRCLE_L"}] call _fnc_addLine;};
if (_loiterRadius != -1) then {format ["_this setWaypointLoiterRadius %1;",_loiterRadius] call _fnc_addLine;};
};


{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue"];

private _value = (if (_attData != "") then {_wpID get3denattribute _attData} else {_wpID get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "itemclass": {
private _wpClass = configfile >> "CfgWaypoints" >> "Default" >> _value;
_value = if (isclass _wpClass) then {gettext (_wpClass >> "type")} else {"SCRIPTED";};
format ["_this setWaypointType %1;",str _value] call _fnc_addLine;
};
case "description": {
format ["_this setWaypointDescription %1;",str _value] call _fnc_addLine;
};
case "completionradius": {
if (_value != 0) then {format ["_this setWaypointCompletionRadius %1;",_value] call _fnc_addLine;};
};
case "combatmode": {
if (_value != "NO CHANGE") then {format ["_this setWaypointCombatMode ""%1"";",_value] call _fnc_addLine;};
};
case "behaviour": {
if (_value != "UNCHANGED") then {format ["_this setWaypointBehaviour ""%1"";",_value] call _fnc_addLine;};
};
case "formation": {
if (_value != 0) then {format ["_this setWaypointFormation ""%1"";",["NO CHANGE","WEDGE","VEE","LINE","COLUMN","FILE","STAG COLUMN","ECH LEFT","ECH RIGHT","DIAMOND"] select _value] call _fnc_addLine;};
};
case "speedmode": {
if (_value != 0) then {format ["_this setWaypointSpeed ""%1"";",["UNCHANGED","LIMITED","NORMAL","FULL"] select _value] call _fnc_addLine;};
};
case "script": {
if (_value != "") then {format ["_this setWaypointScript ""%1"";",_value] call _fnc_addLine;};
};
case "timeout": {
if !(_value isequalto [0,0,0]) then {format ["_this setWaypointTimeout %1;",_value] call _fnc_addLine;};
};
case "show2d": {
if (_value) then {format ["_this showWaypoint ""%1"";",["NEVER","ALWAYS"] select _value] call _fnc_addLine;};
};
case "show3d": {
if !(_value) then {format ["_this setWaypointVisible %1;",_value] call _fnc_addLine;};
};
case "effectcondition": {
if (_value != "true") then {format ["_this setEffectCondition ""%1"";",_value] call _fnc_addLine;};
};
case "music": {
if (_value != "$NONE$") then {format ["_this setMusicEffect ""%1"";",_value] call _fnc_addLine;};
};
case "title": {
format ["_this setTitleEffect [""RES"",""PLAIN"",""%1""];",_value] call _fnc_addLine;
};
};
};
} foreach (_attributes # 4);

_wp call _fnc_addConnections;

if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach _waypoints;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Logics" call _fnc_addLine;
"private _logics = [];" call _fnc_addLine;
"private _logicIDs = [];" call _fnc_addLine;
{
private _logic = _x;
private _logicID = get3DENEntityID _logic;
private _var = "_item" + str _logicID;


"" call _fnc_addLine;
private _isLayer = [_logicID,"objNull"] call _fnc_layerCondition;

private _valuePresence = (_logic get3denattribute "presence") # 0;
private _valuePresenceCondition = (_logic get3denattribute "presenceCondition") # 0;
private _isPresence = _valuePresence != 1;
private _isPresenceCondition = _valuePresenceCondition != "true";

if (_isPresence || _isPresenceCondition) then {
format ["%1 = objNull;",_var] call _fnc_addLine;
switch true do {
case (_isPresence && _isPresenceCondition): {format ["if (%1 && {random 1 < %2}) then {",_valuePresenceCondition,_valuePresence] call _fnc_addLine;};
case (_isPresence): {format ["if (random 1 < %1) then {",_valuePresence] call _fnc_addLine;};
case (_isPresenceCondition): {format ["if (%1) then {",_valuePresenceCondition] call _fnc_addLine;};
};
+1 call _fnc_setTab;
};


private _randomStart = _logic call _fnc_getRandomStart;
private _pos = ((_logic get3denattribute "position") # 0) vectoradd _posCenter;
if (_isRelative) then {_pos = format ["_posCenter vectorAdd ROTATE_VECTOR(%1,%2,%3)",_pos # 0,_pos # 1,_pos # 2];};
format [
"%1 = (group (missionNamespace getvariable [""BIS_functions_mainscope"",objnull])) createUnit [""%2"",%3,%4,%5,""CAN_COLLIDE""];",
_var,
typeof _logic,
_pos,
_randomStart,
(_logic get3denattribute "placementRadius") # 0
] call _fnc_addLine;
format ["_this = %1;",_var] call _fnc_addLine;
"_logics pushback _this;" call _fnc_addLine;
format ["_logicIDs pushback %1;",_logicID] call _fnc_addLine;


if (_randomStart == "[]") then {
format ["_this setPosWorld %1;",getposworld _logic vectoradd _posCenter] call _fnc_addLine;
format ["_this setVectorDirAndUp %1;",[vectordir _logic,vectorup _logic]] call _fnc_addLine;
} else {
format ["_this setDir %1;",direction _logic] call _fnc_addLine;
};
_logic call _fnc_addCustomArea;


{
_x params ["_attName","_attData","_attProperty","_attExpression","_attDefaultValue"];

private _value = (if (_attData != "") then {_logic get3denattribute _attData} else {_logic get3denattribute _attProperty}) # 0;
if (!isnil "_value" && {!(_value isequalto "") && {!(_value isequalto _attDefaultValue)}}) then {
switch _attData do {
case "": {
format [_attExpression,str _value] call _fnc_addLine;
};
case "name": {
format ["%1 = _this;",_value] call _fnc_addLine;
format ["_this setVehicleVarName ""%1"";",_value] call _fnc_addLine;
};




};
};
} foreach (_attributes # 3);


[_logic,configfile >> "CfgVehicles" >> typeof _logic] call _fnc_setObjectAttributes;

if (_logic iskindof "Module_F") then {"_this setvariable [""BIS_fnc_initModules_disableAutoActivation"",true];" call _fnc_addLine;};

if (_isPresence || _isPresenceCondition) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};

_logic call _fnc_addConnections;

if (_isLayer) then {
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach _logics;


if (_exportLayers) then {
"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Layers" call _fnc_addLine;
{
private _name = (_x get3denattribute "name") # 0;
private _layerObjects = "";
private _layerMarkers = "";
{
private _entity = get3denentity _x;
if (_entity isequaltype objnull) then {
if (gettext (configfile >> "cfgvehicles" >> typeof _entity >> "simulation") != "uavpilot") then {
if (_layerObjects != "") then {_layerObjects = _layerObjects + ",";};
_layerObjects = _layerObjects + "_item" + str _x;
};
} else {
if (_entity isequaltype "") then {
if (_layerMarkers != "") then {_layerMarkers = _layerMarkers + ",";};
_layerMarkers = _layerMarkers + "_item" + str _x;
};
};
} foreach (_layerEntities # _foreachindex);
if (_layerObjects != "" || _layerMarkers != "") then {
format [
"if (_layer%1) then {missionNamespace setVariable [""%2_%3"",[[%4],[%5]]];};",
_x,
missionname,
_name,
_layerObjects,
_layerMarkers
] call _fnc_addLine;
};
} foreach _layers;
};



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Crews" call _fnc_addLine;
{
private _vehicle = _x;
if !(unitisuav _vehicle) then {
private _vehicleID = get3DENEntityID _vehicle;
{
_x params ["_person","_role","_cargoIndex","_turretIndex"];
private _personID = get3DENEntityID _person;
private _roleText = switch (tolower _role) do {
case "driver":	{"_item%1 moveInDriver _item%2;"};
case "cargo":	{"_item%1 moveInCargo [_item%2,%3];"};
case "gunner";
case "commander";
case "turret":	{"_item%1 moveInTurret [_item%2,%4];"};
default {[]};
};
format ["if (!isNull _item%1 && !isNull _item%2) then {" + _roleText + "};",_personID,_vehicleID,_cargoIndex,_turretIndex] call _fnc_addLine;
} foreach (fullcrew _vehicle);
};
} foreach _vehicles;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Vehicle cargo" call _fnc_addLine;
{
private _vehicle = _x;
{
format ["if (!isNull _item%1 && !isNull _item%2) then {_item%1 setVehicleCargo _item%2;};",get3DENEntityID _vehicle,get3DENEntityID _x] call _fnc_addLine;
} foreach getvehiclecargo _x;
} foreach _vehicles;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Connections" call _fnc_addLine;
for "_i" from 0 to (count _allConnections - 1) step 2 do {
private _type = _allConnections # (_i);
private _data = _allConnections # (_i + 1);
switch _type do {
case "sync": {
{
_x params ["_item1","_item2"];
format ["if (!isNull _item%1 && !isNull _item%2) then {_item%1 synchronizeObjectsAdd [_item%2]; _item%2 synchronizeObjectsAdd [_item%1];};",get3DENEntityID _item1,get3DENEntityID _item2] call _fnc_addLine;
} foreach _data;
};
case "triggerowner": {
{
_x params ["_item1","_item2"];
if (_item1 iskindof "emptydetector") then {
format ["if (!isNull _item%1 && !isNull _item%2) then {_item%1 triggerAttachVehicle [_item%2];};",get3DENEntityID _item1,get3DENEntityID _item2] call _fnc_addLine;
} else {
format ["if (!isNull _item%1 && !isNull _item%2) then {_item%1 triggerAttachVehicle [_item%2];};",get3DENEntityID _item2,get3DENEntityID _item1] call _fnc_addLine;
};
} foreach _data;
};
case "waypointactivation": {
{
_x params ["_item1","_item2"];
if (_item1 isequaltype objnull) then {
format ["if (!isNull _item%1 && !(_item%2 isEqualTo [])) then {_item%1 synchronizeWaypoint [_item%2];};",get3DENEntityID _item1,get3DENEntityID _item2] call _fnc_addLine;
} else {
format ["if (!isNull _item%1 && !(_item%2 isEqualTo [])) then {_item%1 synchronizeWaypoint [_item%2];};",get3DENEntityID _item1,get3DENEntityID _item2] call _fnc_addLine;
};
} foreach _data;
};
};
};



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Inits (executed only once all entities exist; isNil used to ensure non-scheduled environment)" call _fnc_addLine;
"isNil {" call _fnc_addLine;
+1 call _fnc_setTab;
{
private _object = _x;
private _objectID = get3DENEntityID _object;
private _var = "_item" + str _objectID;
private _value = (_object get3denattribute "init") # 0;
if !(_value isequalto "") then {
format ["if !(isnull %1) then {",_var] call _fnc_addLine;
+1 call _fnc_setTab;
format ["this = %1;",_var] call _fnc_addLine;
(_value + ";") call _fnc_addLine;
-1 call _fnc_setTab;
"};" call _fnc_addLine;
};
} foreach (_groups + _objects + _logics);
-1 call _fnc_setTab;
"};" call _fnc_addLine;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"// Module activations (only once everything is spawned and connected)" call _fnc_addLine;
{
private _logic = _x;
private _logicID = get3DENEntityID _logic;
private _var = "_item" + str _logicID;
if (_logic iskindof "Module_F") then {format ["if !(isNull %1) then {%1 setvariable [""BIS_fnc_initModules_activate"",true];};",_var] call _fnc_addLine;};
} foreach _logics;



"" call _fnc_addLine;
"" call _fnc_addLine;
"///////////////////////////////////////////////////////////////////////////////////////////" call _fnc_addLine;
"[[_objects,_groups,_triggers,_waypoints,_logics,_markers],[_objectIDs,_groupIDs,_triggerIDs,_waypointIDs,_logicIDs,_markerIDs]]" call _fnc_addLine;

if (_showWindow) then {
uinamespace setvariable ["Display3DENCopy_data",[localize "STR_3DEN_Display3DEN_MenuBar_MissionTerrainBuilder_text",_export]];
(finddisplay 					313) createdisplay "Display3DENCopy";
};

objectBrain = nil;
objectControllable = nil;
objectAgent = nil;
objectVehicle = nil;
objectSimulated = nil;
objectHasInventoryCargo = nil;
objectDestructable = nil;

_export
