SIGSTRM12GIS             -.DQ                  Signkey.EditorSignature&�G��,�9��g�yv�/S���fT�\Ŝ��+�ȤX^�O=�*s!�/ֳ�z����\i�y.g�9zPc�P�'��E�_5��Ǧ|�ʍ
�/�!��?�$�}.i7߮�kbv7}}�)_靖�4�E��ځ"?{��=g�Rz��I�2ji� �T:^*�D�EB���j��R�2�\B���Ox��D@3�L>{2�k��u�ޟZR'[��Y��m���ȝ��9�)�m�v^�؇�dO�:��d]����C�Iʋ:t﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity

local strShaderName = "fMoralBarOffset"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local fConstGoodMaxOffset = 1
local fConstBadMaxOffset = -1
local fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, 0.5)

local fConstGoodMax = 256
local fConstBadMax = 0
local fConstDefault = fConstGoodMax / 2
local fCurrentMoral = mthLerpF(fConstBadMax, fConstGoodMax, 0.5)
local mdlMoralBar = player:FindHudElementByName("MoralBar") -- mdlMoralBar : CModelHudElement

mdlMoralBar:SetVisible(false)

worldGlobals.bMoralBarActive = false

-- list of all puppets and how much they change moral value
local aPuppets = { -- Their .ep names
  -- good guys
  Beheaded_Rocketeer = -4, -- negative if they are friendly
  Beheaded_Bomber = -12,
  
  -- bad guys
  Beheaded_Firecracker = 4, -- positive if they are hostile
  Beheaded_Kamikaze = 12,
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
    SignalEvent("MoralBarFilled")
    SignalEvent("GoodWins")
    worldGlobals.worldInfo:ShowMessageToAll("Good wins!")
    worldGlobals.bMoralBarActive = false
  elseif fCurrentMoral == fConstBadMax then
    SignalEvent("MoralBarFilled")
    SignalEvent("BadWins")
    worldGlobals.worldInfo:ShowMessageToAll("Bad 5wins!")   
    worldGlobals.bMoralBarActive = false 
  end
  
  return fCurrentMoral
end


-------------------
-- MAIN FUNCTION --
-------------------

--Wait(Event(worldInfo.PlayerBorn))

Wait(CustomEvent("MoralBarAppears"))
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
          --worldGlobals.worldInfo:ShowMessageToAll(fCurrentMoral)
        end
      end
    end
    
  end
)��#&�3_�5@�q���Wn���"�Sa-ҩ�(R�}�0FE�s��;y\,l�lp ���`�D;�!/�T�T(�8py��)hX��d�����?yߑa�AQ`�f�&*##���>��w��t�}�?7�'La''N�3-�[ep`o� ����i�#cˊ�-��������/h]M��9U�AP7I��&k��1�3X���H�9!2;ԏ�4i�v������,ڑ�z&dD�ޘu_�ޣ$���Y�<)o�Һ�j'P