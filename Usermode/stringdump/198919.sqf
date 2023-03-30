
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_3DENExportOldSQM'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_3DENExportOldSQM';
	scriptName _fnc_scriptName;

#line 1 "A3\3DEN\Functions\fn_3DENExportOldSQM.sqf [BIS_fnc_3DENExportOldSQM]"
#line 1 "A3\3DEN\Functions\fn_3DENExportOldSQM.sqf"
_br = tostring [13,10];
_export = "";
_tab = "";
_fnc_setTab = {
_tab = "";
for "_i" from 1 to _this do {_tab = _tab + "	";};
};
_fnc_addLine = {
_export = _export + _tab + _this + _br;
};
_idObj = 1;



"version=12;" call _fnc_addLine;
"class Mission" call _fnc_addLine;
"{" call _fnc_addLine;
1 call _fnc_setTab;
"addOns[]={};" call _fnc_addLine;
"addOnsAuto[]={};" call _fnc_addLine;
"randomSeed=42;" call _fnc_addLine;


"class Intel" call _fnc_addLine;
"{" call _fnc_addLine;
2 call _fnc_setTab;
1 call _fnc_setTab;
"};" call _fnc_addLine;


"class Groups" call _fnc_addLine;
"{" call _fnc_addLine;
2 call _fnc_setTab;
_id = 0;
format ["items=%1;",count allgroups] call _fnc_addLine;
{
format ["class Item%1",_id] call _fnc_addLine;
"{" call _fnc_addLine;
3 call _fnc_setTab;
format ["side=""%1"";",side _x] call _fnc_addLine;


"class Vehicles" call _fnc_addLine;
"{" call _fnc_addLine;
4 call _fnc_setTab;
_idUnits = 0;
format ["items=%1;",count units _x] call _fnc_addLine;
{
format ["class Item%1",_idUnits] call _fnc_addLine;
"{" call _fnc_addLine;
5 call _fnc_setTab;

format ["side=""%1"";",side _x] call _fnc_addLine;
format ["vehicle=""%1"";",typeof _x] call _fnc_addLine;
format ["id=%1;",_idObj] call _fnc_addLine;
format ["position[]={%1,%2,%3};",getposasl _x select 0,getposasl _x select 2,getposasl _x select 1] call _fnc_addLine;
format ["azimut=%1;",direction _x] call _fnc_addLine;
format ["offsetY=%1;",getposatl _x select 2] call _fnc_addLine;
format ["leader=%1;",parseNumber (_x == leader _x)] call _fnc_addLine;
format ["skill=%1;",skill _x] call _fnc_addLine;

4 call _fnc_setTab;
"};" call _fnc_addLine;
_idUnits = _idUnits + 1;
_idObj = _idObj + 1;
} foreach units _x;
3 call _fnc_setTab;
"};" call _fnc_addLine;

2 call _fnc_setTab;
"};" call _fnc_addLine;
_id = _id + 1;
} foreach allgroups;
1 call _fnc_setTab;
"};" call _fnc_addLine;



"class Vehicles" call _fnc_addLine;
"{" call _fnc_addLine;
2 call _fnc_setTab;
_id = 0;
format ["items=%1;",{isnull group _x} count (allmissionobjects "All")] call _fnc_addLine;
{
if (isnull group _x) then {
format ["class Item%1",_id] call _fnc_addLine;
"{" call _fnc_addLine;
3 call _fnc_setTab;

"side=""EMPTY"";" call _fnc_addLine;
format ["vehicle=""%1"";",typeof _x] call _fnc_addLine;
format ["id=%1;",_idObj] call _fnc_addLine;
format ["position[]={%1,%2,%3};",getposasl _x select 0,getposasl _x select 2,getposasl _x select 1] call _fnc_addLine;
format ["azimut=%1;",direction _x] call _fnc_addLine;
format ["offsetY=%1;",getposatl _x select 2] call _fnc_addLine;

2 call _fnc_setTab;
"};" call _fnc_addLine;
_id = _id + 1;
_idObj = _idObj + 1;
};
} foreach (allmissionobjects "All");
1 call _fnc_setTab;
"};" call _fnc_addLine;

0 call _fnc_setTab;
"};" call _fnc_addLine;



{
format ["class %1",_x] call _fnc_addLine;
"{" call _fnc_addLine;
1 call _fnc_setTab;
"addOns[]={};" call _fnc_addLine;
"addOnsAuto[]={};" call _fnc_addLine;
"randomSeed=42;" call _fnc_addLine;

"class Intel" call _fnc_addLine;
"{" call _fnc_addLine;
2 call _fnc_setTab;
1 call _fnc_setTab;
"};" call _fnc_addLine;

0 call _fnc_setTab;
"};" call _fnc_addLine;
} foreach ["Intro","OutroWin","OutroLoose"];

copytoclipboard _export;
titletext ["SQM code copied to clipboard","plain"];
