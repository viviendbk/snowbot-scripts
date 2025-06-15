dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local CraftCordonier = {}
local CraftBijoutier = {}
local CraftTailleur = {}
local CraftForgeron = {}
local CraftSculpteur = {}
local TableItem = {}


local TableItemToFM = {}

local ScriptStarting = true
local bankChecked = false
local bankChecked2 = false
local hdvRessourceChecked = false
local hdvRessourceChecked2 = false
local memoryChecked = false
local hdvEquipChecked = false
local ItemSold = false
local FMDone = false
local InfoCurrentItemFM = {}
local StatToRePut = ""
local steep = 0
local counter = 0 
NbRunesUsed = 0
local bankContent = {}
MaxCoef = 0

local function AddToJsonData(content)
    local dataFM = openFile(global:getCurrentScriptDirectory() .. "\\FM.json")

    for _, data in ipairs(dataFM) do
        if data.Server == character:server() then
            local found = false
            for _, element in ipairs(data.Data) do
                if element.Id == content.Id then
                    found = true
                    table.insert(element.FM, {
                        Date = getDate(),
                        FinalCoef = content.InfoFm.Quality,
                        RunesNeeded = content.InfoFm.RunesUsed
                    })
                end
            end
            if not found then
                table.insert(data.Data, {
                    Id = content.Id,
                    Name = inventory:itemNameId(content.Id),
                    FM = {{
                        Date = getDate(),
                        FinalCoef = content.InfoFm.Quality,
                        RunesNeeded = content.InfoFm.RunesUsed
                    }}
                })
            end
        end
    end

    local new_content = json.encode(dataFM)
    -- Écrire les modifications dans le fichier JSON
    file = io.open(global:getCurrentScriptDirectory() .. "\\FM.json", "w")
    file:write(new_content)
    file:close()
end


local function EditJsonMemory(content)
    -- local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json")

    -- local toAdd = content
    -- -- vider les composantes StatsId pour bypass le bug
    -- for _, element in ipairs(toAdd) do
    --     if element.InfoFm and element.InfoFm.StatsId then
    --         element.InfoFm.StatsId = nil
    --     end
    -- end

    -- for _, data in ipairs(jsonMemory) do
    --     if data.Name == character:name() then
    --         data.Memory = content
    --     end
    -- end            
    

    -- local new_content = json.encode(jsonMemory)
    -- -- Écrire les modifications dans le fichier JSON

    -- local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json", "w")

    -- file:write(new_content)
    -- file:close()
end

local function UseRune(runeId)
    global:printMessage("On pose la rune [" .. inventory:itemNameId(runeId) .. "] dans l'interface")

    developer:registerMessage("ExchangeCraftResultMagicWithObjectDescMessage", _AnalyseResultsFM)
    -- mettre la rune sur l'interface
    local message = developer:createMessage("ExchangeObjectMoveMessage")
    message.objectUID = inventory:getUID(runeId)
    message.quantity = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeObjectAddedMessage", 5000, false, nil, 50)
    global:delay(math.random(100, 300))

    steep = steep + 2

    local message = developer:createMessage("ExchangeReadyMessage")
    message.ready = true
    message.steep = steep
    developer:sendMessage(message)
    
    developer:suspendScriptUntil("ExchangeCraftResultMagicWithObjectDescMessage", 5000, false, nil, 50)
    local random = math.random()
    if random < 0.05 then
        global:delay(math.random(4000, 7000))
    elseif random < 0.2 then
        global:delay(math.random(2000, 3000))
    else
        global:delay(math.random(500, 2000))
    end
end

local function ProcessCraft(table, cellId, jobId)
    for _, element in ipairs(table) do
        if inventory:itemCount(element.Id) < element.NbToCraft then
            local CraftQuantity = element.NbToCraft - inventory:itemCount(element.Id)

            for _, element2 in ipairs(element.ListIdCraft) do
                CraftQuantity = math.min(CraftQuantity, math.floor(inventory:itemCount(element2.Id) / element2.Quantity))
            end

            if CraftQuantity > 0 then
                global:printSuccess("On va craft " .. CraftQuantity .. " x [" ..  inventory:itemNameId(element.Id) .. "]")

                global:delay(math.random(500, 1500))
                map:useById(TableOutilAtelier[element.Type].ElementId, -1)
                global:delay(math.random(500, 1500))
    
                global:printSuccess("ok1")
                for _, item in ipairs(element.ListIdCraft) do
                    craft:putItem(item.Id, item.Quantity)
                    global:delay(200)
                end
                global:printSuccess("ok2")

                craft:changeQuantityToCraft(CraftQuantity)
                global:delay(200)
                craft:ready()
                global:printSuccess("Craft effectué !")
                steep = 0 global:leaveDialog()

                if ConsoleRead(global:thisAccountController(), "Erreur dans le script : Impossible d'utiliser l'élément interactif") then
                    global:clearConsole()
                    global:disconnect()
                end
    
                global:delay(math.random(500, 1500))
                return ProcessCraft(table, cellId, jobId)
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

local goToAtelierFaconneur = {
    {map = "0,0", path = "zaap(165152263)"},
    {map = "165152263", path = "top"},
    {map = "165152262", door = "261"},
    {map = "81788928", door = "201"},
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

local goToAtelierFm = {
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



function _AnalyseResultsFM(message)
    developer:unRegisterMessage("ExchangeCraftResultMagicWithObjectDescMessage")

    local changements = {}
    if message.magicPoolStatus == 3 then
        -- si on a - reliquat, on actualise le pui
        InfoCurrentItemFM.InfoFm.Pui = InfoCurrentItemFM.InfoFm.Pui - GetPoidsRune(InfoCurrentItemFM.CurrentRune)
        InfoCurrentItemFM.InfoFm.Pui = InfoCurrentItemFM.InfoFm.Pui > 0 and InfoCurrentItemFM.InfoFm.Pui or 0
    elseif message.magicPoolStatus == 2 then
        -- si on a + reliquat, on retire le poids de la rune qu'on a mis au pui et on rajoutera ensuite le poids des stats retirés
        InfoCurrentItemFM.InfoFm.Pui = InfoCurrentItemFM.InfoFm.Pui - GetPoidsRune(InfoCurrentItemFM.CurrentRune)
    end
    InfoCurrentItemFM.InfoFm.StatsId = message.objectInfo.effects
    --InfoCurrentItemFM.InfoFm.Quality = 0

    local totalPoids = 0
    local qualite = 0
    for k, v in pairs(InfoCurrentItemFM.InfoFm.Stats) do
        local found = false
        for _, effect in ipairs(InfoCurrentItemFM.InfoFm.StatsId) do
            if GetNameCarac(effect.actionId) == k then
                found = true
            end
            if developer:typeOf(effect) == "ObjectEffectInteger" and GetNameCarac(effect.actionId) == k and (v.Current - effect.value) ~= 0 then
                if message.magicPoolStatus == 2 and (v.Current - effect.value) > 0 then
                    -- si on a + reliquat, on actualise le pui
                    InfoCurrentItemFM.InfoFm.Pui = InfoCurrentItemFM.InfoFm.Pui + (v.Current - effect.value) * PoidsByStat[k].PoidsUnite
                    if (v.Current - effect.value) * PoidsByStat[k].PoidsUnite > 20 then
                        -- si on vient d'avoir le + reliquat et que le pui dépasse 20, on mets de côté la stat principale qui vient de sauter pour la remettre après
                        StatToRePut = k
                    end
                end
                changements[k] = effect.value - v.Current
                v.Current = effect.value
            end
        end
        if not found then
            if message.magicPoolStatus == 2 then
                -- si on a + reliquat, on actualise le pui
                InfoCurrentItemFM.InfoFm.Pui = InfoCurrentItemFM.InfoFm.Pui + v.Current * PoidsByStat[k].PoidsUnite
                if v.Current * PoidsByStat[k].PoidsUnite > 20 then
                    -- si on vient d'avoir le + reliquat et que le pui dépasse 20, on mets de côté la stat principale qui vient de sauter pour la remettre après
                    StatToRePut = k
                end
            end
            changements[k] = 0 - v.Current
            v.Current = 0
        end
        -- on ne prend pas en compte le poids des runes invo, po, pa, pm pour ne pas fausser la qualité de l'item
        if not (PoidsByStat[k].PoidsUnite > 30 and v.Current == 1) then
            totalPoids = totalPoids + PoidsByStat[k].PoidsUnite
            qualite = qualite + (PoidsByStat[k].PoidsUnite * (v.Current / v.Max))
        end
    end

    InfoCurrentItemFM.InfoFm.Quality = qualite / totalPoids
    if InfoCurrentItemFM.InfoFm.Quality > MaxCoef then
        MaxCoef = InfoCurrentItemFM.InfoFm.Quality
    end

    if counter % 5  == 0 then
        global:printMessage("----- stats actuels ----")
        for k, v in pairs(InfoCurrentItemFM.InfoFm.Stats) do
            global:printSuccess("[" .. k .. "] : { " .. v.Min .. " | " .. v.Current .. " | " .. v.Max .. " }")
        end
        global:printMessage("------------------------")
    end
    counter = counter + 1

    local string = ""
    for k, v in pairs(changements) do
        if v > 0 then
            string = string .. "+" .. v .. " " .. k .. ", "
        else
            if message.magicPoolStatus == 1 and InfoCurrentItemFM.InfoFm.Pui < 0 then
                InfoCurrentItemFM.InfoFm.Pui = 0
            end
            string = string .. v .. " " .. k .. ", "
        end
    end
    if message.magicPoolStatus == 3 then
        string = string .. " -reliquat, "
    elseif message.magicPoolStatus == 2 then
        string = string .. " +reliquat, "
    end
    string = string .. " [Qualité] = " .. InfoCurrentItemFM.InfoFm.Quality .. ", [Pui] = " .. InfoCurrentItemFM.InfoFm.Pui

    if not string:find("-") then
        global:printSuccess(string)
    elseif string:find("-") and string:find("+") then
        global:printMessage(string)
    else
        global:printError(string)
    end
    -- if ItemSatisfyConditions(InfoCurrentItemFM).Bool and StatToRePut == "" then
    --     steep = 0 global:leaveDialog()
    -- end
end

local function TreatMaps(maps)
    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    map:changeMap("havenbag")
end

local function HaveToBuyRessources()
    local toReturn = false
    for _, item in ipairs(CraftCordonier) do
        if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
            for _, ressource in ipairs(item.ListIdCraft) do
                local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                if QuantityToBuy > 0 then
                    toReturn = true
                end
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
            for _, ressource in ipairs(item.ListIdCraft) do
                local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                if QuantityToBuy > 0 then
                    toReturn = true
                end
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
            for _, ressource in ipairs(item.ListIdCraft) do
                local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                if QuantityToBuy > 0 then
                    toReturn = true
                end
            end
        end
    end
    for _, item in ipairs(CraftForgeron) do
        if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
            for _, ressource in ipairs(item.ListIdCraft) do
                local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                if QuantityToBuy > 0 then
                    toReturn = true
                end
            end
        end
    end
    for _, item in ipairs(CraftSculpteur) do
        if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
            for _, ressource in ipairs(item.ListIdCraft) do
                local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                if QuantityToBuy > 0 then
                    toReturn = true
                end
            end
        end
    end
    global:printSuccess(toReturn)
    return toReturn
end

function move()
    mapDelay()
    global:editAlias("CraftFM " .. character:server() .. " : [" .. truncKamas() .. "m]", true)
    --- Determines which item we'll craft and resell

    if ScriptStarting then
        -- vérifie qu'il est bien abonné        
        if getRemainingSubscription(true) <= 0 and character:kamas() > (character:server() == "Draconiros" and 550000 or 1000000) then
            global:printSuccess("il reste " .. getRemainingSubscription(true) .. "jours d'abonnement, on tente de s'abonner à nouveau")
            Abonnement()
        elseif getRemainingSubscription(true) < 0 then
            Abonnement()
        end

        if #TableItem == 0 then
            -- recupération de la mémoire
            -- local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json")
            -- local found = false
            -- for _, data in ipairs(jsonMemory) do
            --     if data.Name == character:name() then
            --         TableItemToFM = data.Memory
            --         found = true
            --     end
            -- end
            -- if not found then
            --     table.insert(jsonMemory, {
            --         Name = character:name(),
            --         Memory = {}
            --     })
            -- end
            -- local new_content = json.encode(jsonMemory)
            -- -- Écrire les modifications dans le fichier JSON
            -- local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json", "w")
            -- file:write(new_content)
            -- file:close()

            global:printSuccess("Remplissage de la TableItem...")
            for i = 1, 20000 do
                if IsItem(inventory:itemTypeId(i)) and inventory:getLevel(i) <= job:level(GetJobIdByType(inventory:getTypeName(i))) and inventory:getLevel(i) <= job:level(GetJobMageIdByType(inventory:getTypeName(i)))
                 and inventory:getLevel(i) > math.min(job:level(GetJobIdByType(inventory:getTypeName(i))) - 10, job:level(GetJobMageIdByType(inventory:getTypeName(i))) > 130 and 115 or (job:level(GetJobMageIdByType(inventory:getTypeName(i))) - 15)) 
                 and ((inventory:itemCount(i) > 0 and inventory:itemPosition(i) == 63) or inventory:itemCount(i) == 0) then
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

        -- va hdv runes pour récupérer le prix / poids de chaque item et la répartition hdv
        if not map:onMap(212601859) and not hdvRunesChecked then
            return TreatMaps(goToHdvRunes)
        elseif not hdvRunesChecked then

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
            steep = 0 global:leaveDialog()
            hdvRunesChecked = true
        end

        -- --va hdv ressources
        if not map:onMap(212601350) and not hdvRessourceChecked then
            return TreatMaps(goToHdvRessources)
        elseif not hdvRessourceChecked then
            --récupère le cout total du craft de chaque item et le met dans la table
            HdvSell()
            steep = 0 global:leaveDialog()

            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Analyse des coût de craft des items...")

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
                
                if not item.ListIdCraft then
                    LackRessource = true
                else
                    for _, Ressource in ipairs(item.ListIdCraft) do
                        if not PrixHdvAllRessources[Ressource.Id] then
                            PrixHdvAllRessources[Ressource.Id] = GetPricesItem(Ressource.Id)
                        end
                        if not PrixHdvAllRessources[Ressource.Id].TrueAveragePrice or PrixHdvAllRessources[Ressource.Id].TrueAveragePrice == 0 or IsItem(inventory:itemTypeId(Ressource.Id))
                        or (Ressource.Quantity > 29 and PrixHdvAllRessources[Ressource.Id].Price100 == 0 and PrixHdvAllRessources[Ressource.Id].Price10 == 0) then
                            LackRessource = true
                            break
                        end
                        TotalPods = TotalPods + inventory:itemWeight(Ressource.Id) * Ressource.Quantity
                        TotalCost = TotalCost + PrixHdvAllRessources[Ressource.Id].TrueAveragePrice * Ressource.Quantity
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
            for _, item in ipairs(TableItem) do
                if #item.ListIdCraft > 0 and item.TotalCost > 0 and item.TotalCost < 2000000 then
                    if job:level(64) < math.min(200, job:level(27) + 1) and GetJobMageIdByType(inventory:getTypeName(item.Id)) == 64 and ItemHasTwoOrMoreCarac(item.Id) and ItemHasAtLeastOneLittleStat(item.Id) and (inventory:getLevel(item.Id) + 3) > job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) then -- costumage
                        global:printSuccess("On va craft  " .. inventory:itemNameId(item.Id) .. " [lvl " .. inventory:getLevel(item.Id) .. "]")
                        table.insert(TableItemToFM, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        table.insert(CraftTailleur, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        break
                    elseif job:level(62) < math.min(200, job:level(15) + 1) and GetJobMageIdByType(inventory:getTypeName(item.Id)) == 62 and ItemHasTwoOrMoreCarac(item.Id) and ItemHasAtLeastOneLittleStat(item.Id) and (inventory:getLevel(item.Id) + 3) > job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) then -- jaillomage
                        global:printSuccess("On va craft " .. inventory:itemNameId(item.Id) .. " [lvl " .. inventory:getLevel(item.Id) .. "]")
                        table.insert(TableItemToFM, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        table.insert(CraftCordonier, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        break
                    elseif job:level(63) < math.min(200, job:level(16) + 1) and GetJobMageIdByType(inventory:getTypeName(item.Id)) == 63 and ItemHasTwoOrMoreCarac(item.Id) and ItemHasAtLeastOneLittleStat(item.Id) and (inventory:getLevel(item.Id) + 3) > job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) then -- cordomage
                        global:printSuccess("On va craft " .. inventory:itemNameId(item.Id) .. " [lvl " .. inventory:getLevel(item.Id) .. "]")
                        table.insert(TableItemToFM, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        table.insert(CraftBijoutier, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        break
                    elseif job:level(44) < math.min(200, job:level(11) + 1) and GetJobMageIdByType(inventory:getTypeName(item.Id)) == 44 and ItemHasTwoOrMoreCarac(item.Id) and ItemHasAtLeastOneLittleStat(item.Id) and (inventory:getLevel(item.Id) + 3) > job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) then -- forgemage
                        global:printSuccess("On va craft " .. inventory:itemNameId(item.Id) .. " [lvl " .. inventory:getLevel(item.Id) .. "]")
                        table.insert(TableItemToFM, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        table.insert(CraftForgeron, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        break
                    elseif job:level(48) < math.min(200, job:level(13) + 1) and GetJobMageIdByType(inventory:getTypeName(item.Id)) == 48 and ((inventory:getLevel(item.Id) == 1) or ((ItemHasTwoOrMoreCarac(item.Id) or inventory:getLevel(item.Id) < 10) and ItemHasAtLeastOneLittleStat(item.Id))) and (inventory:getLevel(item.Id) + 4) > job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) then -- sculptemage
                        global:printSuccess("On va craft " .. inventory:itemNameId(item.Id) .. " [lvl " .. inventory:getLevel(item.Id) .. "]")
                        table.insert(TableItemToFM, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        table.insert(CraftSculpteur, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = 0})
                        break
                    end
                end
            end
            EditJsonMemory(TableItemToFM)

            steep = 0 global:leaveDialog()
            hdvRessourceChecked = true
        end
        
        KamasDeBase = character:kamas()
        
        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked2 then
            return TreatMaps(goToBankBonta)
        elseif not bankChecked2 then
            npc:npcBank(-1)
            if exchange:storageKamas() > 0 then
                exchange:putAllItems()
                global:delay(500)
                exchange:getKamas(0)
                global:delay(500)
                global:printSuccess("j'ai récupérer les kamas, je vais vendre")
            elseif exchange:storageKamas() == 0 then
                exchange:putAllItems()
                global:delay(500)
                global:printError("il n'y a pas de kamas dans la banque")
            end	

            bankContent = exchange:storageItems()

            for _, item in ipairs(CraftCordonier) do
                for i = 1, item.NbToCraft do
                    if exchange:storageItemQuantity(item.Id) > 0 then
                        exchange:getItem(item.Id, 1)
                    end
                end
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                    local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                    if Quantity > 0 then
                        exchange:getItem(ressource.Id, Quantity)
                    end
                end
            end
            for _, item in ipairs(CraftBijoutier) do
                for i = 1, item.NbToCraft do
                    if exchange:storageItemQuantity(item.Id) > 0 then
                        exchange:getItem(item.Id, 1)
                    end
                end
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                    local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                    if Quantity > 0 then
                        exchange:getItem(ressource.Id, Quantity)
                    end
                end
            end
            for _, item in ipairs(CraftTailleur) do
                for i = 1, item.NbToCraft do
                    if exchange:storageItemQuantity(item.Id) > 0 then
                        exchange:getItem(item.Id, 1)
                    end
                end
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                    local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                    if Quantity > 0 then
                        exchange:getItem(ressource.Id, Quantity)
                    end
                end
            end
            for _, item in ipairs(CraftForgeron) do
                for i = 1, item.NbToCraft do
                    if exchange:storageItemQuantity(item.Id) > 0 then
                        exchange:getItem(item.Id, 1)
                    end
                end
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                    local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                    if Quantity > 0 then
                        exchange:getItem(ressource.Id, Quantity)
                    end
                end
            end
            for _, item in ipairs(CraftSculpteur) do
                for i = 1, item.NbToCraft do
                    if exchange:storageItemQuantity(item.Id) > 0 then
                        exchange:getItem(item.Id, 1)
                    end
                end
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityMax = (inventory:podsMax() * 0.85 - inventory:pods()) / inventory:itemWeight(ressource.Id)
                    local Quantity = math.min(QuantityMax, exchange:storageItemQuantity(ressource.Id), ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)), inventory:podsP() < 85 and 500 or 0)
                    if Quantity > 0 then
                        exchange:getItem(ressource.Id, Quantity)
                    end
                end
            end
            steep = 0 global:leaveDialog()
            bankChecked2 = true
            map:door(518)
        end

        ScriptStarting = false
    end

    global:printSuccess("1")

    if not map:onMap(212601350) and HaveToBuyRessources() then
        return TreatMaps(goToHdvRessources)
    elseif HaveToBuyRessources() then
        HdvBuy()
        for _, item in ipairs(CraftCordonier) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("--------------------------------------")
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                        if not Achat(ressource.Id, QuantityToBuy) then
                            item.NbToCraft = 0
                            for i, item2 in ipairs(TableItemToFM) do
                                if item.Id == item2.Id then
                                    table.remove(TableItemToFM, i)
                                end
                            end
                            EditJsonMemory(TableItemToFM)
                            break
                        end
                    end
                end
                global:printMessage("--------------------------------------")
            end
        end
        for _, item in ipairs(CraftBijoutier) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("--------------------------------------")
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                        if not Achat(ressource.Id, QuantityToBuy) then
                            item.NbToCraft = 0
                            for i, item2 in ipairs(TableItemToFM) do
                                if item.Id == item2.Id then
                                    table.remove(TableItemToFM, i)
                                end
                            end
                            EditJsonMemory(TableItemToFM)
                            break
                        end
                    end
                end
                global:printMessage("--------------------------------------")
            end
        end
        for _, item in ipairs(CraftTailleur) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("--------------------------------------")
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                        if not Achat(ressource.Id, QuantityToBuy) then
                            item.NbToCraft = 0
                            for i, item2 in ipairs(TableItemToFM) do
                                if item.Id == item2.Id then
                                    table.remove(TableItemToFM, i)
                                end
                            end
                            EditJsonMemory(TableItemToFM)
                            break
                        end
                    end
                end
                global:printMessage("--------------------------------------")
            end
        end
        for _, item in ipairs(CraftForgeron) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("--------------------------------------")
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                        if not Achat(ressource.Id, QuantityToBuy) then
                            item.NbToCraft = 0
                            for i, item2 in ipairs(TableItemToFM) do
                                if item.Id == item2.Id then
                                    table.remove(TableItemToFM, i)
                                end
                            end
                            EditJsonMemory(TableItemToFM)
                            break
                        end
                    end
                end
                global:printMessage("--------------------------------------")
            end
        end
        for _, item in ipairs(CraftSculpteur) do
            if inventory:itemCount(item.Id) < item.NbToCraft and inventory:podsP() < 95 then
                global:printSuccess("On achète les ressources pour craft [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("--------------------------------------")
                for _, ressource in ipairs(item.ListIdCraft) do
                    local QuantityToBuy = ressource.Quantity * (item.NbToCraft - inventory:itemCount(item.Id)) - inventory:itemCount(ressource.Id)
                    if QuantityToBuy > 0 then
                        global:printSuccess("Achat de " .. QuantityToBuy .. " [" .. inventory:itemNameId(ressource.Id) .. "]")
                        if not Achat(ressource.Id, QuantityToBuy) then
                            item.NbToCraft = 0
                            for i, item2 in ipairs(TableItemToFM) do
                                if item.Id == item2.Id then
                                    table.remove(TableItemToFM, i)
                                end
                            end
                            EditJsonMemory(TableItemToFM)
                            break
                        end
                    end
                end
                global:printMessage("--------------------------------------")
            end
        end
        steep = 0 global:leaveDialog()
    end
    --- Determines which item we'll craft and resell
    global:printSuccess("2")

    --- Path To Craft
    for _, item in ipairs(CraftCordonier) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217055238) then
                return TreatMaps(goToAtelierCordoBonta)
            else
                ProcessCraft(CraftCordonier, 360, 15)
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217058310) then
                return TreatMaps(goToAtelierBijoutierBonta)
            else
                ProcessCraft(CraftBijoutier, 485, 16)
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217056260) then
                return TreatMaps(goToAtelierTailleurBonta)
            else
                ProcessCraft(CraftTailleur, 520, 27)
            end
        end
    end
    for _, item in ipairs(CraftForgeron) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217055236) then
                return TreatMaps(goToAtelierForgeronBonta)
            else
                ProcessCraft(CraftForgeron, 526, 11)
            end
        end
    end
    for _, item in ipairs(CraftSculpteur) do
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217058308) then
                return TreatMaps(goToAtelierSculpteurBonta)
            else
                ProcessCraft(CraftSculpteur, 479, 13)
            end
        end
    end
    
    global:printSuccess("3")

    for _, item in ipairs(TableItemToFM) do
        if inventory:itemCount(item.Id) > 0 and (not item.StatChecked or (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8)) then
            if not item.StatChecked then
                local content = inventory:inventoryContent()
                local qualityItem = 0
                local statsJP = GetDices(item.Id) -- y'a pas les %dommages et %resistance
                local stats = {}
                local statsId = {}
                local runesNeeded = {}
                for _, item2 in ipairs(content) do
                    if item.Id == item2.objectGID then
                        qualityItem = GetQualityItem(item2.effects, item.Id)
                        statsId = item2.effects
                        for _, statJp in ipairs(statsJP) do
                            for _, stat in ipairs(item2.effects) do
                                if statJp.id == stat.actionId then
                                    stats[GetNameCarac(stat.actionId)] = {Min = statJp.dice.min, Current = stat.value, Max = statJp.dice.max}
                                end
                            end
                            if not stats[GetNameCarac(statJp.id)] then
                                stats[GetNameCarac(statJp.id)] = {Min = statJp.dice.min, Current = 0, Max = statJp.dice.max}
                            end
                        end
                        break
                    end
                end

                for k, v in pairs(stats) do
                    local runes = PoidsByStat[k].Runes
                    for _, rune in ipairs(runes) do
                        table.insert(runesNeeded, rune.Id)
                    end
                end

                global:printSuccess("Nous allons fm [" .. inventory:itemNameId(item.Id) .. "] (" .. qualityItem * 100 .. "% JP)")
                global:printMessage("----- stats actuels ----")
                for k, v in pairs(stats) do
                    global:printSuccess("[" .. k .. "] : { " .. v.Min .. " | " .. v.Current .. " | " .. v.Max .. " }")
                end

                global:printMessage("------------------------")

                item.InfoFm = {
                    Quality = qualityItem,
                    StatsId = statsId,
                    Stats = stats,
                    Pui = 0,
                    RunesNeeded = runesNeeded,
                    RunesUsed = {},
                }

                if #bankContent > 0 then
                    item.bankChecked = true
                    for _, item2 in ipairs(bankContent) do
                        for _, rune in ipairs(runesNeeded) do
                            if rune == item2 and inventory:itemCount(rune) < 100 then
                                item.bankChecked = false
                            end
                        end
                    end
                end

                item.StatChecked = true
            end

            if not item.InfoFm.StatsId or #item.InfoFm.StatsId == 0 then
                -- ça arrive quand on intéragit avec la mémoire json.
                local content = inventory:inventoryContent()
                for _, item2 in ipairs(content) do
                    if item.Id == item2.objectGID then
                        item.InfoFm.StatsId = item2.effects
                        break
                    end
                end
            end

            --va chercher les runes manquantes en banque
            if not map:onMap(217059328) and not item.bankChecked and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                return TreatMaps(goToBankBonta)
            elseif not item.bankChecked and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                npc:npcBank(-1)
                if exchange:storageKamas() > 0 then
                    exchange:getKamas(0)
                    global:delay(500)
                    global:printSuccess("j'ai récupérer les kamas, je vais vendre")
                elseif exchange:storageKamas() == 0 then
                    global:printError("il n'y a pas de kamas dans la banque")
                end	

                bankContent = exchange:storageItems()

                for _, rune in ipairs(item.InfoFm.RunesNeeded) do
                    local quantity = math.min(200 - inventory:itemCount(rune), exchange:storageItemQuantity(rune), 200000 / GetPriceRune(rune))
                    if quantity > 0 then
                        exchange:getItem(rune, quantity)
                    end
                end

                item.bankChecked = true
                steep = 0 global:leaveDialog()
                map:door(518)
            end

            -- va hdv runes pour acheter les runes manquantes
            if not map:onMap(212601859) and not item.hdvRunesChecked and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                return TreatMaps(goToHdvRunes)
            elseif not item.hdvRunesChecked and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                for _, rune in ipairs(item.InfoFm.RunesNeeded) do
                    local quantity = math.floor(math.min(100 - inventory:itemCount(rune), (150000 / GetPriceRune(rune)) - inventory:itemCount(rune)))
                    if quantity > 10 or quantity * GetPriceRune(rune) > 20000 then
                        global:printSuccess("Achat de " .. quantity .. " [" .. inventory:itemNameId(rune) .. "]")
                        Achat(rune, quantity)
                    end
                end
                item.hdvRunesChecked = true
            end

            if not map:onMap(217056262) and not item.FMDone and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                return TreatMaps(goToAtelierFm)
            elseif not item.FMDone and (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8) then
                map:useById(TableOutilAtelier[item.Type].FMElementId, TableOutilAtelier[item.Type].FMRep)
                NbRunesUsed = 0
                local content = inventory:inventoryContent()

                for _, item2 in ipairs(content) do
                    if item2.objectGID == item.Id then
                        local message = developer:createMessage("ExchangeObjectMoveMessage")
                        message.objectUID = item2.objectUID
                        message.quantity = 1
                        developer:sendMessage(message)
                        developer:suspendScriptUntil("ExchangeObjectAddedMessage", 5000, false, nil, 50)
                        break
                    end
                end

                local condition = ItemSatisfyConditions(item)

                while (job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) < inventory:getLevel(item.Id) + 8)  do
                    if job:level(GetJobMageIdByType(inventory:getTypeName(item.Id))) == 200 then
                        -- si on est lvl 200 on s'arrête là
                        break
                    end

                    local statToUp = ""
                    local maxCoef = -40

                    while StatToRePut ~= "" do
                        -- si on vient de se prendre un gros +reliquat, on choisi bien ses runes avant de remettre la rune qui a sautée
                        local tableStatWithCoef = {}
                        local coefPositif = false

                        for k, v in pairs(item.InfoFm.Stats) do
                            if not condition.StatsNeeded or #condition.StatsNeeded == 0 or IsInTable(condition.StatsNeeded, k) then
                                local poidsFromMinToMax = (v.Max - v.Min)
                                local coef = 0
                                for _, rune in ipairs(PoidsByStat[k].Runes) do
                                    if rune.Value * 20 > (item.InfoFm.Stats[k].Current < v.Min and v.Min or v.Current) and k ~= StatToRePut then
                                        coef = poidsFromMinToMax > 0 and ((v.Max - v.Current - rune.Value) / poidsFromMinToMax) or (v.Max - v.Current - rune.Value) / v.Max
                                        if coef >= 0 then
                                            global:printSuccess(k .. " : coef " .. coef)
                                            coefPositif = true
                                            table.insert(tableStatWithCoef, {Stat = k, Coef = coef})
                                        end
                                        break
                                    end
                                end
                            end
                        end

                        local trouvee = false
                        local runeSelected = 0

                        --[[
                            remplacer le itemsatifyconditions en ajoutant le fait qu'on s'en fout de la stat qui a donné le pui!!!s
                        ]]
                        if coefPositif --[[and not ItemSatisfyConditions(item).Bool]] then
                            table.sort(tableStatWithCoef, function (a, b)
                                return a.Coef > b.Coef
                            end)
    
                            for _, element in ipairs(tableStatWithCoef) do
                                for _, rune in ipairs(PoidsByStat[element.Stat].Runes) do
                                    if rune.Value * 20 > (item.InfoFm.Stats[element.Stat].Current < item.InfoFm.Stats[element.Stat].Min and item.InfoFm.Stats[element.Stat].Min or item.InfoFm.Stats[element.Stat].Current) 
                                    and rune.Poids <= item.InfoFm.Pui and ((item.InfoFm.Stats[element.Stat].Current * PoidsByStat[element.Stat].PoidsUnite + rune.Poids) < 101 or (item.InfoFm.Stats[element.Stat].Current +rune.Value) < item.InfoFm.Stats[element.Stat].Max) and element.Stat ~= StatToRePut then
                                        runeSelected = rune.Id
                                        break
                                    end
                                end

                                -- si on a trouvé une rune, on la mets, sinon on cherche d'autres runes
                                if runeSelected ~= 0 then
                                    global:printMessage("1 " .. inventory:itemNameId(runeSelected))
                                    trouvee = true
                                    InfoCurrentItemFM.InfoFm = item.InfoFm
                                    InfoCurrentItemFM.CurrentRune = runeSelected

                                    UseRune(runeSelected)
    
                                    -- ajouter la rune dans les runes utilisées
                                    item.InfoFm = InfoCurrentItemFM.InfoFm
                                    item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1

                                    break
                                end
                            end
                        else
                            table.sort(tableStatWithCoef, function (a, b)
                                return a.Coef > b.Coef
                            end)
    
                            for _, element in ipairs(tableStatWithCoef) do
                                for _, rune in ipairs(PoidsByStat[element.Stat].Runes) do
                                    if rune.Value * 20 > (item.InfoFm.Stats[element.Stat].Current < item.InfoFm.Stats[element.Stat].Min and item.InfoFm.Stats[element.Stat].Min or item.InfoFm.Stats[element.Stat].Current) 
                                    and rune.Poids <= item.InfoFm.Pui and ((item.InfoFm.Stats[element.Stat].Current * PoidsByStat[element.Stat].PoidsUnite + rune.Poids) < 101 or (item.InfoFm.Stats[element.Stat].Current +rune.Value) < item.InfoFm.Stats[element.Stat].Max) and element.Stat ~= StatToRePut then
                                        runeSelected = rune.Id
                                        break
                                    end
                                end

                                -- si on a trouvé une rune, on la mets, sinon on cherche d'autres runes
                                if runeSelected ~= 0 then
                                    global:printMessage("1 " .. inventory:itemNameId(runeSelected))
                                    trouvee = true
                                    InfoCurrentItemFM.InfoFm = item.InfoFm
                                    InfoCurrentItemFM.CurrentRune = runeSelected

                                    UseRune(runeSelected)
    
                                    -- ajouter la rune dans les runes utilisées
                                    item.InfoFm = InfoCurrentItemFM.InfoFm
                                    item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1

                                    break
                                end
                            end

                        end


                        if not trouvee then
                            global:printSuccess("----- Le pui est totalement consommé, on remonte la stat d'où provient le pui -----")
                            -- si on a plus assez de pui, on remets la stat
                            local runeSelected = PoidsByStat[StatToRePut].Runes[1].Id
                            InfoCurrentItemFM.InfoFm = item.InfoFm
                            InfoCurrentItemFM.CurrentRune = runeSelected

                            UseRune(runeSelected)

                            -- ajouter la rune dans les runes utilisées
                            item.InfoFm = InfoCurrentItemFM.InfoFm
                            item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                            StatToRePut = ""
                        end
                    end

                    local runeSelected = 0

                    for k, v in pairs(item.InfoFm.Stats) do
                        if v.Current < v.Min then
                            for _, rune in ipairs(PoidsByStat[k].Runes) do
                                if rune.Value * 20 > (item.InfoFm.Stats[k].Current < item.InfoFm.Stats[k].Min and item.InfoFm.Stats[k].Min or item.InfoFm.Stats[k].Current) then
                                    runeSelected = rune.Id
                                    break
                                end
                            end
                            break
                        end


                        local poidsFromMinToMax = (v.Max - v.Min)
                        local coef = 0
                        for _, rune in ipairs(PoidsByStat[k].Runes) do
                            if rune.Value * 20 > (item.InfoFm.Stats[k].Current < item.InfoFm.Stats[k].Min and item.InfoFm.Stats[k].Min or item.InfoFm.Stats[k].Current) then
                                coef = poidsFromMinToMax > 0 and ((v.Max - v.Current - rune.Value) / poidsFromMinToMax) or (v.Max - v.Current - rune.Value) / v.Max
                                if k == "Sagesse" and coef > maxCoef and (((v.Current * PoidsByStat[k].PoidsUnite + rune.Poids) < 90) or ((v.Current + rune.Value) < v.Max)) then
                                    runeSelected = rune.Id
                                    maxCoef = coef
                                elseif k ~= "Sagesse" and coef > maxCoef and ((v.Current * PoidsByStat[k].PoidsUnite + rune.Poids) < 101 or ((v.Current + rune.Value) < v.Max)) then
                                    runeSelected = rune.Id
                                    maxCoef = coef
                                end
                                break
                            end
                        end
                    end

                    -- si on a plus cette rune, on va en racheter
                    if inventory:itemCount(runeSelected) == 0 then
                        global:printError("Nous n'avons plus suffisament de rune " .. inventory:itemNameId(runeSelected) .. ", on va en racheter")
                        item.hdvRunesChecked = false
                        steep = 0 global:leaveDialog()
                        return move()
                    end

                    if not changeRune then
                        maxExeeded = false
                        InfoCurrentItemFM.InfoFm = item.InfoFm
                        InfoCurrentItemFM.CurrentRune = runeSelected

                        UseRune(runeSelected)

                        -- ajouter la rune dans les runes utilisées
                        item.InfoFm = InfoCurrentItemFM.InfoFm
                        item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                    end
                    changeRune = false
                    condition = ItemSatisfyConditions(item)
                end

                global:printSuccess("Fm fini, qualité = " .. item.InfoFm.Quality)
                steep = 0 global:leaveDialog()
                item.FMDone = true
                -- on regarde ensuite combien on a dépensé. si on a dépensé - de 5% du budjet et que l'item a des stats en vita, on tente l'over vita

                item.RunesCost = 0
                for k, v in pairs(item.InfoFm.RunesUsed) do
                    global:printSuccess(inventory:itemNameId(tonumber(k)) .. " : " .. v)
                    item.RunesCost = item.RunesCost + GetPriceRune(tonumber(k)) * v
                end
    
                global:printMessage("-----------------------------------")
                global:printMessage("Nous avons dépensé " .. item.RunesCost .. " k en runes pour [" .. inventory:itemNameId(item.Id) .. "]")
                global:printMessage("-----------------------------------")

                EditJsonMemory(TableItemToFM)
            end
        end 
    end

    --- Path To Craft

    --- Final Selling

    if not map:onMap(217056262) and not breakDone then
        return TreatMaps(goToBrisage)
    elseif not breakDone then
            
        local content = inventory:inventoryContent()

        for _, item in ipairs(content) do
            
            if IsItem(item.objectGID) and item.position == 63 then
                global:printMessage("On va briser [" .. inventory:itemNameId(tonumber(k)) .. "]") 

                map:useById(521675, -1)
                global:delay(500)

                -- depot de l'item dans le briseur
                local message = developer:createMessage("ExchangeObjectMoveMessage")
                message.objectUID = item.objectUID
                message.quantity = 1
                developer:sendMessage(message)  
                developer:suspendScriptUntil("ExchangeObjectAddedMessage", 5000, false, nil, 50)

                -- brisage
                global:delay(500)
                developer:registerMessage("DecraftResultMessage", GetResultBreak)
                message = developer:createMessage("FocusedExchangeReadyMessage")

                message.focusActionId = 0
                message.ready = true
                message.steep = 1
                
                developer:sendMessage(message)
                global:delay(500)
                developer:suspendScriptUntil("DecraftResultMessage", 5000, false, nil, 20)
                global:leaveDialog()
            end
        end
        breakDone = true

    end

    if #TableItemToFM == 0 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\Craft-FM-Resell.lua")
    end
    global:restartScript(true)


    TableItemToFM = {}
    EditJsonMemory(TableItemToFM)
    CraftTailleur = {}
    CraftBijoutier = {}
    CraftCordonier = {}
    CraftSculpteur = {}
    CraftForgeron = {}


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
        global:delay(500)
        exchange:putAllItems()
        steep = 0 global:leaveDialog()

        global:printMessage("-------------------")
        global:printSuccess("Total dépensé : " .. KamasDeBase - character:kamas())
        --global:printSuccess("Total mis en vente : " ..)
        local random = math.random(1, 4)
        if random ~= 1 and character:kamas() > 10000000 then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
        else
            if job:level(62) < 150 then
                global:restartScript(true)
            end
            customReconnect(math.random(100, 150))
        end
    end
    --- Final Selling

end

-- Message listening
function messagesRegistering()
    --developer:registerMessage("ExchangeCraftResultMagicWithObjectDescMessage", _AnalyseResultsFM)
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
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