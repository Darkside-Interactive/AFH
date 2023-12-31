SIGSTRM12GIS             ��׏                  Signkey.EditorSignature4r2'Q�ʑ��9Kg�B�Yȩ�1+��u+�1��yY���ӤM_L%^i�cK��z�S����ϕ4ww���#����Ͱ�w�olWL�cw,�������1FУ�:,���u�TQ?F������ˈ�Z>.�|=�u��^Z	qa�vۘ���1�̒��p<�y~Q��Ql�4A��l��E�}+�!i���E�o���0��.ׅ?�;Y�7(9B�u�Ș͵��@�W��b�ӈ�(��u� &^ʵ:��g�﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity

local strShaderName = "fMoralBarOffset"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local fConstGoodMaxOffset = 1 
local fConstBadMaxOffset = -1
local fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, 0.5)

local fConstGoodMax = 1536
local fConstBadMax = 0
local fConstDefault = fConstGoodMax / 2
local fCurrentMoral = mthLerpF(fConstBadMax, fConstGoodMax, 0.5)
local mdlMoralBar = player:FindHudElementByName("MoralBar") -- mdlMoralBar : CModelHudElement

worldGlobals.bMoralBarActive = false

local aPuppets = { 
  
  Beheaded_Rocketeer = -4, 
  Beheaded_Bomber = -4,
  Beheaded_Firecracker = -4, 
  Beheaded_Kamikaze = -4,
  Drone_Combat = -10,
  Gnaar_Female = -25,
  Gnaar_Male = 20,
  Harpy = -10,
  Khnum = -100,
  Kleer = -8,
  MetalSnake = -120,
  Processed_Brawler = -50,
  Pyro = -75,
  Reptiloid = -25,
  Scrapjack = -35,
  Spider_Big = -16,
  Spider_Small = -1,
  Trooper_Brute = -60,
  Trooper_Commander = -30,
  Trooper_Grenadier = -10,
  Trooper_Laser = -10,
  Vampire = -40,
  Walker_Red = -60,
  Walker_Blue = -40,
  Werebull = -30,
  Russian_Shine_Soldier = 2, 
  American_Shine_Soldier = 2,
  Brazilian_Shine_Soldier = 2,
  Europeian_Shine_Soldier = 2,
  Latina_Shine_Soldier = 2,
  Japanese_Shine_Soldier = 2,
  Chinese_Shine_Soldier = 2,
  Drone_Companion = 10,
}

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
      mdlMoralBar:SetShaderArgValFloat(strRatio, fRatio)
      Wait(CustomEvent("OnStep"))
      
    end
  end)
end

local function LerpMoralBar(fSpeed)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = fCurrentMoralOffset
    local fEndOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, fCurrentMoral/fConstGoodMax)
    fCurrentMoralOffset = fEndOffset
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, fTimeRatio)
      
      mdlMoralBar:SetShaderArgValFloat(strShaderName, fOffsetRatio)
      
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpBarFinished")
  end)
end


local function Moral2Offset(fInput)
  fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, fInput/fConstGoodMax)
  mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)
  return fCurrentMoralOffset
end

local function AddMoral(fInput)
  fCurrentMoral = mthClampF(fCurrentMoral + fInput, fConstBadMax, fConstGoodMax)
  LerpMoralBar(fSpeed)
  FlashBar(fInput)
  
  if fCurrentMoral == fConstGoodMax then
    SignalEvent(worldGlobals.worldInfo, "GoodWins")
    SignalEvent("MoralBarFilled")
  elseif fCurrentMoral == fConstBadMax then
    SignalEvent(worldGlobals.worldInfo, "BadWins")
    SignalEvent("MoralBarFilled")
  end
  
  return fCurrentMoral
end



Wait(CustomEvent("EnableMoralBar"))
worldGlobals.bMoralBarActive = true
SignalEvent("MoralBarCheck")

mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)
mdlMoralBar:SetVisible(true)
mdlMoralBar:SetPosition(mthVector3f(0,320,0))

local aSpawners = NewGroupVar()
local wldSpawners = worldInfo:GetAllEntitiesOfClass("CSpawnerEntity")

for _, v in pairs(wldSpawners) do
  table.insert(aSpawners, v)
end

RunHandled(
  function()
    WaitForever()
  end,

  On(CustomEvent("DisableMoralBar")),function()
    mdlMoralBar:SetVisible(false)
    worldGlobals.bMoralBarActive = false
    for _, v in pairs(wldSpawners) do
      table.remove(v)
    end
  end,      
  OnEvery(CustomEvent("MoralBarCheck")),function()
    if not(fCurrentMoral) == fConstDefault then
      conInfoF("[AFH] 'Content/GoshaLox2/Scripts/GlobalResistanceBar.lua': Value of 'fCurrentMoral' has been changed to constant default value.\n")
      fCurrentMoral = fConstDefault
      Moral2Offset(fCurrentMoral)
    else
      conInfoF("[AFH] 'Content/GoshaLox2/Scripts/GlobalResistanceBar.lua': Value of 'fCurrentMoral' is already in constant default. Nothing to do.\n")
    end
  end,
  
  -- for testing
  OnEvery(CustomEvent("MoralBarFilled")), function()
    Wait(Delay(2))
    SignalEvent("MoralBarReset")
  end,
  
  OnEvery(CustomEvent("MoralBarReset")), function()
    fCurrentMoral = fConstDefault
    LerpMoralBar(0.69)
    Wait(CustomEvent("LerpBarFinished"))

    Moral2Offset(fCurrentMoral)
    worldGlobals.bMoralBarActive = true
  end,

  OnEvery(Any(Events(aSpawners.OneKilled))), function(e)
    local penPuppet = e.any.signaled:GetKilledEntity()
    local bFound = false

    if worldGlobals.bMoralBarActive == true then
      for k, v in pairs(aPuppets) do
        if not bFound and k == penPuppet:GetCharacterClass() then
          bFound = true
          AddMoral(v)
        end
      end
    end
    
  end
)����Kä4���=�w�j����K{_���;ƉG`"S,L	��7i���i;�)��T��=6[�Oqt��kN���R���;�5��$'lZ�*��i{�|`���_�f%B��3�|�?���T�w�^(_rT7��l���̘ �F�ȑ�Ā\�F�8Q7M�ͼh �ҞWL�M;՚�~Np@�֭>=�?$
c����/?�D�Y�*D�ɸDt������U�� ���er��q楞[�+���� 	}RC٩<}