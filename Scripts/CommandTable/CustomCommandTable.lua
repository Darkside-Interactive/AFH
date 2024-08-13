--[[  User-bindable Commands  ]]--

-- look and move commands
AddPlayerCommand("plcmdZ-", "TTRS:PlayerCommand.MoveForward=Move Forward", true);
AddPlayerCommand("plcmdZ+", "TTRS:PlayerCommand.MoveBackward=Move Backward", true);
AddPlayerCommand("plcmdX-", "TTRS:PlayerCommand.StrafeLeft=Strafe Left", true);
AddPlayerCommand("plcmdX+", "TTRS:PlayerCommand.StrafeRight=Strafe Right", true);
AddPlayerCommand("plcmdY+", "TTRS:PlayerCommand.JumpSwimUp=Jump/Swim Up", true);
AddPlayerCommand("plcmdY-", "TTRS:PlayerCommand.Crouch/SwimDown=Crouch/Swim Down", true);
AddPlayerCommand("plcmdMouseLook", "TTRS:PlayerCommand.MouseLook=Mouse Look", true);
AddPlayerCommand("plcmdH-", "TTRS:PlayerCommand.LookRight=Look Right", true);
AddPlayerCommand("plcmdH+", "TTRS:PlayerCommand.LookLeft=Look Left", true);
AddPlayerCommand("plcmdP-", "TTRS:PlayerCommand.LookDown=Look Down", true);
AddPlayerCommand("plcmdP+", "TTRS:PlayerCommand.LookUp=Look Up", true);

-- fire, reload and sprint commands
AddPlayerCommand("plcmdFire", "TTRS:PlayerCommand.PrimaryFire=Primary Fire", true);
AddPlayerCommand("plcmdAltFire", "TTRS:PlayerCommand.AimSecondaryFire=Aim/Secondary Fire", true);
AddPlayerCommand("plcmdReload", "TTRS:PlayerCommand.Reload=Reload", true);
AddPlayerCommand("plcmdSprint", "TTRS:PlayerCommand.Sprint=Sprint", true);
AddPlayerCommand("plcmdToggleSprint", "TTRS:PlayerCommand.ToggleSprint=Toggle Sprint", true);


-- player combat commands

AddPlayerCommand("plcmdAFHDash", "TTRS:PlayerCommand.AFH_Dash=[AWAY FROM HOME] Activate Dash", true)


-- usage commands
AddPlayerCommand("plcmdUse", "TTRS:PlayerCommand.UseMelee=Use/Melee", true);
AddPlayerCommand("plcmdGrapplingHook", "TTRS:PlayerCommand.GrapplingHook=Grappling Hook", true);


-- weapon wheel commands
AddPlayerCommand("plcmdShowWeaponWheel", "TTRS:PlayerCommand.ShowWeaponWheel=Show weapon wheel", true)

-- weapon dual wield commands
AddPlayerCommand("plcmdWeaponSelectMod", "TTRS:PlayerCommand.WeaponSelectMod=Weapon Selection Modifier", true);
AddPlayerCommand("plcmdToggleDualWielding", "TTRS:PlayerCommand.ToggleDualWielding=Toggle Dual Wielding", true);

-- gadget weapon commands
AddPlayerCommand("plcmdGadgetQuickUse", "TTRS:PlayerCommand.GadgetQuickUse=Quick use gadget", true);
AddPlayerCommand("plcmdGadgetNext", "TTRS:PlayerCommand.GadgetNext=Next gadget", true);
AddPlayerCommand("plcmdGadgetPrev", "TTRS:PlayerCommand.GadgetPrev=Previous gadget", true);
AddPlayerCommand("plcmdGadgetSelection", "TTRS:PlayerCommand.GadgetSelection=Gadget selection", true);

-- weapon switch commands
AddPlayerCommand("plcmdNextWeapon", "TTRS:PlayerCommand.NextWeapon=Next Weapon", true);
AddPlayerCommand("plcmdPrevWeapon", "TTRS:PlayerCommand.PreviousWeapon=Previous Weapon", true);
AddPlayerCommand("plcmdToggleLastWeapon", "TTRS:PlayerCommand.ToggleLastWeapon=Toggle Last Weapon", true);

-- misc commands
AddPlayerCommand("plcmdDisplayNetricsa", "TTRS:Menu.Netricsa=Netricsa", true);
AddPlayerCommand("plcmdThirdPersonView", "TTRS:PlayerCommand.ThirdPersonView=Third Person View", true);
if sys_strPlatform ~= "Yeti" then
 AddPlayerCommand("plcmdTalk", "TTRS:PlayerCommand.Talk=Talk", true);
end
AddPlayerCommand("plcmdVoiceComm", "TTRS:PlayerCommand.Voice=Use Voice Communication", true);
AddPlayerCommand("plcmdShowWayToGo", "TTRS:PlayerCommand.ShowWayToGo=Way to go", true);
AddPlayerCommand("plcmdTogglePlayerList", "TTRS:PlayerCommand.TogglePlayerList=Toggle Player List", true);

--[[  Non-user-bindable Commands  ]]--

-- mouse look commands
AddPlayerCommand("plcmdMouseH-", "TTRS:PlayerCommand.LookRight=Look Right", false);
AddPlayerCommand("plcmdMouseH+", "TTRS:PlayerCommand.LookLeft=Look Left", false);
AddPlayerCommand("plcmdMouseP-", "TTRS:PlayerCommand.LookDown=Look Down", false);
AddPlayerCommand("plcmdMouseP+", "TTRS:PlayerCommand.LookUp=Look Up", false);

-- controller pad rotation
AddPlayerCommand("plcmdPadH-", "", false);
AddPlayerCommand("plcmdPadH+", "", false);
AddPlayerCommand("plcmdPadP-", "", false);
AddPlayerCommand("plcmdPadP+", "", false);

-- touchpad commands
AddPlayerCommand("plcmdGamepadTouchX+", "", false);
AddPlayerCommand("plcmdGamepadTouchX-", "", false);
AddPlayerCommand("plcmdGamepadTouchY+", "", false);
AddPlayerCommand("plcmdGamepadTouchY-", "", false);
AddPlayerCommand("plcmdGamepadTouchpadClick", "", false);
AddPlayerCommand("plcmdGamepadTouchpadTap", "", false)

-- weapon slot commands
AddPlayerCommand("plcmdWeaponSlot1", "TTRS:PlayerCommand.WeaponSlot1=Weapon Slot 1", true);
AddPlayerCommand("plcmdWeaponSlot2", "TTRS:PlayerCommand.WeaponSlot2=Weapon Slot 2", true);
AddPlayerCommand("plcmdWeaponSlot3", "TTRS:PlayerCommand.WeaponSlot3=Weapon Slot 3", true);
AddPlayerCommand("plcmdWeaponSlot4", "TTRS:PlayerCommand.WeaponSlot4=Weapon Slot 4", true);
AddPlayerCommand("plcmdWeaponSlot5", "TTRS:PlayerCommand.WeaponSlot5=Weapon Slot 5", true);
AddPlayerCommand("plcmdWeaponSlot6", "TTRS:PlayerCommand.WeaponSlot6=Weapon Slot 6", true);
AddPlayerCommand("plcmdWeaponSlot7", "TTRS:PlayerCommand.WeaponSlot7=Weapon Slot 7", true);
AddPlayerCommand("plcmdWeaponSlot8", "TTRS:PlayerCommand.WeaponSlot8=Weapon Slot 8", true);
AddPlayerCommand("plcmdWeaponSlot9", "TTRS:PlayerCommand.WeaponSlot9=Weapon Slot 9", true);
AddPlayerCommand("plcmdWeaponSlot0", "TTRS:PlayerCommand.WeaponSlot0=Weapon Slot 0", true);

-- voting commands
AddPlayerCommand("plcmdEnterVotingMode", "TTRS:PlayerCommand.EnterVotingMode=Enter Voting Mode", true);
AddPlayerCommand("plcmdVoteYes", "", false);
AddPlayerCommand("plcmdVoteNo", "", false);

-- quick save / player list commands
AddPlayerCommand("plcmdQuickSaveTogglePlayerList", "TTRS:PlayerCommand.QuickSaveTogglePlayerList=Quick Save/Toggle Player List", true);
AddPlayerCommand("plcmdPlayerListCommand1", "", false);
AddPlayerCommand("plcmdPlayerListCommand2", "", false);
AddPlayerCommand("plcmdPlayerListUp", "", false);
AddPlayerCommand("plcmdPlayerListDown", "", false);

-- spectator commands
AddPlayerCommand("plcmdSpectatorModeToggle", "", false);
AddPlayerCommand("plcmdSpectatorPrevious", "", false);
AddPlayerCommand("plcmdSpectatorNext", "", false);
AddPlayerCommand("plcmdSpectatorZoomIn", "", false);
AddPlayerCommand("plcmdSpectatorZoomOut", "", false);
AddPlayerCommand("plcmdSpectatorBack", "", false);
AddPlayerCommand("plcmdSpectateBot", "", false);
AddPlayerCommand("plcmdToggleBotRendering", "", false);

-- vehicle control
AddPlayerCommandWithGroup("plcmdVehicleAccelerateForward", "Vehicle", "TTRS:PlayerCommand.VehicleAccelerateForward=Vehicle accelerate forward", false)
AddPlayerCommandWithGroup("plcmdVehicleAccelerateBackward", "Vehicle", "TTRS:PlayerCommand.VehicleAccelerateBackward=Vehicle accelerate backward", false)
AddPlayerCommandWithGroup("plcmdVehicleSteerLeft", "WheeledVehicle", "TTRS:PlayerCommand.VehicleSteerLeft=Vehicle steer left", false)
AddPlayerCommandWithGroup("plcmdVehicleSteerRight", "WheeledVehicle", "TTRS:PlayerCommand.VehicleSteerRight=Vehicle steer right", false)
AddPlayerCommandWithGroup("plcmdVehicleLeanForward", "WheeledVehicle", "TTRS:PlayerCommand.VehicleLeanForward=Vehicle lean forward", false);
AddPlayerCommandWithGroup("plcmdVehicleLeanBackward", "WheeledVehicle", "TTRS:PlayerCommand.VehicleLeanBackward=Vehicle lean backward", false);
AddPlayerCommandWithGroup("plcmdVehicleHandbrake", "WheeledVehicle", "TTRS:PlayerCommand.VehicleHandbrake=Vehicle handbrake", false);
AddPlayerCommandWithGroup("plcmdVehicleYawLeft", "Vehicle", "TTRS:PlayerCommand.VehicleYawLeft=Vehicle yaw left", false)
AddPlayerCommandWithGroup("plcmdVehicleYawRight", "Vehicle", "TTRS:PlayerCommand.VehicleYawRight=Vehicle yaw right", false)
AddPlayerCommandWithGroup("plcmdVehiclePitchForward", "Vehicle", "TTRS:PlayerCommand.VehiclePitchForward=Vehicle pitch forward", false)
AddPlayerCommandWithGroup("plcmdVehiclePitchBackward", "Vehicle", "TTRS:PlayerCommand.VehiclePitchBackward=Vehicle pitch backward", false)
AddPlayerCommandWithGroup("plcmdVehicleRollLeft", "Vehicle", "TTRS:PlayerCommand.VehicleRollLeft=Vehicle roll left", false)
AddPlayerCommandWithGroup("plcmdVehicleRollRight", "Vehicle", "TTRS:PlayerCommand.VehicleRollRight=Vehicle roll right", false)