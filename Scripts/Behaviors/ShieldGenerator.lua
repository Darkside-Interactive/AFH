SIGSTRM12GIS             Gp#�                  Signkey.EditorSignature���u������:��l�����$S�2�o:<��ٕ��M��je%�?��8�(éSq*���<��=��\&|z{��(�~s8ى����Ls/m��@�;��N�L�3MLx��2G�O7�i���kq�ϓ{�L�=�18O��]�	��gʭ�������O_V�։��=Jj���dk�`���BKT�%��]kʈr�?�3t�s֓��}�_8������?�6�b~��0/д!�W,���r ﻿-- penGenerator : CLeggedPuppetEntity
local Math = import("Content/Shared/Scripts/Math.lua")
local Pi = 3.14159265359
local Template = LoadResource("Content/GoshaLox2/Scripts/Templates/ShieldGeneratorTemplate.rsc") -- Template : CTemplatePropertiesHolder

local penGenerator = worldGlobals.worldInfo:GetEntityByName("ShieldGenerator")
local TargetMarker = worldGlobals.worldInfo:GetEntityByName("ShieldTarget") -- TargetMarker : CPathMarkerEntity

local fMinTimeToReachTarget = 0.2
local fMaxRayEmissionSpeed = 1000
local fBeamMaxLength = 1500

local function ActivateShield(penGenerator, bActivate, strModelName) 
  if IsDeleted(penGenerator) or not penGenerator:IsAlive() then
    return
  end  

  local fVal_1, fVal_2, fVal_3
  if bActivate then 
    if strModelName == "Shield" then penGenerator:PlaySchemeSound("ShieldUp") end
    fVal_1 = 10
    fVal_2 = 0
    fVal_3 = -0.15
  else
    if strModelName == "Shield" then penGenerator:PlaySchemeSound("ShieldDown") end
    fVal_1 = 0
    fVal_2 = 10
    fVal_3 = 0.15
  end
  
  if strModelName == "Shield" then
    if IsDeleted(penGenerator.Shield) or penGenerator.Shield == nil then
      penGenerator.Shield = Template:SpawnEntityFromTemplateByName("Shield",worldGlobals.worldInfo,penGenerator:GetAttachmentAbsolutePlacement("Shield"))
    end
          
    for i=fVal_1,fVal_2,fVal_3 do
      penGenerator.Shield:SetShaderArgValFloat("depth softness", i)
      penGenerator.Shield:SetStretch(1 - i*0.1)
      Wait(CustomEvent("OnStep"))
    end
    if bActivate then penGenerator:SetCurrentHealth(penGenerator:GetMaxHealth()) end
    if not bActivate and not IsDeleted(penGenerator.Field) then penGenerator.Shield:Delete() end
  elseif strModelName == "EnergyField" then
    if IsDeleted(penGenerator.Field) or penGenerator.Field == nil then
      penGenerator.Field = Template:SpawnEntityFromTemplateByName("EnergyField",worldGlobals.worldInfo,penGenerator:GetAttachmentAbsolutePlacement("Shield"))   
    end
      
    for i=fVal_1,fVal_2,fVal_3 do
      penGenerator.Field:SetShaderArgValFloat("depth softness", i)
      penGenerator.Field:SetStretch(1 - i*0.1)
      Wait(CustomEvent("OnStep"))
    end
    if not bActivate and not IsDeleted(penGenerator.Field) then penGenerator.Field:Delete() end  
  end
end

-- Spawns and despawns the laser beam
local function ShootBeam(penGenerator, bActivate, qvBody)
  if IsDeleted(penGenerator) or not penGenerator:IsAlive() then
    return
  end
  
  local BeamCurrentLength = 0
  local vTargetDir = TargetMarker:GetPlacement():GetVect() - qvBody:GetVect()
  local fTargetDist = mthLenV3f(vTargetDir)

  if bActivate then  
    penGenerator.Beam = Template:SpawnEntityFromTemplateByName("BurnerBeam",worldGlobals.worldInfo,qvBody) -- Beam : CStaticModelEntity)
    penGenerator.Beam:SetDir(mthNormalize(vTargetDir))
    
    while not IsDeleted(penGenerator.Beam) and BeamCurrentLength < fTargetDist do
      BeamCurrentLength = mthMinF(fTargetDist, BeamCurrentLength + worldGlobals.worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
      penGenerator.Beam:SetShaderArgValFloat("Length", BeamCurrentLength/fBeamMaxLength * (-0.05))
      Wait(CustomEvent("OnStep"))
    end
  elseif not bActivate then
    BeamCurrentLength = fTargetDist
    
    while not IsDeleted(penGenerator.Beam) and BeamCurrentLength > 0 do
      BeamCurrentLength = mthMaxF(0, BeamCurrentLength - worldGlobals.worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
      penGenerator.Beam:SetShaderArgValFloat("Length", BeamCurrentLength/fBeamMaxLength * (-0.05))
      Wait(CustomEvent("OnStep"))
    end
    if not IsDeleted(penGenerator.Beam) then penGenerator.Beam:Delete() end
  end
  
end

local function ExecuteDeath(penGenerator, qvRoot)
  local penSubstitute = Template:SpawnEntityFromTemplateByName("Substitute",worldGlobals.worldInfo,qvRoot)
  penSubstitute:PlayAnimStay("Death")        
  if not IsDeleted(penGenerator.Shield) then penGenerator.Shield:Delete() end
  if not IsDeleted(penGenerator.Field) then penGenerator.Field:Delete() end
  if not IsDeleted(penGenerator.Beam) then penGenerator.Beam:Delete() end
end

----------------------------------------------------------------------------
--==========================================================================
-- MAIN CODE
--==========================================================================
----------------------------------------------------------------------------

if worldGlobals.netIsHost then
  RunHandled(WaitForever,
    OnEvery(CustomEvent("ShieldGeneratorSpawned")),
    function(ShieldGeneratorSpawned)
      local penGenerator
      penGenerator = ShieldGeneratorSpawned:GetEventThrower()
      print("Generator Spawned")
      
      Wait(Delay(3)) -- Must be same length as the "Appear" animation
      local qvBody = penGenerator:GetAttachmentAbsolutePlacement("Body")
      local qvRoot = penGenerator:GetPlacement()
      
      -- Control of Behavior
      RunHandled(WaitForever,
        On(Event(penGenerator.Died)), function()
          SignalEvent("Shield Generator Destroyed")
          worldGlobals.ExecuteDeath(penGenerator, qvRoot)
        end,
      
        OnEvery(CustomEvent("ShootBeam")), function()
          worldGlobals.ShootBeam(penGenerator, true, qvBody)        
        end,
        OnEvery(CustomEvent("SnakeHealing")), function()
          worldGlobals.ActivateShield(penGenerator, false, "Shield")
          Wait(Delay(0.5))
          worldGlobals.ActivateShield(penGenerator, true, "EnergyField")
          worldGlobals.ShootBeam(penGenerator, true, qvBody)
        end,        
        OnEvery(CustomEvent("SnakeHealed")), function()
          worldGlobals.ActivateShield(penGenerator, false, "EnergyField")
          worldGlobals.ShootBeam(penGenerator, false, qvBody)
          Wait(Delay(0.5))
          worldGlobals.ActivateShield(penGenerator, true, "Shield")
        end
        
      )
    end
  )
end

�.�CtX��@g;�$���Cj1��}���l�2, ��i]f�V=�8\'�r���sV�(} "F�h�q�T=��0����=B��k��$!扭kZ���r{L� Ed݋'�nIWe���uhK<V{%��M��j��L�'����X�Zh�Fd��%6��6k�����D�Z�Ho�|� ��:�.MJ9į��6�/'$D�'��QZH'��}\	�!��x43_�g��~�UӪ(>�ܣ�ǿy5C��2��-'/��