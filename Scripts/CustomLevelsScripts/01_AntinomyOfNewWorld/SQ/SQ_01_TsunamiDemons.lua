SIGSTRM12GIS             -	�T                  Signkey.EditorSignature_�0�k�M����k��gF�]���dr�L�0[2ĳU�Í���=�u�C{�s���(<)�gqvYA1��s_讖Ģ��R��wZ�J.���0��P(��u&.��p<`��U�8�n�X9M��],�jT��mF���q�2�`q�P��/K�c�-?'$����gO��C�<��1�;�!�n�e~���Ҝc骏UQƧ��U� N��$�&�&�p*rO���qN�se#l��jʅ�ƄPȈ�B�﻿-- SQ : ( TSUNAMI DEMONS )

DetectorArea007:Deactivate()

local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity

local BAR_HEALTH = player:GetHealth()
local DAMAGE_AMOUNT = 0

local SQ_TD_STARTED = false


RunHandled(WaitForever,

--[[OnEvery(Event(player.Damaged)),function(e) -- e : CReceiveDamageScriptEvent
  if mdlSquadStatusBar:IsVisible() and SQ_TD_STARTED == true then
    if IsDeleted(mdlSquadStatusBar) then 
      mdlSquadStatusBar = player:FindHudElementByName("mdlSquadStatusBar")
    end
    DAMAGE_AMOUNT = e:GetDamageAmount()
  mdlSquadStatusBar:SetShaderArgValFloat("fSquadStatusBar_RL", DAMAGE_AMOUNT-mthClampF(fEndOffset, DAMAGE_AMOUNT/fEndOffset, 0, 1))
  FlashBar()
  end
end,--]]

On(Event(DetectorArea006.Activated)),function()
  chapter_TD_01:Start()
  Wait(Delay(2))
  Gnaar_01:SpawnSimple()
  Wait(Delay(1.2))
  Gnaar_02:SpawnSimple()
  Wait(Delay(1.0))
  Gnaar_03:SpawnSimple()
  Wait(Delay(0.8))
  Gnaar_04:SpawnSimple()
  
  Wait(All(Events(Enemies.AllKilled)))
  
  objObjectivePhaseCompleted(worldInfo, TD, "TD.01") 
  DetectorArea007:Recharge()
   
  Wait(Event(DetectorArea007.Activated))
  objObjectivePhaseCompleted(worldInfo, TD, "TD.03")
  Wait(Delay(2))
  worldInfo:ForceMusic("Continuous", _01_SQ_TsunamiDemons)
  plasmaMental:Activate()
  
  SignalEvent("EnableMoralBar_01")

  Wait(Delay(10))
  SignalEvent(worldInfo, "AFH_SpawnItems")
  Enemies2:SpawnSimple() -- Gnaar : CLeggedCharacterEntity
  Rocketmans:SpawnSimple() -- Rocketman : CLeggedCharacterEntity
  
  Wait(CustomEvent(worldInfo, "GoodWins"))
  local mdlMoralBar = player:FindHudElementByName("MoralBar") -- mdlMoralBar : CModelHudElement
  if IsDeleted(mdlMoralBar) then
    mdlMoralBar = player:FindHudElementByName("MoralBar")
  end
  mdlMoralBar:SetVisible(false)
  Wait(Delay(0.5))
  mdlMoralBar:SetVisible(true)
  Wait(Delay(0.5))
  mdlMoralBar:SetVisible(false)
  worldGlobals.bMoralBarActive = false
  worldInfo:ForceMusic("Event", _01_SQ_TsunamiDemons_End)
  Enemies2:StopSpawningAndDespawn()
  Rocketmans:StopSpawningAndDespawn()
 
  objObjectivePhaseCompleted(worldInfo, TD, "TD.04")
  
  Wait(Delay(2))
  UghZanHandSpawn_01:Start()
  UghZanHandSpawn_02:Start()
  
  Wait(Delay(4))
  PortalNukeTrail_01:SetParent(Mothership, "")
  PortalNukeTrail_02:SetParent(Mothership, "")
  Wait(Delay(1))
  Leviathan_Call_06:PlayOnce()
  Wait(Delay(1))
  Animator:PlayAnimWait("HarvesterFlyAway")
  
end,

On(CustomEvent(worldInfo, "BadWins")),function()  
  player:SetCustomSpeedMultiplier(0)
  Wait(Delay(0.5))
  worldInfo:AddLocalTextEffect(TextEffect, TranslateString("TTRS:FuckedUp_Egg_01=We are happy to inform you: \n You have fucked up and loosed something important."))
  Wait(Delay(9))
  player:InflictDamage(1000)
  worldInfo:ClearTextEffects()
end)
  j;��t�N�|y�i���L
+�DƲ`�ȫ+c��s�`�s��Y/���~|d( eM�IM<raC�x9n�z�mohŸ�*��k2�z儩���Xt���u�r���9�6a0�6ӻRq^����
ѫK8 �h�C3>�μ�I�i=Mǝ��Z��gcn�Q�%��ow�=�/�n�f4�����%�~����HDu}yI��T77��g���UǞ��1�g�e��S
����L�u����,���ur