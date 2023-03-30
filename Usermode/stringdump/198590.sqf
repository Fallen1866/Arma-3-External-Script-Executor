#line 0 "/temp/bin/A3/Functions_F/Debug/fn_camera.sqf"

disableSerialization;

if (count _this <= 1) exitWith {
	_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
	if (is3DEN) then {
		_displayMission = findDisplay 313;
	};
	_parent = if (isNull _displayMission) then {
		_displays = uinamespace getvariable ["GUI_displays", []];
		_classes = uinamespace getvariable ["GUI_classes", []];

		{
			if (isNull _x) then {
				_classes set [_foreachindex, -1];
			};
		} forEach _displays;
		_displays = _displays - [displayNull];
		_classes = _classes - [-1];

		if (count _displays > 0 && count _displays == count _classes) then {
			if ((_classes select (count _classes - 1)) == "RscDisplayDebug") then {
				_displays select (count _displays - 2)
			} else {
				_displays select (count _displays - 1)
			};
		} else {
			displayNull
		};
	} else {
		_displayMission
	};
	_parent createdisplay "RscDisplayCamera";
};

disableSerialization;
_mode = _this param [0, "Init", [displaynull, ""]];
_this = _this param [1, []];

switch _mode do {
	case "Init": {
		BIS_fnc_camera_draw3D = addmissioneventhandler ["draw3d", "with (uiNamespace) do {
			['Draw3D', _this] call BIS_fnc_camera;
		};
	"];

	_dir = positionCameraToWorld [0, 0, 0] getDir positionCameraToWorld [0, 0, 1];
	_vectorDir = (AGLToASL positionCameraToWorld [0, 0, 0]) vectorFromTo (AGLToASL positionCameraToWorld [0, 0, 1]);
	_vectorDir = [_vectorDir, _dir] call BIS_fnc_rotateVector2D;
	_vectorDirY = _vectorDir select 1;
	if (_vectorDirY == 0) then {
		_vectorDirY = 0.01;
	};
	_pitch = atan ((_vectorDir select 2) / _vectorDirY);

	_camPos = positionCameraToWorld [0, 0, 0];
	_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", "camera" camCreate _camPos];
	_cam cameraeffect ["internal", "back"];
	_cam camPrepareFov 0.75;
	_cam camCommitPrepared 0;
	showCinemaBorder false;
	cameraEffectEnableHUD true;
	vehicle cameraOn switchCamera cameraView;

	_cam setDir _dir;
	[_cam, _pitch, 0] call BIS_fnc_setPitchBank;

	with missionNamespace do {
		if (isnil "BIS_fnc_camera_ppColor") then {
			BIS_fnc_camera_ppColor = ppEffectCreate ["colorCorrections", 1776];
			BIS_fnc_camera_ppColor ppEffectEnable true;
			BIS_fnc_camera_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0.75, 0.25, 0, 1]];
			BIS_fnc_camera_ppColor ppEffectCommit 0;
		};
	};

	missionnamespace setvariable ["BIS_fnc_camera_cam", _cam];
	missionnamespace setvariable ["BIS_fnc_camera_acctime", missionnamespace getvariable ["BIS_fnc_camera_acctime", accTime]];

	BIS_fnc_camera_LMB = false;
	BIS_fnc_camera_RMB = false;
	BIS_fnc_camera_keys = [];
	BIS_fnc_camera_LMBclick = [0, 0];
	BIS_fnc_camera_RMBclick = [0, 0];
	BIS_fnc_camera_pitchbank = [_pitch, 0];
	BIS_fnc_camera_fov = 0.75;
	BIS_fnc_camera_iconCamera = gettext (configfile >> "RscDisplayCamera" >> "iconCamera");
	BIS_fnc_camera_vision = 0;
	BIS_fnc_camera_visibleHUD = true;
	BIS_fnc_camera_cameraView = cameraView;

	cameraon switchcamera "internal";

	_DIKcodes = true call BIS_fnc_keyCode;
	_DIKlast = _DIKcodes select (count _DIKcodes - 1);
	for "_k" from 0 to (_DIKlast - 1) do {
		BIS_fnc_camera_keys set [_k, false];
	};

	_display = _this select 0;
	BIS_fnc_camera_display = _display;
	_display displayaddeventhandler ["keydown", "with (uiNamespace) do {
		['KeyDown', _this] call BIS_fnc_camera;
	};
"];
_display displayaddeventhandler ["keyup", "with (uiNamespace) do {
	['KeyUp', _this] call BIS_fnc_camera;
};
"];
_display displayaddeventhandler ["mousebuttondown", "with (uiNamespace) do {
	['MouseButtonDown', _this] call BIS_fnc_camera;
};
"];
_display displayaddeventhandler ["mousebuttonup", "with (uiNamespace) do {
	['MouseButtonUp', _this] call BIS_fnc_camera;
};
"];
_display displayaddeventhandler ["mousezchanged", "with (uiNamespace) do {
	['MouseZChanged', _this] call BIS_fnc_camera;
};
"];

_ctrlMouseArea = _display displayCtrl 3140;
_ctrlMouseArea ctrladdeventhandler ["mousemoving", "with (uiNamespace) do {
	['Mouse', _this] call BIS_fnc_camera;
};
"];
_ctrlMouseArea ctrladdeventhandler ["mouseholding", "with (uiNamespace) do {
	['Mouse', _this] call BIS_fnc_camera;
};
"];
ctrlSetFocus _ctrlMouseArea;

_ctrlMap = _display displayCtrl 3141;
_ctrlMap ctrlEnable false;
_ctrlMap ctrladdeventhandler ["draw", "with (uiNamespace) do {
	['MapDraw', _this] call BIS_fnc_camera;
};
"];
_ctrlMap ctrladdeventhandler ["mousebuttonclick", "with (uiNamespace) do {
	['MapClick', _this] call BIS_fnc_camera;
};
"];

_ctrlOverlay = _display displayCtrl 3142;
_ctrlOverlay ctrlEnable false;

_positions = profilenamespace getvariable ["BIS_fnc_camera_positions", []];
_positions resize 10;
profilenamespace setvariable ["BIS_fnc_camera_positions", +_positions];
_ctrlPositions = _display displayCtrl 31422;
_ctrlPositions ctrlsettext "1:\n2:\n3:\n4:\n5:\n6:\n7:\n8:\n9:\n0";

_ctrlSliderFocus = _display displayCtrl 31430;
_ctrlSliderFocus ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderFocus', _this] call BIS_fnc_camera;
};
"];
_ctrlSliderFocus sliderSetPosition 0;
["SliderFocus", [_ctrlSliderFocus, sliderPosition _ctrlSliderFocus]] call BIS_fnc_camera;

_ctrlSliderAperture = _display displayCtrl 31432;
_ctrlSliderAperture ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderAperture', _this] call BIS_fnc_camera;
};
"];
_ctrlSliderAperture sliderSetRange [0, 150];
_ctrlSliderAperture sliderSetPosition 0;
_ctrlSliderAperture ctrlsettooltip localize "str_a3_rscdisplaycamera_tooltipaperture";
["SliderAperture", [_ctrlSliderAperture, sliderPosition _ctrlSliderAperture]] call BIS_fnc_camera;

_ctrlSliderDaytime = _display displayCtrl 31434;
_ctrlSliderDaytime sliderSetRange [0, 24 * 60];
_ctrlSliderDaytime ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderDaytime', _this] call BIS_fnc_camera;
};
"];
_ctrlSliderDaytime sliderSetPosition (dayTime * 60);
["SliderDaytime", [_ctrlSliderDaytime, sliderPosition _ctrlSliderDaytime]] call BIS_fnc_camera;

_ctrlSliderOvercast = _display displayCtrl 31436;
_ctrlSliderOvercast sliderSetRange [0, 1];
_ctrlSliderOvercast ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderOvercast', _this] call BIS_fnc_camera;
};
"];
_ctrlSliderOvercast sliderSetPosition overcast;
["SliderOvercast", [_ctrlSliderOvercast, sliderPosition _ctrlSliderOvercast]] call BIS_fnc_camera;

_ctrlSliderAcctime = _display displayCtrl 31438;
_ctrlSliderAcctime sliderSetRange [0, 1];
_ctrlSliderAcctime ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderAcctime', _this] call BIS_fnc_camera;
};
"];
_ctrlSliderAcctime sliderSetPosition 0;
["SliderAcctime", [_ctrlSliderAcctime, sliderPosition _ctrlSliderAcctime]] call BIS_fnc_camera;

_ctrlSliderBrightness = _display displayCtrl 31440;
_ctrlSliderBrightness sliderSetRange [0.5, 1.5];
_ctrlSliderBrightness ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderColor', [ctrlParent (_this select 0)]] call BIS_fnc_camera;
};
"];
_ctrlSliderBrightness sliderSetPosition 1;

_ctrlSliderContrast = _display displayCtrl 31442;
_ctrlSliderContrast sliderSetRange [-0.5, 0.5];
_ctrlSliderContrast ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderColor', [ctrlParent (_this select 0)]] call BIS_fnc_camera;
};
"];
_ctrlSliderContrast sliderSetPosition 0;

_ctrlSliderSaturation = _display displayCtrl 31444;
_ctrlSliderSaturation sliderSetRange [0, 2];
_ctrlSliderSaturation ctrladdeventhandler ["sliderposchanged", "with (uiNamespace) do {
	['SliderColor', [ctrlParent (_this select 0)]] call BIS_fnc_camera;
};
"];
_ctrlSliderSaturation sliderSetPosition 1;

["SliderColor", [_display]] call BIS_fnc_camera;

_display call BIS_fnc_camera_showPositions;

[] call BIS_fnc_guiEffectTiles;

_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
_control = _displayMission displayCtrl 11400;
_control ctrlSetFade 1;
_control ctrlCommit 0;

cuttext ["", "plain"];
titletext ["", "plain"];

{
	if (toLower _x find "bis_fnc_unitplay" isEqualTo 0) then {
		_x cutFadeOut 0
	}
} forEach allCutLayers;

clearRadio;
enableRadio false;

if (is3DEN) then {
	["ShowInterface", false] spawn BIS_fnc_3DENInterface;
	if (get3denactionstate "togglemap" > 0) then {
		do3DENAction "togglemap";
	};
};
};

case "Mouse": {
	_display = ctrlParent (_this select 0);
	_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
	_pitchbank = BIS_fnc_camera_pitchbank;
	_pitch = _pitchbank select 0;
	_bank = _pitchbank select 1;

	if (BIS_fnc_camera_LMB || BIS_fnc_camera_RMB) then {
		_mX = _this select 1;
		_mY = _this select 2;

		if (BIS_fnc_camera_LMB) then {
			_defX = BIS_fnc_camera_LMBclick select 0;
			_defY = BIS_fnc_camera_LMBclick select 1;

			_camZ = (getPosATL _cam select 2) max 1 min 256;
			_dX = (_mX - _defX) * _camZ / 2;
			_dY = -(_mY - _defY) * _camZ / 2;

			_camPos = getPosASL _cam;
			_camPos = [_camPos, _dY, direction _cam] call BIS_fnc_relPos;
			_camPos = [_camPos, _dX, direction _cam + 90] call BIS_fnc_relPos;
			_cam setPosASL _camPos;
		} else {
			_defX = BIS_fnc_camera_RMBclick select 0;
			_defY = BIS_fnc_camera_RMBclick select 1;

			_dX = (_mX - _defX) * 180 * BIS_fnc_camera_fov;
			_dY = -(_mY - _defY) * 180 * BIS_fnc_camera_fov;

			if (BIS_fnc_camera_keys select 0x1D) then {
				_bank = (_bank + _dX * 0.1) max -180 min +180;
				BIS_fnc_camera_pitchbank set [1, _bank];
			} else {
				_cam setDir (direction _cam + _dX);
				_pitch = (_pitch + _dY) max -90 min +90;
			};
			[
				_cam,
				_pitch,
				_bank
			] call BIS_fnc_setPitchBank;
			BIS_fnc_camera_RMBclick = [_mX, _defY];
		};
	};

	_pos = screenToWorld [0.5, 0.5];
	_intersectCam = getPosASL _cam;
	_intersectTarget = [_pos select 0, _pos select 1, getTerrainHeightASL _pos];
	_objects = lineIntersectsWith [
		_intersectCam,
		_intersectTarget,
		objNull,
		objNull,
		true
	];
	_ctrlFrame = _display displayCtrl 31421;
	_object = objNull;
	if (count _objects > 0) then {
		_ctrlOverlay = _display displayCtrl 3142;
		_object = _objects select (count _objects - 1);
		missionnamespace setvariable ["BIS_fnc_camera_target", _object];

		_objectBbox = boundingBox _object;
		_objectBboxZ = (abs((_objectBbox select 0) select 2) + abs((_objectBbox select 1) select 2)) / 2;
		_objectPos = worldToScreen [position _object select 0, position _object select 1, (getPosATL _object select 2) + _objectBboxZ / 2];
		if (count _objectPos > 0) then {
			_objectSize =
			abs((_objectBbox select 0) select 0) + abs((_objectBbox select 1) select 0)
			max
			abs((_objectBbox select 0) select 1) + abs((_objectBbox select 1) select 1)
			max
			abs((_objectBbox select 0) select 2) + abs((_objectBbox select 1) select 2);
			_objectDis = _cam distance _object;

			_ctrlFrameSize = (_objectSize / _objectDis / 2) max 0.1;
			_ctrlFrame ctrlSetPosition [
				(_objectPos select 0) - safeZoneX - ((_ctrlFrameSize / 2) * 3/4),
				(_objectPos select 1) - safeZoneY - (_ctrlFrameSize / 2),
				_ctrlFrameSize * 3/4,
				_ctrlFrameSize
			];
		} else {
			missionnamespace setvariable ["BIS_fnc_camera_target", objNull];
			_ctrlFrame ctrlSetPosition [-10, -10, 0, 0];
		};
	} else {
		missionnamespace setvariable ["BIS_fnc_camera_target", objNull];
		_ctrlFrame ctrlSetPosition [-10, -10, 0, 0];
	};
	_ctrlFrame ctrlCommit 0;

	_camDir = direction _cam;
	_cardinalDir = round (_camDir / 45);
	_cardinalDirText = [
		"str_move_n",
		"str_move_ne",
		"str_move_e",
		"str_move_se",
		"str_move_s",
		"str_move_sw",
		"str_move_w",
		"str_move_nw",
		"str_move_n"
	] select _cardinalDir;
	_cardinalDirText = localize _cardinalDirText;

	_ctrlDebug = _display displayCtrl 31420;
	_ctrlDebug ctrlSetText format [
		"\n\nX = %1 m\nY = %2 m\nZ (ATL) = %3 m\nZ (ASL) %4 m\nFOV = %5\nDir = %6° (%7)\nPitch = %8°\nBank = %9°\nBIS_fnc_camera_target = %10\n",
		getPosATL _cam select 0,
		getPosATL _cam select 1,
		getPosATL _cam select 2,
		getPosASL _cam select 2,
		BIS_fnc_camera_fov,
		round _camDir,
		_cardinalDirText,
		round _pitch,
		round _bank,
		_object
	];

	_camMove = {
		_dX = _this select 0;
		_dY = _this select 1;
		_dZ = _this select 2;
		_pos = getPosASL _cam;
		_dir = (direction _cam) + _dX * 90;
		_camPos = [
			(_pos select 0) + ((sin _dir) * _coef * _dY),
			(_pos select 1) + ((cos _dir) * _coef * _dY),
			(_pos select 2) + _dZ * _coef
		];
		_camPos set [2, (_camPos select 2) max (getTerrainHeightASL _camPos)];
		_cam setPosASL _camPos;
	};
	_camRotate = {
		_dX = _this select 0;
		_dY = _this select 1;
		_pitchbank = _cam call BIS_fnc_getPitchBank;
		_cam setDir (direction _cam + _dX);
		[
			_cam,
			(_pitchbank select 0) + _dY,
			0
		] call BIS_fnc_setPitchBank;
	};
	_isActive = {
		{
			BIS_fnc_camera_keys param [_x, false]
		} count (actionKeys _this) > 0
	};

	_coef = 0.1;
	if ("cameraMoveTurbo1" call _isActive) then {
		_coef = _coef * 10;
	};
	if ("cameraMoveTurbo2" call _isActive) then {
		_coef = _coef * 100;
	};
	if (BIS_fnc_camera_keys select 0x36) then {
		_coef = _coef / 10;
	};

	if ("cameraMoveForward" call _isActive) then {
		[0, 1, 0] call _camMove;
	};
	if ("cameraMoveBackward" call _isActive) then {
		[0, -1, 0] call _camMove;
	};
	if ("cameraMoveLeft" call _isActive) then {
		[-1, 1, 0] call _camMove;
	};
	if ("cameraMoveRight" call _isActive) then {
		[1, 1, 0] call _camMove;
	};

	if ("cameraMoveUp" call _isActive) then {
		[0, 0, 1] call _camMove;
	};
	if ("cameraMoveDown" call _isActive) then {
		[0, 0, -1] call _camMove;
	};

	if ("cameraLookDown" call _isActive) then {
		[+0, -1] call _camRotate;
	};
	if ("cameraLookLeft" call _isActive) then {
		[-1, +0] call _camRotate;
	};
	if ("cameraLookRight" call _isActive) then {
		[+1, +0] call _camRotate;
	};
	if ("cameraLookUp" call _isActive) then {
		[+0, +1] call _camRotate;
	};
	if ("cameraZoomIn" call _isActive) then {
		BIS_fnc_camera_fov = (BIS_fnc_camera_fov - 0.01) max 0.01;
		_cam camPrepareFov BIS_fnc_camera_fov;
		_cam camCommitPrepared 0;
	};
	if ("cameraZoomOut" call _isActive) then {
		BIS_fnc_camera_fov = (BIS_fnc_camera_fov + 0.01) min 1;
		_cam camPrepareFov BIS_fnc_camera_fov;
		_cam camCommitPrepared 0;
	};
};

case "MouseButtonDown": {
	_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
	_button = _this select 1;
	_mX = _this select 2;
	_mY = _this select 3;
	_shift = _this select 4;
	_ctrl = _this select 5;
	_alt = _this select 6;

	if (_button > 0) then {
		BIS_fnc_camera_RMB = true;
		BIS_fnc_camera_RMBclick = [_mX, _mY];
	} else {
		BIS_fnc_camera_LMB = true;
		BIS_fnc_camera_LMBclick = [_mX, _mY];
	};
	BIS_fnc_camera_pitchbank set [0, (_cam call BIS_fnc_getPitchBank) select 0];
};

case "MouseButtonUp": {
	_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
	_button = _this select 1;
	if (_button > 0) then {
		BIS_fnc_camera_RMB = false;
		BIS_fnc_camera_RMBclick = [0, 0];
	} else {
		BIS_fnc_camera_LMB = false;
		BIS_fnc_camera_LMBclick = [0, 0];
	};

	BIS_fnc_camera_pitchbank set [0, (_cam call BIS_fnc_getPitchBank) select 0];
};

case "MouseZChanged": {
	_display = _this select 0;
	_ctrlMap = _display displayCtrl 3141;
	if !(ctrlEnabled _ctrlMap) then {
		_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
		_camVector = vectorDir _cam;

		_dZ = (_this select 1) * 10;
		_vX = (_camVector select 0) * _dZ;
		_vY = (_camVector select 1) * _dZ;
		_vZ = (_camVector select 2) * _dZ;

		_camPos = getPosASL _cam;
		_camPos = [
			(_camPos select 0) + _vX,
			(_camPos select 1) + _vY,
			(_camPos select 2) + _vZ
		];
		_camPos set [2, (_camPos select 2) max (getTerrainHeightASL _camPos)];
		_cam setPosASL _camPos;
	};
};

case "KeyDown": {
	_display = _this select 0;
	_key = _this select 1;
	_shift = _this select 2;
	_ctrl = _this select 3;
	_alt = _this select 4;
	_return = false;

	BIS_fnc_camera_keys set [_key, true];

	_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
	_camSave = {
		_positions = profilenamespace getvariable ["BIS_fnc_camera_positions", []];
		if (_ctrl) then {
			_positions set [
				_this,
				_camParams
			];
			profilenamespace setvariable ["BIS_fnc_camera_positions", +_positions];
			saveProfileNamespace;

			_display call BIS_fnc_camera_showPositions;
		} else {
			_params = _positions select _this;
			if !(isnil "_params") then {
				["Paste", _params] call BIS_fnc_camera;
			};
		};
		_return = true;
	};
	_camParams = [
		worldName,
		position _cam,
		direction _cam,
		BIS_fnc_camera_fov,
		BIS_fnc_camera_pitchbank,
		sliderPosition (_display displayCtrl 31430),
		sliderPosition (_display displayCtrl 31432),
		sliderPosition (_display displayCtrl 31434),
		sliderPosition (_display displayCtrl 31436),
		sliderPosition (_display displayCtrl 31438),
		sliderPosition (_display displayCtrl 31440),
		sliderPosition (_display displayCtrl 31442),
		sliderPosition (_display displayCtrl 31444)
	];

	switch (true) do {
		case (_key == 0x02): {
			1 call _camSave;
		};
		case (_key == 0x03): {
			2 call _camSave;
		};
		case (_key == 0x04): {
			3 call _camSave;
		};
		case (_key == 0x05): {
			4 call _camSave;
		};
		case (_key == 0x06): {
			5 call _camSave;
		};
		case (_key == 0x07): {
			6 call _camSave;
		};
		case (_key == 0x08): {
			7 call _camSave;
		};
		case (_key == 0x09): {
			8 call _camSave;
		};
		case (_key == 0x0A): {
			9 call _camSave;
		};
		case (_key == 0x0B): {
			0 call _camSave;
		};

		case (_key == 0x3B): {
			_display createdisplay "RscDisplayDebugPublic";
			_result = true;
		};

		case (_key in actionkeys "cameraReset"): {
			BIS_fnc_camera_pitchbank = [0, 0];
			[0, 0] call _camRotate;
			BIS_fnc_camera_fov = 0.7;
			_camPos = position _cam;
			_camDir = direction _cam;
			_cam cameraeffect ["terminate", "back"];
			camDestroy _cam;
			_cam = "camera" camCreate _camPos;
			_cam cameraeffect ["internal", "back"];
			_cam setDir _camDir;
			missionnamespace setvariable ["BIS_fnc_camera_cam", _cam];
		};

		case (_key in actionkeys "showMap"): {
			_ctrlMouseArea = _display displayCtrl 3140;
			_ctrlMap = _display displayCtrl 3141;
			if (ctrlEnabled _ctrlMap) then {
				_ctrlMouseArea ctrlEnable true;
				_ctrlMap ctrlEnable false;
				ctrlSetFocus _ctrlMap;
				_ctrlMap ctrlSetPosition [-10, -10, 0.8 * safeZoneW, 0.8 * safeZoneH];
				_ctrlMap ctrlCommit 0;
			} else {
				_ctrlMouseArea ctrlEnable false;
				_ctrlMap ctrlEnable true;
				ctrlSetFocus _ctrlMap;
				_ctrlMapPos = [
					safeZoneX + 0.1 * safeZoneW,
					safeZoneY + 0.1 * safeZoneH,
					0.8 * safeZoneW,
					0.8 * safeZoneH
				];
				_ctrlMap ctrlSetPosition _ctrlMapPos;
				_ctrlMap ctrlCommit 0;
				_ctrlMap ctrlMapAnimAdd [0, 0.1, position _cam];
				ctrlMapAnimCommit _ctrlMap;
				{
					player reveal [_x, 4]
				} forEach allUnits;
			};
		};

		case (_key in actionkeys "cameraInterface"): {
			_return = true;
			_ctrlOverlays = [_display displayCtrl 3142, _display displayCtrl 3143];
			if (BIS_fnc_camera_visibleHUD) then {
				{
					_x ctrlSetFade 1;
				} forEach _ctrlOverlays;
				(_display displayCtrl 3142) ctrlEnable false;
				cameraEffectEnableHUD false;
			} else {
				{
					_x ctrlSetFade 0;
				} forEach _ctrlOverlays;
				(_display displayCtrl 3142) ctrlEnable true;
				cameraEffectEnableHUD true;
			};
			BIS_fnc_camera_visibleHUD = !BIS_fnc_camera_visibleHUD;
			{
				_x ctrlCommit 0.1
			} forEach _ctrlOverlays;
		};

		case (_key == 0x2D): {
			if (_ctrl) then {
				[
					"Paste",
					_camParams
					] spawn {
						copytoclipboard format ["%1 call bis_fnc_camera;
						", _this];
					};
				};
			};
			case (_key == 0x2E): {
				if (_ctrl) then {
					_camParams spawn {
						copytoclipboard format ["%1", _this];
					};
				};
			};
			case (_key == 0x2F): {
				if (_ctrl) then {
					_clipboard = call compile copyFromClipboard;
					if (typeName _clipboard == typeName []) then {
						_clipboard = [_clipboard] param [0, [], [[]], [13]];
						if (count _clipboard == 13) then {
							["Paste", _clipboard] call BIS_fnc_camera;
						} else {
							["Wrong format of camera params (""%1"")", copyFromClipboard] call BIS_fnc_error;
						};
					};
				};
			};

			case (_key in actionkeys "cameraVisionMode"): {
				BIS_fnc_camera_vision = BIS_fnc_camera_vision + 1;
				_vision = BIS_fnc_camera_vision % 4;
				switch (_vision) do {
					case 0: {
						camUseNVG false;
						false setCamUseTI 0;
					};
					case 1: {
						camUseNVG true;
						false setCamUseTI 0;
					};
					case 2: {
						camUseNVG false;
						true setCamUseTI 0;
					};
					case 3: {
						camUseNVG false;
						true setCamUseTI 1;
					};
				};
			};

			case (_key == 0x19): {
				if (_ctrl) then {
					screenshot format (["SplendidCamera\%1_['%2', %3, %4, %5, %6, %7, %8, %9, %10, %11].png", profileName] + _camParams);
				};
			};

			case (_key == 0x39): {
				_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
				_vehicle = vehicle player;
				_surfaces = lineIntersectsSurfaces [getPosASL _cam, AGLToASL screenToWorld [0.5, 0.5]];
				_worldPos = if (count _surfaces > 0) then {
					ASLToAGL (_surfaces select 0 select 0)
				} else {
					screenToWorld [0.5, 0.5]
				};

				_alt = if (_vehicle != player) then {
					getPosATL _vehicle select 2
				} else {
					_worldPos select 2
				};
				_vehicle setPosATL [_worldPos select 0, _worldPos select 1, _alt];
				_vehicle setVelocity [0, 0, 0];
			};

			case (_key == 0x01): {
				_displayType = if (isMultiplayer) then {
					"RscDisplayMPInterrupt"
				} else {
					"RscDisplayInterrupt"
				};
				_displayPause = _display createDisplay _displayType;

				_ctrlAbort = _displayPause displayCtrl 104;
				_ctrlAbort ctrlShow false;
				_ctrlAbortNew = _displayPause ctrlcreate [configname inheritsfrom (configfile >> "RscDisplayInterrupt" >> "controls" >> "ButtonAbort"), 2];
				_ctrlAbortNew ctrlSetPosition ctrlPosition _ctrlAbort;
				_ctrlAbortNew ctrlCommit 0;
				if (isNull cameraOn) then {
					_ctrlAbortNew ctrlSetText ctrlText _ctrlAbort;
				} else {
					_ctrlAbortNew ctrlsettext format ["%1 (%2)", localize "STR_DISP_CLOSE", localize "STR_a3_rscdisplaycamera_header"];
				};
				_ctrlAbortNew ctrlAddEventHandler [
					"buttonclick",
					{
						(ctrlParent (_this select 0)) closeDisplay 2;
						(findDisplay 314) closeDisplay 2;

						if (isNull cameraOn) then {
							([] call BIS_fnc_displayMission) closeDisplay 2;
						};
					}
				];

				BIS_fnc_camera_RMB = false;
				BIS_fnc_camera_LMB = false;
				BIS_fnc_camera_RMBclick = [0, 0];
				BIS_fnc_camera_LMBclick = [0, 0];

				_return = true;
			};
			default {};
		};
		_return
	};

	case "KeyUp": {
		BIS_fnc_camera_keys set [_this select 1, false];
	};

	case "Draw3D": {
		if (BIS_fnc_camera_visibleHUD) then {
			_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
			_locations = nearestlocations [position _cam, ["nameVillage", "nameCity", "nameCityCapital"], 2000];
			{
				_pos = locationPosition _x;
				_pos set [2, 0];
				drawIcon3D [
					"#(argb, 8, 8, 3)color(0, 0, 0, 0)",
					[1, 1, 1, 1],
					_pos,
					0,
					0,
					0,
					text _x,
					1
				];
			} forEach _locations;
		};
	};

	case "MapDraw": {
		_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
		_ctrlMap = _this select 0;
		_ctrlMap drawIcon [
			BIS_fnc_camera_iconCamera,
			[0, 1, 1, 1],
			position _cam,
			32,
			32,
			direction _cam,
			"",
			1
		];
	};

	case "MapClick": {
		_ctrlMap = _this select 0;
		_button = _this select 1;
		_posX = _this select 2;
		_posY = _this select 3;
		if (_button == 0) then {
			_worldPos = _ctrlMap ctrlMapScreenToWorld [_posX, _posY];
			_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
			_cam setPos [
				_worldPos select 0,
				_worldPos select 1,
				getPosATL _cam select 2
			];
		};
	};

	case "SliderFocus": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_value = _value^2;
		_focus = 1;
		_text = str (round (_value * 1000) / 1000) + " m";
		if (_value == 0) then {
			_value = -1;
			_text = localize "STR_WI_ZEROING_AUTO";
		};
		if (_value == 100) then {
			_value = -1;
			_focus = -1; _text = "DISABLED";
		};

		_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
		_cam camPrepareFocus [_value, _focus];
		_cam camCommitPrepared 0;

		_ctrlValue = _display displayCtrl 31431;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderAperture": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;

		_text = str (round (_value * 100) / 100);
		if (_value == 0) then {
			_value = -1;
			_text = localize "STR_WI_ZEROING_AUTO";
		};

		setAperture _value;

		_ctrlValue = _display displayCtrl 31433;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderDaytime": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_text = [_value / 60, "HH:MM:SS"] call BIS_fnc_timeToString;

		0 setOvercast (sliderPosition (_display displayCtrl 31436));

		_date = date;
		_date set [3, 0];
		_date set [4, _value];
		setDate _date;

		_ctrlValue = _display displayCtrl 31435;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderOvercast": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_text = str (round (_value * 100) / 100);

		_fogparams = fogParams;
		0 setOvercast _value;
		forceWeatherChange;
		0 setFog _fogparams;

		_ctrlValue = _display displayCtrl 31437;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderAcctime": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_text = str (round (_value * 100) / 100);

		setAccTime _value;

		_ctrlValue = _display displayCtrl 31439;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderColor": {
		private ["_display"];
		_display = _this select 0;

		_valueBrightness = _this param [1, sliderPosition (_display displayCtrl 31440)];
		_valueContrast = _this param [2, sliderPosition (_display displayCtrl 31442)];
		_valueSaturation = _this param [3, sliderPosition (_display displayCtrl 31444)];

		with missionNamespace do {
			BIS_fnc_camera_ppColor ppEffectAdjust [1, _valueBrightness, _valueContrast, [1, 1, 1, 0], [1, 1, 1, _valueSaturation], [0.75, 0.25, 0, 1]];
			BIS_fnc_camera_ppColor ppEffectCommit 0;
		};

		(_display displayCtrl 31441) ctrlSetText str (round (_valueBrightness * 100) / 100);
		(_display displayCtrl 31443) ctrlSetText str (round (_valueContrast * 100) / 100);
		(_display displayCtrl 31445) ctrlSetText str (round (_valueSaturation * 100) / 100);
	};

	case "SliderContrast": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_text = str (round (_value * 100) / 100);

		_ctrlValue = _display displayCtrl 31443;
		_ctrlValue ctrlSetText _text;
	};

	case "SliderSaturation": {
		private ["_display"];
		_display = ctrlParent (_this select 0);
		_value = _this select 1;
		_text = str (round (_value * 100) / 100);

		_ctrlValue = _display displayCtrl 31445;
		_ctrlValue ctrlSetText _text;
	};

	case "Paste": {
		_this spawn {
			disableSerialization;
			[] call BIS_fnc_camera;
			waitUntil {
				!isnull (uinamespace getvariable ["BIS_fnc_camera_display", displayNull])
			};
			with uiNamespace do {
				_worldname =	_this param [0, "", [""]];
				if (_worldname != worldName) exitWith {
					["Camera params are for world ""%1"", you're currently on ""%2""", _worldname, worldName] call BIS_fnc_error;
				};
				_pos = _this param [1, position player, [[]], [3]];
				_dir = _this param [2, direction player, [0]];
				_fov = _this param [3, BIS_fnc_camera_fov, [0]];
				_pitchbank =	_this param [4, [0, 0], [[]], [2]];
				_focus =	_this param [5, 0, [0]];
				_aperture =	_this param [6, 0, [0]];
				_daytime =	_this param [7, dayTime * 60, [0]];
				_overcast =	_this param [8, overcast, [0]];
				_acctime =	_this param [9, 0, [0]];
				_brightness =	_this param [10, 1, [0]];
				_contrast =	_this param [11, 0, [0]];
				_saturation =	_this param [12, 1, [0]];

				_pitch =	_pitchbank param [0, 0, [0]];
				_bank = _pitchbank param [1, 0, [0]];

				_display = uinamespace getvariable ["BIS_fnc_camera_display", displayNull];
				_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
				_cam setPos _pos;
				_cam setDir _dir;
				BIS_fnc_camera_fov = _fov;
				[
					_cam,
					_pitch,
					_bank
				] call BIS_fnc_setPitchBank;

				_cam camPrepareFov BIS_fnc_camera_fov;
				_cam camCommitPrepared 0;
				BIS_fnc_camera_pitchbank = _pitchbank;
				(_display displayCtrl 31430) sliderSetPosition _focus;
				(_display displayCtrl 31432) sliderSetPosition _aperture;
				(_display displayCtrl 31434) sliderSetPosition _daytime;
				(_display displayCtrl 31436) sliderSetPosition _overcast;
				(_display displayCtrl 31438) sliderSetPosition _acctime;
				(_display displayCtrl 31440) sliderSetPosition _brightness;
				(_display displayCtrl 31442) sliderSetPosition _contrast;
				(_display displayCtrl 31444) sliderSetPosition _saturation;
				["SliderFocus", [(_display displayCtrl 31430), _focus]] call BIS_fnc_camera;
				["SliderAperture", [(_display displayCtrl 31432), _aperture]] call BIS_fnc_camera;
				["SliderDaytime", [(_display displayCtrl 31434), _daytime]] call BIS_fnc_camera;
				["SliderOvercast", [(_display displayCtrl 31436), _overcast]] call BIS_fnc_camera;
				["SliderAcctime", [(_display displayCtrl 31438), _acctime]] call BIS_fnc_camera;
				["SliderColor", [_display]] call BIS_fnc_camera;
			};
		};
	};

	case "InitDummy": {
		_worldname =	_this param [0, "", [""]];
		if (_worldname != worldName) exitWith {
			["Camera params are for world ""%1"", you're currently on ""%2""", _worldname, worldName] call BIS_fnc_error;
		};
		_pos = _this param [1, position player, [[]], [3]];
		_dir = _this param [2, direction player, [0]];
		_fov = _this param [3, 0.7, [0]];
		_pitchbank =	_this param [4, [0, 0], [[]], [2]];
		_focus =	_this param [5, 0, [0]];
		_aperture =	_this param [6, 0, [0]];
		_daytime =	_this param [7, dayTime * 60, [0]];
		_overcast =	_this param [8, overcast, [0]];
		_acctime =	_this param [9, 0, [0]];
		_brightness =	_this param [10, 1, [0]];
		_contrast =	_this param [11, 0, [0]];
		_saturation =	_this param [12, 1, [0]];

		_pitch =	_pitchbank param [0, 0, [0]];
		_bank = _pitchbank param [1, 0, [0]];

		_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", "camera" camCreate _pos];
		_cam cameraeffect ["internal", "back"];
		_cam camPrepareFov _fov;
		_cam camCommitPrepared 0;
		showCinemaBorder false;
		missionnamespace setvariable ["BIS_fnc_camera_cam", _cam];

		if (isnil "BIS_fnc_camera_ppColor") then {
			BIS_fnc_camera_ppColor = ppEffectCreate ["colorCorrections", 1776];
			BIS_fnc_camera_ppColor ppEffectEnable true;
			BIS_fnc_camera_ppColor ppEffectAdjust [1, 1, 0, [1, 1, 1, 0], [1, 1, 1, 1], [0.75, 0.25, 0, 1]];
			BIS_fnc_camera_ppColor ppEffectCommit 0;
		};

		_cam setDir _dir;
		([_cam] + _pitchbank) call BIS_fnc_setPitchBank;
		["SliderFocus", [controlNull, _focus]] call BIS_fnc_camera;
		["SliderAperture", [controlNull, _aperture]] call BIS_fnc_camera;
		["SliderDaytime", [controlNull, _daytime]] call BIS_fnc_camera;
		["SliderOvercast", [controlNull, _overcast]] call BIS_fnc_camera;
		["SliderAcctime", [controlNull, _acctime]] call BIS_fnc_camera;
		["SliderColor", [displayNull, _brightness, _contrast, _saturation]] call BIS_fnc_camera;
	};

	case "ExitDummy": {
		_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
		_cam cameraeffect ["terminate", "back"];
		camDestroy _cam;

		ppeffectdestroy (missionnamespace getvariable ["BIS_fnc_camera_ppColor", -1]);
		BIS_fnc_camera_ppColor = nil;
	};

	case "Exit": {
		setacctime (missionnamespace getvariable ["BIS_fnc_camera_acctime", 1]);
		setAperture -1;
		enableRadio true;
		showChat true;

		with missionNamespace do {
			_cam = missionnamespace getvariable ["BIS_fnc_camera_cam", objNull];
			_cam cameraeffect ["terminate", "back"];

			if (is3DEN) then {
				get3DENCamera setPos position _cam;
				get3DENCamera setVectorDirAndUp [vectorDir _cam, vectorUp _cam];
				get3DENCamera cameraeffect ["internal", "back"];
				["ShowInterface", true] call BIS_fnc_3DENInterface;
			};

			camDestroy _cam;
			ppEffectDestroy BIS_fnc_camera_ppColor;

			BIS_fnc_camera_cam = nil;
			BIS_fnc_camera_target = nil;
			BIS_fnc_camera_acctime = nil;
			BIS_fnc_camera_ppColor = nil;
		};

		cameraOn switchCamera BIS_fnc_camera_cameraView;

		BIS_fnc_camera_display = nil;
		BIS_fnc_camera_LMB = nil;
		BIS_fnc_camera_RMB = nil;
		BIS_fnc_camera_keys = nil;
		BIS_fnc_camera_LMBclick = nil;
		BIS_fnc_camera_RMBclick = nil;
		BIS_fnc_camera_pitchbank = nil;
		BIS_fnc_camera_fov = nil;
		BIS_fnc_camera_iconCamera = nil;
		BIS_fnc_camera_vision = nil;
		BIS_fnc_camera_visibleHUD = nil;
		BIS_fnc_camera_cameraView = nil;

		removemissioneventhandler ["draw3d", BIS_fnc_camera_draw3D];
		BIS_fnc_camera_draw3D = nil;

		camUseNVG false;
		false setCamUseTI 0;

		if ((productVersion select 4) == "Development") then {
			_displayMission = [] call (uinamespace getvariable "bis_fnc_displayMission");
			_control = _displayMission displayCtrl 11400;
			_control ctrlSetFade 0;
			_control ctrlCommit 0;
		};
	};
};