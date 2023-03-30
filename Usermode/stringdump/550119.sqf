#line 0 "/temp/bin/A3/Functions_F/Diagnostic/fn_exportCfgVehiclesAssetDB.sqf"

















private _sides_param = param [0,[4,5,6,7,8,9],[0,[]]];						
private _categories_param = param [1,0,[0]];								

if !(_sides_param isEqualType []) then										
{
	_sides_param = [_sides_param];
};

if (count(_sides_param) > 1) then 
{
	_categories_param = 1;
};

startloadingscreen [""];

_cfgVehicles 			= (configfile >> "cfgvehicles") call bis_fnc_returnchildren;	
_text 					= "";															
_br 					= tostring [13,10];												
_br_long				= "						" + _br + _br;
_product 				= productversion select 0;										
_productShort 			= productversion select 1;										

_scopes 				= ["Private","Protected","Public"];																					
_sides 					= ["OPFOR","BLUFOR","Independent","Civilian","Unknown","Enemy","Friendly","Modules","Empty","Ambient Life"];		
_scopecolor 			= ["#e1c2c2","#fff3b2","#c2e1c2"];																					
_sidecolor 				= ["#e1c2c2","#c2d4e7","#c2e1c2","#dac2e1","#fff3b2","e1c2c2","#c2e1c2","#fdd3a6","#dac2e1","#cccccc"];				


_civilian				= ["Civilians"];
_structures				= ["Structures","Structures (Altis)","Structures (Tanoa)","Walls","Fences"];
_ruins_wrecks			= ["Ruins","Ruins (Altis)","Ruins (Tanoa)","Wrecks"];
_equipment				= ["Equipment","Weapons","Weapon Attachements","Supplies"];
_objects				= ["Furniture","Signs","Things","Other"];
_vr						= ["VR Objects"];
_animals				= ["Animals"];

_categories				= [_civilian, _structures, _ruins_wrecks, _equipment, _objects, _vr, _animals];

_cfg_DLC				= ["Curator","Expansion","Heli","Kart","Mark","Orange","Argo","Tank"];						
_icons_DLC				= [
							"Kart","karts_icon_ca",
							"Heli", "heli_icon_ca",
							"Mark", "mark_icon_ca",
							"Expansion", "apex_icon_ca",
							"Jets", "jets_icon_ca",
							"Orange", "orange_icon_ca",
							"Argo", "malden_icon_ca",
							"Tank", "tank_icon_ca"
						  ];

_exclude_list			= [];


_fnc_getItemPage = {
	switch (_this) do {
		case "Weapon": {"CfgWeapons Weapons"};
		case "VehicleWeapon": {"CfgWeapons Vehicle Weapons"};
		case "Item": {"CfgWeapons Items"};
		case "Equipment": {"CfgWeapons Equipment"};
		default {"CfgWeapons"};
	};
};

_text = format ["{{Template:%1 Assets}}<br />",_product] + _br;


_text = _text + "{| class=""wikitable sortable"" border=""1"" style=""border-collapse:collapse; font-size:80%;"" cellpadding=""3px""" + _br;
_text = _text + "! Preview<br />" + _br;
_text = _text + "! Class Name<br />" + _br;
_text = _text + "! Display Name<br />" + _br;
_text = _text + "! Side<br />" + _br;
_text = _text + "! Category<br />" + _br;
_text = _text + "! Subcategory<br />" + _br;
_text = _text + "! Scope<br />" + _br;
_text = _text + "! DLC<br />" + _br;

if (_categories_param == 0) then 
{
	_text = _text + "! Weapons<br />" + _br;
	_text = _text + "! Magazines<br />" + _br;
	_text = _text + "! Items<br />" + _br;
};
_text = _text + "! Addons<br />" + _br;
_text = _text + "! Features<br />" + _br;

_parsed = [];				


if (3 in _sides_param) then
{
	{	
		_side = getnumber(_x >> "side");
		_editorcategory = gettext(configfile >> "cfgeditorcategories" >> gettext(_x >> "editorCategory") >> "displayname");
		if (_editorcategory == "") then
		{
			_editorcategory = gettext(configfile >> "cfgFactionClasses" >> gettext(_x >> "faction") >> "displayname");
		};
		
		
		if ((configname _x select [0,6]) == "Supply") then
		{
			_exclude_list pushBack _x;
		};
		
		if (((configname _x select [0,15]) == "Land_Carrier_01") && {getnumber(_x >> "scope") != 2}) then
		{
			_exclude_list pushBack _x;
		};
		
		
		if (_side == 3 && {_editorcategory in (_categories select _categories_param)} && {!(_x in _exclude_list)}) then
		{
			_parsed pushBack _x;
		};
	} foreach _cfgVehicles;	
	_cfgVehicles = _parsed;
};

_cfgVehiclesCount = count _cfgVehicles;										
{
	_scope = getnumber(_x >> "scope");										
	_side = getnumber(_x >> "side");										
	
	if (_scope > 0 && _side in _sides_param) then							
	{
		_weapons = [];														
		_magazines = [];													
		
		_textSide = _sides select _side;									
		_textScope = _scopes select _scope;									
		_textDLC = "";														
		_iconDLC = "";														
		_textWeapons = "";													
		_textMagazines = "";												
		_textItems = "";													
		_textAddons = "";													
		_textFeatures = "";													
		
		
		_tmp_features_int = 0;
		_tmp_features_array = [];
		_count_textures = 0;
		_count_animations = 0;
		_count_hiddensel = 0;	
		_count_vehcapacity = 0;
		_count_turrets = 0;
		_array_turrets = [];
		_count_slingload = 0;
		_count_sling_ropes = 0;
		_can_float = 0;
		
		
		_driver = 0;
		_copilot = 0;
		_commanders = 0;
		_ffv_positions = 0;
		_gunners = 0;
		_cargo = 0;
		
		
		_veh_medic = 0;
		_veh_repair = 0;
		_veh_ammo = 0;
		_veh_fuel = 0;
		
		
		_veh_carrier = 0;
		_veh_cargo = 0;
		
		
		_men_medic = 0;
		_men_repair = 0;
		_men_mines = 0;
		_men_uav = 0;
	
		_classname = configname _x;																										
		_displayname = gettext(_x >> "displayname");																					
		_editorcategory = gettext(configfile >> "cfgeditorcategories" >> gettext(_x >> "editorCategory") >> "displayname");				
		_editorsubcategory = gettext(configfile >> "cfgeditorsubcategories" >> gettext(_x >> "editorSubcategory") >> "displayname");	
		_items = ([gettext (_x >> "uniformClass")] + getarray (_x >> "linkedItems") + getarray (_x >> "items")) - [""];					
		_addons = unitaddons _classname;																								
		
		
		if (_editorcategory == "") then
		{
			_editorcategory = gettext(configfile >> "cfgFactionClasses" >> gettext(_x >> "faction") >> "displayname");
		};
		
		
		if (_editorsubcategory == "") then
		{
			_editorsubcategory = gettext(configfile >> "cfgVehicleClasses" >> gettext(_x >> "vehicleClass") >> "displayname");
		};
		
		
		_textDLC = gettext(_x >> "DLC");
		if ((_icons_DLC find _textDLC) != -1) then
		{
			_iconDLC = _icons_DLC select ((_icons_DLC find _textDLC)+1);
		};
		
		
		if (_categories_param == 0) then 
		{
			
			{
				_weapons = _weapons + getarray (_x >> "weapons");
				_magazines = _magazines + getarray (_x >> "magazines");
			} foreach (_classname call bis_fnc_getTurrets);
			
			
			{
				_type = _x call bis_fnc_itemType;								
				_page = (_type select 0) call _fnc_getItemPage;					
				_textWeapons = _textWeapons + _br + format [":[[%1 %3#%2|%2]]",_product,_x,_page];
			} foreach _weapons;
			
			
			while {count _magazines > 0} do {
				_mag = _magazines select 0;
				_textMagazines = _textMagazines + _br + format [":%1x&nbsp;[[%3 CfgMagazines#%2|%2]]",{_x == _mag} count _magazines,_mag,_product];
				_magazines = _magazines - [_mag];
			};
			
			
			while {count _items > 0} do {
				_item = _items select 0;
				_type = _item call bis_fnc_itemType;
				_page = (_type select 0) call _fnc_getItemPage;
				_textItems = _textItems + _br + format [":[[%4 %3#%2|%2]]",{_x == _item} count _items,_item,_page,_product];
				_items = _items - [_item];
			};
		};
		
		
		{	
			if ((_x find "CuratorOnly") == -1) then 
			{
				_textAddons = _textAddons + _br + format [":[[%1 CfgPatches CfgVehicles#%2|%2]]",_product,_x];
			};
		} foreach _addons;
		
		
		
		
		_textFeatures = _textFeatures + "'''Randomization:''' ";
		
		
		_tmp_features_array = getarray(_x >> "TextureList");
		for [{_i = 0},{_i < count _tmp_features_array},{_i = _i + 2}] do 
		{
			if (_tmp_features_array select (_i + 1) > 0) then
			{
				_count_textures = _count_textures + 1;
			};
		};
		
		
		_tmp_features_array = getarray(_x >> "animationList");
		for [{_i = 0},{_i < count _tmp_features_array},{_i = _i + 2}] do 
		{
			if (_tmp_features_array select (_i + 1) > 0 && _tmp_features_array select (_i + 1) < 1) then
			{
				_count_animations = _count_animations + 1;
			};
		};
		
		
		if (_count_textures > 1 || {_count_animations > 0}) then
		{
			_textFeatures = _textFeatures + "Yes";
			
			if (_count_textures > 1) then
			{
				_textFeatures = _textFeatures + ", " + str _count_textures + " skins";
			};
			
			
			if (_count_animations > 0) then
			{
				_textFeatures = _textFeatures + ", " + str _count_animations + " component";
				
				if (_count_animations > 1) then
				{
					_textFeatures = _textFeatures + "s";
				};
			};
			
			_textFeatures = _textFeatures + _br_long;
		}
		else 
		{
			_textFeatures = _textFeatures + "No" + _br_long;
		};
		
		
		
		_count_hiddensel = count getarray(_x >> "hiddenSelections");
		_textFeatures = _textFeatures + "'''Camo&nbsp;selections:'''&nbsp;" + str _count_hiddensel + _br_long;
		
		
		if ((configname _x isKindOf "Air") || {configname _x isKindOf "Car"} || {configname _x isKindOf "Tank"} || {configname _x isKindOf "Ship"}) then
		{ 
			
			
			_get_count_turrets = 
			{
				private _config = _this select 0;
				_count_turrets = _count_turrets + count("true" configClasses(_config >> "Turrets"));
				{
					_array_turrets pushBack _x;			
					[_x] call _get_count_turrets;		
				} forEach ("true" configClasses(_config >> "Turrets"));
			};
			
			[_x] call _get_count_turrets;			
			
			_driver = getnumber(_x >> "hasDriver");			
			_cargo = getnumber(_x >> "transportSoldier");	
			
			
			{	
				if (gettext(_x >> "ProxyType") == "CPCommander") then
				{
					_commanders = _commanders + 1;
				} else 
				{	
					if ((getnumber(_x >> "isCopilot") == 1) && {count(getarray(_x >> "weapons")) == 0 || count(getarray(_x >> "magazines")) == 0}) then
					{
						_copilot = _copilot + 1;
					}
					else
					{	
						if (getnumber(_x >> "isPersonTurret") == 1 && {count(getarray(_x >> "weapons")) == 0 || {count(getarray(_x >> "magazines")) == 0} || {gettext(_x >> "ProxyType") == "CPCargo"}}) then
						{
							_ffv_positions = _ffv_positions + 1;
						} else
						{	
							_gunners = _gunners + 1;
						};
					};
				};
			} forEach _array_turrets;
			
			_count_vehcapacity = _driver + _cargo + _count_turrets; 	
			
			_textFeatures = _textFeatures + "'''Vehicle&nbsp;capacity:'''&nbsp;";
			
			if (getnumber(_x >> "isUav") == 1) then
			{
				_textFeatures = _textFeatures + "Remotely&nbsp;controlled, ";
			};
			_textFeatures = _textFeatures + str _count_vehcapacity;
			
			
			if (_count_vehcapacity > 0) then
			{
				_textFeatures = _textFeatures + " --> ";
				
				
				if (_driver > 0) then
				{
					_textFeatures = _textFeatures + str _driver + "&nbsp;driver";
				};
				
				
				if (_copilot > 0) then
				{
					if (_driver > 0) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _copilot + "&nbsp;copilot";
					
					if (_copilot > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				
				if (_commanders > 0) then
				{
					if ((_driver > 0) || {_copilot > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _commanders + "&nbsp;commander";
					
					if (_commanders > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				
				if (_gunners > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0}) then
					{
						_textFeatures = _textFeatures + ","  + _br_long;
					};
					_textFeatures = _textFeatures + str _gunners + "&nbsp;gunner";
					
					if (_gunners > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				
				if (_ffv_positions > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0} || {_gunners > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _ffv_positions + "&nbsp;firing&nbsp;position";
					
					if (_ffv_positions > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				
				if (_cargo > 0) then
				{
					if ((_driver > 0) || {_copilot > 0} || {_commanders > 0} || {_gunners > 0} || {_ffv_positions > 0}) then
					{
						_textFeatures = _textFeatures + "," + _br_long;
					};
					_textFeatures = _textFeatures + str _cargo + "&nbsp;cargo&nbsp;position";
					
					if (_cargo > 1) then
					{
						_textFeatures = _textFeatures + "s";
					};
				};
				
				_textFeatures = _textFeatures + _br_long;
			};
			
			
			_veh_medic = getnumber(_x >> "attendant");
			_veh_ammo = getnumber(_x >> "transportAmmo");
			_veh_fuel = getnumber(_x >> "transportFuel");
			_veh_repair = getnumber(_x >> "transportRepair");
			
			_textFeatures = _textFeatures + "'''Roles:''' ";
			
			if (_veh_medic > 0) then 
			{
				_textFeatures = _textFeatures + "can&nbsp;heal";
			};
			
			if (_veh_repair > 0) then 
			{
				if (_veh_medic > 0) then 
				{
					_textFeatures = _textFeatures + "," + _br;
				};
				_textFeatures = _textFeatures + "can&nbsp;repair";
			};
			
			if (_veh_ammo > 0) then 
			{
				if (_veh_medic > 0 || {_veh_repair > 0}) then 
				{
					_textFeatures = _textFeatures + ",";
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;ammo";
			};
			
			if (_veh_fuel > 0) then 
			{
				if (_veh_medic > 0 || {_veh_repair > 0} || {_veh_ammo > 0}) then 
				{
					_textFeatures = _textFeatures + "," + _br;
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;fuel";
			};
			
			
			if (!(_veh_fuel > 0) && {!(_veh_medic > 0)} && {!(_veh_repair > 0)} && {!(_veh_ammo > 0)}) then 
			{
				_textFeatures = _textFeatures + "None";
			};
			_textFeatures = _textFeatures + _br_long;
			
			
			_can_float = getnumber(_x >> "canFloat");
			_textFeatures = _textFeatures + "'''Can&nbsp;float:'''&nbsp;";
			
			if (_can_float == 1) then
			{
				_textFeatures = _textFeatures + "Yes" + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "No" + _br_long;
			};
			
			
			_textFeatures = _textFeatures + "'''Vehicle&nbsp;in&nbsp;vehicle&nbsp;transport:''' ";
			if (isclass (_x >> "VehicleTransport")) then
			{
				_veh_carrier = getnumber(_x >> "VehicleTransport" >> "Carrier" >> "maxLoadMass");
				_veh_cargo = getnumber(_x >> "VehicleTransport" >> "Cargo" >> "canBeTransported");
			}
			else 
			{   
				
				
				_veh_cargo = 1;
			};
			
			if (_veh_carrier > 0) then
			{
				_textFeatures = _textFeatures + "Can&nbsp;transport,&nbsp;up&nbsp;to&nbsp;" + str _veh_carrier + "&nbsp;kg. ";
			}
			else
			{
				_textFeatures = _textFeatures + "Cannot&nbsp;transport. ";
			};
			
			if (_veh_cargo > 0) then
			{
				_textFeatures = _textFeatures + "Can be transported." + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "Cannot be transported." + _br_long;
			};
			
			
			_count_slingload = getnumber(_x >> "slingLoadMaxCargoMass");
			_textFeatures = _textFeatures + "'''Slingload:''' ";
			
			if (_count_slingload > 0) then 
			{
				_textFeatures = _textFeatures + "Yes,&nbsp;up&nbsp;to&nbsp;" + str _count_slingload + "&nbsp;kg" + _br_long;
			}
			else
			{
				_textFeatures = _textFeatures + "No" + _br_long;
			};
		};
		
		
		if ((configname _x isKindOf "Man") && {!(configname _x isKindOf "Animal")}) then
		{ 
			
			_textFeatures = _textFeatures + "'''Roles:''' ";
			
			_men_medic = getnumber(_x >> "attendant");
			_men_repair = getnumber(_x >> "engineer");
			_men_mines = getnumber(_x >> "canDeactivateMines");
			_men_uav = getnumber(_x >> "uavHacker");
			
			
			if (_men_medic > 0) then 
			{
				_textFeatures = _textFeatures + "can&nbsp;heal";
			};
			
			if (_men_repair > 0) then 
			{
				if (_men_medic > 0) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;repair";
			};
			
			if (_men_mines > 0) then 
			{
				if (_men_medic > 0 || {_men_repair > 0}) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;deactivate&nbsp;mines";
			};
			
			if (_men_uav > 0) then 
			{
				if (_men_medic > 0 || {_men_repair > 0} || {_men_mines > 0}) then 
				{
					_textFeatures = _textFeatures + ", ";
				};
				_textFeatures = _textFeatures + "can&nbsp;replenish&nbsp;fuel";
			};
			
			
			if (!(_men_medic > 0) && {!(_men_repair > 0)} && {!(_men_mines > 0)} && {!(_men_uav > 0)}) then 
			{
				_textFeatures = _textFeatures + "None";
			};
		};
		
		
		if !(configname _x isKindOf "Man") then
		{ 
			
			_textFeatures = _textFeatures + "'''Slingloadable:''' ";
			_count_sling_ropes = count getarray(_x >> "slingLoadCargoMemoryPoints");
			if (_count_sling_ropes > 0) then
			{
				_textFeatures = _textFeatures + "Yes";
			}
			else
			{
				_textFeatures = _textFeatures + "No";
			};
		};

		_text = _text + "|-" + _br;
		_text = _text + "| " + format ["[[File:%1.jpg|150px|&nbsp;]]",_classname] + _br;												
		_text = _text + "| " + format ["<span id=""%1"" >'''%1'''</span>",_classname] + _br;											
		_text = _text + "| " + "''" + _displayname + "''" + _br;																		
		_text = _text + "| " + format ["style='background-color:%2;' | %1",_textSide,_sideColor select _side] + _br;					
		_text = _text + "| " + _editorcategory + _br;																					
		_text = _text + "| " + _editorsubcategory + _br;																				
		_text = _text + "| " + format ["style='background-color:%2;' | %1",_textScope,_scopeColor select _scope] + _br;					
		if (_iconDLC != "") then 																										
		{
			_text = _text + "| " + format ["[[File:%1.png|50px]]",_iconDLC] + _br;												
		}
		else
		{
			_text = _text + "| " + _textDLC + _br;
		};
		
		if (_categories_param == 0) then 
		{
			_text = _text + "| " + _textWeapons + _br;																					
			_text = _text + "| " + _textMagazines + _br;																				
			_text = _text + "| " + _textItems + _br + _br;																				
		};
		_text = _text + "| " + _textAddons + _br + _br;																					
		_text = _text + "| " + _textFeatures + _br;																						
		
	};
	progressloadingscreen (_foreachindex / _cfgVehiclesCount);
} foreach _cfgVehicles;

_text = _text + "|}" + _br;													
_text = _text + format [
		"<small style=""color:grey;"">Generated by [[%1]] in [[%2]] version %3.%4 by ~~~~</small>",
		_fnc_scriptName,
		productversion select 0,
		(productversion select 2) * 0.01,
		productversion select 3
	] + _br;
_text = _text + format ["<br />{{Template:%1 Assets}}",_product];
copytoclipboard _text;														

endloadingscreen;
