
--- <Moving>

local insert, remove, sort = table.insert, table.remove, table.sort
Moving = {}


function Moving:goToBrakmar(mapID, onMapFn)
    if not getCurrentAreaName():find("Brâkmar") then
        if map:currentMapId() == tonumber(havenbagID) then
            return map:changeMap(zBrak)
        else
            return map:changeMap("havenbag")
        end
    else
        if map:currentMapId() ~= mapID then
            return map:moveToward(mapID)
        else
            if onMapFn then
                return onMapFn()
            end
        end
    end
end

function Moving:goAstrubBank(inBankCallback)
    if map:currentSubArea() == "Canyon sauvage" then
        return
        {
            {map = "-16,11", path = "top"},
            {map = "-16,10", path = "left"},
            {map = "-17,10", path = "bottom"},
            {map = "-17,11", path = "left"},
            {map = "-18,11", path = "bottom"},
            {map = "-18,12", path = "left"},
            {map = "-19,12", path = "top(6)"},
            {map = "-19,11", path = "top"},
            {map = "-19,10", path = "right"},
            {map = "-18,10", path = "top"},
            {map = "-18,9", path = "right"},
            {map = "-19,9", path = "right"},
            {map = "-17,9", path = "top"},
            {map = "-17,8", path = "top"},
        }
    elseif getCurrentAreaName() == "Île du Minotoror" then 
        return
        {
            {map = "34476296", custom = function() npc:npc(783, 3) npc:reply(-2) npc:reply(-1) end},
            {map = "-43,-17", path = "bottom"},
            {map = "-43,-18", path = "bottom"},
            {map = "-43,-19", path = "bottom"},
            {map = "-40,-19", path = "bottom"},
            {map = "-40,-18", path = "bottom"},
            {map = "-40,-17", path = "bottom"},
            {map = "-40,-16", path = "left"},
            {map = "-41,-16", path = "left"},
            {map = "-42,-16", path = "left"},
            {map = "-41,-17", path = "left"},
            {map = "-41,-18", path = "left"},
            {map = "-42,-18", path = "left"},
            {map = "-42,-17", path = "top"},
            {map = "-41,-19", path = "left"},
            {map = "-42,-19", path = "left"},
            {map = "-43,-16", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) end}
        } 
    elseif map:onMap("11,10") then
        map:changeMap("left")
    end
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end
    if not getCurrentAreaName():find("Astrub") then
        if map:currentMapId() == tonumber(BANK_MAPS.idHavenbag) then
            return map:changeMap(BANK_MAPS.zAstrub)
        else
            return map:changeMap("havenbag")
        end
    else
        if map:currentMapId() ~= tonumber(BANK_MAPS.bankAstrubInt) then
            return map:moveToward(tonumber(BANK_MAPS.bankAstrubInt))
        else
            if inBankCallback then
                return inBankCallback()
            end
        end
    end
end


--- </Moving>