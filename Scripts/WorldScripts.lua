SIGSTRM12GIS             �S�3           st257420      Signkey.EditorSignature|�?q�b8�������vJ��U�*���Yk�'��%-P���Y��ro>r���ł�9��7��8S�%$�4F�c	�>F���V��i3h�,|O�a&OQ�	8:>�"��lD�:R1;Ǧw d�*a�Q�T�$G��YD�T�Z�� ���,miunE�X�4�$��q����6���^aIؘ�r��i�(N`�8d�;@9����nx��S�Uw�C�|����iz�޻����
�?ߧ��R�{9�ko��)O���d�Q=��H?﻿worldGlobals.worldInfo--[[: CWorldInfoEntity]] = worldInfo
-- set global whether we're on remote interface (much faster than calling function every time)
worldGlobals.netIsRemote = worldInfo:NetIsRemote()
-- for ease of use, create netIsHost as negation of netIsRemote
worldGlobals.netIsHost = not worldGlobals.netIsRemote
worldGlobals.isSinglePlayer = worldInfo:IsSinglePlayer()

-- Called when level starts so that it precaches difficulty
import("Content/Shared/Scripts/Utils.lua")

-- it is important to prepare all classes for net sync right away (so client and serve always have the same classes prepared for net sync)
dofile("Content/SeriousSam4/Scripts/NetSyncClasses.lua")

if corIsAppEditor() then
  function globals.OnStopGame()
  print("Time played : "..timToFloat(globals.worldInfo:SimNow()))
  end
end

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

-- dev scripts are only started in editor and only if they exist, and only when cheats with developer shortcuts are enabled
if corIsAppEditor() and chtGetCheatingLevel(worldInfo) >= 3 then
  scrExecuteDevScriptIfExists("Content/SeriousSam4/Scripts/DevWorldScripts.lua")
end

dofile("Content/Shared/Scripts/Network.lua")

-- execute scripts used only on host machine
if not worldGlobals.netIsRemote then
  dofile("Content/SeriousSam4/Scripts/TurretScripts.lua")
  dofile("Content/SeriousSam4/Scripts/DoorScripts.lua")
  dofile("Content/SeriousSam4/Scripts/SpawnerHelpers.lua")
  dofile("Content/SeriousSam4/Scripts/SirianKeyController.lua")
  dofile("Content/SeriousSam4/Scripts/DoorsWithLightsControl.lua")
  dofile("Content/SeriousSam4/Scripts/Enemies/Drone_Combat_Behavior.lua")
  dofile("Content/SeriousSam4/Scripts/HealthAmmoRestore.lua")
  dofile("Content/SeriousSam4/Scripts/ItemInspect.lua")
end
-- script handling seasonal changes (e.g. Haloween, Christmass etc)
dofile("Content/SeriousSam4/Scripts/Seasons.lua")

dofile("Content/SeriousSam4/Scripts/Player.lua")
dofile("Content/SeriousSam4/Scripts/Netricsa4.lua")
dofile("Content/SeriousSam4/Scripts/TutorialTips.lua")

-- Table containing paths to the weapon parameters
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
 
-- Table containing paths to the gadget parameters
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

����*����@>Rw��0�}-O㣫�Ϊ�W�h֝�g������6��/��Y�i#�y,/i����Yܸ��d�%�����2��{!�|�Az ���07�(�����{��r5����`��?�R����z���Z{��<vG��M��ւM/�_�<�zX@���b������Fy��ዝ�*т�����@e�:�z��ц�������ߓ�`kS���T��N3W뚤i$w�&�܁�ëXO�