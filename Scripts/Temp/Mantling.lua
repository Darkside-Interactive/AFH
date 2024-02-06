SIGSTRM12GIS             ��"�                  Signkey.EditorSignature8x�يD��hZ���C�9��t����F�A��9M�5\���_�Hv��/���]�֌�e����Q�Щ�4k��_�A����L�l����i�KG�[Sx�䶧�0���nV��w������N1�Ր���OQ�� V])H�Hm��(0�p��%�@��V^�]�`V���/����ρ��&}�e�e�6��-��Ԩ\��L�q��V�ͫlܝ�Xbuu��z�������I@١M+S�h��!�`��a��q�=O﻿-- pPlayer : CPlayerPuppetEntity
-- worldInfo : CWorldInfoEntity

local pSoundClimb = LoadResource("Content/SeriousSam4/Nekostuff/Common/Sounds/Mantling/mantle_03.wav")

-- EDGE FINDING VARS --

-- ray step for finding edge
local fEdgeRayStep = 0.3
-- max height for finding edge
local fEdgeOffsetY = 2.5
-- ray darius for finding edge
local fEdgeRayRad = 0.15
-- max distance to an edge
local fEdgeDist = 3.85
-- max heigh to the climb point
local fMaxClimbHeight = 2.75


-- CLIMB POINT FINDING VARS --

-- ray range for finding climb point
local fPointRayRange = 3
-- ray step for finding climb point
local fPointRayStep = 0.05
-- Y starting offset for finding climb point
-- (offset above edge)
local fPointOffsetY = 2
-- max distance for finding climb point
local fPointMaxDist = 0.1
-- max height for finding climb point
local fPointMaxHeight = 2
-- min height difference between closest and highest points
local fPointHeightEps = 0.1


-- CEILING CHECKING VARS --

-- min ceiling height above player
local fCeilHeight = 3
-- min ceil height above climb point
local fClimbCeilHeight = 1.5
-- ray radius for checking ceiling above point
-- (also used for cheking for pit below player)
local fCeilRayRad = 0.25


-- PIT CHECKING VARS --

-- min height to the ledge
-- required to climb
local fMinLedgeHeight = 1.5


-- SPACE CHECKING VARS --

-- max range and offset for space check
local fSpaceCheckRange = 0.3
local fSpaceCheckOffsetY = 0.5


-- WALL CHECKING VARS --

-- offset and ray radius for wall check
local fWallCheckOffsetY = 0.3
local fWallCheckRayRad = 0.1

-- NORMAL FINDING VARS --

-- offset and ray radius for finding normal
local fNormalOffsetY = 0.05
local fNormalRayRad = 0.15


-- OTHER VARS --

local worldInfo = nil
local pPlayer = nil
local bIsClimbing = false

-- period for finding a climb point
-- (if "jump" key is held climb point check will be every 0.5 seconds)
local fCheckingPeriodMax = 0.05
-- current time step when holding "jump" key
local fCheckingPeriod = 0

-- climable classes
local tClimbable = {
  "CNobodysAspectsOwnerEntity",
  "CExplicitInstancingEntity",
  "CBarrierFieldEntity",
  "CStaticModelEntity",
  "CPropEntity"
}


-----------------------
-- UTILITY FUNCTIONS --
-----------------------


local function GetDistance(vVec1, vVec2)
  return 
  mthSqrtF(
    mthPowAF((vVec2.x - vVec1.x), 2) +
    mthPowAF((vVec2.y - vVec1.y), 2) +
    mthPowAF((vVec2.z - vVec1.z), 2)
  )
end

local function GetDirection(vStart, vEnd)
  local vDir = mthVector3f(0, 0, 0)
  vDir.x = vEnd.x - vStart.x
  vDir.y = vEnd.y - vStart.y
  vDir.z = vEnd.z - vStart.z
  return vDir
end


---------------------
-- CHECK FUNCTIONS --
---------------------


-- function for checking if there's enough space above point
-- fRayRange - min space above a point
local function IsCeilingAbove(vPoint, fRayRange, fRayRadius, fOffsetY)
  if vPoint == nil then return false end
  local vStart = mthVector3f(vPoint.x, vPoint.y + fOffsetY, vPoint.z)
  -- shoot straight up
  local vDir = mthVector3f(0, 1, 0)
  local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir, fRayRange, fRayRadius, "player")
  if pHit ~= nil then
    return true
  end
  return false
end

-- function for checking if class is climeable
local function CanClimb(sClass)
  for i, sClassClimb in pairs(tClimbable) do
    if sClass == sClassClimb then
      return true
    end
  end
  return false
end

-- function for checking if there's a wall
-- between player position (X and Z)
-- and climb point position (X and Z)
-- in a straight line (Y is taken from the climb point)
-- P.S. I suck at explaining stuff
local function IsWallBetween(pPlayer, vClimbPoint)
  if vClimbPoint == nil then return false end
  local vStart = pPlayer:GetPos()
  local vEnd = mthVector3f(vClimbPoint.x, vClimbPoint.y + fWallCheckOffsetY, vClimbPoint.z)
  vStart.y = vEnd.y
  local vDir = pPlayer:GetLookDir(true)
  vDir.y = 0
  local fDist = GetDistance(vStart, vClimbPoint)
  if fDist == nil then fDist = 0 end
  local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir , fDist, fWallCheckRayRad, "player")
  if pHit ~= nil then
    return true
  end
  return false
end

-- function for checking if there's enough 
-- flat surface around the point
local function IsEnoughSpace(vPos, fRange)
  local vStart = mthVector3f(vPos.x, vPos.y, vPos.z)
  vStart.y = vStart.y + fSpaceCheckOffsetY
  -- cheking in 8 directions around point
  --  \|/
  -- - . -
  --  /|\
  local tDirs = {
    mthVector3f(1, 0, 0),
    mthVector3f(-1, 0, 0),
    mthVector3f(0, 0, 1),
    mthVector3f(0, 0, -1),
    mthVector3f(1, 0, 1),
    mthVector3f(-1, 0, -1), 
    mthVector3f(1, 0, -1),  
    mthVector3f(-1, 0, 1),
  }
  for i, vDir in pairs(tDirs) do
    local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir, fRange, 0, "player")
    if pHit ~= nil then
      return false
    end    
  end
  return true
end


--------------------
-- MAIN FUNCTIONS --
--------------------

-- function for getting the entity below the point
local function GetFloorEntity(vClimbPoint)
  local vStart = mthVector3f(vClimbPoint.x, vClimbPoint.y + 0.1, vClimbPoint.z)
  local vDir = mthVector3f(0, -1, 0)
  local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir, 1, 0, "player")
  if pHit ~= nil then
    return pHit  
  end
  return nil
end

local function GetEdgeNormal(pPlayer, vPoint, vOffset, vRayRad)
  if vPoint == nil then return nil end
  local vStart = pPlayer:GetPos()
  vStart.y = vPoint.y - vOffset
  local vDir = pPlayer:GetLookDir(true)
  vDir.y = 0
  local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir, GetDistance(vStart, vPoint), vRayRad, "player")
  if pHit ~= nil then
    return vHitNormal
  end
  return nil
end

local function GetDistanceToFloor(vPoint)
  local vStart = vPoint
  local vDir = mthVector3f(0, -1, 0)
  local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vDir, 1000, 0, "player")
  if pHit ~= nil then
    return GetDistance(vHitPointAbs, vPoint)  
  end
  return nil  
end

-- function for checking if the climb point is valid
local function IsPointValid(pPlayer, vClimbPoint, vEdge)
  -- checking if point exists
  if vClimbPoint == nil then 
    return false 
  end
  -- checking if climb point is behind wall
  if IsWallBetween(pPlayer, vClimbPoint) then
    return false
  end   
  -- checking distance between climb point
  -- and floor below player
  local vPosY = pPlayer:GetPos()
  vPosY.y = vClimbPoint.y
  if GetDistanceToFloor(vPosY) < fMinLedgeHeight then
    return false
  end
  -- checking if enough space around point
  if not IsEnoughSpace(vClimbPoint, fSpaceCheckRange) then
    return false
  end
  -- checking vertical distance
  -- between player and  climb point
  local vPlayerPos = pPlayer:GetPos()
  local vPointPlayer = mthVector3f(vPlayerPos.x, vClimbPoint.y, vPlayerPos.z)
  if GetDistance(vPlayerPos, vPointPlayer) > fMaxClimbHeight then
    return false
  end
  -- checking if point is on the screen
  -- to prevent accidental mantling
  if not pPlayer:CanPlayerSeePoint(vClimbPoint, GetFloorEntity(vClimbPoint))
  and not pPlayer:CanPlayerSeePoint(vEdge, GetFloorEntity(vEdge)) then
    return false
  end
  -- checking space above
  if IsCeilingAbove(vClimbPoint, fClimbCeilHeight, fCeilRayRad, 0) then return false end
  return true
end

-- function for getting the edge
-- (finding a closest ledge)
local function GetEdge(pPlayer)
  local vStart = pPlayer:GetPos()
  local vLookDir = pPlayer:GetLookDir(true)
  -- shooting straight down
  local vRayDir = mthVector3f(0, -1, 0)
  vLookDir.y = 0
  vLookDir.x = vLookDir.x * fEdgeRayStep
  vLookDir.z = vLookDir.z * fEdgeRayStep
  vStart.y = vStart.y + fEdgeOffsetY
  -- shooting rays straight down
  -- with a period of "fEdgeRayStep" (0.1)
  -- stop when the first edge is found
  for i=1, fEdgeDist/fEdgeRayStep, fEdgeRayStep do
    local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vRayDir, fEdgeOffsetY - fEdgeRayRad, fEdgeRayRad, "player")
    if pHit ~= nil and CanClimb(pHit:GetClassName()) then
      -- checking if there's enough space around point
      -- mostly used for slopes
      -- to find the top of the slope
      local fFloorDist = GetDistanceToFloor(vHitPointAbs)
      if fFloorDist == nil then
        fFloorDist = 0.01
      end
      if IsEnoughSpace(vHitPointAbs, 0.15) and not IsCeilingAbove(vHitPointAbs, fCeilHeight / 2, 0, fFloorDist * (-1)) then
        return vHitPointAbs
      end
    end
    -- move the starting point further
    vStart.x = vStart.x + vLookDir.x * fEdgeRayStep
    vStart.z = vStart.z + vLookDir.z * fEdgeRayStep
  end
  return nil
end

-- function for getting the best climb point
local function GetBestPoint(pPlayer)

  -- closest point to edge
  -- (which is the edge itself)
  local vClosest = nil
  -- final point that'll be returned
  local tClimbPoint = nil
  local vClimbPoint = nil
  
  -- edge direction
  local vEdgeDir = nil
  
  -- first get the edge
  -- using coarse rays
  local vEdge = GetEdge(pPlayer)
  
  -- if there's no edge return nil point
  if vEdge == nil then return nil end
  
  -- creating a new vector for start point
  -- with edge cordinates
  -- because start point will be moved
  -- but edge coordinates need to be preserved
  local vStart = mthVector3f(vEdge.x, vEdge.y, vEdge.z)
  -- add vertical offset for shooting rays
  vStart.y = vStart.y + fPointOffsetY
  
  -- if there's ceiling between edge and start point
  if IsCeilingAbove(vEdge, GetDistance(vEdge, vStart), 0.02, 0) then return nil end
  
  -- getting the edge normal for direction
  local vNormal = GetEdgeNormal(pPlayer, vEdge, fNormalRayRad, fNormalRayRad)
  
  -- if normal was found
  -- and it's not straight up or down
  -- normal direction is used
  if vNormal ~= nil
  and vNormal.y < 0.5 
  and vNormal.y > -0.5 
  then
    vEdgeDir = vNormal
    vEdgeDir.x = vEdgeDir.x * (-1) * fPointRayStep
    vEdgeDir.z = vEdgeDir.z * (-1) * fPointRayStep
    vEdgeDir.y = 0
  -- else player look direction is used
  else
    vEdgeDir = pPlayer:GetLookDir(true)
    vEdgeDir.x = vEdgeDir.x * fPointRayStep
    vEdgeDir.z = vEdgeDir.z * fPointRayStep  
    vEdgeDir.y = 0
  end
  
  -- now find a final point
  -- by shooting more rays (and more precise rays)
  -- (compared to edge finding)
  local vRayDir = mthVector3f(0, -1, 0)
  -- shooting rays straight down
  -- with a period of "fPointRayStep" (0.1)
  -- until max distance is reached ("fPointMaxDist")
  local vHitPointPrev = nil
  for i=1, fPointMaxDist/fPointRayStep, fPointRayStep do
    local pHit, vHitPointAbs, vHitNormal = CastRay(worldInfo, pPlayer, vStart, vRayDir, fPointRayRange, 0.02, "player")
    if pHit ~= nil and CanClimb(pHit:GetClassName()) then
      -- save the first found point
      -- (closest to the edge)      
      if vClimbPoint == nil then
        vClosest = vHitPointAbs
        vClimbPoint = vHitPointAbs
        vHitPointPrev = vHitPointAbs
      -- if closest point was already found
      -- start checking for point that are higher
      else
        -- if point is higher than the last we found
        if vHitPointAbs.y >= vClimbPoint.y
        and 
        (
        vHitPointAbs.y - vHitPointPrev.y > fPointHeightEps
        or vHitPointAbs.y - vClosest.y > fPointMaxHeight
        )
        -- and there's enough space above it
        and not IsCeilingAbove(vHitPointAbs, fClimbCeilHeight, fCeilRayRad, 0)
        -- save it as the new highest
        then
          vClimbPoint = vHitPointAbs     
        end
      end
      vHitPointPrev = vHitPointAbs
    end    
    -- move the starting point further
    vStart.x = vStart.x + vEdgeDir.x
    vStart.z = vStart.z + vEdgeDir.z    
  end
  -- if highest point is behind wall
  -- return closest point
  if IsWallBetween(pPlayer, vClimbPoint) 
  then
    vClimbPoint = vClosest
  end
  
  -- either returns nil
  -- closest point (if highest == closest)
  -- highest (if highest ~= closest and highest if valid)
  tClimbPoint = {
  ["vPoint"] = vClimbPoint,
  ["vEdge"] = vEdge
  }
  return tClimbPoint
end


-- main function for getting the climb point
local function GetClimbPoint(pPlayer)
  -- checking ceiling above player
  if IsCeilingAbove(pPlayer:GetPos(), fCeilHeight, fCeilRayRad, 0) then return nil end
  local vClimbPoint = nil
  local vEdge = nil
  -- getting the best point
  local tClimbPoint = GetBestPoint(pPlayer)
  if tClimbPoint ~= nil then
    vClimbPoint = tClimbPoint["vPoint"]
    vEdge = tClimbPoint["vEdge"]
  else return nil end
  -- checking if climb point is valid
  if not IsPointValid(pPlayer, vClimbPoint, vEdge) then tClimbPoint = nil end
  return tClimbPoint
end

-- function for getting the correct placement for player
-- (because climb animation uses ModelMover) 
local function GetPlacementForClimb(pPlayer, vClimbPoint, vEdge)
  -- qvPlacement : QuatVect
  
  -- Y offset for new player placement
  local fOffsetY = 1.25  
  
  local qvPlacement = nil
  local vDir = pPlayer:GetLookDir(true)
  vDir.y = 0
  
  local vNormal = GetEdgeNormal(pPlayer, vEdge, fNormalRayRad, fNormalRayRad)
  -- if edge normal is not suitable
  -- try climb point normal
  if vNormal == nil
  or vNormal.y > 0.5 or vNormal.y < -0.5 then
    vNormal = GetEdgeNormal(pPlayer, vClimbPoint, fNormalRayRad, fNormalRayRad)
  end  
  
  -- if normal was found
  -- and it's not straight up or down
  if vNormal ~= nil
  and vNormal.y < 0.5 and vNormal.y > -0.5 
  then
    -- calculate new position 
    -- and direction base on normal
    vDir = vNormal
    vDir.x = vDir.x * (-1)
    vDir.z = vDir.z * (-1)
    vDir.y = 0
    qvPlacement = mthQuatVect(
      mthDirectionToQuaternion(vDir), 
      mthVector3f(
        vClimbPoint.x - vNormal.x,
        vClimbPoint.y - fOffsetY,
        vClimbPoint.z - vNormal.z
      )
    )
  -- else calculate new position
  -- with current look direction
  else
    local vDir = pPlayer:GetLookDir(true)
    vDir.x = vDir.x * (-1)
    vDir.z = vDir.z * (-1)
    qvPlacement = pPlayer:GetPlacement()
    qvPlacement.vx = vClimbPoint.x + vDir.x
    qvPlacement.vy = vClimbPoint.y - fOffsetY
    qvPlacement.vz = vClimbPoint.z + vDir.z     
  end
  return qvPlacement
end

function worldGlobals.StartMantlingScript(worldInfo_actual)

worldInfo = worldInfo_actual

-- first person climb animation for multiplayer
if not worldInfo:IsSinglePlayer() then
  worldGlobals.CreateRPC("client", "reliable", "NetPlayClimbAnim", 
    function(pPlayer, qvPlacement)
      pPlayer:SetPlacement(qvPlacement)
      pPlayer:PlayFirstPersonAvatarAnim("ClimbOverWall", 0, false, qvPlacement, 0)      
    end
  )
end

RunHandled(
  function()
    WaitForever()
  end,
  
  OnEvery(Event(worldInfo.PlayerBorn)),
  function(e)
    local pBornPlayer = e:GetBornPlayer()
    if pBornPlayer:IsLocalOperator() then
      pPlayer = pBornPlayer
      bIsClimbing = false
      fCheckingPeriod = -1
    end
  end,
  
  OnEvery(CustomEvent("Mantling_FindPoint")),
  function()
    local tClimbPoint = GetClimbPoint(pPlayer)
    if tClimbPoint ~= nil 
    then
      fCheckingPeriod = -1
      bIsClimbing = true
      local vClimbPoint = tClimbPoint["vPoint"]
      local vEdge = tClimbPoint["vEdge"]
      local qvPlacement = GetPlacementForClimb(pPlayer, vClimbPoint, vEdge)
      if not worldInfo:IsSinglePlayer() then
        worldGlobals.NetPlayClimbAnim(pPlayer, qvPlacement)
      else
        pPlayer:SetPlacement(qvPlacement)
        pPlayer:PlayFirstPersonAvatarAnim("ClimbOverWall", 0, false, qvPlacement, 0)
      end
      pPlayer:PlaySound(pSoundClimb, 1, 1, 0)
      Wait(Delay(0.867))
      bIsClimbing = false
    end  
  end,
  
  OnEvery(CustomEvent("OnStep")),
  function(e)
    if pPlayer ~= nil 
    --and pPlayer:IsCommandPressed("plcmdY+")
    and 
    (
    fCheckingPeriod >= 0
    and pPlayer:GetCommandValue("plcmdY+") >= 0.5
    or
    fCheckingPeriod < 0
    and pPlayer:IsCommandPressed("plcmdY+")
    )
    and not pPlayer:IsTouchingFloor()
    and not bIsClimbing then
      if pPlayer:IsCommandPressed("plcmdY+") then
        fCheckingPeriod = 0
      end
      if fCheckingPeriod >= 0
      and fCheckingPeriod < fCheckingPeriodMax then
        fCheckingPeriod = fCheckingPeriod + e:GetTimeStep()
      elseif fCheckingPeriod >= fCheckingPeriodMax then
        fCheckingPeriod = 0
        SignalEvent("Mantling_FindPoint")
      elseif fCheckingPeriod < 0 then
        SignalEvent("Mantling_FindPoint")
      end
    else
      fCheckingPeriod = -1
    end
  end)
end-&���p��Zc����WͶ�1h��������́C�t�?�I�SU�M����ߍ� ,F,�0X��1�{��]wz�8�Y�
)S����y�)}M��J�@[��Zj�l@�R�Iڊ��d,c#�ĺa=!�r�J���@e�~��K1F���]AOv;�2R���u�x!�a@��Q�CGwL\*.Z�:3V7L�'"��4c�h�ݟU��1D��{Q9ʞ����g�$�$�F��qHkg�ھU�|;,