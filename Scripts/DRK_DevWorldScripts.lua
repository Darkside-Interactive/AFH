SIGSTRM12GIS             n��                  Signkey.EditorSignature�<���X����a�Z��T�9>��yX�4�E�C�g*id�RJ��H%�Jeb�Ѥ�!���~7�*��$^_1�t�k��ÔE��k%����e�R��
�htb��$�Xe#��E��~*s���y�㒖e�g�Ԋ�Ä���+y|<�2a�{����yZb�_һBy���e6[��*}T�W�
N�J����c��1��vSQuz4w���3(��R4lQ�UB�lCa!3�5�K��86����,�g=@�;���Pע����ۮ#2�﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity
conInfoF("[AFH]: Loaded developer settings.\n")

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
local lastBuildNumber = "0.1.2"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local BUILD_VERSION = ("0."..lastBuildNumber.." | PRE-ALPHA | DEV-BUILD | SHA : f197f0a330580657ec465059c4571f1b9ac4c5c0")
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
end)$��p4�O���C�v\��b"w)	����H^��v���zʖ^Y�dA�Z�@��?f�,t�y�;l�Cʴ0�i�����v-�m��Z�_l��s���i���Y8n��β��R�X����|]�����
S�\�,�3,&�������'J��sibj_7N�H6�S9�����lÔ��Z	CP(���"B��
=y2P$���+���(1�A�����./�ϾD/q`3W�~���s*�r�%g��^��ޠ�@