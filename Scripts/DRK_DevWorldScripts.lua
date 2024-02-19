SIGSTRM12GIS             -�*�                  Signkey.EditorSignature6q2-��b�_�b �O�P�����gø�+��kA8�+�O�{��ĭ)�֋� ��Zb+l��d�"S0�h0�b�	��򇸻/�˟r=�!�v�ph��7���{%3`mq��t�%���ů�P�+��L?���@:':��N���^`�O�8��u?���5}X�5Xc�+4L%>-���D����фe. ����(\-��P3 ����#o��K����6o�� ��H�LW�o��C�S�﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity
conInfoF("[AFH]: Loaded developer settings.\n")

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
local lastBuildNumber = "1.2.5"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local BUILD_VERSION = ("0."..lastBuildNumber.." | ALPHA | DEV-BUILD | SHA : 3346ac82ed3eacd61cd2ef5c64a9e0baab0d4dc3")
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
end)��z����	P��٭�R:;�}�9|�)G����m][�K�C�S ���P�ˋ$��4���N�q�d�c�+qpB���L�u����R��� �mM���9��׹[#76��-�.S	�W��ϡ�oJ<TE+Hd��1��z��ERP݋�:�ؠ������Q,ʧ���>g��S�����������t8&LX�Mc�� ��yd9j�_͓/���i�|RB�#=8;�~�K�<�;��G�n2�@_�h�