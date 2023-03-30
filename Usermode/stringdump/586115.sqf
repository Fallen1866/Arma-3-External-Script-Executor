#line 0 "/temp/bin/A3/Functions_F/GUI/fn_customGPSvideo.sqf"


















_this spawn {

	_content = _this select 0;
	_sizeCoef = if (count _this > 1) then {_this select 1} else {1};

	([] call bis_fnc_rscLayer) cutrsc ["RscMissionScreen","plain"];
	waituntil {!isnull (uinamespace getvariable "BIS_RscMissionScreen")};
	uinamespace setvariable ["BIS_RscMissionScreen_customGPSvideo",uinamespace getvariable "BIS_RscMissionScreen"];

	_contentConfig = configfile >> "RscMiniMap" >> "controlsBackground" >> "CA_MiniMap";
	_contentX = getnumber (_contentConfig >> "x");
	_contentY = getnumber (_contentConfig >> "y");
	_contentW = getnumber (_contentConfig >> "w");
	
	_contentH = _contentW * (10/16) * (4/3); 

	_frameConfig = configfile >> "RscMiniMap" >> "controls" >> "CA_MinimapFrame";
	_frameX = getnumber (_frameConfig >> "x");
	_frameY = getnumber (_frameConfig >> "y");
	_frameW = getnumber (_frameConfig >> "w");
	_frameH = getnumber (_frameConfig >> "h");
	_frame = if (isnil "BIS_fnc_customGPS_Params") then {

		
		gettext (_frameConfig >> "text");
	} else {

		
		_params = BIS_fnc_customGPS_Params;
		if (count _params > 1) then {
			_dX = _params select 1;
			_contentX = _contentX + _dX;
			_frameX = _frameX + _dX;
		};
		if (count _params > 2) then {
			_dY = _params select 2;
			_contentY = _contentY + _dY;
			_frameY = _frameY + _dY;
		};
		_params select 0;
	};

	_posContent = [
		_contentX,
		_contentY,
		_contentW * _sizeCoef,
		_contentH * _sizeCoef
	];
	_posFrame = [
		_frameX,
		_frameY,
		_frameW,
		_frameH
	];

	
	bis_fnc_customGPSvideo_videoStopped = false;

	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1100) ctrladdeventhandler ["videoStopped","bis_fnc_customGPSvideo_videoStopped = true;"];
	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1100) ctrlsetposition _posContent;
	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1100) ctrlsettext _content;
	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1100) ctrlcommit 0;

	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1101) ctrlsetposition _posFrame;
	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1101) ctrlsettext _frame;
	((uinamespace getvariable "BIS_RscMissionScreen_customGPSvideo") displayctrl 1101) ctrlcommit 0;

	waituntil {bis_fnc_customGPSvideo_videoStopped};
	bis_fnc_customGPSvideo_videoStopped = nil;
	([] call bis_fnc_rscLayer) cuttext ["","plain"];
};
