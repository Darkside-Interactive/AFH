
local Math = import("Content/Shared/Scripts/Math.lua")
local pwpWeaponHands = worldGlobals.worldInfo:LoadResource(Depfile("Content/SeriousSam4/Databases/Weapons/HandsWeapon.ep"))
local resSpawnProperties = worldGlobals.worldInfo:LoadResource(Depfile("Content/SeriousSam4/Databases/ItemCratePickupSpawnProperties.rsc"))
local resSirianArtifactPPP = worldGlobals.worldInfo:LoadResource(Depfile("Content/SeriousSam4/Presets/Postprocessing/SirianArtifactBroken.rsc"))
local resSirianArtifactDarkeningPPP = worldGlobals.worldInfo:LoadResource(Depfile("Content/SeriousSam4/Presets/Postprocessing/SirianArtifactBrokenDarkening.rsc"))

local function OrientPlayerTowardsCrate(penPlayer --[[: CPlayerPuppetEntity]], crate --[[: CStaticModelEntity]])
  local fDuration = 0.2
  -- crate handling is only done for the local operator
  if not penPlayer:IsLocalOperator() then
    penPlayer:EnableOperatorMove(false)
    penPlayer:EnableOperatorLook(false)
    penPlayer:MovePuppet(penPlayer:GetPos())
    Wait(Delay(fDuration))
    return
  end

  -- find location for the player
  local qvCrate = crate:GetPlacement()
  local qvFrontUp = mthMulQV(qvCrate, Math.QV(0,0.2,-1,0,0,0))
  local qTowardCrate = mthMulQ4f(qvCrate:GetQuat(), mthEulerToQuaternion(mthVector3f(Math.fPI,0,0)))
  -- ray cast down
  local vRayO = qvFrontUp:GetVect()
  local penHit, vHitPointAbs, vHitNormal = CastRay(worldGlobals.worldInfo, penPlayer, qvFrontUp:GetVect(), mthVector3f(0,-1,0), 2, 0, "use_aim_ray")
  local qvTarget
  if penHit~=nil then
    qvTarget = mthQuatVect(qTowardCrate, vHitPointAbs)
  else
    conErrorF("Point on gorund in front of the crate can't be found!")
    Wait(Delay(fDuration))
    return
  end

  -- remove outline
  penPlayer:EnableOperatorMove(false)
  penPlayer:EnableOperatorLook(false)

  local vStartPos = penPlayer:GetPos()
  local vStartEul = penPlayer:GetCurrentLookDirEul()
  local qvStart = mthQuatVect(mthEulerToQuaternion(vStartEul), vStartPos)
  local qvDelta = mthMulQV(mthInvertQV(qvTarget), qvStart)
  local vTargetPos = qvTarget:GetVect()
  local vLook = penPlayer:GetLookOrigin():GetVect()
  local vCratePos = crate:GetPos()
  local fAngleDeg = (vCratePos.y-vLook.y)/0.5*15
  qvTarget.qp = mthDegToRad(fAngleDeg)
  local fDurationPos = mthClampUpF(mthLenV3f(qvDelta:GetVect())/2, fDuration)
  local vDeltaEul = mthQuaternionToEuler(qvDelta:GetQuat())
  local fMaxAngle = mthMaxF(mthAbsF(vDeltaEul.x), mthAbsF(vDeltaEul.y))
  local fDurationRot = fDurationPos
  local vTargetEul = mthQuaternionToEuler(qvTarget:GetQuat())
  local tmStart = worldGlobals.worldInfo:SimNow()
  while true do
    if IsDeleted(penPlayer) then
      return
    end
    local fT = timToFloat( worldGlobals.worldInfo:SimNow()-tmStart)
    local fRatioPos = mthClampUpF(fT/fDurationPos,1)
    local fRatioRot = mthClampUpF(fT/fDurationRot,1)
    if fT>fDuration then
      penPlayer:MovePuppet(vTargetPos)
      penPlayer:SetLookDir(vTargetEul)
      penPlayer:SetOperatorLookDir(vTargetEul)
      penPlayer:AutoAnimationOff()
      break
    end
    fRatioPos = mthPowAF(Math.easeInOut(fRatioPos),0.5)
    fRatioRot = mthPowAF(Math.easeInOut(fRatioRot),0.5)
    local qvLerpedPos = mthLerpQV(qvStart, qvTarget, fRatioPos)
    local qvLerpedRot = mthLerpQV(qvStart, qvTarget, fRatioRot)
    local vLerpedPos = qvLerpedPos:GetVect()
    local vLerpedEul = mthQuaternionToEuler(qvLerpedRot:GetQuat())
    
    penPlayer:MovePuppet(vLerpedPos)
    penPlayer:SetLookDir(vLerpedEul)
    
    Wait(CustomEvent("OnStep"))
  end
end

-- Returns params of weapons in right and left hand
local function GetPlayerWeaponParams(penPlayer --[[: CPlayerPuppetEntity]])
  local LeftWeapon = penPlayer:GetLeftHandWeapon()
  local RightWeapon = penPlayer:GetRightHandWeapon()
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

local function TakeItemFromCrate(penPlayer --[[: CPlayerPuppetEntity]], crate --[[: CStaticModelEntity]])
  -- lower the weapons on host
  if globals.netIsHost then
    penPlayer:PutDownWeapons()
  end

  OrientPlayerTowardsCrate(penPlayer, crate)
  if IsDeleted(penPlayer) then
    return
  end

  if penPlayer:IsLocalOperator() then
    crate:PlayAnimStay("Open")
  end
  -- wait for crate to open
  Wait(Delay(1.3))
  if IsDeleted(penPlayer) then
    return
  end

  -- re-enable operator move/look and auto animations before starting generic weapon animation
  -- so after generic weapon animation finishes they get restored
  
  penPlayer:EnableOperatorMove(true)
  penPlayer:EnableOperatorLook(true)
  penPlayer:AutoAnimationOn()              
  if globals.netIsHost then
    prjStartGenericWeaponAnimation(penPlayer, pwpWeaponHands, "TakeItem01", "GWASF_STOP_MOVING|GWASF_STOP_LOOKING")
  end
  Wait(CustomEvent(penPlayer, "GenericWeaponAnimationFinished"))
end

local function OnPlayerUsedGadgetCrate(penPlayer --[[: CPlayerPuppetEntity]], itemCrateCompositeEntity --[[: CCompositeEntity]],
    crate --[[: CStaticModelEntity]], resGadget --[[: CGadgetItemParams]], pickupCount, bOpenNetricsa)
  -- remember currently selected weapons on host
  local rightWeaponParams, leftWeaponParams
  if globals.netIsHost then
    rightWeaponParams, leftWeaponParams = GetPlayerWeaponParams(penPlayer)
  end

  TakeItemFromCrate(penPlayer, crate)
  if IsDeleted(penPlayer) then
    return
  end
  
  if penPlayer:IsLocalOperator() and resGadget:IsManuallySelectable() then
    globals.RequestHint(penPlayer, "GadgetSwap", true)
  end

  if globals.netIsHost then
    SignalEvent(itemCrateCompositeEntity, "Used", penPlayer)
    -- give the required number of gadget items
    for i = 1, pickupCount do
      prjGiveItemToPlayer(resGadget, penPlayer)
    end

    Wait(Delay(0.4))

    -- restore weapons
    penPlayer:SelectWeapon(rightWeaponParams)
    penPlayer:SelectWeaponLeft(leftWeaponParams)
  end
end

local function OnPlayerUsedUpgradeCrate(penPlayer --[[: CPlayerPuppetEntity]], itemCrateCompositeEntity --[[: CCompositeEntity]],
    crate --[[: CStaticModelEntity]], resUpgrade)

  if penPlayer:IsWeaponUpgradeInInventory(resUpgrade:GetWeaponUpgradeParams()) then
    if penPlayer:IsLocalOperator() then
      crate:PlayAnimStay("Open_KeepItem")
    end
    return
  end

  TakeItemFromCrate(penPlayer, crate)
  if IsDeleted(penPlayer) then
    return
  end

  if globals.netIsHost then
    SignalEvent(itemCrateCompositeEntity, "Used", penPlayer)
    -- give the weapon upgrade item
    prjGiveItemToPlayer(resUpgrade, penPlayer)
    Wait(CustomEvent(penPlayer, "GenericWeaponAnimationFinished"))
    Wait(Delay(0.4))
  end
end

local function OnPlayerUsedSkillPointCrate(penPlayer --[[: CPlayerPuppetEntity]], itemCrateCompositeEntity --[[: CCompositeEntity]],
    crate --[[: CStaticModelEntity]], resSkillPoint, pwpWeapon)
  -- remember currently selected weapons on host
  local rightWeaponParams, leftWeaponParams
  if globals.netIsHost then
    rightWeaponParams, leftWeaponParams = GetPlayerWeaponParams(penPlayer)
  end

  TakeItemFromCrate(penPlayer, crate)
  if IsDeleted(penPlayer) then
    return
  end

  RunAsync(function()
    Wait(CustomEvent("ArtifactBroken"))
    if IsDeleted(penPlayer) then return end
    local qvLookOrigin = penPlayer:GetLookOrigin()
    local vLookDir = mthQuaternionToDirection(qvLookOrigin:GetQuat())
    qvLookOrigin:SetVect(qvLookOrigin:GetVect()+vLookDir*0.3+mthVector3f(0,-0.1,0))
    local penParticles = resSpawnProperties:SpawnEntityFromTemplateByName("SirianArtifactCrushedVFX", worldGlobals.worldInfo, qvLookOrigin)
    Wait(Delay(0.5))
    if IsDeleted(penPlayer) then return end
    penPlayer:AddPostprocessingLayer("SirianArtifact", resSirianArtifactPPP, 0, 1)
    worldGlobals.worldInfo:StartScreenCrossfade(2.5,2,2,0,0,0)
    local tmStart = worldGlobals.worldInfo:SimNow()
    while timToFloat(worldGlobals.worldInfo:SimNow()-tmStart)<3 do
      local tmNow = worldGlobals.worldInfo:SimNow()
      local fTime = timToFloat(tmNow-tmStart)
      local fRatio = mthStepUpF(fTime, 0.75, 2.5)
      penPlayer:SetPostprocessingLayerRatio("SirianArtifact", fRatio)
      Wait(CustomEvent("OnStep"))
      if IsDeleted(penPlayer) then return end
    end       
    RunAsync(function()
      if IsDeleted(penPlayer) then return end
      penPlayer:RemovePostprocessingLayer("SirianArtifact")
      penPlayer:SelectWeapon(rightWeaponParams)
      penPlayer:SelectWeaponLeft(leftWeaponParams)  
      Wait(Delay(2))
      SignalEvent(worldGlobals.worldInfo, "AcquireSam4Skill")
      end)
  end)

  if globals.netIsHost then
    SignalEvent(itemCrateCompositeEntity, "Used", penPlayer)
    -- give the skill point item
    prjGiveItemToPlayer(resSkillPoint, penPlayer)
    prjStartGenericWeaponAnimation(penPlayer, pwpWeapon, "Use", "GWASF_STOP_MOVING|GWASF_STOP_LOOKING|GWASF_GIVE_NEW_WEAPON")
  end
end

if globals.OnPlayerUsedGadgetCrate_Net == nil then
  globals.CreateRPC("client", "reliable", "OnPlayerUsedGadgetCrate_Net", function(penPlayer, compositeEntityId, bOpenNetricsa)
    if IsDeleted(penPlayer) then
      return
    end
    local itemCrateCompositeEntity --[[: CCompositeEntity]] = globals.worldInfo:GetEntityByID("CCompositeEntity", compositeEntityId)
    assert(itemCrateCompositeEntity, "Could not find composite entity with id " .. compositeEntityId)
    RunAsync(function()
      OnPlayerUsedGadgetCrate(penPlayer, itemCrateCompositeEntity, itemCrateCompositeEntity.crate, itemCrateCompositeEntity.resGadget, itemCrateCompositeEntity.pickupCount, bOpenNetricsa)
    end)
  end)
end

if globals.OnPlayerUsedUpgradeCrate_Net == nil then
  globals.CreateRPC("client", "reliable", "OnPlayerUsedUpgradeCrate_Net", function(penPlayer, compositeEntityId)
    if IsDeleted(penPlayer) then
      return
    end
    local itemCrateCompositeEntity --[[: CCompositeEntity]] = globals.worldInfo:GetEntityByID("CCompositeEntity", compositeEntityId)
    assert(itemCrateCompositeEntity, "Could not find composite entity with id " .. compositeEntityId)
    RunAsync(function()
      OnPlayerUsedUpgradeCrate(penPlayer, itemCrateCompositeEntity, itemCrateCompositeEntity.crate, itemCrateCompositeEntity.resUpgrade)
    end)
  end)
end

if globals.OnPlayerUsedSkillPointCrate_Net == nil then
  globals.CreateRPC("client", "reliable", "OnPlayerUsedSkillPointCrate_Net", function(penPlayer, compositeEntityId)
    if IsDeleted(penPlayer) then
      return
    end
    local itemCrateCompositeEntity --[[: CCompositeEntity]] = globals.worldInfo:GetEntityByID("CCompositeEntity", compositeEntityId)
    assert(itemCrateCompositeEntity, "Could not find composite entity with id " .. compositeEntityId)
    RunAsync(function()
      OnPlayerUsedSkillPointCrate(penPlayer, itemCrateCompositeEntity, itemCrateCompositeEntity.crate,
        itemCrateCompositeEntity.resSkillPoint, itemCrateCompositeEntity.pwpWeapon)
    end)
  end)
end

local ItemCratePickup = {}

-- Handles gadget item crate pickup.
-- crate: crate used for pickup
-- compositeEntity: composite entity being used
-- resGadget: gadget resource awarded to player
-- pickupCount: number of picked gadget items
function ItemCratePickup.HandleGadgetPickup(crate --[[: CStaticModelEntity]], compositeEntity --[[: CCompositeEntity]], resGadget, pickupCount)
  -- registering input params with composite entity so we can use only the composite entity for RPC
  compositeEntity.crate = crate
  compositeEntity.resGadget = resGadget
  compositeEntity.pickupCount = pickupCount
  -- wait for crate to be used
  crate:EnableUsage()
  local e = Wait(Event(crate.Used))
  local penPlayer --[[: CPlayerPuppetEntity]] = e:GetUser()

  local bOpenNetricsa = false
  -- don't open netricsa in cooperative for extra life gadget as it doesn't make any sense to get it
  if penPlayer:IsLocalOperator() and (globals.isSinglePlayer or not resGadget:IsExtraLifeGadget()) then
    bOpenNetricsa = not penPlayer:NetricsaMessageAlreadyReceived(resGadget:GetNetricsaMessageData())
  end

  globals.OnPlayerUsedGadgetCrate_Net(penPlayer, compositeEntity:GetEntityID(), bOpenNetricsa)
end

-- Handles weapon upgrade item crate pickup.
-- crate: crate used for pickup
-- compositeEntity: composite entity being used
-- resUpgrade: weapon upgrade resource awarded to player
function ItemCratePickup.HandleUpgradePickup(crate --[[: CStaticModelEntity]], compositeEntity --[[: CCompositeEntity]], resUpgrade)
  -- registering input params with composite entity so we can use only the composite entity for RPC
  compositeEntity.crate = crate
  compositeEntity.resUpgrade = resUpgrade
  -- wait for crate to be used
  crate:EnableUsage()
  local e = Wait(Event(crate.Used))
  local penPlayer --[[: CPlayerPuppetEntity]] = e:GetUser()
  globals.OnPlayerUsedUpgradeCrate_Net(penPlayer, compositeEntity:GetEntityID())
end

-- Handles skill point item crate pickup.
-- crate: crate used for pickup
-- compositeEntity: composite entity being used
-- resSkillPoint: skill point resource awarded to player
function ItemCratePickup.HandleSkillPointPickup(crate --[[: CStaticModelEntity]], compositeEntity --[[: CCompositeEntity]], resSkillPoint, pwpWeapon)
  -- registering input params with composite entity so we can use only the composite entity for RPC
  compositeEntity.crate = crate
  compositeEntity.resSkillPoint = resSkillPoint
  compositeEntity.pwpWeapon = pwpWeapon
  -- wait for crate to be used
  crate:EnableUsage()
  local e = Wait(Event(crate.Used))
  local penPlayer --[[: CPlayerPuppetEntity]] = e:GetUser()
  globals.OnPlayerUsedSkillPointCrate_Net(penPlayer, compositeEntity:GetEntityID())
end

return ItemCratePickup