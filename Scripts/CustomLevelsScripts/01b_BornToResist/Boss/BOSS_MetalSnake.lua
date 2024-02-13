SIGSTRM12GIS             ��ˉ                  Signkey.EditorSignature����M�t��$����jd[��<7���8�t�`E���=�DM�(��+���f����:D�C�rg�*�f��m:��v��ޭ��"˧�����Uxֱ^ۈ�rA�C˸�E0����t��mrS���b��ͩdn�h��W �ȫ�rӺ 
��7�Ե=��3$Cb9]�u+t�HC���v��:>-⪢�[5G��@� �����r��S���2�z��E�q�����#��/2?8vwa�����~�l�﻿-- maded by ![C]E_the_Bre]a[ker

local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local MoralBarActive = false

local bLightningsEnable = false
local GeneratorsDestroyed = 0

local IsSnakeUnderground = 0
local GroundLevel = 0
local SnakeShootDelay = 8
local ProjectileCount = 30
local projectile = worldInfo:LoadResource(Depfile("Content/SeriousSam4/Databases/Projectiles/Projectile_MetalSnake.ep"))
local HP_HealRatio = 0.369
local HealStarted = false
local bSnakeIsBoss = false
local penMetalSnake = worldInfo:GetEntityByName("MetalSnake")
local bHealIsStarted = false
local bShieldsDown = false

local function ShieldSounds(fDelay, fTime) 
  SoundShieldsStretched:PlayLoopingFadeIn(fTime) 
  Wait(Delay(fDelay))
  SoundShieldsStretched:StopLoopingFadeOut(fTime)
end

Beams:Disappear()
Sphere:Disappear()
SphereCollision:Disable()
Ray:Disappear()
Shields2:Disappear()

local function EaseOutSine(fInput)
  return mthSinF((fInput * 3.14159) / 2)
end

local function LerpModelStretch(penModel, fStartSize, fEndSize, fSpeed)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = fStartSize 
    local fEndOffset = fEndSize
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, EaseOutSine(fTimeRatio))
      
      penModel:SetStretch(fOffsetRatio)            
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpModelFinished")
    conInfoF("[AFH]: Finished lerping [#Entity(CStaticModelEntity,"..penModel:GetEntityID()..")] stretch\n")
  end)
end

local function CheckShieldsExistence(penName, strType, bInvulnerable, fStartSize, fEndStretch, fLerpTime)
  if(strType) == "check1" then
    if not IsDeleted(penName) then
      LerpModelStretch(penName, fStartSize, fEndStretch, fLerpTime)
    else
      return
    end      
  elseif(strType) == "check2" then
    if not IsDeleted(penName) then
      penName:BeInvulnerable(bInvulnerable)
    else
      return
    end 
  SignalEvent("Check finished")
  else
    conErrorF("[AFH]: Unknown string type in 'CheckShieldsExistence' function defined in line 59\n")
  end
end

RunHandled(WaitForever,


OnEvery(Delay(2.0)),function()
  if bLightningsEnable == true then
    local qvPLC 
      local brandom = mthRndRangeL(1,30)
      for i=1,#lightpaths,1 do
        qvPLC = lightpaths[brandom]:GetPlacement()
      end
  LightningHitEffect:SetPlacement(qvPLC)
  qvPLC.vy = qvPLC.vy + 500
  LightningBoltEffect:SetPlacement(qvPLC)
  LightningHitEffect:Start()
  LightningBoltEffect:Start()
  
  local SoundRandom = mthRndRangeL(1,3)
  local SoundEffect = worldInfo:GetEntityByName("ThunderSound"..SoundRandom.."")
  SoundEffect:PlayOnce()
  SoundEffect:SetPlacement(qvPLC)
  end
end,

On(CustomEvent("EnableMoralBar_IzhevskAdministration")),function()
  MoralBarActive = true
  Processed:SpawnMaintainGroup()
  conInfoF("============================\n")
  conInfoF("[AFH]: Izhevsk Administration Info:\n")
  conInfoF("\n")
  conInfoF("[AFH]: Total Legged Characters:\n")
  conInfoF("\n")
  local aLeggeds = worldInfo:GetAllEntitiesOfClass("CLeggedCharacterEntity")
    for _, v in pairs (aLeggeds) do
      conInfoF("[#Entity(CLeggedCharacterEntity,"..v:GetEntityID()..")]\n")
    end
    conInfoF("[AFH]: Total count:\n")
    local aSpawners = worldInfo:GetAllEntitiesOfClass("CSpawnerEntity")
    conInfoF("\n")
    for _, v in pairs (aLeggeds) do
      conInfoF("  [#Entity(CSpawnerEntity,"..v:GetEntityID()..")]\n")
    end
    for _, v in pairs (aSpawners) do
      conInfoF("[#Entity(CSpawnerEntity,"..v:GetEntityID().." : "..v:GetTotalCount()..")]\n")
    end
   conInfoF("\n")
   conInfoF("[AFH]: Bosses:\n")
    if(worldInfo:GetBoss()) == nil then
      conInfoF("[AFH]: No bosses detected.\n")
    else
      local Boss = worldInfo:GetBoss()
        conInfoF("[AFH]: Detected boss:\n")
        conInfoF("\n")
        conInfoF("[AFH]: Boss name: "..Boss:GetName().."\n")  
        conInfoF("[AFH]: Boss health: "..Boss:GetHealth().."\n")
        conInfoF("[AFH]: Boss health increased: "..bBossHealthIncreased.."\n")
      Wait(Delay(0.01))
   end
conInfoF("[AFH]: Finished determening enemies count. Shutting down.\n")
conInfoF("============================\n")
Wait(Delay(35))
RainAnimator:StartAnimation("TurningOn")
worldInfo:SetMusic("Ambient", resRainyAmbient)
Rainstorm_Izhevsk:Start() 
end,

On(CustomEvent("OnStep")),function()
  Processed:StopSpawningAndDespawn()
  Wait(Delay(1.2))
  SignalEvent("DisableMoralBar")
  worldInfo:StopForcedMusic()
  Wait(Delay(6))
  
  bLightningsEnable = true
  
  Wait(Delay(2))
  Sphere:Appear()
  Sphere:SetStretch(0.01)
  player:PlaySound(Octanian_ShieldActivate,1,1,0)
  LerpModelStretch(Sphere, 0,01, 1, 4)
  SoundSphere:PlayLooping()
  Wait(CustomEvent("LerpModelFinished"))
  SphereCollision:Enable()
  
  Wait(Delay(1.5))
  
  Beam_01:Appear()  
  LerpModelStretch(Beam_01, 0, 3, 1)
  
  SoundAppear:PlayOnce()
  Wait(Delay(SoundAppear:GetSound():GetLength()))
  SoundLooping:PlayLooping()
  
  Wait(Delay(3))
  
  Beam_02:Appear()
  LerpModelStretch(Beam_02, 0, 3, 1)
  
  SoundAppear2:PlayOnce()
  Wait(Delay(SoundAppear2:GetSound():GetLength()))
  SoundLooping2:PlayLooping()  
  
  Wait(Delay(3))
  
  Beam_03:Appear()
  Beam_03:SetStretch(0.01) 
  
  LerpModelStretch(Beam_03, 0, 3, 1)
  
  SoundAppear3:PlayOnce()
  Wait(Delay(SoundAppear3:GetSound():GetLength()))
  SoundLooping3:PlayLooping()    
  
  Wait(Delay(3))
  
  Beam_04:Appear()
  
  LerpModelStretch(Beam_04, 0, 3, 1)
  
  SoundAppear4:PlayOnce()
  Wait(Delay(SoundAppear4:GetSound():GetLength()))
  SoundLooping4:PlayLooping()      
  
  Wait(Delay(5))
  local Shield_01b = Shield_001:SpawnOne() -- Shield_01b : CLeggedCharacterEntity
  Wait(Delay(3))
  local Shield_02b = Shield_002:SpawnOne() -- Shield_02b : CLeggedCharacterEntity  
  Wait(Delay(3))
  local Shield_03b = Shield_003:SpawnOne() -- Shield_03b : CLeggedCharacterEntity 
  Wait(Delay(3))
  local Shield_04b = Shield_004:SpawnOne() -- Shield_04b : CLeggedCharacterEntity

  Shield_01b:EnableReceiveDamageScriptEvent(false)
  Shield_02b:EnableReceiveDamageScriptEvent(false)  
  Shield_03b:EnableReceiveDamageScriptEvent(false)
  Shield_04b:EnableReceiveDamageScriptEvent(false)
  
  local Shields = Shield_01b, Shield_02b, Shield_03b, Shield_04b -- Shields : CLeggedCharacterEntity
  
  Shields:SetAlignment("Good")
  Wait(Delay(6)) 
  
  LerpModelStretch(Beam_01, 3, 0, 1)
  LerpModelStretch(Beam_02, 3, 0, 1)
  LerpModelStretch(Beam_03, 3, 0, 1)
  LerpModelStretch(Beam_04, 3, 0, 1)
  
  Wait(CustomEvent("LerpModelFinished"))

  Shields2:Appear()
  Shields:BeInvulnerable(true)  
      
  Ray:Appear()
  Shaker_Ray_01:StartShaking()
  ZoomBlurAnimator:StartAnimation("ShieldOn")
  
  
  Sound:PlayLooping()
  
  Wait(Delay(3))
  
  ParticleSmoke:Start()
  
  Wait(Delay(4))
  
  local penMetalSnake = Snake:SpawnOne() -- penMetalSnake : CLeggedCharacterEntity
  local qvBody = penMetalSnake:GetAttachmentAbsolutePlacement("Mouth_1")
  local vTargetDir = TargetMarker:GetPlacement():GetVect() - qvBody:GetVect()
  local fTargetDist = mthLenV3f(vTargetDir)
  
  local RayCurrentLength = 0
  local fMaxRayEmissionSpeed = 1000
  local fMinTimeToReachTarget = 0.2
  local fBeamMaxLength = 1000
  
  local Shield_01_Destroyed = false
  local Shield_02_Destroyed = false
  local Shield_03_Destroyed = false
  local Shield_04_Destroyed = false
  
  penMetalSnake:SetHealth(32000)
  penMetalSnake:SetAlignment("Evil")
  penMetalSnake:FindFoe()
  worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 3, 1)
  worldInfo:RegisterBoss(penMetalSnake, "SNAKE")
  penMetalSnake:BeInvulnerable(true)
  bSnakeIsBoss = true

  Wait(Delay(4))
  LerpModelStretch(Ray, 555, 0,01, 0.5)
  ZoomBlurAnimator:StartAnimation("ShieldOff")
  
  Sound:Stop()  
  
  while not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() do
    if(GeneratorsDestroyed) == 0 then
      LerpModelStretch(Shield_01_01, 2, 0, 2)
      ShieldSounds(1.5, 0.5)
      Shield_01b:BeInvulnerable(false)
      Shield_01b:EnableReceiveDamageScriptEvent(true)
      Shield_01b:PlayLoopingAnim("Idle_Start") 
      Wait(Delay(3))
      Shield_01b:PlayLoopingAnim("Idle_Loop")
      ZoomBlurAnimator:StartAnimation("ShieldOn")
      LerpModelStretch(Ray_01, 0, 555, 2)
      Shaker_Ray_02:StartShaking()
      Shield_011_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_01:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      Wait(CustomEvent("LerpModelFinished"))    
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)
          HealStarted = true
          Wait(Delay(8))
          if(Shield_01_Destroyed) == false then
            penMetalSnake:BeInvulnerable(true)
            Shield_01b:PlayLoopingAnim("Idle_Stop")
            Wait(Delay(3))
            Shield_01b:PlayLoopingAnim("Idle")
            Sound:StopLoopingFadeOut(0.5)
            LerpModelStretch(Ray_01, 555, 0, 0.5)
            ZoomBlurAnimator:StartAnimation("ShieldOff")
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
            Shield_011_Particle:DisableEmitting()
            LerpModelStretch(Shield_01_01, 0, 2, 2)
          ShieldSounds(2, 0.5)
         Shield_01b:BeInvulnerable(true)
         Shield_01b:EnableReceiveDamageScriptEvent(false)
        conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_01b:GetEntityID()..")] finished regeneration event. Awakening second shield...\n")
        Wait(Delay(20))
        else
           return
        end
    elseif(GeneratorsDestroyed) == 1 then
      LerpModelStretch(Shield_02_01, 2, 0, 2)
      ShieldSounds(1.5, 0.5)
      Shield_02b:BeInvulnerable(false)
      Shield_02b:EnableReceiveDamageScriptEvent(true)
      Shield_02b:PlayLoopingAnim("Idle_Start") 
      Wait(Delay(3))
      Shield_02b:PlayLoopingAnim("Idle_Loop")
      ZoomBlurAnimator:StartAnimation("ShieldOn")
      LerpModelStretch(Ray_02, 0, 555, 2)
      Shaker_Ray_02:StartShaking()
      Shield_021_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_02:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      Wait(CustomEvent("LerpModelFinished"))    
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)
          HealStarted = true
          Wait(Delay(8))
          if(Shield_01_Destroyed) == false then
            penMetalSnake:BeInvulnerable(true)
            Shield_02b:PlayLoopingAnim("Idle_Stop")
            Wait(Delay(3))
            Shield_02b:PlayLoopingAnim("Idle")
            Sound:StopLoopingFadeOut(0.5)
            LerpModelStretch(Ray_02, 555, 0, 0.5)
            ZoomBlurAnimator:StartAnimation("ShieldOff")
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
            Shield_021_Particle:DisableEmitting()
            LerpModelStretch(Shield_02_01, 0, 2, 2)
          ShieldSounds(2, 0.5)
         Shield_02b:BeInvulnerable(true)
         Shield_02b:EnableReceiveDamageScriptEvent(false)
        conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_02b:GetEntityID()..")] finished regeneration event. Awakening second shield...\n")
        Wait(Delay(20))                                                                                 
        else
          return
        end
    elseif(GeneratorsDestroyed) == 2 then
      LerpModelStretch(Shield_03_01, 2, 0, 2)
      ShieldSounds(1.5, 0.5)
      Shield_03b:BeInvulnerable(false)
      Shield_03b:EnableReceiveDamageScriptEvent(false)
      Shield_03b:PlayLoopingAnim("Idle_Start") 
      Wait(Delay(3))
      Shield_03b:PlayLoopingAnim("Idle_Loop")
      ZoomBlurAnimator:StartAnimation("ShieldOn")
      LerpModelStretch(Ray_03, 0, 555, 2)
      Shaker_Ray_02:StartShaking()
      Shield_031_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_03:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      Wait(CustomEvent("LerpModelFinished"))    
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)
          HealStarted = true
          Wait(Delay(8))
          if(Shield_01_Destroyed) == false then
            penMetalSnake:BeInvulnerable(true)
            Shield_03b:PlayLoopingAnim("Idle_Stop")
            Wait(Delay(3))
            Shield_03b:PlayLoopingAnim("Idle")
            Sound:StopLoopingFadeOut(0.5)
            LerpModelStretch(Ray_03, 555, 0, 0.5)
            ZoomBlurAnimator:StartAnimation("ShieldOff")
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
            Shield_031_Particle:DisableEmitting()
            LerpModelStretch(Shield_03_01, 0, 2, 2)
          ShieldSounds(2, 0.5)
         Shield_03b:BeInvulnerable(true)
         Shield_03b:EnableReceiveDamageScriptEvent(false)
        conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_03b:GetEntityID()..")] finished regeneration event. Awakening second shield...\n")
        Wait(Delay(20))                                                                                 
        else
          return
        end      
    elseif(GeneratorsDestroyed) == 3 then
      LerpModelStretch(Shield_04_01, 2, 0, 2)
      ShieldSounds(1.5, 0.5)
      Shield_04b:BeInvulnerable(false)
      Shield_04b:EnableReceiveDamageScriptEvent(true)
      Shield_04b:PlayLoopingAnim("Idle_Start") 
      Wait(Delay(3))
      Shield_04b:PlayLoopingAnim("Idle_Loop")
      ZoomBlurAnimator:StartAnimation("ShieldOn")
      LerpModelStretch(Ray_04, 0, 555, 2)
      Shaker_Ray_02:StartShaking()
      Shield_041_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_04:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      Wait(CustomEvent("LerpModelFinished"))    
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)
          HealStarted = true
          Wait(Delay(8))
          if(Shield_01_Destroyed) == false then
            penMetalSnake:BeInvulnerable(true)
            Shield_04b:PlayLoopingAnim("Idle_Stop")
            Wait(Delay(3))
            Shield_04b:PlayLoopingAnim("Idle")
            Sound:StopLoopingFadeOut(0.5)
            LerpModelStretch(Ray_04, 555, 0, 0.5)
            ZoomBlurAnimator:StartAnimation("ShieldOff")
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
            Shield_041_Particle:DisableEmitting()
            LerpModelStretch(Shield_04_01, 0, 2, 2)
          ShieldSounds(2, 0.5)
         Shield_04b:BeInvulnerable(true)
         Shield_04b:EnableReceiveDamageScriptEvent(false)
        conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_04b:GetEntityID()..")] finished regeneration event. Awakening second shield...\n")
        Wait(Delay(20))                                                                                 
        else
          return
        end        
    end
  end  
  Wait(Delay(15))
  SignalEvent(worldInfo, "SnakeStartShooting")
end,


On(Any(Events(Shields24.OneKilled))),function()
  if(GeneratorsDestroyed) == 0 then
    GeneratorsDestroyed = GeneratorsDestroyed + 1
    if(HealStarted) == true then
      penMetalSnake:InflictDamage(penMetalSnake:GetHealth()-7000)
      penMetalSnake:PlaySound(Hurt, 1,1,0.01)
      penMetalSnake:BeInvulnerable(false)
      Shield_01_Destroyed = true
    end
  elseif(GeneratorsDestroyed) == 1 then
    GeneratorsDestroyed = GeneratorsDestroyed + 1
    if(HealStarted) == true then
      penMetalSnake:InflictDamage(7000)
      penMetalSnake:PlaySound(Hurt, 1,1,0.01)
      penMetalSnake:BeInvulnerable(false)
    end
  elseif(GeneratorsDestroyed) == 2 then
    GeneratorsDestroyed = GeneratorsDestroyed + 1
    if(HealStarted) == true then
      penMetalSnake:InflictDamage(7000)
      penMetalSnake:PlaySound(Hurt, 1,1,0.01)    
      penMetalSnake:BeInvulnerable(false)
    end
  elseif(GeneratorsDestroyed) == 3 then
    GeneratorsDestroyed = GeneratorsDestroyed + 1
    if(HealStarted) == true then
      penMetalSnake:InflictDamage(7000)
      penMetalSnake:PlaySound(Hurt, 1,1,0.01)
      penMetalSnake:BeInvulnerable(false)
    end
  elseif(GeneratorsDestroyed) == 4 then
    GeneratorsDestroyed = GeneratorsDestroyed + 1
    if(HealStarted) == true then
      penMetalSnake:InflictDamage(11000)
      penMetalSnake:PlaySound(Death, 1,1,0.01)
      penMetalSnake:BeInvulnerable(false)
      SignalEvent("Snake died")
    end
  end
end,      


On(Event(Shield_01.OneKilled)),function()
  Shield_01_01:Delete()
  Ray_01:Delete()
end,

On(Event(Shield_02.OneKilled)),function()
  Shield_02_01:Delete()
  Ray_02:Delete()
end,

On(Event(Shield_03.OneKilled)),function()
  Shield_03_01:Delete()
  Ray_03:Delete()
end,

On(Event(Shield_04.OneKilled)),function()
  Shield_04_01:Delete()
  Ray_04:Delete()
end,
    -- snake ai destruction events
    -- this is relative to moment when snake reaches building wall
    
    On(Event(DetectorSnake.Activated)),function()
      Shaker_SideWall_01:StartShaking()
      Dust_SideWall_01:Start()
      Sound_SideWall_01:PlayOnce()
      worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 1, 1)
      Wait(Delay(4))
      worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 3, 1)
    end,
    
    On(CustomEvent(penMetalSnake, "_ai_Destruction_Earth")),function()
      worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 1, 1)
      Shaker_Earth_01:StartShaking()
      Explosion_SideWall_01:Start()
      Wait(Delay(0.2))
      Dust_SideWall_011:Start()
      Sound_Dust_01:PlayOnce()
      Wait(Delay(3.8))
      worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 3, 1)
    end,
      
    On(CustomEvent(worldInfo, "SnakeStartShooting")),function()
      local count = 1
      while true do
        if IsDeleted(penMetalSnake) or penMetalSnake == nil or penMetalSnake:GetHealth() < 30 then        
          break
        end
        
        for i=1, 30 do
          if IsDeleted(penMetalSnake) or penMetalSnake == nil or penMetalSnake:GetHealth() < 30 then
            break
          end
          if mthXZLenV3f(penMetalSnake:GetPos()-penMarkerCenter:GetPos()) < 120 then
            local qvMouth = penMetalSnake:GetAttachmentAbsolutePlacement("Mouth_1")
            worldInfo:SpawnProjectile(penMetalSnake, projectile, qvMouth,  30, player)
            qvMouth = penMetalSnake:GetAttachmentAbsolutePlacement("Mouth_2")
            worldInfo:SpawnProjectile(penMetalSnake, projectile, qvMouth, 30, player)  
            qvMouth = penMetalSnake:GetAttachmentAbsolutePlacement("Mouth_3")
            worldInfo:SpawnProjectile(penMetalSnake, projectile, qvMouth, 30, player)                         
            Wait(Delay(0.1))
          else
            Wait(Delay(2))
          end
        end
        Wait(Delay(5))
      end
end){�8����B'�L�4��� �f�F�p��A�dwqJώby]~�/���^�E�fy���ONɍm\U�/C��!�|RO�l��� g6���2`�Y����U�[+ՠ��o~����D�����#nIm��� ����?���x��_�e;�$ra�h�)�u�{G
/�(@B���������gRh�?7$q�:$.�%[�e�x���%��q�{��b���j��v@M`s��P�$+@8_�61�a�J�ä	