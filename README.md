# [EPOCH 1.0.6+] Zupa Single Currency
Zupas Single Currency script updated for Epoch 1.0.6+ by salival.

* Discussion URL: https://epochmod.com/forum/topic/43331-zsc-for-epoch-106-and-overwatch-025/
* original install url: https://github.com/EpochSC/SingleCurrencyStorage
* original discussion url: https://epochmod.com/forum/topic/28493-alpha-release-single-currency-30-storage-default-hive-no-global-banking/
	
* Tested as working on a blank Epoch 1.0.6+ and OverWatch 0.25 server.
* Designed to minimize duping/glitching of bank related saving with nearby players (checkWallet etc).
* Lots of code snippets taken from the original Zupa release thread to stop multiple people checking wallet/depositing into the same safe etc.
* Supports multiple configuration types, Safes/lockboxes only, vehicles only, safes/lockboxes AND vehicles.
* Supports any map, currently only has server_traders files for Chernarus (default), napf and tavi.
* To install global banking: https://github.com/oiad/ZSC#changing-to-global-banking

# Thanks to:
* Zupa for his awesome script being a really good base to start from.
* JasonTM for getting a working copy of the global banking (https://github.com/worldwidesorrow)
* kingpapawawa for helping with testing and supplying the bank icon

# Index:

* [Mission folder install](https://github.com/oiad/ZSC#mission-folder-install)
* [dayz_server folder install](https://github.com/oiad/ZSC#dayz_server-folder-install)
* [Battleye filter install](https://github.com/oiad/ZSC#battleye-filter-install)
* [Changing to global banking](https://github.com/oiad/ZSC#changing-to-global-banking)
* [Installing NPC based banks (optional)](https://github.com/oiad/ZSC#installing-npc-based-banks-optional)
* [Changing so players don't lose coins on death (PVE weenies)](https://github.com/oiad/ZSC#changing-so-players-dont-lose-coins-on-death-pve-weenies)
* [Changing from default epoch CfgTraders to OverWatch CfgTraders](https://github.com/oiad/ZSC#changing-from-default-epoch-cfgtraders-to-overwatch-cfgtraders)
* [Changing from default Chernarus server_traders to any other map](https://github.com/oiad/ZSC#changing-from-default-chernarus-server_traders-to-any-other-map)
* [Adding other classnames to the list of DZE_MoneyStorageClasses](https://github.com/oiad/ZSC#adding-other-classnames-to-the-list-of-dze_moneystorageclasses)
* [Using vehicles to store coins ONLY](https://github.com/oiad/ZSC#using-vehicles-to-store-coins-only)
* [Using vehicles AND DZE_MoneyStorageClasses to store coins](https://github.com/oiad/ZSC#using-vehicles-and-dze_moneystorageclasses-to-store-coins)
* [Giving NEW players coins on their first login](https://github.com/oiad/ZSC#giving-new-players-coins-on-their-first-login)

# Install:

* This install basically assumes you have NO custom variables.sqf or compiles.sqf or fn_selfActions.sqf, I would recommend diffmerging where possible. 
* This has all the config traders set up for epoch 1.0.6+ items and OverWatch guns/items. You will need to install the specific version you want to use, See install notes further down.

**[>> Download <<](https://github.com/oiad/ZSC/archive/master.zip)**

# REPORTING ERRORS/PROBLEMS

1. Please, if you report issues can you please attach (on pastebin or similar) your CLIENT rpt log file as this helps find out the errors very quickly. To find this logfile:

	```sqf
	C:\users\<YOUR WINDOWS USERNAME>\AppData\Local\Arma 2 OA\ArmA2OA.RPT
	```

# Mission folder install:

1. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
	```
	
	and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\variables.sqf";
	```
	
2. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
	```
	
	and add directly below:

	```sqf
	call compile preprocessFileLineNumbers "dayz_code\init\compiles.sqf";
	```

3. In mission\init.sqf find: 
	```sqf
	call compile preprocessFileLineNumbers "server_traders.sqf";
	```
	
	and replace with:

	```sqf
	call compile preprocessFileLineNumbers "scripts\traders\server_traders.sqf";
	```

4. In mission\init.sqf find: 
	```sqf
	waitUntil {scriptDone progress_monitor};
	```
	
	and add directly above:

	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscInit.sqf";
	execVM "scripts\zsc\playerHud.sqf";
	[] execVM "dayz_code\compile\remote_message.sqf";
	```

5. Replace your original description.ext with the one provided or merge the contents if you have modified your own version.

6. If you run ESSv3 spawn script (by [@ebayShopper](https://github.com/ebayShopper/ESSV3)) copy the supplied <code>stringtable - ZSC - ESSv3.xml</code> to your mission file directory and rename it to <code>stringTable.xml</code>

7. If you run Virtual Garage (by [@oiad](https://github.com/oiad/virtualGarage)) copy the supplied <code>stringtable - ZSC - ESSv3 - VG.xml</code> to your mission file directory and rename it to <code>stringTable.xml</code>

8. If you are not running ESSv3 or Virtual Garage copy the supplied <code>stringTable.xml</code> to your mission file directory

# dayz_server folder install:

1. Replace or merge the contents of <code>server_handleSafeGear.sqf</code> provided with your original copy.

# Battleye filter install.

1. In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> add this to the end of it:

	```sqf
	!="createDialog \"BankDialog\";" !="createDialog \"GivePlayerDialog\";"
	```

	So it will then look like this for example:

	```sqf
	5 createDialog <CUT> !="createDialog \"BankDialog\";" !="createDialog \"GivePlayerDialog\";"
	```

2. In your config\<yourServerName>\Battleye\scripts.txt around line 51: <code>5 toString</code> add this to the end of it:

	```sqf
	!"_input = parseNumber (toString (_input));"
	```
	
	So it will then look like this for example:

	``sqf
	5 toString <CUT> !"_input = parseNumber (toString (_input));"
	```

# Changing to global banking:

1. Install ZSC as above to use as a base, global banking is a modular based install so ZSC is required.

2. In mission\init.sqf find:
	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscInit.sqf";
	```
	
	and add directly below:
	```sqf
	call compile preprocessFileLineNumbers "scripts\zsc\zscATMInit.sqf";
	```

3. In mission\description.ext find:
	```sqf
	#include "dayz_code\configs\zscDialogs.hpp"
	```
	
	and add directly below:
	```sqf
	#include "dayz_code\configs\zscATMdialogs.hpp"
	```

4. In mission\dayz_code\init\variables.sqf find:
	```sqf
	ZSC_MaxMoneyInStorageMultiplier = 50000; // Multiplier for how much money a bank object can hold, example: 200 magazine slots in the object (or the default value above ^^) multiplied by the 50,000 multiplier is 10 million coin storage. (200*50000=10m coins)
	```
	
	and add directly below:
	```sqf
	/*
		IMPORTANT: The following 2 variables below are CASE SENSITIVE! If you don't put the object/trader classname EXACTLY how
		they appear in game, THEY WILL NOT WORK!
	*/

	ZSC_bankObjects = [""]; // Array of objects that are available for banking (i.e Suitcase, Info_Board_EP1)
	ZSC_bankTraders = ["Functionary1_EP1_DZ"]; // Array of trader classnames that are available for banking (i.e Functionary1_EP1_DZ)
	ZSC_limitOnBank = true; // Have a limit on the bank? (i.e true or false) limits the global banking to the number below.
	ZSC_maxBankMoney = 5000000; // Default limit for bank objects.
	```

5. Copy the following files to your mission folder preserving the directory structure:
	```sqf
	dayz_code\configs\zscATMdialogs.hpp
	scripts\zsc\images\bank.paa
	scripts\zsc\atmDialog.sqf
	scripts\zsc\playerHud.sqf
	scripts\zsc\zscATMInit.sqf
	```
	
6. Battleye filters for global banking:

	In your config\<yourServerName>\Battleye\scripts.txt around line 12: <code>5 createDialog</code> or <code>5 "createDialog"</code> add this to the end of it:
	```sqf
	!"createDialog \"atmDialog\";"
	```

	So it will then look like this for example:

	```sqf
	5 "createDialog" <CUT> !"createDialog \"BankDialog\";" !"createDialog \"GivePlayerDialog\";" !"createDialog \"atmDialog\";"
	```

7. In infiSTARS AHConfig.sqf, If you have the following line set to true:
	```sqf
	/*  Check Actions ?       */ _CSA = false;	/* true or false */	/* this checks mousewheel actions */
	```
	
	Then you will need to find this line in AHConfig.sqf:
	```sqf
	"r_player_actions2","s_bank_dialog","s_bank_dialog2","s_build_Hedgehog_DZ","s_build_Sandbag1_DZ","s_build_Wire_cat1","s_building_snapping",
	```
	
	And replace it with this line:
	```sqf
	"r_player_actions2","s_bank_dialog","s_bank_dialog1","s_bank_dialog2","s_build_Hedgehog_DZ","s_build_Sandbag1_DZ","s_build_Wire_cat1","s_building_snapping",
	```

# Installing NPC based banks (optional)

1. Copy the following directory to your dayz_server folder:
	```sqf
	dayz_server\bankTraders
	```

2. In mission\init.sqf find this line:
	```sqf
	execVM "\z\addons\dayz_server\traders\chernarus11.sqf"; //Add trader agents
	```
	
	add this line directly below:
	```sqf
	execVM "\z\addons\dayz_server\bankTraders\chernarus.sqf"; //Add banking agents
	```
	You can chose from the following files depending on your map:
	```sqf
	chernarus.sqf
	lingor.sqf
	namalsk.sqf
	napf.sqf
	panthera.sqf
	tavi.sqf
	```

# Changing so players don't lose coins on death (PVE weenies)

1. In mission\dayz_code\init\variables.sqf find this line or similar relating to ZSC:
	```sqf
	ZSC_MaxMoneyInStorageMultiplier = 50000; // Multiplier for how much money a bank object can hold, example: 200 magazine slots in the object (or the default value above ^^) multiplied by the 50,000 multiplier is 10 million coin storage. (200*50000=10m coins)
	```

	Add this line after it:
	```sqf
	Z_moneyVariable = "GlobalMoney"; // Uncomment this this to make it so players don't lose coins on death. Will need to disable checkWallet as you can dupe if you have this and check wallet running.
	```
	You will also need to disable/remove check wallet as then players can get unlimited coins by constantly checking their body.

# Changing from default epoch CfgTraders to OverWatch CfgTraders:

1. In <code>dayz_code\configs</code> move or delete the folder <code>Category</code> and the file <code>cfgServerTrader.hpp</code> 

2. Rename <code>Category - Overwatch</code> to <code>Category</code> 

3. Rename <code>cfgServerTrader - Overwatch.hpp</code> to <code>cfgServerTrader.hpp</code>

4. In <code>scripts\traders</code> move or delete the file <code>server_traders.sqf</code>

5. Rename <code>server_traders - overwatch.sqf</code> to <code>server_traders.sqf</code>

# Changing from default Chernarus server_traders to any other map:

1. In <code>scripts\traders</code> move or delete the file <code>server_traders.sqf</code>

2. Rename <code>server_traders - whatever-map-name.sqf</code> to <code>server_traders.sqf</code>

# Adding other classnames to the list of DZE_MoneyStorageClasses:

1. In <code>dayz_code\init\variables.sqf</code> find: 
	```sqf
	DZE_MoneyStorageClasses = DZE_LockableStorage;
	```
	
	and replace with (using Plastic_Pole_EP1_DZ as an example):

	```sqf
	DZE_MoneyStorageClasses = DZE_LockableStorage + ["Plastic_Pole_EP1_DZ"];
	```

# Using vehicles to store coins ONLY:

1. In <code>scripts\zsc\bankDialog.sqf</code> find:
	```sqf
	if !(_typeOf in DZE_MoneyStorageClasses) exitWith {
	```
	
	and replace with:

	```sqf
	if !(ZSC_CurrentStorage isKindOf "AllVehicles") exitWith {
	```
	
2. In <code>dayz_code\compile\fn_selfActions.sqf</code> find: 
	```sqf
	if (_typeOfCursorTarget in DZE_MoneyStorageClasses && {!locked _cursorTarget} && {!(_typeOfCursorTarget in DZE_LockedStorage)} && {player distance _cursorTarget < 5}) then {
	```
	
	and replace with:

	```sqf
	if (_isVehicle && {!_isMan} && {!locked _cursorTarget} && {_isAlive} && {player distance _cursorTarget < 5}) then {
	```
	
3. dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf</code> provided with your original copy.

# Using vehicles AND DZE_MoneyStorageClasses to store coins:

1. In <code>scripts\zsc\bankDialog.sqf</code> find: 
	```sqf
	if !(_typeOf in DZE_MoneyStorageClasses) exitWith {
	```
	
	and replace with:

	```sqf
	if ((!(_typeOf in DZE_MoneyStorageClasses) && !(cursortarget isKindOf "AllVehicles"))) exitWith {
	```
	
2. In <code>dayz_code\compile\fn_selfActions.sqf</code> find: 
	```sqf
	if (_typeOfCursorTarget in DZE_MoneyStorageClasses && {!locked _cursorTarget} && {!(_typeOfCursorTarget in DZE_LockedStorage)} && {player distance _cursorTarget < 5}) then {
	```
	
	and replace with:

	```sqf
	if ((_typeOfCursorTarget in DZE_MoneyStorageClasses || _isVehicle) && {!_isMan} && {!locked _cursorTarget} && {_isAlive} && !(_typeOfCursorTarget in DZE_LockedStorage) && {player distance _cursorTarget < 5}) then {
	```
	
3. dayz_server folder install:

	Replace or merge the contents of <code>dayz_server\system\server_monitor.sqf</code> provided with your original copy.
	
# Giving NEW players coins on their first login:

1. In <code>dayz_server\compile\server_playerLogin.sqf</code> find:
	```sqf
	PVCDZ_plr_Login = [_charID,_inventory,_backpack,_survival,_isNew,dayz_versionNo,_model,_isHiveOk,_newPlayer,_isInfected,_group,_CharacterCoins,_playerCoins,_BankCoins];
	```
	
	If you want to give the player (so coins are on the body) 5k coins, add this line before it:
	
	```sqf
	if (_newPlayer) then {_characterCoins = 5000;};
	```
	
	If you want to give the player 5k coins into their bank, add this line instead:
	```sqf
	if (_newPlayer) then {_bankCoins = 5000;};
	```	
