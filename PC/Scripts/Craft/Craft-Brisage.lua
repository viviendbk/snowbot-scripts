dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


RunesInBank = {}

local TableItem = {} -- contient tous les items du jeu
local TableItemToChoice = {} -- contient les items craftables actuellement (qui n'ont pas été brisés depuis x jours)
local TableItemSave = {} -- dans le c

local ItemsToCraft = {} -- contient les items que l'on va craft

local ScriptStarting = true
local bankChecked = false
local bankChecked2 = false
local hdvRessourceChecked = false
local hdvEquipChecked = false
local hdvRunesChecked = false
local BrisageDone = false
local RuneSold = false
local GoSellRunes = false
local GoFinishBreak = false
local StopNoFocus = false
local finishThisBreaking = false -- sert pour empêcher le relancement du script si on a dépassé la valeur maximale en banque de la rune qu'on est en train de briser

local totalRenta = 0

local totalEarns = 0
local totalLosts = 0

local StatSearched = ""
local reloadCount = 0
local cpt = 0
local Total = 0
local PrixMoyenParPoids = 0
local NbRunes = 0

local function EditJsonMemory(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryBreakage.json")

    for _, data in ipairs(jsonMemory) do
        if data.Name == character:name() then
            if type(content) == "string" then
                data.StatSearched = content
            else
                data.Memory = content
            end
        end
    end            
    

    local new_content = json.encode(jsonMemory)
    -- Écrire les modifications dans le fichier JSON

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryBreakage.json", "w")

    file:write(new_content)
    file:close()
end


local function ProcessCraft(table, cellId)
    global:printSuccess("Debut Craft")
    for _, element in ipairs(table) do
        global:printSuccess(inventory:itemNameId(element.Id))
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local CraftQuantity = element.NbToCraft - inventory:itemCount(element.Id)

            for _, element2 in ipairs(element.ListIdCraft) do
                CraftQuantity = math.min(CraftQuantity, math.floor(inventory:itemCount(element2.Id) / element2.Quantity))
            end

            if CraftQuantity > 0 then
                global:printSuccess("On va craft " .. CraftQuantity .. " x [" ..  inventory:itemNameId(element.Id) .. "]")

                randomDelay()
                map:useById(TABLE_OUTIL_ATELIER[element.Type].ElementId, -1)
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
    global:printSuccess("Fin Craft")
    global:delay(math.random(500, 2000))
    global:leaveDialog()
    map:door(cellId)
end

local goToBankBonta = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "top"},
    {map = "212599813", path = "zaapi(212600322)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212600322)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212600322)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212600322)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212600322)"}, -- extérieur atelier sculpteur
    {map = "212601350", path = "zaapi(212600322)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(212600322)"}, -- hdv equipements
    {map = "212601860", path = "zaapi(212601860)"}, -- hdv brisage 
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
    {map = "212601859", path = "zaapi(212600837)"}, -- hdv brisage 
    {map = "212600322", path = "zaapi(212600837)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(212600837)"},
    {map = "212600323", path = "bottom"},
    -- map : 212600837
}

local goToHdvRessources = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212601350)"},
    {map = "212600837", path = "zaapi(212601350)"},
    {map = "212599813", path = "zaapi(212601350)"}, -- extérieur atelier bijoutier
    {map = "212599814", path = "zaapi(212601350)"}, -- extérieur atelier taileur
    {map = "212601347", path = "zaapi(212601350)"}, -- extérieur atelier cordonier
    {map = "212601348", path = "zaapi(212601350)"}, -- extérieur atelier forgeron
    {map = "212601860", path = "zaapi(212601350)"}, -- extérieur atelier sculpteur
    {map = "212600322", path = "zaapi(212601350)"}, -- exterieur banque
    {map = "212600837", path = "zaapi(212601350)"}, -- hdv equipements
    {map = "212601859", path = "zaapi(212601350)"}, -- hdv brisage 

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
    {map = "212601859", path = "zaapi(212601347)"}, -- hdv brisage 

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
    {map = "212601859", path = "zaapi(212599813)"}, -- hdv brisage 

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
    {map = "212601859", path = "zaapi(212599814)"}, -- hdv brisage 

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
    {map = "212601859", path = "zaapi(212601348)"}, -- hdv brisage 

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
    {map = "212601859", path = "zaapi(212601860)"}, -- hdv brisage 

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

local function SortRunesTable(dico)
    local tableau = {}
    for cle, valeur in pairs(dico) do
        tableau[#tableau+1] = {cle=cle, prix=valeur.PrixParPoids}
    end
    shuffleTable(tableau)
    local resultat = {}
    for i=1,#tableau do
        resultat[tableau[i].cle] = dico[tableau[i].cle]
    end
    return resultat
end


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

local function GetCraftCost(ListIdCraft)
    local PrixHdvAllRessources = {}

    HdvSell()
    local TotalCost = 0
    local LackRessource = false

    if not ListIdCraft then
        LackRessource = true
    else
        for _, Ressource in ipairs(ListIdCraft) do
            if not PrixHdvAllRessources[Ressource.Id] then
                PrixHdvAllRessources[Ressource.Id] = GetPricesItem(Ressource.Id)
                randomDelay()
            end
            if not PrixHdvAllRessources[Ressource.Id].TrueAveragePrice or PrixHdvAllRessources[Ressource.Id].TrueAveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id))
            or (Ressource.Quantity > 29 and PrixHdvAllRessources[Ressource.Id].Price100 == 0 and PrixHdvAllRessources[Ressource.Id].Price10 == 0) then
                LackRessource = true
                break
            end

            if PrixHdvAllRessources[Ressource.Id].TrueAveragePrice > PrixHdvAllRessources[Ressource.Id].AveragePrice * 2 then
                if PrixHdvAllRessources[Ressource.Id].Price100 / 100 > PrixHdvAllRessources[Ressource.Id].AveragePrice * 0.8
                and PrixHdvAllRessources[Ressource.Id].Price10 / 10 > PrixHdvAllRessources[Ressource.Id].AveragePrice * 0.8
                then
                    TotalCost = TotalCost + ((PrixHdvAllRessources[Ressource.Id].Price100 / 100) + (PrixHdvAllRessources[Ressource.Id].Price10 / 10) / 2) * Ressource.Quantity
                elseif (PrixHdvAllRessources[Ressource.Id].Price100 / 100 > PrixHdvAllRessources[Ressource.Id].AveragePrice * 0.8) and Ressource.Quantity > 10 then
                    TotalCost = TotalCost + (PrixHdvAllRessources[Ressource.Id].Price100 / 100) * Ressource.Quantity
                elseif PrixHdvAllRessources[Ressource.Id].Price10 / 10 > PrixHdvAllRessources[Ressource.Id].AveragePrice * 0.8 then
                    TotalCost = TotalCost + (PrixHdvAllRessources[Ressource.Id].Price10 / 10) * Ressource.Quantity
                elseif PrixHdvAllRessources[Ressource.Id].Price1 > PrixHdvAllRessources[Ressource.Id].AveragePrice * 0.8 and Ressource.Quantity < 30 then
                    TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].Price1 * Ressource.Quantity
                else
                    TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].TrueAveragePrice * Ressource.Quantity
                end 
            else
                TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].TrueAveragePrice * Ressource.Quantity
            end
        end
    end

    HdvBuy()
    if LackRessource then
        global:printError("Des ressources sont manquantes")
        return 0
    else
        global:printSuccess("Nouveau prix : " .. TotalCost)
        return math.floor(TotalCost)
    end 
end

function move()
    mapDelay()

    --[[
        nouveau possible trajet:
        recuperer le prix des runes hdv runes
        aller en banque, si on voit une rune qui n'est pas sous sa forme la plus rentable et qu'il y a plus de 1000 de cette rune là,
        on prend le prend le max de cette rune possible - 1000 (pour en laisser 1000 en banque), on va zone brisage pour les fusionner puis zonehdv rune pour les vendre
        on retourne ensuite en banque pour vérifier si il y a encore des runes qu'il faut fusionner
        quand il il n'y a plus de runes à fusionner, on peut commencer le process de craft brisage

        Ce qu'il faut prendre en compte pour calculer le nb de jour optimal à attendre:
        - le coef mini needed
        - le cout de craft de l'item
        - le niveau de l'item
    ]]

    if global:thisAccountController():getAlias():find("FM") then
        global:editAlias("CraftFM " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    elseif global:thisAccountController():getAlias():find("Craft2") then
        global:editAlias("Craft2 " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    else
        global:editAlias("Craft " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    end

    if ScriptStarting then
        logBotStats()
        if getRemainingSubscription(true) <= 0 then
            Abonnement()
        end

        local jsonFile = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json")
        local nbItemsTotal = 0

        if #TableItem == 0 then
            -- recupération de la mémoire
            local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryBreakage.json")

            local found = false
            for _, data in ipairs(jsonMemory) do
                if data.Name == character:name() then
                    ItemsToCraft = data.Memory
                    StatSearched = data.StatSearched
                    found = true
                end
            end

            if not found then
                table.insert(jsonMemory, {
                    Name = character:name(),
                    Memory = {}
                })
            end

            local new_content = json.encode(jsonMemory)
            -- Écrire les modifications dans le fichier JSON
            local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryBreakage.json", "w")
            file:write(new_content)
            file:close()

            global:printSuccess("Remplissage de la TableItem...")

            for i = 1, 20000 do
                if IsItem(inventory:itemTypeId(i)) and inventory:getLevel(i) <= job:level(GetJobIdByType(inventory:getTypeName(i))) and inventory:getLevel(i) > 30
                and inventory:getLevel(i) < 200 and ((inventory:itemCount(i) > 0 and inventory:itemPosition(i) == 63) or inventory:itemCount(i) == 0) then
                    if CanCraftNow(i, jsonFile) then
                        table.insert(TableItem, {
                            Id = i,
                            ListIdCraft = getRecipe(i),
                            Type = inventory:getTypeName(i),
                            NbToCraft = 0,
                        })
                    end
                    nbItemsTotal = nbItemsTotal + 1
                end
            end
            global:printSuccess("Remplissage fini!")
            global:printMessage("--------------------")
            global:printSuccess(#TableItem .. " items craftables sur " .. nbItemsTotal .. " (" .. #TableItem * 100 / nbItemsTotal .. "%)")
            global:printMessage("--------------------")

        end

        if #ItemsToCraft > 0 and ScriptStarting then
            global:printSuccess("On était déjà en train de craft/briser, on reprend les items d'avant le crash")
            ScriptStarting = false
            hdvRessourceChecked = true
            TableItemToChoice = ItemsToCraft

            global:printSuccess("Stat recherchée : " .. StatSearched)

            for _, item in ipairs(ItemsToCraft) do
                global:printSuccess("Nous allons craft " .. item.NbToCraft .. " x [" .. inventory:itemNameId(item.Id) .. "] : " .. item.TotalCost .. " k")
                for _, element in ipairs(tableCraft) do
                    for _, type in ipairs(element.types) do
                        if item.Type == type then
                            table.insert(element.table, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getRecipe(item.Id), NbToCraft = 1})
                        end
                    end
                end
            end

            return move()
        end
        -- rajouter le fat de prendre les runes en banque et d'aller les vendre

        if global:thisAccountController():getAlias():find("Craft2") and not delay then
            delay = true
            global:printMessage("On attend 1 à 2 minutes avant de commancer")
            RECONNECT_ON_TIMEOUT = false
            global:delay(math.random(60000, 120000))
            RECONNECT_ON_TIMEOUT = true
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
            -- local itemsInBank = exchange:storageItems()
            -- for _, item in ipairs(itemsInBank) do 
            --     if IsItem(inventory:itemTypeId(item)) then
            --         exchange:getItem(item, exchange:storageItemQuantity(item))
            --     end
            -- end
            local content = exchange:storageItems()

            for _, item in ipairs(content) do
                if inventory:itemTypeId(item) == 78 then
                    RunesInBank[tostring(item)] = exchange:storageItemQuantity(item)
                    local QuantityMax = (inventory:podsMax() * 0.80 - inventory:pods()) / inventory:itemWeight(item)
                    local quantity = 0

                    if job:level(62) > 50 then
                        quantity = math.min(QuantityMax, exchange:storageItemQuantity(item) - 500, inventory:podsP() < 80 and 500 or 0)
                    else
                        quantity = math.min(QuantityMax, exchange:storageItemQuantity(item), inventory:podsP() < 80 and 500 or 0)
                    end
                    if quantity > 0 then
                        exchange:getItem(item, quantity)
                    end
                    if exchange:storageItemQuantity(item) > 2000 then
                        global:printError("On ne brise plus les items associés à [" .. GetStatByRune(item) .. "]")
                        PoidsByStat[GetStatByRune(item)].CantBreak = true
                    end
                end 
            end

            global:leaveDialog()
            bankChecked = true
            map:door(518)
        end

        KamasDeBase = character:kamas()
        ScriptStarting = false
    end

    -- va hdv runes pour récupérer le prix / poids de chaque item et la répartition hdv
    if not map:onMap(212601859) and not hdvRunesChecked then
        global:printSuccess("On va à hdv runes")
        return treatMaps(goToHdvRunes)
    elseif not hdvRunesChecked then
        HdvSell()
        global:printMessage("Récupération du prix des runes...")

        PrixMoyenParPoids = 0
        NbRunes = 0
        for k, v in pairs(PoidsByStat) do
            NbRunes = NbRunes + 1
            local partHdv = 0
            local prixParPoids = 0

            for _, element in ipairs(v.Runes) do
                element.Prices = GetPricesItem(element.Id)
                partHdv = partHdv + get_quantity(element.Id).total_lots
                prixParPoids = prixParPoids + element.Prices.AveragePrice / element.Poids
            end
            v.PartsHdv = partHdv / (character:level() * 2)
            v.PrixParPoids = prixParPoids / #v.Runes
            global:printMessage("Prix par poids de " .. k .. " : " .. v.PrixParPoids .. "k")
            PrixMoyenParPoids = PrixMoyenParPoids + v.PrixParPoids
        end

        PrixMoyenParPoids = PrixMoyenParPoids / NbRunes
        global:printMessage("")
        global:printMessage("Prix moyen des runes : " .. PrixMoyenParPoids .. "k")
        global:printMessage("")

        local totalValue = 0
        for k, v in pairs(RunesInBank) do
            totalValue = totalValue + GetPriceRune(tonumber(k)) * v
        end

        global:printSuccess("La banque a une valeur de " .. totalValue .. "k")
        StopNoFocus = totalValue > 120000000
        if totalValue > 200000000 then
            if global:thisAccountController():getAlias():find("FM") then
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-FM-Resell.lua")
            else
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Resell.lua")
            end
        end
        if StopNoFocus then
            global:printSuccess("On stop le no focus")
        end

        global:leaveDialog()
        global:printSuccess("Récupération finie!")

        if #ItemsToCraft == 0 then
            HdvSell()
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
    
            global:leaveDialog()
            -- determination de la rune qu'on va rechercher

            if character:kamas() < 2000000 then
                global:printError("On a moins de 2 milions de kamas, on ne prend pas le risque d'aller briser des items")
            end
    
            PoidsByStat = SortRunesTable(PoidsByStat)
    
            local nbRunesAVendre = 0       
    
            for k, v in pairs(PoidsByStat) do
                if v.PrixParPoids and NbRunes > 0 and v.PrixParPoids > (PrixMoyenParPoids) and not v.CantBreak then
                    nbRunesAVendre = nbRunesAVendre + 1
                    global:printSuccess("On peut briser les items associés à [" .. k .. "]")
                end
            end

            global:printSuccess("")
            global:printSuccess("On peut briser en les items associés à " .. nbRunesAVendre .. " stats différentes")
    
            local random = math.random(1, nbRunesAVendre > 10 and 4 or nbRunesAVendre > 6 and 3 or 2)
            if nbRunesAVendre < 5 then
                if character:kamas() < 20000000 then
                    customReconnect(math.random(100,150))
                else
                    if global:thisAccountController():getAlias():find("FM") then
                        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-FM-Resell.lua")
                    else
                        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Resell.lua")
                    end
                end          
            end
            if random == 1 and not StopNoFocus then
                StatSearched = "No focus"
                global:printMessage("Nous allons faire des craft no focus")
            else
                for k, v in pairs(PoidsByStat) do
                    if v.PrixParPoids > (PrixMoyenParPoids) and v.PartsHdv < ((character:level() * 2) / nbRunesAVendre) and not v.CantBreak
                    and ((not k:find("% Do") and not k:find("distance") and not k:find("melee")) or (job:level(60) > 100)) then
                        StatSearched = k
                        global:printMessage("Nous allons chercher des runes [" .. k .. "] qui ont un prix moyen de " .. v.PrixParPoids .. " par pui")
                        break
                    end
                end
            end
            global:editInMemory("StatSearched", StatSearched)
            EditJsonMemory(StatSearched)
        end

        hdvRunesChecked = true
    end

    if not map:onMap(212601859) and GoSellRunes then
        return treatMaps(goToHdvRunes)
    elseif GoSellRunes then
        global:printSuccess("GoToSellRunes")
        HdvSell()
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

        global:printSuccess("Fin vente des runes")

        global:leaveDialog()
        GoSellRunes = false
        BrisageDone = false
        if inventory:podsP() > 95 then
            bankChecked2 = false
            GoFinishBreak = true
            local content = inventory:inventoryContent()
            for _, item in ipairs(content) do
                if IsItem(inventory:itemTypeId(item.objectGID)) then
                    table.insert(TableItemSave, item)
                end
            end
        end
    end

    --va hdv ressources pour récupérer le cout de craft des items
    if not map:onMap(212601350) and not hdvRessourceChecked then
        return treatMaps(goToHdvRessources)
    elseif not hdvRessourceChecked then
        --récupère le cout total du craft de chaque item et le met dans la table

        if mount:hasMount() then
            buyAndfeedDD()
            if not mount:isRiding() then
                mount:toggleRiding()
            end
        end

        HdvSell()
        global:printMessage("")
        global:printMessage("--------------------------------------")
        global:printMessage("Analyse des coût de craft des items...")

        local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceRessources.json")

        jsonPrice = not jsonPrice and {{Date = getDate(), Time = getCurrentTime(), Prices = {}}} or jsonPrice
        debug("date = " .. jsonPrice[1].Date)
        global:printSuccess(isXDaysLater(jsonPrice[1].Date, 2))

        if isXDaysLater(jsonPrice[1].Date, 2) then
            global:printSuccess("Le prix des ressources ne sont pas à jour, on les récupère")
            getPricesResourceInHDV()
        end

        if cpt == 0 then
            sale:updateAllItems()
            cpt = cpt +1
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
        end

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printMessage("")

        global:leaveDialog()

        TableItemToChoice = {}
        global:printMessage("--------------------------------------")
        global:printMessage("Analyse des items craftables parmis " .. #TableItem .. " items (reloadCount = " .. reloadCount .. ")")

        RECONNECT_ON_TIMEOUT = false
        -- determination des items qu'on va craft-briser 
        local jsonFile = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json")
        local newTemp = {}
        local NbItemsSameFocus = 0
        local listBrisagesPossibles = {}
        local minCost = 999999999999



        global:printSuccess("Récupération du vrai prix des ressources")

        HdvSell()

        for _, item in ipairs(TableItem) do
            if _ == math.floor(#TableItem / 4) then
                global:printMessage("25% effectué...")
            elseif _ == math.floor(#TableItem / 2) then
                global:printMessage("50% effectué...")
            elseif _ == math.floor(#TableItem * 0.75) then
                global:printMessage("75% effectué...")
            end
            if item.TotalCost > 0 then
                minCost = math.min(minCost, item.TotalCost)
                debug(item.Id .. " " .. inventory:itemNameId(item.Id) .. " : " .. item.TotalCost)
                item.BestFocus = GetBestFocusOnJp(item.Id)
                                debug("ok")
                if item.BestFocus == StatSearched then
                    NbItemsSameFocus = NbItemsSameFocus + 1
                end
                if item.BestFocus ~= "" and (GetPercentageMinimum(item.Id, item.TotalCost) < (reloadCount > 5 and 800 or 600)) and CanCraftNow(item.Id, jsonFile) and ((item.BestFocus == "No focus") or not PoidsByStat[item.BestFocus].CantBreak) then
                    listBrisagesPossibles[item.BestFocus] = not listBrisagesPossibles[item.BestFocus] and 1 or listBrisagesPossibles[item.BestFocus] + 1
                end
                if item.BestFocus == StatSearched and GetPercentageMinimum(item.Id, item.TotalCost) < (reloadCount > 5 and 800 or 600) and CanCraftNow(item.Id, jsonFile) then
                    local realTotalCost = 0
                    for _, ressource in ipairs(item.ListIdCraft) do
                        realTotalCost = realTotalCost + GetPricesItem(ressource.Id).TrueAveragePrice * ressource.Quantity
                    end
                    item.TotalCost = realTotalCost
                    table.insert(TableItemToChoice, item)
                    table.insert(newTemp, item.Id)
                end
            end
        end

        for k, v in pairs(PoidsByStat) do
            local totalItemsToBreak = 0
            for _, item in ipairs(TableItem) do
                if item.BestFocus == k then
                    totalItemsToBreak = totalItemsToBreak + 1
                end
            end
            if totalItemsToBreak > 0 then
                global:printMessage("[" .. k .. "] : " .. totalItemsToBreak .. " items restants à crafter")
            end
        end

        global:leaveDialog()

        SetNewTempBrisage(newTemp, jsonFile)

        global:printSuccess("Analyse finie!")
        global:printMessage("--------------------------------------")
        global:printSuccess("Nous avons " .. #TableItemToChoice .. " items craftables sur " .. NbItemsSameFocus)

        local max = 0
        local maxFocus = ""
        for k, v in pairs(listBrisagesPossibles) do
            if v > max then
                max = v
                maxFocus = k
            end
            global:printSuccess(k .. " : " .. v)
        end

        RECONNECT_ON_TIMEOUT = true
        global:printSuccess("max focus : " .. maxFocus)

        if #TableItemToChoice == 0 and reloadCount < 10 and maxFocus ~= "" then
            global:printSuccess("On a pas trouvé d'item à craft, on retente")
            reloadCount = reloadCount + 1

            if reloadCount > 3 then
                global:printSuccess("focus : " .. maxFocus)
                StatSearched = maxFocus
            else
                PoidsByStat = SortRunesTable(PoidsByStat)

                local nbRunesAVendre = 0       
        
                for k, v in pairs(PoidsByStat) do
                    if v.PrixParPoids and NbRunes > 0 and v.PrixParPoids > (PrixMoyenParPoids) and not v.CantBreak then
                        nbRunesAVendre = nbRunesAVendre + 1
                    end
                end
        
                global:printSuccess("on peut vendre " .. nbRunesAVendre .. " runes différentes")
        
                local random = math.random(1, nbRunesAVendre > 10 and 4 or nbRunesAVendre > 6 and 3 or 2)
                if random == 1 and not StopNoFocus then
                    StatSearched = "No focus"
                    global:printSuccess("Nous allons faire des craft no focus")
                else
                    for k, v in pairs(PoidsByStat) do
                        if v.PrixParPoids > (PrixMoyenParPoids) and v.PartsHdv < ((character:level() * 2) / nbRunesAVendre) and not v.CantBreak
                        and ((not k:find("% Do") and not k:find("distance") and not k:find("melee")) or (job:level(60) > 100)) then
                            StatSearched = k
                            global:printSuccess("Nous allons chercher des runes [" .. k .. "] qui ont un prix moyen de " .. v.PrixParPoids .. " par pui")
                            break
                        end
                    end
                end
            end

            EditJsonMemory(StatSearched)

            return move()
        elseif (#TableItemToChoice == 0 and reloadCount > 9) or maxFocus == "" then
            if character:kamas() > 10000000 then
                if global:thisAccountController():getAlias():find("FM") then
                    global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-FM-Resell.lua")
                else
                    global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Resell.lua")
                end
            else
                customReconnect(math.random(100, 150))
            end
        end
            -- Trier les articles par ordre aléatoire

        shuffleTable(TableItemToChoice)
        local randomKamas = math.random(reloadCount > 5 and 3000000 or  1500000, reloadCount > 5 and 5000000 or 3000000)
        local kamasOwned = character:kamas() >= randomKamas and randomKamas or character:kamas()
        local podsAvailable = inventory:podsMax() - inventory:pods()

        for _, item in ipairs(TableItemToChoice) do
            if item.TotalCost * 1.5 < kamasOwned and podsAvailable * 0.9 > item.PodsNeededToCraft  then
                item.NbToCraft = 1
                kamasOwned = kamasOwned - item.TotalCost
                podsAvailable = podsAvailable - item.PodsNeededToCraft
            end
        end

        ItemsToCraft = {}

        for _, item in ipairs(TableItemToChoice) do
            if item.NbToCraft > 0 and #ItemsToCraft < 20 then
                table.insert(ItemsToCraft, item)
                global:printSuccess("Nous allons craft : [" .. inventory:itemNameId(item.Id) .. "] : " .. item.TotalCost .. " k")
                for _, element in ipairs(tableCraft) do
                    for _, type in ipairs(element.types) do
                        if type == item.Type then
                            table.insert(element.table, item)
                        end
                    end
                end
            end
        end

        EditJsonMemory(ItemsToCraft)

        hdvRessourceChecked = true

    end

    --va chercher les kamas en banque
    if not map:onMap(217059328) and not bankChecked2 then
        return treatMaps(goToBankBonta)
    elseif not bankChecked2 then
        npc:npcBank(-1)
        global:printSuccess(exchange:storageItemQuantity(9162))
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

        local podsNeeded = 0
        if TableItemSave then
            for _, item in ipairs(TableItemSave) do
                if exchange:storageItemQuantity(item.objectGID) > 0 then
                    for i = 1, exchange:storageItemQuantity(item.objectGID) do
                        if exchange:storageItemQuantity(item.objectGID) > 0 then
                            exchange:getItem(item.objectGID, 1)
                        end
                    end
                end      
            end
            TableItemSave = {}
        end

        if StatSearched ~= "No focus" then
            local totalEstimation = 0
            for _, element in ipairs(PoidsByStat[StatSearched].Runes) do
                totalEstimation = totalEstimation + exchange:storageItemQuantity(element.Id) * element.Prices.AveragePrice
            end
            global:printSuccess("Valeur des runes " .. StatSearched .. " : " .. totalEstimation)
    
            if ((not finishThisBreaking 
            and ((PoidsByStat[StatSearched].PoidsUnite == 1 and totalEstimation > 2000000) or (PoidsByStat[StatSearched].PoidsUnite == 2 and totalEstimation > 5000000) or totalEstimation > 7500000))
            or (finishThisBreaking and totalEstimation > 15000000))
            and StatSearched ~= "PA" and StatSearched ~= "PM" and StatSearched ~= "PO" then
                global:printSuccess("Nous avons déjà suffisant de runes de ce type, on en cherche d'autre")
                global:leaveDialog()
                EditJsonMemory({})
                global:loadAndStart(global:getCurrentScriptDirectory() .. "\\Craft-brisage.lua")
            end
        end

        if not GoFinishBreak then
            for _, element in ipairs(tableCraft) do
                for _, item in ipairs(element.table) do

                    for i = 1, item.NbToCraft do
                        if exchange:storageItemQuantity(item.Id) > 0 then
                            exchange:getItem(item.Id, 1)
                        end
                    end

                    for _, ressource in ipairs(item.ListIdCraft) do
                        local Quantity = math.min(exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 90 and 500 or 0)
                        if Quantity > 0 then
                            exchange:getItem(ressource.Id, Quantity)
                        end
                    end

                end
            end
        end
        
        for _, item in ipairs(ItemsToCraft) do
            podsNeeded = podsNeeded + item.PodsNeededToCraft * 1.05 * item.NbToCraft
        end

        global:printSuccess("Nous avons besoin de " .. podsNeeded .. " pods pour craft nos items")

        global:printMessage("Recupération des runes...")

        local content = exchange:storageItems()

        local statsCantBreak = {}
        for _, item in ipairs(content) do
            if inventory:itemTypeId(item) == 78 and item ~= 10057 and (inventory:podsMax() - inventory:pods() - podsNeeded) > 500 then
                RunesInBank[tostring(item)] = exchange:storageItemQuantity(item)
                local QuantityMax = (inventory:podsMax() * 0.80 - inventory:pods()) / inventory:itemWeight(item)
                local quantity = 0
                if job:level(62) > 50 then
                    quantity = math.min(QuantityMax, exchange:storageItemQuantity(item) - 500, 300000 / GetPriceRune(item), inventory:podsP() < 80 and 400 or 0)
                else
                    quantity = math.min(QuantityMax, exchange:storageItemQuantity(item), inventory:podsP() < 80 and 400 or 0)
                end
                if (GetPriceByNumberRune(item) > 1000 and quantity > 10) or (GetPriceByNumberRune(item) > 10000 and quantity > 0) or quantity > 100 then
                    exchange:getItem(item, quantity)
                end
                if exchange:storageItemQuantity(item) > 2000 then
                    statsCantBreak[GetStatByRune(item)] = 1
                    PoidsByStat[GetStatByRune(item)].CantBreak = true
                elseif not statsCantBreak[GetStatByRune(item)] then
                    PoidsByStat[GetStatByRune(item)].CantBreak = false
                end
            end 
        end
        global:printSuccess("Récupération finie !")

        global:leaveDialog()
        bankChecked2 = true
        map:door(518)
    end

    global:printSuccess("Focus : " .. StatSearched)

    global:printSuccess("1")

    -- va hdv equipement
    if not map:onMap(212600837) and not hdvEquipChecked then
        return treatMaps(goToHdvEquip)
    elseif not hdvEquipChecked then
        global:printMessage("On regarde si les items sont moins cher en hdv que leur prix de craft et on actualise le cout de craft si NbToCraft > 1...")

        for _, element in ipairs(tableCraft) do
            for _, item in ipairs(element.table) do
                global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "]")
                for i = 1, (item.NbToCraft - inventory:itemCount(item.Id)) do
                    BuyItemIfLessExpencive(item.Id, item.TotalCost)
                end
            end
        end
    
        global:leaveDialog()
        global:delay(math.random(500, 2000))
        hdvEquipChecked = true
    end

    for _, element in ipairs(tableCraft) do
        global:printMessage("- " .. #element.table .. " craft")
    end

    if not map:onMap(212601350) and HaveToBuyRessources() then
        return treatMaps(goToHdvRessources)
    elseif HaveToBuyRessources() then
        HdvBuy()

        for _, element in ipairs(tableCraft) do
            for _, item in ipairs(element.table) do
                if item.NbToCraft > 0 then
                    global:printMessage("Check du prix de [" .. inventory:itemNameId(item.Id) .. "] | ancien prix : " .. item.TotalCost)
                    item.TotalCost = GetCraftCost(item.ListIdCraft)
                    local percentageMini = GetPercentageMinimum(item.Id, item.TotalCost)
                    global:printMessage("PercentageMini : " .. percentageMini)
                    if percentageMini > 800 or item.TotalCost == 0 then
                        global:printError("L'item n'est plus rentable à crafter, percentageMini = " .. percentageMini)
                        item.NbToCraft = 0
                        for i, item2 in ipairs(ItemsToCraft) do
                            if item.Id == item2.Id then
                                table.remove(ItemsToCraft, i)
                            end
                        end
                        EditJsonMemory(ItemsToCraft)
                    end
                end
                if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                    global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                    global:printMessage("--------------------------------------")
                    for _, ressource in ipairs(item.ListIdCraft) do
                        local QuantityToBuy = math.ceil(ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id))
                        if QuantityToBuy > 0 then
                            global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                            if not Achat(ressource.Id, QuantityToBuy) then
                                item.NbToCraft = 0
                                for i, item2 in ipairs(ItemsToCraft) do
                                    if item.Id == item2.Id then
                                        table.remove(ItemsToCraft, i)
                                    end
                                end
                                EditJsonMemory(ItemsToCraft)
                                break
                            end
                        end
                    end
                    global:printMessage("--------------------------------------")
                end
            end
        end

        
        for _, item in ipairs(TableItemToChoice) do
            if item.NbToCraft > 1 then
                for _, element in ipairs(tableCraft) do
                    for _, item2 in ipairs(element.table) do
                        if item.Id == item2.Id then
                            item.TotalCost = item2.TotalCost
                        end
                    end
                end
            end
        end
    end
    --- Determines which item we'll craft and resell
    global:printSuccess("2")

    if not GoFinishBreak then
        -- go craft
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
    end


    global:printSuccess("4")
    --- Brisage

    if not map:onMap(217056262) and (not BrisageDone or GoFinishBreak) then
        return treatMaps(goToBrisage)
    elseif not BrisageDone or GoFinishBreak then
        GoFinishBreak = false
        finishThisBreaking = false
        for _, element in ipairs(tableCraft) do
            element.table = {}
        end

        local podsAvailable = inventory:podsMax() - inventory:pods()
        local kamasOwned = character:kamas()

        local ToAddInJson = {}

        local jsonBrisage = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json")

        for a = 1, 2 do
            local content = inventory:inventoryContent()
            for _, element in ipairs(content) do
                if IsItem(inventory:itemTypeId(element.objectGID)) and inventory:podsP() > 90 and inventory:podsP() < 100 then
                    global:printMessage("Fusion des runes!")

                    MergeRunes()

                    if ConsoleRead(global:thisAccountController(), "Erreur dans le script : Impossible d'utiliser l'élément interactif") then
                        global:clearConsole()
                        global:disconnect()
                    end
                end
                for _, item in ipairs(TableItemToChoice) do

                    if IsItem(inventory:itemTypeId(element.objectGID)) and inventory:podsP() > 97 then
                        GoSellRunes = true
                        break
                    end

                    if item.Id == element.objectGID and inventory:itemPosition(item.Id) == 63 then

                        local PercentageMini = GetPercentageMinimum(item.Id, item.TotalCost)
                        global:printMessage("On va briser [" .. inventory:itemNameId(item.Id) .. "] qui a couté " .. item.TotalCost .. " à craft, et qui nécessite " .. PercentageMini .. " %") 
                        map:useById(521675, -1)
                        global:printSuccess("Ok1")
                        randomDelay()
    

                        -- depot de l'item dans le briseur
                        local message = developer:createMessage("ExchangeObjectMoveRequest")
                        message.object_uid = element.objectUID
                        message.quantity = 1
                        developer:sendMessage(message)  
                        developer:suspendScriptUntil("ExchangeObjectsAddedEvent", 5000, false, nil, 50)
                        global:printSuccess("Ok2")
    
                        randomDelay()
    
                        -- brisage
                        developer:registerMessage("DecraftResultEvent", _GetResultBreak)
                        message = developer:createMessage("ExchangeFocusedReadyRequest")
                        if StatSearched == "No focus" then
                            message.focus_action_id = 0
                        else
                            message.focus_action_id = GetIdCarac(StatSearched)
                        end
                            global:printSuccess("Ok3")

                        message.ready = true
                        message.step = 1
                        developer:sendMessage(message)
                        randomDelay()
                        developer:suspendScriptUntil("DecraftResultMessage", 5000, false, nil, 20)
                        global:leaveDialog()
    
                        Total = Total + EstimationGain - item.TotalCost

                        if EstimationGain < -2000000 then
                            global:printError("BUG")
                            global:disconnect()
                        end
    
                        if EstimationGain > item.TotalCost then
                            global:printSuccess("Gain de " .. EstimationGain - item.TotalCost .. "k")
                            totalEarns = totalEarns + EstimationGain - item.TotalCost 
                        else
                            global:printError("Perte de " .. item.TotalCost - EstimationGain .. "k")
                            totalLosts = totalLosts + item.TotalCost - EstimationGain
                        end
    

                        ToAddInJson.nbKamasInvesti = not ToAddInJson.nbKamasInvesti and item.TotalCost or ToAddInJson.nbKamasInvesti + item.TotalCost
                        ToAddInJson.EstimationKamasGagnes = not ToAddInJson.EstimationKamasGagnes and EstimationGain or ToAddInJson.EstimationKamasGagnes + EstimationGain
                        ToAddInJson.RentaNet = not ToAddInJson.RentaNet and (EstimationGain - item.TotalCost) or ToAddInJson.RentaNet + (EstimationGain - item.TotalCost)
                        totalRenta = totalRenta + (EstimationGain - item.TotalCost)
                        global:printMessage("Renta Net : " .. totalRenta)


                        if ToAddInJson.RentaNet < -2000000 then
                            global:printError("BUG")
                            -- global:disconnect()
                        end
                    
                        for _, element in ipairs(jsonBrisage) do
                            if element.server == character:server() then
                                local LastBreak = {}
                                local quantityToReCraft = 1
                                local lostPoints = 1000

                                for i, data in ipairs(element.BrisagesEffectues) do
                                    if data.Id == item.Id and isXDaysLater(data.DateBreak, 1) then
                                        global:printSuccess("l'item a déjà été brisé le " ..  data.DateBreak .. " et on avait obtenu : " .. data.CurrentCoef .. "%")
                                        
                                        if data.LastBreaks and #data.LastBreaks > 0 then
                                            data.LastBreaks[2] = data.LastBreaks[1]
                                            data.LastBreaks[1] = {Coef = data.CurrentCoef, Date = data.DateBreak}
                                        elseif not data.LastBreaks or #data.LastBreaks == 0 then
                                            data.LastBreaks = {{Coef = data.CurrentCoef, Date = data.DateBreak}}
                                        end

                                        LastBreak = data.LastBreaks
                                        break
                                    elseif data.Id == item.Id then
                                        lostPoints = data.CurrentCoef - Pourcentage
                                        quantityToReCraft = math.max(math.floor((Pourcentage - PercentageMini * 1.1) * 0.9 / (lostPoints + 1)), 1)
                                        
                                        global:printMessage("On a perdu "  .. lostPoints .. " points par rapport au dernier brisage (" .. data.DateBreak .. "), on peut estimer pouvoir refaire " .. quantityToReCraft .. " fois ce craft")
                                        LastBreak = not data.LastBreaks and {{}} or data.LastBreaks
                                        data.CurrentCoef = Pourcentage

                                        if quantityToReCraft > 0 and inventory:itemCount(item.Id) == 0 and (podsAvailable / inventory:podsMax()) > 0.1 and (kamasOwned - (item.TotalCost * 1.05)) > 100000 then
                                            quantityToReCraft = math.min(10, quantityToReCraft, math.floor(podsAvailable * 0.8 / item.PodsNeededToCraft), kamasOwned / item.TotalCost)
                                            quantityToReCraft = quantityToReCraft > 1 and math.floor(quantityToReCraft) or math.floor(quantityToReCraft)
                                            
                                            data.CurrentCoef = Pourcentage
                                            podsAvailable = podsAvailable - quantityToReCraft * item.PodsNeededToCraft
                                            kamasOwned = kamasOwned - (item.TotalCost * 1.05)
                                            global:printSuccess("Il restera " .. podsAvailable .. " pods si on refait ce craft " .. quantityToReCraft .. " fois")
                                            
                                        end
                                        break
                                    end
                                end
    

                                ToAddInJson.BrisagesEffectues = not ToAddInJson.BrisagesEffectues and {} or ToAddInJson.BrisagesEffectues   
                                -- supprimer les données si elles sont déjà présente dans ToAddInJson
                                for i, data in ipairs(ToAddInJson.BrisagesEffectues) do
                                    if data.Id == item.Id then
                                        table.remove(ToAddInJson.BrisagesEffectues, i)
                                        break
                                    end
                                end

                                -- ajouter les données dans ToAddInJson
                                table.insert(ToAddInJson.BrisagesEffectues, {
                                    Name = inventory:itemNameId(item.Id),
                                    Id = item.Id,
                                    CraftCost = item.TotalCost,
                                    CurrentCoef = Pourcentage,
                                    LastBreaks = LastBreak,
                                    CoefMiniNeeded = math.floor(PercentageMini),
                                    DateBreak = getDate()
                                })

                                local renta = EstimationGain - item.TotalCost
                                local rentaPercentage = EstimationGain > 0 and EstimationGain / item.TotalCost or 0
                                local PercentageNeeded = GetPercentageMinimum(item.Id, item.TotalCost)
                                local coefPourcentageObtenuSurMinimum = Pourcentage / PercentageNeeded

                                -- if rentaPercentage / coefPourcentageObtenuSurMinimum > 1.3 and renta > 50000 and coefPourcentageObtenuSurMinimum < 1.2 then
                                --     global:printError("BUG")
                                --     global:editAlias(global:thisAccountController():getAlias() .. " BUG", false)
                                --     global:disconnect()
                                -- end

                                if ((renta > 10000 and ((coefPourcentageObtenuSurMinimum > 1.1 and (EstimationGain / item.TotalCost) > 1.20) or coefPourcentageObtenuSurMinimum > 1.2)) 
                                or (renta > 5000 and coefPourcentageObtenuSurMinimum > 2) or (renta > 7000 and coefPourcentageObtenuSurMinimum > 1.5)) 
                                and inventory:itemCount(item.Id) == 0 
                                and item.TotalCost > 0 
                                and ((EstimationGain / item.TotalCost) < 1.50 or lostPoints > 8 or item.TotalCost < 100000) then -- sécurité supplémentaire
                                    GoSellRunes = true
                                    hdvEquipChecked = false
                                    bankChecked2 = false
                                    finishThisBreaking = true
                                    global:printSuccess("Nous allons recraft " .. quantityToReCraft .. " : [" .. inventory:itemNameId(item.Id) .. "] : " .. item.TotalCost .. " k")
                                    item.NbToCraft = math.min(10, quantityToReCraft)

                                    for _, element in ipairs(tableCraft) do
                                        for _, type in ipairs(element.types) do
                                            if type == item.Type then
                                                table.insert(element.table, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getRecipe(item.Id), NbToCraft = item.NbToCraft})
                                            end
                                        end
                                    end

                                elseif inventory:itemCount(item.Id) == 0 then
                                    for i, item2 in ipairs(ItemsToCraft) do
                                        if item.Id == item2.Id then
                                            table.remove(ItemsToCraft, i)
                                        end
                                    end
                                    EditJsonMemory(ItemsToCraft)
                                end
                                break
                            break
                            end
                        end
                        break
                    end
                end
            end
        end

        if ToAddInJson.RentaNet then
            global:printMessage("Update du json...")

            jsonBrisage = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json")
    
            for _, data in ipairs(jsonBrisage) do
                if data.server == character:server() then
                    for i = #data.BrisagesEffectues, 1, -1 do
                        local element = data.BrisagesEffectues[i]
                        for _, element2 in ipairs(ToAddInJson.BrisagesEffectues) do
                            if element.Id == element2.Id then
                                table.remove(data.BrisagesEffectues, i)
                            end
                        end
                    end
                    for _, element in ipairs(ToAddInJson.BrisagesEffectues) do
                        table.insert(data.BrisagesEffectues, element)
                    end
    
                    data.nbKamasInvesti = data.nbKamasInvesti + ToAddInJson.nbKamasInvesti
                    data.EstimationKamasGagnes = data.EstimationKamasGagnes + ToAddInJson.EstimationKamasGagnes
                    data.RentaNet = data.RentaNet + ToAddInJson.RentaNet
                    data.RentaPercentage = data.EstimationKamasGagnes > 0 and data.EstimationKamasGagnes / data.nbKamasInvesti or 0
                    jsonBrisage[1]["Renta du "..  getDate()] = not jsonBrisage[1]["Renta du "..  getDate()] and ToAddInJson.RentaNet or jsonBrisage[1]["Renta du "..  getDate()] + ToAddInJson.RentaNet
                    break
                end
            end
    
            local Renta7Jours = 0
            local i = 1
            for k, v in pairs(jsonBrisage[1]) do
                if not k:find("7 jours") and isXDaysLater(k:split(" ")[3], 7) then
                    global:printSuccess("On supprime la date " .. k:split(" ")[3])
                    jsonBrisage[1][k] = nil
                elseif not k:find("7 jours") then
                    Renta7Jours = Renta7Jours + v
                end
                i = i + 1
            end
            
            jsonBrisage[1]["Renta sur 7 jours"] = Renta7Jours
            -- Convertir la table Lua modifiée en JSON
            local new_content = json.encode(jsonBrisage)
        
            -- Écrire les modifications dans le fichier JSON
            file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json", "w")
            file:write(new_content)
            file:close()
            global:printSuccess("Fin de l'update!")
        end

        if inventory:podsP() < 100 then
            global:printMessage("Fusion des runes!")

            -- fusion des runes
            MergeRunes()
            global:printSuccess("Fusion terminée!")
        end
        
        BrisageDone = true

        local jsonFile = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\Brisage.json")
        SetNewTempBrisage({}, jsonFile)
    end

    if GoSellRunes then
        global:printSuccess("Nous allons maintenant vendre les runes")
        return move()
    end

    --- Brisage

    if not map:onMap(212601859) and not RuneSold then
        return treatMaps(goToHdvRunes)
    elseif not RuneSold then
        HdvSell()
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

        local random = math.random(1, 3)
        if random == 1 then
            sale:updateAllItems()
        end

        if sale:availableSpace() > 20 then
            global:printSuccess("Nous allons briser d'autres items!")
            hdvRunesChecked = false
            hdvRessourceChecked = false
            bankChecked2 = false
            hdvEquipChecked = false
            RuneSold = false
            BrisageDone = false
            GoSellRunes = false

            global:leaveDialog()
            return move()
        end
        global:leaveDialog()
        RuneSold = true
    end


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

        EditJsonMemory({})

        global:printMessage("Stats : " .. totalEarns - totalLosts)

        if (totalEarns - totalLosts) < -10000000 then
            global:printError("Pertes anormales")
            -- global:disconnect()
        end
        --global:printSuccess("Total mis en vente : " ..)
        if global:thisAccountController():getAlias():find("FM") then
            if character:kamas() < 10000000 then
                customReconnect(math.random(100,150))
            else
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-FM-Resell.lua")
            end
        else
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Resell.lua")
        end
    end
    --- Final Selling

end

-- Message listening
function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

function bank()
    return move()
end

function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end

function stopped()
    local lines = global:consoleLines()
    if lines[#lines - 2]:find("Cette action est impossible car vous êtes occupé.") or lines[#lines - 1]:find("Echec lors de l'utilisation d'un Zaap/Zaapi") then
        global:disconnect()
    end
end