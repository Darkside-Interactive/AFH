SIGSTRM12GIS             v,[�                  Signkey.EditorSignature&ۂ'@�7��vx\G���oĵ�2�)/maB��u3����E�-�yǈQҪ�Pҫ���B8ʱy���L�
��Z�`!��m^�f';$d�����J�f|���E��ܖ?����`G4�7[����3�T�J���#p���Q�2����_��v<�s�A��lP$Y)��<��Q �_T�e6S.���1�*��L;�}.�;C�;�j�#HL�r0/���]�ʱN���7S+%�~o�+w��~�&[���(��Ҥ�﻿local bTimerActive = false

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity

local player = Wait(Event(worldInfo.PlayerBorn)):GetBornPlayer() -- player : CPlayerPuppetEntity

local HUD = worldInfo:LoadResource("Content/GoshaLox2/Scripts/Templates/ShieldGeneratorTemplate.rsc") -- HUD : CTemplatePropertiesHolder


worldGlobals.bLoopTimer = false

local function ClockTimer(convertType, seconds, type, value, bTimer)
  seconds = tonumber(seconds)
  
  local hours, mins, secs
  local h, m, s
  
  if type == "s" then
    if convertType == "hours" then
      hours = string.format("%02.f", mthFloorF(seconds/3600));
      mins = string.format("%02.f", mthFloorF(seconds/60 - (hours*60)));
      secs = string.format("%02.f", mthFloorF(seconds - hours*3600 - mins *60));
      return hours..":"..mins..":"..secs
    elseif convertType == "mins" then
      mins = string.format("%02.f", mthFloorF(seconds/60));
      secs = string.format("%02.f", mthFloorF(seconds - mins *60));
      return mins..":"..secs  
    elseif convertType == "secs" then
      mins = "00"
      secs = string.format("%02.f", mthFloorF(seconds - mins *60))
      return mins..":"..secs            
    else
      conErrorF("[AFH]: Invalid format type: '"..convertType.."'\n")
    end
 elseif type == "t" then
   if not string.match(value, "^%d+:%d+:%d+$") then
     conErrorF("[AFH]: Invalid time format: "..value.."\n")
     return
   else
     return value
   end
 else
   conErrorF("[AFH]: Invalid time specified in '"..value.."'\n") 
 end
end

function worldGlobals.StopTimer(bDisable)
  if(bDisable) == true then
    worldGlobals.bLoopTimer = false
  else
    worldGlobals.bLoopTimer = true
  end
end

function worldGlobals.StartTimer(convertType, seconds, type, value)
  Wait(Delay(1))
  
  worldGlobals.bLoopTimer = true
  
  local TimerSound = nil
  local TimeTextBox = nil
  local TextTextBox = nil
  local fBlinkTimer = nil
  local blink = nil
  
  if type == "s" then
    local seconds = tonumber(seconds)
    while seconds >= 0 and worldGlobals.bLoopTimer == true  do
      local formatted_time = ClockTimer(convertType, seconds, "s")
      TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
      TextTextBox = player:FindHudElementByName("TimerText") -- TextTextBox : CTextBoxHudElement
      if IsDeleted(TimeTextBox) then
        TimeTextBox = player:FindHudElementByName("Timer")
        TimeTextBox:SetText(formatted_time,-1,-1)
      end
      TimeTextBox:SetText(formatted_time,-1,-1)
      if IsDeleted(TextTextBox) then
        TextTextBox = player:FindHudElementByName("TimerText")
        TextTextBox:SetText(TranslateString("TTRS:HUDMessage_Timer_Text=TIME LEFT:"),-1,-1)
      end
      TextTextBox:SetText(TranslateString("TTRS:HUDMessage_Timer_Text=TIME LEFT:"),-1,-1)
      Wait(Delay(1))
      seconds = seconds - 1
      if seconds <= 10 then
        local TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement()) -- TimerSound : CStaticSoundEntity
        if IsDeleted(TimerSound) then
          TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement())
          TimerSound:SetParent(player, "")
        end
        TimerSound:PlayOnce()
      end      
    end
    SignalEvent(worldGlobals.worldInfo, "TimerFinished")
    worldGlobals.bLoopTimer = false
    if IsDeleted(TimerSound) then
      TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement())  
      TimerSound:SetParent(player, "")
    end
    TimerSound:Delete()
    if IsDeleted(TimeTextBox) then
      TimeTextBox = player:FindHudElementByName("Timer")
      TimeTextBox:Clear()
    end
    TimeTextBox:Clear()  
    if IsDeleted(TextTextBox) then
      TextTextBox = player:FindHudElementByName("TimerText")
      TextTextBox:Clear()
    end
    TextTextBox:Clear()        
  elseif type == "t" then
    local h,m,s = string.match(value, "^(%d+):(%d+):(%d+)$")
    h,m,s = tonumber(h), tonumber(m), tonumber(s)
    local time_seconds = h*3600 + m*60 + s
    while time_seconds >= 0 and worldGlobals.bLoopTimer == true do
      local time = string.format("%02.f:%02.f:%02.f", h, m, s)
       TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
       TextTextBox = player:FindHudElementByName("TimerText")
        if IsDeleted(TimeTextBox) then
          TimeTextBox = player:FindHudElementByName("Timer")
          TimeTextBox:SetText(time,-1,-1)
        end
      TimeTextBox:SetText(time,-1,-1)
      if IsDeleted(TextTextBox) then
        TextTextBox = player:FindHudElementByName("TimerText")
        TextTextBox:SetText(TranslateString("TTRS:HUDMessage_Timer_Text=TIME LEFT:"),-1,-1)
      end
      TextTextBox:SetText(TranslateString("TTRS:HUDMessage_Timer_Text=TIME LEFT:"),-1,-1)      
      Wait(Delay(1))
      time_seconds = time_seconds - 1
      h, m, s = mthFloorF(time_seconds/3600), mthFloorF((time_seconds%3600)/60), time_seconds%60
      if time_seconds <= 10 then
        TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement()) -- TimerSound : CStaticSoundEntity
        if IsDeleted(TimerSound) then
          TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement())
          TimerSound:SetParent(player, "")
        end
        TimerSound:PlayOnce()
        if(time_seconds) == 0 then
          return
        end
      end
   end
   SignalEvent(worldGlobals.worldInfo, "TimerFinished")
   worldGlobals.bLoopTimer = false
   if IsDeleted(TimerSound) then
     TimerSound = HUD:SpawnEntityFromTemplateByName("FUCKu", worldInfo, player:GetPlacement())  
     TimerSound:SetParent(player, "")
   end
   TimerSound:Delete()
   if IsDeleted(TimeTextBox) then
     TimeTextBox = player:FindHudElementByName("Timer")
     TimeTextBox:Clear()
   end
   TimeTextBox:Clear()
   if IsDeleted(TextTextBox) then
     TextTextBox = player:FindHudElementByName("TimerText")
     TextTextBox:Clear()
   end
   TextTextBox:Clear()
   
  else
    conErrorF("[AFH]: Invalid format type: '"..type.."'\n")
  end
end
�$q�G�g%W"&}�l�v�d�|�I�8���Um�	�x� ��S��.�T�N����{wi �J��x���Q�,�Y J��h�!ǪD�E_���$�d��`k�&?@�	.�,�b5��7�������|�D���w:�(EpJXY�X�.H��.��b��{J��R=�����[
.�d��ܯ�N��Es�hC�EB|0;��Y�mgA��� ��[�&!ٓ�G#+�5�;�j_���~�د�- �#H�ٮ�A���