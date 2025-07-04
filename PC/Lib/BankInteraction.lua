function isBotBankAvailable()
    local json = openFile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. character:server() .. "\\botBankAvailability.json")
    if not json then
        global:printError("Le fichier botBankAvailability.json n'existe pas pour le serveur " .. character:server())
        global:finishScript()
    end
    return not json and false or not json[1].connected
end

function setBotBankConnected(server, bool)
    local jsonMemory = openFile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. server .. "\\botBankAvailability.json")

    if not jsonMemory then
        jsonMemory = {
            {
                connected = bool,
                lastUpdate = getCurrentDateTime()
            }
        }
    else
        jsonMemory[1].connected = bool
        jsonMemory[1].lastUpdate = getCurrentDateTime()
        jsonMemory[1].doneBy = global:thisAccountController():getAlias()
    end

    local new_content = json.encode(jsonMemory)
    -- Écrire les modifications dans le fichier JSON

    global:printMessage("json update : bot bank connected mis à :")
    global:printMessage(bool)

    local file = io.open("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. server .. "\\botBankAvailability.json", "w")

    file:write(new_content)
    file:close()
end

function resetBotBankAvailability(force)
    debug("reset bot connected")
    local servers = merge(SERVERS_MULTI, SERVERS_MONO)
    for _, server in ipairs(servers) do
        debug(server)
        if force then
                global:printSuccess(server)
            setBotBankConnected(server, false)
        else
            local jsonMemory = openFile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. server .. "\\botBankAvailability.json")
            if isDateExceeded(jsonMemory[1].lastUpdate) and jsonMemory[1].connected then
                setBotBankConnected(server, false)
            end
        end
    end
end

function forwardKamasBotBankIfNeeded(givingTriggerValue, minKamas, maxWaitingTime, minRetryHours)
    
    if global:remember("failed") then
        if not global:remember("retryTimestamp") then global:addInMemory("retryTimestamp", os.time()) end

        if secondsToHours(os.time() - global:remember("retryTimestamp")) >= minRetryHours then
            rerollVar()
            global:editInMemory("retryTimestamp", 0)
        end
    end
    if character:kamas() >= givingTriggerValue and not global:remember("failed") then
        givingMode = true
    end

    if givingMode then

        if not connected then

            while not isBotBankAvailable() do
                global:printError("Le bot bank est connecté sur une autre instance, on attend 10 secondes")
                global:delay(10000)
            end

            receiver = connectGiver(maxWaitingTime, "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\bot_banque.lua")

            if cannotConnect or not botFound then
                rerollVar()
                if botFound then
                    receiver:disconnect()
                end
                global:editInMemory("retryTimestamp", os.time())
                global:addInMemory("failed", true)
				cannotConnect = false
                global:restartScript(true)
            else
				connected = true
            end
        end

        if not global:remember("failed") then
            if not movingPrinted then
                global:printMessage("Déplacement jusqu'à la banque d'Astrub")
                movingPrinted = true
            end
            debug(getCurrentAreaName())
            if not getCurrentAreaName():find("Astrub") then
                if map:currentMapId() == tonumber(BANK_MAPS.idHavenbag) then
                    return map:changeMap(BANK_MAPS.zAstrub)
                else
                    return map:changeMap("havenbag")
                end
            else
                if map:currentMapId() ~= tonumber(BANK_MAPS.bankAstrubInt) then
                    return debugMoveToward(tonumber(BANK_MAPS.bankAstrubInt))
                else
                    launchExchangeAndGive(minKamas, maxWaitingTime)
                end
            end
        end
    end

end

function take50kIfNeeded(kamasTriggerValuer, maxWaitingTime, minRetryHours)
    if global:remember("failedTakeKamas") then
        global:deleteMemory("failedTakeKamas")
        global:printError("On a pas pu faire l'echange avec le bot bank et on a plus de kamas, on retente dans " .. minRetryHours .. " heures")
        customReconnect(minRetryHours * 60)
    end
    if character:kamas() < kamasTriggerValuer then
        go = true
    end

    if go then

        if not connected then

            while not isBotBankAvailable() do
                global:printError("Le bot bank est connecté sur une autre instance, on attend 10 secondes")
                global:delay(10000)
            end

            receiver = connectGiver(maxWaitingTime, "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\give-50kk.lua")

            if cannotConnect or not botFound then
                rerollVar()
                if botFound then
                    receiver:disconnect()
                end
                global:addInMemory("failedTakeKamas", true)
				cannotConnect = false
                global:restartScript(true)
            else
				connected = true
            end
        end

        if not global:remember("failedTakeKamas") then
            if not movingPrinted then
                global:printMessage("Déplacement jusqu'à la banque d'Astrub")
                movingPrinted = true
            end
            debug(getCurrentAreaName())
            if not getCurrentAreaName():find("Astrub") then
                if map:currentMapId() == tonumber(BANK_MAPS.idHavenbag) then
                    return map:changeMap(BANK_MAPS.zAstrub)
                else
                    return map:changeMap("havenbag")
                end
            else
                if map:currentMapId() ~= tonumber(BANK_MAPS.bankAstrubInt) then
                    return debugMoveToward(tonumber(BANK_MAPS.bankAstrubInt))
                else
                    launchExchangeAndTake50k(maxWaitingTime)
                end
            end
        end
    end
end


function connectGiver(maxWaitingTime, pathScriptBotBank)
    pathScriptBotBank = pathScriptBotBank or "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\give-kamas.lua"
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank_" .. character:server():lower()) then
            botFound = true
            if not acc:isAccountFullyConnected() then

                setBotBankConnected(character:server(), true)
                acc:connect()


                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1


                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        global:printError("Bot banque non-connecté après " .. maxWaitingTime .. " secondes, reprise du trajet")
                        setBotBankConnected(character:server(), false)
                        cannotConnect = true
	
                        return acc
                    end
                end

				acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\configBank.xml")

                acc:loadScript(pathScriptBotBank)				

                acc:exchangeListen(false)
                acc.global():setPrivate(false)
                acc:startScript()
                return acc
            else
                debug(acc:getAlias() .. " est déjà connecté")
                debug(acc.character():id())
                acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\configBank.xml")
                acc:loadScript(pathScriptBotBank)				
                acc:startScript()
                return acc
            end
        end
    end
    botFound = false
end

function connectGiver50k(maxWaitingTime)
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank_" .. character:server():lower()) then
            botFound = true
            if not acc:isAccountFullyConnected() then

                setBotBankConnected(character:server(), true)
                acc:connect()


                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1


                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        global:printError("Bot banque non-connecté après " .. maxWaitingTime .. " secondes, reprise du trajet")
                        setBotBankConnected(character:server(), false)
                        cannotConnect = true
	
                        return acc
                    end
                end

                acc:loadConfig("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Configs\\configBank.xml")
                acc:loadScript("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\give-50kk.lua")

                acc:exchangeListen(false)
                acc.global():setPrivate(false)
                acc:startScript()
                return acc
            else
                debug(acc:getAlias() .. " est déjà connecté")
                debug(acc.character():id())
                return acc
            end
        end
    end
    botFound = false
end

function rerollVar()
    if global:remember("failed") then
        global:deleteMemory("failed")
    end

    toGive, connected, movingPrinted, givingMode = 0, nil, nil, nil
end 

function waitBotIsOnAstrubBank(botBank, maxWaitingTime)
    local safetyCount = 0
    maxWaitingTime = maxWaitingTime or 60
    global:printMessage("On attends que le bot bank soit arrivé a la banque")

    while not botBank.map():onMap(BANK_MAPS.bankAstrubInt) and safetyCount < maxWaitingTime do
        local accounts = snowbotController:getLoadedAccounts()
        for _, account in ipairs(accounts) do
            if account.character():id() == botBank.character():id() then
                botBank = account
            end
        end
        safetyCount = safetyCount + 5
        global:delay(5000)
    end

    return safetyCount < maxWaitingTime
end

function launchExchangeSafely(id, maxWaitingTime)
    maxWaitingTime = maxWaitingTime or 60
    local safetyCount = 0

    while not exchange:launchExchangeWithPlayer(id) and safetyCount < maxWaitingTime do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
        randomDelay()
		safetyCount = safetyCount + 5
        global:leaveDialog()
    end
    return safetyCount < maxWaitingTime
end

function launchExchangeAndGive(minKamas, maxWaitingTime)
    local id = receiver.character():id()
    receiver:exchangeListen(false)

    
    if not waitBotIsOnAstrubBank(receiver, maxWaitingTime) then
        global:printError("Bot banque n'est toujours pas à astrub après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
		receiver:disconnect()
		return
    end

    global:printSuccess("On attend qu'il ait fini son interaction avec la bank")
    global:delay(math.random(20000, 30000))

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

    if not launchExchangeSafely(id, maxWaitingTime) then
        global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
		receiver:disconnect()
		return
    end

    local toGive = (character:kamas() - minKamas) > 100000 and (character:kamas() - minKamas) or 1

    global:printSuccess("On donne " .. toGive .. " kamas")
    exchange:putKamas(toGive)

    -- on donne des ressources random
    local giveRessources = math.random()
    if giveRessources < 0.5 then
        local content = inventory:inventoryContent()

        -- On filtre les objets qu'on a le droit de donner
        local eligibleItems = {}
        for _, item in ipairs(content) do
            if not IsItem(item.objectGID) and item.position == 63 then
                table.insert(eligibleItems, item)
            end
        end

        local nbResourcesToGive = math.random(0, math.min(3, #eligibleItems))
        if nbResourcesToGive > 0 then
            global:printMessage("On va donner " .. nbResourcesToGive .. " ressources")
            for i = 1, nbResourcesToGive do
                local random = math.random(1, #eligibleItems)
                local id = eligibleItems[random].objectGID
                local quantity = math.random(1, math.min(inventory:itemCount(id), 3))
                exchange:putItem(id, quantity)
                global:printSuccess("Ressource donnée : " .. inventory:itemNameId(id) .. " x" .. quantity)
            end
        else
            global:printMessage("Aucune ressource éligible à donner")
        end
    else
        global:printMessage("On ne donne pas de ressources")
    end

    global:delay(15000, 20000)

    global:printMessage("On confirm l'échange")
    exchange:ready()

    global:printSuccess("Kamas transférés. Reprise du trajet")
	global:delay(math.random(5000, 10000))

    rerollVar()
    receiver:disconnect()
    setBotBankConnected(character:server(), false)
    while receiver:isAccountConnected() do
        global:printError("Le bot banque n'a pas pu se déconnecter, on attend 5 seconde")
        global:delay(5000)
        receiver:disconnect()
    end

    global:restartScript(true)
end


function launchExchangeAndTake50k(maxWaitingTime)
    local id = receiver.character():id()
    receiver:exchangeListen(false)

    
    if not waitBotIsOnAstrubBank(receiver, maxWaitingTime) then
        global:printError("Bot banque n'est toujours pas à astrub après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
		receiver:disconnect()
		return
    end

    global:printSuccess("On attend qu'il ait fini son interaction avec la bank")
    global:delay(math.random(20000, 30000))

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

    if not launchExchangeSafely(id, maxWaitingTime) then
        global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
		receiver:disconnect()
		return
    end


    -- on donne des ressources random
    local giveRessources = math.random()
    if giveRessources < 0.5 then
        local content = inventory:inventoryContent()

        -- On filtre les objets qu'on a le droit de donner
        local eligibleItems = {}
        for _, item in ipairs(content) do
            if not IsItem(item.objectGID) then
                table.insert(eligibleItems, item)
            end
        end

        local nbResourcesToGive = math.random(0, math.min(3, #eligibleItems))
        if nbResourcesToGive > 0 then
            global:printMessage("On va donner " .. nbResourcesToGive .. " ressources")
            for i = 1, nbResourcesToGive do
                local random = math.random(1, #eligibleItems)
                local id = eligibleItems[random].objectGID
                local quantity = math.random(1, math.min(inventory:itemCount(id), 3))
                exchange:putItem(id, quantity)
                global:printSuccess("Ressource donnée : " .. inventory:itemNameId(id) .. " x" .. quantity)
            end
        else
            global:printMessage("Aucune ressource éligible à donner")
        end
    else
        global:printMessage("On ne donne pas de ressources")
    end

    global:delay(math.random(7500, 15000))
    randomDelay()

    global:printMessage("On confirm l'échange")
    exchange:ready()

    global:printSuccess("Kamas transférés. Reprise du trajet")
	global:delay(math.random(5000, 10000))

    rerollVar()
    receiver:disconnect()
    setBotBankConnected(character:server(), false)
    while receiver:isAccountConnected() do
        global:printError("Le bot banque n'a pas pu se déconnecter, on attend 5 seconde")
        global:delay(5000)
        receiver:disconnect()
    end

    global:restartScript(true)
end

function isAccountKnown(id)
    local accounts = snowbotController:getLoadedAccounts()
    for _, account in ipairs(accounts) do
        if account.character():id() == id then
            return true
        end
    end
    return false
end


function submitKamasOrder(amount)
    
    local filePath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. character:server() .. "\\bank-orders.json"

    jsonMemory = {
        {
            id = character:id(),
            alias = myAlias,
            kamasAmount = amount
        }
    }
    writeFile(filePath, jsonMemory)
end

function fetchKamasOrders()
    local filePath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. character:server() .. "\\bank-orders.json"
    local jsonMemory = openFile(filePath)

    -- Ensure jsonMemory[1] exists and is a table
    if type(jsonMemory[1]) ~= "table" then
        return {} -- no orders found
    end

    -- Return the list of orders

    return jsonMemory[1]
end

function deleteKamasOrder(characterId)
    local filePath = "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Temp\\" .. character:server() .. "\\bank-orders.json"
    local jsonMemory = openFile(filePath)

    -- Ensure jsonMemory[1] exists and is a table
    if type(jsonMemory) ~= "table" then
        global:printError("Aucune commande trouvée pour le personnage " .. characterId)
        return -- nothing to delete
    end

    -- Remove all matching entries
    for i = #jsonMemory, 1, -1 do
        if tostring(jsonMemory[i].id) == tostring(characterId) then
            table.remove(jsonMemory, i)
        end
    end

    writeFile(filePath, jsonMemory)
end


function goAstrubBank(inBankCallback)
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end

    if not map:onMap(BANK_MAPS.bankAstrubInt) then
        return treatMaps(GO_BANK_ASTRUB)
    end
    global:printSuccess("On est arrivé a la banque d'astrub")
    if inBankCallback then
        return inBankCallback()
    end
end