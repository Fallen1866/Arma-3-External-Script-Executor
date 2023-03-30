#line 0 "/temp/bin/A3/Functions_F/GUI/fn_guiHint.sqf"






































disableserialization;
private ["_posX","_posY","_posW","_posH","_textHeader","_textMessage","_pos","_buttonW","_buttonH","_posText","_idc","_result"];

private [
	"_textMessage",
	"_textHeader",
	"_buttonTextRight",
	"_buttonTextLeft",
	"_buttonTextMiddle",
	"_picturePos",
	"_exitDelay",
	"_GUI_GRID",
	"_GUI_GRID_X",
	"_GUI_GRID_Y",
	"_GUI_GRID_w",
	"_GUI_GRID_H",
	"_pictureW",
	"_pictureH",
	"_textPicture",
	"_textMessageCount",
	"_paddingW",
	"_paddingWpicture",
	"_paddingH",
	"_marginBcgW",
	"_marginBcgH",
	"_posW",
	"_posH",
	"_posX",
	"_posY",
	"_buttonW",
	"_buttonH",
	"_pos",
	"_posPicture",
	"_posText",
	"_posListbox",
	"_posSubText",
	"_fnc_bcg",
	"_buttonTextRightDisable",
	"_buttonCodeRight",
	"_buttonTextLeftDisable",
	"_buttonCodeLeft",
	"_buttonTextMiddleDisable",
	"_buttonCodeMiddle",
	"_idc",
	"_display",
	"_result"
];

BIS_fnc_guiHint_status = 0;
_textMessage =		_this param [0,[],[[]]];
_textHeader =		_this param [1,"",["",parsetext ""]];
_buttonTextRight =	_this param [2,localize "STR_DISP_OK",["",[]]];
_buttonTextLeft =	_this param [3,"",["",[]]];
_buttonTextMiddle =	_this param [4,"",["",[]]];
_picturePos =		_this param [5,[],[0,[]]];









["GUI", "GRID_CENTER"] call BIS_fnc_guiGrid params ["_GUI_GRID_X", "_GUI_GRID_Y", "_GUI_GRID_W", "_GUI_GRID_H"];


if (typename _picturePos == typename 0) then {_picturePos = [_picturePos];};
_pictureW = _picturePos param [0,6,[0]];
_pictureH = _picturePos param [1,12,[0]];
_pictureW = _pictureW * _GUI_GRID_W;
_pictureH = _pictureH * _GUI_GRID_H;
_textPicture = "";
_textMessageCount = 0;


_paddingW = 0.5 * _GUI_GRID_W;
_paddingWpicture = if (_pictureW <= 0) then {0} else {_paddingW};
_paddingH = 0.5 * _GUI_GRID_H;
_marginBcgW = 0.2 * _GUI_GRID_W * 0;
_marginBcgH = 0.2 * _GUI_GRID_W * 0;


_posW = 18 * _GUI_GRID_W;
_posH = _pictureH + _GUI_GRID_H * 2 + _paddingH * 2;
_posX = safezoneX + (safezoneW - _posW) / 2;
_posY = safezoneY + (safezoneH - _posH) / 2;


_pictureOnly = if (_pictureW >= (_posW - _paddingW * 2)) then {
	_pictureW = _posW - _paddingW * 2;
	true
} else {
	false
};


_buttonW = _posW / 3;
_buttonH = _GUI_GRID_H;
_pos = [
	_posX,
	_posY,
	_posW,
	_posH
];
_posPicture = [
	_posX + _paddingWpicture,
	_posY + _paddingH + _GUI_GRID_H,
	_pictureW,
	_pictureH
];
_posText = [
	(_posPicture select 0) + _pictureW + _paddingW,
	(_posPicture select 1),
	_posW - _pictureW - _paddingW * 2 - _paddingWpicture,
	_pictureH
];
_posListbox = [
	_posX + _paddingW,
	(_posPicture select 1),
	_posW - _pictureW - _paddingW * 2 - _paddingWpicture,
	_pictureH / 2
];
_posSubText = [
	0,
	0,
	(_posText select 2) - _paddingW,
	0
];
_fnc_bcg = {
	[
		(_this select 0) - _marginBcgW,
		(_this select 1) - _marginBcgH,
		(_this select 2) + _marginBcgW * 2,
		(_this select 3) + _marginBcgH * 2
	]
};


_buttonTextRightDisable = false;
_buttonDelayRight = _buttonTextRight param [2,1,[1]];
_buttonCodeRight = _buttonTextRight param [1,{},[{}]];
if (typename _buttonTextRight == typename []) then {
	_buttonTextRightDisable = count _buttonTextRight <= 1;
};
_buttonTextRight = _buttonTextRight param [0,"",[""]];
uinamespace setvariable [_fnc_scriptname + "_codeRight",_buttonCodeRight];

_buttonTextLeftDisable = false;
_buttonDelayLeft = _buttonTextLeft param [2,1,[1]];
_buttonCodeLeft = _buttonTextLeft param [1,{},[{}]];
if (typename _buttonTextLeft == typename []) then {
	_buttonTextLeftDisable = count _buttonTextLeft <= 1;
};
_buttonTextLeft = _buttonTextLeft param [0,"",[""]];
uinamespace setvariable [_fnc_scriptname + "_codeLeft",_buttonCodeLeft];

_buttonTextMiddleDisable = false;
_buttonDelayMiddle = _buttonTextMiddle param [2,1,[1]];
_buttonCodeMiddle = _buttonTextMiddle param [1,{},[{}]];
if (typename _buttonTextMiddle == typename []) then {
	_buttonTextMiddleDisable = count _buttonTextMiddle <= 1;
};
_buttonTextMiddle = _buttonTextMiddle param [0,"",[""]];
uinamespace setvariable [_fnc_scriptname + "_codeMiddle",_buttonCodeMiddle];

if (isnil {(uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint')}) then {uinamespace setvariable ['Hsim_RscDisplayCommonHint_guiHint',displaynull]};



[nil,4000] call BIS_fnc_guiBackground;
[_pos] call BIS_fnc_guiBackground;


createdialog "RscDisplayCommonHint";
uinamespace setvariable ['Hsim_RscDisplayCommonHint_guiHint',uinamespace getvariable "HSim_RscDisplayCommonHint"];



_idc = 1101;
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
	_posX + _GUI_GRID_W * 0.1,
	_posY + _GUI_GRID_H * 0.07,
	_posW,
	_GUI_GRID_H
];
if (typename _textHeader == typename "") then {
	_textHeader = parsetext format ["<t align='left' size='1.3'>%1</t>",_textHeader];
};
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetstructuredtext _textHeader;
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;



if (count _textMessage > 0) then{
	if (typename (_textMessage select 0) == typename []) then {
		_textMessageCount = count _textMessage + 1;

		
		_idc = 1500;
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
			_posText select 0,
			_posText select 1,
			_posText select 2,
			0.04 * _textMessageCount
		];
		{
			private ["_lbText","_lbPicture"];
			_lbText =	_x param [0,"",["",[]]];
			_lbIcon =	_x param [3,"",[""]];
			_lbAdd = ((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) lbadd _lbText;

			
			if (_lbIcon != "") then {
				_lbPicture = _x param [1,"",[""]];
				((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) lbsetpicture [_lbAdd,_lbIcon];
			};
		} foreach _textMessage;
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrladdeventhandler ["LBDblClick","BIS_fnc_guiHint_status = +1; ((ctrlParent (_this select 0)) closeDisplay 3000);"];

		
		uinamespace setvariable [_fnc_scriptname + "_textMessage",_textMessage];
		uinamespace setvariable [_fnc_scriptname + "_lbselchanged",{
			disableserialization;
			_params = _this select 0;
			_fnc_scriptName = _this select 1;

			_control = _params select 0;
			_lbId = _params select 1;
			if (_lbId >= 0) then {
				uinamespace setvariable [_fnc_scriptname + "_cursel",_lbId];

				_textMessage = uinamespace getvariable (_fnc_scriptname + "_textMessage");
				_lbArray = _textMessage select _lbId;
				if (typename _lbArray == typename []) then {
					_lbMessage = _lbArray param [1,"",[""]];
					_lbPicture = _lbArray param [2,"#(argb,8,8,3)color(1,0,1,1)",[""]];

					_idc = 1100;
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetstructuredtext parsetext _lbMessage;
					_ctrlPos = ctrlposition ((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc);
					_ctrlPos set [3,ctrltextheight ((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc)];
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition _ctrlPos;
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;

					_idc = 1200;
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsettext _lbPicture;
				} else {
					_idc = 1100;
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetstructuredtext parsetext "";
					_idc = 1200;
					((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsettext "#(argb,8,8,3)color(1,0,1,1)";
				};
			};
		}];

		
		uinamespace setvariable [_fnc_scriptname + "_cursel",if !(isnil "BIS_fnc_guiHint_curselCustom") then {BIS_fnc_guiHint_curselCustom} else {0}];
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrladdeventhandler [
			"lbselchanged",
			format ["[_this,'%1'] call (uinamespace getvariable '%1_lbselchanged');",_fnc_scriptName]
		];
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) lbsetcursel (uinamespace getvariable (_fnc_scriptname + "_cursel"));
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;

		
		
		
	} else {
		_textPicture = _textMessage param [1,"#(argb,8,8,3)color(1,0,1,1)",[""]];
		_textMessage = _textMessage param [0,"",[""]];
	};

	
	_idc = 2300;
	_sizeEx = getnumber ((configfile >> "RscDisplayCommonHint") >> "controls" >> "HintListbox" >> "sizeex");
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
		(_posText select 0),
		(_posText select 1) + _sizeEx * _textMessageCount,
		(_posText select 2),
		(_posText select 3) - _sizeEx * _textMessageCount
	];
	if (typename _textMessage == typename "") then {
		_textMessage = parsetext format ["<t align='left'>%1</t>",_textMessage];
	};
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetbackgroundcolor [1,0,1,1];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;

	_idc = 1100;
	if (typename _textMessage != typename []) then {
		((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetstructuredtext _textMessage;
	};
	_posSubText set [3,ctrltextheight ((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc)];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition _posSubText;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;
};









_posPicture = _posPicture call _fnc_bcg;


_idc = 1200;
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition _posPicture;

if (_pictureW < _GUI_GRID_W / 2) then {((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlshow false} else {((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlshow true};
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;



if (_buttonTextRight!= "") then {
	
	_idc = 1701;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
		_posX + _posW - _buttonW * 1,
		_posY + _posH - _buttonH,
		_buttonW,
		_buttonH
	];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsettext _buttonTextRight;

	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrladdeventhandler ["buttonclick",format ["with uinamespace do {[1,_this,%1] spawn bis_fnc_guiHint_buttonclick;};",_buttonDelayRight]];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
	ctrlsetfocus ((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc);
	if (_buttonTextRightDisable) then {((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlenable false;};
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;
};


if (_buttonTextLeft != "") then {
	
	
	_idc = 1700;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
		
		_posX,
		_posY + _posH - _buttonH,
		_buttonW,
		_buttonH
	];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsettext _buttonTextLeft;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrladdeventhandler ["buttonclick",format ["with uinamespace do {[-1,_this,%1] spawn bis_fnc_guiHint_buttonclick;};",_buttonDelayLeft]];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
	if (_buttonTextLeftDisable) then {((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlenable false;};
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;
};


if (_buttonTextMiddle != "") then {
	
	_idc = 1702;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetposition [
		_posX + _posW - _buttonW * 2,
		_posY + _posH - _buttonH,
		_buttonW,
		_buttonH
	];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsettext _buttonTextMiddle;
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrladdeventhandler ["buttonclick",format ["with uinamespace do {[0,_this,%1] spawn bis_fnc_guiHint_buttonclick;};",_buttonDelayMiddle]];
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0;
	if (_buttonTextMiddleDisable) then {((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlenable false;};
	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 0; 	((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;
};



uinamespace setvariable [
	_fnc_scriptname + "_buttonClick",
	{
		_status = _this select 0;
		_delay = _this select 2;
		_this = _this select 1;
		missionnamespace setvariable ["BIS_fnc_guiHint_status",_status];

		disableserialization;
		_button = _this select 0;
		_display = ctrlParent _button;

		
		_button ctrlremovealleventhandlers "buttonclick";

		
		_controls = [(configfile >> "RscDisplayCommonHint"),0,false] call bis_fnc_displaycontrols;
		{
			if (_x < 10000) then {
				_idc = _x;
				((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlsetfade 1;
				((uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayctrl _idc) ctrlcommit 0.3;
			};
		} foreach _controls;
		uisleep 0.3;

		
		_codeName = switch _status do {
			case -1: {"BIS_fnc_guiHint_codeLeft"};
			case 0: {"BIS_fnc_guiHint_codeMiddle"};
			case +1: {"BIS_fnc_guiHint_codeRight"};
			default {""}
		};
		_code = uinamespace getvariable [_codeName,{}];
		with missionnamespace do {[] spawn _code;};

		
		_time = diag_ticktime + _delay;
		waituntil {(uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') != _display || diag_ticktime > _time};
		_display closeDisplay 3000;
	}
];
uinamespace setvariable [
	_fnc_scriptname + "_unLoad",
	{
		if (isnull (uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint')) then {
			uinamespace setvariable ["BIS_fnc_guiHint_buttonclick",nil];
			uinamespace setvariable ["BIS_fnc_guiHint_unload",nil];
		};
		_exitCode = uinamespace getvariable ["BIS_fnc_guiHint_codeMiddle",{}];
		call _exitCode;
		true
	}
];
(uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint') displayaddeventhandler ["unload","with uinamespace do {_this spawn bis_fnc_guiHint_unload;};"];













_display = (uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint');
waituntil {_display != (uinamespace getvariable 'Hsim_RscDisplayCommonHint_guiHint')};

_result = [BIS_fnc_guiHint_status];
if (!isnil {uinamespace getvariable (_fnc_scriptname + "_cursel")}) then {_result = _result + [uinamespace getvariable (_fnc_scriptname + "_cursel")]};

_result
