SIGSTRM12GIS             b��l        	   st1792250      Signkey.EditorSignatureIIi�b�-.q�٠6eZD�: ��9R@���7e	���	�,(!�20klkϓo���@g�~m�R��T4Rt�gK�ީE%,0���h@3�j:����`E�qP�h� ��qJ�AP��ݯ�͍؂��u�j��{��b�B4ɿ�0�2E��>"ǧ��ڴKX`��~�8q
!
�L�@ �8z�
�+7��#��鎗��FDU��u��b�-��T�㐸�+�Å���dM R�b���+o﻿----------------------------------------
--Tank vehicle script by NSKuber
--Used for properly animating the Turret, all wheels/treads,
--handling Primary Fire attack and Boost effects/functionality
----------------------------------------

--penTank : CVehicleEntity

local worldInfo = worldGlobals.worldInfo

local QV = function(x,y,z,h,p,b)
  return mthQuatVect(mthHPBToQuaternion(h,p,b),mthVector3f(x,y,z))
end
local Pi = 3.14159265359

local strTankPath = "Content/SeriousSamSM/Databases/Puppets/Vehicles/Tank.ep"
local rscTemplates = LoadResource(Depfile("Content/SeriousSamSM/Models/Vehicles/Tank/Templates.rsc")) --rscTemplates : CTemplatePropertiesHolder

local fPMin = -5/180*Pi
local fPMax = Pi/6
local qRotateDown = mthHPBToQuaternion(0,-Pi/2,0)
local qRotateUp = mthHPBToQuaternion(0,Pi/2,0)

local rscCannonball = LoadResource("Content/SeriousSamSM/Databases/Projectiles/TankShell.ep")

local fTurretHSpeed = 3
local fTurretPSpeed = 0.5
local fTurretStartFollowThreshold = 0.05
local fTurretStopFollowThreshold = 0.01
local fMinVelRatio = 0.15
local fSmoothing = 20

local fTankHeight = 4.5

local fMaxFireShiftAngle = 15/180*Pi
local fReloadingTime = 2.5

local fMaxTurningVelocity = 10
local fTurningMultplier = 40
local fEps = 0.0001
local fTimeToMaxSteering = 0.25

local fBoostCooldown = 3
local fBoostForceMultMax = 50
local fTotalBoostDuration = 0.25
local fAccelerationBoostDuration = 0.15

local fMaxHeathToBoostStomp = 150

local fOnGroundCheckCastDistance = 0.5
local OnGroundRaycastBones = {"L_Thread_01", "L_Thread_07", "R_Thread_01", "R_Thread_07"}
 
local vZero = mthVector3f(0,0,0)

--This function sets the current position of the turred 
--based on the previous one and the desired one
--so it slowly 'rotates' the turret towards its desired direction
local TankAimAtPoint = function(penTank,qDesiredDir,ScriptedBPF)
  
  local invBase = mthQuatVect(mthInvertQ4f(penTank.qDir),vZero)
  local qvDir = mthQuatVect(qDesiredDir,vZero)

  local qvTurn = mthMulQV(invBase,qvDir)
  
  qvTurn.qb = 0
  local fPTemp = mthMaxF(mthMinF(qvTurn.qp,fPMax),fPMin)
  qvTurn.qp = 0
  
  local fHDiff = qvTurn.qh - penTank.fTurretH
  local fPDiff = fPTemp - penTank.fTurretP
 
  if (fHDiff < -Pi) then fHDiff = fHDiff + 2*Pi end
  if (fHDiff > Pi) then fHDiff = fHDiff - 2*Pi end

  penTank.fTurretH = penTank.fTurretH + mthSgnF(fHDiff) * mthMinF(mthAbsF(fHDiff), fTurretHSpeed * (mthLogAF(fSmoothing + 1, fSmoothing * mthAbsF(fHDiff)/Pi + 1) + fMinVelRatio) * worldInfo:SimGetStep())
  if (mthAbsF(penTank.fTurretH) >= 2*Pi) then
    penTank.fTurretH = penTank.fTurretH - mthSgnF(penTank.fTurretH) * 2*Pi
  end
    
  qvTurn.qh = penTank.fTurretH
  ScriptedBPF:SetBonePlacement("Turret",qvTurn)  
    
  penTank.fTurretP = penTank.fTurretP + mthSgnF(fPDiff)*mthMinF(mthAbsF(fPDiff),fTurretPSpeed*worldInfo:SimGetStep())
  qvTurn.qp = penTank.fTurretP
  qvTurn.qh = 0
  ScriptedBPF:SetBonePlacement("Barrel",qvTurn)
  
  local qvMachineGun = penTank.enRider:GetLookOrigin()
  qvMachineGun.qh = qvMachineGun.qh - penTank.fTurretH - penTank.qDir.h
  ScriptedBPF:SetBonePlacement("MachineGun",qvMachineGun)

end


--bonePathFollower : CScriptedBonePathFollower

local fSteering = 0

--Firing effects for the primary fire cannon attack
--Using animation events proved to be inconsistent in Multiplayer for unknown reason,
--so it's been offloaded to the scripting
local function TankFiringEffects(enTank) --enTank : CVehicleEntity
  RunAsync(function()
    enTank.fFiringCooldown = fReloadingTime-- * (0.7 + 0.6 / (1 + worldGlobals.GetEnemyMultiplier()))
    
    --SOUNDS (volumetric for operator, non-volumetric for others)
    RunAsync(function()
      if enTank:GetRiderOnSeat("Default"):IsLocalOperator() then
        enTank:PlaySchemeSound("Fire")
        Wait(Delay(0.5))
        enTank:PlaySchemeSound("Reload")
      else
        enTank:PlaySchemeSound("FireNonVolumetric")
        Wait(Delay(0.5))
        enTank:PlaySchemeSound("ReloadNonVolumetric")      
      end  
    end)
    
    --PARTICLES
    local qvBarrel = enTank:GetAttachmentAbsolutePlacement("BarrelEffects")
    qvBarrel:SetVect(qvBarrel:GetVect() + enTank:GetLinearVelocity() * worldInfo:SimGetStep())
    local penFiringParticle = rscTemplates:SpawnEntityFromTemplateByName("FireEffect",worldInfo,qvBarrel)
    Wait(Delay(2))
    if not IsDeleted(penFiringParticle) then penFiringParticle:Delete() end

  end)
end

worldGlobals.CreateRPC("server","unreliable","TankPrimaryFireEffects",function(enTank)
  if IsDeleted(enTank) or IsDeleted(enTank:GetRiderOnSeat("Default")) then return end
  if not enTank:GetRiderOnSeat("Default"):IsLocalOperator() then
    TankFiringEffects(enTank)
  end
end)

--Tank primary fire function, signaled from the client to the host
worldGlobals.CreateRPC("client","reliable","TankPrimaryFire",function(penTank,vAimedPoint)
  
  if worldInfo:NetIsHost() then    
    penTank:PlayAnim("FirePrimary")
  
    local qvBarrel = penTank:GetAttachmentAbsolutePlacement("Barrel")
    
    local vDir = mthQuaternionToDirection(qvBarrel:GetQuat())
    local vDesiredDir = mthNormalize(vAimedPoint - qvBarrel:GetVect())
    if (mthDotV3f(vDesiredDir,vDir) > mthCosF(fMaxFireShiftAngle)) then
      qvBarrel:SetQuat(mthDirectionToQuaternion(vDesiredDir))
    else
      local vSideDir = mthCrossV3f(mthCrossV3f(vDir,vDesiredDir),vDir)
      qvBarrel:SetQuat(mthDirectionToQuaternion(mthNormalize(vDir+mthSinF(fMaxFireShiftAngle)*vSideDir)))
    end
    
    worldInfo:SpawnProjectile(penTank:GetRiderOnSeat("Default"),rscCannonball,qvBarrel,250,nil)
    
    if not worldInfo:IsSinglePlayer() then
      worldGlobals.TankPrimaryFireEffects(penTank)
    end
  end
  
  if penTank:GetRiderOnSeat("Default"):IsLocalOperator() then
    TankFiringEffects(penTank)
  end
  
end)

worldGlobals.CreateRPC("client","reliable","RDLC_TankDash",function(penTank)
  RunAsync(function()

    if worldInfo:NetIsHost() then
      --Dash visual/sound effects
      penTank:PlayAnim("Dash")
      
      --Dash acceleration (no acceleration when the tank is not on the ground)
      local fTimer = 0
      while not IsDeleted(penTank) and (fTimer < fTotalBoostDuration) do
        fTimer = mthMinF(fTimer + worldInfo:SimGetStep(),fTotalBoostDuration)         

        if (penTank.iWheelsOnGround > 2) then        
        
          if (fTimer < fAccelerationBoostDuration) then
            penTank:PushRel(0,-3,penTank:GetMass() * fBoostForceMultMax * (fTimer/fAccelerationBoostDuration))
          else
            penTank:PushRel(0,-3,penTank:GetMass() * fBoostForceMultMax)
          end
          
        end
        Wait(CustomEvent("OnStep"))
                    
      end    
      
    end
  end)
end)


local strHint = "TTRS:Tutorial.TankControls={plcmdFire} - Cannon\n{plcmdAltFire} - Machine gun\n{plcmdSprint} - Boost"
--strHint = TranslateString(strHint)

--The three front pairs functional wheels are, in fact, invisible (and rotate left/right)
--so the visible wheels are "fake" and as such their rotation during movement is "faked"
--using a scripted bone path follower
local FakeWheels = {"L_Wheel_01_Fake","L_Wheel_02_Fake","L_Wheel_03_Fake",
  "R_Wheel_01_Fake","R_Wheel_02_Fake","R_Wheel_03_Fake",}

local BonesForBPF = {"Turret","Barrel","MachineGun",
                  "L_Wheel_01_Fake","L_Wheel_02_Fake","L_Wheel_03_Fake",
                  "R_Wheel_01_Fake","R_Wheel_02_Fake","R_Wheel_03_Fake",
                  "R_Wheel_08","L_Wheel_08","R_Wheel_00","L_Wheel_00",
                  }

                  
local function SetUpTankData(penTank)
  penTank.qvPlacement = penTank:GetPlacement()
  penTank.vPos = penTank.qvPlacement:GetVect()
  penTank.qDir = penTank.qvPlacement:GetQuat()
  penTank.qvRiderLook = penTank.enRider:GetLookOrigin()
  penTank.vVel = penTank:GetLinearVelocity()
  penTank.vTurret = GetBonePlacementAbs(penTank,"Turret"):GetVect()
  
  if (penTank.fTimeSinceLastOnGroundCheck > 0.2) then
    penTank.fTimeSinceLastOnGroundCheck = 0
    local vDownDir = mthQuaternionToDirection(mthMulQ4f(penTank.qDir,qRotateDown))
    penTank.iWheelsOnGround = 0
    for i=1,4,1 do
      local vCast = GetBonePlacementAbs(penTank,OnGroundRaycastBones[i]):GetVect()
      local entity,_,_ = CastRay(penTank,penTank,vCast,vDownDir,fOnGroundCheckCastDistance,0,"player_bullet")
      if (entity ~= nil) then penTank.iWheelsOnGround = penTank.iWheelsOnGround + 1 end
    end
  end
end
                  

local bAlreadyShownLongTip = false
               
--Function which is called each step of the simulation
function worldGlobals.VehicleSM_Tank_OnStep(behaviour) --behaviour : CVehicleScriptBehavior
  
  --if true then return end
  
  local penTank = behaviour:GetOwner()
  
  if (penTank:GetRiderOnSeat("Default") ~= penTank.enRider) then
    if not IsDeleted(penTank.enRider) and penTank.enRider:IsLocalOperator() then
      penTank.enRider.bIsSprintBlocked = false
      plpSetProfileLong("RDLC_CommandsBlocked", 0)
      penTank.enRider:UnblockCommand("plcmdSprint")
      local CentralTipTextElement = penTank.enRider:FindHudElementByName("CentralTipText") --KeyPipesTextElement : CTextBoxHudElement      
      CentralTipTextElement:SetVisible(false)      
    end
    penTank.enRider = penTank:GetRiderOnSeat("Default")
    if not IsDeleted(penTank.enRider) and penTank.enRider:IsLocalOperator() then   
      local CentralTipTextElement = penTank.enRider:FindHudElementByName("CentralTipText") --KeyPipesTextElement : CTextBoxHudElement      
      CentralTipTextElement:SetVisible(true)
      if bAlreadyShownLongTip then
        CentralTipTextElement:SetText(TranslateString(strHint), 3.5, 0.5) 
      else
        CentralTipTextElement:SetText(TranslateString(strHint), 7, 0.5)
        bAlreadyShownLongTip = true
      end        
      CentralTipTextElement = nil
    end 
    
    penTank.fTimeSinceBoostUsed = 0
    penTank.iTimesBoostUsed = 0
    penTank.fBoostingCooldown = 0
  end
      
  if (penTank.enRider ~= nil) then
     
    local ScriptedBPF = penTank:GetScriptedBonePathFollower() --ScriptedBPF : CScriptedBonePathFollower
    
    SetUpTankData(penTank)
    
    --enRider : CPlayerPuppetEntity
    local vCastDir = mthQuaternionToDirection(penTank.qvRiderLook:GetQuat())
    local vLookOrigin = mthCloneVector3f(penTank.vPos)
    vLookOrigin.y = vLookOrigin.y + fTankHeight + 2 - 1.5 --these numbers come from Tank's bounding box size and camera params
          
    --Calculating look aimed point and desired direction of the turret
    local enHitEntity,vAimedPoint,_ = CastRay(worldInfo,penTank,vLookOrigin,vCastDir,1000,0,"player_bullet")
    --If aimed at a projectile (which happens often when you shoot from the cannon)
    if (enHitEntity ~= nil) and (enHitEntity:GetClassName() == "CGenericProjectileEntity") then
      enHitEntity,vAimedPoint,_ = CastRay(worldInfo,enHitEntity,vAimedPoint,vCastDir,1000,0,"player_bullet")
    end
    if (enHitEntity == nil) then
      vAimedPoint = vLookOrigin + vCastDir*1000
    end
    local vDesiredDir = mthNormalize(vAimedPoint - penTank.vTurret)
    
    --Rotate the turret 
    TankAimAtPoint(penTank,mthDirectionToQuaternion(vDesiredDir),ScriptedBPF)
    
    --Calculating aimed point for the firing
    vCastDir = penTank.enRider:GetLookDir(false)
    enHitEntity,vAimedPoint,_ = CastRay(worldInfo,penTank,vLookOrigin,vCastDir,1000,0,"player_bullet")
    if (enHitEntity ~= nil) and (enHitEntity:GetClassName() == "CGenericProjectileEntity") then
      enHitEntity,vAimedPoint,_ = CastRay(worldInfo,enHitEntity,vAimedPoint,vCastDir,1000,0,"player_bullet")
    end
    if (enHitEntity == nil) then
      vAimedPoint = vLookOrigin + vCastDir*1000
    end
          
    --vDesiredDir = mthNormalize(vAimedPoint - penTank.vTurret)
  
    --Firing primary cannon
    if penTank.enRider:IsLocalOperator() then
      if (penTank.enRider:GetCommandValue("plcmdFire") > 0) and (penTank.fFiringCooldown == 0) then
        worldGlobals.TankPrimaryFire(penTank,vAimedPoint)
      end
    end  
    
    --FAKE WHEELS VISUALS
    local fDriveSpeed = mthDotV3f(penTank.vVel,penTank:GetDir())
          
    penTank.fTreadsShift = mthFracF(penTank.fTreadsShift + fDriveSpeed*worldInfo:SimGetStep() * 0.75)
    if (penTank.fTreadsShift < 0) then penTank.fTreadsShift = penTank.fTreadsShift + 1 end
    penTank:SetShaderArgValFloat("","Treads",penTank.fTreadsShift)
     
    --Cool but pretty performance-intensive: 400 FPS drops to 340
    if (fDriveSpeed ~= 0) then
      
      local qvModelWheel = GetBonePlacementRel(penTank,FakeWheels[1]:sub(1,-6))
      if (mthAbsF(qvModelWheel.qh) > 2) then
        qvModelWheel.qh = Pi * mthSgnF(qvModelWheel.qh)
      else
        qvModelWheel.qh = 0
      end      
      
      for i=1,#FakeWheels,1 do
        ScriptedBPF:SetBonePlacement(FakeWheels[i],qvModelWheel)
      end
      
      ScriptedBPF:SetBonePlacement("R_Wheel_08",qvModelWheel)
      ScriptedBPF:SetBonePlacement("L_Wheel_08",qvModelWheel)         
      ScriptedBPF:SetBonePlacement("R_Wheel_00",qvModelWheel)
      ScriptedBPF:SetBonePlacement("L_Wheel_00",qvModelWheel)      
      
    end
    
    --Boosting
    if penTank.enRider:IsLocalOperator() then
        
      --Show a tip about tank controls again if the player is not using the boost at all    
      penTank.fTimeSinceBoostUsed = penTank.fTimeSinceBoostUsed + worldInfo:SimGetStep()
      if (penTank.fTimeSinceBoostUsed > 15) then
        local hudTip = penTank.enRider:FindHudElementByName("TutorialTips") --hudTip : CTipHudElement
        hudTip:ShowTip(strHint, 1)
        penTank.fTimeSinceBoostUsed = 0
        hudTip = nil
              
        local localPlayer = penTank.enRider
        RunAsync(function()
          Wait(Delay(8))
          if not IsDeleted(localPlayer) then
            local hudTip = localPlayer:FindHudElementByName("TutorialTips") --hudTip : CTipHudElement
            hudTip:SetCurrentPhase(3)              
          end
        end)
      end
      
      --Use boosting only if the tank is on the ground        
      if (penTank.iWheelsOnGround > 2) then
              
        --When the boost is used, nominal velocity changes
        if (penTank:GetCurrentNominalVelocity() > 100) and (penTank.fBoostingCooldown == 0) then
                
          penTank.fBoostingCooldown = fBoostCooldown
          worldGlobals.RDLC_TankDash(penTank)
          penTank.iTimesBoostUsed = penTank.iTimesBoostUsed + 1
          if (penTank.iTimesBoostUsed > 1) then --if the player used the boost >1 times, do not show tips anymore
            penTank.fTimeSinceBoostUsed = -1000000
          else
            penTank.fTimeSinceBoostUsed = 0
          end                 
        end
                
                
        --Block/Unblock boosting depending on the circumstances
        if ((penTank.fBoostingCooldown > 0) or (fDriveSpeed < 0)) and not penTank.enRider.bIsSprintBlocked then
          plpSetProfileLong("RDLC_CommandsBlocked", 1)
          penTank.enRider:BlockCommand("plcmdSprint")
          penTank.enRider.bIsSprintBlocked = true
        elseif (penTank.fBoostingCooldown == 0) and (fDriveSpeed >= 0) and penTank.enRider.bIsSprintBlocked then
          plpSetProfileLong("RDLC_CommandsBlocked", 0)
          penTank.enRider:UnblockCommand("plcmdSprint")
          penTank.enRider.bIsSprintBlocked = false
        end
              
      else
        
        --Block boosting when not on the ground
        if not penTank.enRider.bIsSprintBlocked then
          plpSetProfileLong("RDLC_CommandsBlocked", 1)
          penTank.enRider:BlockCommand("plcmdSprint")
          penTank.enRider.bIsSprintBlocked = true          
        end
            
      end
            
    end
  
  end      
        
  penTank.fFiringCooldown = mthMaxF(penTank.fFiringCooldown - worldInfo:SimGetStep(),0)
  penTank.fBoostingCooldown = mthMaxF(penTank.fBoostingCooldown - worldInfo:SimGetStep(),0)
  penTank.fTimeSinceLastOnGroundCheck = penTank.fTimeSinceLastOnGroundCheck + worldInfo:SimGetStep()

end
     
--Function which is called on Tank start, sets up certain things      
function worldGlobals.VehicleSM_Tank_OnBoot(behaviour)
  --enRider : CPlayerPuppetEntity

  local penTank = behaviour:GetOwner()

  if penTank.bInitialized then return end
  penTank.bInitialized = true
  
  local enRider

  RunAsync(function()
    RunHandled(function()
        penTank:EnableReceiveDamageScriptEvent(true)
        while not IsDeleted(penTank) and penTank:IsAlive() do
          if (enRider ~= nil) and (penTank:GetRiderOnSeat("Default") == nil) then enRider = nil end 
          Wait(CustomEvent("OnStep"))
        end
      end,
      
      OnEvery(Event(penTank.ReceiveDamage)), function(pay)
        if (pay:GetInflictor() ~= nil) then
          if (pay:GetInflictor():GetClassName() ~= "CPlayerPuppetEntity") then
            pay:HandleDamage()
          end
        end
      end,
      
      OnEvery(Event(penTank.NewRider)), function()
        
        enRider = penTank:GetRiderOnSeat("Default")
        --DEBUG
        --penTank:InflictDamage(100000)     
      end
    )
      
    if not IsDeleted(enRider) then
      if enRider:IsLocalOperator() then
        enRider.bIsSprintBlocked = false
        plpSetProfileLong("RDLC_CommandsBlocked", 0)
        enRider:UnblockCommand("plcmdSprint")
      end
    end
    
  end)

  penTank.fFiringCooldown = 0
  penTank.fBoostingCooldown = 0
  penTank.fTreadsShift = 0
  penTank.fTurretH = 0
  penTank.fTurretP = 0
  penTank.fTimeSinceBoostUsed = 0
  penTank.fTimeSinceLastOnGroundCheck = 0
  penTank.iWheelsOnGround = 4
    
  --ScriptedBPF : CScriptedBonePathFollower
  --Rotation of the turret of the tank is implemented via ScriptedBonePathFollower
  local ScriptedBPF = penTank:GetScriptedBonePathFollower()
                  
  for i=1,#BonesForBPF,1 do
    ScriptedBPF:AddBone(BonesForBPF[i])
  end

  ScriptedBPF:SetBoneFlags("Turret",false,false,true)
  ScriptedBPF:SetBoneFlags("Barrel",false,false,true)
  ScriptedBPF:SetBoneFlags("MachineGun",false,false,true)
  for i=1,#FakeWheels,1 do
    ScriptedBPF:SetBoneFlags(FakeWheels[i],false,false,true)
  end
  ScriptedBPF:SetBoneFlags("R_Wheel_08",false,false,true)
  ScriptedBPF:SetBoneFlags("L_Wheel_08",false,false,true)
  ScriptedBPF:SetBoneFlags("R_Wheel_00",false,false,true)
  ScriptedBPF:SetBoneFlags("L_Wheel_00",false,false,true)

end 
,n�/�e���'P���E��&&g�14j@��Ô��]��D&���M�v{�|�gB���P4�1��L���*7|�2��opj,a��d��P�z�a�Πݖ�<w�Ls�֛�g3��S��j�3S,?��1ˆo�1�k��G��5�݊�x�v�F��	}g�6_ӧ���M���r��d%�������657�_�f/p����ן�%
�p��cJ|u��43���[��N��P
����	��� @/+�[`�