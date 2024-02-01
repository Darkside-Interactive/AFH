SIGSTRM12GIS             ��L                  Signkey.EditorSignaturet`�E��C�a:�6G�>���x��XfJ%w^U;p����N�v�ލ��RY.N6%թ�j �b֝��������1�T��Bs�Q�{��&�⬟��,̺٬�a!e�5ه[L��d�P�x���l��4���!��X]ߥ�a���G '��Q?��_0y��*օ���+ݽ�4���
v�*4�ؐ6١��������ne�aÞ�'8��S�+�I7	�4�sP���@",����#��ë��X��V�#��﻿-- penPuppet : CPuppetEntity
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
end)6�Ib�d��Y]k�ݏC�|@D�0<�L}����'�^~��ˊ%�8������]j�W��0�26�� Yl����!t�)k�j}��[�y�������k�r�;���s�5�j�y}"�A���h��Ų�㵌k�{�_�z�	 <a��[�������gn�ÿ*���5T$)�n�㑙"l��`����E�1L�ZŶ���@�i�R��CR�h����cX�Ϣ�>��+Lr�<��)�T<�-�E�#\V;uvC�M�G�u9�