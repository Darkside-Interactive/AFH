SIGSTRM12GIS             ���                  Signkey.EditorSignature�p$"�q�mK��[i=�jCI�q2α��{V�~��	c�.��A� �ء@��ʠ�sXy�
~ɭ �@~Q�o�]����D�W��~!�q\'����K&/4R�e��\K��"0�1,�J��o�H	�`�3Y�ئ\�ϊ&��y}�[��$���z�:�J���2L۬Zڜs��iXD�#��I���'
�b�-�_iX�N�j&��
��I�D��s#l�D�DU�ں�A�xN}3��b#���X�Ex2��s�33\�?�(M﻿-- Creates an RPC in worldGlobals with caller with provided function and options. Returns the function that should be called that will call the provided function body.
local function CreateRPC(isServer, isReliable, funcName, func)
  assert(type(isServer) == "boolean")
  assert(type(isReliable) == "boolean")
  assert(type(funcName) == "string")
  assert(type(func) == "function")
  
  local namePrefix = 'RPC_'
  if isServer then
    namePrefix = namePrefix .. "server_"  
  else
    namePrefix = namePrefix .. "client_"
  end
  if isReliable then
    namePrefix = namePrefix .. "reliable_"
  else
    isReliable = namePrefix .. "reliable_"
  end
  local rpcName = namePrefix..funcName
  -- we must register the script RPC as an optimization so the RPC name is known before CallScriptRPC and can be synced more efficiently
  RegisterScriptRPC(rpcName)
  -- creating the actual function in worldGlobals (so it can be called on other machine)
  worldGlobals[rpcName] = func
  -- if necessary, creating the caller function that will execute the RPC and then call the function
  -- (RPC caller is necessary if we're on the same machine this function is designed to be called from
  -- otherwise, we don't need it since client should not execute server RPC and vice versa)
  if isServer == worldGlobals.netIsHost then
    if isReliable then
      worldGlobals[funcName] = function(...)
        CallScriptRPC(rpcName, true, ...)
        func(...)
      end
    else
      worldGlobals[funcName] = function(...)
        CallScriptRPC(rpcName, false, ...)
        func(...)
      end
    end
  else
    worldGlobals[funcName] = func
  end
end

function worldGlobals.CreateRPC(serverOrClient, reliableOrUnreliable, funcName, func)
  assert(worldGlobals[funcName] == nil, 'Attempting to create script RPC "' .. funcName .. '" that already exists"')
  local isServer
  if serverOrClient == "server" then
    isServer = true
  elseif serverOrClient == "client" then
    isServer = false
  else
    assert(false, "Invalid origin specifier '" .. tostring(serverOrClient) .. "'. Use 'server' or 'client'!")
  end
  
  local isReliable
  if reliableOrUnreliable == "reliable" then
    isReliable = true
  elseif reliableOrUnreliable == "unreliable" then
    isReliable = false
  else
    assert(false, "Invalid reliability specifier '" .. tostring(reliableOrUnreliable) .. "'. Use 'reliable' or 'unreliable'!")
  end
  CreateRPC(isServer, isReliable, funcName, func)
end

--Create placeholder functions for missing RPCs
if not (worldGlobals.worldInfo:IsSinglePlayer() or worldGlobals.worldInfo:IsMenuSimulationWorld()) then
  Wait(Delay(0.1))
  local RPCConfirmedMissing = {}
  dofile("Content/Config/RPCList.lua")
  if not (worldGlobals.RPCFixList == nil) then
    for RPCName in string.gmatch(worldGlobals.RPCFixList, "(RPC_.-)\n") do
      if worldGlobals[RPCName] == nil then
        worldGlobals[RPCName] = --This function will be overwritten if the RPC is properly defined afterwards
          function()
            if not RPCConfirmedMissing[RPCName] then
              RPCConfirmedMissing[RPCName] = true
              local Type,Name = string.match(RPCName, "RPC_(%a-)_reliable_(.+)" )
              conWarningF("Missing "..Type.." RPC with name \""..Name.."\"\n")
            end
          end
      end
    end
  end
end����8ivTB�x�
�wX�"@���B��O'��<m�.E�*��-�6�L�������h����󷷭�n�$\o'����������H"E����V�W��GÕ��[\yf�%<Ɲ2s�At����55�=��
���i~�3��k'��r����b�]�(r�7�w�,~�C��VD!]ar*�e�{��}�������E���G�I���~=�ה�C��zpi�|�3��o��;�������Q��