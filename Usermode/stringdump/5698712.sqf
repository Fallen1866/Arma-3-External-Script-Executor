
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_OM_phone_SMS'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_OM_phone_SMS';
	scriptName _fnc_scriptName;

#line 1 "\A3\Missions_F_Oldman\Systems\scripts\Phone\fn_OM_phone_SMS.sqf [BIS_fnc_OM_phone_SMS]"
#line 1 "A3\Missions_F_Oldman\Systems\scripts\Phone\fn_OM_phone_SMS.sqf"
params ["_contact", "_text"];
_name = getText (missionConfigFile >> "CfgOMPhoneContacts" >> _contact >> "name");
_img = getText (missionConfigFile >> "CfgOMPhoneContacts" >> _contact >> "img");
_mapKeyBind = actionKeysNames "ShowMap";
_null = ["OMIncomingMessage", [_name + (if !(visibleMap) then {" " + "<t align = 'center'>[<t color = '#61af64'>" + _mapKeyBind + "</t>]" + " " + Localize "STR_A3_OM_System_Phone_SMSRead" + "</t>"} else {""}) + format ["<img image = '%1' size = '1.75' align = 'left' shadow = '0'>", _img]]] call BIS_fnc_shownotification;

isNil
{
BIS_OM_messageReceivedTime = time;
BIS_OM_messagesPool pushBack [_contact, _name, _text, [date] call BIS_fnc_OM_phone_correct_time, TRUE];
BIS_OM_unreadMessagesCnt = BIS_OM_unreadMessagesCnt + 1;	
findDisplay 46 displayCtrl 9999013 ctrlShow !visibleMap;
private _ctrlList = findDisplay 12 getVariable ["_ctrlList", controlNull];
if (visibleMap && { _ctrlList lbData lbCurSel _ctrlList == "Messages" }) then 
{
processDiaryLink "<log subject=""Map""></log>";
processDiaryLink "<log subject=""Messages""></log>";
};
};

BIS_OM_messagesLog = "<br/>";
_pool = +BIS_OM_messagesPool;
reverse _pool;
_cnt = count _pool;
{
_name = _x # 1;
_text = _x # 2;
_date = _x # 3;
_from = _x # 4;
_min = (_date select 4);

BIS_OM_messagesLog = BIS_OM_messagesLog + format ["%9 %1 <font color='#878787'>(%2/%3/%4, %5:%6)</font><br/>%7%8",
_name,
_date select 0,
_date select 1,
_date select 2,
_date select 3,
_min,
_text,
if (_forEachIndex != (_cnt - 1)) then {"<br/><br/>"} else {""},
if (_from) then {"<font color = '#0acd00'>From:</font>"} else {"<font color = '#0074cd'>To:</font>"}
];
} forEach _pool;
player setDiaryRecordText [["Messages", BIS_OM_phone_section_sms], ["Messages", BIS_OM_messagesLog]];

if (vehicle player == player) then {
playSound "OMPhoneRingSMS";
sleep 4;
} else {
playSound "OMPhoneRingVehicleSMS";
sleep 3;
};

TRUE

