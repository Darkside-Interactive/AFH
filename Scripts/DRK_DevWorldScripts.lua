SIGSTRM12GIS             ����                  Signkey.EditorSignature4�ΐ�3Ej�8�&���7v&Pv�0�hH�.�p.Bj�a�՚���
��������O1�(���T�����-J�e�V�GZ0&,���3�(R:�6o� q��I4��� 7�ܙp�E�nz��.�ޒ=��a�K6�
�Q�ݘ��D�J�|���;P뼏ƒY����5#�Wݠu��=W�W��FD4j�	��������~�� �|�2>"�H[G`7�/���nh9��w�Q�N0&C?ZWb��8�E����#��﻿-- penPuppet : CPuppetEntity
-- aSpawners : CSpawnerEntity
conInfoF("[AFH]: Loaded developer settings.\n")

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
local lastBuildNumber = "0.7.2.1"
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
local BUILD_VERSION = ("0."..lastBuildNumber.." | PRE-ALPHA | DEV-BUILD | SHA : 386e6ae7888e73b246672868bfa845cc972a59f3")
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
end)R_�I��`��>&M.T��Cw�KJ`�ɵ�o/��zH�Џ��h�����s�Ó�M"�3)��
|�]���S^�?4�:��iغh������%�tk��7s���awqfgؕ5�x��%�I�=ӱ��g���Y}��]%�u~�$ά�F-&|��|�v�.8���;�T�1;+����C}~!���q*��c����Qb����q��xR�^�`jp�/苕^�#ÿ��Yjv~��Xsr�26�u�2��