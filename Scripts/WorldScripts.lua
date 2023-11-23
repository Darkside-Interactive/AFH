SIGSTRM12GIS             Т-g           st257420      Signkey.EditorSignature
7̡�nݜZ��-��V/=ts�6VV�e���U"��U�[Y���g�ZW�g ���C��ed�F�P��!�Q5YF������)]�ܗޟD��ើ�I�%t��f>�`b��dd�g4�\]$�F��? Ll=�j�X�{�Uin`�`҂�nv3��CF��Zc$���CGF͕Έ�'	a��
M�0����+���b"P������Dx��9(R��jOM*�kύ�tʽ~+�`�W���I����YI$+8���Y﻿worldGlobals.worldInfo--[[: CWorldInfoEntity]] = worldInfo
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

dofile("Content/Shared/Scripts/Network.lua")

dofile("Content/GoshaLox2/Scripts/DoorControl.lua")
dofile("Content/GoshaLox2/Scripts/Dash.lua")
dofile("Content/GoshaLox2/Scripts/LocalPlayerHandler.lua")

-- elevator
dofile("Content/GoshaLox2/Scripts/ElevatorControl.lua")

-- player settings

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
end���hw$Z��K�/G���J�'�F���=HcG�%�NT�-����MTʁ�����T<K�蚼�o�y&��b�/�~��nI�r�u(�E�v�1.8ӗ���(FAy�=�Ŀ+0��*�
O���ˈG� ��"�L�3�� ���%t"iv����\�"��vH�px��8h���Iܫ��쫨uF98��,
P�v�*��;��k掮|^FE�JR����j�y<*�}��K��)�%h>9�Y�9;⋔ݬ�