-- keyboard and mouse controls binding
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse X+",     "plcmdMouseH-");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse X-",     "plcmdMouseH+");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Y+",     "plcmdMouseP-");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Y-",     "plcmdMouseP+");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Right",  "plcmdX+");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Left",   "plcmdX-");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Down",   "plcmdZ+");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Up",     "plcmdZ-");

AddDefaultBinding(1, "Keyboard+Mouse", "A",            "plcmdX-");
AddDefaultBinding(1, "Keyboard+Mouse", "D",            "plcmdX+");
AddDefaultBinding(1, "Keyboard+Mouse", "Space",        "plcmdY+");
AddDefaultBinding(1, "Keyboard+Mouse", "Left Control",            "plcmdY-");
AddDefaultBinding(1, "Keyboard+Mouse", "W",            "plcmdZ-");
AddDefaultBinding(1, "Keyboard+Mouse", "S",            "plcmdZ+");

AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Button 1", "plcmdFire");
AddDefaultBinding(1, "Keyboard+Mouse", "R",              "plcmdReload");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Button 2", "plcmdAltFire");
AddDefaultBinding(1, "Keyboard+Mouse", "Tab",            "plcmdTogglePlayerList");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Left", "plcmdPlayerListCommand1");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Right", "plcmdPlayerListCommand2");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Up", "plcmdPlayerListUp");
AddDefaultBinding(1, "Keyboard+Mouse", "Arrow Down", "plcmdPlayerListDown");
AddDefaultBinding(1, "Keyboard+Mouse", "F", "plcmdDisplayNetricsa");
AddDefaultBinding(1, "Keyboard+Mouse", "H",              "plcmdThirdPersonView");
if sys_strPlatform ~= "Yeti" then
  AddDefaultBinding(1, "Keyboard+Mouse", "Y",              "plcmdTalk");
end
AddDefaultBinding(1, "Keyboard+Mouse", "T", "plcmdVoiceComm");
AddDefaultBinding(1, "Keyboard+Mouse", "E", "plcmdUse");
AddDefaultBinding(1, "Keyboard+Mouse", "C", "plcmdShowWayToGo");

AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Button 3", "plcmdShowWeaponWheel");
AddDefaultBinding(1, "Keyboard+Mouse", "Q", "plcmdShowWeaponWheel");
AddDefaultBinding(1, "Keyboard+Mouse", "X", "plcmdToggleLastWeapon");

-- spectator commands
AddDefaultBinding(1, "Keyboard+Mouse", "Space", "plcmdSpectatorModeToggle");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Button 1", "plcmdSpectatorPrevious");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Button 2", "plcmdSpectatorNext");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Wheel Up", "plcmdSpectatorZoomIn");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Wheel Down", "plcmdSpectatorZoomOut");

AddDefaultBinding(1, "Keyboard+Mouse", "/", "plcmdSpectateBot");
AddDefaultBinding(1, "Keyboard+Mouse", "R", "plcmdToggleBotRendering");

AddDefaultBinding(1, "Keyboard+Mouse", "Left Shift", "plcmdSprint");

-- voting shortcuts
AddDefaultBinding(1, "Keyboard+Mouse", "F3", "plcmdVoteYes");
AddDefaultBinding(1, "Keyboard+Mouse", "F4", "plcmdVoteNo");
AddDefaultBinding(1, "Keyboard+Mouse", "F5", "plcmdEnterVotingMode");

-- shortcuts to weapons slots
AddDefaultBinding(1, "Keyboard+Mouse", "1", "plcmdWeaponSlot1");
AddDefaultBinding(1, "Keyboard+Mouse", "2", "plcmdWeaponSlot2");
AddDefaultBinding(1, "Keyboard+Mouse", "3", "plcmdWeaponSlot3");
AddDefaultBinding(1, "Keyboard+Mouse", "4", "plcmdWeaponSlot4");
AddDefaultBinding(1, "Keyboard+Mouse", "5", "plcmdWeaponSlot5");
AddDefaultBinding(1, "Keyboard+Mouse", "6", "plcmdWeaponSlot6");
AddDefaultBinding(1, "Keyboard+Mouse", "7", "plcmdWeaponSlot7");
AddDefaultBinding(1, "Keyboard+Mouse", "8", "plcmdWeaponSlot8");
AddDefaultBinding(1, "Keyboard+Mouse", "9", "plcmdWeaponSlot9");
AddDefaultBinding(1, "Keyboard+Mouse", "0", "plcmdWeaponSlot0");

AddDefaultBinding(1, "Keyboard+Mouse", "Left Alt", "plcmdWeaponSelectMod");

-- weapon cycling
AddDefaultBinding(1, "Keyboard+Mouse", "]",               "plcmdNextWeapon");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Wheel Down",  "plcmdNextWeapon");
AddDefaultBinding(1, "Keyboard+Mouse", "[",               "plcmdPrevWeapon");
AddDefaultBinding(1, "Keyboard+Mouse", "Mouse Wheel Up","plcmdPrevWeapon");

-- gadget cycling
AddDefaultBinding(1, "Keyboard+Mouse", "Z", "plcmdGadgetQuickUse");
AddDefaultBinding(1, "Keyboard+Mouse", "N", "plcmdGadgetPrev");
AddDefaultBinding(1, "Keyboard+Mouse", "M", "plcmdGadgetNext");

-- vehicle control
AddDefaultBinding(1, "Keyboard+Mouse", "W", "plcmdVehicleAccelerateForward")
AddDefaultBinding(1, "Keyboard+Mouse", "S", "plcmdVehicleAccelerateBackward")
AddDefaultBinding(1, "Keyboard+Mouse", "A", "plcmdVehicleSteerLeft")
AddDefaultBinding(1, "Keyboard+Mouse", "D", "plcmdVehicleSteerRight")
AddDefaultBinding(1, "Keyboard+Mouse", "Left Shift", "plcmdVehicleLeanForward");
AddDefaultBinding(1, "Keyboard+Mouse", "Left Control", "plcmdVehicleLeanBackward");
AddDefaultBinding(1, "Keyboard+Mouse", "Space", "plcmdVehicleHandbrake");
AddDefaultBinding(1, "Keyboard+Mouse", "A", "plcmdVehicleYawLeft");
AddDefaultBinding(1, "Keyboard+Mouse", "D", "plcmdVehicleYawRight");
AddDefaultBinding(1, "Keyboard+Mouse", "Num 8", "plcmdVehiclePitchForward");
AddDefaultBinding(1, "Keyboard+Mouse", "Num 5", "plcmdVehiclePitchBackward");
AddDefaultBinding(1, "Keyboard+Mouse", "Num 4", "plcmdVehicleRollLeft");
AddDefaultBinding(1, "Keyboard+Mouse", "Num 6", "plcmdVehicleRollRight");