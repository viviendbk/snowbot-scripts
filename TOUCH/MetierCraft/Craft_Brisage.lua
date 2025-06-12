dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


local TableItem = {}
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
        if element.GoCraft and inventory:itemCount(element.Id) < element.NbMaxToCraft then

            npc:sale()
            -- vérification que le craft est tjr rentable
            local TotalCost = 0
            local LackRessource = false

            for _, Ressource in ipairs(element.ListIdCraft) do
                local Price = GetPricesItem(Ressource.Id) 
                if not Price then
                    global:delay(500)
                    Price = GetPricesItem(Ressource.Id)
                end
                if not Price.AveragePrice or Price.AveragePrice == 0 then
                    LackRessource = true
                    break
                end
                if Price.Price100 == 0 and Price.Price10 == 0 and Ressource.Quantity > 20 then
                    LackRessource = true
                    break
                end
                TotalCost = TotalCost + GetPricesItem(Ressource.Id).AveragePrice * Ressource.Quantity     
            end

            element.TotalCost = TotalCost
            global:leaveDialog()

            -- si l'item n'est plus rentable ou n'est plus craftable
            if LackRessource then
                global:printError("Des ressources sont manquantes en hdv pour craft " .. inventory:itemNameId(element.Id))
                element.GoCraft = false
                return ProcessCraft(table, cellId, jobId)
            else
                global:printMessage("Total des couts pour craft " .. inventory:itemNameId(element.Id) .. " : " .. TotalCost)
                global:printMessage("Estimation des gains moyens si on le brise : " .. element.EstimationEarns)
            end

            if element.TotalCost * 1.15 < element.EstimationEarns then
                element.GoCraft = false
                global:printSuccess("L'item " .. inventory:itemNameId(element.Id) .. " n'est plus rentable à craft")
                return ProcessCraft(table, cellId, jobId)
            end

            local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.9
            local CraftQuantity = math.floor(math.min(podsAvailable / element.PodsNeededToCraft, 1))

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
    -- npc:npcSale()

    -- --global:printMessage("Récupération du prix des runes...")

    -- local PrixMoyen = 0
    -- local i = 0
    -- for k, v in pairs(PoidsByStat) do
    --     i = i + 1
    --     local partHdv = 0
    --     local prixParPoids = 0

    --     for _, element in ipairs(v.Runes) do
    --         element.Prices = GetPricesItem(element.Id)
    --         prixParPoids = prixParPoids + element.Prices.AveragePrice / element.Poids
    --     end

    --     v.PartsHdv = partHdv / (character:level() * 2)
    --     v.PrixParPoids = prixParPoids / #v.Runes
    --     PrixMoyen = PrixMoyen + v.PrixParPoids
    -- end

    -- --global:printSuccess("Récupération finie!")

    -- npc:npcBuy()

    -- global:printSuccess("renta de " .. inventory:itemNameId(261) .. " : " .. GetEstimationEarnsOnBreak(GetDice(261)) .. " kamas")

    -- global:finishScript()

    global:editAlias("bank_" .. character:serverName():lower() .. " : [" .. truncKamas() .. "m]", true)
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
                        GoCraft = false,
                    }
                    table.insert(TableItem, element)
                end
            end

            global:printSuccess("Remplissage fini!, il y a " .. #TableItem .. " items craftables")
        end

        developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
        npc:npcSale()

        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

        global:leaveDialog()

        --local kamasOwned = character:kamas()
        KamasDeBase = character:kamas()
        if character:kamas() < 1000000 then
            global:printSuccess("Pas assez de kamas")
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\MetierCraft\\Craft_ResellV2.lua")
        end
        local kamasOwned = character:kamas() >= 5000000 and 5000000 or character:kamas()
        local kamasDepense  = 0

        npc:npcSale()

        global:printMessage("Récupération du prix des runes...")

        local PrixMoyen = 0
        local i = 0
        for k, v in pairs(PoidsByStat) do
            i = i + 1
            local partHdv = 0
            local prixParPoids = 0

            for _, element in ipairs(v.Runes) do
                element.Prices = GetPricesItem(element.Id)
                prixParPoids = prixParPoids + element.Prices.AveragePrice / element.Poids
            end
            v.PartsHdv = partHdv / (character:level() * 2)
            v.PrixParPoids = prixParPoids / #v.Runes
            PrixMoyen = PrixMoyen + v.PrixParPoids
        end

        global:printSuccess("Récupération finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("Analyse de la rentabilité des items...")
        global:printMessage("--------------------------------------")
        PrixHdvAllRessources = {}

        for _, item in ipairs(TableItem) do
            if kamasOwned < 20000 then
                global:printSuccess("Plus assez de kamas pour faire d'autres crafts")
                break
            end

            if item.ListIdCraft and (item.JobLevelMini <= job:level(GetJobIdByType(item.Type))) then
                local TotalCost = 0
                local TotalPods = 0
                local LackRessource = false

                for _, Ressource in ipairs(item.ListIdCraft) do
                    if not PrixHdvAllRessources[Ressource.Id] then
                        PrixHdvAllRessources[Ressource.Id] = GetPricesItem(Ressource.Id)
                    end
                    if not PrixHdvAllRessources[Ressource.Id] or PrixHdvAllRessources[Ressource.Id].AveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id)) then
                        LackRessource = true
                        break
                    end
                    if PrixHdvAllRessources[Ressource.Id].Price100 == 0 and PrixHdvAllRessources[Ressource.Id].Price10 == 0 and Ressource.Quantity > 20 then
                        LackRessource = true
                        break
                    end
                    TotalPods = TotalPods + inventory:itemWeight(Ressource.Id) * Ressource.Quantity
                    TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].AveragePrice * Ressource.Quantity   
                end

                item.PodsNeededToCraft = TotalPods
                item.TotalCost = LackRessource and 0 or TotalCost
            end
        end

        npc:npcBuy()
        
        for _, item in ipairs(TableItem) do
            item.EstimationEarns = GetEstimationEarnsOnBreak(GetDice(item.Id))
            global:printMessage("[" .. inventory:itemNameId(item.Id) .. "] craft = " .. item.TotalCost .. " , renta = " .. item.EstimationEarns)
            if item.TotalCost > 0 and item.EstimationEarns > item.TotalCost * 1.2 and item.TotalCost * 1.5 < kamasOwned and (item.EstimationEarns - item.TotalCost) > 5000 then
                item.GoCraft = true

                kamasOwned = kamasOwned - item.TotalCost * 1.3
                global:printSuccess("On peut craft " .. inventory:itemNameId(item.Id) .. "!")
                kamasDepense = kamasDepense + item.TotalCost
                
                if item.Type == "Chapeau" or item.Type == "Cape" or item.Type == "Sac à dos" then
                    table.insert(CraftTailleur, item)
                elseif item.Type == "Ceinture" or item.Type == "Bottes" then
                    table.insert(CraftCordonier, item)
                elseif item.Type == "Anneau" or item.Type == "Amulette" then
                    table.insert(CraftBijoutier, item)
                end
            end
        end
        table.sort(TableItem, function(a, b) return (a.EstimationEarns / a.TotalCost) < (b.EstimationEarns / b.TotalCost) end)
        
        for _, item in ipairs(TableItem) do
            global:printMessage("[" .. inventory:itemNameId(item.Id) .. "] craft = " .. item.TotalCost .. " , renta = " .. item.EstimationEarns)
        end

        NbTotalCraft = #CraftBijoutier + #CraftCordonier + #CraftTailleur

        for _, item in ipairs(TableItem) do
            if item.GoCraft then
                item.NbMaxToCraft = (character:kamas() / NbTotalCraft) / item.TotalCost
            end
        end
        
        global:leaveDialog()     

        global:printMessage("--------------------------------------")
        global:printMessage("Nous allons faire : ")
        global:printMessage("- " .. #CraftBijoutier .. " craft bijoutier")
        global:printMessage("- " .. #CraftCordonier .. " craft cordonier")
        global:printMessage("- " .. #CraftTailleur .. " craft tailleur")

        global:printMessage("--------------------------------------")
        global:printMessage("Le cout Total des crafts est de " .. kamasDepense)
        global:printMessage("--------------------------------------")
        global:printSuccess("Analyse terminée!")

        inventory:openBank()
        exchange:putAllItems()

        for _, item in ipairs(CraftCordonier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbMaxToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftBijoutier) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbMaxToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                if Quantity > 0 then
                    exchange:getItem(ressource.Id, Quantity)
                end
            end
        end
        for _, item in ipairs(CraftTailleur) do
            for _, ressource in ipairs(item.ListIdCraft) do
                local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbMaxToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
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
        if item.GoCraft and inventory:itemCount(item.Id) < item.NbMaxToCraft then
            if not map:onMap(7864328) then
                return TreatMapBonta(goToAtelierCordoBonta)
            else
                ProcessCraft(CraftCordonier, 424, 15)
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if item.GoCraft and inventory:itemCount(item.Id) < item.NbMaxToCraft then
            if not map:onMap(3145733) then
                return TreatMapBonta(goToAtelierBijoutierBonta)
            else
                ProcessCraft(CraftBijoutier, 396, 16)
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if item.GoCraft and inventory:itemCount(item.Id) < item.NbMaxToCraft then
            if not map:onMap(7864327) then
                return TreatMapBonta(goToAtelierTailleurBonta)
            else
                ProcessCraft(CraftTailleur, 396, 27)
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