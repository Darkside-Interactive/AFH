SIGSTRM12GIS             $�E3                  Signkey.EditorSignature���g�;�	B#'*IH՚����K¢����B�7~{>�a(�Q�C�a��V��-�ULCRb}��8��5��r��^ǥ�V���?Y��[�F
��#�Z�Va���w�'�����W*J��d~_V��Ա�>rNa�7�=���t��g�����R��*	��ԙR�&1^�O���m�!�Q4)� K��uk���nkY�4~�%�?v%>�Å��/tC�KzG�U���2r�LB����8̈́�﻿-- Script by Cyborg.SeriousSite

worldGlobals.AFH = {}
local InitLocalPlayerHandler = function()
  if(worldGlobals.AFH.bLocalPlayerHandlerAttached) then return end
  worldGlobals.AFH.bLocalPlayerHandlerAttached = true
  RunAsync(function()
  while true do
    while (worldGlobals.AFH.penLocalPlayer == nil) do
    local AllPlayers = worldGlobals.worldInfo:GetAllPlayersInRange(worldGlobals.worldInfo, -1)
    for i=1,#AllPlayers,1 do
      if AllPlayers[i]:IsLocalOperator() then
      worldGlobals.AFH.penLocalPlayer = AllPlayers[i]
      SignalEvent("AFH_LocalPlayerFound")
      break
     end
    end
    Wait(CustomEvent("OnStep"))
   end
   while not IsDeleted(worldGlobals.AFH.penLocalPlayer) do
     Wait(CustomEvent("OnStep"))
   end 
   worldGlobals.AFH.penLocalPlayer = nil
  end
 end)
end
InitLocalPlayerHandler()��k��j4־ ���{�!��	�֦�u�FttZ�������{�>�X- ��v +4�s�X��e����N�vE�=K�]j{��%��W$�,�R<S���0�b�ty�g8KX�`��X�^�Ag�F���込�����E�t���P��G$��8}�ABTMx̨��L[��l���ae&��\���-W���@��y�*D<� k;�_1�|��w@1��n7�|C���@�*�j��xf��>�0�N~ �ET/