
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_3DENMissionPreview'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_3DENMissionPreview';
	scriptName _fnc_scriptName;

#line 1 "A3\3DEN\Functions\fn_3DENMissionPreview.sqf [BIS_fnc_3DENMissionPreview]"
#line 1 "A3\3DEN\Functions\fn_3DENMissionPreview.sqf"
#line 1 "a3\3DEN\UI\resincl.inc"












































































































































































































































































































































































































































































































































#line 1 "A3\3DEN\Functions\fn_3DENMissionPreview.sqf"


_input = param [0,"",["",{}]];

if (_input isequaltype {}) then {

uinamespace setvariable ["bis_fnc_3DENMissionPreview_code",_input];
do3DENAction "MissionPreview";
} else {
switch (tolower _input) do {


case "missionpreviewcustom": {
_veh = vehicle player;
_pos = uinamespace getvariable ["bis_fnc_3DENMissionPreview_pos",position get3DENCamera];
_posZ = if ((typeof _veh) iskindof "air" && isengineon _veh) then {

_pos select 2
} else {

_limit = 1;
_posASL = getposasl get3DENCamera;
if ((_pos select 2) > _limit && {lineIntersects [_posASL,[_posASL select 0,_posASL select 1,(_posASL select 2) - _limit]]}) then {
_pos select 2
} else {
0
};
};
_veh setpos [_pos select 0,_pos select 1,_posZ];
_veh setdir direction get3DENCamera;
};


case "missionpreviewspectator": {
["Initialize",[player,nil,true,true]] call BIS_fnc_EGSpectator;
_cam = ["GetCamera"] call bis_fnc_EGSpectator;
_cam setposasl getposasl get3DENCamera;
_cam setvectordirandup [vectordir get3DENCamera,vectorup get3DENCamera];

[] spawn {
disableserialization;
waituntil {!isnull ([] call bis_fnc_displayMission)};
([] call bis_fnc_displayMission) displayaddeventhandler [
"unload",
{
_cam = ["GetCamera"] call bis_fnc_EGSpectator;
uinamespace setvariable ["bis_fnc_3DENMissionPreview_camPos",[getposasl _cam,[vectordir _cam,vectorup _cam]]];
}
];
};
};


case "onmissionpreview": {
(_this param [1,[],[[]]]) call (uinamespace getvariable ["bis_fnc_3DENMissionPreview_code",{}]);


if (isnull player) then {
["Paste",[worldname,position get3dencamera,direction get3dencamera,nil,get3dencamera call bis_fnc_getpitchbank,nil,nil,nil,nil,1]] call bis_fnc_camera;
([] call bis_fnc_displayMission) displayaddeventhandler [
"unload",
{
if !(isnil "bis_fnc_camera_cam") then {
uinamespace setvariable ["bis_fnc_3DENMissionPreview_camPos",[getposasl bis_fnc_camera_cam,[vectordir bis_fnc_camera_cam,vectorup bis_fnc_camera_cam]]];
};
}
];
};
};


case "onmissionpreviewend": {
uinamespace setvariable ["bis_fnc_3DENMissionPreview_code",nil];
uinamespace setvariable ["bis_fnc_3DENMissionPreview_pos",nil];


ctrlsetfocus (finddisplay 					313 displayctrl 			52);


_camPos = uinamespace getvariable "bis_fnc_3DENMissionPreview_camPos";
if (!isnil "_camPos") then {
_camPos spawn {
get3DENCamera setposasl (_this select 0);
get3DENCamera setvectordirandup (_this select 1);
uinamespace setvariable ["bis_fnc_3DENMissionPreview_camPos",nil];
};
};
};
};
};
