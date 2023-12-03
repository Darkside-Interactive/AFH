SIGSTRM12GIS             A�g�                  Signkey.EditorSignatureB��b�lJgl��R���{�*��":d�=����9����s}$q.��n�pkx;jq��b� _ዔ��`T\�N����>s��SG�3#M�q��.������/�{#�c}�S��'N]�Z�˾"��#� hq��x0�
z�ݎ��5/������(���@�"-����v��K�ͅ]�RO�A��雹zUQ]�u4�mBXx���q�"��f�	.�w�s��/s��@�)�F��Ii���r�	�0﻿-- penPuppet : CPuppetEntity
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

-- IMPORTANT MESSAGE
-- if you adding new enemies to this enumerator please remember this thing:
-- if value is negative then it's bad guys that decreases bar to red color
-- if value is positive then it's good guys that increases bar to blue color

local aPuppets = { 
  
  Beheaded_Rocketeer = -4, 
  Beheaded_Bomber = -4,
  Beheaded_Firecracker = -4, 
  Beheaded_Kamikaze = -4,
  Drone_Combat = -10,
  Gnaar_Female = -25,
  Gnaar_Male = -20,
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

-- convert moral value to mask offset U range from -1 to 1
local function Moral2Offset(fInput)
  fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, fInput/fConstGoodMax)
  mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)
  return fCurrentMoralOffset
end

-- change current moral value, use negative input to subtract
local function AddMoral(fInput)
  fCurrentMoral = mthClampF(fCurrentMoral + fInput, fConstBadMax, fConstGoodMax)
  Moral2Offset(fCurrentMoral)
  
  if fCurrentMoral == fConstGoodMax then
    SignalEvent(worldGlobals.worldInfo, "GoodWins")
    SignalEvent("MoralBarFilled")
  elseif fCurrentMoral == fConstBadMax then
    SignalEvent(worldGlobals.worldInfo, "BadWins")
    SignalEvent("MoralBarFilled")
  end
  
  return fCurrentMoral
end


-------------------
-- MAIN FUNCTION --
-------------------

--Wait(Event(worldInfo.PlayerBorn))

Wait(CustomEvent("EnableMoralBar"))
worldGlobals.bMoralBarActive = true


-- initialize bar
mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)
mdlMoralBar:SetVisible(true)
mdlMoralBar:SetPosition(mthVector3f(0,320,0))

-- get all spawners in wld and put them in group var
local aSpawners = NewGroupVar()
local wldSpawners = worldInfo:GetAllEntitiesOfClass("CSpawnerEntity")

for _, v in pairs(wldSpawners) do
  table.insert(aSpawners, v)
end

-- main loop to catch killed puppets from spawners
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
    Moral2Offset(fCurrentMoral)
    worldGlobals.bMoralBarActive = true
    --worldGlobals.worldInfo:ShowMessageToAll("BAR RESET\nNew round, fight!")
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
)&%�l�ic��;�2 s��g��(+k1%-V���[��%���`:)u���0p���7 ��4��X�e�L�+���=Ux^.�����3�@������TW��������#�Z�t�.%e�|�<h;]Q��(3��+�ڟޒ�ˮR���� �9�2��剄���tῦ��h?{} z%�w�88�<
Ą�Ɨ[���MC����EK�:����rBm[��+�!�ʔ�`׸�5R�/�W٤�0a�@