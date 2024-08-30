--================================|| PLAYER SEARCHING FUNCTION||======================================================================================================
local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
local player -- player : CPlayerPuppetEntity  
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
--================================|| INITIALIZE PLAYER ||========================================================================================================
Wait(CustomEvent("AFH_LocalPlayerFound")) 
player = worldGlobals.AFH.penLocalPlayer
--================================|| PLAYER TABLE STATS ||=======================================================================================================
local pStats = {
  ["Tourist"] = {dash_power_x = 30, dash_power_y = 10, dash_power_z = 30, dash_recharge = 0.5, health = 300, armor = 300},
  ["Easy"] = {dash_power_x = 25, dash_power_y = 7, dash_power_z = 25, dash_recharge = 1, health = 300, armor = 300},
  ["Normal"] = {dash_power_x = 15, dash_power_y = 4, dash_power_z = 15, dash_recharge = 1.4, health = 200, armor = 200},
  ["Hard"] = {dash_power_x = 10, dash_power_y = 3, dash_power_z = 10, dash_recharge = 1.8, health = 200, armor = 200},
  ["Serious"] = {dash_power_x = 10, dash_power_y = 1, dash_power_z = 10,dash_recharge = 2, health = 200, armor = 200},
  ["Mental"] = {dash_power_x = 5, dash_power_y = 0, dash_power_z = 5, dash_recharge = 3.5, health = 200, armor = 200}
}
--================================|| THIS IS INCLUDES ||======================================================================================================
  -- nothing here, of course :))))))))))))
--================================|| STARTUP MESSAGE ||==========================================================================================================
local BUILD_NUMBER = "0.1.2.8"
local BUILD_STATUS = "ALPHA"
local BUILD_SHA = "29f381"
if player then
  conLogF("[AFH]: CScriptEntity, ('Content/GoshaLox2/Scripts/NewOverridenHudV2.lua') hud started.\n")
else 
  conErrorF("[AFH]: Failed to load CScriptEntity, ('Content/GoshaLox2/Scripts/NewOverridenHudV2.lua')\n       Possible errors: player not found\n")
  return
end
if corIsAppEditor() then
  conLogF("------------- NEW OVERRIDEN HUD -------------\n")
  conLogF("[AFH]: CPlayerPuppetEntity,"..player:GetEntityID()..","..player:GetPlayerName()..")] DP: X: "..pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x..", Y: "..pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_y..", Z: "..pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x.." KD: "..pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_recharge.."\n")
  conLogF("[AFH]: CPlayerPuppetEntity,"..player:GetEntityID()..","..player:GetPlayerName()..")] M_HEALTH: "..player:GetMaxHealth()..", M_ARMOR: "..player:GetMaxArmor().."\n")  
  conLogF("[AFH]: World Difficulty(GDF): "..worldInfo:GetGameDifficulty().."\n")
  conLogF("[AFH]: World GameMode: "..worldInfo:GetGameMode().." ("..(worldInfo:GetGameMode() == "SinglePlayer" and "Cooperative" or "SinglePlayer").." is not possible)\n")
  if scrFileExists("Content/GoshaLox2/Scripts/DRK_DevWorldScripts.lua") then
    conLogF("[AFH]: B_INF: V: "..BUILD_NUMBER.."\n[AFH]:        S: "..BUILD_STATUS.."\n[AFH]:        SH: "..BUILD_SHA.."\n")
  else
    conLogF("[AFH]: Can't find Developer Scripts.\n")
  end
  if(player:GetPlayerName() == "![C]E_the_Bre]a[ker") then
    conLogF("[AFH]: Hello, ![C]E_the_Bre]a[ker. Welcome back.\n")
  else
    conLogF("[AFH]: USER: "..player:GetPlayerName().."\n")
  end
  conLogF("-------------------------------------------------------\n")
end
--================================|| GLOBAL VARIABLES||=======================================================================================================
local bDashRechargeIsDynamicOrFixed = true
local isDamage,isSpeed,isInvulnerability = false
local bTimerActive = false
local DashAvailable = true
local Can_Dodge = true
local tempo = nil
local Direction_Back = nil
local Gun = nil -- Gun : CWeaponEntity
local Gun_Left = nil -- Gun_Left : CWeaponEntity
local fBlinkTimer = 0
--================================|| GLOBAL TEXT VARIABLES ||=================================================================================================
local HudPointerText_OverHealth = TranslateString("TTRS:HudElement.Text_OverHealth=OVERHEALTH")
local HudPointerText_Health = TranslateString("TTRS:HudElement.Text_Health=HEALTH")
local HudPointerText_LowHealth = TranslateString("TTRS:HudElement.Text_LowHealth=LOW HEALTH")
local HudPointerText_Armor = TranslateString("TTRS:HudElement.Text_Armor=ARMOR")
local HudPointerText_LowArmor = TranslateString("TTRS:HudElement.Text_LowArmor=LOW ARMOR")
local HudPointerText_OverArmor = TranslateString("TTRS:HudElement.Text_OverArmor=OVERARMOR")
local HudPointerText_Ammo = TranslateString("TTRS:HudElement.Text_Ammo=AMMO")
local HudPointerText_Vehicle = TranslateString("TTRS:HudElement.Text_Engine=ENGINE")
local HudPointerText_Alt = TranslateString("TTRS:HudElement.Text_Alt=ALT")
local HudPointerText_Left = TranslateString("TTRS:HudElement.Text_Left=LEFT")
local HudPointerText_Right = TranslateString("TTRS:HudElement.Text_Right=RIGHT")
--================================|| GLOBAL HUD ELEMENTS VARIABLES||===========================================================================================
local HealthArmor = player:FindHudElementByName("H_A") -- HealthArmor : CModelHudElement
local Compass = player:FindHudElementByName("Compass") -- Compass : CModelHudElement
local mdlDashBar = player:FindHudElementByName("H_A") -- mdlDashBar : CModelHudElement
local GDF = worldInfo:GetGameDifficulty()  
--================================|| RESOURCES ||==============================================================================================================
local dash = LoadResource("Content/GoshaLox2/Presets/PostProcessing/Dash.rsc") -- dash : CPostProcessingEffectEntity
local HUD = LoadResource("Content/GoshaLox2/Scripts/Templates/NewOverridenHudV2.rsc") -- HUD : CTemplatePropertiesHolder
--================================|| TABLES ||=================================================================================================================
local Weapons = {
  --[[ WEAPONS ]]--
  MinigunParams = {param = "Content/SeriousSam4/Databases/Weapons/MiniGunWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/MinigunIcon.mdl")},
  RocketLauncherParams = {param = "Content/SeriousSam4/Databases/Weapons/RocketLauncherWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/RocketLauncherIcon.mdl")},
  CannonParams = {param = "Content/SeriousSam4/Databases/Weapons/CannonWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/CannonIcon.mdl")},
  ShotgunParams = {param = "Content/SeriousSam4/Databases/Weapons/SingleShotgunWeapon.ep", bUpgrade = true, bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/SingleShotgunIcon.mdl")},
  DBSParams = {param = "Content/SeriousSam4/Databases/Weapons/DoubleShotgunWeapon.ep", bUpgrade = true, bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/DBSIcon.mdl")},
  StickyBomb = {param = "Content/SeriousSam4/Databases/Weapons/StickyBombWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/C4Icon.mdl")},
  Laser = {param = "Content/SeriousSam4/Databases/Weapons/LaserWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/LaserIcon.mdl")},
  GrenadeLauncher = {param = "Content/SeriousSam4/Databases/Weapons/GrenadeLauncherWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/GrenadeLauncherIcon.mdl")},
  AKParams = {param = "Content/SeriousSam4/Databases/Weapons/AK47Weapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/AK47Icon.mdl")},
  AutoShotgunParams = {param = "Content/SeriousSam4/Databases/Weapons/AutoShotgunWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/AutoShotgunIcon.mdl")},
  Devastator = {param = "Content/SeriousSam4/Databases/Weapons/DevastatorWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/DevastatorIcon.mdl")},
  PistolParams = {param = "Content/SeriousSam4/Databases/Weapons/PistolWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/PistolIcon.mdl")},   
  AssaultRifle = {param = "Content/SeriousSam4/Databases/Weapons/AssaultRifleWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/AssaultRifleIcon.mdl")},
  FRPCL = {param = "Content/SeriousSam4/Databases/Weapons/FRPCL.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/FRCPLIcon.mdl")},
  SniperWeapon = {param = "Content/SeriousSam4/Databases/Weapons/SniperWeapon.ep", bClip = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/SniperWeaponIcon.mdl")},
  TypingWeapon = {param = "Content/SeriousSam4/Databases/Weapons/TypingWeapon.ep", bTmar = true},
  --[[ GADGETS ]]--
  Nuke = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/MiniNuke.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/MiniNukeIcon.mdl")},
  MedKit = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/MedKitItem.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/MedKitIcon.mdl")},
  BlackHole = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/BlackHole.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/BlackHoleIcon.mdl")},
  NerveGas = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/NerveGasGadgetItem.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/NerveGasGadgetIcon.mdl")},
  CompanionDrone = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/CompanionDroneGadgetItem", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/CompanionDroneIcon.mdl")},
  DecoyGadgetItem = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/DecoyGadgetItem.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/DecoyGadgetIcon.mdl")},
  ExtraLife = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/ExtraLifeGadgetItem.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/ExtraLifeGadgetIcon.mdl")},
  KavkazSila = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/SeriousRageItem.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/KavkazIcon.mdl")},
  BatyaAeterno = {param = "Content/SeriousSam4/Databases/Items/GadgetItems/SeriousTime.ep", bTmar = true, mdlIcon = ("Content/GoshaLox2/Interface/WeaponIcons/AeternoIcon.mdl")}, 
   --[[ MELEE ]] --  
  Knife = {param = "Content/SeriousSam4/Databases/Weapons/KnifeWeapon.ep", bTmar = true, mdlIcon = "icon_knife"},
}
--================================|| L-FUNCTIONS ||=============================================================================================================
--[[------------------------------------------------------------------
  INTERFACE ELEMENT POSITION ANIMATION(AscendToHeaven)
  Lerps element position from it's current (vStartPosition) to desired position (vEndPosition)
  with easing (OutSine, InSine) and specified speed of animation
]]--------------------------------------------------------------------
local function AscendToHeaven(penModel, vEndPosition, easingType, fSpeed)
  local vStartPosition 
  local tmStart2 = worldInfo:SimNow()
  local fTimePassed = 0
  local fTimeTotal = fSpeed or 0.169
  
  worldGlobals.tmLastStartDashOffset = tmStart2
   
  if IsDeleted(penModel) then  
    penModel = player:FindHudElementByName("H_A")
  end
  vStartPosition = penModel:GetPosition()
  while fTimePassed < fTimeTotal and tmStart2 == worldGlobals.tmLastStartDashOffset do
    fTimePassed = timToFloat(worldInfo:SimNow() - tmStart2)
    local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
    local fOffsetRatio 
    if easingType == "EaseOutSine" then
      fOffsetRatio = mthVector3f(
        mthLerpF(vStartPosition.x, vEndPosition.x, mthSinF((fTimeRatio * 3.14159) / 2)),
        mthLerpF(vStartPosition.y, vEndPosition.y, mthSinF((fTimeRatio * 3.14159) / 2)),
        mthLerpF(vStartPosition.z, vEndPosition.z, mthSinF((fTimeRatio * 3.14159) / 2))
      )
    elseif easingType == "EaseInSine" then
      fOffsetRatio = mthVector3f(
        mthLerpF(vStartPosition.x, vEndPosition.x, 1 - mthCosF((fTimeRatio * 3.14159) / 2)),
        mthLerpF(vStartPosition.y, vEndPosition.y, 1 - mthCosF((fTimeRatio * 3.14159) / 2)),
        mthLerpF(vStartPosition.z, vEndPosition.z, 1 - mthCosF((fTimeRatio * 3.14159) / 2))
      )       
    end   
    if IsDeleted(penModel) then
      penModel = player:FindHudElementByName("H_A")  
      penModel:SetPosition(fOffsetRatio)
    end
    penModel:SetPosition(fOffsetRatio)
    Wait(CustomEvent("OnStep"))
  end
end
local function ClockTimer(convertType, seconds, type, value, bTimer)
  seconds = tonumber(seconds)
  
  local hours, mins, secs
  local h, m, s
  
  if type == "s" then
    if convertType == "hours" then
      hours = string.format("%02.f", mthFloorF(seconds/3600));
      mins = string.format("%02.f", mthFloorF(seconds/60 - (hours*60)));
      secs = string.format("%02.f", mthFloorF(seconds - hours*3600 - mins *60));
      return hours..":"..mins..":"..secs
    elseif convertType == "mins" then
      mins = string.format("%02.f", mthFloorF(seconds/60));
      secs = string.format("%02.f", mthFloorF(seconds - mins *60));
      return mins..":"..secs  
    elseif convertType == "secs" then
      mins = "00"
      secs = string.format("%02.f", mthFloorF(seconds - mins *60))
      return mins..":"..secs            
    else
      conErrorF("[AFH]: Invalid format type: '"..convertType.."'\n")
    end
 elseif type == "t" then
   if not string.match(value, "^%d+:%d+:%d+$") then
     conErrorF("[AFH]: Invalid time format: "..value.."\n")
     return
   else
     return value
   end
 else
   conErrorF("[AFH]: Invalid time specified in '"..value.."'\n") 
 end
 Wait(CustomEvent("OnStep"))
end
local function SafeDelete(penEntity)
  if not IsDeleted(penEntity) then
    penEntity:Delete()
  end  
end

--[[------------------------------------------------------------------
  BARS ANIMATIONS
  Interpolation function for each bar on interface.
]]--------------------------------------------------------------------
local function LerpModelShaderArg(chLerpType, penModel, fStartOffset, fEndOffset, fSpeed, strShaderName, vEndPosition, easingType, chPlayerStat, strStatName, tmLastOffsetTime)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    tmLastOffsetTime = tmStart
    
    while fTimePassed < fTimeTotal and tmStart == tmLastOffsetTime do
      if chLerpType == "ascend_to_heaven" then
        fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
        if IsDeleted(penModel) then
          penModel = player:FindHudElementByName(penModel)
        end
        local vStartPosition = penModel:GetPosition()
        local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
        local fOffsetRatio 
          if easingType == "EaseOutSine" then
            fOffsetRatio = mthVector3f(
              mthLerpF(vStartPosition.x, vEndPosition.x, mthSinF((fTimeRatio * 3.14159) / 2)),
              mthLerpF(vStartPosition.y, vEndPosition.y, mthSinF((fTimeRatio * 3.14159) / 2)),
              mthLerpF(vStartPosition.z, vEndPosition.z, mthSinF((fTimeRatio * 3.14159) / 2))
            )
          elseif easingType == "EaseInSine" then
            fOffsetRatio = mthVector3f(
              mthLerpF(vStartPosition.x, vEndPosition.x, 1 - mthCosF((fTimeRatio * 3.14159) / 2)),
              mthLerpF(vStartPosition.y, vEndPosition.y, 1 - mthCosF((fTimeRatio * 3.14159) / 2)),
              mthLerpF(vStartPosition.z, vEndPosition.z, 1 - mthCosF((fTimeRatio * 3.14159) / 2))
            )       
          end   
          if IsDeleted(penModel) then
            penModel = player:FindHudElementByName("H_A")  
          end
          penModel:SetPosition(fOffsetRatio)
      elseif chLerpType == "e_stripes" then
        fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
        
        local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
        local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, mthSinF((fTimeRatio * 3.14159) / 2))
        if IsDeleted(penModel) then
          penModel = player:FindHudElementByName("H_A")
        end
        penModel:SetShaderArgValFloat(strShaderName, fOffsetRatio)      
      elseif chLerpType == "h_stripes" then
        fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
        local fStripeStartOffset
        local fStripeEndOffset
        if chPlayerStat == "health" then
          fStripeStartOffset = penModel:GetShaderArgValFloat(strShaderName)
          fStripeEndOffset = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].health/player:GetHealth()))
        elseif chPlayerStat == "armor" then
          fStripeStartOffset = penModel:GetShaderArgValFloat(strShaderName)
          fStripeEndOffset = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].armor/player:GetArmor()))        
        end  
        local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
        local fOffsetRatio = mthLerpF(fStripeStartOffset, fStripeEndOffset, mthSinF((fTimeRatio * 3.14159) / 2))
        if IsDeleted(penModel) then
          penModel = player:FindHudElementByName("H_A")
        end
        penModel:SetShaderArgValFloat(strShaderName, fOffsetRatio)    
      end        
    end
    Wait(CustomEvent("OnStep"))
  end)
end
--[[------------------------------------------------------------------
  INTERFACE TIMER
  Timer on interface that converts specified seconds in timer format (H:M:S) or starts a timer from specified time (h:m:s).
]]--------------------------------------------------------------------
function worldGlobals.StartTimer(convertType, strTimerName, seconds, type, value)
  
  worldGlobals.bLoopTimer = true
  Wait(Delay(1))
  
  local TimerSound = nil
  local TimeTextBox = nil
  local TextTextBox = nil
  local fBlinkTimer = nil
  local blink = nil
  
  if type == "s" then
    local seconds = tonumber(seconds)
    while seconds >= 0 and worldGlobals.bLoopTimer == true do
      local formatted_time = ClockTimer(convertType, seconds, "s")
      TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
      TextTextBox = player:FindHudElementByName("TimerText") -- TextTextBox : CTextBoxHudElement
      if IsDeleted(TimeTextBox) then
        TimeTextBox = player:FindHudElementByName("Timer")
        TimeTextBox:SetText(formatted_time,-1,-1)
      end
      TimeTextBox:SetText(formatted_time,-1,-1)
      if IsDeleted(TextTextBox) then
        TextTextBox = player:FindHudElementByName("TimerText")
        TextTextBox:SetText(TranslateString(strTimerName),-1,-1)
      end
      TextTextBox:SetText(TranslateString(strTimerName),-1,-1)  
      Wait(Delay(1))
      seconds = seconds - 1 
      if seconds <= 10  then             
        local TimerSound = HUD:SpawnEntityFromTemplateByName("TimerSound", worldInfo, player:GetPlacement()) -- TimerSound : CStaticSoundEntity
        if IsDeleted(TimerSound) then
          TimerSound = HUD:SpawnEntityFromTemplateByName("TimerSound", worldInfo, player:GetPlacement())
          TimerSound:SetParent(player, "")
        end
        if not IsDeleted(TimerSound) then
          if(time_seconds) ~=0 then
            TimerSound:PlayOnce()
          else
            SafeDelete(TimerSound)
          end
        end
      elseif seconds == 0 then
        return
      end
    end  
    SignalEvent(worldGlobals.worldInfo, "TimerFinished")
    worldGlobals.bLoopTimer = false
    if IsDeleted(TimerSound) then
      TimerSound = HUD:SpawnEntityFromTemplateByName("TimerSound", worldInfo, player:GetPlacement())  
      TimerSound:SetParent(player, "")
    end
    TimerSound:Delete()
    if IsDeleted(TimeTextBox) then
      TimeTextBox = player:FindHudElementByName("Timer")
      TimeTextBox:Clear()
    end
    TimeTextBox:Clear()  
    if IsDeleted(TextTextBox) then
      TextTextBox = player:FindHudElementByName("TimerText")
      TextTextBox:Clear()
    end
    TextTextBox:Clear()          
  elseif type == "t" then
    local h,m,s = string.match(value, "^(%d+):(%d+):(%d+)$")
    h,m,s = tonumber(h), tonumber(m), tonumber(s)
    local time_seconds = h*3600 + m*60 + s
    while time_seconds >= 0 and worldGlobals.bLoopTimer == true do
      local time = string.format("%02.f:%02.f:%02.f", h, m, s)
       TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
       TextTextBox = player:FindHudElementByName("TimerText")
        if IsDeleted(TimeTextBox) then
          TimeTextBox = player:FindHudElementByName("Timer")
          TimeTextBox:SetText(time,-1,-1)
        end
      TimeTextBox:SetText(time,-1,-1)
      if IsDeleted(TextTextBox) then
        TextTextBox = player:FindHudElementByName("TimerText")
        TextTextBox:SetText(TranslateString(strTimerName),-1,-1)
      end
      TextTextBox:SetText(TranslateString(strTimerName),-1,-1)      
      Wait(Delay(1))
      time_seconds = time_seconds - 1
      h, m, s = mthFloorF(time_seconds/3600), mthFloorF((time_seconds%3600)/60), time_seconds%60
      if time_seconds <= 10 then
        TimerSound = HUD:SpawnEntityFromTemplateByName("TimerSound", worldInfo, player:GetPlacement()) -- TimerSound : CStaticSoundEntity
        if IsDeleted(TimerSound) then
          TimerSound = HUD:SpawnEntityFromTemplateByName("TimerSound", worldInfo, player:GetPlacement())
          TimerSound:SetParent(player, "")
        end
        if not IsDeleted(TimerSound) then
          if(time_seconds) ~= 0 then
            TimerSound:PlayOnce()
          else
            SafeDelete(TimerSound)
          end
        end
        if(time_seconds) == 0 then
          break
        end
      end
   end
   SignalEvent(worldGlobals.worldInfo, "TimerFinished")
   worldGlobals.bLoopTimer = false
   if IsDeleted(TimerSound) then
     TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement())  
     TimerSound:SetParent(player, "")
   end
   TimerSound:Delete()
   if IsDeleted(TimeTextBox) then
     TimeTextBox = player:FindHudElementByName("Timer")
     TimeTextBox:Clear()
   end
   TimeTextBox:Clear()
   if IsDeleted(TextTextBox) then
     TextTextBox = player:FindHudElementByName("TimerText")
     TextTextBox:Clear()
   end
   TextTextBox:Clear()
   
  else
    conErrorF("[AFH]: Invalid format type: '"..type.."'\n")
  end
  Wait(CustomEvent("OnStep"))
end


RunHandled(WaitForever,


--[[------------------------------------------------------------------
  DODGE MECHANIC 
  It's now here because I need to animate two separate bars by one function call  
]]--------------------------------------------------------------------
OnEvery(CustomEvent("Do_Dodge_Sam")),function(Do_Dodge_Sam)
  if worldGlobals.CanDodge == true and Can_Dodge == true and player:IsAlive() then
    Can_Dodge = false
      player:PlaySchemeSound("Dash")
      local Dont_Do_Another_Dodge = false
        if player:GetCommandValue("plcmdX-") and Dont_Do_Another_Dodge == false then -- Left Dodge
            tempo.x = tempo.x * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x
            tempo.y = tempo.y * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_y
            tempo.z = tempo.z * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_z
            player:SetLinearVelocity(tempo)
            Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdX+") and Dont_Do_Another_Dodge == false then -- Right Dodge
            tempo.x = tempo.x * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x
            tempo.y = tempo.y * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_y
            tempo.z = tempo.z * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_z
            player:SetLinearVelocity(tempo)  
          Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdZ-") and Dont_Do_Another_Dodge == false then -- Forward Dodge
            tempo.x = tempo.x * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x
            tempo.y = tempo.y * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_y
            tempo.z = tempo.z * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_z
            player:SetLinearVelocity(tempo)
          Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdZ+") and Dont_Do_Another_Dodge == false then -- Backward Dodge
            tempo.x = tempo.x * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_x
            tempo.y = tempo.y * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_y
            tempo.z = tempo.z * pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_power_z
            player:SetLinearVelocity(tempo)
          Dont_Do_Another_Dodge = true
        end
        if not player:GetCommandValue("plcmdZ+") and not player:GetCommandValue("plcmdZ-") and not player:GetCommandValue("plcmdX+") and not player:GetCommandValue("plcmdX-") then
          Dont_Do_Another_Dodge = true
        end
        Wait(Delay(0.01))
          DashAvailable = false
          LerpDashBar(-1, 0.1, 0.3)                    
          LerpModelShaderArg("ascend_to_heaven", mdlDashBar, nil, nil, 0.3, nil, mthVector3f(mdlDashBar:GetPosition().x,1033,0), "EaseOutSine", nil, nil, worldGlobals.tmLastStartDashBarPosition)
          LerpDashBar(0.1, -1, pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_recharge)
          Wait(Delay(pStats[worldGlobals.worldInfo:GetGameDifficulty()].dash_recharge))
          DashAvailable = true
       player:PlaySchemeSound("DashAvailable")
    Can_Dodge = true      
    LerpModelShaderArg("ascend_to_heaven", mdlDashBar, nil, nil, 0.4, nil, mthVector3f(mdlDashBar:GetPosition().x,1100,0), "EaseOutSine", nil, nil, worldGlobals.tmLastStartDashBarPosition)
   
  else
    return
  end
end,

OnEvery(CustomEvent("OnStep")),function()
  if(worldGlobals.CanDodge) == true then
    if IsDeleted(mdlDashBar) then
      mdlDashBar = player:FindHudElementByName("DashBar")
      mdlDashBar:SetVisible(true)
    end
    mdlDashBar:SetVisible(true)
  else  
    if IsDeleted(mdlDashBar) then
      mdlDashBar = player:FindHudElementByName("DashBar")
      mdlDashBar:SetVisible(false)
    end
    mdlDashBar:SetVisible(false)
  end   
  if player:IsAlive() and worldGlobals.CanDodge == true then
    tempo = mthNormalize(player:GetDesiredTempoAbs())
  else
    return
  end  
  local CutSceneController = worldInfo:GetCutSceneController() -- CutSceneController : CCutSceneController
  if player:IsAlive() and player:IsCommandPressed("plcmdAFHDash") and Can_Dodge == true and worldGlobals.CanDodge == true and player:GetCustomSpeedMultiplier() == 1 then
    if CutSceneController:IsCutSceneActive() == true then
      conErrorF("[AFH]: Cut scene is currently active! Can't create Dash Event\n")
      return
    else
    SignalEvent("Do_Dodge_Sam")
  end
  if(Can_Dodge) == false then
    player:PlaySchemeSound("DashNotAvailable")
  end
end
end)

RunAsync(function()

--[[------------------------------------------------------------------
  INTERFACE LOGIC
  The interface "backend" that controls every element that player can see
]]--------------------------------------------------------------------
while not IsDeleted(player) and player:IsAlive() do
    --[[ AMMO & WEAPON (ICONS, AMMO BAR)]]--
    Gun = player:GetRightHandWeapon()
--[[    if(Gun ~= nil) then
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
      if not IsDeleted(Gun) then
        local maxammo = Gun:GetMaxAmmo()
        local maxclip = Gun:GetMaxAmmoInClip()
        local ammo = Gun:GetAmmo()
        local maxammo = Gun:GetMaxAmmo()
        local ShaderBarPlacement = (-1/maxammo/ammo)
        
        for k,v in pairs(Weapons) do
          if Gun:GetParams():GetFileName() == v["param"] then
             local weaponIcon = player:FindHudElementByName("WeaponIcon") -- weaponIcon : CModelHudElement
             if v["mdlIcon"] then
               if IsDeleted(weaponIcon) then
                 weaponIcon = player:FindHudElementByName("WeaponIcon")
                 weaponIcon:SetModel(v["mdlIcon"])
               end
               weaponIcon:SetModel(v["mdlIcon"])  
               weaponIcon:SetVisible(true)
             else
               if IsDeleted(weaponIcon) then
                 weaponIcon = player:FindHudElementByName("WeaponIcon")
                 weaponIcon:SetVisible(false)
               end
               weaponIcon:SetVisible(false)
             end
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
  VEHICLE 
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
  end   --]]
  if player:IsAlive() and player:GetRide() == nil then
  --[[ COMPASS ]] -- (fuckiest shit ever)
    
    
  --[[ HEALTH ]]--
    HealthArmor:SetVisible(true)
    local ShaderHealthBar = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].health/player:GetHealth()))
    local ShaderHealthBarFull = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].health/player:GetMaxHealth()-player:GetHealth()))
    local ShaderArmorBar = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].armor/player:GetArmor()))
    local ShaderArmorBarFull = (-1/(pStats[worldGlobals.worldInfo:GetGameDifficulty()].armor/(player:GetMaxArmor()-player:GetArmor())))    
    if worldInfo:GetGameDifficulty() == "Easy" or worldInfo:GetGameDifficulty() == "Tourist" then
        if player:GetHealth() > 200  then     
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 0)  
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 0)          
        end
      else
        if player:GetHealth() > 100 then
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 0)  
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 0)          
        end
      end
      if worldInfo:GetGameDifficulty() == "Easy" or worldInfo:GetGameDifficulty() == "Tourist" then
        if player:GetHealth() <= 200 then -- [ HEALTH (<= 200) ] 
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 0)
            HealthArmor:SetShaderArgValFloat("IconBlink", 0)            
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)          
          HealthArmor:SetShaderArgValFloat("colorHP", 0)
          HealthArmor:SetShaderArgValFloat("IconBlink", 0)
        end
        if player:GetHealth() <= 100 then -- [ MID HEALTH (<= 100) ] 
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 0)
            HealthArmor:SetShaderArgValFloat("IconBlink", 0)
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 0)
          HealthArmor:SetShaderArgValFloat("IconBlink", 0)         
        end   
        if player:GetHealth() <= 50 then -- [ LOW HEALTH (<= 50) ]
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 1)
            HealthArmor:SetShaderArgValFloat("IconBlink", 2)
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 1)
          HealthArmor:SetShaderArgValFloat("IconBlink", 2)          
        end        
      else
        if player:GetHealth() <= 100 then -- [ HEALTH (<= 100) ] 
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
            HealthArmor:SetShaderArgValFloat("colorHP", 0)
            HealthArmor:SetShaderArgValFloat("IconBlink", 0)
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 0)
          HealthArmor:SetShaderArgValFloat("IconBlink", 0)          
        end  
      end        
      if player:GetHealth() <= 75 then -- [ MID HEALTH (<= 75) ]]
        if IsDeleted(HealthArmor) then
          HealthArmor = player:FindHudElementByName("H_A")
        end
        if HealthArmor:IsVisible() then
          LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
        end
        if IsDeleted(HealthArmor) then
           HealthArmor = player:FindHudElementByName("H_A")  
           HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
           HealthArmor:SetShaderArgValFloat("colorHP", 0.5)
           HealthArmor:SetShaderArgValFloat("IconBlink", 1)
        end
        HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
        HealthArmor:SetShaderArgValFloat("colorHP", 0.5)
        HealthArmor:SetShaderArgValFloat("IconBlink", 1)         
      end             
      if player:GetHealth() <= 35 then -- [ LOW HEALTH (<= 35) ]
        if IsDeleted(HealthArmor) then
          HealthArmor = player:FindHudElementByName("H_A")
        end
        if HealthArmor:IsVisible() then
          LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fHealthBarOffset", nil, "health", "health", worldGlobals.tmLastStartHealthBarOffset)
        end
        if IsDeleted(HealthArmor) then
          HealthArmor = player:FindHudElementByName("H_A")  
          HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
          HealthArmor:SetShaderArgValFloat("colorHP", 1)
          HealthArmor:SetShaderArgValFloat("IconBlink", 2)
        end
        HealthArmor:SetShaderArgValFloat("fPlayerIconHealthOffset", 1+ShaderHealthBar)
        HealthArmor:SetShaderArgValFloat("colorHP", 1)
        HealthArmor:SetShaderArgValFloat("IconBlink", 2)          
      end
    if worldInfo:GetGameDifficulty() == "Tourist" or worldInfo:GetGameDifficulty() == "Easy" then
      if player:GetArmor() <= 300 then 
        if IsDeleted(HealthArmor) then
          HealthArmor = player:FindHudElementByName("H_A")
        end
        if HealthArmor:IsVisible() then
          LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fArmorBarOffset", nil, "armor", "armor", worldGlobals.tmLastStartArmorBarOffset)
        end
        if IsDeleted(HealthArmor) then
          HealthArmor = player:FindHudElementByName("H_A")  
          HealthArmor:SetShaderArgValFloat("fPlayerIconArmorOffset", 1+ShaderArmorBar)
        end
        HealthArmor:SetShaderArgValFloat("fPlayerIconArmorOffset", 1+ShaderArmorBar)          
      end
    else
        if player:GetArmor() >= 0 then        
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")
          end
          if HealthArmor:IsVisible() then
            LerpModelShaderArg("h_stripes", HealthArmor, nil, nil, 0.169, "fArmorBarOffset", nil, "armor", "armor", worldGlobals.tmLastStartArmorBarOffset)
          end
          if IsDeleted(HealthArmor) then
            HealthArmor = player:FindHudElementByName("H_A")  
            HealthArmor:SetShaderArgValFloat("fPlayerIconArmorOffset", 1+ShaderArmorBar)
          end
          HealthArmor:SetShaderArgValFloat("fPlayerIconArmorOffset", 1+ShaderArmorBar)         
        end
      end
  else
    HealthArmor:SetVisible(false)
  end      
  Wait(CustomEvent("OnStep"))
end
end)