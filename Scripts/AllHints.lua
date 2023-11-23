SIGSTRM12GIS             9��        #   st564310,sv552450,sv552460,sv567670      Signkey.EditorSignature���`�Z���N'
�[���o֯����+��cbn�E��N��٥e=���߁tkȱ_2hB o��d�5��L�HٻP|���� ԋ��u��k^��%^�R�(�dFYA x�c1�[�Y�g�%�j0�E��ް'�Z��,��N�M��xm��:5E�MjǬ-	����yc�[��H���K�nhuͬ�7b��jS�aGw�F^�*iGAB� ��NA��I+	S�9h����g:P���xc��rq�ES��z+﻿function globals.GetHints(bLoadingScreen, worldFileName, gameMode, killerCharacter, killerCharacterClass, damageType)

  local campaignGameModes = {"BeastHunt", "Cooperative", "CooperativeCoinOp", "CooperativeStandard", "SinglePlayer", "TeamBeastHunt"}

  local hintEntries = 
  {
    { -- Intro hint
      hints = {
        "TTRS:AFH_LoadingScreenMessage_00b=OCTOBER 26/2114 \ SOMEWHERE IN THE ASS OF WORLD\nWe are testing our new teleportation technology. Today I will be the first test pilot of one of our teleports. The main thing is not to get lost where this shit takes me.",
        
      },
      levelLoading = {
        -- should only be active for these levels
        levels = {"01_AntinomyOfNewWorld"},
      }
    },    
    { -- Skyrim hint
      hints = {
        "TTRS:AFH_LoadingScreenMessage_01=OCTOBER 28/2114 \ SKYRIM, SALAIR RIDGE\nSome time ago it was an amazing place, striking with its beauties. We still don't know who called this place ''SKYRIM'', but we got tired of this name. But it's hard to realize that people used to live here. Damn mental.",
        
      },
      levelLoading = {
        -- should only be active for these levels
        levels = {"02_GoshaLox0", "03_GoshaLox1", "05_GoshaLox2"},
      }
    },
    { -- Hints for beginning
      hints = {
        "TTRS:AFH_LoadingScreenMessage_02=WEST SIBERIA, OCTOBER 26/2114 \nTimes are changing, people are leaving, and some are coming. They are consumed by the cold in which they get stuck. That is why cold is a serious problem that needs to be solved once and for all. We are going to Southern Siberia.",
        
      },
      levelLoading = {
        -- should only be active for this level
        levels = {"01_GoshaLox"},
      }
    },
    { -- Hints for artificial world
      hints = {
        "TTRS:AFH_LoadingScreenMessage_03=qFXG5r}jD&@lH4>2jT%PqnF|o!BOY8*UM[{\*}L1M7%gwBrt\:3lz\nxK_/mItDU?D2OTZxV,lU(A6qFXG5r}jD&@lH4>2jT%PqnF|o!BOY8*UM[{\*}L1M7%gwBrt\:3lz\nxK_/mItDU?D2OTZxV,lU(A6",
    },
      levelLoading = {
        -- should only be active for this level
        levels = {"06_GoshaLox3"},
      }
    },
    {
      hints = {
        "TTRS:AFH_LoadingScreenMessage_04=",
    },
      levelLoading = {
        -- should only be active for this level
        levels = {"07_GoshaLox2b", "08_GoshaLox4b"},
      }
    },
    {
      hints = {
        "TTRS:AFH_LoadingScreenMessage_05=ON THE APPROACH TO WEST SIBERIA \ MAY 15, 2115\nThat's what happens if you talk a lot and don't listen. Skyrim is dead. And it doesn't exist anymore. I hope Vasya will take me safely. I'm feeling a little bad...",
    },
      levelLoading = {
        levels = {"08_GoshaLox4"},
      }
    },
    {
      hints = {
        "TTRS:AFH_LoadingScreenMessage_06=WEST SIBERIA \ MAY 16, 2115\nVasily died. Looks like I'm alone on this island. Well, all is not lost. I have a cool shotgun and a snowmobile, as well as the hope of seeing my childhood best friend Royce. I hope this isn't another trap.",
    },
      levelLoading = {
        levels = {"08_GoshaLox4c"},
      }
    }    
  }
  local function IsInArray(array, value)
    for _, v in ipairs(array) do
      if v == value then
        return true
      end
    end
    return false
  end
  
  -- function body
  local resultHints = {}
  
  -- if called for loading screen
  if bLoadingScreen == 1 then
    -- searching for loading screen hints
    for _, hintEntry in ipairs(hintEntries) do
      local entryLevelLoading = hintEntry.levelLoading
      -- if hint entry is eligble
      if entryLevelLoading ~= nil
        and (entryLevelLoading.gameModes == nil or IsInArray(entryLevelLoading.gameModes, gameMode))
        and (entryLevelLoading.levels == nil or IsInArray(entryLevelLoading.levels, worldFileName))
        and (entryLevelLoading.customFunc == nil or entryLevelLoading.customFunc()) then
        
        -- add all of its hints to result hints
        for i, hint in ipairs(hintEntry.hints) do
          table.insert(resultHints, hint)
        end
      end
    end
  -- else, called for player being killed
  else
    -- searching for death screen hints
    for _, hintEntry in ipairs(hintEntries) do
      local entryKilled = hintEntry.killed
      -- if hint entry is eligble
      if entryKilled ~= nil
        and (entryKilled.killerCharacters == nil or IsInArray(entryKilled.killerCharacters, killerCharacter))
        and (entryKilled.customFunc == nil or entryKilled.customFunc()) then
        
        -- add all of its hints to result hints
        for i, hint in ipairs(hintEntry.hints) do
          table.insert(resultHints, hint)
        end
      end
    end
  end
  return unpack(resultHints)
end�$]j4PjT"���/�s�Sl㚮����QA�~�n��h��_�|O�j�<'�1���rsج���l��{x�L�%E�w/�N(�U6g~��hX�c�	T�9�8�����%nq�o�d �_�S��h���J)������ܒ������c ��Wm�U�c����������-n5d�teK��,fѧ�T�ɣD\EuQ�����8���r�4�h������Ңˏ����|9�/��9�%���.rGd�� gEO