SIGSTRM12GIS             ʗa�                  Signkey.EditorSignature��7Wr�Ckr�ݰY��7̝�%bT��J<|�uԐ4�#6��u��twjI����|E��ё�\䒩�o�+�� j&�"��H4�A6�&:��p��$l����a�&}�|)�!iS��ei!���L$T��#�\�41���*:L�Ƅmm���'5ε }�^ec�~L Ț��S������Ȍi�s_"���<��1����������PC/�����m/l;h���W�M�)dҜ�K�s!Y��0�&o�p�﻿local worldInfo = worldGlobals.worldInfo


-- penModel : CStaticModelEntity

function worldGlobals.LerpModelStretch(penModel, FromStretch, ToStretch)
  RunAsync(function()
    local tmStart = worldInfo:SimNow()
    local fTimePassed = 0
    local fTimeTotal = fSpeed or 0.169    
    
    local fStartOffset = FromStretch
    local fEndOffset = ToStretch
    
    worldGlobals.tmLastStartBarOffset = tmStart 
    
    while fTimePassed < fTimeTotal and tmStart == worldGlobals.tmLastStartBarOffset do
      fTimePassed = timToFloat(worldInfo:SimNow() - tmStart)
      local fTimeRatio = mthClampF(fTimePassed / fTimeTotal, 0, 1)
      local fOffsetRatio = mthLerpF(fStartOffset, fEndOffset, fTimeRatio)
      
      penModel:SetModelStretch(fOffsetRatio)            
      Wait(CustomEvent("OnStep"))
    end   
    
    SignalEvent("LerpModelFinished")
    conInfoF("[AFH]: Finished lerping model's stretch\n")
  end)
end��9-@�3�2V�EX9sG&�'0��h��+z���u|�[:6�w]"��������7�^��2�2^�McOH�]Z�8�2�m��a��v�B��ꮲ{�0 �����v# K����-գ4���Ӿ����t�4�*�'�;�����,���B@�^|IЙ���ئ��O�+0�W�D�Z�~���V����cԝ!�H9�{ou�F\a���D\�Z8m����h�f��-�Χ��`��y�FDqh��JoE�jӰ�