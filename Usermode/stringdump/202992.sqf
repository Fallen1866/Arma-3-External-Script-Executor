{
	private _fnc_scriptNameParent = if (isNil '_fnc_scriptName') then {'BIS_fnc_moduleSiteInit'} else {_fnc_scriptName};
	private _fnc_scriptName = 'BIS_fnc_moduleSiteInit';
	scriptName _fnc_scriptName;

#line 1 "A3\modules_f\sites\functions\fn_moduleSiteInit.sqf [BIS_fnc_moduleSiteInit]"
#line 1 "A3\modules_f\sites\functions\fn_moduleSiteInit.sqf"
if (isNil 'BIS_initSitesRunning') then {
BIS_initSitesRunning = TRUE;
['[SITES] Modules config init'] call BIS_fnc_logFormat;
if (isServer) then {execVM '\A3\modules_f\sites\init_core.sqf'} else {execVM '\A3\modules_f\sites\init_client.sqf'};
};}
