SIGSTRM12GIS             <��                  Signkey.EditorSignature.z�V�U:��T�
��G�B�p@vʦ"➏q��\�ťb���މ�~ܡ�����654۞���*��x}����@�ǣ��6�7D���(Ź��[�}��a?�-6n��[847 �w��$��Q�����×N�j_�9x=��y�J����A�j�&��u���D�J�Vߔ{x�P�m[���sSr��:
TRP�D����y�������	��ķe��l1�e@��c�v�aWs7���Q��go�Ul�� ̕p﻿-- maded by ![C]E_the_Bre]a[ker

local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local MoralBarActive = false

local bLightningsEnable = false
local GeneratorsDestroyed = 0

local projectile = worldInfo:LoadResource(Depfile("Content/SeriousSam4/Databases/Projectiles/Projectile_MetalSnake.ep"))
local HP_HealRatio = 0.369
local HealStarted = false
local bSnakeIsBoss = false

local Shield_01_Destroyed = false
local Shield_02_Destroyed = false
local Shield_03_Destroyed = false
local Shield_04_Destroyed = false

Shield_01b_Destroyed:Disappear()
Shield_02b_Destroyed:Disappear()

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
Fire_02_Areas:Start()

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
Wait(Delay(2))
Fire_02_Areas:DisableEmitting()
end,

On(CustomEvent(worldInfo, "GoodWins")),function()
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
  LerpModelStretch(Sphere, 0,01, 1,6, 4)
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
  
  Shields:SetAlignment("Evil")
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
  penMetalSnake:BeInvulnerable(true)
  worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 3, 1)
  
  local qvBody = penMetalSnake:GetAttachmentAbsolutePlacement("Mouth_1")
  local vTargetDir = TargetMarker:GetPlacement():GetVect() - qvBody:GetVect()
  local fTargetDist = mthLenV3f(vTargetDir)
  
  local RayCurrentLength = 0
  local fMaxRayEmissionSpeed = 1000
  local fMinTimeToReachTarget = 0.2
  local fBeamMaxLength = 1000
  
  worldInfo:ForceMusic("Continuous", empty)
  
  Wait(Delay(4))
  LerpModelStretch(Ray, 555, 0,01, 0.5)
  ZoomBlurAnimator:StartAnimation("ShieldOff")
  
  Sound:Stop()  
  
  Wait(Delay(4))
  worldInfo:ForceMusic("Continuous", MetalSnake2)
  Wait(Delay(3.8))
  
  penMetalSnake:SetHealth(24000)
  penMetalSnake:SetAlignment("Evil")
  penMetalSnake:FindFoe()
  worldGlobals.SetSnakeSpeedMultiplier(penMetalSnake, 3, 1)
  worldInfo:RegisterBoss(penMetalSnake, "SNAKE")    
  SignalEvent(worldInfo, "Snake Spawned")

  if not IsDeleted(player) and player:IsAlive() and not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() then
    BossName:SetText(bossName, TranslateString("TTRS:HUDText_BossName_MetalSnake=METAL SNAKE"), true)
    bSnakeIsBoss = true  
  end  
  while not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() do
  if(bSnakeIsBoss) == true then
    if(GeneratorsDestroyed) == 0 and Shield_01_Destroyed == false then
      if not IsDeleted(Shield_01_01) then
        LerpModelStretch(Shield_01_01, 2, 0, 2)
        ShieldSounds(1.5, 0.5)
      else
        return
      end
      if not IsDeleted(Shield_01b) and Shield_01b:IsAlive() then
        Shield_01b:BeInvulnerable(false)
        Shield_01b:EnableReceiveDamageScriptEvent(true)
        Shield_01b:PlayLoopingAnim("Idle_Start") 
        Wait(Delay(3))
        Shield_01b:PlayLoopingAnim("Idle_Loop")
      else
        return
      end
      if not IsDeleted(Ray_01) then
        ZoomBlurAnimator:StartAnimation("ShieldOn")
        LerpModelStretch(Ray_01, 0, 555, 2)
        Shaker_Ray_02:StartShaking()
        Shield_011_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_01:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      else
        return
      end
      if(penMetalSnake:IsAlive() and not IsDeleted(penMetalSnake)) then
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)      
      else
        return
      end
      Wait(CustomEvent("LerpModelFinished"))    
        HealStarted = true
        if(penMetalSnake:GetHealth() < penMetalSnake:GetMaxHealth() and penMetalSnake:IsAlive()) then
          penMetalSnake:ReceiveHealth(penMetalSnake:GetMaxHealth(), true)
        end
        Wait(Delay(8))
        if(Shield_01_Destroyed) == false then
          Shield_01b:PlayLoopingAnim("Idle_Stop")
          Wait(Delay(3))
          Shield_01b:PlayLoopingAnim("Idle")
          Sound:StopLoopingFadeOut(0.5)
          if not IsDeleted(Ray_01) then
            LerpModelStretch(Ray_01, 555, 0, 0.5)
            Shield_011_Particle:DisableEmitting()
            ZoomBlurAnimator:StartAnimation("ShieldOff")
          else
            return
          end
          if not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() then
            penMetalSnake:BeInvulnerable(true)
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
          else
            return
          end
          if not IsDeleted(Shield_01_01) and GeneratorsDestroyed == 0 then           
            LerpModelStretch(Shield_01_01, 0, 2, 2)
            ShieldSounds(2, 0.5)
          else
            return
          end
          if Shield_01b:IsAlive() then
            Shield_01b:BeInvulnerable(true)
            Shield_01b:EnableReceiveDamageScriptEvent(false)
          else
            return
          end
          conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_01b:GetEntityID()..")] finished regeneration event.\n")
          Wait(Delay(20))
        end
    elseif(GeneratorsDestroyed) == 1 and Shield_01_Destroyed == true and Shield_02_Destroyed == false then
      if not IsDeleted(Shield_02_01) then
        LerpModelStretch(Shield_02_01, 2, 0, 2)
        ShieldSounds(1.5, 0.5)
      else
        return
      end
      if not IsDeleted(Shield_04b) and Shield_04b:IsAlive() then
        Shield_04b:BeInvulnerable(false)
        Shield_04b:EnableReceiveDamageScriptEvent(true)
        Shield_04b:PlayLoopingAnim("Idle_Start") 
        Wait(Delay(3))
        Shield_04b:PlayLoopingAnim("Idle_Loop")
      else
        return
      end
      if not IsDeleted(Ray_02) then
        ZoomBlurAnimator:StartAnimation("ShieldOn")
        LerpModelStretch(Ray_02, 0, 555, 2)
        Shaker_Ray_02:StartShaking()
        Shield_021_Particle:Start()
        RayCurrentLength = mthMinF(fTargetDist, RayCurrentLength + worldInfo:SimGetStep() * mthMinF(fMaxRayEmissionSpeed, (fTargetDist/fMinTimeToReachTarget)))
        Ray_02:SetShaderArgValFloat("Length", RayCurrentLength/fBeamMaxLength * (-0.05))
        Sound:PlayLoopingFadeIn(2)
      else
        return
      end
      if not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() then
        penMetalSnake:BeInvulnerable(false)
        penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 1)
      else
        return
      end        
      Wait(CustomEvent("LerpModelFinished"))    
      HealStarted = true
      if(penMetalSnake:GetHealth() < penMetalSnake:GetMaxHealth() and penMetalSnake:IsAlive()) then
        penMetalSnake:ReceiveHealth(penMetalSnake:GetMaxHealth(), true)
      end      
      Wait(Delay(8))  
        if(Shield_02_Destroyed) == false then
          if not IsDeleted(penMetalSnake) and penMetalSnake:IsAlive() then
            penMetalSnake:BeInvulnerable(true)
            penMetalSnake:SetShaderArgValFloat("Mouth", "Glow", 0)
          else
            return
          end
          if not IsDeleted(Shield_04b) and Shield_04b:IsAlive() then
            Shield_04b:PlayLoopingAnim("Idle_Stop")
            Wait(Delay(3))
            Shield_04b:PlayLoopingAnim("Idle")
            Sound:StopLoopingFadeOut(0.5)
          else
            return
          end
          if not IsDeleted(Ray_02) then
            LerpModelStretch(Ray_02, 555, 0, 0.5)
            ZoomBlurAnimator:StartAnimation("ShieldOff")
            Shield_021_Particle:DisableEmitting()
          else
            return
          end
          if not IsDeleted(Shield_02_01) then         
            LerpModelStretch(Shield_02_01, 0, 2, 2)
            ShieldSounds(2, 0.5)
          else
            return
          end
          if not IsDeleted(Shield_04b) and Shield_04b:IsAlive() then
            Shield_04b:BeInvulnerable(true)           
            Shield_04b:EnableReceiveDamageScriptEvent(false)
          else
            return
          end
          conInfoF("[AFH]: [#Entity(CStaticModelEntity,"..Shield_04b:GetEntityID()..")] finished regeneration event. Awakening second shield...\n")
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
          if(Shield_03_Destroyed) == false then
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
          if(Shield_04_Destroyed) == false then
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
    else
      return
    end
  end  
end,

On(Event(MetalSnake.OneKilled)),function()
  if not IsDeleted(player) and player:IsAlive() then
    BossName:ClearAllTexts()
    BossName:SetText(BossNameRemove, TranslateString("TTRS:HUDText_BossName_MetalSnake=METAL SNAKE"), false)
    bSnakeIsBoss = false
  else
    bSnakeIsBoss = false
  end
end,
On(Any(Events(Shields24.OneKilled))),function()
local penMetalSnake = Snake:GetLastSpawned()
  if(GeneratorsDestroyed) == 0 then
    GeneratorsDestroyed = 1
    penMetalSnake:InflictDamage(7000)
    soundHurt:PlayOnce()
    ShakerHurt:StartShaking()
    penMetalSnake:BeInvulnerable(false)
    Shield_01_Destroyed = true
    ParticleExplosion:Start()
    SoundExplosion:PlayOnce()
    Ray_01:Delete()
    Shield_01_01:Delete()
    Shield_011_Particle:Stop()
    Smoke:Start()
    ZoomBlurAnimator:StartAnimation("ShieldOff")
  elseif(GeneratorsDestroyed) == 1 then
    GeneratorsDestroyed = 2
      penMetalSnake:InflictDamage(7000)
      soundHurt:PlayOnce()
      ShakerHurt:StartShaking()
      penMetalSnake:BeInvulnerable(false)
      Shield_02_Destroyed = true
      ParticleExplosion_02:Start()
      SoundExplosion_02:PlayOnce()
      Ray_02:Delete()
      Shield_02_01:Set()
      Shield_021_Particle:Stop()
      Smoke_02:Start()
      ZoomBlurAnimator:StartAnimation("ShieldOff")
      Wait(Delay(0.8))
      Shield_02b_Destroyed:Appear()
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
end)L�4P����,7nk5F)�&lv$Ω�����6z)*-v�(D���K��R8��o�hcl.�hLItb$)��2ț}i{o�f(�@�.;ҾI�l��cL3�P��T�~�&��� 2�T^Cr����_�惭����<#�n�	���D~�_��b�0M�Rw]f��N���;;�Ɇu��r~5y�Y�8iW�'��$[GrWj҄���fŎ��N-�q��q�PA6.PH�{�i9EOs���r�ץ�}_"