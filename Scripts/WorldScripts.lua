SIGSTRM12GIS             |�K�                  Signkey.EditorSignature�i��ȗ�41ѓ��]6͢Gp$&ֲ�r�TI���t}���ʴ���o�<��D���u��ȣ�6�%Q6��, n��ۅjh���{��:�3��ģ���bWD1������^��`������~[$~�َ.^��˰�z��c���7u��LJ�L^�(ȥ�@���Ί�x,J(�B�>�	=@�b���H/hVp�c�e҈��+y�??�X��{�t!�T��B�9EZh��|+M��K�ZdK_���A﻿worldGlobals.worldInfo --[[: CWorldInfoEntity]] = worldInfo
-- set global whether we're on remote interface (much faster than calling function every time)
worldGlobals.netIsRemote = worldInfo:NetIsRemote()
-- for ease of use, create netIsHost as negation of netIsRemote
worldGlobals.netIsHost = not worldGlobals.netIsRemote
worldGlobals.isSinglePlayer = worldInfo:IsSinglePlayer()

-- Called when level starts so that it precaches difficulty
import("Content/Shared/Scripts/Utils.lua")

-- it is important to prepare all classes for net sync right away (so client and serve always have the same classes prepared for net sync)
dofile("Content/SeriousSam4/Scripts/NetSyncClasses.lua")

-- Function that is called when game is stopped
worldGlobals.aStopGameCallbacks = {}

 function worldGlobals.RegisterStopGameCallback(func)
  worldGlobals.aStopGameCallbacks[#worldGlobals.aStopGameCallbacks+1] = func
 end

 function worldGlobals.UnregisterStopGameCallback(func)
  for i=1, #worldGlobals.aStopGameCallbacks do
    if worldGlobals.aStopGameCallbacks[i]==func then
      table.remove(worldGlobals.aStopGameCallbacks, i)
      return
    end
  end
 end

 function worldGlobals.OnStopGame()
  for i=1, #worldGlobals.aStopGameCallbacks do
    worldGlobals.aStopGameCallbacks[i]()
  end
end


  
function worldGlobals.OnStopGame()
  print("[AFH]: Time played : "..string.format("%.4f", timToFloat(worldGlobals.worldInfo:SimNow())))
end

-- darkside developer scripts are used only if editor is opened
-- script returns weapon info and last killed entity info
if corIsAppEditor() then
  dofile("Content/GoshaLox2/Scripts/DRK_DevWorldScripts.lua")
end

-- [GLOBAL] : Global scripts for each world

dofile("Content/GoshaLox2/Scripts/Network.lua")

dofile("Content/GoshaLox2/Scripts/DoorControl.lua")
dofile("Content/GoshaLox2/Scripts/Dash.lua")
dofile("Content/GoshaLox2/Scripts/LocalPlayerHandler.lua")
dofile("Content/GoshaLox2/Scripts/TimerClock.lua")

-- [WORLDS ENTITY] : Custom entity script control function for each world

dofile("Content/GoshaLox2/Scripts/ModelStretchLerper.lua")

-- [ELEVATOR] : Feature from the first episode, enables abilitiy to control elevator entity with unlimited ammount of buttons and markers
dofile("Content/GoshaLox2/Scripts/ElevatorControl.lua")

-- [PLAYER] : Setting up player functions and settings such as generating custom animations, setting netricsa, global resistance bar and etc.

dofile("Content/GoshaLox2/Scripts/Player.lua")
dofile("Content/GoshaLox2/Scripts/Netricsa4.lua")
dofile("Content/GoshaLox2/Scripts/GlobalResistanceBar.lua")
dofile("Content/GoshaLox2/Scripts/CustomWorldScripts/NewOverridenHudV2.lua")
dofile("Content/GoshaLox2/Scripts/TutorialTips.lua")


-- [VEHICLE] : Vehicle behaviors that is written in scripts

dofile("Content/GoshaLox2/Vehicles/VEHICLE_M1Tank.lua")

worldGlobals.WeaponParamPaths = {
  Weapon_Knife = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/KnifeWeapon.ep")),
  Weapon_Pistol = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/PistolWeapon.ep")),
  Weapon_SingleShotgun = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/SingleShotgunWeapon.ep")),
  Weapon_DoubleShotgun = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/DoubleShotgunWeapon.ep")),
  Weapon_AutoShotgun = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/AutoShotgunWeapon.ep")),
  Weapon_AssaultRifle = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/AssaultRifleWeapon.ep")),
  Weapon_Minigun = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/MiniGunWeapon.ep")),
  Weapon_RocketLauncher = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/RocketLauncherWeapon.ep")),
  Weapon_GrenadeLauncher = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/GrenadeLauncherWeapon.ep")),
  Weapon_FRPCL = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/FRPCL.ep")),
  Weapon_Laser = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/LaserWeapon.ep")),
  Weapon_Sniper = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/SniperWeapon.ep")),
  Weapon_Cannon = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/CannonWeapon.ep")),
  Weapon_Devastator = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/DevastatorWeapon.ep")),
  Weapon_Explosive = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/StickyBombWeapon.ep")),
}

function worldGlobals.GetWeaponsForGiveAll(player, worldFileName)
  print("Giving all weapons for world " .. worldFileName)
  local ret = {}
  local weaponsList = worldGlobals.WeaponParamPaths;
  for k, v in pairs(weaponsList) do
    table.insert(ret, v)
  end
  return unpack(ret)
 end
 

worldGlobals.GadgetParamPaths = {
  Gadget_ExtraLife = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/ExtraLifeGadgetItem.ep")),
  Gadget_SeriousTime = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/SeriousTime.ep")),
  Gadget_SeriousRage = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/SeriousRageItem.ep")),
  Gadget_BlackHole = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/BlackHole.ep")),
  Gadget_MiniNuke = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/MiniNuke.ep")),
  Gadget_Decoy = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/DecoyGadgetItem.ep")),
  Gadget_NerveGas = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/NerveGasGadgetItem.ep")),
  Gadget_CompanionDrone = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/CompanionDroneGadgetItem.ep")),
  Gadget_MedKit = MakeIdent(Depfile("Content/SeriousSam4/Databases/Items/GadgetItems/MedKitItem.ep")),
}

function worldGlobals.GetGadgetsForGiveAll(player, worldFileName)
  print("Giving all gadgets for world " .. worldFileName)
  local ret = {}
  for k, v in pairs(worldGlobals.GadgetParamPaths) do
    table.insert(ret, v)
  end
  return unpack(ret)
 end
 
-- Table containing paths to the upgrade parameters
worldGlobals.UpgradeParamPaths = {
  Upgrade_RocketMulticharge = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/GenericWeaponUpgrades/Rockets_MultichargeUpgrade.rsc")),
  Upgrade_ShotgunGrenades = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/GenericWeaponUpgrades/Shotgun_GrenadeUpgrade.rsc")),
  Upgrade_ActiveGrenades = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/GenericWeaponUpgrades/GrenadeLauncher_ActiveGrenadesUpgrade.rsc")),
  Upgrade_LaserDeathRay = MakeIdent(Depfile("Content/SeriousSam4/Databases/Weapons/GenericWeaponUpgrades/Laser_DeathRayUpgrade.rsc")),
}

function worldGlobals.GetUpgradesForGiveAll(player, worldFileName)
  print("Giving all upgrades for world " .. worldFileName)
  local ret = {}
  for k, v in pairs(worldGlobals.UpgradeParamPaths) do
    -- add upgrade
    table.insert(ret, v)
  end
  return unpack(ret)
 end

��ι�t8$G0��`�sn���ȯkM�Lfx������?"a�K��M���d���b��2�KC%����ĸ���Z�%��m������
�=� �lN����l+�E��gC;�N�8��Gs���	�b^���c��������
���b��_ܡa`59��cۍfzg;I��+�q��[�ZՕ��4KN���ܳ9��V�!��ړZY�w�M'.��@�����2��2���~B�D|���e�k���