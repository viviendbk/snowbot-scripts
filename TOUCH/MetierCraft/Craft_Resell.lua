dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local CraftCordonier = {}
local CraftBijoutier = {}
local CraftTailleur = {}
local ScriptStarting = true


local function GetJobIdByType(Type)
    if Type == "Chapeau" or Type == "Cape" or Type == "Sac à dos" then
        return 27
    elseif Type == "Ceinture" or Type == "Bottes" then
        return 15
    elseif Type == "Anneau" or Type == "Amulette" then
        return 16
    end
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
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9

            local PodsNeededToCraft = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Nb
            end

            local CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, element.NbToCraft - inventory:itemCount(element.Id)))

            global:printSuccess("On va craft " .. CraftQuantity .. " x " ..  element.Name)

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
    global:editAlias("bank_" .. character:serverName():lower() .. " : [" .. truncKamas() .. "m]", true)
    --- Determines which item we'll craft and resell

    if ScriptStarting then
        if character:bonusPackExpiration() == 0 then
            character:getBonusPack(1)
            global:reconnect(0)
        end
        inventory:openBank()

        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end

        global:leaveDialog()

        ScriptStarting = false
        for _, item in ipairs(TableStuffs) do
            while inventory:itemCount(item.Id) > 0 do
                SellItem(item.Id)
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

        for _, item in ipairs(TableStuffs) do
            if kamasOwned < 20000 then
                global:printSuccess("Plus assez de kamas pour faire d'autres crafts")
                break
            end
            if get_quantity(item.Id).total_quantity < 2 then
                local TotalCost = 0
                local LackRessource = false

                for _, Ressource in ipairs(item.ListIdCraft) do
                    local Prices = GetPricesItem(Ressource.Id)
                    if Prices.AveragePrice == 0 then
                        LackRessource = true
                    end
                    TotalCost = TotalCost + Prices.AveragePrice * Ressource.Nb
                end

                global:printMessage("Total des couts pour craft " .. inventory:itemNameId(item.Id) .. " : " .. TotalCost)

                local MinPriceResell = GetPricesItem(item.Id).Price1
                if LackRessource then
                    global:printError("Des ressources sont manquantes en hdv pour ce craft")
                else
                    global:printMessage("Prix minimum en hdv pour cet item : " .. MinPriceResell)
                end

                if not LackRessource and (TotalCost * 1.3 < MinPriceResell) and (TotalCost * 3 < kamasOwned) and (item.JobLevelMini <= job:level(GetJobIdByType(item.Type))) and (((MinPriceResell - TotalCost) > 10000) or (TotalCost < MinPriceResell * 0.3)) then
                    kamasOwned = kamasOwned - TotalCost * (2 - get_quantity(item.Id).total_quantity) * 1.3
                    global:printSuccess("On peut craft " .. inventory:itemNameId(item.Id) .. "!")
                    kamasDepense = kamasDepense + TotalCost * (2 - get_quantity(item.Id).total_quantity)
                    item.NbToCraft = 2 - get_quantity(item.Id).total_quantity
                    if item.Type == "Chapeau" or item.Type == "Cape" or item.Type == "Sac à dos" then
                        table.insert(CraftTailleur, item)
                    elseif item.Type == "Ceinture" or item.Type == "Bottes" then
                        table.insert(CraftCordonier, item)
                    elseif item.Type == "Anneau" or item.Type == "Amulette" then
                        table.insert(CraftBijoutier, item)
                    end
                end   

            end
        end
        
        global:leaveDialog()     

        global:printMessage("--------------------------------------")
        global:printMessage("Le cout Total des crafts est de " .. kamasDepense)
        global:printMessage("--------------------------------------")
        global:printSuccess("Analyse terminée!")

        inventory:openBank()
        exchange:putAllItems()

        for _, item in ipairs(CraftCordonier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftBijoutier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftTailleur) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Nb * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        global:leaveDialog()
        global:delay(1000)
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

    --- Path To Craft

    --- Final Selling

    for _, item in ipairs(TableStuffs) do
        while inventory:itemCount(item.Id) > 0 do
            --global:printSuccess(inventory:itemNameId(item.Id))
            SellItem(item.Id)
        end
    end

    CraftTailleur = {}
    CraftBijoutier = {}
    CraftCordonier = {}

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
        global:reconnect(3)
    end
    --- Final Selling

end

function bank()
    return move()
end