local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local bTurnOnDetectors = false
local bDoorOpened = false
dofile("Content/SeriousSam4/Scripts/VoiceOverHelper.lua")

local function EaseOutSine(fInput)
  return mthSinF((fInput * 3.14159) / 2)
end
local VoiceOver = function(sound, otherParty)
  return worldInfo:VoiceOver(sound, otherParty)
end

local function LerpModel(strShader, fSpeed)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = 1.1
    local fEndOffset = 0.1
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, EaseOutSine(fTimeRatio))
      
      SimpleModel1761:SetShaderArgValFloat(strShader, fOffsetRatio)
      
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpBarFinished")
  end)
end

worldInfo:StopDynamicMusics()
RunAsync(function()
  BackgroundFigtingSounds:Stop()
  --StartCutsceneSimulation(worldInfo, Depfile("Content/GoshaLox2/Levels/II/Cutscenes/L01P01C.wld"))
  CameraBlack:PlayAnimWait("Black")
  if not IsDeleted(player) and player:IsAlive() then
    player:RemoveAllWeapons()
  end
  worldInfo:ForceMusic("Event", CS_01_Intro_TrainCrash)
  Wait(Delay(3))
  BackgroundFigtingSounds:PlayLoopingFadeIn(4)
  BackgroundFigtingSounds:SetVolume(1)
  worldInfo:StartOverlayFade(3,3,0,0,0,0, "OVFF_LOCAL")
  if not IsDeleted(player) and player:IsAlive() then
    player:SetCustomSpeedMultiplier(0)
  end
  Wait(Delay(3))
  CameraBlack:Stop()
  worldInfo:StartOverlayFade(0,0.4,2,0,0,0, "OVFF_LOCAL")
  worldInfo:StartDynamicMusics()
  Wait(Delay(3))
  if not IsDeleted(player) and player:IsAlive() then
    player:SayLocalVoiceover(L01P01S1_01_Sam_What_the_hell_is_this_place)
  end
  worldInfo:ForceMusic("Ambient")
  if not IsDeleted(player) and player:IsAlive() then
    player:SetCustomSpeedMultiplier(0.4)
  end  
  Wait(Delay(12))
  objStartObjective(worldInfo, AONW)
  local Pistol = LoadResource("Content/GoshaLox2/Databases/GenericItems/Weapons/Pistol_Generic.ep")
  if not IsDeleted(player) and player:IsAlive() then
    player:AwardWeapon(Pistol)
    player:SelectWeapon(Pistol)
    prjStartGenericWeaponAnimation(player, Pistol, "Intro", "GWASF_AUTO_SAVE_ON_END|GWASF_INTERRUPTIBLE")
  end
  Wait(Delay(0.7))       
  if not IsDeleted(player) and player:IsAlive() then
    player:SayLocalVoiceover(L01P01S01_02_Sam_At_least_I_didnt)
  end
  local pheHudElm = player:FindHudElementByName("TutorialTips") -- pheHudElm : CTipHudElement
  if IsDeleted(pheHudElm) then
    pheHudElm = player:FindHudElementByName("TutorialTips")  
    pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_Move2=Use  {plcmdZ-} {plcmdX-} {plcmdZ+} {plcmdX+}  to walk\nUse  {plcmdY+}  to jump\n"), 0.65)  
  end
  pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_Move2=Use  {plcmdZ-} {plcmdX-} {plcmdZ+} {plcmdX+}  to walk\nUse  {plcmdY+}  to jump\n"), 0.65)  
  conInfoF("[AFH]: Working with player "..player:GetPlayerName().."\n")
  Wait(Delay(5))
  PlasmaMental:Activate()
  Processed:SpawnSimpleNow()
  Rocketeer:SpawnSimple() 
  Wait(Delay(2))
  if not IsDeleted(player) and player:IsAlive() then
    player:SayLocalVoiceover(L01P01S01_03_Sam_Guys_you_just_in_time)
  end
  Wait(All(Events(Enemies.AllKilled)))
  PlasmaMental:Deactivate()
end)

RunHandled(WaitForever,

On(Event(Shotgun.Picked)),function()
  prjStartGenericWeaponAnimation(player, Shotgun, "Intro", "GWASF_AUTO_SAVE_ON_END|GWASF_INTERRUPTIBLE")
end,

On(Event(DetectorArea016.Activated)),function()
  if not IsDeleted(player) and player:IsAlive() then
    player:SetCustomSpeedMultiplier(1)
  end    
  local pheHudElm = player:FindHudElementByName("TutorialTips") -- pheHudElm : CTipHudElement
  if IsDeleted(pheHudElm) then
    pheHudElm = player:FindHudElementByName("TutorialTips")  
    pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_Move1=Use  {plcmdSprint}  to sprint"), 0.65)  
  end
  pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_Move1=Use  {plcmdSprint}  to sprint"), 0.65)    
  PlasmaMental2:Activate()
  Wait(Delay(2))
  Kamikaze:SpawnSimple()
  GnaarMale:SpawnSimple()
  Wait(All(Events(Enemies2.AllKilled)))
  PlasmaMental2:Deactivate()
  local pheHudElm = player:FindHudElementByName("TutorialTips") -- pheHudElm : CTipHudElement
  if IsDeleted(pheHudElm) then
    pheHudElm = player:FindHudElementByName("TutorialTips")  
    pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_WeaponWheel=Use  {plcmdShowWeaponWheel}  to show Weapon Wheel"), 0.65)  
  end
  pheHudElm:ShowTip(TranslateString("TTRS:Hud.ElementHint.Player_WeaponWheel=Use  {plcmdShowWeaponWheel}  to show Weapon Wheel"), 0.65)          
end)