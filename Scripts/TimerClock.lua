SIGSTRM12GIS             @h=                  Signkey.EditorSignaturex}fi�|�Hӏj�b�qH����H4�LO��*L�lMA�j�6�[��S��:�F��UPd�̃���to\�+�wѥ�f?B�|��h�"�LPJ��9�!�[C)h�cȆ%O�������NQMf$h7�T��x��yWʑi�>�@���8�9�>��j�WZ;s �f		ު}|-E=�����ۄ�y)���e��5�r��6������=&5P�p	���&<%�Dye�W�����ʒ:���﻿local bTimerActive = false

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
      if(mins) == 0 then
        return "00:00";
      end
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

function worldGlobals.StartTimer(convertType, seconds, type, value)
  Wait(Delay(1))
  if type == "s" then
    local seconds = tonumber(seconds)
    while seconds >= 0 do
      local formatted_time = ClockTimer(convertType, seconds, "s")
      local TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
      if IsDeleted(TimeTextBox) then
        TimeTextBox = player:FindHudElementByName("Timer")
        TimeTextBox:SetText(time,-1,-1)
      end
      TimeTextBox:SetText(time,-1,-1)
      Wait(Delay(1))
      seconds = seconds - 1
      if seconds <= 10 then
        print("SOUND")
      end      
    end
    print("Timer finished")
  elseif type == "t" then
    local h,m,s = string.match(value, "^(%d+):(%d+):(%d+)$")
    h,m,s = tonumber(h), tonumber(m), tonumber(s)
    local time_seconds = h*360 + m*60 + s
    while time_seconds >= 0 do
      local time = string.format("%02.f:%02.f:%02.f", h, m, s)
      local TimeTextBox = player:FindHudElementByName("Timer") -- TimeTextBox : CTextBoxHudElement
        if IsDeleted(TimeTextBox) then
          TimeTextBox = player:FindHudElementByName("Timer")
          TimeTextBox:SetText(time,-1,-1)
        end
      TimeTextBox:SetText(time,-1,-1)
      Wait(Delay(1))
      time_seconds = time_seconds - 1
      h, m, s = mthFloorF(time_seconds/3600), mthFloorF((time_seconds%3600)/60), time_seconds%60
      if time_seconds <= 10 then
        print("SOUND")
      end
   end
   print("Timer finished")
  else
    conErrorF("[AFH]: Invalid format type: '"..type.."'\n")
  end
end
��	F?�,sͺ��
�|�ÃZm3��p��zf���	8�j-��[RDv�C�X��LX!��9�������E���&:� C^2�%��xƍ �ϝ��q�?��IcF�9zw$�����t��2�J�}����g���9!�P>�^P��Y����p�aC�gdu��S���h>k�@�=�,��Q]���hM��3��S5��lB�fM��|�������lG\r[=�Nn�B���pw�=mF.'��c���