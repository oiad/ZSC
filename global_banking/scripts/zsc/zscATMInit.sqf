ATMDialogUpdateAmounts = {
	ctrlSetText [23001,format["%1 %2",player getVariable [Z_MoneyVariable,0] call BIS_fnc_numberText,CurrencyName]];
	ctrlSetText [23002,format["%1 %2",player getVariable [z_bankVariable,0] call BIS_fnc_numberText,CurrencyName]];
};

ATMDialogWithdrawAmount = {
	private ["_amount","_bank","_wealth"];

	_amount = parseNumber (_this select 0);	
	_bank = player getVariable [Z_bankVariable,0];
	_wealth = player getVariable [Z_moneyVariable,0];

	if (_amount > 999999) exitWith {"You can not withdraw more than 999,999 coins at once." call dayz_rollingMessages};
	if (_amount < 1 or {_amount > _bank}) exitWith {"You can not withdraw more than is in your bank." call dayz_rollingMessages};

	player setVariable [Z_moneyVariable,(_wealth + _amount),true];
	player setVariable [Z_bankVariable,(_bank - _amount),true];
	call player_forceSave;

	format["You have withdrawn %1 %2.",[_amount] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
};
ATMDialogDepositAmount = {
	private ["_amount","_bank","_wealth"];

	_amount = parseNumber (_this select 0);
	_bank = player getVariable [Z_bankVariable,0];
	_wealth = player getVariable [Z_MoneyVariable,0];

	if (_amount > 999999) exitWith {"You can not deposit more than 999,999 coins at once." call dayz_rollingMessages};
	if (_amount < 1 or {_amount > _wealth}) exitWith {"You can not deposit more than you have." call dayz_rollingMessages};
// start of Donator Banks n shit 
	
if(ZSC_limitOnBank && ((_bank + _amount ) >  ZSC_maxBankMoney )) then {
	if( (getPlayerUID player in ZSC_donator_UID ) && ((_bank + _amount ) =<  ZSC_maxDonatorBank )) then { 
		player setVariable[Z_MoneyVariable,(_wealth - _amount),true];
		player setVariable[Z_bankVariable,(_bank + _amount),true];		
		format["You have deposited %1 %2.", [_amount] call BIS_fnc_numberText, CurrencyName] call dayz_rollingMessages;			
	} else {

		format["You can only have a max of %1 %3, donators %2", [ZSC_maxBankMoney] call BIS_fnc_numberText,[ZSC_maxDonatorBank] call BIS_fnc_numberText,CurrencyName]call dayz_rollingMessages;
	};
	
	//end of Donator Banks n shiet
	
	} else {
		player setVariable [Z_MoneyVariable,(_wealth - _amount),true];
		player setVariable [Z_bankVariable,(_bank + _amount),true];
		format["You have deposited %1 %2",[_amount] call BIS_fnc_numberText,CurrencyName] call dayz_rollingMessages;
		call player_forceSave;
	};
};
