SIGSTRM12GIS             ���q                  Signkey.EditorSignature�Mn��Jk�К�<jd�!�;��M���b�3`�^����}��Ε�����['S%��$-�d����.\C:���V4����ޏ�1i3Z�dF�D��.�@�� w��<��������45�����Ǆ�0��.��*�a� ��N��C>�r�;��/�Q��in'������.����!���\�8Lt���@w>� I��ʙd��5<�/�W)p���<i���Us�,2`���_g��mr����ҵ��4����]﻿-- Script by Cyborg.SeriousSite

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
InitLocalPlayerHandler()
k6�?X��T�7��m��Br\�:���0�!�\�mi�@�j�����H�E�Z)b�,��1�*���<^?>i�PΓ���j}	[V3!mG�B+e�׉9��_*�/~n��J ���{0�7gw�l`��Z[-mu>�/)�9��ԨLRQMw`���-���7�Ht�ː�]�}�A����H�'P#�[������jIQ$�y��]��.��Uji������C��{��B7
��0��2M�Ȝ ��HX��+����}��*