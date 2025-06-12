dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local NbToCraft = 1
local ScriptStarting = true

local goToAtelierCordo = {
    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-20", path = "left" },
    { map = "6,-21", path = "left" },
    { map = "5,-19", path = "left" },
    { map = "6,-19", path = "left" },
    { map = "6,-18", path = "left" },
    { map = "6,-17", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "6,-15", path = "left" },
    { map = "5,-15", path = "left" },
    { map = "5,-16", path = "left" },
    { map = "5,-17", path = "left" },
    { map = "5,-18", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "5,-22", path = "left" },
    { map = "5,-21", path = "left" },
    { map = "4,-22", path = "left" },
    { map = "4,-21", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "4,-19", path = "left" },
    { map = "4,-18", path = "left" },
    { map = "4,-17", path = "left" },
    { map = "84674566", path = "left" },
    { map = "83887104", path = "396"},
    { map = "4,-15", path = "left" },
    { map = "3,-14", path = "left" },
    { map = "3,-15", path = "left" },
    { map = "3,-16", path = "left" },
    { map = "3,-17", path = "left" },
    { map = "3,-18", path = "left" },
    { map = "3,-19", path = "left" },
    { map = "3,-20", path = "left" },
    { map = "3,-21", path = "left" },
    { map = "3,-22", path = "left" },
    { map = "2,-22", path = "left" },
    { map = "2,-21", path = "left" },
    { map = "2,-20", path = "left" },
    { map = "2,-19", path = "left" },
    { map = "2,-18", path = "left" },
    { map = "2,-17", path = "left" },
    { map = "2,-14", path = "top" },
    { map = "1,-14", path = "top" },
    { map = "0,-14", path = "top" },
    { map = "-1,-15", path = "top" },
    { map = "1,-15", path = "top" },
    { map = "0,-15", path = "top" },
    { map = "2,-15", path = "top" },
    { map = "-1,-14", path = "top" },
    { map = "-1,-16", path = "top" },
    { map = "0,-16", path = "top" },
    { map = "1,-16", path = "top" },
    { map = "2,-16", path = "top" },
    { map = "-1,-17", path = "top" },
    { map = "-1,-18", path = "top" },
    { map = "0,-17", path = "top" },
    { map = "0,-18", path = "top" },
    { map = "0,-19", path = "top" },
    { map = "0,-20", path = "top" },
    { map = "-1,-20", path = "top" },
    { map = "-1,-19", path = "top" },
    { map = "1,-18", path = "top" },
    { map = "1,-19", path = "top" },
    { map = "1,-20", path = "top" },
    { map = "1,-21", path = "left" },
    { map = "1,-22", path = "left" },
    { map = "-1,-21", path = "right" },
    { map = "0,-22", path = "bottom" },
    { map = "1,-17", path = "left" },
    { map = "84672513", door = "315" },
    { map = "83627008", custom = function ()
        npc:npc(597, 3)
        npc:reply(-2)
        npc:reply(-1)
        global:leaveDialog()
        map:moveToCell(325)
    end}
}

local goToAtelierBijoutier = {
    { map = "-1,-22", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-14", path = "right" },
    { map = "4,-22", path = "bottom" },
    { map = "5,-22", path = "bottom" },
    { map = "5,-21", path = "bottom" },
    { map = "6,-21", path = "bottom" },
    { map = "7,-21", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "4,-20", path = "bottom" },
    { map = "5,-20", path = "bottom" },
    { map = "6,-20", path = "bottom" },
    { map = "7,-20", path = "bottom" },
    { map = "7,-19", path = "bottom" },
    { map = "6,-19", path = "bottom" },
    { map = "5,-19", path = "bottom" },
    { map = "4,-19", path = "bottom" },
    { map = "4,-18", path = "bottom" },
    { map = "5,-18", path = "bottom" },
    { map = "6,-18", path = "bottom" },
    { map = "7,-18", path = "bottom" },
    { map = "5,-17", path = "bottom" },
    { map = "6,-17", path = "bottom" },
    { map = "7,-17", path = "bottom" },
    { map = "4,-17", path = "bottom" },
    { map = "4,-15", path = "right" },
    { map = "4,-16", path = "right" },
    { map = "5,-15", path = "top" },
    { map = "6,-15", path = "top" },
    { map = "7,-15", path = "top" },
    { map = "7,-16", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "84675078", door = "371" },
    { map = "83625986", custom = function ()
        npc:npc(462, 3)
        npc:reply(-3)
        npc:reply(-1)
        global:leaveDialog()
        map:moveToCell(397)
    end },
}

local CraftCordonier = {
    {Name = "Ceinture Tortue Bleue", Id = 2683, Type = "Ceinture", ListIdCraft = {{Id = 1002, Nb = 18}, {Id = 997, Nb = 4}, {Id = 2624, Nb = 13}, {Id = 2613, Nb = 20}}},
    {Name = "Bottes de l'Eleveur de Bouftous", Id = 6470, Type = "Bottes", ListIdCraft = {{Id = 460, Nb = 20}, {Id = 1777, Nb = 22}, {Id = 9940, Nb = 5}, {Id = 15573, Nb = 1}, {Id = 1771, Nb = 26}}},
}

local CraftBijoutier = {
    {Name = "Boufbamu", Id = 10836, Type = "Amulette", ListIdCraft = {{Id = 385, Nb = 6}, {Id = 748, Nb = 1}, {Id = 887, Nb = 15}, {Id = 15573, Nb = 1}}},
    {Name = "Gelano", Id = 2469, Type = "Anneau", ListIdCraft = {{Id = 2437, Nb = 2}, {Id = 757, Nb = 20}, {Id = 9940, Nb = 6}, {Id = 15585, Nb = 1}, {Id = 2242, Nb = 2}}},
    {Name = "Abranneau Mou", Id = 1559, Type = "Anneau", ListIdCraft = {{Id = 401, Nb = 30}, {Id = 463, Nb = 6}, {Id = 435, Nb = 15}, {Id = 432, Nb = 12}}},
}

local CraftTailleur = {
    {Name = "Caracoiffe", Id = 2531, Type = "Chapeau", ListIdCraft = {{Id = 997, Nb = 6}, {Id = 17092, Nb = 15}, {Id = 2624, Nb = 25}, {Id = 15572, Nb = 1}}},
    {Name = "Caracape", Id = 2532, Type = "Cape", ListIdCraft = {{Id = 13489, Nb = 10}, {Id = 17104, Nb = 1}, {Id = 2618 , Nb = 20}, {Id = 7059, Nb = 30}}},
}

local TableStuffs = {
    {Name = "Caracoiffe", Id = 2531, Type = "Chapeau", ListIdCraft = {{Id = 997, Nb = 6}, {Id = 17092, Nb = 15}, {Id = 2624, Nb = 25}, {Id = 15572, Nb = 1}}},
    {Name = "Caracape", Id = 2532, Type = "Cape", ListIdCraft = {{Id = 13489, Nb = 10}, {Id = 17104, Nb = 1}, {Id = 2618 , Nb = 20}, {Id = 7059, Nb = 30}}},
    {Name = "Boufbamu", Id = 10836, Type = "Amulette", ListIdCraft = {{Id = 385, Nb = 6}, {Id = 887, Nb = 18}, {Id = 1777, Nb = 19}, {Id = 15573, Nb = 1}}},
    {Name = "Gelano", Id = 2469, Type = "Anneau", ListIdCraft = {{Id = 2437, Nb = 2}, {Id = 757, Nb = 20}, {Id = 9940, Nb = 6}, {Id = 15585, Nb = 1}, {Id = 2242, Nb = 2}}},
    {Name = "Abranneau Mou", Id = 1559, Type = "Anneau", ListIdCraft = {{Id = 401, Nb = 30}, {Id = 463, Nb = 6}, {Id = 435, Nb = 15}, {Id = 432, Nb = 12}}},
    {Name = "Ceinture Tortue Bleue", Id = 2683, Type = "Ceinture", ListIdCraft = {{Id = 1002, Nb = 18}, {Id = 997, Nb = 4}, {Id = 2624, Nb = 13}, {Id = 2613, Nb = 20}}},
    {Name = "Bottes de l'Eleveur de Bouftous", Id = 6470, Type = "Bottes", ListIdCraft = {{Id = 460, Nb = 20}, {Id = 1777, Nb = 22}, {Id = 9940, Nb = 5}, {Id = 15573, Nb = 1}, {Id = 1771, Nb = 26}}},
}

local TableOutilAtelier = {
    ["Cape"] = {ElementId = 455865, Rep = -1},
    ["Sac à dos"] = {ElementId = 455865, Rep = -2},
    ["Chapeau"] = {ElementId = 455866, Rep = -1},
    ["Amulette"] = {ElementId = 455835, Rep = -2},
    ["Anneau"] = {ElementId = 455835, Rep = -1},
    ["Bottes"] = {ElementId = 455863, Rep = -2},
    ["Ceinture"] = {ElementId = 455863, Rep = -1},
    ["Dague"] = {ElementId = 455861, Rep = -1},
    ["Marteau"] = {ElementId = 455861, Rep = -2},
    ["Epee"] = {ElementId = 455861, Rep = -3},
    ["Pelle"] = {ElementId = 455861, Rep = -4},
    ["Hache"] = {ElementId = 455861, Rep = -5},
    ["Baton"] = {ElementId = 455854, Rep = -1},
    ["Baguette"] = {ElementId = 455854, Rep = -2},
    ["Arc"] = {ElementId = 455854, Rep = -3},
    ["Potion"] = {ElementId = 455659, Rep = -1},
}


local function ProcessCraft(table, cellId, jobId)
    for _, element in ipairs(table) do
        if inventory:itemCount(element.Id) < NbToCraft then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9

            local PodsNeededToCraft = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Nb
            end

            local CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, NbToCraft - inventory:itemCount(element.Id)))

            global:printSuccess("go Craft " .. CraftQuantity .. " x " ..  element.Name)

            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end

            global:delay(500)
            map:useById(TableOutilAtelier[element.Type].ElementId, TableOutilAtelier[element.Type].Rep)
            global:delay(500)

            for _, item in ipairs(element.ListIdCraft) do
                craft:putItem(item.Id, item.Nb)
                global:delay(200)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(200)
            CraftReady()
            global:printSuccess("Craft effectué !")
            global:leaveDialog()

            global:delay(500)
            return ProcessCraft(table, cellId, jobId)
        end
    end

    map:moveToCell(cellId)
end

local goToAtelierCordoBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-34,-61", path = "zaapi(146234)" },
    { map = "-29,-56", path = "zaapi(146234)" },
    { map = "-28,-55", path = "zaapi(146234)" },
    { map = "-28,-61", path = "zaapi(146234)" },
    { map = "-29,-53", path = "zaapi(146234)" },
    { map = "-32,-56", path = "zaapi(146234)" },
    { map = "146234", door = "352" },
}

local goToAtelierBijoutierBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-29,-56", path = "zaapi(148797)" },
    { map = "-29,-58", path = "zaapi(148797)" },
    { map = "-28,-55", path = "zaapi(148797)" },
    { map = "-28,-61", path = "zaapi(148797)" },
    { map = "-29,-53", path = "zaapi(148797)" },
    { map = "-32,-56", path = "zaapi(148797)" },
    { map = "148797", door = "510" },
}

local goToAtelierTailleurBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "-34,-61", path = "zaapi(146232)" },
    { map = "-29,-58", path = "zaapi(146232)" },
    { map = "-28,-55", path = "zaapi(146232)" },
    { map = "-28,-61", path = "zaapi(146232)" },
    { map = "-29,-53", path = "zaapi(146232)" },
    { map = "-32,-56", path = "zaapi(146232)" },
    { map = "-29,-56", path = "zaapi(146232)"},
    { map = "146232", door = "329" },
}

local function PopoBonta()
    if map:currentArea() ~= "Bonta" then
        if inventory:itemCount(6965) == 0 then
            npc:npcBuy()
            global:delay(500)
            sale:buyItem(6965, 1, 1000)
            if inventory:itemCount(6965) == 0 then
                sale:buyItem(6965, 10, 10000)
            end
            global:delay(500)
            global:leaveDialog()
            global:delay(500)
        end
        inventory:useItem(6965)
    end
end

local function TreatMapBonta(maps)

    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    PopoBonta()
end


function move()
    if ScriptStarting then
        inventory:openBank()

        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end
        
        for _, item in ipairs(CraftBijoutier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)))
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftCordonier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)))
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftTailleur) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)))
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        global:leaveDialog()

        ScriptStarting = false
    end

    for _, item in ipairs(CraftCordonier) do
        if inventory:itemCount(item.Id) < NbToCraft then
            if not map:onMap(7864328) then
                return TreatMapBonta(goToAtelierCordoBonta)
            else
                ProcessCraft(CraftCordonier, 424, 15)
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if inventory:itemCount(item.Id) < NbToCraft then
            if not map:onMap(3145733) then
                return TreatMapBonta(goToAtelierBijoutierBonta)
            else
                ProcessCraft(CraftBijoutier, 396, 16)
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if inventory:itemCount(item.Id) < NbToCraft then
            if not map:onMap(7864327) then
                return TreatMapBonta(goToAtelierTailleurBonta)
            else
                ProcessCraft(CraftTailleur, 396, 27)
            end
        end
    end

    if inventory:itemCount(14993) < NbToCraft or inventory:itemCount(13781) < NbToCraft then
        npc:npcBuy()
        for i = 1, NbToCraft do
            if inventory:itemCount(14993) < NbToCraft then
                sale:buyItem(14993, 1, 10000)
            end
            if inventory:itemCount(13781) < NbToCraft then
                sale:buyItem(13781, 1, 70000)
            end
            if inventory:itemCount(13766) < NbToCraft then
                sale:buyItem(13766, 1, 70000)
            end
        end
    
        global:leaveDialog()
        global:printSuccess("bouclier/trophé acheté")
    end

    if map:currentArea() ~= "Astrub" then
        PopoRappel()
        inventory:openBank()
        exchange:putAllItems()
        global:leaveDialog()
    end

    if not map:onMap(83887104) then
        GoTo("84674566", function()
            map:door(303)
            global:disconnect()
        end)
    else
        global:disconnect()
    end
end
