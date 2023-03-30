
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_animatePicture'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_animatePicture';
	scriptName _fnc_scriptName;

#line 1 "\A3\Functions_F_Tacops\Systems\fn_animatePicture.sqf [BIS_fnc_animatePicture]"
#line 1 "A3\Functions_F_Tacops\Systems\fn_animatePicture.sqf"
scriptname "BIS_fnc_animatePicture";


































disableSerialization;
params
[
["_userControl", 			controlNull,[controlNull]		],
["_durationOrSpeed", 		2, 			[0]					],
["_translateArray",			[],			[[]]				],
["_scaleArray",				[],			[[]]				],
["_alpha",					0,			[0]					]
];


_translateArray params
[
["_translatePosition",		[0,0],		[[]],			2   ],
["_translateRelative",		true,		[true]				],
["_translateUsingDuration",	true,		[true]				]
];
_translatePosition params
[
["_translateX",				0,			[0]					],
["_translateY",				0,			[0]					]
];


_scaleArray params
[
["_scalePosition",			1,			[[], 0]		   		],
["_scaleRelative",			true,		[true]				],
["_scalePivot",				"center",	[""]				]
];


if (isNull _userControl) exitWith
{
["Animation failed: control  is nil"] call bis_fnc_log;
};


private _currentPosAndSize = ctrlPosition _userControl;
(ctrlPosition _userControl) params ["", "", "_currentW", "_currentH"];

private ["_scaleX", "_scaleY"];


if(typeName _scalePosition == "SCALAR") then 
{
_scaleX = _scalePosition;
_scaleY = _scalePosition;
}
else 
{
_scaleX = _scalePosition select 0;
_scaleY = _scalePosition select 1;
};



if(!_translateRelative) then
{

_translateX	= _translateX - (_currentPosAndSize select 0);
_translateY	= _translateY - (_currentPosAndSize select 1);
};


if(!_scaleRelative) then
{

_scaleX = _scaleX / _currentW;
_scaleY = _scaleY / _currentH;
};


if(!_translateUsingDuration) then
{

if(_durationOrSpeed <= 0) then
{
["Animation failed: speed is <= 0"] call bis_fnc_log;
0;
}
else 
{

_durationOrSpeed = (sqrt (_translateX^2 + _translateY^2)) / _durationOrSpeed;
};
};




switch (toLower(_scalePivot)) do
{
case "topleft":
{
_translateX = -1 * _translateX;
_translateY = -1 * _translateY;
};
case "topcenter":
{
_translateX = ((_currentW * (_scaleX - 1)) / 2) - _translateX;
_translateY = -1 * _translateY;
};
case "topright": 
{
_translateX = (_currentW * (_scaleX - 1)) - _translateX;
_translateY = -1 * _translateY;
};	
case "centerleft":
{
_translateX = -1 * _translateX;
_translateY = ((_currentH * (_scaleY - 1)) / 2) - _translateY;
};
case "center":
{
_translateX = ((_currentW * (_scaleX - 1)) / 2) - _translateX;
_translateY = ((_currentH * (_scaleY - 1)) / 2) - _translateY;
};
case "centerright":
{
_translateX = (_currentW * (_scaleX - 1)) - _translateX;
_translateY = ((_currentH * (_scaleY - 1)) / 2) - _translateY;
};
case "bottomleft":
{
_translateX = -1 * _translateX;
_translateY = (_currentH * (_scaleY - 1)) - _translateY;
};	
case "bottomcenter":
{
_translateX = ((_currentW * (_scaleX - 1)) / 2) - _translateX;
_translateY = (_currentH * (_scaleY - 1)) - _translateY;
};
case "bottomright": 
{
_translateX = (_currentW * (_scaleX - 1)) - _translateX;
_translateY = (_currentH * (_scaleY - 1)) - _translateY;
};	
default 
{
_translateX = ((_currentW * (_scaleX - 1)) / 2) - _translateX;
_translateY = ((_currentH * (_scaleY - 1)) / 2) - _translateY;
};
};


_userControl ctrlSetPosition [(_currentPosAndSize select 0) - _translateX, (_currentPosAndSize select 1) - _translateY, _currentW * _scaleX, _currentH * _scaleY];
_userControl ctrlSetFade _alpha;
_userControl ctrlCommit _durationOrSpeed;


_durationOrSpeed;
