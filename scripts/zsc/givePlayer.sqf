if (dayz_actionInProgress) exitWith {"You are already performing an action, wait for the current action to finish." call dayz_rollingMessages;};
dayz_actionInProgress = true;

private ["_dialog","_isBusy"];

_isBusy = true;
player setVariable["isBusy",true,true];

if (isPlayer cursorTarget) then {
	ZSC_GiveMoneyTarget = cursorTarget;
	_isBusy = ZSC_GiveMoneyTarget getVariable["isBusy",false];
	if (_isBusy) exitWith {
		player setVariable ["isBusy",false,true];
		format [localize "STR_ZSC_ALREADY_TRADING",name ZSC_GiveMoneyTarget] call dayz_rollingMessages;
	};
	if (!_isBusy) then {
		player setVariable["isBusy",true,true];	
		_dialog = createdialog "GivePlayerDialog";
		_display = uiNamespace getVariable["zsc_dialogs", displayNull];
		_display displayCtrl 14002 ctrlSetText(format[localize "STR_ZSC_NO_COINS",CurrencyName]);
		call GivePlayerDialogAmounts;
	};
} else {
	localize "STR_ZSC_NOT_PLAYER" call dayz_rollingMessages;
};

dayz_actionInProgress = false;
