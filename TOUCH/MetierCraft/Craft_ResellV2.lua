dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


local TableItem = {}
local CraftCordonier = {}
local CraftBijoutier = {}
local CraftTailleur = {}
local CraftSculpteurBaton = {}
local CraftSculpteurBaguette = {}
local CraftSculpteurArc = {}

local ScriptStarting = true


local function GetJobIdByType(Type)
    if Type == "Chapeau" or Type == "Cape" or Type == "Sac à dos" then
        return 27
    elseif Type == "Ceinture" or Type == "Bottes" then
        return 15
    elseif Type == "Anneau" or Type == "Amulette" then
        return 16
    elseif Type == "Bâton" then
        return 18
    elseif Type == "Baguette" then
        return 19
    elseif Type == "Arc" then
        return 13
    end
    return 1
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
    ["Épée"] = {ElementId = 455861, Rep = -3},
    ["Pelle"] = {ElementId = 455861, Rep = -4},
    ["Hache"] = {ElementId = 455861, Rep = -5},
    ["Bâton"] = {ElementId = 455854, Rep = -1},
    ["Baguette"] = {ElementId = 455854, Rep = -2},
    ["Arc"] = {ElementId = 455854, Rep = -3},
    ["Potion"] = {ElementId = 455659, Rep = -1},
}


local function ProcessCraft(table, cellId, jobId)
    for _, element in ipairs(table) do
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9

            local PodsNeededToCraft = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Quantity
            end

            local CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, element.NbToCraft - inventory:itemCount(element.Id)))

            if CraftQuantity > 0 then
                global:printSuccess("On va craft " .. CraftQuantity .. " x " ..  inventory:itemNameId(element.Id))

                for _, element2 in ipairs(element.ListIdCraft) do
    
                    BuyQuantity = CraftQuantity * element2.Quantity - inventory:itemCount(element2.Id)
                    
                    if BuyQuantity > 0 then
                        global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                        Achat(element2.Id, BuyQuantity)
                        global:delay(500)
                    end
                end
    
                global:delay(500)
                map:useById(TableOutilAtelier[element.Type].ElementId, TableOutilAtelier[element.Type].Rep)
                global:delay(500)
    
                global:printSuccess("ok1")
                for _, item in ipairs(element.ListIdCraft) do
                    global:printSuccess(inventory:itemNameId(item.Id) .. " : ".. item.Quantity)
                    craft:putItem(item.Id, item.Quantity)
                    global:delay(200)
                end
                global:printSuccess("ok2")
                craft:changeQuantityToCraft(CraftQuantity)
                global:delay(200)
                CraftReady()
                global:printSuccess("Craft effectué !")
                global:leaveDialog()
    
                global:delay(500)
                return ProcessCraft(table, cellId, jobId)
            end
        end
    end

    map:moveToCell(cellId)
end

local goToAtelierCordoBonta = {
    { map = "-33,-56", path = "zaapi(146234)" },
    { map = "3145733", path = "396"},
    { map = "148797", path = "zaapi(146234)" },
    { map = "146232", path = "zaapi(146234)" },
    { map = "7864327", path = "396"},
    { map = "-28,-55", path = "zaapi(146234)" },
    { map = "-28,-61", path = "zaapi(146234)" },
    { map = "-29,-53", path = "zaapi(146234)" },
    { map = "-32,-56", path = "zaapi(146234)" },
    { map = "146234", door = "352" },
}

local goToAtelierBijoutierBonta = {
    { map = "-33,-56", path = "zaapi(148797)" },
    { map = "146232", path = "zaapi(148797)" },
    { map = "7864327", path = "396"},
    { map = "-29,-58", path = "zaapi(148797)" },
    { map = "-28,-55", path = "zaapi(148797)" },
    { map = "-28,-61", path = "zaapi(148797)" },
    { map = "-29,-53", path = "zaapi(148797)" },
    { map = "-32,-56", path = "zaapi(148797)" },
    { map = "148797", door = "510" },
}

local goToAtelierTailleurBonta = {
    { map = "-33,-56", path = "zaapi(146232)" },
    { map = "3145733", path = "396"},
    { map = "148797", path = "zaapi(146232)" },
    { map = "-29,-58", path = "zaapi(146232)" },
    { map = "-28,-55", path = "zaapi(146232)" },
    { map = "-28,-61", path = "zaapi(146232)" },
    { map = "-29,-53", path = "zaapi(146232)" },
    { map = "-32,-56", path = "zaapi(146232)" },
    { map = "146232", door = "329" },
}

local goToAtelierSculpteurBonta = {
    { map = "-33,-56", path = "zaapi(145725)" },
    { map = "3145733", path = "396"},
    { map = "148797", path = "zaapi(145725)" },
    { map = "-29,-58", path = "zaapi(145725)" },
    { map = "-28,-55", path = "zaapi(145725)" },
    { map = "-28,-61", path = "zaapi(145725)" },
    { map = "-29,-53", path = "zaapi(145725)" },
    { map = "-32,-56", path = "zaapi(145725)" },
    { map = "146232", path = "zaapi(145725)"},
    { map = "145725", door = "116" },
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

    global:editAlias("Craft " .. character:serverName() .. " : [" .. truncKamas() .. "m]", true)
    --- Determines which item we'll craft and resell

    if ScriptStarting then
        if character:bonusPackExpiration() == 0 then
            character:getBonusPack(1)
            global:reconnect(0)
        end

        global:leaveDialog()

        if #TableItem == 0 then
            global:printSuccess("Remplissage de la TableItem...")

            for line in io.lines("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\MetierCraft\\Objects.txt") do
                Id = tonumber(line:split(" ")[1])
                if IsItem(inventory:itemTypeId(Id)) and get_level_craft_item(get_recipe(Id)) <= job:level(GetJobIdByType(get_type_name(Id)))
                and ((inventory:itemCount(Id) > 0 and inventory:itemPosition(Id) ~= 63) or inventory:itemCount(Id) == 0) then
                    local element = {
                        Id = Id,
                        ListIdCraft = get_recipe(Id),
                        Type = get_type_name(Id),
                        JobLevelMini = get_level_craft_item(get_recipe(Id)),
                        NbToCraft = 1,
                    }
                    table.insert(TableItem, element)
                end
            end

            global:printSuccess("Remplissage fini!, il y a " .. #TableItem .. " items craftables")
        end

        inventory:openBank()

        exchange:putAllItems()

        for _, item in ipairs(TableItem) do
            if exchange:storageItemQuantity(item.Id) > 0 then
                local Quantity = math.min(exchange:storageItemQuantity(item.Id), inventory:podsP() < 90 and 10 or 0)
                if Quantity > 0 then
                    exchange:getItem(item.Id, exchange:storageItemQuantity(item.Id))
                end
            end
        end

        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end

        for _, item in ipairs(TableItem) do
            while inventory:itemCount(item.Id) > 0 and inventory:itemPosition(item.Id) == 63 and sale:availableSpace() > 0 do
                if not SellItem(item.Id) then
                    break
                end
            end
        end

        local random = math.random(1, 2)

        if random == 1 then
            global:printSuccess("On actualise tous les prix")
            UpdateAllItemOpti()
        end

        developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
        npc:npcSale()

        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

        global:leaveDialog()

        global:printMessage("Analyse de la rentabilité des items...")
        global:printMessage("--------------------------------------")
        --local kamasOwned = character:kamas()
        KamasDeBase = character:kamas()
        local kamasOwned = character:kamas() >= 5000000 and 5000000 or character:kamas()
        local kamasDepense  = 0

        npc:npcSale()

        PrixHdvAllRessources = {}

        for _, item in ipairs(TableItem) do
            if kamasOwned < 20000 then
                global:printSuccess("Plus assez de kamas pour faire d'autres crafts")
                break
            end

            if get_quantity(item.Id).total_quantity < item.NbToCraft and item.ListIdCraft and (item.JobLevelMini <= job:level(GetJobIdByType(item.Type))) then
                local TotalCost = 0
                local LackRessource = false

                for _, Ressource in ipairs(item.ListIdCraft) do
                    if not PrixHdvAllRessources[Ressource.Id] then
                        PrixHdvAllRessources[Ressource.Id] = GetPricesItem(Ressource.Id)
                    end
                    if not PrixHdvAllRessources[Ressource.Id].AveragePrice or PrixHdvAllRessources[Ressource.Id].AveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id)) then
                        LackRessource = true
                        break
                    end
                    if PrixHdvAllRessources[Ressource.Id].Price100 == 0 and PrixHdvAllRessources[Ressource.Id].Price10 == 0 and Ressource.Quantity > 20 then
                        LackRessource = true
                        break
                    end
                    TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].AveragePrice * Ressource.Quantity     
                end

                item.TotalCost = TotalCost

                global:printMessage("Total des couts pour craft " .. inventory:itemNameId(item.Id) .. " : " .. TotalCost)

                local MinPriceResell = GetPricesItem(item.Id).Price1
                if LackRessource then
                    global:printError("Des ressources sont manquantes en hdv pour ce craft")
                else
                    global:printMessage("Prix minimum en hdv pour cet item : " .. MinPriceResell)
                end

                if not LackRessource and (TotalCost * 1.3 < MinPriceResell) and (TotalCost * 3 < kamasOwned) and 
                (((MinPriceResell - TotalCost) > 10000) or ((TotalCost < MinPriceResell * 0.3) and ((MinPriceResell - TotalCost) > 5000))) and TotalCost < 1500000 then
                    item.NbToCraft = item.NbToCraft - get_quantity(item.Id).total_quantity

                    kamasOwned = kamasOwned - TotalCost * item.NbToCraft * 1.3
                    global:printSuccess("On peut craft " .. inventory:itemNameId(item.Id) .. "!")
                    kamasDepense = kamasDepense + TotalCost * item.NbToCraft
                    
                    if item.Type == "Chapeau" or item.Type == "Cape" or item.Type == "Sac à dos" then
                        table.insert(CraftTailleur, item)
                    elseif item.Type == "Ceinture" or item.Type == "Bottes" then
                        table.insert(CraftCordonier, item)
                    elseif item.Type == "Anneau" or item.Type == "Amulette" then
                        table.insert(CraftBijoutier, item)
                    elseif item.Type == "Bâton" then
                        table.insert(CraftSculpteurBaton, item)
                    elseif item.Type == "Baguette" then
                        table.insert(CraftSculpteurBaguette, item)
                    elseif item.Type == "Arc" then
                        table.insert(CraftSculpteurArc, item)
                    end
                end   

            end
        end
        
        global:leaveDialog()     

        global:printMessage("--------------------------------------")
        global:printMessage("Nous allons faire : ")
        global:printMessage("- " .. #CraftBijoutier .. " craft bijoutier")
        global:printMessage("- " .. #CraftCordonier .. " craft cordonier")
        global:printMessage("- " .. #CraftTailleur .. " craft tailleur")
        global:printMessage("- " .. #CraftSculpteurBaton + #CraftSculpteurBaguette + #CraftSculpteurArc .. " craft sculpteur")

        global:printMessage("--------------------------------------")
        global:printMessage("Le cout Total des crafts est de " .. kamasDepense)
        global:printMessage("--------------------------------------")
        global:printSuccess("Analyse terminée!")

        inventory:openBank()
        exchange:putAllItems()

        for _, item in ipairs(CraftCordonier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftBijoutier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftTailleur) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftSculpteurBaton) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftSculpteurBaguette) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftSculpteurArc) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        global:leaveDialog()
        global:delay(1000)
        ScriptStarting = false
    end

    --- Determines which item we'll craft and resell

    --- Path To Craft

    for _, item in ipairs(CraftCordonier) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(7864328) then
                return TreatMapBonta(goToAtelierCordoBonta)
            else
                ProcessCraft(CraftCordonier, 424, 15)
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(3145733) then
                return TreatMapBonta(goToAtelierBijoutierBonta)
            else
                ProcessCraft(CraftBijoutier, 396, 16)
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(7864327) then
                return TreatMapBonta(goToAtelierTailleurBonta)
            else
                ProcessCraft(CraftTailleur, 396, 27)
            end
        end
    end
    for _, item in ipairs(CraftSculpteurBaton) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(6815750) then
                return TreatMapBonta(goToAtelierSculpteurBonta)
            else
                ProcessCraft(CraftSculpteurBaton, 437, 18)
            end
        end
    end
    for _, item in ipairs(CraftSculpteurBaguette) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(6815750) then
                return TreatMapBonta(goToAtelierSculpteurBonta)
            else
                ProcessCraft(CraftSculpteurBaguette, 437, 19)
            end
        end
    end
    for _, item in ipairs(CraftSculpteurArc) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(6815750) then
                return TreatMapBonta(goToAtelierSculpteurBonta)
            else
                ProcessCraft(CraftSculpteurArc, 437, 13)
            end
        end
    end

    --- Path To Craft


    --- Final Selling

    for _, item in ipairs(TableItem) do
        while inventory:itemCount(item.Id) > 0 and inventory:itemPosition(item.Id) == 63 and sale:availableSpace() > 0 do
            if not SellItem(item.Id, item.TotalCost * 1.2, item.TotalCost * 3) then
                break
            end
        end
    end

    CraftTailleur = {}
    CraftBijoutier = {}
    CraftCordonier = {}
    CraftSculpteurBaton = {}
    CraftSculpteurBaguette = {}
    CraftSculpteurArc = {}
    
    if map:currentArea() ~= "Astrub" then
        PopoRappel()
        inventory:openBank()
        exchange:putAllItems()
        global:leaveDialog()
    end
    
    if not map:onMap(83887104) then
        GoTo("84674566", function()
            map:door(303)
        end)
    else
        global:printMessage("-------------------")
        global:printSuccess("Total dépensé : " .. KamasDeBase - character:kamas())
        --global:printSuccess("Total mis en vente : " ..)
        global:reconnectBis(math.random(90, 180))
    end
    --- Final Selling

end

function bank()
    return move()
end