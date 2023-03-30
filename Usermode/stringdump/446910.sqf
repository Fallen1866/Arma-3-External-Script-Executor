#line 0 "/temp/bin/A3/Functions_F/Strategic/fn_ORBATGetGroupParams.sqf"















private [
	"_class",
	"_overrideParams",
	"_fnc_checkOverride",
	"_id",
	"_idText",
	"_type",
	"_typeName",
	"_typeTexture",
	"_typeGender",
	"_cfgType",
	"_size",
	"_sizeTexture",
	"_sizeName",
	"_sizeNameShort",
	"_sizeNameGender",
	"_textDefault",
	"_textShortDefault",
	"_sizeValue",
	"_cfgSize",
	"_side",
	"_sidePrefix",
	"_sideColor",
	"_cfgSide",
	"_text",
	"_textShort",
	"_texture",
	"_textureSize",
	"_insignia",
	"_color",
	"_cfgColor",
	"_commander",
	"_commanderID",
	"_cfgCommander",
	"_commanderRank",
	"_commanderRankNameShort",
	"_commanderTexture",
	"_description",
	"_cfgDescription",
	"_assets",
	"_assetsText",
	"_asset",
	"_assetCountActive",
	"_assetCountInactive",
	"_assetIcon",
	"_infoText",
	"_paramsArray",
	"_cfgParamsArray",
	"_newArray"
];



_class = _this param [0,configfile,[configfile,""]];
































if (typename _class == typename "") exitwith {
	switch (tolower _class) do {
		case "count":			{12};
		case "configname":		{0};
		case "subclasses":		{1};
		case "text":			{2};
		case "texture":			{3};
		case "insignia":		{4};
		case "size":			{5};
		case "color":			{6};
		case "texturesize":		{7};
		case "infotext":		{8};
		case "sizetexture":		{9};
		case "textshort":		{10};
		case "assetstext":		{11};
		default				{-1};
	};
};


if !(isclass _class) then {
	"Class not found" call bis_fnc_error;
	_result = [];
	_result set [0,		""];
	_result set [1,		1];
	_result set [2,			""];
	_result set [3,			""];
	_result set [4,			""];
	_result set [5,			0];
	_result set [6,			[0,0,0,0]];
	_result set [7,		0];
	_result set [8,			""];
	_result set [9,		0];
	_result set [10,		""];
	_result set [11,		[]];
	_result
};

_overrideParams = missionnamespace getvariable ["BIS_fnc_ORBATsetGroupParams_groups",[]];
_fnc_checkOverride = {
	private ["_id","_value","_groupID","_params","_valueOverride"];
	_id = _this select 0;
	_value = _this select 1;

	_groupID = _overrideParams find _class;
	if (_groupID >= 0) then {
		_params = _overrideParams select (_groupID + 1);
		_valueOverride = _params param [_id,_value];
		if !(isnil "_valueOverride") then {_valueOverride} else {_value};
	} else {
		_value
	};
};




_id = [_class,"id"] call bis_fnc_returnconfigentry;
if (isnil "_id") then {_id = "";};
_id = [0,_id] call _fnc_checkOverride;
_idTextShort = "";
_idText = switch (true) do {
	case (typename _id == typename 00): {
		if (_id > 0) then {
			_idType = getnumber (_class >> "idType");
			switch _idType do {
				case 1: {_id call bis_fnc_romanNumeral};
				case 2: {_idTextShort = [_id,true] call bis_fnc_phoneticalWord; [_id,false] call bis_fnc_phoneticalWord};
				case 3: {_id call bis_fnc_teamColor};
				default {_id call bis_fnc_ordinalNumber};
			};
		} else {
			""
		};
	};
	case (typename _id == typename ""): {_id};
	case (typename _id == typename []): {""};
};
if (_idTextShort == "") then {_idTextShort = _idText;};




_size = gettext (_class >> "size");
_size = [1,_size] call _fnc_checkOverride;
_sizeTexture = "";
_sizeName = "";
_sizeNameShort = "";
_sizeNameGender = 0;
_textDefault = "";
_textShortDefault = "";
_sizeValue = 1;
_cfgSize = configfile >> "CfgChainOfCommand" >> "Sizes" >> _size;
if (isclass _cfgSize) then {
	_sizeTexture = gettext (_cfgSize >> "texture");
	_sizeName = gettext (_cfgSize >> "name");
	_sizeNameShort = gettext (_cfgSize >> "nameShort");
	_sizeNameGender = ((_cfgSize >> "nameGender") call BIS_fnc_parseNumberSafe) max 0 min 2;
	if (isnil {_sizeNameGender}) then {_sizeNameGender = 0;};
	_sizeValue = getnumber (_cfgSize >> "size");
	_textDefault = gettext (_cfgSize >> "textDefault");
	_textShortDefault = gettext (_cfgSize >> "textShortDefault");
} else {
	if (_size != "") then {
		["%1: Size '%2' not found in ""CfgChainOfCommand"" >> ""Sizes""",_class,_size] call bis_fnc_error;
	};
};




_type = gettext (_class >> "type");
_type = [2,_type] call _fnc_checkOverride;
_typeName = "";
_typeTexture = "";
_cfgType = configfile >> "CfgChainOfCommand" >> "Types" >> _type;
if (isclass _cfgType) then {
	_typeTexture = gettext (_cfgType >> "texture");
	_typeGender = ["nameMasculine","nameFeminine","nameNeutral"] select _sizeNameGender;
	_typeName = gettext (_cfgType >> _typeGender);
} else {
	if (_type != "") then {
		["%1: Type '%2' not found in ""CfgChainOfCommand"" >> ""Types""",_class,_type] call bis_fnc_error;
	};
};
_typeTexture = _typeTexture call bis_fnc_textureMarker;
_sizeTexture = _sizeTexture call bis_fnc_textureMarker;




_side = gettext (_class >> "side");
_side = [3,_side] call _fnc_checkOverride;
_sidePrefix = "";
_sideColor = [1,1,1,1];
_cfgSide = configfile >> "CfgChainOfCommand" >> "Sides" >> _side;
if (isclass _cfgSide) then {
	_sidePrefix = gettext (_cfgSide >> "prefix");
	_sideColor = (_cfgSide >> "color") call bis_fnc_colorConfigToRGBA;
} else {
	if (_side != "") then {
		["%1: Side '%2' not found in ""CfgChainOfCommand"" >> ""Sides""",_class,_side] call bis_fnc_error;
	};
};




_text = gettext (_class >> "text");
if (_text == "") then {_text = _textDefault;};
_text = [4,_text] call _fnc_checkOverride;




_textShort = gettext (_class >> "textShort");
if (_textShort == "") then {_textShort = _textShortDefault;};
if (_textShort == "") then {_textShort = _text;};
_textShort = [5,_textShort] call _fnc_checkOverride;




_texture = gettext (_class >> "texture");
_texture = [6,_texture] call _fnc_checkOverride;
if (_texture == "" && _sidePrefix != "" && _typeTexture != "") then {_texture = _sidePrefix + _typeTexture};
_texture = _texture call bis_fnc_textureMarker;
_texture = _texture call bis_fnc_textureVehicleIcon;




_textureSize = getnumber (_class >> "textureSize");
_textureSize = [7,_textureSize] call _fnc_checkOverride;
if (_textureSize <= 0) then {
	_textureSize = getnumber (_cfgSide >> "size");
	if (_textureSize <= 0) then {_textureSize = 1;};
};




_insignia = gettext (_class >> "insignia");
_insignia = [8,_insignia] call _fnc_checkOverride;




_cfgColor = _class >> "color";
_color = if (istext _cfgColor) then {
	_colorMarker = configfile >> "CfgMarkerColors" >> (gettext _cfgColor);
	if (isclass _colorMarker) then {(_colorMarker >> "color") call bis_fnc_colorConfigToRGBA} else {_sideColor};
} else {
	if (isarray _cfgColor) then {_cfgColor call bis_fnc_colorConfigToRGBA} else {_sideColor};
};
_color = [9,_color] call _fnc_checkOverride;
if (count _color != 4) then {_color = _sideColor;};




_commander = gettext (_class >> "commander");
_commander = [10,_commander] call _fnc_checkOverride;
_cfgCommander = configfile >> "CfgWorlds" >> "GenericNames" >> _commander >> "LastNames";
if (isclass _cfgCommander) then {
	_classArray = toarray str _class;
	_commanderID = 42;
	{
		_commanderID = _commanderID + (-_x + _foreachindex)^2;
	} foreach _classArray;
	_commanderID = abs (_commanderID % (count _cfgCommander));	
	_commander = gettext (_cfgCommander select _commanderID);
};




_commanderRank = gettext (_class >> "commanderRank");
_commanderRank = [11,_commanderRank] call _fnc_checkOverride;
_commanderRankNameShort = "";
_commanderRankTexture = "";
if (_commanderRank == "") then {_commanderRank = gettext (_cfgSize >> "commanderRank");}; 
if (_commanderRank != "") then {
	_commanderRankNameShort = [_commanderRank,"displayNameShort"] call bis_fnc_rankParams;
	_commanderRankTexture = [_commanderRank,"texture"] call bis_fnc_rankParams;
};




_cfgDescription = _class >> "description";
_description = if (isarray _cfgDescription) then {
	_descriptionArray = getarray _cfgDescription;
	_description = "";
	{
		_description = _description + _x;
		_description = _description + "<br />";
	} foreach _descriptionArray;
	_description
} else {
	gettext _cfgDescription;
};
_description = [12,_description] call _fnc_checkOverride;




_cfgParamsArray = _class >> "ParamsArray";
_paramsArray = [];
if (isarray _cfgParamsArray) then {
	_paramsArray = getArray _cfgParamsArray;
};




_assets = getarray (_class >> "assets");
_assets = [13,_assets] call _fnc_checkOverride;
_assetsText = "";
{
	_asset = _x param [0,"",[""]];
	_assetCountActive = _x param [1,1,[1]];
	_assetCountInactive = _x param [2,0,[0]];

	_assetIcon = gettext (configfile >> "CfgVehicles" >> _asset >> "picture");
	_assetIcon = _assetIcon call bis_fnc_textureVehicleIcon;
	for "_a" from 1 to _assetCountActive do {
		_assetsText = _assetsText + format ["<img image='%1' color='#ffffffff' size='1.1' />",_assetIcon];
	};
	for "_i" from 1 to _assetCountInactive do {
		_assetsText = _assetsText + format ["<img image='%1' color='#55ffffff' size='1.1' />",_assetIcon];
	};
} foreach _assets;



_text = format [
	_text,
	 _idText,
	 _typeName,
	 _sizeName
];
_textShort = format [
	_textShort,
	 _idTextShort,
	 _typeName,
	 _sizeNameShort
];


_space = toarray " " select 0;

_textArray = toarray _text;
{
	if (_x != _space) exitwith {};
	_textArray set [_foreachindex,-1];
} foreach _textArray;
_textArray = _textArray - [-1];
_text = tostring _textArray;

_textShortArray = toarray _textShort;
{
	if (_x != _space) exitwith {};
	_textShortArray set [_foreachindex,-1];
} foreach _textShortArray;
_textShortArray = _textShortArray - [-1];
_textShort = tostring _textShortArray;




_infoText = _text;
if (_commander != "") then {
	if (_commanderRankNameShort == "") then {
		_infoText = _infoText + format ["<br /><t size='0.3' color='#00000000'>-<br /></t><t size='0.8'>%1</t>",_commander];
	} else {
		_infoText = _infoText + format ["<br /><t size='0.3' color='#00000000'>-<br /></t><img image='%1' /><t size='0.8'> %2. %3</t>",_commanderRankTexture,_commanderRankNameShort,_commander];
	};
};
if (_description != "") then {
	if ((count _paramsArray) != 0) then {
		_newArray = [];
		{
			_newArray = _newArray + [call (compile _x)]
		} forEach _paramsArray;
		_paramsArray = _newArray;
		_description = format ([_description] + _paramsArray);
	};
	_infoText = _infoText + format ["<br /><t size='0.5' color='#00000000'>-<br /></t><t size='0.8'>%1</t>",_description];
};


_result = [];
_result set [0,		configname _class];
_result set [1,		1];
_result set [2,		_text];
_result set [3,		_texture];
_result set [4,	_insignia];
_result set [5,		_sizeValue];
_result set [6,		_color];
_result set [7,		_textureSize];
_result set [8,		_infoText];
_result set [9,		_sizeTexture];
_result set [10,		_textShort];
_result set [11,		_assetsText];
_result
