SIGSTRM12GIS             �Q                  Signkey.EditorSignatureQ����F,�A^-S�3d�~�D��:�)=��cW�y�$4k��k��#���wƱ�;c3�������J*Z!��frlɆҟ�����S�WW~�d"Pb3�p����ce���Z=C�kK��������)�会�N1hY��yf���~+�S�N�ݘ�^ïYz���Q�R�x�0"Ss���Kk���D���,�z��o���f7 y�����}\Fu����T� �ϒ�XI����Il5�n����﻿-- set up elevator control function if necessary
if worldGlobals.ElevatorControl == nil then
  dofile("Content/GoshaLox/Scripts/ElevatorControl.lua")
end

ElevatorBarrier:Appear()

RunHandled(WaitForever,

On(CustomEvent(worldInfo, "AFH_EnableElevatorControl")),function()
ElevatorBarrier:Disappear()
Elevator_Entrance:PlayAnimStay("Opened")
local ec = {}
ec.numberOfLevels = 2
ec.levelAvailableFunc = function(levelNumber)
  if levelNumber < 3 then
    return true
  else
    local strVar = "Floor"..(levelNumber-1).."Unlocked"
    return ctdIsVarSet(worldInfo, strVar)
  end
end
ec.buttons = buttons
ec.levelsPanelModel = elevatorPanel
ec.generateButtonNumbersFunc = function(levelNumber)
  return levelNumber - 1
end
ec.buttonLights = buttonLights
ec.callButtonLights = callButtonLights
ec.callButtons = elevatorCallButtons
ec.chaptersOnLevels = {{}, level0Chapters}
ec.levelElevatorStartingChapters = {chapterLevel00, chapterLevel01}
ec.elevator = elevator
ec.entrances = elevatorEntrances
ec.levelMarkers = markers
ec.doorSound = doorSound
ec.updateAvailableButtonsDetector = elevatorDetector
ec.soundUse = soundUse
ec.soundUseFail = soundUseFail

worldGlobals.ElevatorControl(ec)
end)g9��R�z�t��޶�"�D%����<`j��ޒg �K�n����!�S�x�6)M���z���������9��+�ի?,�c�}�U?�AUv�A$���w�s-��(֬�By�0�t�,V+*��Ie��)^��z,��>+�t�ƺ�CIYO$�Nݶ��IԂ?Ӈ��_���g<B�i�ic��O^�y�	q�d���gj!�&6���>�n��aC�U&�W�nrR�zǞ`[��0x3�2�b �ET�OZD _�du