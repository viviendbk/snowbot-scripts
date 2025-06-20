dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


local CraftCordonier = {}
local CraftBijoutier = {}
local CraftTailleur = {}
local CraftForgeron = {}
local CraftSculpteur = {}
local TableItem = {}


local TableItemToFM = {}
local hasToCraft = false

local ScriptStarting = true
local bankChecked = false
local bankChecked2 = false
local hdvRessourceChecked = false
local hdvRessourceChecked2 = false
local memoryChecked = false
local hdvEquipChecked = false
local goBuyStuff = false
local ItemSold = false
local FMDone = false
local brisageDone = false
local InfoCurrentItemFM = {}
local StatToRePut = ""
local steep = 0
local counter = 0 
NbRunesUsed = 0
local bankContent = {}
MaxCoef = 0

local stuffPods = {
    {Name = "Sac du grand aventurier", Id = 1707, Place = 7},
    {Name = "Bottes du meulou", Id = 8264, Place = 5},
    {Name = "bague de boufbowl", Id = 11083, Place = 2},
    {Name = "Ceinture du bouftou", Id = 2428, Place = 3},
    {Name = "coiffe du père noel", Id = 8334, Place = 6},
    {Name = "anneau de gadjet", Id = 11087, Place = 4},

}

for _, element in ipairs(stuffPods) do
    if inventory:itemCount(element.Id) == 0 then
        goBuyStuff = true
    end
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
                map:useById(TABLE_OUTIL_ATELIER[element.Type].ElementId, -1)
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

local goToCosmetics = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(217064452)"},
    {map = "212601348", path = "zaapi(217064452)"}, -- extérieur atelier forgeron
    {map = "212599814", path = "zaapi(217064452)"}, -- extérieur atelier taileur
    {map = "212599813", path = "zaapi(217064452)"}, -- extérieur atelier bijoutier
    {map = "212601347", path = "zaapi(217064452)"}, -- extérieur atelier cordonier
    {map = "212600322", path = "zaapi(217064452)"}, -- exterieur banque
    {map = "212601350", path = "zaapi(217064452)"}, -- hdv ressources
    {map = "212600837", path = "zaapi(217064452)"}, -- hdv equipements
    {map = "212731651", door = "192"}
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
            if tostring(effect) == "SwiftBot.ObjectEffectInteger" and GetNameCarac(effect.actionId) == k and (v.Current - effect.value) ~= 0 then
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

function _getUIDCoiffe(message)
    developer:unRegisterMessage("ExchangeBidHouseInListRemovedMessage")
    UIDCoiffe = message.itemUID
end


function _getUIDCape(message)
    developer:unRegisterMessage("ExchangeBidHouseInListRemovedMessage")
    UIDCape = message.itemUID
end

local function achatShushi()
    npc:npc(286, 6)
    UIDCoiffe = 0
    UIDCape = 0
    developer:registerMessage("ExchangeBidHouseInListRemovedMessage", _getUIDCoiffe)
    sale:buyItem(18154, 1, 800000)
    developer:suspendScriptUntil("ExchangeBidHouseInListRemovedMessage", 5000, false, nil, 20)

    global:leaveDialog()

    inventory:equipItem(18154, 6)

    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCoiffe
    message.livingPosition = 6
    message.skinId = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)


    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCoiffe
    message.livingPosition = 6
    message.skinId = 2
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)

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

local function isItemCeluiQuonACraft(objectGID)
    for _, item in ipairs(CraftCordonier) do
        if item.Id == objectGID then
            return true
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        if item.Id == objectGID then
            return true
        end
    end
    for _, item in ipairs(CraftTailleur) do
        if item.Id == objectGID then
            return true
        end
    end
    for _, item in ipairs(CraftForgeron) do
        if item.Id == objectGID then
            return true
        end
    end
    for _, item in ipairs(CraftSculpteur) do
        if item.Id == objectGID then
            return true
        end
    end
    for _, item in ipairs(TableItem) do
        if item.Id == objectGID then
            return true
        end
    end
    return false
end

function move()

    mapDelay()
    if ScriptStarting then
        -- vérifie qu'il est bien abonné        
        if getRemainingHoursSubscription() < 24 then
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
                if IsItem(inventory:itemTypeId(i)) and inventory:getLevel(i) <= job:level(GetJobIdByType(inventory:getTypeName(i)))
                 and ((inventory:itemCount(i) > 0 and inventory:itemPosition(i) == 63) or inventory:itemCount(i) == 0) then
                    table.insert(TableItem, {
                        Id = i,
                        ListIdCraft = getRecipe(i),
                        Type = inventory:getTypeName(i),
                        NbToCraft = 1
                    })
                end
            end
            global:printSuccess("Remplissage fini!, il y a " .. #TableItem .. " items craftables")

        end

        -- achat du stuff
        if not map:onMap(212600837) and goBuyStuff then
            global:printSuccess("On va hdv équip pour acheter le stuff")
            return treatMaps(goToHdvEquip)
        elseif goBuyStuff then
            global:printSuccess("On achète le stuff")
            HdvBuy()

            for _, element in ipairs(stuffPods) do
                if inventory:itemCount(element.Id) == 0 then
                    sale:buyItem(element.Id, 1, 300000)
                end
            end

            global:leaveDialog()
            for _, element in ipairs(stuffPods) do
                inventory:equipItem(element.Id, element.Place)
            end
            goBuyStuff = false
            goBuySushi = true
        end

        if not map:onMap(217064452) and goBuySushi then
            return treatMaps(goToCosmetics)
        elseif goBuySushi then
            achatShushi()
            goBuySushi = false
        end


        -- --va hdv ressources
        if not map:onMap(212601350) and not hdvRessourceChecked then
            return treatMaps(goToHdvRessources)
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
                    global:printError("L'item " .. inventory:itemNameId(item.Id) .. " n'a pas de ressources de craft, on le supprime")
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

            local ItemsToCraft = {}

            local metiers = {
                {Id = 11, Table = CraftForgeron, Type = {"Épée", "Hache", "Marteau", "Dague", "Pelle"}},
                {Id = 13, Table = CraftSculpteur, Type = {"Bâton", "Baguette", "Arc"}},
                {Id = 15, Table = CraftCordonier, Type = {"Ceinture", "Bottes"}},
                {Id = 16, Table = CraftBijoutier, Type = {"Anneau", "Amulette"}},
                {Id = 27, Table = CraftTailleur, Type = {"Cape", "Coiffe"}},
            }

            local scriptFinished = true
            for _, element in ipairs(metiers) do
                global:printMessage("On va craft pour le métier " .. job:name(element.Id) .. " [" .. element.Type[1] .. ", " .. element.Type[2] .. "]")
                if job:level(element.Id) < 55 then
                    scriptFinished = false
                    hasToCraft = true
                    global:printSuccess("a")
                    local podsAvailable = inventory:podsMax() - inventory:pods()
                    for _, item in ipairs(TableItem) do
                        if #item.ListIdCraft > 0 and item.TotalCost > 0 and ((inventory:getLevel(item.Id)) > (job:level(element.Id) - 4)) and IsInTable(element.Type, item.Type) and ((item.PodsNeededToCraft * 100) < podsAvailable) then
                            global:printError("AAAA" .. item.TotalCost)
                            table.insert(ItemsToCraft, {Id = item.Id, TotalCost = item.TotalCost, Type = item.Type, PodsNeededToCraft = item.PodsNeededToCraft, ListIdCraft = getRecipe(item.Id), NbToCraft = 100})
                        end
                    end

                    global:printSuccess("b")
                    table.sort(ItemsToCraft, function (a, b)
                        return a.TotalCost < b.TotalCost
                    end)
                                        global:printSuccess("c")
                    global:printSuccess("On va craft  " .. inventory:itemNameId(ItemsToCraft[1].Id) .. " [lvl " .. inventory:getLevel(ItemsToCraft[1].Id) .. "]")

                    table.insert(element.Table, ItemsToCraft[1])
                    break
                end
            end
            
            if scriptFinished then
                global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
            end

            steep = 0 global:leaveDialog()
            hdvRessourceChecked = true
        end
        
        KamasDeBase = character:kamas()
        
        --va chercher les kamas en banque
        if not map:onMap(217059328) and not bankChecked2 then
            return treatMaps(goToBankBonta)
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
        return treatMaps(goToHdvRessources)
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
        global:printSuccess("a " .. inventory:itemNameId(item.Id))
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217055238) then
                return treatMaps(goToAtelierCordoBonta)
            else
                ProcessCraft(CraftCordonier, 360, 15)
            end
        end
    end
    for _, item in ipairs(CraftBijoutier) do
        global:printSuccess("b " .. inventory:itemNameId(item.Id))
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217058310) then
                return treatMaps(goToAtelierBijoutierBonta)
            else
                ProcessCraft(CraftBijoutier, 485, 16)
            end
        end
    end
    for _, item in ipairs(CraftTailleur) do
        global:printSuccess("c " .. inventory:itemNameId(item.Id))
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217056260) then
                return treatMaps(goToAtelierTailleurBonta)
            else
                ProcessCraft(CraftTailleur, 520, 27)
            end
        end
    end
    for _, item in ipairs(CraftForgeron) do
        global:printSuccess("d " .. inventory:itemNameId(item.Id))
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217055236) then
                return treatMaps(goToAtelierForgeronBonta)
            else
                ProcessCraft(CraftForgeron, 526, 11)
            end
        end
    end
    for _, item in ipairs(CraftSculpteur) do
        global:printSuccess("e " .. inventory:itemNameId(item.Id))
        if inventory:itemCount(item.Id) < item.NbToCraft then
            if not map:onMap(217058308) then
                return treatMaps(goToAtelierSculpteurBonta)
            else
                ProcessCraft(CraftSculpteur, 479, 13)
            end
        end
    end
    
    global:printSuccess("3")


    if not map:onMap(217056262) and not brisageDone then
        return treatMaps(goToBrisage)
    elseif not brisageDone then
        local content = inventory:inventoryContent()

        local items = {}
        for _, element in ipairs(content) do
            if IsItem(inventory:itemTypeId(element.objectGID)) and element.position == 63 and (isItemCeluiQuonACraft(element.objectGID)
            or inventory:itemCount(element.objectGID) > 10) then
                table.insert(items, {objectGID = element.objectGID, objectUID = element.objectUID, quantity = element.quantity})
            end
        end
        


        local index = 1
        local step = 1 
        while index <= #items do
            local batchSize = math.min(50, #items - index + 1)

            for i = 0, batchSize - 1 do
                if inventory:podsP() > 80 then
                    global:printSuccess("on va merge les runes ")
                    MergeRunes()
                end
                map:useById(521675, -1)
                global:delay(math.random(500, 1500))
                debug("on va mettre l'objet " .. inventory:itemNameId(items[index + i].objectGID) .. " dans l'échange")
                local item = items[index + i]
                local message = developer:createMessage("ExchangeObjectMoveRequest")
                message.object_uid = item.objectUID
                message.quantity = item.quantity
                developer:sendMessage(message)
                
                developer:suspendScriptUntil("ExchangeObjectsAddedEvent", 5000, false, nil, 50)
                global:delay(math.random(50, 200))

                -- Confirmer l'envoi de ce lot
                local message = developer:createMessage("ExchangeFocusedReadyRequest")
                message.focus_action_id = 0
                message.ready = true
                message.step = step
                developer:sendMessage(message)
                global:delay(math.random(500, 1500))
                global:leaveDialog()
            end

            debug("fini de mettre les objets dans l'échange")

            global:delay(math.random(1000, 2000))
            debug("on a validé")
            -- Passer aux items suivants
            index = index + batchSize
            step = step + 1
        end

        global:leaveDialog()
    end


    if not hasToCraft then
        global:printSuccess("Fini de monter les métiers")
        global:disconnect()
    end

    global:restartScript(true)


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
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Craft\\Craft-Brisage.lua")
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