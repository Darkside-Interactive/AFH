SIGSTRM12GIS             ��p�                  Signkey.EditorSignature��+��O�Qu���c(t62���H"ΏA)��(.�~��a}�4��=�ㆭa��&e	��*��,h�� QL����tT2���@��
o"5���pw�U&�?|T�G��?@��T���=��C�Q��g�BȚ�?�i�	��=�Z�	����Ԉh�/�Μ� �wSno���[�ɟ���?7����V��tB3�;����_{yB	4)`��t2_}������l3��H�P�1*<o���6��a��Q_S���
�﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity

local strShaderName = "fMoralBarOffset"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local fConstGoodMaxOffset = 1 
local fConstBadMaxOffset = -1
local fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, 0.5)

local fConstGoodMax = 2048
local fConstBadMax = 0
local fConstDefault = fConstGoodMax / 2
local fCurrentMoral = mthLerpF(fConstBadMax, fConstGoodMax, 0.5)
local mdlMoralBar = player:FindHudElementByName("MoralBar") -- mdlMoralBar : CModelHudElement

worldGlobals.bMoralBarActive = false

local aPuppets = { 
  
  Processed_Brawler = 60,
  Processed_Common = 244,
  Reptiloid = 30,
  Walker_Red = 70,
  Gnaar_Female = 30,
  TD_01 = -70,
  TD_02 = -70,
  TD_03 = -40,
  TD_04 = -40,
  PlayerPuppet = -512,
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
  elseif fCurrentMoral == fConstBadMax then
    SignalEvent(worldGlobals.worldInfo, "BadWins")
  end
  
  return fCurrentMoral
end



Wait(CustomEvent("EnableMoralBar_IzhevskAdministration"))
worldGlobals.bMoralBarActive = true
SignalEvent("MoralBarCheck")

mdlMoralBar:SetVisible(true)
mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)
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

  OnEvery(CustomEvent("OnStep")),function()
    if(worldGlobals.bMoralBarActive) == false then
      mdlMoralBar:SetVisible(false)
    else
      mdlMoralBar:SetVisible(true)
    end
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
  
  On(Event(player.Died)),function()
    AddMoral(-512)
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
)
P>i�{i��-]6�i���-Rg��t�^h��Y�PW�p��!!3b��
�����|�[�%>T����Q�E�\f1�V!�i��1�.!�sIn@��IB5�ۿd��P����DD;ML�����4a;v4v3��\�0|���Y�X�ܲ]J��%	a����9sǱc��'Ƽ?u�2V�8Iv��"�b!,��c�b�� ._̨����Z�$J�D�ڙ��@��]�D�>�)%���|�n��:{2�`TY������g