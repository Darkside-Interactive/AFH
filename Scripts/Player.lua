SIGSTRM12GIS             � ��                  Signkey.EditorSignature�:�YM�o�/�'Av�V�N�._�=l�^H��x'e��~��8���#��1�^k���b�&��ش\�(Sz���uL�K	ȵ��.���԰3N��t:�)t�8�W^�o@�UwQ&
�����95�+{k�f�p]�in�����nɷe�mz)!O�g���W��YmJ��K�4�sw��Y�\� 05Db�`Q~�p��;+i]T�6�>4��O��M�qt��H��}�'Ƒ~�iG�kU��!����`�﻿local Math = import("Content/Shared/Scripts/Math.lua")

local vampireShared
local strGhostPostProcessingPath = Depfile("Content/SeriousSam4/Presets/Postprocessing/GhostDamage.rsc")
local resElectricityPostProcessing = LoadResource(Depfile("Content/SeriousSam4/Presets/Postprocessing/ElectricityDamage.rsc"))

-- Returns params of weapons in right and left hand
local function GetPlayerWeaponParams(player --[[: CPlayerPuppetEntity]])
  local LeftWeapon = player:GetLeftHandWeapon()
  local RightWeapon = player:GetRightHandWeapon()
  local LeftWeaponParams = nil
  local RightWeaponParams = nil
  if LeftWeapon ~= nil then
    LeftWeaponParams = LeftWeapon:GetParams()
  end
  if RightWeapon ~= nil then
    RightWeaponParams = RightWeapon:GetParams()
  end
  return RightWeaponParams, LeftWeaponParams
end

worldGlobals.CreateRPC("server", "reliable", "StartHUDElectricityNet", function(damagedPlayer)
  -- electricity is only done for the local operator player
  if not damagedPlayer:IsLocalOperator() then
    return
  end

  -- start function that will activate and fade out electricity postprocessing
  if not damagedPlayer.bElectricityPostProcessingInProgress then
    RunAsync(function()
      damagedPlayer.bElectricityPostProcessingInProgress = true
      local fFXDuration = 0.5
      damagedPlayer:AddPostprocessingLayer("ElectricityPPP", resElectricityPostProcessing, 1, 1)
      local tmStart = worldGlobals.worldInfo:SimNow()
      while true do
        local tmNow = worldGlobals.worldInfo:SimNow()
        local fT = timToFloat(tmNow-tmStart)
        local fRatio = 1-fT/fFXDuration
        if fRatio<=0 then
          break
        end
        fRatio = mthPowAF(fRatio,0.7)
        damagedPlayer:SetPostprocessingLayerRatio("ElectricityPPP", fRatio)
        Wait(CustomEvent("OnStep"))
      end
      damagedPlayer:RemovePostprocessingLayer("ElectricityPPP")
      damagedPlayer.bElectricityPostProcessingInProgress = false
    end)
  end
end)

worldGlobals.CreateRPC("server", "reliable", "StartHUDSlimeNet", function(damagedPlayer)
  -- slime is only done for the local operator player
  if not damagedPlayer:IsLocalOperator() then
    return
  end
  local bSlimeExists = damagedPlayer.tmSlimeStart ~= nil
  -- in any case, refresh the slime start time
  damagedPlayer.tmSlimeStart = worldGlobals.worldInfo:SimNow()
  -- if slime is not already applied to this player
  if not bSlimeExists then
    -- start function that will "fade out" the slime effect
    RunAsync(function()
      local fTotalSlimeDuration = 3
      while true do
        local tmNow = worldGlobals.worldInfo:SimNow()        
        local fFromStart = timToFloat(tmNow-damagedPlayer.tmSlimeStart)
        if fFromStart>=fTotalSlimeDuration then
          local pheHudModelElement = damagedPlayer:FindHudElementByName("Slime")
          pheHudModelElement:SetVisible(false)
          -- clear slime start time when done so we know we're not applying the slime any more
          damagedPlayer.tmSlimeStart = nil
          return
        end
        local qvHead = damagedPlayer:GetLookOrigin()
        local qvDelta = Math.QV(0,0,-0.4,0,0,0)
        local fSlimeRatio = mthStepDownF(fFromStart, 0, fTotalSlimeDuration)
        do
          local pheHudModelElement = damagedPlayer:FindHudElementByName("Slime")
          pheHudModelElement:SetVisible(true)
          pheHudModelElement:SetPosOffset(mthVector3f(0, 0, -0.7))
          pheHudModelElement:SetShaderArgValFloat("fSlimeOpacity", mthPowAF(fSlimeRatio,0.5))
          pheHudModelElement = nil
        end
        Wait(CustomEvent("OnStep"))
      end
    end)
  end
end)

worldGlobals.CreateRPC("server", "reliable", "StartHUDVampireProjectileBiteNet", function(damagedPlayer)
  -- slime is only done for the local operator player
  if not damagedPlayer:IsLocalOperator() then
    return
  end

  -- start function that will activate and fade out ghost bite postprocessing
  if not damagedPlayer.bGhostPostProcessingInProgress then
    RunAsync(function()
      damagedPlayer.bGhostPostProcessingInProgress = true
      local fGhostFXDuration = 1.5
      if vampireShared == nil then
        vampireShared = import("Content/SeriousSam4/Scripts/Enemies/VampireShared.lua")
      end
      damagedPlayer:AddPostprocessingLayer("GhostDamage", vampireShared.resGhostPostProcessing, 1, 1)
      local tmStart = worldGlobals.worldInfo:SimNow()
      while true do
        local tmNow = worldGlobals.worldInfo:SimNow()
        local fT = timToFloat(tmNow-tmStart)
        local fRatio = 1-fT/fGhostFXDuration
        if fRatio<=0 then
          break
        end
        fRatio = mthPowAF(fRatio,0.7)
        damagedPlayer:SetPostprocessingLayerRatio("GhostDamage", fRatio)
        Wait(CustomEvent("OnStep"))
      end
      damagedPlayer:RemovePostprocessingLayer("GhostDamage")
      damagedPlayer.bGhostPostProcessingInProgress = false
    end)
  end

  -- fetch projectile
  local pheHudModelElement = damagedPlayer:FindHudElementByName("VampireProjectile")
  if pheHudModelElement == nil then
    return
  end
  -- if is already visible
  if pheHudModelElement:IsVisible() then
    -- skip new ghost
    pheHudModelElement = nil
    return
  end

  local fTotalVampireProjectileDuration = 0.8
  pheHudModelElement:SetPosOffset(mthVector3f(0, 0, 0))
  pheHudModelElement:SetFOV(mthDegToRad(75))
  pheHudModelElement:SetVisible(true)
  local fGhostStretch = 0.1
  pheHudModelElement:SetModelStretch(mthVector3f(fGhostStretch,fGhostStretch,fGhostStretch))
  pheHudModelElement:PlayAnimation("Bite_01", 1, 1, 1)
  --print("PLAYING ANIM")
  damagedPlayer.tmVampireProjectileStart = worldGlobals.worldInfo:SimNow()
  pheHudModelElement = nil

  -- start function that will display ghost bite animation
  RunAsync(function()
    while true do
      local pheProjectileHUDMdl = damagedPlayer:FindHudElementByName("VampireProjectile")
      local tmNow = worldGlobals.worldInfo:SimNow()
      local fFromStart = timToFloat(tmNow-damagedPlayer.tmVampireProjectileStart)
      if fFromStart>=fTotalVampireProjectileDuration then
        pheProjectileHUDMdl:SetVisible(false)
        return
      end
      pheProjectileHUDMdl = nil
      Wait(CustomEvent("OnStep"))
    end
  end)
end)K�qS5��H��'�d�_�r����I�I� "a�y��	Ec+���2�t�VD�t�� yA���,�*9%	��V�98C`��;�����
����3�9�?������e^'|�\H�C[���[�3��� :7��\8�G����C|����,�ا�z#F_8��Pv<X�{T��]�x�v4v�n���s_�d\����Lt���`q�b���C9��czE[���;w����H��鈭J}ͱ�$^�,	\s�