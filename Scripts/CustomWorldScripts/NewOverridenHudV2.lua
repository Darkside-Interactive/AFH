SIGSTRM12GIS             �+�-                  Signkey.EditorSignatureN���,��" ���#@Í��24u��r
�v��{]���9�`�i;�K^���^%-�^;�%��6b���g"�qj��h�mw�z�0��08=���趺}�l���< `��6'����+�z)<}}��IOF�C�����j� �4.�;9RE����@���0@L���.��|�[��Q����y�֐N����@{��J&`{�U�]���
�}c�a��������S�#T����mE����\���﻿-- supports coop

local worldInfo = worldGlobals.worldInfo -- worldInfo : CWorldInfoEntity
worldGlobals.AFH = {}
local InitLocalPlayerHandler = function()
  if(worldGlobals.AFH.bLocalPlayerHandlerAttached) then return end
  worldGlobals.AFH.bLocalPlayerHandlerAttached = true
  RunAsync(function()
  while true do
    while (worldGlobals.AFH.penLocalPlayer == nil) do
    local AllPlayers = worldInfo:GetAllPlayersInRange(worldInfo, -1)
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

local player -- player : CPlayerPuppetEntity  
Wait(CustomEvent("AFH_LocalPlayerFound")) 
player = worldGlobals.AFH.penLocalPlayer

local BUILD_VERSION = "0.1.2.2b | PRE-ALPHA"

local A = "TTRS:HudElement.Text_OverHealth=OVERHEALTH"
local HudPointerText_OverHealth = TranslateString(A)
local B = "TTRS:HudElement.Text_Health=HEALTH"
local HudPointerText_Health = TranslateString(B)
local C = "TTRS:HudElement.Text_LowHealth=LOW HEALTH"
local HudPointerText_LowHealth = TranslateString(C)
local D = "TTRS:HudElement.Text_Armor=ARMOR"
local HudPointerText_Armor = TranslateString(D)
local D1 = "TTRS:HudElement.Text_LowArmor=LOW ARMOR"
local HudPointerText_LowArmor = TranslateString(D1)
local D2 = "TTRS:HudElement.Text_OverArmor=OVERARMOR"
local HudPointerText_OverArmor = TranslateString(D2)
local E = "TTRS:HudElement.Text_Ammo=AMMO"
local HudPointerText_Ammo = TranslateString(E)
local fBlinkTimer = 0
local HealthText = player:FindHudElementByName("HealthText") -- HealthText : CTextBoxHudElement
local ArmorText = player:FindHudElementByName("ArmorText") -- ArmorText : CTextBoxHudElement


local function SafeDelete(penEntity)
  if not IsDeleted(penEntity) then
    penEntity:Delete()
  else
    return
  end  
end


RunHandled(WaitForever,

OnEvery(CustomEvent("OnStep")),function()
if player:IsAlive() and player:GetRide() == nil then
  -- [ HEALTH ] 
    if player:GetHealth() > 100 then -- [ OVERHEALTH  (> 100)] 
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_OverHealth,-1,-1)
      end
      HealthText:SetText(HudPointerText_OverHealth,-1,-1)
    end
    if player:GetHealth() <= 100 and player:GetHealth() > 35 then -- [ HEALTH (<= 100 && > 35) ] 
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_Health,-1,-1)
      end
      HealthText:SetText(HudPointerText_Health,-1,-1)
    end
    if player:GetHealth() <= 35 then -- [ LOW HEALTH (<= 35) ]
      if IsDeleted(HealthText) then
        HealthText = player:FindHudElementByName("HealthText")
        HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      end
      HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      fBlinkTimer = timToFloat(worldGlobals.worldInfo:SimNow())*10%5
      if fBlinkTimer<2 then
        if IsDeleted(HealthText) then
          HealthText = player:FindHudElementByName("HealthText")
          HealthText:Clear()
        end
        HealthText:Clear()
      else
        if IsDeleted(HealthText) then
          HealthText = player:FindHudElementByName("HealthText")
          HealthText:SetText(HudPointerText_LowHealth,-1,-1)
        end
        HealthText:SetText(HudPointerText_LowHealth,-1,-1)
      end
    end
  -- [ ARMOR ]
    if player:GetArmor() > 0 then -- [ ARMOR (> 0) ]
      if IsDeleted(ArmorText) then
        ArmorText = player:FindHudElementByName("ArmorText")
        ArmorText:SetText(HudPointerText_Armor,-1,-1)
      end
      ArmorText:SetText(HudPointerText_Armor,-1,-1)
    end
    if player:GetArmor() == 0 then -- [ ARMOR (== 0) ]
      if IsDeleted(ArmorText) then
        ArmorText = player:FindHudElementByName("ArmorText")
        ArmorText:Clear()
      end
      ArmorText:Clear()
    end
  end
end)���@����*�M1��3wf��|E2��0xUB���y���j�K�J��!J.&�K�`�U]�?R-�o�4t��Ȩժ?�9} �N�����aWY��򨷭����B��A(�b��r-�=�
&4/�6���{�ѥ��'ď�ǎ�4�.M�\���=�}%�?��C��� �O���9�f���%-�!ȷ�	�A1��?��ې��Df��{	y�9��E�TC��U���ܔ�E�Fe1�_S���m�