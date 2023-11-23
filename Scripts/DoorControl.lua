SIGSTRM12GIS             �:g�                  Signkey.EditorSignature?뾈Õ>a�v��N�)�����W�M�罬<����Y�T4�3��/9I��8)�%�A$�Z�擠��z��E��Ƈ�.�ݐf;��r�OtB8�\�����D�z E��c�&�b;?-;<	},�9����u)��a(���7�,�&W���߫97��y���.�[�-�a�%�>��[��!�.���� Y�S*0nVR&��=��}��b%�lp0O�*HC$3���|��;i�ZMI������/8�﻿function worldGlobals.DoorControl(key, door, aggregator)
  RunAsync(function()
    local doorOpened = false
    local keyPicked = false
    local KeyName = key:GetEntityID()
    local DoorID = door:GetEntityID()
    
    door:AssureLocked()
    door:EnableUsage()
    door:EnableLookedAtNotification()
    
       
    RunHandled(WaitForever,
      
    OnEvery(Event(key.Picked)),function()
      keyPicked = true
        door:Unlock()
      conInfoF("[AFH]: [#Entity(CGenericKeyItemEntity,"..KeyName..")] picked!\n")
    end,   
      
    OnEvery(Event(door.Used)),function()
    if(keyPicked) then
      doorOpened = true
      door:DisableUsage()
      Wait(Delay(0.5))
      aggregator:ShowHudInfo(false)
      conInfoF("[AFH]: [#Entity(CDoorEntity,"..DoorID..")] opened!)]\n")
    else
      door:DisableUsage()
      conErrorF("[AFH]: [#Entity(CPlayerPuppetEntity,"..worldGlobals.Player:GetPlayerName()..")] tried to open [#Entity(CDoorEntity,"..DoorID..")] without key!\n")
      Wait(Delay(3.5))
      door:EnableUsage()
      if not(IsDeleted(key)) then
        aggregator:AddKey(key)
      end
      aggregator:ShowHudInfo(true)
      conInfoF("[AFH]: [#Entity(CKeyAggregatorEntity,"..aggregator:GetEntityID()..")]: successfully added keys to HUD.")
      worldGlobals.Player:SayPlayer(LoadResource("Content/Talos/Sounds/ArrangerKeyPressed.wav"))
      Wait(Delay(0.9))
      worldGlobals.Player:SayPlayer(LoadResource("Content/GoshaLox/Sounds/KeyAggregatorMovingOnHUD.wav"))
    end
  end)
end)
end

function worldGlobals.PLDControl(plasmaDoor, KeyCard, KeyCardReader, aggregatorPlasma)
  RunAsync(function()
      local keyCardPicked = false
      
      local KeyCardN = KeyCard:GetEntityID()
      local DoorNumber = plasmaDoor:GetEntityID()
      
      KeyCardReader:EnableUsage()
      
      
      RunHandled(WaitForever,
      On(Event(KeyCard.Picked)),function()
          conInfoF("[AFH]: [#Entity(CGenericKeyItemEntity,"..KeyCardN..")] picked!")
          keyCardPicked = true
      end,
      OnEvery(Event(KeyCardReader.Used)),function()
        if(keyCardPicked) == false then
          KeyCardReader:PlayAnimStay("Error")
          KeyCardReader:DisableUsage()
          conErrorF("[AFH]: Error occured while opening [#Entity(CPlasmaDoorEntity,"..plasmaDoor:GetEntityID()..")]. Please check file ('Content/GoshaLox/Scripts/DoorControl.lua')\n")
          Wait(Delay(2))
          KeyCardReader:EnableUsage()
          if not(IsDeleted(KeyCard)) then
              aggregatorPlasma:AddKey(KeyCard)
            end                    
            aggregatorPlasma:ShowHudInfo(true)
          worldGlobals.Player:SayPlayer(LoadResource("Content/Talos/Sounds/ArrangerKeyPressed.wav"))
          Wait(Delay(0.9))
          worldGlobals.Player:SayPlayer(LoadResource("Content/GoshaLox/Sounds/KeyAggregatorMovingOnHUD.wav"))            
        else
          KeyCardReader:PlayAnimStay("Unlock")
          aggregatorPlasma:ShowHudInfo(false)
          Wait(Delay(0.5))
          plasmaDoor:Deactivate()
          conInfoF("[AFH]: [#Entity(CPlasmaDoorEntity,"..DoorNumber.."]) unlocked\n")
      end
      end
    )
 end)
end

function worldGlobals.KDRControl(keyCard, aggregator2, reader, door2)
  RunAsync(function()
    local keyPicked = false
    reader:EnableUsage()
    print("started")
    
    
    RunHandled(
      WaitForever,
      On(Event(keyCard.Picked)),
      function()
        print("key picked")
        keyPicked = true
      end,
      OnEvery(Event(reader.Used)),
      function()
        print("reader used")
        if keyPicked then
        reader:PlayAnimStay("Unlock")
          door2:Unlock()
          Wait(Delay(0.5))
          aggregator2:ShowHudInfo(false)
        else
          reader:PlayAnimStay("Error")
          reader:DisableUsage()
          Wait(Delay(3.5))
          reader:EnableUsage()
            if not(IsDeleted(keyCard)) then
              aggregator2:AddKey(keyCard)
            end                
          aggregator2:ShowHudInfo(true)      
          worldGlobals.Player:SayPlayer(LoadResource("Content/Talos/Sounds/ArrangerKeyPressed.wav"))
          Wait(Delay(0.9))
          worldGlobals.Player:SayPlayer(LoadResource("Content/GoshaLox/Sounds/KeyAggregatorMovingOnHUD.wav"))             
        end
      end
    )
  end)
end


function worldGlobals.KDControl(key, door)
  RunAsync(function()
    local keyPicked = false
    door:EnableUsage()
    RunHandled(
      WaitForever,
      OnEvery(Event(door.Used)),
      function(e) -- e : CUsedScriptEvent
  -- user : CPlayerPuppetEntity
  local user=e:GetUser()
        if(keyPicked) then
          door:DisableUsage()
  else
    door:DisableUsage()
    Wait(Delay(3.5))
    door:EnableUsage()
        end
      end,
      On(Event(key.Picked)),
      function()
        keyPicked = true
        door:Unlock()
      end)
    end)
end 
4G2��k��d �4-g�%
暥A�0��GU��4�w7�'y�i��PA��J��	x�d�̄qg����G�����H�����Z�����)�?��w���Z�k����K</�-�/P��(>��U|��U�%�0�n�����lyM�2w��lp#,>����>���Omx9���V�_�ŀD��(ӳ�٨��BnDmQ��3٘k N��z���R�I�)i���n����~����p�����