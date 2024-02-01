SIGSTRM12GIS             o��                  Signkey.EditorSignature �Oa����h��G��")�x�ti���T v&���s��A\pam���7�A$��Ñ�>�:��]�0\�I�xS�1�[�ِ���fC>\P�TM<�E���D)��(Rk�~S@�ۊ�ӡ*&WPR��t�~�MCl��$�<�o�ռ<O?�1�nh�\$����������c��2#��xW����,���m�û�&��$������� B�߯�H_�k�0�򶽋��*����8:��4cn���O/���iw��﻿---- supports coop
local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
worldGlobals.AFH = {}
local InitLocalPlayerHandler = function()
  if(worldGlobals.AFH.bLocalPlayerHandlerAttached) then return end
  worldGlobals.AFH.bLocalPlayerHandlerAttached = true
  RunAsync(function()
  while true do
    while (worldGlobals.AFH.penLocalPlayer == nil) do
    local AllPlayers = worldInfo:GetAllPlayersInRange(worldInfo, -1)
    for i=1,#AllPlayers,1 do
      if AllPlayers[i]:IsLocalOperator() then
      worldGlobals.AFH.penLocalPlayer = AllPlayers[i]
      SignalEvent("AFH_LocalPlayerFound")
      break
     end
    end
    Wait(CustomEvent("OnStep"))
   end
   while not IsDeleted(worldGlobals.AFH.penLocalPlayer) do
     Wait(CustomEvent("OnStep"))
   end 
   worldGlobals.AFH.penLocalPlayer = nil
  end
 end)
end
InitLocalPlayerHandler()

local player -- player : CPlayerPuppetEntity  
Wait(CustomEvent("AFH_LocalPlayerFound")) 
player = worldGlobals.AFH.penLocalPlayer

local Gun = nil -- Gun : CWeaponEntity

local A = "TTRS:HudElement.Text_OverHealth=OVERHEALTH"
local HudPointerText_OverHealth = TranslateString(A)
local B = "TTRS:HudElement.Text_Health=HEALTH"
local HudPointerText_Health = TranslateString(B)
local C = "TTRS:HudElement.Text_LowHealth=LOW HEALTH"
local HudPointerText_LowHealth = TranslateString(C)
local D = "TTRS:HudElement.Text_Armor=ARMOR"
local HudPointerText_Armor = TranslateString(D)
local D1 = "TTRS:HudElement.Text_LowArmor=LOW ARMOR"
local HudPointerText_LowArmor = TranslateString(D1)
local D2 = "TTRS:HudElement.Text_OverArmor=OVERARMOR"
local HudPointerText_OverArmor = TranslateString(D2)
local E = "TTRS:HudElement.Text_Ammo=AMMO"
local HudPointerText_Ammo = TranslateString(E)
local F = "TTRS:HudElement.Text_Engine=ENGINE"
local HudPointerText_Vehicle = TranslateString(F)
local G = "TTRS:HudElement.Text_Alt=ALT"
local HudPointerText_Alt = TranslateString(G)
local fBlinkTimer = 0
local HealthText = player:FindHudElementByName("HealthText") -- HealthText : CTextBoxHudElement
local ArmorText = player:FindHudElementByName("ArmorText") -- ArmorText : CTextBoxHudElement
local AmmoText = player:FindHudElementByName("AmmoText") -- AmmoText : CTextBoxHudElement
local AltAmmoText = player:FindHudElementByName("AltAmmoText") -- AltAmmoText : CTextBoxHudElement


local VehicleText = player:FindHudElementByName("VehicleText") -- VehicleText : CTextBoxHudElement
local Ride = worldInfo:GetAllEntitiesOfClass("CLeggedCharacterEntity") -- Ride : CLeggedCharacterEntity

local Weapons = {
  --[[ WEAPONS ]]--
  MinigunParams = {param = "Content/SeriousSam4/Databases/Weapons/MiniGunWeapon.ep", bClip = true},
  RocketLauncherParams = {param = "Content/SeriousSam4/Databases/Weapons/RocketLauncherWeapon.ep", bClip = true},
  CannonParams = {param = "Content/SeriousSam4/Databases/Weapons/CannonWeapon.ep", bClip = true},
  ShotgunParams = {param = "Content/SeriousSam4/Databases/Weapons/SingleShotgunWeapon.ep", bClip = true},
  DBSParams = {param = "Content/SeriousSam4/Databases/Weapons/DoubleShotgunWeapon.ep", bClip = true},
  StickyBomb = {param = "Content/SeriousSam4/Databases/Weapons/StickyBombWeapon.ep", bClip = true},
  Laser = {param = "Content/SeriousSam4/Databases/Weapons/LaserWeapon.ep", bClip = true},
  GrenadeLauncher = {param = "Content/SeriousSam4/Databases/Weapons/GrenadeLauncherWeapon.ep", bClip = true},
  AKParams = {param = "Content/SeriousSam4/Databases/Weapons/AK47Weapon.ep", bClip = true},
  AutoShotgunParams = {param = "Content/SeriousSam4/Databases/Weapons/AutoShotgunWeapon.ep", bClip = true},
  Devastator = {param = "Content/SeriousSam4/Databases/Weapons/DevastatorWeapon.ep", bClip = true},
  PistolParams = {param = "Content/SeriousSam4/Databases/Weapons/PistolWeapon.ep", bClip = true},   
  AssaultRifle = {param = "Content/SeriousSam4/Databases/Weapons/AssaultRifleWeapon.ep", bClip = true},
  FRPCL = {param = "Content/SeriousSam4/Databases/Weapons/FRPCL.ep", bClip = true},
  SniperWeapon = {param = "Content/SeriousSam4/Databases/Weapons/SniperWeapon.ep", bClip = true},
  TypingWeapon = {param = "Content/SeriousSam4/Databases/Weapons/TypingWeapon.ep", bTmar = true},
  
  
  --[[ GADGETS ]]--
  Nuke = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/MiniNuke.ep", bTmar = true},
  MedKit = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/MedKitItem.ep", bTmar = true},
  BlackHole = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/BlackHole.ep", bTmar = true},
  NerveGas = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/NerveGasGadgetItem.ep", bTmar = true},
  CompanionDrone = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/CompanionDroneGadgetItem", bTmar = true},
  DecoyGadgetItem = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/DecoyGadgetItem.ep", bTmar = true},
  ExtraLife = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/ExtraLifeGadgetItem.ep", bTmar = true},
  KavkazSila = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/SeriousRageItem.ep", bTmar = true},
  BatyaAeterno = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/SeriousTime.ep", bTmar = true},
  
  --[[ MELEE ]] --
  
  Knife = {param = "Content/SeriousSam4/Databases/Weapons/KnifeWeapon.ep", bTmar = true},
}

worldGlobals.HideOverridenHudV2 = false

local function SafeDelete(penEntity)
  if not IsDeleted(penEntity) then
    penEntity:Delete()
  else
    return
  end  
end
RunHandled(WaitForever,

OnEvery(CustomEvent("OnStep")),function()
  --[[ AMMO ]]--
    Gun = player:GetRightHandWeapon()
    if(Gun ~= nil) then
      for k,v in pairs(Weapons) do
        if Gun:GetParams():GetFileName() == v["param"] then
          if v["bTmar"] == true then
            if IsDeleted(AmmoText) then
              AmmoText = player:FindHudElementByName("AmmoText") -- AmmoText : CTextBoxHudElement
              AmmoText:Clear()
            end
            AmmoText:Clear()
          elseif v["bClip"] == true then
            if IsDeleted(AmmoText) then
              AmmoText = player:FindHudElementByName("AmmoText") -- AmmoText : CTextBoxHudElement
              AmmoText:SetText(HudPointerText_Ammo,-1,-1)
            end
            AmmoText:SetText(HudPointerText_Ammo,-1,-1)
          else
            if IsDeleted(AmmoText) then
              AmmoText = player:FindHudElementByName("AmmoText") -- AmmoText : CTextBoxHudElement   
              AmmoText:Clear()            
            end
            AmmoText:Clear()
          end      
        end 
      end
    else
    if IsDeleted(AmmoText) then
      AmmoText = player:FindHudElementByName("AmmoText") -- AmmoText : CTextBoxHudElement   
      AmmoText:Clear()            
    end
    AmmoText:Clear()    
  end
  --[[ VEHICLE ]]--
  if player:IsAlive() and player:GetRide() then
    if IsDeleted(VehicleText) then
      VehicleText = player:FindHudElementByName("VehicleText") 
      VehicleText:SetText(HudPointerText_Vehicle,-1,-1)
    end
    VehicleText:SetText(HudPointerText_Vehicle,-1,-1)
  else
    if IsDeleted(VehicleText) then
      VehicleText = player:FindHudElementByName("VehicleText")  
      VehicleText:Clear()
    end
    VehicleText:Clear()  
  end
  if player:IsAlive() and player:GetRide() == nil then
  --[[ HEALTH ]]--
    if player:GetHealth() > 100 then -- [ OVERHEALTH  (> 100)] 
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_OverHealth,-1,-1)
      end
      HealthText:SetText(HudPointerText_OverHealth,-1,-1)
    end
    if player:GetHealth() <= 100 and player:GetHealth() > 35 then -- [ HEALTH (<= 100 && > 35) ] 
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_Health,-1,-1)
      end
      HealthText:SetText(HudPointerText_Health,-1,-1)
    end
    if player:GetHealth() <= 35 then -- [ LOW HEALTH (<= 35) ]
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      end
      HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      fBlinkTimer = timToFloat(worldGlobals.worldInfo:SimNow())*10%5
      if fBlinkTimer<2 then
        if IsDeleted(HealthText) then
          HealthText = player:FindHudElementByName("HealthText")
          HealthText:Clear()
        end
        HealthText:Clear()
      else
        if IsDeleted(HealthText) then
          HealthText = player:FindHudElementByName("HealthText")
          HealthText:SetText(HudPointerText_LowHealth,-1,-1)
        end
        HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      end
    end
  -- [ ARMOR ]
    if player:GetArmor() > 0 then -- [ ARMOR (> 0) ]
      if IsDeleted(ArmorText) then
        ArmorText = player:FindHudElementByName("ArmorText")
        ArmorText:SetText(HudPointerText_Armor,-1,-1)
      end
      ArmorText:SetText(HudPointerText_Armor,-1,-1)
    end
    if player:GetArmor() == 0 then -- [ ARMOR (== 0) ]
      if IsDeleted(ArmorText) then
        ArmorText = player:FindHudElementByName("ArmorText")
        ArmorText:Clear()
      end
      ArmorText:Clear()
    end
  end
end)s��gALQ�M6��d{a����+� �4)�����_�C7NU�c���s�@�E�	rLR�f��Sy0�~e���c�F�;)��m��Շ�@1X��1���"L�>#����	�zB��߄���K\����~sk�?�3Χ��D��x�~ѱ㷰�zj�FG�y�)I��֚�S��S����ݳ��1jS�?<Hdz��@�g{)n�m��'v������h��KD��P�t[�*�7o�G�m�E