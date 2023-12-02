SIGSTRM12GIS             ]�OO                  Signkey.EditorSignature�nR���/t��n�m[i�3�i�x:ȇ)���#�ı+cW�yt9Ĺz`f!�||��Y��,���$�B�6�X�ڶ�[|��L-r��P�d�X��5-M����<�v�"I��s�;��dF���
�U�����$��aڢ;r���hn �qe� ���4�l���6�%3*��|T<j�j�/�z��8� LE>�!�.9%nQ�D��f��h�{�\��� �k�;����(�[��n$i��̌ҿ��IJ�﻿-- penPuppet : CPuppetEntity
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
worldGlobals.bIsBattleActiveNow = false

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

if(worldGlobals.bIsBattleActiveNow) == true then

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
))�֚/��g�/�6	��2��}#�F�GV�-_��t(~��!Qپ#��>=��B�������Ceթ4ȃm֥~-2�B����JD�pk�kUĚҰ���a��dA	gܣ"X{$��FKv6��O��WJ� ���Y;�"������o
 )��	*�iB�%�w	��aC\��ƑO"��|Z
H�bnt��xxpλ��,��!�!�����+���ʮ�J�}U�m���m<e�C�|F-�t�ҘɅ