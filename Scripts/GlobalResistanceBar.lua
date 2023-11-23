SIGSTRM12GIS             $�V                  Signkey.EditorSignaturew	2���'u ��d��x�s1�-)�`D���g�y�ش/�f��Jx���W|xomSO9��z��p����$:�׳I~��F�����+Rf��w��i�� �F���R�(� i����?��g��?"����6���,:^Ƶ:��4�bDQ�?������h�{h`|�N2�z�	�N	t��?� i�6��Ƽ������8�~�K��n�E��X�d��h�`$���oNHj�*b1S���|ڗ�v>��R)*�﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity

local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local strShaderName = "fMoralBarOffset"
local fConstGoodMaxOffset = 1
local fConstBadMaxOffset = -1
local fCurrentMoralOffset = mthLerpF(fConstBadMaxOffset, fConstGoodMaxOffset, 0.5)

local fConstGoodMax = 256
local fConstBadMax = 0
local fCurrentMoral = mthLerpF(fConstBadMax, fConstGoodMax, 0.5)
local mdlMoralBar = player:FindHudElementByName("MoralBar") -- mdlMoralBar : CModelHudElement

mdlMoralBar:SetVisible(false)

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
  elseif fCurrentMoral == fConstBadMax then
    SignalEvent("MoralBarFilled")
    SignalEvent("BadWins")
    worldGlobals.worldInfo:ShowMessageToAll("Bad wins!")    
  end
  
  return fCurrentMoral
end

Wait(CustomEvent("MoralBarAppears"))

-- initialize bar
mdlMoralBar:SetVisible(true)
mdlMoralBar:SetShaderArgValFloat(strShaderName, fCurrentMoralOffset)

-- get all spawners in wld and put them in group var
local aSpawners = NewGroupVar()
local wldSpawners = worldInfo:GetAllEntitiesOfClass("CSpawnerEntity")

for _, v in pairs(wldSpawners) do
  table.insert(aSpawners, v)
end

-- main loop to catch killed puppets from spawners
RunHandled(
  function()
    Wait(CustomEvent("MoralBarFilled"))
  end,

  OnEvery(Any(Events(aSpawners.OneKilled))), function(e)
    local penPuppet = e.any.signaled:GetKilledEntity()
    local bFound = false

    for k, v in pairs(aPuppets) do
      if not bFound and k == penPuppet:GetCharacterClass() then
        bFound = true
        AddMoral(v)
        --worldGlobals.worldInfo:ShowMessageToAll(fCurrentMoral)
      end
    end    
  
  end
)  [�(R6�4�QQV2�a��`?\�5�`w� �~��;�#��}&8%�3h}���� ���r@AU��;�0���^V�BA����Q������!�W�?#�E`����T!����.Q_:^G�Bv�c�K����K����R4���@�H�V�{"�8���!7R��oP^�\
�q'��|�Z�_���]�=��w�`H��թnp__��n	�����U�	�G�w�~55D��4ET[�s���
�P՝ �t:F�