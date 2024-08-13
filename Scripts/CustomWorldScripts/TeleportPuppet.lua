function worldGlobals.TeleportPuppet(penPuppet, penTeleportSound, penMarker, bSpawnEffect)
  penTeleportSound:PlayOnce()
  penTeleportSound:SetParent(penPuppet, "")
    worldGlobals.worldInfo:StartOverlayFade(0.5, 2, 0.7, 255,255,255, "OVFF_LOCAL")
      Wait(Delay(1.565))
        if(penMarker) == nil then
          conErrorF("[AFH]: Attempt to teleport 'CPlayerPuppetEntity' to unexisted point!\n")
        end
        if(bSpawnEffect) ~= nil then
          penPuppet:Teleport(penMarker, bSpawnEffect)
        else
          conErrorF("[AFH]: Invalid argument in boolean 'bSpawnEffect'! Should be true or false.\n")
        end
     conInfoF("[AFH]: Successfully teleported to "..penMarker:GetName().." point.\n")
end