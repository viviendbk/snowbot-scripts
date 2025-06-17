function isBotBankAvailable()
    local json = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. character:server() .. "\\botBankAvailability.json")
    if not json then
        global:printError("Le fichier botBankAvailability.json n'existe pas pour le serveur " .. character:server())
        global:finishScript()
    end
    return not json and false or not json[1].connected
end

function setBotBankConnected(server, bool)
    local jsonMemory = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. server .. "\\botBankAvailability.json")

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
    end

    local new_content = json.encode(jsonMemory)
    -- Écrire les modifications dans le fichier JSON

    local file = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. server .. "\\botBankAvailability.json", "w")

    file:write(new_content)
    file:close()
end

function resetBotBankAvailability(force)
    local servers = merge(SERVERS_MULTI, SERVERS_MONO)
    for _, server in ipairs(servers) do
        if force then
            setBotBankConnected(server, false)
        else
            local jsonMemory = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. server .. "\\botBankAvailability.json")
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

            receiver = connectReceiver(maxWaitingTime)

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
                            debug("ok")
                if map:currentMapId() == tonumber(BANK_MAPS.idHavenbag) then
                    return map:changeMap(BANK_MAPS.zAstrub)
                else
                    return map:changeMap("havenbag")
                end
            else
                            debug("ok2")
                if map:currentMapId() ~= tonumber(BANK_MAPS.bankAstrubInt) then
                    return debugMoveToward(tonumber(BANK_MAPS.bankAstrubInt))
                else
                    launchExchangeAndGive(minKamas, maxWaitingTime)
                end
            end
        end
    end

end

function connectReceiver(maxWaitingTime)
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
                global:printSuccess("ok")

				acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml")
                acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\bot_banque.lua")				
                acc:startScript()
                return acc
            else
                return acc
            end
        end
    end
    botFound = false
end

function connectGiver(maxWaitingTime)
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

				acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml")
                if global:thisAccountController():getAlias():find("LvlUp") then
                    giver:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas-and-stuff.lua")
                else
                    acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\give-kamas.lua")				
                end

                acc:exchangeListen(true)
                acc.global():setPrivate(false)
                acc:startScript()
                return acc
            else
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
    while not botBank.map:onMap(BANK_MAPS.bankAstrubInt) and safetyCount < maxWaitingTime do
        local accounts = snowbotcontroller:getLoadedAccounts()
        for _, account in ipairs(accounts) do
            if account.character:id() == botBank.character():id() then
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
    end
    return safetyCount < maxWaitingTime
end

function launchExchangeAndGive(minKamas, maxWaitingTime)
    local id = receiver.character():id()
    receiver:exchangeListen(false)
    receiver:exchangeListen(true)
    
    if not waitBotIsOnAstrubBank(receiver, maxWaitingTime) then
        global:printError("Bot banque n'est toujours pas à astrub après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
        setBotBankConnected(character:server(), false)
		receiver:disconnect()
		return
    end

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

    if not launchExchangeSafely(id, maxWaitingTime) then
        global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
		receiver:disconnect()
		return
    end


    local toGive = (character:kamas() - minKamas) > 100000 and (character:kamas() - minKamas) or 1

    randomDelay()
    exchange:putKamas(toGive)
    global:delay(math.random(7500, 15000))
    randomDelay()
    exchange:ready()

    global:delay(3000)

    global:printSuccess("Kamas transférés. Reprise du trajet")
	global:delay(5000)
	receiver:reloadScript()
	receiver:startScript()
	global:delay(10000)
    rerollVar()
    receiver:disconnect()
    setBotBankConnected(character:server(), false)

    global:restartScript(true)
end

function isAccountKnown(id)
    local accounts = snowbotcontroller:getLoadedAccounts()
    for _, account in ipairs(accounts) do
        if account.character():id() == id then
            return true
        end
    end
    return false
end


function submitKamasOrder(amount)
    local filePath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. character:server() .. "\\bank-orders.json"
    local jsonMemory = openFile(filePath)

    -- Ensure jsonMemory[1] exists and is a table
    if type(jsonMemory[1]) ~= "table" then
        jsonMemory[1] = {}
    end

    -- Remove existing entry with the same id
    for i = #jsonMemory[1], 1, -1 do
        if jsonMemory[1][i].id == character:id() then
            table.remove(jsonMemory[1], i)
        end
    end

    -- Insert the new order
    table.insert(jsonMemory[1], {
        id = character:id(),
        alias = myAlias,
        kAmount = amount
    })

    writeFile(filePath, jsonMemory)
end

function deleteKamasOrder(characterId)
    local filePath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. character:server() .. "\\bank-orders.json"
    local jsonMemory = openFile(filePath)

    -- Ensure jsonMemory[1] exists and is a table
    if type(jsonMemory[1]) ~= "table" then
        return -- nothing to delete
    end

    -- Remove all matching entries
    for i = #jsonMemory[1], 1, -1 do
        if jsonMemory[1][i].id == characterId then
            table.remove(jsonMemory[1], i)
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
        treatMaps(GO_BANK_ASTRUB)
    end
    global:printSuccess("On est arrivé a la banque d'astrub")
    if inBankCallback then
        return inBankCallback()
    end
end