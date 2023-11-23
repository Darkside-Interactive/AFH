SIGSTRM12GIS             �z�                  Signkey.EditorSignature�%�j%^"��2��[V�k:�J ۑ�M'����j�ˋ:=��V�@�G=��
��N�� }�f;w��|}����,��W6�%O���ɚ���s��E�"�a��3�!�6ei��D��kU��AC@N��x7����j�������8$�R�O�W�3V�~M��ؘGs�OD���S���,�e�� @��Td֊�ǵ&j��z�P���n�h������)����^6�OA�fe�-9�s3�/��&���{�׸�����ڸ﻿-- Script by I[C]E_the_Bre]a[ker
-- Coop/Multiplayer support by I[C]E_the_Bre]a[ker


-- worldInfo : CWorldInfoEntity
local worldInfo = worldGlobals.worldInfo

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

local DashCount
local GDF = worldInfo:GetGameDifficulty()  
local DashRechargeTime
local UpdateRechargeTime = false
local pizdec
local HUDEffect = worldInfo:GetEntityByName("DashHudEffect")
local fBlinkTimer = 0
local AllowRecharging = false
local dash = LoadResource("Content/GoshaLox/Presets/PostProcessing/Dash.rsc") -- dash : CPostProcessingEffectEntity
local tempo = nil
local Direction_Back = nil
local Can_Dodge = true

worldGlobals.CanDodge = true

worldGlobals.DashTemplate = LoadResource("Content/GoshaLox/Scripts/Templates/Dash.rsc") -- DashTemplate : CTemplatePropertiesHolder

local function DashCountUpdate()
  if GDF == "Serious" then
    DashCount = 3
  end
  if GDF == "Hard" then
    DashCount = 5
  end
  if GDF == "Normal" then
    DashCount = 6
  end
  if GDF == "Easy" then
    DashCount = 8 
  end
  if GDF == "Tourist" then
    DashCount = 12
  end
  if corIsAppEditor() then
    DashCount = 20
  end   
end
local function DashRechargeTimeUpdate()
  if GDF == "Serious" then
    DashRechargeTime = 25
  end
  if GDF == "Hard" then
    DashRechargeTime = 20
  end  
  if GDF == "Normal" then
    DashRechargeTime = 15
  end
  if GDF == "Easy" then
    DashRechargeTime = 10
  end
  if GDF == "Tourist" then
    DashRechargeTime = 5
  end
end  
conInfoF("[AFH]: CScriptEntity, ('Content/GoshaLox/Scripts/Dash.lua') initialized without conditions. Nothing to do.\n")

RunHandled(WaitForever,

OnEvery(Delay(1)),function()
  if(AllowRecharging) == true then
      local DashAvailableCount = player:FindHudElementByName("DashAvailableCount") -- DashAvailableCount : CTextBoxHudElement
        if IsDeleted(DashAvailableCount) then
          DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
          DashAvailableCount:SetPosition(mthVector3f(120, 511, 5))
        end
        DashAvailableCount:SetPosition(mthVector3f(120, 511, 5))          
        local DashText = player:FindHudElementByName("DashText") -- DashText : CTextBoxHudElement
          if IsDeleted(DashText) then
            DashText = player:FindHudElementByName("DashText")
            DashText:SetText(TranslateString("TTRS:DashRecharging=RECHARGING:"),-1,-1)
          end
        DashText:SetText(TranslateString("TTRS:DashRecharging=RECHARGING:"),-1,-1)
          if IsDeleted(DashAvailableCount) then
            DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
            DashRechargeTime = DashRechargeTime-1
            DashAvailableCount:SetText(DashRechargeTime,-1,-1)
          end
        DashRechargeTime = DashRechargeTime-1
        DashAvailableCount:SetText(DashRechargeTime,-1,-1)
        if(DashRechargeTime) == 0 then
          AllowRecharging = false
          UpdateRechargeTime = true
          DashCountUpdate()
          local DashAvailableCount = player:FindHudElementByName("DashAvailableCount") 
            if IsDeleted(DashAvailableCount) then
              DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
              DashAvailableCount:SetText(DashCount,-1,-1)
              DashAvailableCount:SetPosition(mthVector3f(105, 511, 5))
            end
            DashAvailableCount:SetText(DashCount,-1,-1)
            DashAvailableCount:SetPosition(mthVector3f(105, 511, 5))
          local DashText = player:FindHudElementByName("DashText") -- DashText : CTextBoxHudElement
            if IsDeleted(DashText) then
              DashText = player:FindHudElementByName("DashText")
              DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
            end
           DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
           Can_Dodge = true  
          DashRechargeTimeUpdate()
          player:PlaySchemeSound("DashAvailable")
          UpdateRechargeTime = false
        end
 else
   return
 end
end,

OnEvery(CustomEvent("Do_Dodge_Sam")),function(Do_Dodge_Sam)
if(DashCount) > 0 and worldGlobals.CanDodge == true and Can_Dodge == true and player:IsAlive() then
    Can_Dodge = false
      player:PlaySchemeSound("Dash")
      HUDEffect:ShowBackgroundEffects()
      local CoopDashEffect = worldGlobals.DashTemplate:SpawnEntityFromTemplateByName("DashEffect", worldInfo, player:GetPlacement()) -- CoopDashEffect : CParticleEffectEntity
      --CoopDashEffect:SetPlacement(mthQuatVect(CoopDashEffect:GetPlacement():GetQuat(), player:GetPlacement():GetVect()))
      CoopDashEffect:SetParent(player, "")
      if IsDeleted(CoopDashEffect) then
        CoopDashEffect = worldGlobals.DashTemplate:SpawnEntityFromTemplateByName("DashEffect", worldInfo, player:GetPlacement())
        --CoopDashEffect:SetPlacement(mthQuatVect(CoopDashEffect:GetPlacement():GetQuat(), player:GetPlacement():GetVect()))
        CoopDashEffect:SetParent(player, "")
      end
      CoopDashEffect:Start()
      player:AddPostprocessingLayer("Dash", dash, 1, 1)
      local Dont_Do_Another_Dodge = false
        if player:GetCommandValue("plcmdX-") and Dont_Do_Another_Dodge == false then -- Left Dodge
            tempo.x = tempo.x * 30
            tempo.y = tempo.y * 0
            tempo.z = tempo.z * 30
            player:SetLinearVelocity(tempo)
            Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdX+") and Dont_Do_Another_Dodge == false then -- Right Dodge
            tempo.x = tempo.x * 30
            tempo.y = tempo.y * 0
            tempo.z = tempo.z * 30
            player:SetLinearVelocity(tempo)  
          Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdZ-") and Dont_Do_Another_Dodge == false then -- Forward Dodge
            tempo.x = tempo.x * 30
            tempo.y = tempo.y * 0
            tempo.z = tempo.z * 30
            player:SetLinearVelocity(tempo)
          Dont_Do_Another_Dodge = true
        end
        if player:GetCommandValue("plcmdZ+") and Dont_Do_Another_Dodge == false then -- Backward Dodge
            tempo.x = tempo.x * 30
            tempo.y = tempo.y * 0
            tempo.z = tempo.z * 30
            player:SetLinearVelocity(tempo)
          Dont_Do_Another_Dodge = true
        end
        if not player:GetCommandValue("plcmdZ+") and not player:GetCommandValue("plcmdZ-") and not player:GetCommandValue("plcmdX+") and not player:GetCommandValue("plcmdX-") then
              player:SetLinearVelocity(Direction_Back)
              Dont_Do_Another_Dodge = true
        end
        Wait(Delay(0.01))   
        local DashAvailableCount = player:FindHudElementByName("DashAvailableCount") -- DashAvailableCount : CTextBoxHudElement
          if IsDeleted(DashAvailableCount) then
            DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
            DashCount = DashCount-1 
            DashAvailableCount:SetText(DashCount,-1,-1)
          end
          DashCount = DashCount-1 
        DashAvailableCount:SetText(DashCount,-1,-1)
        local DashText = player:FindHudElementByName("DashText")
          if IsDeleted(DashText) then
            DashText = player:FindHudElementByName("DashText")
            DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
          end
        DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)      
        Wait(Delay(0.6))
        player:RemovePostprocessingLayer("Dash")
        if IsDeleted(CoopDashEffect) then
           CoopDashEffect = worldGlobals.DashTemplate:SpawnEntityFromTemplateByName("DashEffect", worldInfo, player:GetPlacement())
           CoopDashEffect:SetParent(player, "")
        end
        CoopDashEffect:DisableEmitting()
    Can_Dodge = true  
else
  return
end
end,

--[[OnEvery(Event(SeriousSpeed.Picked)),function()
  Can_Dodge = false
  local DashText = player:FindHudElementByName("DashText")
    if IsDeleted(DashText) then
      DashText = player:FindHudElementByName("DashText")
      DashText:SetText(TranslateString("TTRS:DashNotAvailable=NOT AVAILABLE"),-1,-1)
    end
    DashText:SetText(TranslateString("TTRS:DashNotAvailable=NOT AVAILABLE"),-1,-1)
  local DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
    if IsDeleted(DashAvailableCount) then
      DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
      DashAvailableCount:Clear()
    end
    DashAvailableCount:Clear()
  Wait(Delay(72))
  Can_Dodge = true
  local DashText = player:FindHudElementByName("DashText")
    if IsDeleted(DashText) then
      DashText = player:FindHudElementByName("DashText")
      DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
    end
    DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)    
  local DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
    if IsDeleted(DashAvailableCount) then
      DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
      DashAvailableCount:SetText(DashCount,-1,-1)
      DashAvailableCount:SetPosition(mthVector3f(105, 618, 5))
    end
    DashAvailableCount:SetText(DashCount,-1,-1)
    DashAvailableCount:SetPosition(mthVector3f(105,618,5))
end,--]]
On(CustomEvent("AFH_DashCheck")),function()
  if(worldGlobals.CanDodge) == true then   
      DashRechargeTimeUpdate()
      DashCountUpdate()
      local DashText = player:FindHudElementByName("DashText")
        if IsDeleted(DashText) then
          DashText = player:FindHudElementByName("DashText")
          DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
        end
      DashText:SetText(TranslateString("TTRS:DashText=DASHES:"),-1,-1)
      AllowRecharging = false
      local DashCount2 = player:FindHudElementByName("DashAvailableCount") -- DashCount2 : CTextBoxHudElement
        if IsDeleted(DashCount2) then
          DashCount2 = player:FindHudElementByName("DashAvailableCount")
          DashCount2:SetText(DashCount,-1,-1)  
          DashCount2:SetPosition(mthVector3f(105, 511, 5))
        end
      DashCount2:SetText(DashCount,-1,-1)    
      DashCount2:SetPosition(mthVector3f(105, 511, 5))
    end
end,

OnEvery(CustomEvent("OnStep")),function()
  if(worldGlobals.CanDodge) == true then
    AllowRecharging = false
    SignalEvent("AFH_DashCheck")
   end
   if(worldGlobals.CanDodge) == false then
     AllowRecharging = false
       local DashText = player:FindHudElementByName("DashText")
         if IsDeleted(DashText) then
          DashText = player:FindHudElementByName("DashText")
          DashText:Clear()      
         end
         DashText:Clear()
         AllowRecharging = false
         local DashCount2 = player:FindHudElementByName("DashAvailableCount") -- DashCount2 : CTextBoxHudElement
         if IsDeleted(DashCount2) then
           DashCount2 = player:FindHudElementByName("DashAvailableCount")
           DashCount2:Clear()
         end
       DashCount2:Clear()
   end 
   if(DashCount) == 0 then
     AllowRecharging = true
       local DashAvailableCount = player:FindHudElementByName("DashAvailableCount") -- DashAvailableCount : CTextBoxHudElement
         if IsDeleted(DashAvailableCount) then
           DashAvailableCount = player:FindHudElementByName("DashAvailableCount")
           DashAvailableCount:SetText(DashRechargeTime,-1,-1)
           DashAvailableCount:SetPosition(mthVector3f(120, 511, 5))
         end
         DashAvailableCount:SetText(DashRechargeTime,-1,-1)
         DashAvailableCount:SetPosition(mthVector3f(120, 511, 5))
         local DashText = player:FindHudElementByName("DashText") -- DashText : CTextBoxHudElement
           if IsDeleted(DashText) then
             DashText = player:FindHudElementByName("DashText")
             DashText:SetText(TranslateString("TTRS:DashRecharging=RECHARGING:"),-1,-1)
           end
         DashText:SetText(TranslateString("TTRS:DashRecharging=RECHARGING:"),-1,-1)          
    end
    if player:IsAlive() and worldGlobals.CanDodge == true then
        Direction_Back = mthQuaternionToDirection(player:GetPlacement() :GetQuat())
        Direction_Back = Direction_Back * (-35)
        tempo = mthNormalize(player:GetDesiredTempoAbs())
    else
      return
    end
    if player:IsAlive() and player:IsCommandPressed("plcmdAFHDashCommand") and Can_Dodge == true and worldGlobals.CanDodge == true then
        SignalEvent("Do_Dodge_Sam")
        if(DashCount) == 0 then
          player:PlaySchemeSound("DashNotAvailable")
        end
  end
end)a��$���k]�F7J��`[tIs���ʀ6�� Ns�c �������$�����rܝ �2_��kd��qX���K�l�a� ��d�K�)iY�0nn�{�D9C>� �	c�����������ab��p�9O �M�9��A����v$O����V�w�'�F����L%EϺ��}fc�s�ާ�oa����}Xa�& �9a����@���z�|���"1�5L�N������#	cv�cg�7@�&�:T˷G�C