
local function Equip()
	global:printSuccess("dab de panneau")
    developer:sendMessage('{"call":"sendMessage","data":{"type":"InventoryPresetUseMessage","data":{"presetId":0}}}')
end

function move()

    if map:onMap("1,-21") == true then
        global:printSuccess("Boucle terminée")
    end
    
    if character:level() == 43 then
        global:printSuccess("Niveau 43")
        --global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\xxx.lua") -- script pas encore fait
    end



    return {
        { map = "1,-21", path = "bottom" },
        { map = "1,-20", path = "left" },
        { map = "0,-20", path = "left" },
        { map = "-1,-20", path = "left" },
        { map = "-2,-20", path = "bottom", fight = true },
        { map = "-2,-19", path = "bottom", fight = true },
        { map = "-2,-18", path = "bottom", fight = true },
        { map = "-2,-17", path = "bottom", fight = true },
        { map = "-2,-16", path = "bottom", fight = true },
        { map = "-2,-15", path = "bottom", fight = true },
        { map = "-2,-14", path = "bottom", fight = true },
        { map = "-2,-13", path = "left", fight = true },
        { map = "-3,-13", path = "top", fight = true },
        { map = "-3,-14", path = "top", fight = true },
        { map = "-3,-16", path = "top", fight = true },
        { map = "-3,-15", path = "top", fight = true },
        { map = "-3,-18", path = "top", fight = true },
        { map = "-3,-17", path = "top", fight = true },
        { map = "-3,-19", path = "top", fight = true },
        { map = "-3,-20", path = "right", fight = true },     
    }
  end
  
  
  function bank()
    return {
    }
  end
  