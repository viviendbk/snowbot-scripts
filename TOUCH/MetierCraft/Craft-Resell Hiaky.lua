json = dofile(global:getCurrentScriptDirectory().."\\json.lua")

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
    
                global:printSuccess(element.Type)
                global:delay(500)
                map:useById(TableOutilAtelier[element.Type].ElementId, TableOutilAtelier[element.Type].Rep)
                global:delay(500)
    
                for _, item in ipairs(element.ListIdCraft) do
                    craft:putItem(item.Id, item.Quantity)
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
        -- if character:bonusPackExpiration() == 0 then
        --     character:getBonusPack(1)
        --     global:reconnect(0)
        -- end

        global:leaveDialog()

        if #TableItem == 0 then
            global:printSuccess("Remplissage de la TableItem...")

            local allItems = openFile(global:getCurrentScriptDirectory() .. "\\id_to_recipe.json")

            for k, v in pairs(allItems) do
                Id = tonumber(k)
                if get_level_craft_item(get_recipe(Id)) <= 100 and ((inventory:itemCount(Id) > 0 and inventory:itemPosition(Id) ~= 63) or inventory:itemCount(Id) == 0) then
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

            if get_quantity(item.Id).total_quantity < item.NbToCraft and item.ListIdCraft and (item.JobLevelMini <= 100) then
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

local Quality_ItemToSell = 0
local IdToSell = 0
local UIDToSell = 0
local BestPrice = 0
local Stats = {}

string.split = function(self, sep, rawSep)
    local insert, result = table.insert, {}
    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end

    local rawSep = rawSep and sep or "([^" .. sep .. "]+)"

    for match in self:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

local rndm, print = math.random, {}

local charController = global:thisAccountController()

local function try(fn, catch)
    local status, result = pcall(fn)

    if not status then
        return catch and catch(status, result)
    else
        return result
    end
end

setmetatable(print, print) 


function GetQualityItem(ItemStats, Id)
    Id = Id or IdToSell
    local toReturn = 0

    for _, stat in ipairs(ItemStats) do
        if IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then
            toReturn = toReturn + stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
        end
    end
    return toReturn
end

function FinalSelling(Id, UID, Price)
    if Price < 2 then
        local TotalCost = 0

        npc:npcSale()

        for _, item in ipairs(TableStuffs) do
            if item.Id == Id then
                for _, Ressource in ipairs(item.ListIdCraft) do
                    local Prices = GetPricesItem(Ressource.Id)
                    TotalCost = TotalCost + Prices.AveragePrice * Ressource.Nb
                end
                break
            end
        end
        Price = math.floor(TotalCost * 1.5)
        if Price == 0 then
            Price = sale:getPriceItem(Id, 1)
        end
        global:leaveDialog()
    end
    if Price == 0 then
        return false
    end
    if character:kamas() > Price * 0.03 then
        npc:npcSale()

        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeObjectMovePricedMessage",
            ["data"] = {
                ["objectUID"] = UID,
                ["quantity"] = 1,
                ["price"] = Price,
            }
        }
    
        local msg = developer:fromObject(obj)
    
        developer:sendMessage(msg)
    
        global:printSuccess("1 lot de [" .. inventory:itemNameId(Id) .. "] à " .. Price .. " kamas")
    
        global:leaveDialog()
    else
        global:printError("Pas assez de kamas pour vendre, on réessaie dans 2 heures")
        global:reconnect(2)
    end
end

function _GetBestPrice(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    local message = developer:toObject(message)
    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}

    for _, data in ipairs(toScan) do
        local element = {
            Quality = GetQualityItem(data.effects),
            Price = data.prices[1]
        }
        table.insert(AllItemsInHdv, element)
    end

    table.sort(AllItemsInHdv, function (a, b)
        return a.Price < b.Price        
    end)


    for _, element in ipairs(AllItemsInHdv) do
        if Quality_ItemToSell < element.Quality then
            BestPrice = (element.Price > 0) and element.Price - 1 or element.Price
            break
        end
    end

    global:printSuccess("Meilleur prix trouvé : " .. BestPrice)
end

function GetNameCarac(Id)
    for _, element in ipairs(IdWithCaracName) do
        if element.Id == Id then
            return element.Name
        end
    end
end

function IsActionIdKnown(actionId)
    for _, element in ipairs(IdWithCaracName) do
        if element.Id == actionId then
            return true
        end
    end
    return false
end

function SellItem(Id, MinPrice, MaxPrice)
    MinPrice = MinPrice or 0
    MaxPrice = MaxPrice or 100000000
    local iContent = inventory:inventoryContent()
    for _, item in ipairs(iContent) do
        if item.objectGID == Id then
            ItemFound = true
            ItemStats = item.effects
            IdToSell = item.objectGID
            UIDToSell = item.objectUID
        end
    end

    if not ItemFound then
        global:printSuccess("L'item n'est pas présent dans l'inventaire, impossible de le vendre")
        return
    else
        ItemFound = false
    end

    Quality_ItemToSell = GetQualityItem(ItemStats) - 0.05
    global:printSuccess("Poids de l'item " .. inventory:itemNameId(Id) .. " : " .. Quality_ItemToSell)
    npc:npcBuy()

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseTypeMessage",
        ["data"] = {
            ["type"] = inventory:itemTypeId(Id),
        }
    }

    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }

    local msg = developer:fromObject(obj)

    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPrice)

    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    
    global:leaveDialog()

    if BestPrice > MaxPrice then
        return FinalSelling(IdToSell, UIDToSell, MaxPrice)
    elseif BestPrice < MinPrice then
        return FinalSelling(IdToSell, UIDToSell, MinPrice)
    else
        return FinalSelling(IdToSell, UIDToSell, BestPrice)
    end
    BestPrice = 0
    Quality_ItemToSell = 0
    return true
end

function printVar(variable, name, indent)
    name = name or "Variable"
    indent = indent or ""
    if type(variable) == "table" then
        global:printSuccess(indent .. name .. " = {")
        for k, v in pairs(variable) do
            printVar(v, k, indent .. "  ")
        end
        global:printSuccess(indent .. "}")
    else
        global:printSuccess(indent .. name .. " = " .. tostring(variable))
    end
  end

function _GetMessagePrices(message)
    TablePrice = {}
    developer:unRegisterMessage("ExchangeBidhouseMinimumItemPriceListMessage")
    local message = developer:toObject(message)

    local AveragePrice = 0

    if message.prices[2] == 0 and message.prices[3] == 0 then
        AveragePrice = message.prices[1]
    elseif message.prices[3] == 0 and message.prices[1] == 0 then
        AveragePrice = message.prices[2] / 10
    elseif message.prices[2] == 0 and message.prices[1] == 0 then
        AveragePrice = message.prices[3] / 100
    elseif message.prices[3] ~= 0 and message.prices[1] ~= 0 and message.prices[2] ~= 0 then
        AveragePrice =(message.prices[3] / 100 + message.prices[2] / 10 + message.prices[1]) / 3
    elseif message.prices[3] == 0 then
        AveragePrice = (message.prices[2] / 10 + message.prices[1]) / 2
    elseif message.prices[2] == 0 then
        AveragePrice = (message.prices[3] / 100 + message.prices[1]) / 2
    elseif message.prices[1] == 0 then
        AveragePrice = (message.prices[3] / 100 + message.prices[2] / 10) / 2
    end

    local element = {
        Id = message.objectGID,
        Price1 = message.prices[1],
        Price10 = message.prices[2],
        Price100 = message.prices[3],
        AveragePrice = math.floor(AveragePrice)
    }
    table.insert(TablePrice, element)
end

function GetPricesItem(Id)
    developer:registerMessage("ExchangeBidhouseMinimumItemPriceListMessage", _GetMessagePrices)
    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }
    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeBidhouseMinimumItemPriceListMessage", 5000, false, nil, 20)

    for _, item in ipairs(TablePrice) do
        if Id == item.Id then
            return item
        end
    end
end



function Achat(IdItem, qtt)
    --[[
        Amelioratioons :

    ]]
    npc:npcSale()

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    local Prices = GetPricesItem(IdItem)

    global:printSuccess("Prix par 100 : " .. Prices.Price100)
    global:printSuccess("Prix par 10 : " .. Prices.Price10)
    global:printSuccess("Prix par 1 : " .. Prices.Price1)

    global:leaveDialog()


    if (Prices.Price100 == 0) and (Prices.Price10 == 0) and (Prices.Price1 == 0) then
        global:printSuccess("L'item n'est plus disponible en hdv")
        global:restartScript(true)
        return false
    elseif Prices.Price10 == 0 and Prices.Price100 == 0 and qtt < 21 then
        qtt = 1
    elseif ((Prices.Price10 == 0) and (Prices.Price1 == 0)) or ((qtt > 10) and Prices.Price10 * qtt / 10 > Prices.Price100 and Prices.Price100 > 0) or (Prices.Price10 == 0 and qtt > 9 and qtt < 100 ) then
        qtt = 100
    elseif Prices.Price1 == 0 and qtt < 10 then
        qtt = 10
    elseif qtt > 10 and qtt < 100 and qtt % 10 * Prices.Price1 > Prices.Price10 then
        qtt = qtt + (10 - qtt % 10)
    elseif qtt < 10 and Prices.Price1 * qtt > Prices.Price10 and Prices.Price10 > 0 then
        qtt = 10
    elseif (Prices.Price100 ~= 0) and (Prices.Price10 ~= 0) then
        qtt = ((((qtt < 100) and (qtt > 10)) and (Prices.Price100 * 1.3 < Prices.Price10 * 10)) and (inventory:itemWeight(IdItem) * 100) < (inventory:podsMax() - inventory:pods())) and 100
        or ((qtt < 10) and (Prices.Price10 * 1.3 < Prices.Price1 * 10)) and 10
        or qtt
    end

    npc:npcBuy()

    while qtt > 0 do           
        if qtt >= 100 then
            if character:kamas() < Prices.Price100 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price10 * 1.2 < Prices.Price100 / 10) and Prices.Price10 ~= 0) or Prices.Price100 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 10, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            elseif Prices.Price100 == 0 and Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 100, 100000000)
                qtt = qtt - 100             
            end
        elseif qtt >= 10 and qtt < 100 then
            if character:kamas() < Prices.Price10 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            if ((Prices.Price1 * 1.2 < Prices.Price10 / 10) and Prices.Price1 ~= 0) or Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, 2000000)
                end
                local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem) -- 50 de base 50 acheter
                return Achat(IdItem, nbRessourceManquante)
            else
                sale:buyItem(IdItem, 10, 10000000)
                qtt = qtt - 10
            end
        elseif qtt >= 1 and qtt < 10 then
            if character:kamas() < Prices.Price1 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                global:reconnect(2)
            end
            sale:buyItem(IdItem, 1, 1500000)
            qtt = qtt - 1 
        end
    end

    global:leaveDialog()

    local nbRessourceManquante = NbDeBdase + Quantite - inventory:itemCount(IdItem)
    if nbRessourceManquante > 0 then
        Achat(IdItem, nbRessourceManquante)
    end
    global:printSuccess("Fin achat")
    return true
end


function _AnalyseItemsOnSale(message)
    developer:unRegisterMessage("ExchangeStartedBidSellerMessage")
    message = developer:toObject(message)
    local ItemsOnSale = {}
    local RessourcesOnSale = {}
    local toScan = message.objectsInfos

    for _, data in ipairs(toScan) do
        if data.quantity == 1 and IsItem(inventory:itemTypeId(data.objectGID)) then
            global:printSuccess(_ .. "ème item : " .. inventory:itemNameId(data.objectGID))
            local element = {
                Id = data.objectGID,
                UID = data.objectUID,
                Effects = data.effects,
                Price = data.objectPrice,
                Quality = 0,
                CurrentBestPrice = 0,
            }
            table.insert(ItemsOnSale, element)
        else
            local element = {
                Id = data.objectGID,
                Price = data.objectPrice,
                Lot = data.quantity,
                CurrentBestPrice = 0
            }
            table.insert(RessourcesOnSale, element)
        end
    end

    global:leaveDialog()

    npc:npcBuy()

    for _, item in ipairs(ItemsOnSale) do
        IdToSell = item.Id
        item.Quality = GetQualityItem(item.Effects, item.Id) - 0.05
        Quality_ItemToSell = item.Quality

        global:printSuccess("Qualité de " .. inventory:itemNameId(item.Id) .. " : " .. item.Quality)
        global:printSuccess("Prix actuel : " .. item.Price)
        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeBidHouseTypeMessage",
            ["data"] = {
                ["type"] = inventory:itemTypeId(item.Id),
            }
        }

        local msg = developer:fromObject(obj)
        developer:sendMessage(msg)
    
        developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)
    
        local obj = {}
        obj["call"] = "sendMessage"
        obj["data"] = {
            ["type"] = "ExchangeBidHouseListMessage",
            ["data"] = {
                ["id"] = item.Id,
            }
        }

        local msg = developer:fromObject(obj)
    
        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPrice)
    
        developer:sendMessage(msg)

        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

        item.CurrentBestPrice = BestPrice
    end

    global:leaveDialog()

    global:printMessage("----------ACTUALISATION----------")
    npc:npcSale()

    for _, item in ipairs(ItemsOnSale) do
        if ((item.Price - item.CurrentBestPrice) > 2000) then
            global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "] : ancien prix : " .. item.Price .. ", nouveau prix : " .. item.CurrentBestPrice - 1)
            sale:editPrice(item.UID, item.CurrentBestPrice - 1, 1)
        end
    end
    global:leaveDialog()

    global:printMessage("----------ACTUALISATION FINIE----------")

    npc:npcBuy()

    for _, ressource in ipairs(RessourcesOnSale) do
        local Prices = GetPricesItem(ressource.Id)
        ressource.CurrentBestPrice = Prices
    end

    global:leaveDialog()

    npc:npcSale()

    for _, ressource in ipairs(RessourcesOnSale) do
        local Lot = ressource.Lot
        if Lot == 100 then
            if ressource.CurrentBestPrice.Price100 < ressource.Price then
                global:printSuccess("Actualisation du lot de 100 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 100)
            end
        elseif Lot == 10 then
            if ressource.CurrentBestPrice.Price10 < ressource.Price then
                global:printSuccess("Actualisation du lot de 10 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 10)
            end
        elseif Lot == 1 then
            if ressource.CurrentBestPrice.Price1 < ressource.Price then
                global:printSuccess("Actualisation du lot de 1 [" .. inventory:itemNameId(ressource.Id) .. "], nouveau prix : " .. ressource.CurrentBestPrice - 1)
                sale:editPriceByGID(ressource.Id, ressource.CurrentBestPrice - 1, 1)
            end
        end
    end
end

function UpdateAllItemOpti()
    developer:registerMessage("ExchangeStartedBidSellerMessage", _AnalyseItemsOnSale)
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, false, nil, 20)
end

function PopoRappel()
    if inventory:itemCount(548) == 0 then
        npc:npcBuy()
        global:delay(500)
        sale:buyItem(548, 1, 1000)
        if inventory:itemCount(548) == 0 then
            sale:buyItem(548, 10, 10000)
        end
        global:delay(500)
        global:leaveDialog()
        global:delay(500)
    end
    inventory:useItem(548)
end

function PopoBonta()
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
function PopoBrakmar()
    if map:currentArea() ~= "Brakmar" then
        if inventory:itemCount(6964) == 0 then
            npc:npcBuy()
            global:delay(500)
            sale:buyItem(6964, 1, 1000)
            if inventory:itemCount(6964) == 0 then
                sale:buyItem(6964, 10, 10000)
            end
            global:delay(500)
            global:leaveDialog()
            global:delay(500)
        end
        inventory:useItem(6964)
    end
end
function LoadAndConnectBotBanque(trajetBotBank)
    global:printSuccess("Connexion du bot banque")

    local All_Alias = ankabotController:getAliasAllRegistredAccounts()
    local All_Username = ankabotController:getUsernameAllRegistredAccounts()

    for i, Alias in ipairs(All_Alias) do
        if Alias:find("bank_" .. character:serverName():lower()) then
            for j, Username in ipairs(All_Username) do
                if i == j then
                    while ankabotController:accountIsLoaded(Username) do
                        global:printMessage("On attend que le bot se décharge")
                        if not ankabotController:getAccount(Username):isAccountConnected() then
                            global:delay(10000)
                            if not ankabotController:getAccount(Username):isAccountConnected() then
                                ankabotController:getAccount(Username):unloadAccount()
                            end
                        else
                            if ConsoleRead(global:thisAccountController(), "Le serveur a coupé la connexion inopinément") and not ankabotController:getAccount(Username):isScriptPlaying() then
                                global:clearConsole()
                                ankabotController:getAccount(Username):unloadAccount()
                                return LoadAndConnectBotBanque(trajetBotBank)
                            end
                        end
                        global:delay(5000)
                    end

                    global:printSuccess("On charge le compte!")
                    local acc = ankabotController:loadAccount(Username, true)

                    local WaitingTime = 0
                    while not acc:isAccountFullyConnected() do
                        global:printMessage("Attente de la connexion du bot")
                        global:delay(5000)
                        WaitingTime = WaitingTime + 5
                        if WaitingTime > 120 then
                            global:restartScript(true)
                        end
                    end

                    acc:loadScript(trajetBotBank)

                    if acc.map:currentArea() ~= "Astrub" then
                        acc:callScriptFunction("PopoRappel")
                        global:delay(5000)
                    end
                    acc:startScript()
                    while not acc.map:onMap(map:currentMapId()) do
                        global:printSuccess("On attend que le bot banque nous rejoigne")
                        global:delay(5000)
                    end
                    global:delay(2000)
                    return acc
                end
            end
        end
    end
end

---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
function get_quantity(id)
    if object_in_hdv then
        informations = {
            id = id,
            quantity = {
                ["1"] = 0,
                ["10"] = 0,
                ["100"] = 0
            },
            total_quantity = 0,
            total_lots = 0,
        }

        for _, info in ipairs(object_in_hdv) do
            if info.id == id then
                informations.quantity["1"] = info.quantity["1"]
                informations.quantity["10"] = info.quantity["10"]
                informations.quantity["100"] = info.quantity["100"]
                informations.total_quantity = info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
                informations.total_lots = info.quantity["1"] + info.quantity["10"] + info.quantity["100"]
            end
        end

        return informations
    else
        global:printError("[INFO] - l'HDV n'a pas été scanné je ne peux donc pas resortir les quantités demandées.")
    end
end

---Fonction qui permet de scanner l'hotel de vente.
function stack_items_informations(message)
    message = developer:toObject(message)
    object_in_hdv = {}
    may_add_id = true

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                may_add_id = false

                break
            end
        end

        if may_add_id then
            table.insert(object_in_hdv,{ id = item.objectGID, quantity = {["1"] = 0, ["10"] = 0, ["100"] = 0}})
        end

        may_add_id = true
    end

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                info.quantity[tostring(item.quantity)] = info.quantity[tostring(item.quantity)] + 1
            end
        end
    end
end

function CraftReady()
    developer:sendMessage('{"call":"sendMessage","data":{"type":"ExchangeReadyMessage","data":{"ready":true,"step":2}}}')
    developer:suspendScriptUntil("ExchangeCraftResultWithObjectDescMessage", 5000, false, nil, 20)
end

function ManageMount()
    local myMount = mount:myMount()

    if myMount ~= nil then
        if not myMount.isRideable then
            global:printSuccess("Ma dd n'est pas montable, on la libère")
            developer:sendMessage('{"call":"sendMessage","data":{"type":"MountReleaseRequestMessage"}}')
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
        if myMount.level < 100 and character:level() > 75 then
            global:printSuccess("dd level : " .. myMount.level)
            mount:setXpRatio(90)
        else
            mount:setXpRatio(0)
        end
    
        if (myMount.energyMax - myMount.energy) > 1000 and character:kamas() > 10000 and character:energyPoints() > 0 and (inventory:podsMax() - inventory:pods()) > 300 then
            global:printSuccess("ProcessAchat nourriture pour dragodinde...")
            -- mettre l'achat de nourriture pour monture
            local TableAchat = {
                {Name = "Poisson Pané", Id = 1750, Price = 999999},
                {Name = "Crabe Sourimi", Id = 1757, Price = 999999},
                {Name = "Goujon", Id = 1782, Price = 999999},
                {Name = "Brochet", Id = 1847, Price = 999999},
                {Name = "Sardine Brillante", Id = 1805, Price = 999999},
                {Name = "Cuisse de Boufton", Id = 1911, Price = 999999},
                {Name = "Cuisse de Bouftou **", Id = 1912, Price = 999999},
                {Name = "Poisson-Chaton", Id = 603, Price = 999999},
                {Name = "Bar Rikain", Id = 1779, Price = 999999},
            }
        
            npc:npcSale()

            for _, element in ipairs(TableAchat) do
                element.Price = GetPricesItem(element.Id).Price100
            end
    
            table.sort(TableAchat, function (a, b)
                return a.Price < b.Price
            end)

            global:leaveDialog()

            global:delay(500)

            npc:npcBuy()
            global:delay(500)

            for i, element in ipairs(TableAchat) do
                if element.Price > 0 then
                    index = i
                    sale:buyItem(element.Id, 100, element.Price + 1)
                    break
                end
            end

            global:delay(500)
            global:leaveDialog()

            mount:feedMount(TableAchat[index].Id, 100)
            if not mount:isRiding() then
                mount:toggleRiding()
            end
        end
    end
end

function AllTeamHavePanneau70()
    local Stuff70 = {
        {Type = "Coiffe", Id = 2531, Position = 6},
        {Type = "Cape", Id = 2532, Position = 7},
        {Type = "Ceinture", Id = 2683, Position = 3},
        {Type = "Amulette", Id = 10836, Position = 0},
        {Type = "AnneauGauche", Id = 2469, Position = 4},
        {Type = "AnneauDroit", Id = 1559, Position = 2},
        {Type = "Bottes", Id = 6470, Position = 5},
    }

   local team = global:thisAccountController():getTeamAccounts()
   table.insert(team, global:thisAccountController()) 
   for _, acc in ipairs(team) do
        for _, item in ipairs(Stuff70) do
            if acc.inventory:itemCount(item.Id) == 0 then
                return false
            end
        end
   end
   return true
end

function ConsoleRead(acc, string)
    local lines = acc.global:consoleLines() or {}
    local found = false
    if lines then
        for i = 1, #lines do
            found = found or (lines[i]:find(string) ~= nil)
        end
    end
    return found
end

-- function GoTo(mapToward, action)
--     local toward = mapToward:split(",")
--     if not map:onMap(mapToward) then
--         if #toward == 2 then
--             return map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
--         elseif #toward == 1 then
--             return map:moveToward(tonumber(toward[1]))
--         end
--     else
--         action()
--     end
-- end

function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    local onMap = map:onMap(mapToward)
    local num1, num2 = tonumber(toward[1]), tonumber(toward[2])
    return (not onMap and (#toward == 2 and map:moveToward(num1, num2) or #toward == 1 and map:moveToward(num1))) or action()
end

function TakeBonusPackForTeam()
    if not global:remember("WaitingTimeToBuyBonusPack") then
        global:addInMemory("WaitingTimeToBuyBonusPack", 0)
    end
    if ((os.time() - global:remember("WaitingTimeToBuyBonusPack")) / 60 / 60) >= 2 then
        global:editInMemory("WaitingTimeToBuyBonusPack", 0)
    end
    if global:isBoss() and global:remember("WaitingTimeToBuyBonusPack") == 0 then
        local TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            if acc.character:bonusPackExpiration() == 0 then
                acc.inventory:openBank()
                if acc.exchange:storageKamas() > 0 then
                    acc.global:printSuccess("Il y a " .. acc.exchange:storageKamas() .. " kamas en banque, on les prend")
                    acc.exchange:getKamas(0)
                    acc.global:delay(500)
                elseif acc.exchange:storageKamas() == 0 then
                    acc.global:printError("Il n'y a pas de kamas en banque")
                    acc.global:delay(500)
                end
                acc.global:leaveDialog()
                if acc.character:kamas() > 50000 then
                    acc.character:getBonusPack(1)
                    acc.global:reconnect(0)
                else
                    global:editInMemory("WaitingTimeToBuyBonusPack", os.time())
                    acc.global:printError("Pas assez de kamas pour acheter le bonue pack")
                end
            end
        end
        if character:bonusPackExpiration() == 0 then
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
            if character:kamas() > 50000 then
                character:getBonusPack(1)
                global:reconnect(0)
            else
                global:printError("Pas assez de kamas pour acheter le bonue pack")
                global:editInMemory("WaitingTimeToBuyBonusPack", os.time())
            end
        end
    end
end

function GetTypeBan(acc)
    local modoban = ConsoleRead(acc, "vient de vous bannir")
    local defban = ConsoleRead(acc, "banni définitivement")
    return (modoban and "[BAN MODO]") or (defban and "[BAN DEF]") or "[BAN JSP]"
end


function bank()
    return move()
end

function truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    return nbr:sub(1, nbr:find("%p") + size)
end

function truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return truncate(amount, 0)
end

function openFile(path, del)
    local fileResult = io.open(path, "r")

    if fileResult then
        local content = fileResult:read("*a")
        fileResult:close()

        if del then os.remove(path) end

        return path:find(".json")
            and json.decode(content)
            or content 
    end
end

function writeFile(path, data)
    local file = io.open(path, "w")

    file:write(path:find(".json") and json.encode(data) or data)
    file:close()
end

AllRecipes = openFile(global:getCurrentScriptDirectory() .. "\\id_to_recipe.json")


function get_recipe(id)

    local ingredientsTable = {}
    local tableToAnalyse = AllRecipes[tostring(id)]

    if tableToAnalyse then
        local ingredients = AllRecipes[tostring(id)]["ingredient"]
        local quantities = AllRecipes[tostring(id)]["quantity"]
    
        if ingredients then
            for i, ingredientId in ipairs(ingredients) do
                local ingredientQuantity = quantities[i]
                ingredientsTable[i] = { Id = ingredientId, Quantity = ingredientQuantity }
            end
        end
    else
        return nil
    end


    return ingredientsTable
end

function get_level_craft_item(recipe)

    if not recipe then
        return 101
    end
    return not recipe and 0 
        or #recipe == 1 and 1
        or #recipe == 2 and 1 
        or #recipe == 3 and 10
        or #recipe == 4 and 20
        or #recipe == 5 and 40
        or #recipe == 6 and 60
        or #recipe == 7 and 80
        or #recipe == 8 and 100
end


function IsItem(TypeId)
    local Ids = { 16, 17, 11, 10, 1, 9, 82, 151, 7, 19, 8, 6, 5, 2, 3, 4, 81}
    Ids = {4}
    for _, Id in ipairs(Ids) do
        if Id == TypeId then
            return true
        end
    end
    return false
end

function get_type_name(id)
    local typeId = inventory:itemTypeId(id)
    local tableId = {
        ["16"] = "Coiffe",
        ["17"] = "Cape",
        ["10"] = "Ceinture",
        ["1"] = "Amulette",
        ["9"] = "Anneau",
        ["11"] = "Bottes",
        ["81"] = "Sac à Dos"
    }
    return tableId[tostring(typeId)]
end

function _GetMeanDice(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    Stats = {}
    local message = developer:toObject(message)
    local toScan = message.itemTypeDescriptions
    local AllItemsInHdv = {}
    local dicoStats = {}

    for _, data in ipairs(toScan) do
        table.insert(AllItemsInHdv, data.effects)
    end

    for _, element in ipairs(AllItemsInHdv) do
        for _, stat in ipairs(element) do
            dicoStats[tostring(stat.actionId)] = not dicoStats[tostring(stat.actionId)] and stat.value or dicoStats[tostring(stat.actionId)] + stat.value
            dicoStats["nb" .. tostring(stat.actionId)] = not dicoStats["nb" .. tostring(stat.actionId)] and 1 or dicoStats["nb" .. tostring(stat.actionId)] + 1
        end
    end

    for k, v in pairs(dicoStats) do
        if not k:find("nb") and dicoStats["nb" .. k] > #AllItemsInHdv / 2 then
            table.insert(Stats, {
                actionId = tonumber(k),
                value = math.ceil(v / dicoStats["nb" .. k])
            })
        end
    end
end

function GetDice(Id)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseTypeMessage",
        ["data"] = {
            ["type"] = inventory:itemTypeId(Id),
        }
    }

    local msg = developer:fromObject(obj)
    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    local obj = {}
    obj["call"] = "sendMessage"
    obj["data"] = {
        ["type"] = "ExchangeBidHouseListMessage",
        ["data"] = {
            ["id"] = Id,
        }
    }

    local msg = developer:fromObject(obj)

    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetMeanDice)

    developer:sendMessage(msg)

    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

    return Stats
end

function GetEstimationEarnsOnBreak(dice)
    local toReturn = 0

    for _, stat in ipairs(dice) do
        if stat.actionId == 111 or stat.actionId == 128 or stat.actionId == 117 or stat.actionId == 182 then
            local percentage = math.min(1.5 * ((inventory:getLevel(Id)^2) / PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite^(5/4)), 67)
            toReturn = toReturn + (percentage / 100) *PoidsByStat[GetNameCarac(stat.actionId)].Runes[1].Prices.AveragePrice
            --global:printSuccess("Il y a " .. percentage .."% de chance d'obtenir une rune " .. GetNameCarac(stat.actionId))
        elseif IsActionIdKnown(stat.actionId) and not GetNameCarac(stat.actionId):find("-") then

            --global:printSuccess(GetNameCarac(stat.actionId) .. " : " .. stat.value)
            local poidsStat = stat.value * PoidsByStat[GetNameCarac(stat.actionId)].PoidsUnite
            local minPoids = poidsStat * (2/3) * 0.9
            local maxPoids = poidsStat * (2/3) * 1.1

            local infoRunes = PoidsByStat[GetNameCarac(stat.actionId)].Runes
            local poidsRunes = {}
            local pwdRunes = {}

            local nbRunesObtenuesMax = {}
            local nbRunesObtenuesMin = {}

            for i = 1, 3 do
                poidsRunes[i] = not infoRunes[i] and 9999999 or infoRunes[i].Poids
            end
            pwdRunes[1] = poidsRunes[1]
            pwdRunes[2] = 2 * poidsRunes[1] + poidsRunes[2]
            pwdRunes[3] = 4 * poidsRunes[1] + 2 * poidsRunes[2] + poidsRunes[3]

            local reste = minPoids
            for i = 1, 3 do
                nbRunesObtenuesMin[i] = math.floor(reste / pwdRunes[4-i])
                reste = reste - nbRunesObtenuesMin[i] * poidsRunes[4-i]
            end
            nbRunesObtenuesMin[3] = nbRunesObtenuesMin[3] + reste

            reste = maxPoids
            for i = 1, 3 do
                nbRunesObtenuesMax[i] = math.floor(reste / pwdRunes[4-i])
                reste = reste - nbRunesObtenuesMax[i] * poidsRunes[4-i]
            end
            nbRunesObtenuesMax[3] = nbRunesObtenuesMax[3] + reste

            local earnsMini = 0
            local earnsMax = 0
            for i = 1, #PoidsByStat[GetNameCarac(stat.actionId)].Runes do
                earnsMini = earnsMini + nbRunesObtenuesMin[i] * PoidsByStat[GetNameCarac(stat.actionId)].Runes[#PoidsByStat[GetNameCarac(stat.actionId)].Runes + 1 - i].Prices.AveragePrice
                earnsMax = earnsMax + nbRunesObtenuesMax[i] * PoidsByStat[GetNameCarac(stat.actionId)].Runes[#PoidsByStat[GetNameCarac(stat.actionId)].Runes + 1 - i].Prices.AveragePrice
            end
            toReturn = toReturn + (earnsMini + earnsMax) / 2

        end
    end

    return math.floor(toReturn)
end

IdWithCaracName = {
    {
        Id = 111,
        Name = "PA"
    },
    {
        Id = 168,
        Name = "-PA"
    },
    {
        Id = 128,
        Name = "PM"
    },
    {
        Id = 169,
        Name = "-PM"
    },
    {
        Id = 117,
        Name = "Portee"
    },
    {
        Id = 116,
        Name = "-Portee"
    },
    {
        Id = 182,
        Name = "Invocations"
    },
    {
        Id = 112,
        Name = "Dommages"
    },
    {
        Id = 145,
        Name = "-Dommages"
    },
    {
        Id = 2804,
        Name = "% Dommages distance"
    },
    {
        Id = 2805,
        Name = "-% Dommages distance"
    },
    {
        Id = 2807,
        Name = "% Resistance distance"
    },
    {
        Id = 2806,
        Name = "-% Resistance distance"
    },
    {
        Id = 2812,
        Name = "% Dommages aux sorts"
    },
    {
        Id = 2813,
        Name = "-% Dommages aux sorts"
    },
    {
        Id = 2808,
        Name = "% Dommages armes"
    },
    {
        Id = 2809,
        Name = "-% Dommages armes"
    },
    {
        Id = 2800,
        Name = "% Dommages melee"
    },
    {
        Id = 2801,
        Name = "-% Dommages melee"
    },
    {
        Id = 2803,
        Name = "% Resistance melee"
    },
    {
        Id = 2802,
        Name = "-% Resistance melee"
    },
    {
        Id = 115,
        Name = "Critique"
    },
    {
        Id = 171,
        Name = "Critique"
    },
    {
        Id = 178,
        Name = "Soins"
    },
    {
        Id = 179,
        Name = "-Soins"
    },
    {
        Id = 220,
        Name = "Renvoie dommages"
    },
    {
        Id = 410,
        Name = "Retrait PA"
    },
    {
        Id = 411,
        Name = "-Retrait PA"
    },
    {
        Id = 412,
        Name = "Retrait PM"
    },
    {
        Id = 413,
        Name = "-Retrait PM"
    },
    {
        Id = 160,
        Name = "Esquive PA"
    },
    {
        Id = 162,
        Name = "-Esquive PA"
    },
    {
        Id = 161,
        Name = "Esquive PM"
    },
    {
        Id = 163,
        Name = "-Esquive PM"
    },
    {
        Id = 214,
        Name = "% Resistance Neutre"
    },
    {
        Id = 219,
        Name = "-% Resistance Neutre"
    },
    {
        Id = 210,
        Name = "% Resistance Terre"
    },
    {
        Id = 215,
        Name = "-% Resistance Terre"
    },
    {
        Id = 211,
        Name = "% Resistance Eau"
    },
    {
        Id = 216,
        Name = "-% Resistance Eau"
    },
    {
        Id = 212,
        Name = "% Resistance Air"
    },
    {
        Id = 217,
        Name = "-% Resistance Air"
    },
    {
        Id = 213,
        Name = "% Resistance Feu"
    },
    {
        Id = 218,
        Name = "-% Resistance Feu"
    },
    {
        Id = 795,
        Name = "Arme de chasse"
    },
    {
        Id = 424,
        Name = "Dommages Feu"
    },
    {
        Id = 425,
        Name = "-Dommages Feu"
    },
    {
        Id = 428,
        Name = "Dommages Air"
    },
    {
        Id = 429,
        Name = "-Dommages Air"
    },
    {
        Id = 426,
        Name = "Dommages Eau"
    },
    {
        Id = 427,
        Name = "-Dommages Eau"
    },
    {
        Id = 430,
        Name = "Dommages Neutre"
    },
    {
        Id = 431,
        Name = "-Dommages Neutre"
    },
    {
        Id = 422,
        Name = "Dommages Terre"
    },
    {
        Id = 423,
        Name = "-Dommages Terre"
    },
    {
        Id = 418,
        Name = "Dommages Critiques"
    },
    {
        Id = 419,
        Name = "-Dommages Critiques"
    },
    {
        Id = 225,
        Name = "Dommages Pieges"
    },
    {
        Id = 414,
        Name = "Dommages Poussee"
    },
    {
        Id = 415,
        Name = "-Dommages Poussee"
    },
    {
        Id = 752,
        Name = "Fuite"
    },
    {
        Id = 754,
        Name = "-Fuite"
    },
    {
        Id = 753,
        Name = "Tacle"
    },
    {
        Id = 755,
        Name = "-Tacle"
    },
    {
        Id = 124,
        Name = "Sagesse"
    },
    {
        Id = 156,
        Name = "-Sagesse"
    },
    {
        Id = 176,
        Name = "Prospection"
    },
    {
        Id = 177,
        Name = "-Prospection"
    },
    {
        Id = 158,
        Name = "Pods"
    },
    {
        Id = 159,
        Name = "-Pods"
    },
    {
        Id = 242,
        Name = "Resistance Air"
    },
    {
        Id = 247,
        Name = "-Resistance Air"
    },
    {
        Id = 243,
        Name = "Resistance Feu"
    },
    {
        Id = 248,
        Name = "-Resistance Feu"
    },
    {
        Id = 244,
        Name = "Resistance Neutre"
    },
    {
        Id = 249,
        Name = "-Resistance Neutre"
    },
    {
        Id = 241,
        Name = "Resistance Eau"
    },
    {
        Id = 246,
        Name = "-Resistance Eau"
    },
    {
        Id = 240,
        Name = "Resistance Terre"
    },
    {
        Id = 245,
        Name = "-Resistance Terre"
    },
    {
        Id = 226,
        Name = "Puissance Pieges"
    },
    {
        Id = 420,
        Name = "Resistance Critiques"
    },
    {
        Id = 421,
        Name = "-Resistance Critiques"
    },
    {
        Id = 416,
        Name = "Resistance Poussee"
    },
    {
        Id = 417,
        Name = "-Resistance Poussee"
    },
    {
        Id = 138,
        Name = "Puissance"
    },
    {
        Id = 186,
        Name = "-Puissance"
    },
    {
        Id = 118,
        Name = "Force"
    },
    {
        Id = 157,
        Name = "-Force"
    },
    {
        Id = 119,
        Name = "Agilité"
    },
    {
        Id = 154,
        Name = "-Agilité"
    },
    {
        Id = 123,
        Name = "Chance"
    },
    {
        Id = 152,
        Name = "-Chance"
    },
    {
        Id = 125,
        Name = "Vitalite"
    },
    {
        Id = 153,
        Name = "-Vitalite"
    },
    {
        Id = 126,
        Name = "Intelligence"
    },
    {
        Id = 155,
        Name = "-Intelligence"
    },
    {
        Id = 174,
        Name = "Initiative"
    },
    {
        Id = 175,
        Name = "-Initiative"
    },
    {
        Id = 100,
        Name = "Degats Neutre"
    },
    {
        Id = 98,
        Name = "Degats Air"
    },
    {
        Id = 96,
        Name = "Degats Eau"
    },
    {
        Id = 99,
        Name = "Degats Feu"
    },
    {
        Id = 97,
        Name = "Degats Terre"
    }
}

PoidsByStat = {
    ["Vitalite"] = {PoidsUnite = 0.25, Runes = {{Id = 1523, Poids = 0.75}, {Id = 1548, Poids = 2.5}, {Id = 1554, Poids = 7.5}}},
    ["Force"] = {PoidsUnite = 1, Runes = {{Id = 1519, Poids = 1}, {Id = 1545, Poids = 3}, {Id = 1551, Poids = 10}}},
    ["Chance"] = {PoidsUnite = 1, Runes = {{Id = 1525, Poids = 1}, {Id = 1550, Poids = 3}, {Id = 1556, Poids = 10}}},
    ["Agilité"] = {PoidsUnite = 1, Runes = {{Id = 1524, Poids = 1}, {Id = 1549, Poids = 3}, {Id = 1555, Poids = 10}}},
    ["Intelligence"] = {PoidsUnite = 1, Runes = {{Id = 1522, Poids = 1}, {Id = 1547, Poids = 3}, {Id = 1553, Poids = 10}}},
    ["Initiative"] = {PoidsUnite = 0.1, Runes = {{Id = 7448, Poids = 1}, {Id = 7449, Poids = 3}, {Id = 7450, Poids = 10}}},
    ["Sagesse"] = {PoidsUnite = 3, Runes = {{Id = 1521, Poids = 3}, {Id = 1546, Poids = 9}, {Id = 1552, Poids = 30}}},
    ["Prospection"] = {PoidsUnite = 3, Runes = {{Id = 7451, Poids = 3}, {Id = 10662, Poids = 9}}},
    ["Puissance"] = {PoidsUnite = 2, Runes = {{Id = 7436, Poids = 2}, {Id = 10618, Poids = 6}, {Id = 10619, Poids = 20}}},

    ["Resistance Feu"] = {PoidsUnite = 2, Runes = {{Id = 7452, Poids = 2}}},
    ["Resistance Air"] = {PoidsUnite = 2, Runes = {{Id = 7453, Poids = 2}}},
    ["Resistance Eau"] = {PoidsUnite = 2, Runes = {{Id = 7454, Poids = 2}}},
    ["Resistance Terre"] = {PoidsUnite = 2, Runes = {{Id = 7455, Poids = 2}}},
    ["Resistance Neutre"] = {PoidsUnite = 2, Runes = {{Id = 7456, Poids = 2}}},
    ["% Resistance Feu"] = {PoidsUnite = 6, Runes = {{Id = 7457, Poids = 6}}},
    ["% Resistance Air"] = {PoidsUnite = 6, Runes = {{Id = 7458, Poids = 6}}},
    ["% Resistance Eau"] = {PoidsUnite = 6, Runes = {{Id = 7560, Poids = 6}}},
    ["% Resistance Terre"] = {PoidsUnite = 6, Runes = {{Id = 7459, Poids = 6}}},
    ["% Resistance Neutre"] = {PoidsUnite = 6, Runes = {{Id = 7460, Poids = 6}}},

    ["Resistance Poussee"] = {PoidsUnite = 2, Runes = {{Id = 11651, Poids = 2},{Id = 11652, Poids = 6}}},
    ["Resistance Critiques"] = {PoidsUnite = 2, Runes = {{Id = 11655, Poids = 2}, {Id = 11656, Poids = 6}}},

    ["Esquive PA"] = {PoidsUnite = 7, Runes = {{Id = 11641, Poids = 7}, {Id = 11642, Poids = 21}}},
    ["Esquive PM"] = {PoidsUnite = 7, Runes = {{Id = 11643, Poids = 7}, {Id = 11644, Poids = 21}}},
    ["Retrait PM"] = {PoidsUnite = 7, Runes = {{Id = 11647, Poids = 7}, {Id = 11648, Poids = 21}}},
    ["Retrait PA"] = {PoidsUnite = 7, Runes = {{Id = 11645, Poids = 7}, {Id = 11646, Poids = 21}}},
    ["Pods"] = {PoidsUnite = 0,25, Runes = {{Id = 7443, Poids = 2,5}, {Id = 7444, Poids = 7,5}, {Id = 7445, Poids = 25}}},
    ["Tacle"] = {PoidsUnite = 4, Runes = {{Id = 11639, Poids = 4}, {Id = 11640, Poids = 12}}},
    ["Fuite"] = {PoidsUnite = 4, Runes = {{Id = 11637, Poids = 4}, {Id = 11638, Poids = 12}}},

    ["Dommages"] = {PoidsUnite = 20, Runes = {{Id = 7435, Poids = 20}}},
    ["Dommages Feu"] = {PoidsUnite = 5, Runes = {{Id = 11659, Poids = 5}, {Id = 11660, Poids = 15}}},
    ["Dommages Eau"] = {PoidsUnite = 5, Runes = {{Id = 11661, Poids = 5}, {Id = 11662, Poids = 15}}},
    ["Dommages Air"] = {PoidsUnite = 5, Runes = {{Id = 11663, Poids = 5}, {Id = 11664, Poids = 15}}},
    ["Dommages Terre"] = {PoidsUnite = 5, Runes = {{Id = 11657, Poids = 5}, {Id = 11658, Poids = 15}}},

    ["Dommages Critiques"] = {PoidsUnite = 5, Runes = {{Id = 11653, Poids = 5}, {Id = 11654, Poids = 15}}},
    --["Dommages Pieges"] = {PoidsUnite = 5, Runes = {{Id = 7446, Poids = 5}, {Id = 10613, Poids = 15}}},
    ["Dommages Poussee"] = {PoidsUnite = 5, Runes = {{Id = 11649, Poids = 5}, {Id = 11650, Poids = 15}}},
    ["Dommages Neutre"] = {PoidsUnite = 5, Runes = {{Id = 11665, Poids = 5}, {Id = 11666, Poids = 15}}},

    --["Puissance Pieges"] = {PoidsUnite = 2, Runes = {{Id = 7447, Poids = 2}, {Id = 10615, Poids = 6}, {Id = 10616, Poids = 20}}},
    ["Soins"] = {PoidsUnite = 10, Runes = {{Id = 7434, Poids = 10}}},
    ["Critique"] = {PoidsUnite = 10, Runes = {{Id = 7433, Poids = 10}}},
    --["Renvoie dommages"] = {PoidsUnite = 10, Runes = {{Id = 7437, Poids = 10}}},

    ["Invocations"] = {PoidsUnite = 30, Runes = {{Id = 7442, Poids = 30}}},
    ["Portee"] = {PoidsUnite = 51, Runes = {{Id = 7438, Poids = 51}}},
    ["PA"] = {PoidsUnite = 100, Runes = {{Id = 1557, Poids = 100}}},
    ["PM"] = {PoidsUnite = 90, Runes = {{Id = 1558, Poids = 90}}},
}