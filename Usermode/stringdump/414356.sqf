
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_animatedScreen'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_animatedScreen';
	scriptName _fnc_scriptName;

#line 1 "\A3\Functions_F_Tacops\Systems\fn_animatedScreen.sqf [BIS_fnc_animatedScreen]"
#line 1 "A3\Functions_F_Tacops\Systems\fn_animatedScreen.sqf"
#line 1 "A3\Functions_F_Tacops\Systems\fn_animatedScreen.inc"









































































































































































#line 1 "A3\Functions_F_Tacops\Systems\fn_animatedScreen.sqf"













disableSerialization;

private _mode = param [0,						0,[123]];

if (_mode != 						0 && {isNull 					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull])}) exitWith {["[x] Display 'Animated Screen' doesn't exist!"] call bis_fnc_error;};

switch (_mode) do
{

case 						0:
{
if (!isNull 					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull])) then
{
["[!] Display 'Animated Screen' already exists!"] call bis_fnc_error;

[					1] call bis_fnc_animatedScreen;
};


				10 cutText ["","BLACK IN",10e10];

private _layers 		= param [1,			5,[123,[]]];
private _overscale 		= param [2,				1.05,[123]];
private _contentRatio	= param [3,			16/9,[123]];

_layers params
[
["_pictureLayers",			5,[123]],
["_textLayers",				0,[123]],
["_overlayLayers",			0,[123]]
];


						11 cutRsc ["RscAnimatedScreen","PLAIN",0,true];
private _display = 					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]);


_display setVariable ["#overscale",_overscale];
_display setVariable ["#contentRatio",_contentRatio];
_display setVariable ["#layers",_layers];

private _aspectRatio = safezoneW/safezoneH/0.75;
private _viewportW = safeZoneW;
private _viewportH = (safeZoneH * _aspectRatio / _contentRatio) min safeZoneH;
private _viewportX = safeZoneX;
private _viewportY = 0.5 - (_viewportH/2);


private _ctrlGroupViewport = _display ctrlCreate ["RscControlsGroupNoScrollbars",					100];
_ctrlGroupViewport ctrlSetPosition [_viewportX,_viewportY,_viewportW,_viewportH];
_ctrlGroupViewport ctrlCommit 0;


private _canvasW = safeZoneW * _overscale;
private _canvasH = _canvasW * 4/3;
private _canvasX = (1 - _overscale) * 0.5 * safeZoneW;
private _canvasY = (_viewportH - _canvasH)/2;
private _ctrlGroupCanvas = _display ctrlCreate ["RscControlsGroupNoScrollbars",						101,_ctrlGroupViewport];
_ctrlGroupCanvas ctrlSetPosition [_canvasX,_canvasY,_canvasW,_canvasH];
_ctrlGroupCanvas ctrlCommit 0;


for "_idc" from 0 to (_pictureLayers-1) do
{
private _ctrl = _display ctrlCreate ["RscPicture",_idc,_ctrlGroupCanvas];
_ctrl ctrlSetPosition [0,0,_canvasW,_canvasH];
_ctrl ctrlCommit 0;
};


private _ctrlGroupTexts = _display ctrlCreate ["RscControlsGroupNoScrollbars",						102,_ctrlGroupViewport];
_ctrlGroupTexts ctrlSetPosition [0,0,_viewportW,_viewportH];
_ctrlGroupTexts ctrlCommit 0;


for "_idc" from 0 to (_textLayers-1) do
{
private _ctrl = _display ctrlCreate ["RscStructuredText",_idc,_ctrlGroupTexts];
_ctrl ctrlSetPosition [0,0,_viewportW,_viewportH];
_ctrl ctrlCommit 0;
};


					16 cutRsc ["RscAnimatedScreenOverlay","PLAIN",0,true];
private _display = 					(uiNamespace getVariable ["bis_animatedScreen_displayOverlay",displayNull]);
private _ctrlGroupOverlay = _display ctrlCreate ["RscControlsGroupNoScrollbars",						100			];
_ctrlGroupOverlay ctrlSetPosition [_viewportX,_viewportY,_viewportW,_viewportH];
_ctrlGroupOverlay ctrlCommit 0;


for "_idc" from 0 to (_overlayLayers-1) do
{
private _ctrl = _display ctrlCreate ["RscStructuredText",_idc,_ctrlGroupOverlay];
_ctrl ctrlSetPosition [0,0,_viewportW,_viewportH];
_ctrl ctrlCommit 0;
};
};


case 						2:
{
private _display = 					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]);
private _flags = param [1,[],[[]]];
private _rscTypes = ["RscPicture","RscStructuredText","RscStructuredText"];

private _layers = _display getVariable ["#layers",[			5,				0,			0]];

{
private _reset = _flags param [_forEachIndex,false,[true]];

if (_reset) then
{
private _ctrlGroup = _x;
private _ctrlPosition = ctrlPosition _ctrlGroup; _ctrlPosition set [0,0]; _ctrlPosition set [1,0];
private _maxIDC = (_layers select _forEachIndex) - 1;

for "_idc" from 0 to _maxIDC do
{
private _ctrl = _ctrlGroup controlsGroupCtrl _idc;

if (!isNull(_ctrl getVariable ["#script_rotation",scriptNull])) then {terminate (_ctrl getVariable ["#script_rotation",scriptNull]);};
if (!isNull(_ctrl getVariable ["#script_pulsing",scriptNull])) then {terminate (_ctrl getVariable ["#script_pulsing",scriptNull]);};
if (!isNull(_ctrl getVariable ["#script_skyboxCycle",scriptNull])) then {terminate (_ctrl getVariable ["#script_skyboxCycle",scriptNull]);};

if (ctrlDelete _ctrl) then
{
_ctrl = _display ctrlCreate [_rscTypes select _forEachIndex,_idc,_ctrlGroup];
_ctrl ctrlSetPosition _ctrlPosition;
_ctrl ctrlCommit 0;
};
};
};
}
forEach [						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				,						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						102)				,						(					(uiNamespace getVariable ["bis_animatedScreen_displayOverlay",displayNull]) displayCtrl 						100			)];
};


case 				5:
{
params
[
"",
["_layer",0,[123,[]]],
["_texture","",[""]],
["_posCenter",[0.5,0.5],[[]]],
["_alpha",1,[123]],
["_scale",1,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

(ctrlPosition 						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				) params ["","","_canvasW","_canvasH"];
(_posCenter apply {_x - 0.5}) params ["_offsetX","_offsetY"];

private _pictureW = _canvasW * _scale;
private _pictureH = _canvasH * _scale;
private _pictureX = (_canvasW - _pictureW) / 2 + (_offsetX * _canvasW);
private _pictureY = (_canvasH - _pictureH) / 2 + (_offsetY * _canvasH);

_ctrl ctrlSetText _texture;
_ctrl ctrlSetFade (1 - _alpha);
_ctrl ctrlSetPosition [_pictureX,_pictureY,_pictureW,_pictureH];
_ctrl ctrlCommit 0;

_ctrl
};


case 				6:
{
params
[
"",
["_layer",0,[123,[]]],
["_duration",0,[123]],
["_posCenterEnd",nil,[[]]],
["_scaleEnd",nil,[123]],
["_posCenterStart",nil,[[]]],
["_scaleStart",nil,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

(ctrlPosition 						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				) params ["","","_canvasW","_canvasH"];
(ctrlPosition _ctrl) params ["_pictureCurrentX","_pictureCurrentY","_pictureCurrentW","_pictureCurrentH"];

private _scaleCurrent = _pictureCurrentW / _canvasW;


if (!isNil{_scaleStart} || !isNil{_posCenterStart}) then
{
if (isNil{_scaleStart}) then {_scaleStart = _scaleCurrent;};

if (isNil{_posCenterStart}) then
{
_posCenterStart =
[
_pictureCurrentX/_canvasW + (_scaleCurrent * 0.5),
_pictureCurrentY/_canvasH + (_scaleCurrent * 0.5)
];
};

(_posCenterStart apply {_x - 0.5}) params ["_offsetStartX","_offsetStartY"];

private _pictureStartW = _canvasW * _scaleStart;
private _pictureStartH = _canvasH * _scaleStart;
private _pictureStartX = (_canvasW - _pictureStartW) / 2 + (_offsetStartX * _canvasW);
private _pictureStartY = (_canvasH - _pictureStartH) / 2 + (_offsetStartY * _canvasH);

_ctrl ctrlSetPosition [_pictureStartX,_pictureStartY,_pictureStartW,_pictureStartH];
_ctrl ctrlCommit 0;
};


if (!isNil{_scaleEnd} || !isNil{_posCenterEnd}) then
{
if (isNil{_scaleEnd}) then {_scaleEnd = _scaleCurrent;};

if (isNil{_posCenterEnd}) then
{
_posCenterEnd =
[
_pictureCurrentX/_canvasW + (_scaleCurrent * 0.5),
_pictureCurrentY/_canvasH + (_scaleCurrent * 0.5)
];
};

(_posCenterEnd apply {_x - 0.5}) params ["_offsetEndX","_offsetEndY"];

private _pictureEndW = _canvasW * _scaleEnd;
private _pictureEndH = _canvasH * _scaleEnd;
private _pictureEndX = (_canvasW - _pictureEndW) / 2 + (_offsetEndX * _canvasW);
private _pictureEndY = (_canvasH - _pictureEndH) / 2 + (_offsetEndY * _canvasH);

_ctrl ctrlSetPosition [_pictureEndX,_pictureEndY,_pictureEndW,_pictureEndH];
_ctrl ctrlCommit _duration;
};
};


case 				9:
{
params
[
"",
["_layer",0,[123,[]]],
["_duration",0,[123,[]]],
["_angleDelta",0,[123]],
["_angleStart",nil,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

if (isNil{_angleStart}) then
{
_angleStart = (ctrlAngle _ctrl) param [0,0];
};

private _angleSpeed = 0;

if (_duration isEqualType []) then
{
_angleSpeed = _duration param [0,0,[123]];
_duration = if (_angleSpeed == 0) then {0} else {_angleDelta / _angleSpeed};
}
else
{
_angleSpeed = if (_duration == 0) then {0} else {_angleDelta / _duration};
};


if (_duration == 0) exitWith {_ctrl ctrlSetAngle [_angleStart + _angleDelta,0.5,0.5]};

if (!isNull(_ctrl getVariable ["#script_rotation",scriptNull])) then
{
terminate (_ctrl getVariable ["#script_rotation",scriptNull]);
};

private _script = [_ctrl,_angleStart,_angleDelta,diag_tickTime,diag_tickTime + _duration,_angleSpeed] spawn
{
disableSerialization;

params ["_ctrl","_angleStart","_angleDelta","_timeStart","_timeEnd","_angleSpeed"];

private _angle = _angleStart;

waitUntil
{
_angle = _angleStart + _angleSpeed * (diag_tickTime - _timeStart);

_ctrl ctrlSetAngle [_angle,0.5,0.5];

diag_tickTime > _timeEnd
};

_ctrl setVariable ["#script_rotation",scriptNull];
};

_ctrl setVariable ["#script_rotation",_script];
};


case 					7:
{
params
[
"",
["_layer",0,[123,[]]],
["_duration",0,[123]],
["_alphaEnd",nil,[123]],
["_alphaStart",nil,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

if (!isNil{_alphaStart}) then
{
_ctrl ctrlSetFade (1 - _alphaStart);
_ctrl ctrlCommit 0;
};

if (!isNil{_alphaEnd}) then
{
_ctrl ctrlSetFade (1 - _alphaEnd);
_ctrl ctrlCommit _duration;
};
};


case 				8:
{
params
[
"",
["_layer",0,[123,[]]],
["_duration",3,[123]],
["_alpha1",0,[123]],
["_alpha2",1,[123]],
["_cycles",10e10,[123]]
];

if (_duration <= 0) exitWith {["[x] Pulse duration needs to be > 0!"] call bis_fnc_error;};

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

if (!isNull(_ctrl getVariable ["#script_pulsing",scriptNull])) then
{
terminate (_ctrl getVariable ["#script_pulsing",scriptNull]);
};

private _script = [_ctrl,_duration/2,1-_alpha1,1-_alpha2,_cycles] spawn
{
disableSerialization;

params ["_ctrl","_durationHalf","_fade1","_fade2","_cycles"];

private _cycle = 0;
private _timeEnd = diag_tickTime;

while {!isNull _ctrl && _cycle < _cycles} do
{
_timeEnd = diag_tickTime + _durationHalf;

_ctrl ctrlSetFade _fade1;
_ctrl ctrlCommit _durationHalf;

waitUntil{diag_tickTime > _timeEnd};

_cycle = _cycle + 0.5;

if (isNull _ctrl || _cycle >= _cycles) exitWith {};

_timeEnd = diag_tickTime + _durationHalf;

_ctrl ctrlSetFade _fade2;
_ctrl ctrlCommit _durationHalf;

waitUntil{diag_tickTime > _timeEnd};

_cycle = _cycle + 0.5;
};

_ctrl setVariable ["#script_pulsing",scriptNull];
};

_ctrl setVariable ["#script_pulsing",_script];
};


case 				30:
{
params
[
"",
["_layer",0,[123,[]]],
["_text","",[""]],
["_position",[0,0],[[]]],
["_align",			        0,[123]],
["_color",[1,1,1,1],[[]]],
["_alpha",1,[123]],
["_tagSize",1,[123]],
["_tagShadow",0,[123]],
["_tagFont",					"RobotoCondensedBold",[""]],
["_width",0.9,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						102)				 controlsGroupCtrl _layer);
(ctrlPosition 						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						102)				) params ["","","_textsW","_textsH"];


_width = _width * _textsW;





_ctrl ctrlSetTextColor _color;


_ctrl ctrlSetPosition [-10,-10,_width,0];
_ctrl ctrlCommit 0;

_position params ["_positionX","_positionY"];
_positionX = _positionX * _textsW;
_positionY = _positionY * _textsH;

private _tagAlign = "left";
private _anchorX = 0;
private _anchorY = 0;

switch (_align) do
{
case 			        0;
case 		        6;
case 			            7:
{
_tagAlign = "left";
_anchorX = 0;
};
case 				        1;
case 			        8;
case 			        5:
{
_tagAlign = "center";
_anchorX = 0.5;
};
case 			        2;
case 			        	3;
case 		        4:
{
_tagAlign = "right";
_anchorX = 1;
};
};
switch (_align) do
{
case 			        0;
case 				        1;
case 			        2:
{
_anchorY = 0;
};
case 			            7;
case 			        8;
case 			        	3:
{
_anchorY = 0.5;
};
case 		        6;
case 			        5;
case 		        4:
{
_anchorY = 1;
};
};


private _structuredText = format["<t size='%2' align='%3' shadow='%4' font='%5'>%1</t>",_text,_tagSize,_tagAlign,_tagShadow,_tagFont];
_ctrl ctrlSetStructuredText parseText _structuredText;


private _ctrlH = ctrlTextHeight _ctrl;
_ctrl setVariable ["#sizeMult",_ctrlH/_tagSize];
_ctrl setVariable ["#anchorMultX",_anchorX];
_ctrl setVariable ["#anchorMultY",_anchorY];
_ctrl setVariable ["#structuredText",_structuredText];
_ctrl setVariable ["#width",_width];


_ctrl ctrlSetPosition [(-_anchorX * _width) + _positionX,(-_anchorY * _ctrlH) + _positionY,_width,_ctrlH];
_ctrl ctrlSetFade (1-_alpha);
_ctrl ctrlCommit 0;

_ctrl
};


case 				31:
{
params
[
"",
["_layer",0,[123,[]]],
["_duration",0,[123]],
["_posEnd",nil,[[]]],
["_scaleEnd",nil,[123]],
["_alphaEnd",nil,[123]],
["_posStart",nil,[[]]],
["_scaleStart",nil,[123]],
["_alphaStart",nil,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						102)				 controlsGroupCtrl _layer);

(ctrlPosition 						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						102)				) params ["","","_textsW","_textsH"];
(ctrlPosition _ctrl) params ["_textCurrentX","_textCurrentY","_textCurrentW","_textCurrentH"];

private _ctrlSizeMult = _ctrl getVariable ["#sizeMult",0.04];
private _anchorX = _ctrl getVariable ["#anchorMultX",0];
private _anchorY = _ctrl getVariable ["#anchorMultY",0];

private _scaleCurrent = ctrlScale _ctrl;
private _width = _ctrl getVariable ["#width",0.9 * _textsW];


if (!isNil{_scaleStart} || !isNil{_posStart}) then
{
if (isNil{_scaleStart}) then {_scaleStart = _scaleCurrent;};

if (isNil{_posStart}) then
{
_posStart =
[
(_textCurrentX + (_anchorX * _width * _scaleCurrent))/_textsW,
(_textCurrentY + (_anchorY * _textCurrentH * _scaleCurrent))/_textsH
];
};

_posStart params ["_posStartX","_posStartY"];
_posStartX = _posStartX * _textsW;
_posStartY = _posStartY * _textsH;


_ctrl ctrlSetPosition [(-_anchorX * _width * _scaleStart) + _posStartX,(-_anchorY * _textCurrentH * _scaleStart) + _posStartY,_width,_textCurrentH];
_ctrl ctrlSetScale _scaleStart;
_ctrl ctrlCommit 0;
};

if (!isNil{_alphaStart}) then
{
_ctrl ctrlSetFade (1-_alphaStart);
_ctrl ctrlCommit 0;
};


if (!isNil{_scaleEnd} || !isNil{_posEnd}) then
{
if (isNil{_scaleEnd}) then {_scaleEnd = _scaleCurrent;};

if (isNil{_posEnd}) then
{
_posEnd =
[
(_textCurrentX + (_anchorX * _width * _scaleCurrent))/_textsW,
(_textCurrentY + (_anchorY * _textCurrentH * _scaleCurrent))/_textsH
];
};

_posEnd params ["_posEndX","_posEndY"];
_posEndX = _posEndX * _textsW;
_posEndY = _posEndY * _textsH;


_ctrl ctrlSetPosition [(-_anchorX * _width * _scaleEnd) + _posEndX,(-_anchorY * _textCurrentH * _scaleEnd) + _posEndY,_width,_textCurrentH];
_ctrl ctrlSetScale _scaleEnd;
_ctrl ctrlCommit _duration;
};

if (!isNil{_alphaEnd}) then
{
_ctrl ctrlSetFade (1-_alphaEnd);
_ctrl ctrlCommit _duration;
};
};


case 				40:
{
params
[
"",
["_layer",0,[123,[]]],
["_text","",[""]],
["_position",[0,0],[[]]],
["_align",			        0,[123]],
["_color",[1,1,1,1],[[]]],
["_alpha",1,[123]],
["_tagSize",1,[123]],
["_tagShadow",0,[123]],
["_tagFont",					"RobotoCondensedBold",[""]],
["_width",0.9,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayOverlay",displayNull]) displayCtrl 						100			) controlsGroupCtrl _layer);
(ctrlPosition 						(					(uiNamespace getVariable ["bis_animatedScreen_displayOverlay",displayNull]) displayCtrl 						100			)) params ["","","_textsW","_textsH"];


_width = _width * _textsW;





_ctrl ctrlSetTextColor _color;


_ctrl ctrlSetPosition [-10,-10,_width,0];
_ctrl ctrlCommit 0;

_position params ["_positionX","_positionY"];
_positionX = _positionX * _textsW;
_positionY = _positionY * _textsH;

private _tagAlign = "left";
private _anchorX = 0;
private _anchorY = 0;

switch (_align) do
{
case 			        0;
case 		        6;
case 			            7:
{
_tagAlign = "left";
_anchorX = 0;
};
case 				        1;
case 			        8;
case 			        5:
{
_tagAlign = "center";
_anchorX = 0.5;
};
case 			        2;
case 			        	3;
case 		        4:
{
_tagAlign = "right";
_anchorX = 1;
};
};
switch (_align) do
{
case 			        0;
case 				        1;
case 			        2:
{
_anchorY = 0;
};
case 			            7;
case 			        8;
case 			        	3:
{
_anchorY = 0.5;
};
case 		        6;
case 			        5;
case 		        4:
{
_anchorY = 1;
};
};


private _structuredText = format["<t size='%2' align='%3' shadow='%4' font='%5'>%1</t>",_text,_tagSize,_tagAlign,_tagShadow,_tagFont];
_ctrl ctrlSetStructuredText parseText _structuredText;


private _ctrlH = ctrlTextHeight _ctrl;
_ctrl setVariable ["#sizeMult",_ctrlH/_tagSize];
_ctrl setVariable ["#anchorMultX",_anchorX];
_ctrl setVariable ["#anchorMultY",_anchorY];
_ctrl setVariable ["#structuredText",_structuredText];


_ctrl ctrlSetPosition [(-_anchorX * _width) + _positionX,(-_anchorY * _ctrlH) + _positionY,_width,_ctrlH];
_ctrl ctrlSetFade (1-_alpha);
_ctrl ctrlCommit 0;

_ctrl
};


case 				20:
{
params
[
"",
["_layer",0,[123,[]]],
["_texture","",[""]],
["_alpha",1,[123]],
["_duration",0,[123]]
];

if (_layer isEqualType []) exitWith
{
{_this set [1,_x];_this call bis_fnc_animatedScreen;} forEach _layer;
};

[				5,_layer,_texture,[1,0.5],_alpha,2] call bis_fnc_animatedScreen;

private _ctrl = (						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				 controlsGroupCtrl _layer);

if (!isNull(_ctrl getVariable ["#script_skyboxCycle",scriptNull])) then
{
terminate (_ctrl getVariable ["#script_skyboxCycle",scriptNull]);
};

private _script = [_layer,_duration] spawn
{
disableSerialization;

params ["_layer","_duration"];

while {true} do
{
[				6,_layer,_duration,[0,0.5],nil,[1,0.5]] call bis_fnc_animatedScreen;

uisleep _duration;
};
};

_ctrl setVariable ["#script_skyboxCycle",_script];
};


case 					1:
{

				10 cutText ["","PLAIN",0];


{
if (!isNull(_x getVariable ["#script_rotation",scriptNull])) then {terminate (_x getVariable ["#script_rotation",scriptNull]);};
if (!isNull(_x getVariable ["#script_pulsing",scriptNull])) then {terminate (_x getVariable ["#script_pulsing",scriptNull]);};
if (!isNull(_x getVariable ["#script_skyboxCycle",scriptNull])) then {terminate (_x getVariable ["#script_skyboxCycle",scriptNull]);};
}
forEach ((allControls 					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull])) - [						(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 						101)				,					(					(uiNamespace getVariable ["bis_animatedScreen_displayMain",displayNull]) displayCtrl 					100)]);


						11 cutText ["","PLAIN"];


					16 cutText ["","PLAIN"];


				15 cutText ["","PLAIN"];
};


case 					3:
{
private _duration = param [1,0.5,[123]];
private _wait = param [2,true,[true]];

				15 cutText ["","BLACK OUT",_duration];
if (_wait) then {uiSleep _duration;};
};


case 					4:
{
private _duration = param [1,0.5,[123]];
private _wait = param [2,true,[true]];

				15 cutText ["","BLACK IN",_duration];
if (_wait) then {uiSleep _duration;};
};

default
{

};
};



