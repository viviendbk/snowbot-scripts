---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")
DEVELOPER_MULTI_THREADING = true

if not global:remember("bank()") then
    global:addInMemory("bank()", false)
end

-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

FORBIDDEN_MONSTERS = {}

AMOUNT_MONSTERS = {}

TeamAcount = global:thisAccountController():getTeamAccounts()
lenghtTeam = 0

if global:isBoss() then
    lenghtTeam = #TeamAcount + 1
end


if global:isBoss() then
    for _, acc in ipairs(TeamAcount) do
        while not acc:isAccountFullyConnected() do
            reload = true
            --global:printSuccess("Attente de la connexion des mules")
            global:delay(2000)
        end
        acc.global:deleteMemory("retryPortail")
        acc.global:deleteMemory("lenghtTeam")
        acc.global:addInMemory("lenghtTeam", lenghtTeam)
    end
    global:deleteMemory("retryPortail")
    global:deleteMemory("lenghtTeam")
    global:addInMemory("lenghtTeam", lenghtTeam)
    if reload then 
        global:restartScript(true) 
    end
end

lenghtTeam = global:remember("lenghtTeam")


GoToAstrubBank = {
    -- mettre tous les zaaps des zones qu'on farm vers le zaap astrub + le trajet vers la banque astrub
    {map = "-32,-56", path = "zaap(84674563)"},
    {map = "-16,1", path = "zaap(84674563)"},
    {map = "5,7", path = "zaap(84674563)"},
    {map = "10,22", path = "zaap(84674563)"},
    {map = "4,-19", path = "bottom"},
    {map = "4,-18", path = "bottom"},
    {map = "4,-17", path = "bottom"},
    {map = "84674566", door = "303"},
    {map = "83887104", custom = function ()
        if global:isBoss() then
            AccountBank = connectBotBanque()
            LaunchExchange = true
            launchExchangeAndGiveItems()
        end
    end}
}

ArbreHakam1 = {
    {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
    {map = "0,0", path = "zaap(20973313)"},
    {map = "20973313", lockedCustom = function()
        message = developer:createMessage("SpellVariantActivationRequestMessage")
        message.spellId = 14011
        if global:isBoss() then
            local team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                acc.developer:sendMessage(message)
                global:delay(500)
                acc.map:changeMap("bottom")
            end
            developer:sendMessage(message)
            global:delay(500)
            map:changeMap("bottom")
        end
        end},
    {map = "20973056", path = "bottom"},
    {map = "20973057", path = "right"},
    {map = "20973569", door = "471"},
    {map = "25692680", door = "492"},
    {map = "25691146", path = "top"},
    {map = "25691144", path = "257"},
    {map = "24118791", fight = true, path = "top"},
    {map = "24118790", fight = true, path = "left"},
    {map = "24118278", fight = true, path = "bottom"},

}

ArbreHakam2 = {
    {map = "24118279", fight = true, path = "top"},
    {map = "24118278", fight = true, path = "left"},
    {map = "24117766", fight = true, path = "bottom"},
    {map = "24117767", fight = true, path = "434"},
    {map = "25691654", path = "top"},
    {map = "25691652", path = "top"},
    {map = "25691650", path = "540"},
    {map = "24117765", fight = true, path = "right"},
    {map = "24118277", fight = true, path = "right"},
    {map = "24118789", fight = true, door = "178"},
    {map = "24119314", fight = true, path = "left"},
    {map = "24118802", fight = true, door = "445"},
    {map = "25690624", path = "left"},
    {map = "25690112", path = "bottom"},
    {map = "24117761", fight = true, path = "right"},
    {map = "24118273", fight = true, path = "right"},
    {map = "24118785", fight = true, path = "bottom"},
    {map = "24118786", fight = true, path = "bottom"},
    {map = "24118787", fight = true, path = "left"},
    {map = "24118275", fight = true, path = "left"},
    {map = "24117763", fight = true, path = "top"},
    {map = "24117762", fight = true, path = "right"},
}

ArbreHakam3 = {
    {map = "24118274", fight = true, path = "bottom"},
    {map = "24118275", fight = true, path = "524"},
    {map = "25694213", path = "havenbag"},
    {map = "0,0", path = "zaap(20973313)"},
    {map = "20973313", path = "bottom"},
    {map = "20973056", path = "bottom"},
    {map = "20973057", path = "right"},
    {map = "20973569", path = "right"},
    {map = "20974081", path = "top"},
    {map = "20974080", path = "253"},
    {map = "25690116", path = "338"},
    {map = "24118794", fight = true, path = "bottom"},
    {map = "24118795", fight = true, path = "539"},
    {map = "25694721", path = "left"},
    {map = "25694209", path = "left"},
    {map = "25693697", path = "top"},
    {map = "25693696", path = "318"},
    {map = "24117771", fight = true, path = "right"},
    {map = "24118283", fight = true, path = "top"},
    {map = "24118282", fight = true, path = "left"},
    {map = "24117770", fight = true, path = "top"},
    {map = "24117769", fight = true, path = "right"},
    {map = "24118281", fight = true, path = "right"},
    {map = "24118793", lockedCustom = function()
        message = developer:createMessage("SpellVariantActivationRequestMessage")
        message.spellId = 12761
        if global:isBoss() then
            local team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                acc.developer:sendMessage(message)
                global:delay(500)
                acc.map:door(135)
            end
            developer:sendMessage(message)
            global:delay(500)
            map:door(135)
        end
        end},
}


TableArea = {
    {Zone = {
        {ArbreHakam1, "24118279", false}, {ArbreHakam2, "24118274", false}, {ArbreHakam3, "25690115", false},
    }, MaxMonster = (lenghtTeam == 2) and 5 or (lenghtTeam == 3) and 6 or 8, MinMonster = (lenghtTeam < 4) and 1 or 3, ListeVenteId = {8797, 8796, 8788, 8792, 8832, 8793, 8790, 8791, 8787, 8786}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
}

--- </init>


TableVente = {
    {Name = "Souche de l'Abrakleur clair", id = 8797, maxHdv100 = 10, maxHdv10 = 20, maxHdv1 = 10, canSell = true},
    {Name = "Nœud de l'Abrakleur clair", id = 8796, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Croupion du Bitouf aérien", id = 8788, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Coco du Bitouf aérien", id = 8792, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Bave du Kaskargo", id = 8832, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Coquille du Kaskargo", id = 8793, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Rembourrage de Meupette", id = 8790, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Étoffe de Meupette", id = 8791, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Cloaque du Poolay", id = 8787, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Tresse du Poolay", id = 8786, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},

}

local CompteurDeath = 0
local cptActualiser = 1
local hdvActualise = false


local hdvFull = false
local DebutDuScript = true

--- <parameters>

local receiverAlias = "bank"
-- Montant de kamas que le bot farm devra garder 

local minKamas = nil

-- Montant de kamas qui déclenchera le transfert au bot bank
local givingTriggerValue = 2500000

-- Temps d'attente maximal de la connexion du bot bank (en secondes)
local maxWaitingTime = 5

-- Temps d'attente avant de réessayer de connecter le bot bank (en heures)
local minRetryHours = 6


--- </parameters>



--- </functions>


local function secondsToHours(time)
    return time / 60 / 60
end

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

function connectBotBanque()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank_" .. character:serverName():lower()) then
            if not acc:isAccountConnected() then
                acc:connect()

                global:printMessage("attente de la connexion du bot banque")

                while not acc:isAccountFullyConnected() do
                    global:delay(2000)
                end

                global:printSuccess("le bot banque s'est connecté !")

				acc:loadScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Bot_Bank.lua")
                acc:startScript()
                return acc
            else
                global:printSuccess("bot déjà connecté, on attend 5 secondes")
                global:delay(5000)
                return connectBotBanque()
            end
        end
    end
end

function launchExchangeAndGiveItems()
    
    inventory:openBank()
    global:delay(500)

    for _, element in ipairs(TableVente) do
        local podsAvailable = inventory:podsMax() - inventory:pods()
        local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), math.floor(podsAvailable / inventory:itemWeight(element.id)))
        if QuantiteAPrendre > 0 then
            LaunchExchange = true
            exchange:getItem(element.id, QuantiteAPrendre)
        end
    end
    global:delay(500)
    global:leaveDialog()
    global:delay(500)

    if LaunchExchange then
        global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

        AccountBank.global:setPrivate(false)
    
        while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
            global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
            global:delay(5000)
        end
    
        exchange:putAllItems()
        global:delay(500)
        exchange:ready()
    
    
        if developer:suspendScriptUntil("ExchangeLeaveMessage", 10000, true, nil, 20) then
            global:printSuccess("L'échange s'est bien déroulé, on check la banque de nouveau")
            LaunchExchange = false
            launchExchangeAndGiveItems()
        else
            global:printError("Bug sur le dernier exchange, deconnexion")
            global:disconnect()
        end
    end
    -- si on a plus rien à donner au bot banque, on retourne farm
    if global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc:callScriptFunction("PopoRappel")
        end
        PopoRappel()
    end
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

local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end


---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
function get_quantity(id)
    if object_in_hdv then
        local informations = {
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

function CheckEndFight(message)
    if lenghtTeam == 4 then
        if not message.results[1].alive and not message.results[2].alive and not message.results[3].alive and not message.results[4].alive then

            CompteurDeath = CompteurDeath + 1
    
            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    if CompteurDeath < 2 then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
    elseif lenghtTeam == 3 then
        if not message.results[1].alive and not message.results[2].alive and not message.results[3].alive then
            CompteurDeath = CompteurDeath + 1
    
            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    if CompteurDeath < 2 then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
    elseif lenghtTeam == 2 then
        if not message.results[1].alive and not message.results[2].alive then

            CompteurDeath = CompteurDeath + 1
    
            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    
                    if CompteurDeath < ((element.ListeVenteId[1] == 8797) and 3 or 2) then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
        
    end
end

function isWhitelisted(id)
    local IdsAvailable = global:getTeamMembersIds()
    global:printSuccess(id)

    for _, Id in ipairs(IdsAvailable) do
        global:printSuccess(Id)
        if Id == id then
        	return true
        end
    end
    return false
end

function _ExchangeRequestedTradeMessage(message)
    if not global:isBoss() then
        global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
        developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
        global:delay(1000)
    
        local toGive = character:kamas() - 70000
        -- Put kamas
        if toGive > 0 then
            global:printSuccess("Je mets dans l'échange ".. toGive .." kamas.")
            exchange:putKamas(toGive)
        end
    
        global:printSuccess("je mets les ressources")
    
        exchange:putAllItems()
    
        global:printSuccess("on valide l'échange")
    
        exchange:ready()
        -- Wait
        global:printMessage("Attente de confirmation ...")
    end
    global:printSuccess("bug")
	-- Check
	--[[if not isWhitelisted(message.source) then
		global:printError("Échange reçu de la part d'un joueur inconnu, on refuse !")
		global:leaveDialog()
		return
	end]]
	-- Accept
end

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
    developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end

---Fonction qui permet de lancer la communication avec l'HDV.

function antiModo()
    if global:isModeratorPresent(45) then
        timerdisconnect = math.random(27000, 36000) 

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

        local Alias = global:thisAccountController():getAlias():split(" ")

        if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
            global:editAlias("Team 1 " .. character:serverName() .. " Combat [MODO]", true)
        else
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. " Combat [MODO]", true)
        end

        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global:reconnectBis((timerdisconnect + 10) / 1000)
            end
            global:reconnectBis(timerdisconnect / 1000)
        end
    end
end

function ProcessSell()

    if not DebutDuScript then
        if global:isBoss() then

            npc:npcSale()

            developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

            table.sort(TableVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)

            global:delay(1000)

            for _, element in ipairs(TableVente) do
                if inventory:itemCount(element.id) == 0 then global:printSuccess("on a plus rien à vendre") break end

                cpt = get_quantity(element.id).quantity["100"]
                local Priceitem = sale:getPriceItem(element.id, 3)
                while inventory:itemCount(element.id) >= 100 and sale:AvailableSpace() > 0 and cpt < element.maxHdv100 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and 100000 or Priceitem
                    sale:SellItem(element.id, 100, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                end
                cpt = get_quantity(element.id).quantity["10"]
                local Priceitem = sale:getPriceItem(element.id, 2)
                while inventory:itemCount(element.id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.maxHdv10 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and 10000 or Priceitem
                    sale:SellItem(element.id, 10, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(element.id) .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                end
                cpt = get_quantity(element.id).quantity["1"]
                local Priceitem = sale:getPriceItem(element.id, 1)
                while inventory:itemCount(element.id) >= 1 and sale:AvailableSpace() > 0 and cpt < element.maxHdv1 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and 1000 or Priceitem
                    sale:SellItem(element.id, 1, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                end
            end
        
            if cptActualiser >= 2 and not hdvActualise and character:kamas() > 150000 then
                global:printSuccess("Actualisation des prix")
                hdvActualise = true
                cptActualiser = 0
                sale:updateAllItems()
            else
                cptActualiser = cptActualiser + 1
            end
    
            if sale:AvailableSpace() == 0 then 
                hdvFull = true 
                global:printError("l'hdv est plein") 
            else
                hdvFull = false
            end
    
            global:leaveDialog()
            global:delay(500)
        end
    end

    if global:isBoss() then
        npc:npcSale()

        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

        global:delay(1000)

        -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
        for _, element in ipairs(TableVente) do
            if get_quantity(element.id).quantity["100"] >= element.maxHdv100 and get_quantity(element.id).quantity["10"] >= element.maxHdv10 and get_quantity(element.id).quantity["1"] >= element.maxHdv1 then
                element.canSell = false
            else
                element.canSell = true
            end
        end
        for i, element in ipairs(TableArea) do
            local compteur = 0
            for _, element2 in ipairs(element.ListeVenteId) do
                for _, element3 in ipairs(TableVente) do -- trouve l'id dans la tableVente
                    if element2 == element3.id then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).total_lots / (element3.maxHdv100 + element3.maxHdv10 + element3.maxHdv1))
                        compteur = compteur + 1
                    end
                end
            end
            element.PourcentageHdv = math.floor(element.PourcentageHdv * 100 / compteur)		
            global:printSuccess(element.PourcentageHdv)
            --element.Stop = element.PourcentageHdv >= 85
        end
    
        global:leaveDialog()
    
        table.sort(TableArea, function(a1, a2) return a1.PourcentageHdv < a2.PourcentageHdv end)
    end


    --[[for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("Groupe " .. character:server()) then
            
        end
    end]]

    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global:deleteMemory("TableArea")
            acc.global:addInMemory("TableArea", TableArea)
        end
        global:deleteMemory("TableArea")
        global:addInMemory("TableArea", TableArea)
    end

    TableArea = global:remember("TableArea")

    --if not global:isBoss() then
        for _, element in ipairs(TableArea) do
            global:printSuccess(element.PourcentageHdv)
        end
    --end
    for _, element in ipairs(TableArea) do
        element.Farmer = false
        for _, element2 in ipairs(element.Zone) do
            element2[3] = false
        end
        element.PourcentageHdv = 0
    end

    for _, element in ipairs(TableArea) do
        if not element.Stop then
            element.Farmer = true
            element.Zone[1][3] = true
            break
        end
    end

    if not DebutDuScript then
        ProcessBank()
    end
    DebutDuScript = false
end

function treatMaps(maps)
    local msg = "[Erreur] - Aucune action à réaliser sur la map"

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end
    if global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc:callScriptFunction("PopoRappel")
        end
        PopoRappel()
    end
end

function WhichArea()
    tradeDone = false
    hdvActualise = false
    for i in ipairs(TableArea) do
        local Zone = TableArea[i].Zone
        for j in ipairs(Zone) do

            if map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) <= #Zone then
                -- si on arrive à la map de changement de sous zone
                MAX_MONSTERS = TableArea[i].MaxMonster
                MIN_MONSTERS = TableArea[i].MinMonster
                Zone[j][3] = false
                Zone[j + 1][3] = true
                return treatMaps(Zone[j + 1][1])

            elseif map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) > #Zone then

                global:printSuccess(i + 1 .. " ème zone")
                CompteurDeath = 0
                -- si on arrive à la map de changement de sous zone et à la fin de la table
                Zone[j][3] = false
                TableArea[i].Farmer = false

                for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                    local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                    
                    if not ZoneSuivante.Stop then

                        if ZoneSuivante.Ecaflipus and not failPortail then
                            GoToDimension()
                        elseif ZoneSuivante.Ecaflipus and failPortail then
                            ZoneSuivante = TableArea[IncrementTable(i + index, #TableArea)]
                        end
                        MAX_MONSTERS = ZoneSuivante.MaxMonster
                        MIN_MONSTERS = ZoneSuivante.MinMonster

                        ZoneSuivante.Farmer = true
                        ZoneSuivante.Zone[1][3] = true
                        return treatMaps(ZoneSuivante.Zone[1][1])

                    end

                end
                -- si on a pas trouvé d'autre zone, on refarm la même

                return treatMaps(Zone[1][1])

            elseif Zone[j][3] and TableArea[i].Farmer then
                global:printSuccess(j)
                local myZone = TableArea[i]

                if myZone.Ecaflipus and not failPortail and (map:currentArea() ~= "Ecaflipus") then
                    GoToDimension()
                elseif myZone.Ecaflipus and failPortail then
                    global:printSuccess(i + 1 .. " ème zone")
                    CompteurDeath = 0
                    -- si on arrive à la map de changement de sous zone et à la fin de la table
                    Zone[j][3] = false
                    TableArea[i].Farmer = false
                    for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                        local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                        
                        if not ZoneSuivante.Stop then
    
                            if ZoneSuivante.Ecaflipus and not failPortail then
                                GoToDimension()
                            elseif ZoneSuivante.Ecaflipus and failPortail then
                                ZoneSuivante = TableArea[IncrementTable(i + index, #TableArea)]
                            end
                            MAX_MONSTERS = ZoneSuivante.MaxMonster
                            MIN_MONSTERS = ZoneSuivante.MinMonster
    
                            ZoneSuivante.Farmer = true
                            ZoneSuivante.Zone[1][3] = true
                            return treatMaps(ZoneSuivante.Zone[1][1])
    
                        end
    
                    end
                else
                    MAX_MONSTERS = myZone.MaxMonster
                    MIN_MONSTERS = myZone.MinMonster

                    return treatMaps(myZone.Zone[j][1])
                end
            end
        end 
    end
end

function EditAlias()
    local Alias = global:thisAccountController():getAlias():split(" ")
    if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
        global:editAlias("Team 1 " .. character:serverName() .. " Combat", true)
    else
        global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. " Combat", true)
    end
end

function move()

    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global:deleteMemory("GoToBotBank")
            acc.global:addInMemory("GoToBotBank", character:kamas() > 1000000)
        end
        global:deleteMemory("GoToBotBank")
        global:addInMemory("GoToBotBank", character:kamas() > 1000000)
    end

    GoToBotBank = global:remember("GoToBotBank")

    if GoToBotBank then
        if not Rappel then
            Rappel = true
            PopoRappel()
        end
        return GoToAstrubBank
    end

	if character:bonusPackExpiration() == 0 then
		character:getBonusPack(1)
	end
    
    if DebutDuScript then
        ProcessSell()
    end

    EditAlias()

    antiModo()

    return WhichArea()
end

function ProcessBank()
    inventory:openBank()

    if exchange:storageKamas() > 0 then
        global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
        exchange:getKamas(0)
        global:delay(500)
    elseif exchange:storageKamas() == 0 then
        global:printError("Il n'y a pas de kamas en banque")
        global:delay(500)
    end

    if global:isBoss() then
        if hdvFull then
            exchange:putAllItems()
        else
            for _, element in ipairs(TableVente) do
                if inventory:itemCount(element.id) > 0 then
                    exchange:putItem(element.id, inventory:itemCount(element.id))
                end
            end
        end
        if not hdvFull then
            local itemToSell = {}
            for _, element in ipairs(TableVente) do
                local podsAvailable = inventory:podsMax() - inventory:pods()
                local TotalMax = element.maxHdv100 * 100 + element.maxHdv10 * 10 + element.maxHdv1
                local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.id)))
                if ((element.maxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.maxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.canSell then
                    local element = {id = element.id, quantity = QuantiteAPrendre}
                    table.insert(itemToSell, element)
                end
            end
            if itemToSell ~= nil and #itemToSell > 0 then
                for _, element in ipairs(itemToSell) do
                    exchange:getItem(element.id, element.quantity)
                end
                ProcessSell()
            end
        end
    end

    hdvFull = false

	global:leaveDialog()
    global:editInMemory("bank()", false)
end

function bank()
    EditAlias()

    global:editInMemory("bank()", true)

    if not tradeDone and global:isBoss() then   

        local TeamAcount = global:thisAccountController():getTeamAccounts()

        for _, acc in ipairs(TeamAcount) do
            acc.global:setPrivate(false)
            while not exchange:launchExchangeWithPlayer(acc.character:id()) do
                global:printMessage("Attente de l'acceptation de l'échange (2 secondes)")
                global:delay(2000)
            end
            
            developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
            exchange:ready()

            acc.global:setPrivate(true)
        end
        tradeDone = true
    end

    if global:isBoss() then
        ProcessSell()
        ProcessBank()
    end
end

function phenix()
    return {
        {map = "-18,-57", custom = function ()
            if global:isBoss() then
                team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(172)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(172)
                PopoRappel()
            end
        end},
        {map = "-11,16", path = "top"},
        {map = "-11,15", path = "top"},
        {map = "-11,14", path = "top"},
        {map = "-11,13", path = "right"},
        {map = "64489222", custom = function ()
            if global:isBoss() then
                team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(354)
                    acc.mount:toggleRiding()
                    acc.map:door(218)
                end
                map:door(354)
                mount:toggleRiding()
                map:door(218)
            end
        end},
        {map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() 
            if global:isBoss() then
                team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(184)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(184)
                PopoRappel()
            end
        end},
    }
end