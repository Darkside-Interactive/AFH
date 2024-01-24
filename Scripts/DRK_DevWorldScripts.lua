SIGSTRM12GIS             ��N                  Signkey.EditorSignature-z�es&�x��Wv��g�j1���h|���9;�7��0�(���N#i�����kslok5%�$��2����]t�/���4p��7�GW:�1εØmշ_��Q�\H�8>��#��k �<gQ�ï̒�}�e�z�I�4J7�Cj����	s׫z� :.i8�/.i \���#g�m���yJ�%,mO�V����Å���q������A�D;p�	q����>F�Mȡ ����i��������3�i﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity
conInfoF("[AFH]: Loaded developer settings.\n")

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
local lastBuildNumber = "0.7.1"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local BUILD_VERSION = ("0."..lastBuildNumber.." | PRE-ALPHA | DEV-BUILD | SHA : c7d1491a91cef222d76dde72195a0e714d6e1521")
local bEnableDeveloperSettings = false
local KilledCount = 0

local aPuppets = { 
  Beheaded_Rocketeer,
  Beheaded_Bomber,
  Beheaded_Firecracker, 
  Beheaded_Kamikaze,
  Drone_Combat,
  Gnaar_Female,
  Gnaar_Male,
  Harpy,
  Khnum,
  Kleer,
  MetalSnake,
  Processed_Brawler,
  Pyro,
  Reptiloid,
  Scrapjack,
  Spider_Big,
  Spider_Small,
  Trooper_Brute,
  Trooper_Commander,
  Trooper_Grenadier,
  Trooper_Laser,
  Vampire,
  Walker_Red,
  Walker_Blue,
  Werebull,
  Russian_Shine_Soldier, 
  American_Shine_Soldier,
  Brazilian_Shine_Soldier,
  Europeian_Shine_Soldier,
  Latina_Shine_Soldier,
  Japanese_Shine_Soldier,
  Chinese_Shine_Soldier,
  Drone_Companion,
}

local aSpawners = NewGroupVar()
local KilledEntity = worldInfo:GetAllEntitiesOfClass("CSpawnerEntity") -- KilledEntity : CLeggedCharacterEntity

for _, v in pairs(KilledEntity) do
  table.insert(aSpawners, v)
end

RunHandled(WaitForever,

OnEvery(CustomEvent("OnStep")),function(DebugSettings)
  if corIsAppEditor and chtGetCheatingLevel(worldInfo) >= 3 then
    local WIPTable = player:FindHudElementByName("WIPTable") -- WIPTable : CTextBoxHudElement
    if IsDeleted(WIPTable) then
      WIPTable = player:FindHudElementByName("WIPTable")
      WIPTable:SetText(BUILD_VERSION,-1,-1)
    end
    WIPTable:SetText(BUILD_VERSION,-1,-1)    
  end
end,
OnEvery(Any(Events(aSpawners.OneKilled))), function(e)
  KilledCount = KilledCount + 1
  local penPuppet = e.any.signaled:GetKilledEntity()
  local LastKilledEntity = player:FindHudElementByName("LastKilledEntity") -- LastKilledEntity : CTextBoxHudElement
  local PuppetClassName = penPuppet:GetCharacterClass()
  if IsDeleted(LastKilledEntity) then
    LastKilledEntity = player:FindHudElementByName("LastKilledEntity")
    if(KilledCount) > 1 then
      LastKilledEntity:SetText("Killed entity: CLASS : "..penPuppet:GetClassName().." NAME : "..penPuppet:GetCharacterClass().." COMBO : "..KilledCount.."",1,1)
    else
      LastKilledEntity:SetText("Killed entity: CLASS : "..penPuppet:GetClassName().." NAME : "..penPuppet:GetCharacterClass().." COUNT : "..KilledCount.."",1,1)
    end
  end
  if(KilledCount) > 1 then
    LastKilledEntity:SetText("Killed entity: CLASS : "..penPuppet:GetClassName().." NAME : "..penPuppet:GetCharacterClass().." COMBO : "..KilledCount.."",1,1)
  else
    LastKilledEntity:SetText("Killed entity: CLASS : "..penPuppet:GetClassName().." NAME : "..penPuppet:GetCharacterClass().." COUNT : "..KilledCount.."",1,1)
  end
  Wait(Delay(5))
  KilledCount = 0
end)F1�E{k�~=�-_����J0/�#O����P�-�H�D�e�Z��9��:�&�����o��\�fr���m��a���4@�[� ����1L7� M����U�B�]ҌJ�(�y��`}O�# <��-D���}ːX��h~�����ف|{V��>���l!s-c�n͉��A"��3�ՅUv��3�5*(��g����Eg!�tt?y��p|��T��\�y=����z�w ��+fvߙB��Z