SIGSTRM12GIS             j�B           st257420      Signkey.EditorSignatureg�Ĵ��󨔺�īoRp����J��(��f���Y��EΞLu���4A����4Ј�a�����QR�W��,-:�k9и��#�P�dى���%�Ѫ�n��%��X�C�NǟU�.�;A�%Ա�m2�S��U�r��gѪ*^�0��3�B���4��x}�CxM쭎P��#���y1�c� �[��y��0]��E�⼏:Oi�F�s}��F"��l�>_�8ai�@�S��Nh}\s0���8��X﻿worldGlobals.worldInfo--[[: CWorldInfoEntity]] = worldInfo
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

-- darkside developer scripts are used only if editor is opened and cheats are used with developer shortcuts
if corIsAppEditor() and chtGetCheatingLevel(worldInfo) >= 3 then
  scrExecuteDevScriptIfExists("Content/GoshaLox2/Scripts/DRK_DevWorldScripts.lua")
end

-- global scripts:

dofile("Content/Shared/Scripts/Network.lua")

dofile("Content/GoshaLox2/Scripts/DoorControl.lua")
dofile("Content/GoshaLox2/Scripts/Dash.lua")
dofile("Content/GoshaLox2/Scripts/LocalPlayerHandler.lua")

-- elevator
dofile("Content/GoshaLox2/Scripts/ElevatorControl.lua")

-- player setup

dofile("Content/GoshaLox2/Scripts/Player.lua")
dofile("Content/GoshaLox2/Scripts/Netricsa4.lua")
dofile("Content/GoshaLox2/Scripts/TutorialTips.lua")


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

function worldGlobals.GetWeaponsForGiveAll(player,worldFileName)
  print("Giving all weapons for world " .. worldFileName)
  local ret = {}
    for k, v in pairs(worldGlobals.WeaponParamPaths) do
      table.insert(ret, v)
    end
  return unpack(ret)
endr#���߬���#��W�-)Q��Q��7e$^�l��ߨ�	 `���G�M�.�Kd��u�5^E��C�tAFb�<rI�o��rL�i@��3"L�<������+*��/�|��=wYWph�����45�gJ`^�W�0߲�8��,뺒�ǻ:бQ5ҶxxH�3��g+��IaP�Mc�Ir���Tg�Zwp�eZ@(&B�k����#�B{2	Ɨ���~�j>���gCq桞�����r;��w