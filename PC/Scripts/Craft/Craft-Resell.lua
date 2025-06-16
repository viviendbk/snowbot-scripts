dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local dicoItems = {}
local TableItem = {}

local ScriptStarting = true
local bankChecked = false
local bankChecked2 = false
local hdvRessourceChecked = false
local hdvRessourceChecked2 = false
local hdvEquipChecked = false
local ItemSold = false


local function ProcessCraft(table, cellId)
    for _, element in ipairs(table) do
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local CraftQuantity = element.NbToCraft - inventory:itemCount(element.Id)

            for _, element2 in ipairs(element.ListIdCraft) do
                CraftQuantity = math.min(CraftQuantity, math.floor(inventory:itemCount(element2.Id) / element2.Quantity))
            end

            if CraftQuantity > 0 then
                global:printSuccess("On va craft " .. CraftQuantity .. " x [" ..  inventory:itemNameId(element.Id) .. "]")

                randomDelay()
                map:useById(TableOutilAtelier[element.Type].ElementId, -1)
                randomDelay()
    
                global:printSuccess("ok1")
                for _, item in ipairs(element.ListIdCraft) do
                    craft:putItem(item.Id, item.Quantity)
                    global:delay(math.random(200, 500))
                end
                global:printSuccess("ok2")

                craft:changeQuantityToCraft(CraftQuantity)
                global:delay(math.random(200, 500))
                craft:ready()
                global:printSuccess("Craft effectué !")
                global:leaveDialog()
    
                if ConsoleRead(global:thisAccountController(), "Erreur dans le script : Impossible d'utiliser l'élément interactif") then
                    global:clearConsole()
                    global:disconnect()
                end
                randomDelay()
                return ProcessCraft(table, cellId)
            end
        end
    end

    map:door(cellId)
end

local goToBankBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "top"},
    {map = "212599813", path = "zaapi(212600322)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600322)"}, -- extérieur atelier taileur
    {map = "212601350", path = "zaapi(212600322)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212600322)"}, -- hdv equipements
    {map = "212600322", door = "468"},
    -- intérieur 217059328
}

local goToHdvEquip = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212599813", path = "zaapi(212600837)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600837)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212600837)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212600837)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212600837)"}, -- extérieur atelier sculpteur
    {map = "212601350", path = "zaapi(212600837)"}, -- hdv ressources
    {map = "212600322", path = "zaapi(212600837)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212600837)"},
    {map = "212600323", path = "bottom"},
    -- map : 212600837
}

local goToHdvRessources = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601350)"},
    {map = "212601350", path = "zaapi(212601350)"},
    {map = "212600837", path = "zaapi(212601350)"},
    {map = "212599813", path = "zaapi(212601350)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601350)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212601350)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212601350)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212601350)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212601350)"}, -- exterieur banque
    {map = "212600837", path = "zaapi(212601350)"}, -- hdv equipements
    -- map : 212601350
}

local goToAtelierCordoBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601347)"},
    {map = "212599813", path = "zaapi(212601347)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601347)"}, -- extérieur atelier taileur
    {map = "212601348", path = "zaapi(212601347)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212601347)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212601347)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212601347)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601347)"}, -- hdv equipements

    {map = "212601347", door = "231"}, -- extérieur atelier cordonier
}

local goToAtelierBijoutierBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212599813)"},
    {map = "212599814", path = "zaapi(212599813)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212599813)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212599813)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212599813)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212599813)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212599813)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212599813)"}, -- hdv equipements

    {map = "212599813", door = "343"}, -- extérieur atelier bijoutier
}

local goToAtelierTailleurBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212599814)"},
    {map = "212599813", path = "zaapi(212599814)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212599814)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212599814)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212599814)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212599814)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212599814)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212599814)"}, -- hdv equipements

    {map = "212599814", door = "496"}, -- extérieur atelier tailleur
}

local goToAtelierForgeronBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601348)"},
    {map = "212599814", path = "zaapi(212601348)"}, -- extérieur atelier taileur
    {map = "212599813", path = "zaapi(212601348)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212601348)"}, -- extérieur atelier cordonier
    {map = "212601860", path = "zaapi(212601348)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212601348)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212601348)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601348)"}, -- hdv equipements

    {map = "212601348", door = "356"}, -- extérieur atelier forgeron
}

local goToAtelierSculpteurBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601860)"},
    {map = "212601348", path = "zaapi(212601860)"}, -- extérieur atelier forgeron
    {map = "212599814", path = "zaapi(212601860)"}, -- extérieur atelier taileur
    {map = "212599813", path = "zaapi(212601860)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212601860)"}, -- extérieur atelier cordonier
    {map = "212600322", path = "zaapi(212601860)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212601860)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601860)"}, -- hdv equipements

    {map = "212601860", door = "412"} -- extérieur atelier sculpteur
}

local goToAtelierFaconneur = {
    {map = "0,0", path = "zaap(165152263)"},
    {map = "165152263", path = "top"},
    {map = "165152262", door = "261"},
    {map = "81788928", door = "186"},
}

local goToHdvRunes = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "217056262", door = "429"},
    {map = "212600323", path = "zaapi(212601859)"},
    {map = "212601348", path = "zaapi(212601859)"}, -- extérieur atelier forgeron
    {map = "212599814", path = "zaapi(212601859)"}, -- extérieur atelier taileur
    {map = "212599813", path = "zaapi(212601859)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212601859)"}, -- extérieur atelier cordonier
    {map = "212600322", path = "zaapi(212601859)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212601859)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601859)"}, -- hdv equipements
}

local goToBrisage = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601859)"},
    {map = "212601348", path = "zaapi(212601859)"}, -- extérieur atelier forgeron
    {map = "212599814", path = "zaapi(212601859)"}, -- extérieur atelier taileur
    {map = "212599813", path = "zaapi(212601859)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(212601859)"}, -- extérieur atelier cordonier
    {map = "212600322", path = "zaapi(212601859)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212601859)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212601859)"}, -- hdv equipements

    {map = "212601859", door = "401"} -- extérieur brisage 
}


local CraftFaconneur = {}
local CraftCordonier = {}
local CraftBijoutier = {}
local CraftTailleur = {}
local CraftForgeron = {}
local CraftSculpteur = {}

local tableCraft = {
    {table = CraftBijoutier, path = goToAtelierBijoutierBonta, mapIdInsideWorkshop = 217058310, cellIdOutWorkshop = 485, types = {"Anneau", "Amulette"}},
    {table = CraftCordonier, path = goToAtelierCordoBonta, mapIdInsideWorkshop = 217055238, cellIdOutWorkshop = 360, types = {"Ceinture", "Bottes"}},
    {table = CraftFaconneur, path = goToAtelierFaconneur, mapIdInsideWorkshop = 81788930, cellIdOutWorkshop = 443, types = {"Bouclier", "Trophet"}},
    {table = CraftTailleur, path = goToAtelierTailleurBonta, mapIdInsideWorkshop = 217056260, cellIdOutWorkshop = 520, types = {"Chapeau", "Cape", "Sac à dos"}},
    {table = CraftForgeron, path = goToAtelierForgeronBonta, mapIdInsideWorkshop = 217055236, cellIdOutWorkshop = 526, types = {"Épée", "Hache", "Marteau", "Dague", "Pelle"}},
    {table = CraftSculpteur, path = goToAtelierSculpteurBonta, mapIdInsideWorkshop = 217058308, cellIdOutWorkshop = 479, types = {"Bâton", "Baguette", "Arc"}},
}



local function HaveToBuyRessources()
    local toReturn = false

    for _, element in ipairs(tableCraft) do
        for _, item in ipairs(element.table) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        toReturn = true
                    end
                end
            end
        end
    end

    global:printSuccess(toReturn)
    return toReturn
end

local function EditJsonRessources(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceRessources.json")

    if not jsonMemory[1] then
        jsonMemory[1] = {Date = getDate(), Time = getCurrentTime(), Prices = content}
    else
        jsonMemory[1].Date = getDate()
        jsonMemory[1].Time = getCurrentTime()
        jsonMemory[1].Prices = content
    end    

    local new_content = json.encode(jsonMemory)

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceRessources.json", "w")

    file:write(new_content)

    file:close()
end

local function EditJsonItems(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceItems.json")

    if not jsonMemory[1] then
        jsonMemory[1] = {Date = getDate(), Time = getCurrentTime(), Prices = content}
    else
        jsonMemory[1].Date = getDate()
        jsonMemory[1].Time = getCurrentTime()
        jsonMemory[1].Prices = content
    end

    local new_content = json.encode(jsonMemory)

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\PriceItems.json", "w")

    file:write(new_content)
    file:close()
end

local function getPricesResourceInHDV()
        global:printMessage("Récupération du prix des ressources...")
        local PrixHdvAllRessources = {}

        if cpt == 0 then
            cpt = cpt +1
            for _, item in ipairs(TableItem) do
            
                if _ == math.floor(#TableItem / 4) then
                    global:printMessage("25% effectué...")
                elseif _ == math.floor(#TableItem / 2) then
                    global:printMessage("50% effectué...")
                elseif _ == math.floor(#TableItem * 0.75) then
                    global:printMessage("75% effectué...")
                end
                
                if item.ListIdCraft then
                    for _, Ressource in ipairs(item.ListIdCraft) do
                        if not PrixHdvAllRessources[tostring(Ressource.Id)] then
                            PrixHdvAllRessources[tostring(Ressource.Id)] = GetPricesItem(Ressource.Id)
                        end
                    end
                end
            end
        end

        global:delay(2000)

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("")

        global:leaveDialog()

        EditJsonRessources(PrixHdvAllRessources)
end

local function getPricesItemsInHDV()
        local priceItems = {}
        for _, item in ipairs(TableItem) do
            if _ == math.floor(#TableItem / 4) then
                global:printMessage("25% effectué...")
            elseif _ == math.floor(#TableItem / 2) then
                global:printMessage("50% effectué...")
                global:leaveDialog()
                map:moveToCell(397)
                HdvSell()
            elseif _ == math.floor(#TableItem * 0.75) then
                global:printMessage("75% effectué...")
            end

            if not priceItems[tostring(item.Id)] then
                priceItems[tostring(item.Id)] = GetPricesItem(item.Id)
            end

            item.PriceHdv = priceItems[tostring(item.Id)]
        end

        global:delay(2000)

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("")

        global:leaveDialog()

        EditJsonItems(priceItems)
end

function move()

    mapDelay()
    if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
    end
    if global:thisAccountController():getAlias():find("Craft2") then
        global:editAlias("Craft2 " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    else
        global:editAlias("Craft " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    end
    --- Determines which item we'll craft and resell

    if ScriptStarting then
        -- vérifie qu'il est bien abonné        
        if getRemainingSubscription(true) <= 0 and character:kamas() > (character:server() == "Draconiros" and 550000 or 1000000) then
            global:printSuccess("il reste " .. getRemainingSubscription(true) .. "jours d'abonnement, on tente de s'abonner à nouveau")
            Abonnement()
        elseif getRemainingSubscription(true) < 0 then
            Abonnement()
        end

        if global:thisAccountController():getAlias():find("Craft2") and not delay then
            delay = true
            global:printMessage("On attend 1 à 2 minutes avant de commancer")
            RECONNECT_ON_TIMEOUT = false
            global:delay(math.random(60000, 120000))
            RECONNECT_ON_TIMEOUT = true
        end

        if #TableItem == 0 then
        
            global:printSuccess("Remplissage de la TableItem...")

            local jsonFile = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\" .. character:server() .. "\\Craft-Resell.json")
            for i = 1, 20000 do
                if IsItem(inventory:itemTypeId(i)) and inventory:getLevel(i) <= job:level(GetJobIdByType(inventory:getTypeName(i))) and inventory:getLevel(i) > (character:server() == "Draconiros" and 49 or 49)
                and inventory:getLevel(i) < (character:server() == "Ombre" and 150 or 200) and ((inventory:itemCount(i) > 0 and inventory:itemPosition(i) == 63) or inventory:itemCount(i) == 0) and CanCraftItem(i, jsonFile) then
                    table.insert(TableItem, {
                        Id = i,
                        ListIdCraft = getIngredients(i),
                        Type = inventory:getTypeName(i),
                        NbToCraft = 1
                    })
                end
            end
            global:printSuccess("Remplissage fini!, il y a " .. #TableItem .. " items craftables")
        end

        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked then
            return treatMaps(goToBankBonta)
        elseif not bankChecked then
            npc:npcBank(-1)
            if exchange:storageKamas() > 0 then
                exchange:putAllItems()
                randomDelay()
                exchange:getKamas(0)
                randomDelay()
                global:printSuccess("j'ai récupérer les kamas, je vais vendre")
            elseif exchange:storageKamas() == 0 then
                exchange:putAllItems()
                randomDelay()
                global:printError("il n'y a pas de kamas dans la banque")
            end	

            dicoItems = {}
            local itemsInBank = exchange:storageItems()
            for _, item in ipairs(itemsInBank) do
                if IsItem(inventory:itemTypeId(item)) and ItemHasTwoOrMoreCarac(item) then
                    dicoItems[tostring(item)] = not dicoItems[tostring(item)] and 1 or dicoItems[tostring(item)] + 1
                    for i = 1, exchange:storageItemQuantity(item) do
                        if exchange:storageItemQuantity(item) > 0 then
                            exchange:getItem(item, 1)
                        end
                    end
                end
            end

            for k, v in pairs(dicoItems) do
                if v > 1 or inventory:getLevel(tonumber(k)) <= 50 then
                    global:printSuccess("On va briser des doublons d'items")
                    goBreak = true
                end
            end

            global:printMessage("Recupération des runes...")
            local content = exchange:storageItems()
    
            for _, item in ipairs(content) do
                if inventory:itemTypeId(item) == 78 and item ~= 10057 then
                    local quantity = math.min(exchange:storageItemQuantity(item), inventory:podsP() < 80 and 500 or 0)
                    if quantity > 0 then
                        exchange:getItem(item, quantity)
                    end
                    if exchange:storageItemQuantity(item) > 2000 then
                        PoidsByStat[GetStatByRune(item)].CantBreak = true
                    else
                        PoidsByStat[GetStatByRune(item)].CantBreak = false
                    end
                end 
            end
            global:printSuccess("Récupération finie !")

            global:leaveDialog()
            bankChecked = true
            map:door(518)
        end

        -- va hdv runes pour récupérer le prix / poids de chaque item et la répartition hdv
        if not map:onMap(212601859) and not hdvRunesChecked then
            return treatMaps(goToHdvRunes)
        elseif not hdvRunesChecked then

            if goBreak then
                HdvSell()
                global:printMessage("Récupération du prix des runes...")
    
                local PrixMoyen = 0
                local i = 0
                for k, v in pairs(PoidsByStat) do
                    i = i + 1
                    local partHdv = 0
                    local prixParPoids = 0
        
                    for _, element in ipairs(v.Runes) do
                        element.Prices = GetPricesItem(element.Id)
                        partHdv = partHdv + get_quantity(element.Id).total_lots
                        prixParPoids = prixParPoids + element.Prices.TrueAveragePrice / element.Poids
                    end
                    v.PartsHdv = partHdv / (character:level() * 2)
                    v.PrixParPoids = prixParPoids / #v.Runes
                    PrixMoyen = PrixMoyen + v.PrixParPoids
                end
        
                global:printSuccess("Récupération finie!")
                global:leaveDialog()
            end

            -- si on a plusieurs fois le même item, on analyse le prix des runes pour déterminer le meilleur focus pour cet item, on va les briser et on retourne ici
            HdvSell()
            global:printSuccess("vente des runes")
            local content = inventory:inventoryContent()

            for _, item in ipairs(content) do
                if inventory:itemTypeId(item.objectGID) == 78 then
                    local Prices = GetPricesItem(item.objectGID)
                    local itemSold = false
    
                    local cpt = get_quantity(item.objectGID).quantity["100"]
                    local Priceitem1 = Prices.Price100
                    Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and sale:getAveragePriceItem(item.objectGID, 3) * 1.5 or Priceitem1
                    while (inventory:itemCount(item.objectGID) >= 100) and (sale:availableSpace() > 0) and (((Priceitem1 > 4000) and (cpt < math.floor(10 * (character:level() / 200)))) or ((Priceitem1 > 10000) and cpt < math.floor(15 * (character:level() / 200))) or (cpt < math.floor(5 * (character:level() / 200)) and Priceitem1 > 2000)) do 
                        sale:sellItem(item.objectGID, 100, Priceitem1 - 1) 
                        global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(item.objectGID) .. " à " .. Priceitem1 - 1 .. "kamas")
                        cpt = cpt + 1
                        itemSold = true
                    end
            
                    cpt = get_quantity(item.objectGID).quantity["10"]
                    local Priceitem2 = Prices.Price10
                    Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and sale:getAveragePriceItem(item.objectGID, 2) * 1.5 or Priceitem2
                    while (inventory:itemCount(item.objectGID) >= 10) and (sale:availableSpace() > 0) and (((Priceitem2 > 4000) and (cpt < math.floor(10 * (character:level() / 200)))) or  ((Priceitem2 > 10000) and cpt < math.floor(15 * (character:level() / 200))) or (cpt < math.floor(5 * (character:level() / 200)) and Priceitem2 > 2000)) do 
                        sale:sellItem(item.objectGID, 10, Priceitem2 - 1) 
                        global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(item.objectGID) .. " à " .. Priceitem2 - 1 .. "kamas")
                        cpt = cpt + 1
                        itemSold = true
                    end
            
                    cpt = get_quantity(item.objectGID).quantity["1"]
                    local Priceitem3 = Prices.Price1
                    Priceitem3 = (Priceitem3 == nil or Priceitem3 == 0 or Priceitem3 == 1) and sale:getAveragePriceItem(item.objectGID, 1) * 1.5 or Priceitem3
                    while (inventory:itemCount(item.objectGID) >= 1) and (sale:availableSpace() > 0) and (((Priceitem3 > 4000) and (cpt < math.floor(10 * (character:level() / 200)))) or  ((Priceitem3 > 10000) and cpt < math.floor(15 * (character:level() / 200))) or (cpt < math.floor(5 * (character:level() / 200)) and Priceitem3 > 2000)) do 
                        sale:sellItem(item.objectGID, 1, Priceitem3 - 1) 
                        global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(item.objectGID) .. " à " .. Priceitem3 - 1 .. "kamas")
                        cpt = cpt + 1
                        itemSold = true
                    end
    
                    if itemSold then
                        randomDelay()
                    end

                end
            end

            local random = math.random(1, 5)
            if random == 1 then
                sale:updateAllItems()
            end

            global:leaveDialog()

            hdvRunesChecked = true
        end

        if not map:onMap(217056262) and goBreak then
            return treatMaps(goToBrisage)
        elseif goBreak then
                
            for k, v in pairs(dicoItems) do
                if v > 1 and (inventory:itemCount(tonumber(k)) > 1 or inventory:getLevel(tonumber(k)) <= 50) and inventory:itemPosition(tonumber(k)) == 63 then

                    global:printMessage("On va briser [" .. inventory:itemNameId(tonumber(k)) .. "] " .. v .. " fois") 
                    local StatSearched = GetBestFocusOnJp(tonumber(k))

                    global:printSuccess(StatSearched)
                    local content = inventory:inventoryContent()

                    for _, element in ipairs(content) do
                        if inventory:podsP() > 95 then
                            bankChecked = false
                            global:printError("On a plus de place, on va en banque")
                            return move()
                        end

                        if element.objectGID == tonumber(k) then
                            map:useById(521675, -1)
                            randomDelay()

                            -- depot de l'item dans le briseur
                            local message = developer:createMessage("ExchangeObjectMoveMessage")
                            message.objectUID = inventory:getUID(tonumber(k))
                            message.quantity = 1
                            developer:sendMessage(message)  
                            developer:suspendScriptUntil("ExchangeObjectAddedMessage", 5000, false, nil, 50)

                            -- brisage
                            randomDelay()
                            developer:registerMessage("DecraftResultMessage", GetResultBreak)
                            message = developer:createMessage("FocusedExchangeReadyMessage")
                            if StatSearched == "No focus" then
                                message.focusActionId = 0
                            else
                                message.focusActionId = GetIdCarac(StatSearched)
                            end
                            message.ready = true
                            message.steep = 1
                            developer:sendMessage(message)
                            randomDelay()
                            developer:suspendScriptUntil("DecraftResultMessage", 5000, false, nil, 20)
                            global:leaveDialog()
                        end
                    end

                end
            end
            
            global:printMessage("Fusion des runes!")
    
            -- fusion des runes
            map:useById(521675, -2)
            local content = inventory:inventoryContent()
    
            for _, element in ipairs(content) do
                if inventory:itemTypeId(element.objectGID) == 78 and GetNumberOfMergeAvailable(element.objectGID) == 2 and inventory:itemCount(element.objectGID) > 29 then
                    global:printMessage("Analyse des possibles fusions de [" .. inventory:itemNameId(element.objectGID) .. "]")
                    local tabPriceByPui = {
                        GetPriceByNumberRune(element.objectGID),
                        GetPriceByNumberRune(GetMergedRuneId(element.objectGID)),
                        GetPriceByNumberRune(GetMergedRuneId(GetMergedRuneId(element.objectGID)))
                    }
    
                    local MaxPrice = 0
                    local IndexMaxPrice = 0
                    for i, price in ipairs(tabPriceByPui) do
                        if price > MaxPrice then
                            MaxPrice = price
                            IndexMaxPrice = i
                        end
                    end
    
                    if IndexMaxPrice == 2 then
                        global:printSuccess("On fusionne 1 fois")
                        local quantity = math.floor(inventory:itemCount(element.objectGID) / 3)
                        craft:putItem(element.objectGID, 3)
                        randomDelay()
                        craft:changeQuantityToCraft(quantity)
                        randomDelay()
                        craft:ready()
                    elseif IndexMaxPrice == 3 then
                        global:printSuccess("On fusionne 2 fois")
                        local quantity = math.floor(inventory:itemCount(element.objectGID) / 3)
                        craft:putItem(element.objectGID, 3)
                        randomDelay()
                        craft:changeQuantityToCraft(quantity)
                        randomDelay()
                        craft:ready()
                        randomDelay()
                        local nbNextRunes = inventory:itemCount(GetMergedRuneId(element.objectGID))
                        if nbNextRunes > 2 then
                            craft:putItem(GetMergedRuneId(element.objectGID), 3)
                            craft:changeQuantityToCraft(nbNextRunes / 3)
                            craft:ready()
                        end
                    end
    
                elseif inventory:itemTypeId(element.objectGID) == 78 and GetNumberOfMergeAvailable(element.objectGID) == 1 and inventory:itemCount(element.objectGID) > 29 then
                    global:printMessage("Analyse des possibles fusions de [" .. inventory:itemNameId(element.objectGID) .. "]")
                    local tabPriceByPui = {
                        GetPriceByNumberRune(element.objectGID),
                        GetPriceByNumberRune(GetMergedRuneId(element.objectGID)),
                    }
                    local MaxPrice = 0
                    local IndexMaxPrice
                    for i, price in ipairs(tabPriceByPui) do
                        if price > MaxPrice then
                            MaxPrice = price
                            IndexMaxPrice = i
                        end
                    end
                    
                    if IndexMaxPrice == 2 then
                        global:printSuccess("On fusionne 1 fois")
                        local quantity = math.floor(inventory:itemCount(element.objectGID) / 3)
                        craft:putItem(element.objectGID, 3)
                        randomDelay()
                        craft:changeQuantityToCraft(quantity)
                        randomDelay()
                        craft:ready()
                    end
    
                end
            end
            global:leaveDialog()
            goBreak = false

            local jsonFile = openFile(global:getCurrentScriptDirectory() .. "\\Brisage.json")
            SetNewTempBrisage({}, jsonFile)
        end


        --local kamasOwned = character:kamas()
        KamasDeBase = character:kamas()
        local kamasOwned = character:kamas() >= 50000000 and 50000000 or character:kamas()
        local kamasDepense  = 0

        -- --va hdv ressources
        if not map:onMap(212601350) and not hdvRessourceChecked then
            return treatMaps(goToHdvRessources)
        elseif not hdvRessourceChecked then
            --récupère le cout total du craft de chaque item et le met dans la table
            
            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Analyse des coût de craft des items...")

            local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceRessources.json")
            
            if not jsonPrice then
                global:printSuccess("Bug")
            end
            jsonPrice = not jsonPrice and {{Date = getDate(), Time = getCurrentTime(), Prices = {}}} or jsonPrice

            global:printSuccess(jsonPrice[1].Date)
            if isXDaysLater(jsonPrice[1].Date, 2) then
                global:printSuccess("Le prix des ressources ne sont pas à jour, on les récupère")
                getPricesResourceInHDV()
            end

            HdvSell()

            for _, item in ipairs(TableItem) do
                
                if _ == math.floor(#TableItem / 4) then
                    global:printMessage("25% effectué...")
                elseif _ == math.floor(#TableItem / 2) then
                    global:printMessage("50% effectué...")
                elseif _ == math.floor(#TableItem * 0.75) then
                    global:printMessage("75% effectué...")
                end

                local TotalCost = 0
                local TotalPods = 0
                local LackRessource = false

                if item.Type == "Idole" then
                    item.PriceHdv = GetPricesItem(item.Id).Price1
                end
                
                if not item.ListIdCraft then
                    LackRessource = true
                else
                    for _, Ressource in ipairs(item.ListIdCraft) do
                        if not jsonPrice[1].Prices[tostring(Ressource.Id)] then
                            jsonPrice[1].Prices[tostring(Ressource.Id)] = GetPricesItem(Ressource.Id)
                        end
        
                        if not jsonPrice[1].Prices[tostring(Ressource.Id)].TrueAveragePrice or jsonPrice[1].Prices[tostring(Ressource.Id)].TrueAveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id))
                        or (Ressource.Quantity > 29 and jsonPrice[1].Prices[tostring(Ressource.Id)].Price100 == 0 and jsonPrice[1].Prices[tostring(Ressource.Id)].Price10 == 0)  then
                            LackRessource = true
                            break
                        end
                        TotalPods = TotalPods + inventory:itemWeight(Ressource.Id) * Ressource.Quantity
                        TotalCost = TotalCost + jsonPrice[1].Prices[tostring(Ressource.Id)].TrueAveragePrice * Ressource.Quantity
                    end
                end
    
                if LackRessource then
                    --global:printError("Des ressources sont manquantes en hdv pour le craft " .. inventory:itemNameId(item.Id))
                    item.TotalCost = 0
                else
                    --global:printMessage("Total des couts pour craft " .. inventory:itemNameId(item.Id) .. " : " .. TotalCost)
                    item.TotalCost = TotalCost
                end 

                item.PodsNeededToCraft = TotalPods
    
            end

            global:printSuccess("Analyse finie!")
            global:printMessage("--------------------------------------")
            global:printMessage("")

            global:leaveDialog()
            hdvRessourceChecked = true
        end

        -- va hdv equipement
        if not map:onMap(212600837) and not hdvEquipChecked then
            return treatMaps(goToHdvEquip)
        elseif not hdvEquipChecked then

            HdvSell2()

            local nbItemsToCraft = sale:availableSpace()
            local random = math.random(1, 3)
            
            
            -- update les prix des items
            if random == 1 then
                global:printSuccess("On actualise tous les prix")
                UpdateAllItemOpti()
            end
            --récpère les prix hdv de   tous les items présent dans notre liste (craftables) et les met dans la table

            if nbItemsToCraft == 0 then
                global:printError("l'hdv est plein, on retente dans X heures")
                local random = math.random(1, 3)
                if random ~= 1 and character:kamas() > 10000000 then
                    global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
                elseif random == 2 then
                    customReconnect(math.random(100, 150))
                else
                    customReconnect(math.random(480, 600))
                end
            end
            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Récupération du prix hdv des items...")

            local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceItems.json")

            jsonPrice = not jsonPrice and {{Date = getDate(), Time = getCurrentTime(), Prices = {}}} or jsonPrice

            if isXDaysLater(jsonPrice[1].Date, 2) then
                global:printSuccess("Les prix des items ne sont pas à jour, on les récup")
                getPricesItemsInHDV()
            end

            for _, item in ipairs(TableItem) do
                if not item.PriceHdv then
                    item.PriceHdv = 0
                end
                if not item.TotalCost then
                    item.TotalCost = 99999999999999999
                end
                if _ == math.floor(#TableItem / 4) then
                    global:printMessage("25% effectué...")
                elseif _ == math.floor(#TableItem / 2) then
                    global:printMessage("50% effectué...")
                    global:leaveDialog()
                    randomDelay()
                    map:moveToCell(397)
                    HdvSell()
                elseif _ == math.floor(#TableItem * 0.75) then
                    global:printMessage("75% effectué...")
                end

                if not jsonPrice[1].Prices[tostring(item.Id)] then
                    jsonPrice[1].Prices[tostring(item.Id)] = GetPricesItem(item.Id)
                end

                item.PriceHdv = jsonPrice[1].Prices[tostring(item.Id)].Price1
            end

            global:leaveDialog()
            global:printSuccess("Récupération finie!")
            global:printMessage("--------------------------------------")
            global:printMessage("")

            -- vend tous les items qu'on a sur nous au meilleur prix
            global:printMessage("Vente des items présents dans l'inventaire...")


            HdvSell()
            local availableSpace = sale:availableSpace()
            local content = inventory:inventoryContent()
            for _, item in ipairs(content) do
                for _, item2 in ipairs(TableItem) do
                    if item.objectGID == item2.Id then
                        local cpt = get_quantity(item.objectGID).quantity["1"]
                        while inventory:itemCount(item.objectGID) > 0 and inventory:itemPosition(item.objectGID) == 63 and IsItem(inventory:itemTypeId(item.objectGID)) 
                        and availableSpace > 0 and cpt < 2 do
                            availableSpace = availableSpace - 1
                            global:printSuccess("on tente de vendre " .. inventory:itemNameId(item.objectGID))
                            SellItem(item.objectGID, item2.TotalCost, 0)
                            randomDelay()
                            cpt = cpt + 1
                        end
                    end
                end
            end

            global:printSuccess("fini!")
            global:leaveDialog()
            randomDelay()
            HdvSell()
            nbItemsToCraft = sale:availableSpace()
            randomDelay()
            global:leaveDialog()

            global:printSuccess("Il y a actuellement " .. get_quantity(0).totalItems .. " items en hdv et " .. get_quantity(0).totalDifferentsItems .. " items différents")

            -- trie la table du plus rentable à craft au moins rentable
            table.sort(TableItem, function (a, b)
                return (a.PriceHdv - a.TotalCost) > (b.PriceHdv - b.TotalCost)
            end)

            local podsAvailable = inventory:podsMax() - inventory:pods()

            global:printMessage("Analyse de la rentabilité des items...")
            global:printMessage("--------------------------------------")

            for _, item in ipairs(TableItem) do
                if kamasOwned < 100000 then
                    global:printSuccess("Plus assez de kamas pour faire d'autres crafts")
                    break
                end
                if nbItemsToCraft > 0 and get_quantity(item.Id).total_quantity < item.NbToCraft and item.TotalCost > 0 and item.TotalCost < 1500000 
                and item.TotalCost < character:kamas() * 0.9 and item.PriceHdv > 0 and (item.PriceHdv / item.TotalCost) > 1.3 and (item.PriceHdv - item.TotalCost) > 10000 
                and podsAvailable > item.PodsNeededToCraft * 2 and (kamasOwned - item.TotalCost * item.NbToCraft * 1.1) > 100000 then

                    item.NbToCraft = item.NbToCraft - get_quantity(item.Id).total_quantity
                    kamasOwned = kamasOwned - item.TotalCost * item.NbToCraft * 1.1
                    kamasDepense = kamasDepense + item.TotalCost * item.NbToCraft
                    podsAvailable = podsAvailable - item.PodsNeededToCraft


                    if item.ListIdCraft and item.NbToCraft > 0 then

                        nbItemsToCraft = nbItemsToCraft - item.NbToCraft
                        global:printSuccess("[Item] : " .. inventory:itemNameId(item.Id) .. ", [Coût de craft] : " .. item.TotalCost .. ", [Revente] : " .. item.PriceHdv .. ", [Renta Mini] : " .. (item.PriceHdv / item.TotalCost) .. "%, [NbHdv] : " .. get_quantity(item.Id).total_quantity)
                        for _, element in ipairs(tableCraft) do
                            for _, type in ipairs(element.types) do
                                if item.Type == type then
                                    table.insert(element.table, item)
                                end
                            end
                        end
                        global:printSuccess("Pods available après ce craft : " .. podsAvailable)
                    end

                end
            end

            global:printMessage("--------------------------------------")
            global:printMessage("Nous allons faire : ")
            for _, element in ipairs(tableCraft) do
                global:printMessage("- " .. #element.table .. " craft")
            end
            global:leaveDialog()     

            global:printMessage("--------------------------------------")
            global:printMessage("Le cout Total des crafts est de " .. kamasDepense)
            global:printMessage("--------------------------------------")
            global:printSuccess("Analyse terminée!")

            hdvEquipChecked = true
        end
        
        -- --va hdv ressources
        if not map:onMap(212601350) and not hdvRessourceChecked2 then
            return treatMaps(goToHdvRessources)
        elseif not hdvRessourceChecked2 then
            --récupère le cout total du craft de chaque item et le met dans la table
            
            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Vérification du vrai coût de craft des items...")

            HdvSell()

            local json = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\" .. character:server() .. "\\Craft-Resell.json")
            local newTemp = {}

            for _, element in ipairs(tableCraft) do
                for i = #element.table, 1, -1 do
                    local item = element.table[i]
                    local realPrice = 0
                    for _, ressource in ipairs(item.ListIdCraft) do
                        realPrice = realPrice + GetPricesItem(ressource.Id).TrueAveragePrice + ressource.Quantity
                    end
                    if not ((item.PriceHdv / realPrice) > 1.3 and (item.PriceHdv - realPrice) > 10000) then
                        global:printError("L'item " .. inventory:itemNameId(item.Id) .. " n'est plus rentable à faire")
                        table.remove(element.table, i)
                    else
                        table.insert(newTemp, item.Id)
                    end
                end
            end
            SetNewTemp(newTemp, json)

            global:printMessage("--------------------------------------")   

            global:printSuccess("Vérification terminée!")
            global:printMessage("--------------------------------------")
            global:printMessage("")

            global:leaveDialog()
            hdvRessourceChecked2 = true
        end

        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked2 then
            return treatMaps(goToBankBonta)
        elseif not bankChecked2 then
            npc:npcBank(-1)
            if exchange:storageKamas() > 0 then
                exchange:putAllItems()
                randomDelay()
                exchange:getKamas(0)
                randomDelay()
                global:printSuccess("j'ai récupérer les kamas, je vais vendre")
            elseif exchange:storageKamas() == 0 then
                exchange:putAllItems()
                randomDelay()
                global:printError("il n'y a pas de kamas dans la banque")
            end	

            for _, element in ipairs(tableCraft) do
                for _, item in ipairs(element.table) do
                    for _, ressource in ipairs(item.ListIdCraft) do
                        local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                        local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                        if Quantity > 0 then
                            exchange:getItem(ressource.Id, Quantity)
                        end
                    end
                end
            end
            global:leaveDialog()
            bankChecked2 = true
            map:door(518)
        end

        ScriptStarting = false
    end

    global:printSuccess("1")

    if not map:onMap(212601350) and HaveToBuyRessources() then
        return treatMaps(goToHdvRessources)
    elseif HaveToBuyRessources() then
        HdvBuy()

        for _, element in ipairs(tableCraft) do
            for _, item in ipairs(element.table) do
                if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                    global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                    global:printMessage("--------------------------------------")
                    for _, ressource in ipairs(item.ListIdCraft) do
                        local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                        if QuantityToBuy > 0 then
                            global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                            if not Achat(ressource.Id, QuantityToBuy) then
                                item.NbToCraft = 0
                                break
                            end
                        end
                    end
                    global:printMessage("--------------------------------------")
                end
            end
        end
        if character:isBusy() then
            global:leaveDialog()
        end
    end
    --- Determines which item we'll craft and resell
    global:printSuccess("2")

    --- Path To Craft

    for _, element in ipairs(tableCraft) do
        for _, item in ipairs(element.table) do
            if inventory:itemCount(item.Id) < item.NbToCraft then
                if not map:onMap(element.mapIdInsideWorkshop) then
                    return treatMaps(element.path)
                else
                    ProcessCraft(element.table, element.cellIdOutWorkshop)
                end
            end
        end
    end
    
    global:printSuccess("3")

    --- Path To Craft

    --- Final Selling

    if not map:onMap(212600837) and not ItemSold then
        return treatMaps(goToHdvEquip)
    elseif not ItemSold then
        local content = inventory:inventoryContent()
        for _, item in ipairs(content) do
            for _, element in ipairs(TableItem) do
                if item.objectGID == element.Id then
                    if inventory:itemCount(item.objectGID) > 1 then
                        global:printError("Bug trop d'item" .. inventory:itemNameId(item.Id) .. " en inventaire")
                        global:disconnect()
                    end
                    while inventory:itemCount(item.objectGID) > 0 and inventory:itemPosition(item.objectGID) == 63 and IsItem(inventory:itemTypeId(item.objectGID)) 
                    and sale:availableSpace() > 0 do
                        global:printMessage("Cout de craft pour " .. inventory:itemCount(element.Id) .. " : " .. element.TotalCost)
                        SellItem(item.objectGID, element.TotalCost, 0, (element.TotalCost * 2.5) > 100000 and element.TotalCost * 2.5 or 100000)
                        randomDelay()
                    end
                    element.NbToCraft = 0
                end
            end
        end
        ItemSold = true
        HdvSell2()
        global:leaveDialog()
    end


    for _, element in ipairs(tableCraft) do
        element.table = {}
    end

    local json = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\" .. character:server() .. "\\Craft-Resell.json")
    SetNewTemp({}, json)


    if getCurrentAreaName() ~= "Astrub" then
        if not map:onMap("0,0") then
            map:changeMap("havenbag")
        end
        map:changeMap("zaap(191105026)")
    end
    
    if not map:onMap(192415750) then
        debugMoveToward(192415750)
    else
        npc:npcBank(-1)
        randomDelay()
        exchange:putAllItems()
        global:leaveDialog()

        global:printMessage("-------------------")
        global:printSuccess("Total dépensé : " .. KamasDeBase - character:kamas())
        --global:printSuccess("Total mis en vente : " ..)
        local random = math.random(1, 4)
        if random ~= 1 and character:kamas() > 10000000 then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
        else
            customReconnect(math.random(100, 150))
        end
    end
    --- Final Selling

end

-- Message listening
function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end

function bank()
    return move()
end

function stopped()
    local lines = global:consoleLines()
    if lines[#lines - 2]:find("Cette action est impossible car vous êtes occupé.") or lines[#lines - 1]:find("Echec lors de l'utilisation d'un Zaap/Zaapi") then
        global:disconnect()
    end
end