dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local NbToCraft = 1

local CraftCordonier = {
    {Name = "Ceinture Akwadala", Id = 7238, Type = "Ceinture", ListIdCraft = {{Id = 288, Nb = 10}, {Id = 1891, Nb = 12}, {Id = 2613, Nb = 12}, {Id = 417, Nb = 12}}, NbToCraft = 4},
    {Name = "Geta Akwadala", Id = 7242, Type = "Bottes", ListIdCraft = {{Id = 1778, Nb = 15}, {Id = 476, Nb = 30}, {Id = 13728, Nb = 14}}, NbToCraft = 4},
}

local CraftBijoutier = {
    {Name = "Amulette Akwadala", Id = 7250, Type = "Amulette", ListIdCraft = {{Id = 7013, Nb = 22}, {Id = 367, Nb = 5}, {Id = 1455, Nb = 19}, {Id = 13502, Nb = 17}}, NbToCraft = 4},
    {Name = "Alliance Akwadala", Id = 7246, Type = "Anneau", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 6897, Nb = 12}, {Id = 747, Nb = 3}, {Id = 2358, Nb = 12}}, NbToCraft = 4},
}

local CraftTailleur = {
    {Name = "Chapeau Akwadala", Id = 7226, Type = "Chapeau", ListIdCraft = {{Id = 9940, Nb = 4}, {Id = 17100, Nb = 1}, {Id = 367, Nb = 4}, {Id = 17062, Nb = 15}}, NbToCraft = 4},
    {Name = "Cape Akwadala", Id = 7230, Type = "Cape", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 378, Nb = 12}, {Id = 380 , Nb = 30}, {Id = 15568, Nb = 1}}, NbToCraft = 4},
}

local Tablestuffs = {
    {Name = "Chapeau Akwadala", Id = 7226, Type = "Chapeau", ListIdCraft = {{Id = 9940, Nb = 4}, {Id = 17100, Nb = 1}, {Id = 367, Nb = 4}, {Id = 17062, Nb = 15}}, PodsNeededToCraft = 24},
    {Name = "Cape Akwadala", Id = 7230, Type = "Cape", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 378, Nb = 12}, {Id = 380 , Nb = 30}, {Id = 15568, Nb = 1}}, PodsNeededToCraft = 68},
    {Name = "Ceinture Akwadala", Id = 7238, Type = "Ceinture", ListIdCraft = {{Id = 288, Nb = 10}, {Id = 1891, Nb = 12}, {Id = 2613, Nb = 12}, {Id = 417, Nb = 12}}, PodsNeededToCraft = 58},
    {Name = "Geta Akwadala", Id = 7242, Type = "Bottes", ListIdCraft = {{Id = 1778, Nb = 15}, {Id = 476, Nb = 30}, {Id = 13728, Nb = 14}, }, PodsNeededToCraft = 179},
    {Name = "Alliance Akwadala", Id = 7246, Type = "Anneau", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 6897, Nb = 12}, {Id = 747, Nb = 3}, {Id = 2358, Nb = 12}}, PodsNeededToCraft = 103},
    {Name = "Amulette Akwadala", Id = 7250, Type = "Amulette", ListIdCraft = {{Id = 7013, Nb = 22}, {Id = 367, Nb = 5}, {Id = 1455, Nb = 19}, {Id = 13502, Nb = 17}}, PodsNeededToCraft = 170},

    {Name = "Caracoiffe", Id = 2531, Type = "Chapeau", ListIdCraft = {{Id = 997, Nb = 6}, {Id = 17092, Nb = 15}, {Id = 2624, Nb = 25}, {Id = 15572, Nb = 1}}, PodsNeededToCraft = 65},
    {Name = "Caracape", Id = 2532, Type = "Cape", ListIdCraft = {{Id = 13489, Nb = 10}, {Id = 17104, Nb = 1}, {Id = 2618 , Nb = 20}, {Id = 7059, Nb = 30}}, PodsNeededToCraft = 61},
    {Name = "Ceinture Tortue Bleue", Id = 2683, Type = "Ceinture", ListIdCraft = {{Id = 1002, Nb = 18}, {Id = 997, Nb = 4}, {Id = 2624, Nb = 13}, {Id = 2613, Nb = 20}}, PodsNeededToCraft = 79},
    {Name = "Boufbamu", Id = 10836, Type = "Amulette", ListIdCraft = {{Id = 385, Nb = 6}, {Id = 887, Nb = 18}, {Id = 1777, Nb = 19}, {Id = 15573, Nb = 1}}, PodsNeededToCraft = 44},
    {Name = "Gelano", Id = 2469, Type = "Anneau", ListIdCraft = {{Id = 2437, Nb = 2}, {Id = 757, Nb = 20}, {Id = 9940, Nb = 6}, {Id = 15585, Nb = 1}, {Id = 2242, Nb = 2}}, PodsNeededToCraft = 31},
    {Name = "Abranneau Mou", Id = 1559, Type = "Anneau", ListIdCraft = {{Id = 401, Nb = 30}, {Id = 463, Nb = 6}, {Id = 435, Nb = 15}, {Id = 432, Nb = 12}}, PodsNeededToCraft = 111},
    {Name = "Bottes de l'Eleveur de Bouftous", Id = 6470, Type = "Bottes", ListIdCraft = {{Id = 460, Nb = 20}, {Id = 1777, Nb = 22}, {Id = 9940, Nb = 5}, {Id = 15573, Nb = 1}, {Id = 1771, Nb = 26} }, PodsNeededToCraft = 180},

    {Name = "Abracaska", Id = 2410, Type = "Chapeau", ListIdCraft = {{Id = 1694, Nb = 7}, {Id = 11253, Nb = 36}, {Id = 15259, Nb = 2}, {Id = 2267, Nb = 30}, {Id = 437, Nb = 30}, {Id = 15565, Nb = 1}}, PodsNeededToCraft = 201},
    {Name = "Abracapa Ancestrale", Id = 8464, Type = "Cape", ListIdCraft = {{Id = 13492, Nb = 12}, {Id = 15565, Nb = 1}, {Id = 15259 , Nb = 3}, {Id = 7016, Nb = 45}, {Id = 8249, Nb = 36}, {Id = 13698, Nb = 30}}, PodsNeededToCraft = 310},
    {Name = "Torque Ancestral", Id = 8465, Type = "Amulette", ListIdCraft = {{Id = 15743, Nb = 9}, {Id = 1612, Nb = 36}, {Id = 15565, Nb = 1}, {Id = 15259, Nb = 3}, {Id = 13528, Nb = 32}, {Id = 7655, Nb = 10}}, PodsNeededToCraft = 193},
    {Name = "Anneau Ancestral", Id = 8466, Type = "Anneau", ListIdCraft = {{Id = 1694, Nb = 12}, {Id = 15565, Nb = 1}, {Id = 15259, Nb = 2}, {Id = 8066, Nb = 36}, {Id = 13724, Nb = 32}, {Id = 2267, Nb = 25}}, PodsNeededToCraft = 31},
}

local function CanSellItem(Id)
    for _, element in ipairs(Tablestuffs) do
        if Id == element.Id then
            return true
        end
    end
    return false
end

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

local DebutDeScript = true

function move()

    if DebutDeScript then
        DebutDeScript = false
        inventory:openBank()

        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end

        for _, item in ipairs(CraftCordonier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftBijoutier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftTailleur) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        global:leaveDialog()
        global:delay(1000)
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
