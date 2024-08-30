-- L01P01S02
local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity
Keys:DisablePicking()
Radio:DisableUsage()
DetectorRadio:Deactivate()
Detector:Deactivate()

RunHandled(WaitForever,

On(Event(Door.Used)),function()
  Wait(Delay(1))
  objObjectivePhaseCompleted(worldInfo, AONW, "AONW_00")
  Keys:EnablePicking()
  Wait(Event(Keys.Picked))
  objObjectivePhaseCompleted(worldInfo, AONW, "AONW_02b")
  Detector:Recharge()
  Wait(Event(Detector.Activated))
  objObjectivePhaseCompleted(worldInfo, AONW, "AONW_02c")
  DetectorRadio:Recharge()
  Wait(Event(DetectorRadio.Activated))
  if not IsDeleted(player) and player:IsAlive() then
    player:SayLocalVoiceover(L01P01S02_04_Sam_Oh_news)
    player:EnableOperatorLook(false)
    player:EnableOperatorMove(false)
    player:StopMoving()
    player:LookAtEntity(Radio, 0.5)
  end
  Wait(Delay(7))
  player:EnableOperatorLook(true)
  player:EnableOperatorMove(true)
  Radio:EnableUsage()
  Radio:SetUsageDistance(2.0)
  Radio:SetUsageMessage("TTRS:UsageMessage_AONW_Radio.01={plcmdUse}  -  contact with someone")
  Wait(Event(Radio.Used))
  if not IsDeleted(player) and player:IsAlive() then
    player:EnableOperatorLook(false)
    player:EnableOperatorMove(false)
    player:StopMoving()
    player:PutDownWeapons()
    player:DisableWeapons(false)
  end    
  worldInfo:SetMusicVolume("Exploration", 0)
  Wait(Delay(2))
  RadioVoiceover:SetSound(DialUp)
  RadioVoiceover:PlayOnce()
  Wait(Delay(RadioVoiceover:GetSound():GetLength()))
  RadioStatic:PlayLooping()
  Wait(Delay(1.5))
    if not IsDeleted(player) and player:IsAlive() then
      player:SayLocalVoiceover(L01P01S02_05_Sam_Hello_there)
    end
    Wait(Delay(5))
      RadioVoiceover:SetSound(L01P01S02_01_Radio_Who_are_you)
      RadioVoiceover:PlayOnce()
    Wait(Delay(RadioVoiceover:GetSound():GetLength()))
      Wait(Delay(1))
        if not IsDeleted(player) and player:IsAlive() then
          player:SayLocalVoiceover(L01P01S02_06_Sam_We_was_in_one_train)
        end    
      Wait(Delay(9))
        RadioVoiceover:SetSound(L01P01S02_02_Radio_Oh_I_got_it)
        RadioVoiceover:PlayOnce()
      Wait(Delay(RadioVoiceover:GetSound():GetLength()))
        Wait(Delay(1))    
          if not IsDeleted(player) and player:IsAlive() then
            player:SayLocalVoiceover(L01P01S02_07_Sam_What)
          end          
        Wait(Delay(1.3))
          RadioVoiceover:SetSound(L01P01S02_03_Radio_Road_destroyed)
          RadioVoiceover:PlayOnce()
      Wait(Delay(RadioVoiceover:GetSound():GetLength()))   
        Wait(Delay(1))
          RadioVoiceover:SetSound(L01P01S02_04_Radio_You_didnt_see)
          RadioVoiceover:PlayOnce()
     Wait(Delay(RadioVoiceover:GetSound():GetLength()))       
        Wait(Delay(1))    
          if not IsDeleted(player) and player:IsAlive() then
            player:SayLocalVoiceover(L01P01S02_08_Sam_PlasmaField)
            player:LookAtEntity(PlasmaField, 0.5)
            Wait(Delay(2))
            player:LookAtEntity(Radio, 0.5)
          end            
        Wait(Delay(6))
          RadioVoiceover:SetSound(L01P01S02_05_Radio_Shine_symbol)
          RadioVoiceover:PlayOnce()
        Wait(Delay(6.2))
          PlasmaField:Deactivate() 
        Wait(Delay(2))
        if not IsDeleted(player) and player:IsAlive() then
          player:SayLocalVoiceover(L01P01S02_08_Sam_PlasmaField_Off)
        end                 
        Wait(Delay(2.4))
          RadioVoiceover:SetSound(L01P01S02_06_Radio_Good_luck)
          RadioVoiceover:PlayOnce()
      Wait(Delay(RadioVoiceover:GetSound():GetLength()))                
      RadioStatic:SetSound(RFE_End)
      RadioStatic:PlayOnce()
      RadioVoiceover:Stop()
   worldInfo:SetMusicVolume("Exploration", 1)
   if not IsDeleted(player) and player:IsAlive() then
     player:EnableOperatorLook(true)
     player:EnableOperatorMove(true)
     player:EnableWeapons()
   end       
   objObjectivePhaseCompleted(worldInfo, AONW, "AONW_02f")
end)