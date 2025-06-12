dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


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
MaxCoef = 0
local bankContent = {}

local phrase = nil
if global:thisAccountController():getAlias():find("Groupe") then
    phrase = "Groupe " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe2") then
    phrase = "Groupe2 " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe3") then
    phrase = "Groupe3 " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe4") then
    phrase = "Groupe4 " .. character:server()
end



local function AddToJsonData(content)
    local dataFM = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\FM.json")

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
    file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\FM.json", "w")
    file:write(new_content)
    file:close()
end

local function EditJsonMemory(content)
    local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json")

    local toAdd = content
    -- vider les composantes StatsId pour bypass le bug
    for _, element in ipairs(toAdd) do
        if element.InfoFm and element.InfoFm.StatsId then
            element.InfoFm.StatsId = nil
        end
    end

    for _, data in ipairs(jsonMemory) do
        if data.Name == character:name() then
            data.Memory = content
        end
    end            
    

    local new_content = json.encode(jsonMemory)
    -- Écrire les modifications dans le fichier JSON

    local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json", "w")

    file:write(new_content)
    file:close()
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
    global:delay(math.random(200, 500))

    steep = steep + 2

    local message = developer:createMessage("ExchangeReadyMessage")
    message.ready = true
    message.steep = steep
    developer:sendMessage(message)
    
    developer:suspendScriptUntil("ExchangeCraftResultMagicWithObjectDescMessage", 5000, false, nil, 50)
    local random = math.random()
    randomDelay()
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

local function ProcessCraft(table, cellId, jobId)
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
                steep = 0 global:leaveDialog()

                if ConsoleRead(global:thisAccountController(), "Erreur dans le script : Impossible d'utiliser l'élément interactif") then
                    global:clearConsole()
                    global:reconnect(0)
                end
    
                randomDelay()
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
                    if (v.Current - effect.value) * PoidsByStat[k].PoidsUnite > 19 then
                        -- si on vient d'avoir le + reliquat et que le pui dépasse 19, on mets de côté la stat principale qui vient de sauter pour la remettre après
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
                if v.Current * PoidsByStat[k].PoidsUnite > 19 then
                    -- si on vient d'avoir le + reliquat et que le pui dépasse 19, on mets de côté la stat principale qui vient de sauter pour la remettre après
                    StatToRePut = k
                end
            end
            changements[k] = 0 - v.Current
            v.Current = 0
        end
    end

    InfoCurrentItemFM.InfoFm.Quality = GetQualityItem(InfoCurrentItemFM.InfoFm.StatsId, InfoCurrentItemFM.Id)
    if InfoCurrentItemFM.InfoFm.Quality > MaxCoef and StatToRePut == "" then
        MaxCoef = InfoCurrentItemFM.InfoFm.Quality
    end

    if counter % 10  == 0 then
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

    if not string:find("-") then
        if message.magicPoolStatus == 3 then
            string = string .. " -reliquat, "
        elseif message.magicPoolStatus == 2 then
            string = string .. " +reliquat, "
        end
        string = string .. " [Qualité] = " .. InfoCurrentItemFM.InfoFm.Quality .. ", [Pui] = " .. InfoCurrentItemFM.InfoFm.Pui .. ", [NbRunesUsed] = " .. NbRunesUsed
        global:printSuccess(string)
    elseif string:find("-") and string:find("+") then
        if message.magicPoolStatus == 3 then
            string = string .. " -reliquat, "
        elseif message.magicPoolStatus == 2 then
            string = string .. " +reliquat, "
        end
        string = string .. " [Qualité] = " .. InfoCurrentItemFM.InfoFm.Quality .. ", [Pui] = " .. InfoCurrentItemFM.InfoFm.Pui .. ", [NbRunesUsed] = " .. NbRunesUsed
        global:printMessage(string)
    else
        if message.magicPoolStatus == 3 then
            string = string .. " -reliquat, "
        elseif message.magicPoolStatus == 2 then
            string = string .. " +reliquat, "
        end
        string = string .. " [Qualité] = " .. InfoCurrentItemFM.InfoFm.Quality .. ", [Pui] = " .. InfoCurrentItemFM.InfoFm.Pui .. ", [NbRunesUsed] = " .. NbRunesUsed
        global:printError(string)
    end
    if ItemSatisfyConditions(InfoCurrentItemFM).Bool and StatToRePut == "" then
        steep = 0 global:leaveDialog()
    end
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


function move()
    --[[
        faire un tool qui permet de récupérer le prix hdv d'un item fm vita
        -> on parcours chaque item en vente de celui qu'on veut vendre et on mets dans une table tous les items qui possèdent un over
        -> on compare les over avec le notre (la qualité de l'item + la poids de l'over (on va dire 50 / 50))
        -> on essaie de situer notre item parmis ceux en vente pour déterminer son prix,
        -> on vends cet item au bon prix (max 3 fois son prix de craft + prix de fm)
    ]]

    if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
        global:thisAccountController():forceServer("Draconiros")
        global:reconnect(0)
    end
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
            local jsonMemory = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json")
            local found = false

            for _, data in ipairs(jsonMemory) do
                if data.Name == character:name() then
                    TableItemToFM = data.Memory
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
            local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\MemoryFM.json", "w")
            file:write(new_content)
            file:close()

            global:printSuccess("Remplissage de la TableItem...")
            for i = 1, 20000 do
                if IsItem(inventory:itemTypeId(i)) and inventory:getLevel(i) <= job:level(GetJobIdByType(inventory:getTypeName(i))) and inventory:getLevel(i) <= job:level(GetJobMageIdByType(inventory:getTypeName(i)))
                 and inventory:getLevel(i) > math.min(job:level(GetJobIdByType(inventory:getTypeName(i))) - 10, job:level(GetJobMageIdByType(inventory:getTypeName(i))) > 120 and 105 or (job:level(GetJobMageIdByType(inventory:getTypeName(i))) - 15)) 
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


        if #TableItemToFM > 0 and not memoryChecked then
            memoryChecked = true
            hdvRessourceChecked = true
            hdvEquipChecked = true
            hdvRessourceChecked2 = true
            bankChecked = character:kamas() > 1000000
            bankChecked2 = true
            global:printSuccess("On était déjà en train de craft/FM, on reprend les items d'avant le crash")

            for _, item in ipairs(TableItemToFM) do
                if inventory:itemCount(item.Id) == 0 then
                    bankChecked2 = false
                end
                global:printSuccess("Nous allons craft " .. item.NbToCraft .. " x [" .. inventory:itemNameId(item.Id) .. "] : " .. item.TotalCost .. " k")
                for _, element in ipairs(tableCraft) do
                    for _, type in ipairs(element.types) do
                        if item.Type == type then
                            table.insert(element.table, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getIngredients(item.Id), NbToCraft = item.NbToCraft, InfoFm = item.InfoFm, RunesCost = item.RunesCost, PriceFM = item.PriceFM})
                        end
                    end
                end
            end
        end
        memoryChecked = true

        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked then
            return TreatMaps(goToBankBonta)
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
            bankContent = exchange:storageItems()
            for _, item in ipairs(bankContent) do
                if IsItem(inventory:itemTypeId(item)) then
                    dicoItems[tostring(item)] = not dicoItems[tostring(item)] and 1 or dicoItems[tostring(item)] + 1
                    if exchange:storageItemQuantity(item) > 0 then
                        for i = 1, exchange:storageItemQuantity(item) do
                            if exchange:storageItemQuantity(item) > 0 then
                                exchange:getItem(item, 1)
                            end
                        end
                    end
                end
            end

            -- --if there we have a fm item in our inventory, we'll sell it
            -- local inventoryContent = inventory:inventoryContent()
            -- for _, item in ipairs(inventoryContent) do
            --     if inventory:itemCount(item.objectGID) == 1 and IsItem(inventory:itemTypeId(item.objectGID))
            --         and ItemSatisfyConditionsById(item.objectGID) then
            --         global:printSuccess("Nous pouvons allons mettre en vente l'item " .. inventory:itemNameId(item.objectGID))
            --         for _, element in ipairs(TableItem) do
            --             if element.Id == item.objectGID then
            --                 global:printSuccess(element.TotalCost)
            --                 table.insert(TableItemToFM, {Id = element.Id, TotalCost = element.TotalCost, Type = element.Type, PodsNeededToCraft = element.PodsNeededToCraft, ListIdCraft = getIngredients(element.Id), NbToCraft = 1, RunesCost = 0})
            --             end
            --         end
            --     end
            -- end

            for _, item in ipairs(TableItemToFM) do
                if exchange:storageItemQuantity(item.Id) > 0 and inventory:itemCount(item.Id) == 0 then
                    exchange:getItem(item.Id, 1)
                end
            end

            for k, v in pairs(dicoItems) do
                if v > 1 or inventory:getLevel(tonumber(k)) <= 50 then
                    goBreak = true
                end
            end

            global:printMessage("Recupération des runes...")
            local content = exchange:storageItems()
    
            for _, item in ipairs(content) do
                if inventory:itemTypeId(item) == 78 and item ~= 10057 then
                    local quantity = math.min(exchange:storageItemQuantity(item) - 500, inventory:podsP() < 80 and 500 or 0)
                    if quantity > 0 then
                        exchange:getItem(item, quantity)
                    end
                end 
            end
            global:printSuccess("Récupération finie !")

            bankChecked = true
            steep = 0 global:leaveDialog()
            map:door(518)
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
    
            for _, element in ipairs(RunesTransVita) do
                element.Prices = GetPricesItem(element.Id)
            end

            global:printSuccess("Récupération finie!")
            steep = 0 global:leaveDialog()

            if #TableItemToFM == 0 then
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
            end

            steep = 0 global:leaveDialog()

            

            hdvRunesChecked = true
        end

        if not map:onMap(217056262) and goBreak then
            return TreatMaps(goToAtelierFm)
        elseif goBreak then
                
            for k, v in pairs(dicoItems) do
                
                if ((v > 1 and inventory:itemCount(tonumber(k)) > 1) or inventory:getLevel(tonumber(k)) <= 50) and inventory:itemPosition(tonumber(k)) == 63 then
                    if inventory:podsP() > 99 then
                        bankChecked = false
                        break
                    end
                    global:printMessage("On va briser [" .. inventory:itemNameId(tonumber(k)) .. "] " .. v .. " fois") 
                    local StatSearched = GetBestFocusOnJp(tonumber(k))
                    global:printSuccess(StatSearched)


                    local content = inventory:inventoryContent()

                    for _, element in ipairs(content) do
                        if element.objectGID == tonumber(k) then
                            map:useById(521675, -1)
                            steep = 0
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
                            steep = 0 global:leaveDialog()
                        end
                    end

                end
            end
        
            steep = 0 global:leaveDialog()
            goBreak = false

        end


        KamasDeBase = character:kamas()
        local kamasOwned = character:kamas() >= 50000000 and 50000000 or character:kamas() - 7000000
        local kamasDepense  = 0

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


            local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceRessources.json")

            jsonPrice = not jsonPrice and {{Date = getDate(), Time = getCurrentTime(), Prices = {}}} or jsonPrice

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

            steep = 0 global:leaveDialog()
            hdvRessourceChecked = true
        end

        -- va hdv equipement
        if not map:onMap(212600837) and not hdvEquipChecked then
            return TreatMaps(goToHdvEquip)
        elseif not hdvEquipChecked then
            HdvSell()

            local nbItemsToCraft = sale:availableSpace()
            local random = math.random(1, 5)
            -- update les prix des items
            if random == 1 then
                global:printSuccess("On actualise tous les prix")
                UpdateAllItemOpti()
            end
            --récpère les prix hdv de tous les items présent dans notre liste (craftables) et les met dans la table

            if nbItemsToCraft == 0 then
                global:printError("l'hdv est plein, on retente dans X heures")
                local random = math.random(1, 3)
                if random ~= 1 and character:kamas() > 10000000 then
                    global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
                elseif random == 2 then
                    global:reconnectBis(math.random(100, 150))
                else
                    global:reconnectBis(math.random(480, 600))
                end
            end
            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Récupération du prix hdv des items...")

           local jsonPrice = openFile(global:getCurrentScriptDirectory() .. "\\".. character:server() .. "\\PriceItems.json")

            jsonPrice = not jsonPrice and {{Date = getDate(), Time = getCurrentTime(), Prices = {}}} or jsonPrice

            if isXDaysLater(jsonPrice[1].Date, 2) then
                global:printSuccess("Le prix des ressources ne sont pas à jour, on les récupère")
                getPricesResourceInHDV()
            end

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

                if not jsonPrice[1].Prices[tostring(item.Id)] or not jsonPrice[1].Prices[tostring(item.Id)].Price1 then
                    jsonPrice[1].Prices[tostring(item.Id)] = GetPricesItem(item.Id)
                end

                item.PriceHdv = jsonPrice[1].Prices[tostring(item.Id)].Price1
            end

            steep = 0 global:leaveDialog()
            global:printSuccess("Récupération finie!")
            global:printMessage("--------------------------------------")
            global:printMessage("")

            -- vend tous les items qu'on a sur nous au meilleur prix
            if not FirstSellDone then
                FirstSellDone = true
                global:printMessage("Vente des items présents dans l'inventaire...")

                HdvSell()
                steep = 0 global:leaveDialog()
                local content = inventory:inventoryContent()
                for _, item in ipairs(content) do
                    for _, item2 in ipairs(TableItem) do

                        if item.objectGID == item2.Id then
                            local cpt = get_quantity(item.objectGID).quantity["1"]
                            while inventory:itemCount(item.objectGID) > 0 and inventory:itemPosition(item.objectGID) == 63 and IsItem(inventory:itemTypeId(item.objectGID)) 
                            and sale:availableSpace() > 0 and cpt < 2 and ItemSatisfyConditionsById(item.objectGID) and (inventory:getLevel(item.objectGID) > 79) do
                                global:printSuccess("1")
                                SellItem(item.objectGID, item2.TotalCost, item2.RunesCost)
                                global:printSuccess("2")
                                cpt = cpt + 1
                                global:printSuccess("3")
                            end
                        end
                    end
                end
            end

            global:printSuccess("Vente finie!")

            -- trie la table du plus rentable à craft au moins rentable
            table.sort(TableItem, function (a, b)
                return (a.PriceHdv - a.TotalCost) > (b.PriceHdv - b.TotalCost)
            end)

            local podsAvailable = inventory:podsMax() - inventory:pods()

            
            global:printMessage("Analyse de la rentabilité des items...")
            global:printMessage("--------------------------------------")

            HdvBuy()

            local cpt = 0
            
            global:printSuccess("1")
            local json = openFile(global:getCurrentScriptDirectory() .. "\\" .. character:server() .. "\\FM.json")
            global:printSuccess("2")

            local blackListJson = openFile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\BlackListFM.json")

            local function IsBlackList(Id)
                for _, element in ipairs(blackListJson) do
                    if element.Id == Id then
                        return true
                    end
                end
                return false
            end

            for _, item in ipairs(TableItem) do
                if kamasOwned < 100000 then
                    global:printSuccess("Plus assez de kamas pour faire d'autres crafts")
                    break
                end

                if nbItemsToCraft > 0 and get_quantity(item.Id).total_quantity < item.NbToCraft and item.TotalCost > 0 and item.TotalCost < 2500000 
                and item.TotalCost < character:kamas() * 0.9 and item.PriceHdv > 0 and (item.PriceHdv / item.TotalCost) > 1.1 and (item.PriceHdv - item.TotalCost) > 10000 
                and podsAvailable > item.PodsNeededToCraft * 2 and (kamasOwned - item.TotalCost * item.NbToCraft * 1.5) > 100000 
                and not IsBlackList(item.Id) then

                    local meanCoef = 0
                    local meanRuneCost = 0
                    local counterCoef = 0
                    local counterRuneCost = 0
                    local totalRunesNeededLastFM = 0
                    local lastFM = ""
                    local lastRuneCost = 0
                    for _, element in ipairs(json) do
                        for _, data in ipairs(element.Data) do
                            if data.Id == item.Id then
                                for _, data2 in ipairs(data.FM) do
                                    meanCoef = meanCoef + data2.FinalCoef
                                    counterCoef = counterCoef + 1
                                    local runeCost = 0
                                    local nbRunes = 0
                                    for k, v in pairs(data2.RunesNeeded) do
                                        runeCost = runeCost + GetPriceRune(tonumber(k)) * v
                                        nbRunes = nbRunes + v
                                    end

                                    if runeCost < 1000000 or compareDates("20/08/2023", data2.Date) then
                                        meanRuneCost = meanRuneCost + runeCost
                                        counterRuneCost = counterRuneCost + 1
                                    end

                                    if lastFM == "" then
                                        lastFM = data2.Date
                                        item.LastCoef = data2.FinalCoef
                                        totalRunesNeededLastFM = nbRunes
                                        lastRuneCost = runeCost
                                    elseif compareDates(lastFM, data2.Date) then
                                        lastFM = data2.Date
                                        item.LastCoef = data2.FinalCoef
                                        totalRunesNeededLastFM = nbRunes
                                        lastRuneCost = runeCost
                                    end
                                end
                            end
                        end
                    end

                    if counterCoef > 0 then
                        meanCoef = meanCoef / counterCoef
                    end
                    if counterRuneCost > 0 then
                        meanRuneCost = meanRuneCost / counterRuneCost
                    end
                    if totalRunesNeededLastFM > 300 and inventory:getLevel(item.Id) < 160 then
                        global:printSuccess("La dernier fm demandé plus de 300 runes, on baisse la qualité pour le prochain")
                        item.QualityWanted = item.LastCoef - 0.015
                    end
                    item.PriceFM = GetPriceFMItem(item.Id, meanCoef > 0 and meanCoef or 1)

                    global:printMessage("Moyenne du cout des runes pour le craft précédent de " .. inventory:itemNameId(item.Id) .. " : " .. meanRuneCost .. ", cout de craft : " .. item.TotalCost .. ", prix fm : " .. item.PriceFM)

                    cpt = cpt + 1
                    if cpt % 5 == 0 then
                        steep = 0 global:leaveDialog()
                        HdvBuy()
                    end

                    if (item.PriceFM > item.TotalCost * ((character:level() > 220) and 1.30 or 1.3)) and 
                    (item.QualityWanted and ((item.PriceFM - item.TotalCost) > lastRuneCost * 0.75) 
                    or ((counterRuneCost > 0) and (((item.PriceFM - item.TotalCost) > meanRuneCost * 1.5) and (item.PriceFM / (item.TotalCost + meanRuneCost) > 1.2))) 
                    or ((item.PriceFM - item.TotalCost) > 75000)) then

                        item.NbToCraft = item.NbToCraft - get_quantity(item.Id).total_quantity
                        kamasOwned = kamasOwned - item.TotalCost * item.NbToCraft * 1.5
                        kamasDepense = kamasDepense + item.TotalCost * item.NbToCraft
                        podsAvailable = podsAvailable - item.PodsNeededToCraft
    

                        if item.ListIdCraft and ItemHasTwoOrMoreCarac(item.Id) and item.NbToCraft > 0 and #TableItemToFM < 10 then
                            nbItemsToCraft = nbItemsToCraft - item.NbToCraft
                            global:printSuccess("[" .. inventory:itemNameId(item.Id) .. "]: Coût de craft = " .. item.TotalCost .. ", Revente = " .. item.PriceHdv .. ", ReventeFM = " .. item.PriceFM .. ", Renta Est : " .. (item.PriceFM / item.TotalCost) .. "%")

                            for _, element in ipairs(tableCraft) do
                                for _, type in ipairs(element.types) do
                                    if item.Type == type and #element.table < (job:level(GetJobIdByType(item.Type)) > 160 and 10 or 6) then
                                        table.insert(element.table, item)
                                        table.insert(TableItemToFM, item)
                                    end
                                end
                            end

                            global:printSuccess("Pods available après ce craft : " .. podsAvailable)
                        end
                    end
                end

            end


            if #TableItemToFM == 0 then
                global:printError("On a trouvé aucune item, on change de script ou reco dans quelques temps")
                local random = math.random(1, 4)
                if random ~= 1 and character:kamas() > 5000000 then
                    global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
                else
                    local random2 = math.random(1, 2)
                    if random2 == 1 and job:level(64) > 190 and job:level(63) > 190 and job:level(62) > 190 and job:level(48) > 190 and job:level(44) > 190 then
                        global:reconnectBis(math.random(400, 600))
                    else
                        global:reconnectBis(math.random(100, 150))
                    end
                end
            end

            EditJsonMemory(TableItemToFM)

            global:printMessage("--------------------------------------")
            global:printMessage("Nous allons faire : ")
            for _, element in ipairs(tableCraft) do
                global:printMessage("- " .. #element.table .. " craft faconneur")
            end
            steep = 0 global:leaveDialog()     

            global:printMessage("--------------------------------------")
            global:printMessage("Le cout Total des crafts est de " .. kamasDepense)
            global:printMessage("--------------------------------------")
            global:printSuccess("Analyse terminée!")

            hdvEquipChecked = true
        end
        
        -- --va hdv ressources
        if not map:onMap(212601350) and not hdvRessourceChecked2 then
            return TreatMaps(goToHdvRessources)
        elseif not hdvRessourceChecked2 then
            --récupère le cout total du craft de chaque item et le met dans la table
            
            global:printMessage("")
            global:printMessage("--------------------------------------")
            global:printMessage("Vérification du vrai coût de craft des items...")

            HdvSell()

            
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
                        for j = #TableItemToFM, 1, -1 do
                            if TableItemToFM[j].Id == item.Id then
                                table.remove(TableItemToFM, j)
                            end
                        end
                    end
                end
            end

            if #TableItemToFM == 0 then
                global:printError("On a trouvé aucune item, on change de script ou reco dans quelques temps")
                local random = math.random(1, 4)
                if random ~= 1 and character:kamas() > 10000000 then
                    global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
                else
                    global:reconnectBis(math.random(100,150))
                end
            end

            EditJsonMemory(TableItemToFM)

            global:printMessage("--------------------------------------")   

            global:printSuccess("Vérification terminée!")
            global:printMessage("--------------------------------------")
            global:printMessage("")

            global:leaveDialog()
            hdvRessourceChecked2 = true
        end


        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked2 then
            return TreatMaps(goToBankBonta)
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

            bankContent = exchange:storageItems()

            for _, element in ipairs(tableCraft) do
                for _, item in ipairs(element.table) do
                    for i = 1, item.NbToCraft do
                        if exchange:storageItemQuantity(item.Id) > 0 and inventory:itemCount(item.Id) == 0 then
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
        
        steep = 0 
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
                    return TreatMaps(element.path)
                else
                    ProcessCraft(element.table, element.cellIdOutWorkshop)
                end
            end
        end
    end

    global:printSuccess("3")

    for _, item in ipairs(TableItemToFM) do
        if inventory:itemCount(item.Id) > 0 and (not item.StatChecked or not ItemSatisfyConditions(item).Bool) or item.FMTrans then

            if not item.StatChecked then
                StatToRePut = ""
                local content = inventory:inventoryContent()
                local qualityItem = 0
                local statsJP = GetDices(item.Id) -- y'a pas les %dommages et %resistance
                local stats = {}
                local statsId = {}
                local runesNeeded = {}
                for _, item2 in ipairs(content) do
                    if item.Id == item2.objectGID then
                        statsId = item2.effects
                        qualityItem = GetQualityItem(statsId, item.Id)
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

                -- utile pour fm les items qui ont pas de vita de base
                if not stats["Vitalite"] then
                    stats["Vitalite"] = {Min = 0, Current = 0, Max = 0}
                end

                for k, v in pairs(stats) do
                    local runes = PoidsByStat[k].Runes
                    for _, rune in ipairs(runes) do
                        table.insert(runesNeeded, rune.Id)
                    end
                end

                table.insert(runesNeeded, PoidsByStat["Vitalite"].Runes[1].Id)
                table.insert(runesNeeded, PoidsByStat["Vitalite"].Runes[2].Id)
                table.insert(runesNeeded, PoidsByStat["Vitalite"].Runes[3].Id)

                for _, rune in ipairs(RunesTransVita) do
                    if rune.Prices.AveragePrice < 500000 and rune.Prices.TrueAveragePrice > 0 then
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

            --va chercher les runes manquantes en banque
            if not map:onMap(217059328) and not item.bankChecked and not ItemSatisfyConditions(item).Bool then
                return TreatMaps(goToBankBonta)
            elseif not item.bankChecked and not ItemSatisfyConditions(item).Bool then
                npc:npcBank(-1)
                if exchange:storageKamas() > 0 then
                    exchange:getKamas(0)
                    randomDelay()
                    global:printSuccess("j'ai récupérer les kamas, je vais vendre")
                elseif exchange:storageKamas() == 0 then
                    global:printError("il n'y a pas de kamas dans la banque")
                end	

                bankContent = exchange:storageItems()

                for _, rune in ipairs(item.InfoFm.RunesNeeded) do
                    local quantity = math.min(200 - inventory:itemCount(rune), exchange:storageItemQuantity(rune), math.ceil(200000 / GetPriceRune(rune)))
                    if quantity > 0 then
                        exchange:getItem(rune, quantity)
                    end
                end

                item.bankChecked = true
                steep = 0 global:leaveDialog()
                map:door(518)
            end

            -- va hdv runes pour acheter les runes manquantes
            if not map:onMap(212601859) and not item.hdvRunesChecked and (not ItemSatisfyConditions(item).Bool or item.FMTrans) then
                return TreatMaps(goToHdvRunes)
            elseif not item.hdvRunesChecked and (not ItemSatisfyConditions(item).Bool or item.FMTrans) then
                global:printSuccess(inventory:itemNameId(item.Id))
                for _, rune in ipairs(item.InfoFm.RunesNeeded) do
                    local quantity = math.floor(math.min(100 - inventory:itemCount(rune), math.ceil((150000 / GetPriceRune(rune)) - inventory:itemCount(rune))))
                    if quantity > 10 or quantity * GetPriceRune(rune) > 20000 then
                        global:printSuccess("Achat de " .. quantity .. " [" .. inventory:itemNameId(rune) .. "]")
                        Achat(rune, quantity)
                    end
                end
                item.hdvRunesChecked = true
            end

            if not map:onMap(217056262) and not item.FMDone and not ItemSatisfyConditions(item).Bool then
                return TreatMaps(goToAtelierFm)
            elseif not item.FMDone and not ItemSatisfyConditions(item).Bool then
                map:useById(TableOutilAtelier[item.Type].FMElementId, TableOutilAtelier[item.Type].FMRep)
                local content = inventory:inventoryContent()

                local cantFM = false

                for _, item2 in ipairs(content) do
                    if item2.objectGID == item.Id then
                        item.InfoFm.StatsId = item2.effects
                        for _, element in ipairs(item2.effects) do
                            if element.actionId == 2825 then
                                cantFM = true
                            end
                        end
                        item.InfoFm.Quality = GetQualityItem(item.InfoFm.StatsId, item.Id)

                        item.InfoFm.Stats = {}
                        local statsJP = GetDices(item.Id)
                        for _, statJp in ipairs(statsJP) do
                            for _, stat in ipairs(item2.effects) do
                                if statJp.id == stat.actionId then
                                    item.InfoFm.Stats[GetNameCarac(stat.actionId)] = {Min = statJp.dice.min, Current = stat.value, Max = statJp.dice.max}
                                end
                            end
                            if not item.InfoFm.Stats[GetNameCarac(statJp.id)] then
                                item.InfoFm.Stats[GetNameCarac(statJp.id)] = {Min = statJp.dice.min, Current = 0, Max = statJp.dice.max}
                            end
                        end
                        local message = developer:createMessage("ExchangeObjectMoveMessage")
                        message.objectUID = item2.objectUID
                        message.quantity = 1
                        developer:sendMessage(message)
                        developer:suspendScriptUntil("ExchangeObjectAddedMessage", 5000, false, nil, 50)
                        break
                    end
                end

                global:printMessage("----- stats actuels ----")
                for k, v in pairs(item.InfoFm.Stats) do
                    global:printSuccess("[" .. k .. "] : { " .. v.Min .. " | " .. v.Current .. " | " .. v.Max .. " }")
                end
                global:printMessage("------------------------")
                global:printSuccess("Qualité = " .. item.InfoFm.Quality * 100 .. " %")



                local condition = ItemSatisfyConditions(item)

                local statToForget = ""

                while not condition.Bool and not cantFM do

                    NbRunesUsed = NbRunesUsed + 1
                    if NbRunesUsed % 10 == 0 then
                        EditJsonMemory(TableItemToFM)
                    end
                    local statToUp = ""
                    local maxCoef = -1

                    while StatToRePut ~= "" do
                        -- si on vient de se prendre un gros +reliquat, on choisi bien ses runes avant de remettre la rune qui a sautée
                        local tableStatWithCoef = {}
                        local coefPositif = false

                        for k, v in pairs(item.InfoFm.Stats) do
                            if not condition.StatsNeeded or #condition.StatsNeeded == 0 or IsInTable(condition.StatsNeeded, k) and k ~= statToForget then
                                local poidsFromMinToMax = (v.Max - v.Min)
                                local coef = 0
                                for i, rune in ipairs(PoidsByStat[k].Runes) do
                                    if ((rune.Value * 20 > (item.InfoFm.Stats[k].Current < v.Min and v.Min or v.Current)) or (i == #PoidsByStat[k].Runes)) and k ~= StatToRePut and v.Max > 0 then
                                        coef = poidsFromMinToMax > 0 and ((v.Max - v.Current - rune.Value) / poidsFromMinToMax) or (v.Max - v.Current - rune.Value) / v.Max
                                        if coef >= 0 and v.Max > 0 then
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
                            à faire 
                            remplacer le itemsatifyconditions en ajoutant le fait qu'on s'en fout de la stat qui a donné le pui!!!s
                            si on a une stat à remonter mais u le poids de cette stat dépasse le puits, on tente de up la vita
                            ex : il reste 17 de puits et la seule carac à monter est les dommage (20 de puits)
                        ]]


                        if coefPositif and not ItemSatisfyConditions(item, StatToRePut).Bool then
                            table.sort(tableStatWithCoef, function (a, b)
                                return a.Coef > b.Coef
                            end)
    
                            for _, element in ipairs(tableStatWithCoef) do
                                global:printSuccess(1)
                                for i, rune in ipairs(PoidsByStat[element.Stat].Runes) do
                                    if ((rune.Value * 20 > (item.InfoFm.Stats[element.Stat].Current < item.InfoFm.Stats[element.Stat].Min and item.InfoFm.Stats[element.Stat].Min or item.InfoFm.Stats[element.Stat].Current)) or (i == #PoidsByStat[element.Stat].Runes)) and rune.Poids <= item.InfoFm.Pui 
                                    and ((item.InfoFm.Stats[element.Stat].Current * PoidsByStat[element.Stat].PoidsUnite + rune.Poids) < 101 
                                    or (item.InfoFm.Stats[element.Stat].Current + rune.Value) <= item.InfoFm.Stats[element.Stat].Max) and element.Stat ~= StatToRePut then
                                        runeSelected = rune.Id
                                        break
                                    end
                                end
                                global:printSuccess(2)

                                if runeSelected == 0 and item.InfoFm.Pui > 2 and (item.InfoFm.Stats[StatToRePut].Max - item.InfoFm.Stats[StatToRePut].Current) == 1 then
                                    global:printSuccess(3)
                                    if not item.InfoFm.Stats["Vitalite"] then
                                        item.InfoFm.Stats["Vitalite"] = {Min = 0, Current = 0, Max = 0}
                                    end
                                    for _, rune in ipairs(PoidsByStat["Vitalite"].Runes) do
                                        if rune.Value * 20 > (item.InfoFm.Stats["Vitalite"].Current < item.InfoFm.Stats["Vitalite"].Min and item.InfoFm.Stats["Vitalite"].Min or item.InfoFm.Stats["Vitalite"].Current) 
                                        and rune.Poids < item.InfoFm.Pui and (item.InfoFm.Stats["Vitalite"].Current * PoidsByStat["Vitalite"].PoidsUnite + rune.Poids) < 101 then
                                            runeSelected = rune.Id
                                            break
                                        end
                                    end
                                    if runeSelected == 0 and PoidsByStat["Vitalite"].Runes[2].Poids < item.InfoFm.Pui then
                                        runeSelected = PoidsByStat["Vitalite"].Runes[2].Id
                                    end

                                    -- si on a trouvé une rune, on la mets, sinon on cherche d'autres runes
                                    if runeSelected ~= 0 then
                                        global:printMessage("2 " .. inventory:itemNameId(runeSelected))
                                        trouvee = true
                                        InfoCurrentItemFM.Id = item.Id
                                        InfoCurrentItemFM.InfoFm = item.InfoFm
                                        InfoCurrentItemFM.CurrentRune = runeSelected
        
                                        UseRune(runeSelected)
        
                                        -- ajouter la rune dans les runes utilisées
                                        item.InfoFm = InfoCurrentItemFM.InfoFm
                                        item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                                    end
                                elseif runeSelected ~= 0 then
                                    global:printMessage("1 " .. inventory:itemNameId(runeSelected))
                                    trouvee = true
                                    InfoCurrentItemFM.Id = item.Id
                                    InfoCurrentItemFM.InfoFm = item.InfoFm
                                    InfoCurrentItemFM.CurrentRune = runeSelected

                                    UseRune(runeSelected)
    
                                    -- ajouter la rune dans les runes utilisées
                                    item.InfoFm = InfoCurrentItemFM.InfoFm
                                    item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                                    break
                                end
                            end
                        elseif (item.InfoFm.Stats[StatToRePut].Max - item.InfoFm.Stats[StatToRePut].Current) == 1 then
                            if not item.InfoFm.Stats["Vitalite"] then
                                item.InfoFm.Stats["Vitalite"] = {Min = 0, Current = 0, Max = 0}
                            end
                            global:printSuccess("On a fini de up l'item on tente de le fm vita")
                            for _, rune in ipairs(PoidsByStat["Vitalite"].Runes) do
                                if rune.Value * 20 > (item.InfoFm.Stats["Vitalite"].Current < item.InfoFm.Stats["Vitalite"].Min and item.InfoFm.Stats["Vitalite"].Min or item.InfoFm.Stats["Vitalite"].Current) 
                                and rune.Poids < item.InfoFm.Pui and (item.InfoFm.Stats["Vitalite"].Current * PoidsByStat["Vitalite"].PoidsUnite + rune.Poids) < 101 then
                                    runeSelected = rune.Id
                                    break
                                end
                            end

                            if runeSelected == 0 and PoidsByStat["Vitalite"].Runes[2].Poids < item.InfoFm.Pui then
                                runeSelected = PoidsByStat["Vitalite"].Runes[2].Id
                            end

                            -- si on a trouvé une rune, on la mets, sinon on cherche d'autres runes
                            if runeSelected ~= 0 then
                                global:printMessage("2 " .. inventory:itemNameId(runeSelected))
                                trouvee = true
                                InfoCurrentItemFM.Id = item.Id
                                InfoCurrentItemFM.InfoFm = item.InfoFm
                                InfoCurrentItemFM.CurrentRune = runeSelected

                                UseRune(runeSelected)

                                -- ajouter la rune dans les runes utilisées
                                item.InfoFm = InfoCurrentItemFM.InfoFm
                                item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                            end

                        end


                        if not trouvee then
                            global:printSuccess("----- Le pui est totalement consommé, on remonte la stat d'où provient le pui -----")
                            -- si on a plus assez de pui, on remets la stat
                            local runeSelected = PoidsByStat[StatToRePut].Runes[1].Id
                            InfoCurrentItemFM.Id = item.Id
                            InfoCurrentItemFM.InfoFm = item.InfoFm
                            InfoCurrentItemFM.CurrentRune = runeSelected
                            StatToRePut = ""

                            UseRune(runeSelected)

                            -- ajouter la rune dans les runes utilisées
                            item.InfoFm = InfoCurrentItemFM.InfoFm
                            item.InfoFm.RunesUsed[tostring(runeSelected)] = not item.InfoFm.RunesUsed[tostring(runeSelected)] and 1 or item.InfoFm.RunesUsed[tostring(runeSelected)] + 1
                        end
                    end

                    local runeSelected = 0

                    for k, v in pairs(item.InfoFm.Stats) do
                        if (not condition.StatsNeeded or #condition.StatsNeeded == 0 or IsInTable(condition.StatsNeeded, k)) and k ~= statToForget and v.Current < v.Max then
                            if v.Current < v.Min then
                                
                                for i, rune in ipairs(PoidsByStat[k].Runes) do
                                    if ((rune.Value * 20 > (v.Current < v.Min and v.Min or v.Current)) or (i == #PoidsByStat[k].Runes))
                                    and ((v.Current + rune.Value) <= v.Max or (v.Current + rune.Value) < 101) then
                                        statToUp = k
                                        runeSelected = rune.Id
                                        local unMergedRune = GetUnMergedRune(rune.Id)
                                        if unMergedRune then
                                            local preview = v.Current
                                            for i = 1, 200 do
                                                if preview + rune.Value <= v.Max then
                                                    preview = preview + rune.Value
                                                else
                                                    break
                                                end
                                            end
                                            local difference = v.Max - preview
                                            if unMergedRune.Value < difference and unMergedRune.Value * 20 >= v.Current then
                                                global:printSuccess("On prend la rune d'en dessous (plus opti) : " .. inventory:itemNameId(unMergedRune.Id))
                                                runeSelected = unMergedRune.Id
                                            end
                                        end
                                        break
                                    end
                                end
                                if statToUp == k then
                                    break
                                end
                            end
    
                            local poidsFromMinToMax = (v.Max - v.Min)
                            local coef = 0
                            for i, rune in ipairs(PoidsByStat[k].Runes) do
                                if ((rune.Value * 20 > (item.InfoFm.Stats[k].Current < item.InfoFm.Stats[k].Min and item.InfoFm.Stats[k].Min or item.InfoFm.Stats[k].Current)) or (i == #PoidsByStat[k].Runes)) then
                                    coef = poidsFromMinToMax > 0 and ((v.Max - v.Current - rune.Value) / poidsFromMinToMax) or (v.Max - v.Current - rune.Value) / v.Max
                                    if coef > maxCoef and (((v.Current * PoidsByStat[k].PoidsUnite + rune.Poids) < 101) or (v.Current + rune.Value) <= v.Max) and v.Max > 0 then
                                        runeSelected = rune.Id
                                        statToUp = k
                                        maxCoef = coef
                                    end
                                    break
                                end
                            end
                        end
                    end

                    -- si on a pas trouvé de rune, on retire la condition rune.Value > 20
                    if statToUp == "" then
                        for k, v in pairs(item.InfoFm.Stats) do
                            if (not condition.StatsNeeded or #condition.StatsNeeded == 0 or IsInTable(condition.StatsNeeded, k)) and k ~= statToForget and v.Current < v.Max then
                                if v.Current < v.Min then
                                    for _, rune in ipairs(PoidsByStat[k].Runes) do
                                        if ((rune.Value * 20 > (v.Current < v.Min and v.Min or v.Current)) or (i == #PoidsByStat[k].Runes))
                                        and ((v.Current + rune.Value) <= v.Max or (v.Current + rune.Value) < 101) then
                                            statToUp = k
                                            runeSelected = rune.Id
                                            local unMergedRune = GetUnMergedRune(rune.Id)
                                            if unMergedRune then
                                                local preview = v.Current
                                                for i = 1, 200 do
                                                    if preview + rune.Value <= v.Max then
                                                        preview = preview + rune.Value
                                                    else
                                                        break
                                                    end
                                                end
                                                local difference = v.Max - preview
                                                if unMergedRune.Value < difference then
                                                    runeSelected = unMergedRune.Value
                                                end
                                            end
                                            break
                                        end
                                    end
                                    if statToUp == k then
                                        break
                                    end
                                end
        
                                local poidsFromMinToMax = (v.Max - v.Min)
                                local coef = 0
                                for i = #PoidsByStat[k].Runes, 1, -1 do
                                    coef = poidsFromMinToMax > 0 and ((v.Max - v.Current - PoidsByStat[k].Runes[i].Value) / poidsFromMinToMax) or (v.Max - v.Current - PoidsByStat[k].Runes[i].Value) / v.Max
                                    if coef > maxCoef and (((v.Current * PoidsByStat[k].PoidsUnite + PoidsByStat[k].Runes[i].Poids) < 101) or (v.Current + PoidsByStat[k].Runes[i].Value) <= v.Max) and v.Max > 0 then
                                        runeSelected = PoidsByStat[k].Runes[i].Id
                                        statToUp = k
                                        maxCoef = coef
                                        break
                                    end
                                end
                            end
                        end
                    end

                    -- si on dépasse la valeur max on change de stat
                    if ((item.InfoFm.Stats[statToUp].Current + GetValueRune(runeSelected)) > item.InfoFm.Stats[statToUp].Max) and not maxExeeded then
                        maxExeeded = true
                        changeRune = true
                        global:printError("On va dépasser la valeur max avec la rune " .. inventory:itemNameId(runeSelected) .. ", on change de rune")
                    end

                    if (item.InfoFm.Stats[statToUp].Current + GetValueRune(runeSelected) > item.InfoFm.Stats[statToUp].Max + (2 / PoidsByStat[statToUp].PoidsUnite))
                     or ((item.InfoFm.Stats[statToUp].Current * PoidsByStat[statToUp].PoidsUnite + GetPoidsRune(runeSelected)) > 101 and item.InfoFm.Stats[statToUp].Current + GetValueRune(runeSelected) > item.InfoFm.Stats[statToUp].Max) then
                        global:printError("On va dépasser la valeur max avec la rune " .. inventory:itemNameId(runeSelected) .. ", on prends la rune en dessous")
                        runeSelected = GetUnMergedRuneId(runeSelected)
                        if runeSelected == 0 then
                            global:printError("Il n'y a pas de rune en dessous, on change de stat")
                            changeRune = true
                            statToForget = statToUp
                        end
                    end

                    -- si on a plus cette rune, on va en racheter
                    if inventory:itemCount(runeSelected) == 0 and not changeRune then
                        global:printError("Nous n'avons plus suffisament de rune, on va en racheter")
                        item.hdvRunesChecked = false
                        steep = 0 global:leaveDialog()
                        return move()
                    end

                    if not changeRune then
                        statToForget = ""
                        maxExeeded = false
                        InfoCurrentItemFM.Id = item.Id
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

                item.RunesCost = 0
                for k, v in pairs(item.InfoFm.RunesUsed) do
                    global:printSuccess(inventory:itemNameId(tonumber(k)) .. " : " .. v)
                    item.RunesCost = item.RunesCost + GetPriceRune(tonumber(k)) * v
                end
    
                global:printMessage("-----------------------------------")
                global:printMessage("Nous avons dépensé " .. item.RunesCost .. " k en runes pour [" .. inventory:itemNameId(item.Id) .. "] qui nous a couté " .. item.TotalCost .. " à craft")
                global:printMessage("-----------------------------------")
    
                if NbRunesUsed > 0 then
                    NbRunesUsed = 0
                    MaxCoef = 0
                    AddToJsonData(item)
                end

                EditJsonMemory(TableItemToFM)
            end

            if not map:onMap(217056262) and item.FMTrans then
                return TreatMaps(goToAtelierFm)
            elseif item.FMTrans then
                if inventory:itemCount(item.RuneTrans.Id) == 0 then
                    global:printError("On a plus de rune trans, on va en racheter")
                    item.InfoFm.RunesNeeded = {item.RuneTrans.Id}
                    item.hdvRunesChecked = false
                    return move()
                end
                map:useById(TableOutilAtelier[item.Type].FMElementId, TableOutilAtelier[item.Type].FMRep)
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

                UseRune(item.RuneTrans.Id)

                steep = 0 global:leaveDialog()
                item.FMTrans = false
            end
        end 
    end

    --- Path To Craft
    for _, element in ipairs(tableCraft) do
        element.table = {}
    end
    --- Final Selling


    global:printSuccess("finalsell")

    if not map:onMap(212600837) and not ItemSold then
        return TreatMaps(goToHdvEquip)
    elseif not ItemSold then
        local content = inventory:inventoryContent()
        for _, item in ipairs(content) do
            for i, item2 in ipairs(TableItemToFM) do
                if item.objectGID == item2.Id then

                    local statsJP = GetDices(item2.Id)
                    item2.InfoFm.StatsId = item.effects
                    item2.InfoFm.Stats = {}
                    for _, statJp in ipairs(statsJP) do
                        for _, stat in ipairs(item.effects) do
                            if statJp.id == stat.actionId then
                                item2.InfoFm.Stats[GetNameCarac(stat.actionId)] = {Min = statJp.dice.min, Current = stat.value, Max = statJp.dice.max}
                            end
                        end
                        if not item2.InfoFm.Stats[GetNameCarac(statJp.id)] then
                            item2.InfoFm.Stats[GetNameCarac(statJp.id)] = {Min = statJp.dice.min, Current = 0, Max = statJp.dice.max}
                        end
                    end

                    if not item2.InfoFm.Stats["Vitalite"] then
                        item2.InfoFm.Stats["Vitalite"] = {Min = 0, Current = 0, Max = 0}
                    end

                    item2.RunesCost = 0
                    for k, v in pairs(item2.InfoFm.RunesUsed) do
                        global:printSuccess(inventory:itemNameId(tonumber(k)) .. " : " .. v)
                        item2.RunesCost = item2.RunesCost + GetPriceRune(tonumber(k)) * v
                    end

                    local over = false
                    for _, stat in ipairs(item2.InfoFm.StatsId) do
                        local found = false
                        for k, v in pairs(item2.InfoFm.Stats) do
                            if GetNameCarac(stat.actionId) == k then
                                found = true
                            end
                        end
                        if not found then
                            over = true
                            break
                        end
                    end
                    for k, v in pairs(item2.InfoFm.Stats) do
                        if v.Current > v.Max then
                            over = true
                        end 
                    end

                    if not over then
                        PourcentageJetPerf_ItemToSell = GetQualityItem(item.effects, item.objectGID)
                        ItemStats = {}
                        for _, stat in ipairs(item.effects) do
                            if developer:typeOf(stat) == "ObjectEffectInteger" and IsActionIdKnown(stat.actionId) then
                                ItemStats[#ItemStats+1] = {actionId = stat.actionId, value = stat.value}
                            end
                        end
                        IdToSell = item.objectGID
                        HdvBuy()

                        local message = developer:createMessage("ExchangeBidHouseSearchMessage")
                        message.objectGID = item2.Id
                        message.follow = true
                        developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM)
                        developer:sendMessage(message)
                        developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

                        item2.PriceWithoutTrans = BestPrice < (item2.TotalCost  * 2 +  item2.RunesCost * 3) and BestPrice or (item2.TotalCost  * 2 +  item2.RunesCost * 3)
                        local currentPrice = BestPrice
                        local renta = 0
                        global:printMessage("Le prix de " .. inventory:itemNameId(item2.Id) .. " sans rune trans est de " .. currentPrice)
                        global:leaveDialog()

                        -- vérifier aussi que l'item n'a pas déjà une une de trans (retrouver l'id)
                        for _, rune in ipairs(RunesTransVita) do
                            if item2.InfoFm.Stats["Vitalite"].Current * PoidsByStat["Vitalite"].PoidsUnite < rune.ConditionPoids and BestPrice > 0 then
                                
                                HdvBuy()
                                -- ajouter la valeur de la rune à la stat vita
                                BestPrice = 0
                                ItemStats = {}
                                for _, stat in ipairs(item.effects) do
                                    if developer:typeOf(stat) == "ObjectEffectInteger" and IsActionIdKnown(stat.actionId) then
                                        ItemStats[#ItemStats+1] = {actionId = stat.actionId, value = stat.value}
                                    end
                                end
                                for _, stat in ipairs(ItemStats) do
                                    if stat.actionId == 125 then
                                        stat.value = stat.value + rune.Value
                                    end
                                end
                                PourcentageJetPerf_ItemToSell = GetQualityItem(ItemStats, item.objectGID)

                                PoidsOver = GetPoidsOver(ItemStats, item.objectGID)

                                local message = developer:createMessage("ExchangeBidHouseSearchMessage")
                                message.objectGID = item2.Id
                                message.follow = true
                                if PoidsOver > 0 then
                                    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceOver)
                                else
                                    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceFM)
                                end
                                developer:sendMessage(message)
                                developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)

                                local newRenta = BestPrice - currentPrice - rune.Prices.AveragePrice
                                -- si cout de craft + cout du fm < revente, on choisi cette rune
                                -- sinon, si on atténue la perte avec la rune trans, on la met
                                if BestPrice > item2.TotalCost + item2.RunesCost + rune.Prices.AveragePrice and newRenta > 0 and rune.Prices.TrueAveragePrice > 0 and rune.Prices.TrueAveragePrice < 1000000 then
                                    renta = newRenta
                                    item2.RuneTrans = rune
                                    item2.FMTrans = true
                                elseif newRenta > renta and newRenta > 0 and rune.Prices.TrueAveragePrice > 0 and rune.Prices.TrueAveragePrice < 1000000 then
                                    renta = newRenta
                                    item2.RuneTrans = rune
                                    item2.FMTrans = true
                                end

                                global:printMessage("Si on lui mets une " .. inventory:itemNameId(rune.Id) .. ", on gagne " .. newRenta .. "k sur la vente de notre item")
                                global:leaveDialog()
                            end
                        end
                    end

                    while not item2.FMTrans and inventory:itemCount(item.objectGID) > 0 and inventory:itemPosition(item.objectGID) == 63 and IsItem(inventory:itemTypeId(item.objectGID)) 
                    and sale:availableSpace() > 0 do
                        global:printMessage("[" .. inventory:itemNameId(item.objectGID) .. "] : TotalCost : " .. item2.TotalCost + item2.RunesCost .. " (Craft : " .. item2.TotalCost .. ", FM : " .. item2.RunesCost .. "), PriceFM = " .. item2.PriceFM)
                        if item2.RunesCost > 1000000 then
                            global:printError("POTENTIEL BUG ")
                            local blackListJson = openFile(global:getCurrentScriptDirectory() .. "\\BlackListFM.json")

                            blackListJson[#blackListJson+1] = {name = inventory:itemNameId(item2.Id), Id = item2.Id}           
                        
                            local new_content = json.encode(blackListJson)
                            -- Écrire les modifications dans le fichier JSON
                        
                            local file = io.open(global:getCurrentScriptDirectory() .. "\\" .. "\\BlackListFM.json", "w")
                        
                            file:write(new_content)
                            file:close()
                        end
                        if item2.RuneTrans then
                            global:printMessage("On vend au maximum à " .. math.floor(item2.PriceWithoutTrans + (item2.RuneTrans.Prices.AveragePrice * 3)))
                            SellItem(item.objectGID, item2.TotalCost, item2.RunesCost, math.floor(item2.PriceWithoutTrans + (item2.RuneTrans.Prices.AveragePrice * 3)))
                            randomDelay()
                        else
                            SellItem(item.objectGID, item2.TotalCost, item2.RunesCost, math.floor((item2.TotalCost  * 2 +  item2.RunesCost * 3)))
                            randomDelay()
                        end
                        table.remove(TableItemToFM, i)
                        EditJsonMemory(TableItemToFM)
                    end
                end
            end
        end

        for _, item in ipairs(TableItemToFM) do
            if item.FMTrans then
                return move()
            end
        end
        ItemSold = true
        HdvSell2()
        steep = 0 global:leaveDialog()
    end

    TableItemToFM = {}
    EditJsonMemory(TableItemToFM)


    if map:currentArea() ~= "Astrub" then
        if not map:onMap("0,0") then
            map:changeMap("havenbag")
        end
        map:changeMap("zaap(191105026)")
    end
    
    if not map:onMap(192415750) then
        map:moveToward(192415750)
    else
        npc:npcBank(-1)
        randomDelay()
        exchange:putAllItems()
        steep = 0 global:leaveDialog()

        global:printMessage("-------------------")
        global:printSuccess("Total dépensé : " .. KamasDeBase - character:kamas())
        --global:printSuccess("Total mis en vente : " ..)
        local random = math.random(1, 4)
        if random == 1 and character:kamas() > 10000000 then
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
        else
            global:printSuccess("On retourne crafter")
            for _, item in ipairs(TableItem) do
                if not item.TotalCost and item.ListIdCraft then
                    hdvRessourceChecked = false
                    break
                end
            end
            ScriptStarting = true
            hdvEquipChecked = false
            bankChecked2 = false
            ItemSold = false
            return move()
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

function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end

function bank()
    return move()
end

function stopped()
    local lines = global:consoleLines()
    if lines[#lines - 2]:find("Cette action est impossible car vous êtes occupé.") or lines[#lines - 1]:find("Echec lors de l'utilisation d'un Zaap/Zaapi") then
        global:reconnect(0)
    end
end