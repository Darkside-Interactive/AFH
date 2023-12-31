SIGSTRM12GIS             5���                  Signkey.EditorSignature�F_)���5�d �삛 'L���'�Z�<ˁ�1�,�@�>2,ө%K=0x�C���/�I־i~רV{�m�8Q�QH�g8�#ҍ%��I�D]y`XE�o�x!O;DqۅG�8�-ɤ��<�=ϵ"�Z/�����p�8��˻�s��&$���&+���{�kA���,�B�-9��VS�V�[Fg\z�rC���e��p�F2�bS���]_K���O�� t�'����GҧW�����y"����3"b�﻿-- if the tutorial tips should be disabled
local bDisableTutorialTips = false
if bDisableTutorialTips then
  function globals.RequestHint(penPlayer, strHint, bNow)
  end
  return
end


local math = dofile("Content/Shared/Scripts/Math.lua")
local worldInfo = worldGlobals.worldInfo

-- tmLastStep : Time
-- penPlayer : CPlayerActorPuppetEntity
-- strSkill : CString
-- seSkillLearned : CSkillLearnedScriptEvent

local TTConstants = {}
local tmLastStep = 0
local bIsFightActive = false

TTConstants.fMinTimeBetweenTips = 5
TTConstants.fMinPeacefulTime = 10

TTConstants.astrHints = {"WayToGo", "WeaponWheel", "Netricsa", "GadgetSwap", "DualWield", "UnusedSkillPoints"}
TTConstants.aslAcceptCount = {2, 3, 3, 2, 3, 5}
TTConstants.astrTrackedActions = {"Way to go requested", "Weapon wheel opened", "Netricsa invoked", "Gadget hotkeyed", nil, nil}
local aslTrackedActions = {nil, nil, nil, nil, nil, nil}
local bWasDualWielding = nil
local strLastHintPlayed = ""

TTConstants.afDelayBetweenHints = {0, 300, 789, 0, 544, 0} -- practical values
--TTConstants.afDelayBetweenHints = {0, 60, 20, 0, 10, 0} -- testing values
TTConstants.abAutoHint = {0, 1, 1, 0, 1, 0}

TTConstants.astrDisplayHints = {
  "TTRS:TutorialTips.WayToGo=Press {plcmdShowWayToGo}  to activate Netricsa navigator",
  "TTRS:TutorialTips.WeaponWheel=Hold {plcmdShowWeaponWheel}  for weapon wheel",
  "TTRS:TutorialTips.Netricsa=Press {plcmdDisplayNetricsa}  to activate Netricsa",
  "TTRS:TutorialTips.GadgetSwap=Press {plcmdGadgetSelection}  to select gadget",
  "TTRS:TutorialTips.DualWield=Press {plcmdWeaponSelectMod}  to toggle dual wielding",
  "TTRS:TutorialTips.UnusedSkillPoints=You have unused skill points!"
}
TTConstants.afDisplaySizes = {0.4, 0.4, 0.4, 0.4, 0.4, 0.4}

-- gets the hint index
local function GetHintIndex(strHint)
  for i = 1, 6 do
    if (TTConstants.astrHints[i] == strHint) then
      return i
    end
  end
end

local function WaitWhilePlayerExists(penPlayer)
  while penPlayer ~= nil do
    Wait(Delay(1))
  end
end

-- checks whether a hint can be played
local function CanPlayHint(strHint, penPlayer, bNow)
  if (strHint == "") then
    return false
  end

  -- used vs target count check
  local iHint = GetHintIndex(strHint)
  local slTarget = TTConstants.aslAcceptCount[iHint]
  local slAccepted = plpGetLong(penPlayer, "slAccepted" .. strHint)
  if (slAccepted >= slTarget) then
    return false
  end

  -- if the time since the last that this hint was played is too short
  if (plpGetFloat(penPlayer, "fSinceHint" .. strHint)) < TTConstants.afDelayBetweenHints[iHint] and not bNow then 
    return false
  end

  -- don't give a dual wielding tip when:
  if (strHint == "DualWield") then
    -- player is already dual wielding
    local penLeftWeapon = penPlayer:GetLeftHandWeapon()
    local bIsDualWielding = penLeftWeapon ~= nil
    if bIsDualWielding then
      return false
    end
    -- player doesn't have the dual wielding skill learnt
    if not penPlayer:IsSkillLearned("S4PS_DUAL_WIELD_1H_SAME") then
      return false
    end
  end

  -- can't show a hint for an action which player has already used on this level
  local strLastLevel = "strActionUsedOnLevel" .. strHint
  if worldInfo:GetWorldFileName() == plpGetString(penPlayer, strLastLevel) then
    return false
  end

  -- no conditions failed, allow playing the hint
  return true
end

-- selects a hint to be played, selecting the prefered one if possible
local function SelectHint(strPrefered, penPlayer, bRequestedNow)
  -- if the prefered hint can be played, selected it
  if CanPlayHint(strPrefered, penPlayer, bRequestedNow) then
    return strPrefered
  end

  -- find any hint that can be played
  for i, strHint in ipairs(TTConstants.astrHints) do
    if TTConstants.abAutoHint[i] and plpGetLong(penPlayer, "bEverShownHint" .. strHint) and CanPlayHint(strHint, penPlayer, false) then
      return strHint
    end
  end

  -- no hint can be played
  return ""
end

-- tracks per-hint timers
local function TrackHintTimers(penPlayer, fStep)
  for i = 1, 6 do
    if TTConstants.afDelayBetweenHints[i] > 0 then
      local strHintTimer = "fSinceHint" .. TTConstants.astrHints[i]
      plpSetFloat(penPlayer, strHintTimer, plpGetFloat(penPlayer, strHintTimer) + fStep)
    end
  end
end

-- handles an action taught by the tutorial being used by the player
local function TaughtActionUsed(penPlayer, strHint)
  local strCurrentLevel = worldInfo:GetWorldFileName()
  -- if last used on another level
  local strLastLevel = "strActionUsedOnLevel" .. strHint
  if strCurrentLevel ~= plpGetString(penPlayer, strLastLevel) then
    -- record the hint being accepted
    plpSetString(penPlayer, strLastLevel, strCurrentLevel)
    local strAccepted = "slAccepted" .. strHint
    plpSetLong(penPlayer, strAccepted, plpGetLong(penPlayer, strAccepted) + 1)
  end

  -- if there is a hint active for this action, remove it
  if (strHint == strLastHintPlayed and penPlayer.fSinceLastTip < 30) or (strHint == "Netricsa" and strLastHintPlayed == "UnusedSkillPoints") then
    strLastHintPlayed = ""
    local pheHudElm = penPlayer:FindHudElementByName("TutorialTips")
    if pheHudElm ~= nil and pheHudElm:IsHintActive() then
      pheHudElm:SetCurrentPhase("Disappear")
    end
    pheHudElm = nil
  end
end

-- tracks the player using actions promoted by this script
local function TrackPlayerActions(penPlayer)
  -- for each tracked action
  for i = 1, 6 do
    local strHint = TTConstants.astrHints[i]
    -- if the action is tracked automatically in the player profile
    local strTrackedName = TTConstants.astrTrackedActions[i]
    if strTrackedName ~= nil then
      -- fetch the current tracked action hit count
      local slNewTrackedValue = plpGetTrackedActionUsedCount(penPlayer, strTrackedName)
      -- if past tracked action hit count was not cached, set it to the current
      if aslTrackedActions[i] == nil then
        aslTrackedActions[i] = slNewTrackedValue
      end
      -- if the action was hit since the last caching
      if aslTrackedActions[i] < slNewTrackedValue then
        TaughtActionUsed(penPlayer, strHint)
        aslTrackedActions[i] = slNewTrackedValue
      end
    end
  end

  -- track dual wielding activations
  local penLeftWeapon = penPlayer:GetLeftHandWeapon()
  local bIsDualWielding = penLeftWeapon ~= nil
  if bWasDualWielding == nil then
    bWasDualWielding = bIsDualWielding
  end
  if not bWasDualWielding and bIsDualWielding then 
    TaughtActionUsed(penPlayer, "DualWield")
  end
  bWasDualWielding = bIsDualWielding
end

-- plays the given hint
local function PlaySelectedHint(penPlayer, strHint)
  -- get the selected hint index and display values
  local iHint = GetHintIndex(strHint)
  local strDisplayHint = TTConstants.astrDisplayHints[iHint]
  local fDisplaySize = TTConstants.afDisplaySizes[iHint]
  local strTranslated = TranslateString(strDisplayHint)
  
  -- fetch the hud element (if free)
  local pheHudElm = penPlayer:FindHudElementByName("TutorialTips")
  if pheHudElm == nil or pheHudElm:IsHintActive() then
    return
  end
  -- play the hint
  pheHudElm:ShowTip(strTranslated, fDisplaySize)
  pheHudElm = nil
  penPlayer.fSinceLastTip = 0
  strLastHintPlayed = strHint
  plpSetFloat(penPlayer, "fSinceHint" .. strHint, 0)
  plpSetString(penPlayer, "strRequestedSkill", "")
  plpSetLong(penPlayer, "bRequestedNow", false)
  plpSetLong(penPlayer, "bEverShownHint" .. strHint, 1)

  -- unused skill points can only be shown a limited number of times
  if (strHint == "UnusedSkillPoints") then
    plpSetLong(penPlayer, "slAccepted" .. "UnusedSkillPoints", plpGetLong(penPlayer, "slAccepted" .. "UnusedSkillPoints") + 1)
  end
end

-- step operations for tutorial tips ; tracks peaceful time and tracks tips
local function StepTutorialForPlayer(penPlayer)
  if penPlayer == nil then
    return
  end

  -- calculate time step
  local tmNow = worldInfo:SimNow()
  local fStep = timToFloat(tmNow - tmLastStep)
  if (fStep < 0 or fStep > 1) then
    fStep = 0
  end
  tmLastStep = tmNow

  -- track per-hint timers
  TrackHintTimers(penPlayer, fStep)
  -- track peaceful time
  penPlayer.fPeacefulTime = penPlayer.fPeacefulTime + fStep
  if worldInfo:IsFightMusicPlaying() then
    penPlayer.fPeacefulTime = 0
  end
  -- track time since last tip
  penPlayer.fSinceLastTip = penPlayer.fSinceLastTip + fStep

  -- track player using actions being taught
  TrackPlayerActions(penPlayer)

  -- fetch requested hint
  local strHint = plpGetString(penPlayer, "strRequestedSkill")
  if strHint == nil then
    strHint = ""
  end
  local bNow = plpGetLong(penPlayer, "bRequestedNow")

  -- bail if either time is too short and there is no request for immediate tip
  if (penPlayer.fPeacefulTime < TTConstants.fMinPeacefulTime or penPlayer.fSinceLastTip < TTConstants.fMinTimeBetweenTips) and not bNow then
    return
  end

  -- select a hint to be played
  strHint = SelectHint(strHint, penPlayer, bNow)
  if strHint == "" then
    return
  end

  -- play the hint
  PlaySelectedHint(penPlayer, strHint)
end

-- handles all tutorial events and actions
local function OperateTutorialForPlayer(penPlayer)
  penPlayer.fPeacefulTime = 0
  penPlayer.fSinceLastTip = 0

  RunHandled(function() WaitWhilePlayerExists(penPlayer) end,
    -- stepper required for tracking peaceful time
    OnEvery(CustomEvent("OnStep")), function()
      StepTutorialForPlayer(penPlayer)
    end,
    -- when a skill is learnt, check if it is a dual wielding skill, and if so request a DualWield tip
    OnEvery(CustomEvent(penPlayer, "SkillLearned")), function(seSkillLearned)
      local strSkill = seSkillLearned:GetSkill()
      seSkillLearned = nil
      local astrDualWieldingSkill = {"Dual Wield", "Dual Wield Harder", "Dual Wield With a Vengeance", "Mix It Up"}
      for i,str in ipairs(astrDualWieldingSkill) do
        if strSkill == str then
          globals.RequestHint(penPlayer, "DualWield", true)
        end
      end
    end,
    -- when netricsa is closed, notify the player if he didn't use all of the skill points available
    OnEvery(CustomEvent(penPlayer, "NetricsaClosed")), function(seSkillLearned)
      local iUnused = penPlayer:UnusedSkillPoints()
      if iUnused > 0 and CanPlayHint("UnusedSkillPoints", penPlayer, true) then
        globals.RequestHint(penPlayer, "UnusedSkillPoints", true)
      end
    end
  )
end

-- requests a hint to be played on a player
function globals.RequestHint(penPlayer, strHint, bNow)
  if not penPlayer:IsLocalOperator() then
    return
  end
  plpSetString(penPlayer, "strRequestedSkill", strHint)
  plpSetLong(penPlayer, "bRequestedNow", bNow)
end

-- find the local player and operates the tutotiral
local function OperateTutorialForLocalPlayer()
  -- start it only once
  if (worldGlobals.bTutorialTipsStarted ~= nil) then
    return
  end
  worldGlobals.bTutorialTipsStarted = true

  -- find the local operator
  local penOperator = nil
  while penOperator == nil do
    -- wait a second to allow players to spawn
    Wait(Delay(1))
    -- store the starting time
    tmLastStep = worldInfo:SimNow()

    -- go through all the players, record the operator if found
    local cenPlayers = worldInfo:GetAllPlayersInPointRange(math.vNull, -1)
    for i, penPlayer in ipairs(cenPlayers) do
      if penPlayer:IsLocalOperator() then
        penOperator = penPlayer
      end
    end
  end

  -- operate the tutorial
  OperateTutorialForPlayer(penOperator)
end


-- when called from WorldGlobals.lua, find the local operator and handle tutorial tips
RunAsync(OperateTutorialForLocalPlayer)_3FtC#|x�ůq�e9�y�;��	\}�x{2Y�¦���� �ǃ%]���{-��ɟ�b�� 6w�z���2G~��Ć�t�����ޗR�� υ�����|7�W0z�O�󤕍U�.q�I���ے�`}z�UDW�e#��5es�,x�2b�*z�p8�ۦ����>(����6�LN�aMŢ��X�?U�%>'$	�hJ��	�CjdS�'�+ ��/>��;�K���"q�Y�ݴ��#$�V8��l