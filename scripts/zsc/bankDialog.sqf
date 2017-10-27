if (dayz_actionInProgress) exitWith {localize "str_player_actionslimit" call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_dialog","_playerNear","_isBusy","_typeOf"];

player setVariable["isBusy",true,true];
_isBusy = true;
ZSC_CurrentStorage = _this select 3;
_typeOf = typeOf ZSC_CurrentStorage;

if !(_typeOf in DZE_MoneyStorageClasses) exitWith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	format [localize "STR_ZSC_BANKING_NOT_AVAIL",_typeOf] call dayz_rollingMessages;
};

_playerNear = {isPlayer _x} count ((getPosATL cursortarget) nearEntities ["CAManBase", 10]) > 1;
if (_playerNear) exitWith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	localize "str_pickup_limit_5" call dayz_rollingMessages;
};

_isBusy = ZSC_CurrentStorage getVariable["isBusy",false];
if (_isBusy) exitwith {
	dayz_actionInProgress = false;
	player setVariable["isBusy",false,true];
	format [localize "STR_ZSC_BANKING_IN_USE",_typeOf] call dayz_rollingMessages;
};

ZSC_CurrentStorage setVariable["isBusy",true,true];
_dialog = createDialog "BankDialog";
call BankDialogUpdateAmounts;

dayz_actionInProgress = false;
