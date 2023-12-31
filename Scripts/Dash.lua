SIGSTRM12GIS             h��~                  Signkey.EditorSignature�g��U�z�+���%
��<������[�����v�J�TjY��*Z��rôE�a/�B^����uJ�t,i*=��M޺�7G�y��;��&tw�J)"�d�db��ƞ����9��Ȓ��g��*���5W��^vX���ؠ��_$D~�Z�$�q�R'�Cq��V�ЩӨ���3:k����0 LM��z�ԥ �g�3���ޕ_��)���q7Ξ��ٰ�����[z(�p�o��OYϵj���#�扢8�������﻿-- Script by I[C]E_the_Bre]a[ker
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

worldGlobals.UnsecureScript = false

local player -- player : CPlayerPuppetEntity  
Wait(CustomEvent("AFH_LocalPlayerFound"))
player = worldGlobals.AFH.penLocalPlayer

local DashAvailable = false
local DashRechargeTime
local mdlDashBar = player:FindHudElementByName("DashBar") -- mdlDashBar : CModelHudElement
local GDF = worldInfo:GetGameDifficulty()  
local HUDEffect = worldInfo:GetEntityByName("DashHudEffect")
local dash = LoadResource("Content/GoshaLox2/Presets/PostProcessing/Dash.rsc") -- dash : CPostProcessingEffectEntity
local fCurrentDashValue = nil
local tempo = nil
local Direction_Back = nil
local Can_Dodge = true
local DashCount = 4

worldGlobals.CanDodge = true

worldGlobals.DashTemplate = LoadResource("Content/GoshaLox/Scripts/Templates/Dash.rsc") -- DashTemplate : CTemplatePropertiesHolder

if player:IsLocalOperator() or not mdlDashBar == nil then
  worldGlobals.UnsecureScript = true
else
  worldGlobals.UnsecureScript = false
end

if(worldGlobals.UnsecureScript) == true then
  conInfoF("[AFH]: CScriptEntity, ('Content/GoshaLox2/Scripts/Dash.lua') successfully initialized.\n")
else
  conErrorF("[AFH]: CScriptEntity, ('Content/GoshaLox2/Scripts/Dash.lua') failed to initialize. Check 'globals.UnsecureScript'\n")
end

local function DashRechargeTimeUpdate()
  if GDF == "Serious" then
    DashRechargeTime = 5
  end
  if GDF == "Hard" then
    DashRechargeTime = 3
  end  
  if GDF == "Normal" then
    DashRechargeTime = 2
  end
  if GDF == "Easy" then
    DashRechargeTime = 2
  end
  if GDF == "Tourist" then
    DashRechargeTime = 0.5
  end
end  
DashRechargeTimeUpdate()

local function FlashBar(fInput)
  RunAsync(function()
    local bIsPositive = false
    local strRatio = "mbLum"
    local tmStart = worldGlobals.worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = 0.69
    
    worldGlobals.tmLastStart = tmStart 

    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStart do
    
      fTimePassed = timToFloat(worldGlobals.worldInfo:SimNow() - tmStart)
      local fRatio = fTimePassed / fTimeTotal
      mdlDashBar:SetShaderArgValFloat(strRatio, fRatio)
      Wait(CustomEvent("OnStep"))
      
    end
  end)
end

local function LerpDashBarToEnd(fSpeed)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = -1
    local fEndOffset = 0.1
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, fTimeRatio)
      
      mdlDashBar:SetShaderArgValFloat("fDashBarOffset", fOffsetRatio)
      
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpBarFinished")
  end)
end

local function LerpDashBarToStart(fSpeed)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = 0.1
    local fEndOffset = -1
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, fTimeRatio)
      
      mdlDashBar:SetShaderArgValFloat("fDashBarOffset", fOffsetRatio)
      
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpBarFinished")
  end)
end

RunHandled(WaitForever,



OnEvery(CustomEvent("Do_Dodge_Sam")),function(Do_Dodge_Sam)
if(DashAvailable) == true and DashCount > 0 and worldGlobals.CanDodge == true and Can_Dodge == true and player:IsAlive() then
    Can_Dodge = false
      player:PlaySchemeSound("DashSound")
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
        mdlDashBar:SetShaderArgValFloat("clDashFull", 0)
        mdlDashBar:SetShaderArgValFloat("clDashRech", 1)
        LerpDashBarToEnd(0.08)
        Wait(Delay(0.08))                  
        mdlDashBar:SetShaderArgValFloat("fDashBarOffset", 0.1)
        Can_Dodge = false
        DashAvailable = false
          Wait(Delay(0.2))
            LerpDashBarToStart(DashRechargeTime)
          Wait(CustomEvent("LerpBarFinished"))
          mdlDashBar:SetShaderArgValFloat("clDashFull", 1)
          mdlDashBar:SetShaderArgValFloat("clDashRech", 0)
          mdlDashBar:SetShaderArgValFloat("fDashBarOffset", -1)
        player:PlaySchemeSound("DashAvailable")
        Can_Dodge = true       
else
  return
end
end,

On(CustomEvent("AFH_DashCheck")),function()
  if(worldGlobals.CanDodge) == true then   
    mdlDashBar:SetVisible(true)
    if(DashAvailable) == true then
      mdlDashBar:SetShaderArgValFloat("fDashBarOffset", -1)
    else
      mdlDashBar:SetShaderArgValFloat("fDashBarOffset", 0.1)
    end
  end
end,

OnEvery(CustomEvent("OnStep")),function()
  if(worldGlobals.CanDodge) == true then
    SignalEvent("AFH_DashCheck")
    DashAvailable = true
  else
    mdlDashBar:SetVisible(false)
  end   
  if player:IsAlive() and worldGlobals.CanDodge == true then
    Direction_Back = mthQuaternionToDirection(player:GetPlacement() :GetQuat())
    Direction_Back = Direction_Back * (-35)
    tempo = mthNormalize(player:GetDesiredTempoAbs())
  else
    return
  end  
  local CutSceneController = worldInfo:GetCutSceneController() -- CutSceneController : CCutSceneController
  if player:IsAlive() and DashCount > 0 and player:IsCommandPressed("plcmdTogglePlayerList") and Can_Dodge == true and worldGlobals.CanDodge == true and player:GetCustomSpeedMultiplier() == 1 then
    if CutSceneController:IsCutSceneActive() then
      conErrorF("[AFH]: Cut scene is currently active! Can't create Dash Event\n")
      return
    else
    SignalEvent("Do_Dodge_Sam")
  end
end
end).�x�N@P�b)*��p�]G��Ә8l���m�^Y�DgT�,yE����z��9Mu�w\��_��0�Ţ��1k1Q2�5rG�lOX�I.�W"��N�ιд��W褒��,x�����!U�k]T�IO:\���x��F@ө��ֱ�{����18�q���Z�-�5��;k#Oa��	�M��Bc�ާZ��J3���P'��b�L�eiJW�W+�	Qر۝a�V�q:���}h�E =��$:Snٜ��