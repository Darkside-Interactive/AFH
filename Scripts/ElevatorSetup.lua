SIGSTRM12GIS             h˹�                  Signkey.EditorSignature.����F��ù��z�ŵ�+���QE�����f��W4�>��#�3؟��_z��Z�Q�����~z~E�N���&���Zv�Ѕ�^��*�63��"�7ܑ�UCmI��\Xmr����1�c������eH%��ݓ!?|��D>�E� -�^jT�����l��	�7m*���L�V��-��[�P�;ܛ�E�gS"���Q�<]+���Fʭ�/^+c޷��U����h��WL%�0]�x��c+���﻿-- set up elevator control function if necessary
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
end)����d�mk��ix˿���r��U���?ܬ�!C�m�~���oc�Z��Fo�(>�:G}6vo���j��i�ִ��e�h�@��^����c��ZA.[щ�q��̘��~��fE��(���_���/~֊zW���f�M扈Kj����%�s>xM�ܰL}O����_�/k�Y��.D/���D��`q� 3��P��۲��㐢Ḧ%N�N�Ȱ�&�69�I�y���|G���ʼ�@\6jC~Y}�(+�Ps{