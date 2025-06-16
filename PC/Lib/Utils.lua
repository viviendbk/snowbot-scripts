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


function merge(t1, t2)
    local result = {}
    for i = 1, #t1 do table.insert(result, t1[i]) end
    for i = 1, #t2 do table.insert(result, t2[i]) end
    return result
end

function customReconnect(minutes)
    local currentTime = os.time()
    local reconnectTime = currentTime + (minutes * 60)

    global:printMessage("Le script sera en pause jusqu'à " .. os.date("%Y-%m-%d %H:%M:%S", reconnectTime) .. ". Déconnexion du compte.")
    global:editAlias(global:thisAccountController():getAlias() .. "Reconnect at " .. os.date("%Y-%m-%d %H:%M:%S", reconnectTime), false)
    global:disconnect()
end

function handleDisconnection()
    local currentTime = os.time()

    local nextDisconnection = global:remember("nextDisconnection")

    if not nextDisconnection then
        local random = math.random()
        local minutesDisconnection = 0

        if random < 0.02 then
            minutesDisconnection = math.random(200, 300)
        elseif random < 0.03 then
            minutesDisconnection = math.random(30, 45)
        elseif random < 0.15 then
            minutesDisconnection = math.random(70, 110)    
        elseif random < 0.35 then
            minutesDisconnection = math.random(100, 130)          
        elseif random < 0.65 then
            minutesDisconnection = math.random(130, 160)    
        else
            minutesDisconnection = math.random(150, 210)   
        end
        global:addInMemory("nextDisconnection", currentTime + minutesDisconnection * 60)
        global:printMessage("Prochaine déconnexion à " .. os.date("%Y-%m-%d %H:%M:%S", currentTime + minutesDisconnection * 60) .. ".")
        return
    end

    -- Si l'horaire est dépassé de plus de 5 minutes (300 secondes), on planifie une nouvelle déconnexion
    if currentTime > (nextDisconnection + 300) then
        local random = math.random()
        local minutesDisconnection = 0

        if random < 0.02 then
            minutesDisconnection = math.random(200, 300)
        elseif random < 0.03 then
            minutesDisconnection = math.random(30, 45)
        elseif random < 0.15 then
            minutesDisconnection = math.random(70, 110)    
        elseif random < 0.35 then
            minutesDisconnection = math.random(100, 130)          
        elseif random < 0.65 then
            minutesDisconnection = math.random(130, 160)    
        else
            minutesDisconnection = math.random(150, 210)   
        end

        global:editInMemory("nextDisconnection", currentTime + minutesDisconnection * 60)
        global:printMessage("Prochaine déconnexion à " .. os.date("%Y-%m-%d %H:%M:%S", currentTime + minutesDisconnection * 60) .. ".")
        return
    end

    -- si l'horaire est dépassé de moins de 5 minutes, on se déconnecte
    if currentTime >= nextDisconnection then
        global:printError("Le script est en pause jusqu'à " .. os.date("%Y-%m-%d %H:%M:%S", nextDisconnection) .. ". Déconnexion du compte.")
        local random = math.random()
        local minutesDisconnection = 0
        if random < 0.05 then
            -- Rare : pause longue
            minutesDisconnection = math.random(60, 120)
        elseif random < 0.15 then
            -- Moins fréquent : pause plus courte
            minutesDisconnection = math.random(5, 15)
        elseif random < 0.30 then
            -- Courte pause
            minutesDisconnection = math.random(10, 20)
        elseif random < 0.60 then
            -- Moyenne pause
            minutesDisconnection = math.random(20, 40)
        elseif random < 0.90 then
            -- Normale : autour de 30 minutes
            minutesDisconnection = math.random(25, 40)
        else
            -- Occasionnelle longue pause
            minutesDisconnection = math.random(40, 60)
        end
        global:deleteMemory("nextDisconnection")
        customReconnect(minutesDisconnection)
    end
end


function IsInTable(table, element)
    for _, x in ipairs(table) do
        if x == element then
            return true
        end
    end
    return false
end

function truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    if string.len(nbr) < 4 then
        return nbr
    end
    return nbr:sub(1, nbr:find("%p") + size)
end

function truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return truncate(amount, 0) 
end

function getRemainingSubscription(inDay, acc)
    local ts = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate

    local now = os.time()
    
    local diff = ts - now         -- différence en secondes

    if diff <= 0 then
        return 0                     -- la date est dépassée ou c'est le moment même
    end
    if inDay then
        return math.floor(diff / 86400) -- 86400 s = 1 jour
    end
    return math.floor(diff / 3600) -- 3600 s = 1 heure
end

function getRemainingHoursSubscription(acc)
    local ts = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate
    local now = os.time()
    local diff = ts - now         -- différence en secondes
    if diff <= 0 then
        return 0                     -- la date est dépassée ou c'est le moment même
    end
    return math.floor(diff / 3600) -- 3600 s = 1 heure
end


function ConsoleRead(acc, string)
    local lines = acc.global():consoleLines() or {}
    if lines then
        for i = 1, #lines do
            if lines[i]:find(string) then return true end
        end
    end
    return false
end

function Contain(list, element)
	for _, x in ipairs(list) do
		if x == element then
			return true
		end
	end
	return false
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

function getDate()
    local date = os.date("*t") -- récupère la date actuelle
    return string.format("%02d/%02d/%04d", date.day, date.month, date.year)
end

function getCurrentTime()
    local current_time = os.date("*t")  -- Get current date and time
    local hour = string.format("%02d", current_time.hour)  -- Format hour to ensure two digits
    local minute = string.format("%02d", current_time.min) -- Format minute to ensure two digits
    return hour .. ":" .. minute
end

function getCurrentDateTime()
    local currentDateTime = os.date("*t")
    
    local day = string.format("%02d", currentDateTime.day)
    local month = string.format("%02d", currentDateTime.month)
    local year = string.format("%04d", currentDateTime.year)
    local hour = string.format("%02d", currentDateTime.hour)
    local minute = string.format("%02d", currentDateTime.min)

    return day .. ":" .. month .. ":" .. year .. " " .. hour .. ":" .. minute
end

function isDateExceeded(dateString)
    -- Parse the given date string
    local day, month, year, hour, minute = dateString:match("(%d+):(%d+):(%d+) (%d+):(%d+)")
    local givenDateTime = os.time({year=year, month=month, day=day, hour=hour, min=minute})

    -- Get the current date and time
    local currentDateTime = os.time()

    -- Calculate the difference in seconds
    local differenceInSeconds = math.abs(currentDateTime - givenDateTime)

    -- Check if the difference is greater than or equal to 15 minutes (900 seconds)
    if differenceInSeconds >= 900 then
        return true
    else
        return false
    end
end

function isDateXDaysLater(date, time, x)
    -- Splitting date into day, month, and year
    local day, month, year = date:match("(%d+)/(%d+)/(%d+)")
    
    -- Splitting time into hours and minutes
    local hour, minute = time:match("(%d+):(%d+)")
    
    -- Converting day, month, year, hour, and minute into integers
    day, month, year, hour, minute = tonumber(day), tonumber(month), tonumber(year), tonumber(hour), tonumber(minute)
    
    -- Getting the current date and time
    local currentDate = os.date("*t")
    
    -- Creating a table for the specified date and time
    local specifiedDate = {
        year = year,
        month = month,
        day = day,
        hour = hour,
        min = minute,
        sec = 0
    }
    
    -- Calculating the timestamp for x days later
    specifiedDate.day = specifiedDate.day + x
    local specifiedTimestamp = os.time(specifiedDate)
    
    -- Calculating the timestamp for the current date
    local currentTimestamp = os.time(currentDate)
    
    -- Comparing timestamps
    return specifiedTimestamp <= currentTimestamp
end

function isXDaysLater(dateString, x)
    -- Conversion de la date en une table de valeurs
    local day, month, year = dateString:match("(%d+)/(%d+)/(%d+)")
    local dateTable = {day = tonumber(day), month = tonumber(month), year = tonumber(year)}
  
    -- Calcul de la date x jours plus tard
    local futureDate = os.time(dateTable) + x * 24 * 60 * 60
  
    -- Comparaison avec la date actuelle
    return futureDate <= os.time()
end

function compareDates(date1, date2)
    local day1, month1, year1 = date1:match("(%d+)/(%d+)/(%d+)")
    local day2, month2, year2 = date2:match("(%d+)/(%d+)/(%d+)")
    
    day1, month1, year1 = tonumber(day1), tonumber(month1), tonumber(year1)
    day2, month2, year2 = tonumber(day2), tonumber(month2), tonumber(year2)
    
    if year2 > year1 then
        return true
    elseif year2 == year1 then
        if month2 > month1 then
            return true
        elseif month2 == month1 then
            return day2 > day1
        end
    end
    
    return false
end

function extractDateTime(text)
    -- Recherche une date et heure au format "YYYY-MM-DD HH:MM:SS"
    local dateTime = text:match("(%d%d%d%d%-%d%d%-%d%d %d%d:%d%d:%d%d)")
    return dateTime
end

function compareDateTime(d1, d2)

    local function parseDateTime(datetime, fallbackDate)
        -- Format complet : "YYYY-MM-DD HH:MM:SS"
        local y, m, d, h, min, s = datetime:match("^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)$")
        if y then
            return os.time({
                year = tonumber(y),
                month = tonumber(m),
                day = tonumber(d),
                hour = tonumber(h),
                min = tonumber(min),
                sec = tonumber(s)
            })
        end

        -- Format heure complète : "HH:MM:SS"
        h, min, s = datetime:match("^(%d%d):(%d%d):(%d%d)$")
        if h then
            return os.time({
                year = fallbackDate.year,
                month = fallbackDate.month,
                day = fallbackDate.day,
                hour = tonumber(h),
                min = tonumber(min),
                sec = tonumber(s)
            })
        end

        -- Format heure courte : "HH:MM"
        h, min = datetime:match("^(%d%d):(%d%d)$")
        if h then
            return os.time({
                year = fallbackDate.year,
                month = fallbackDate.month,
                day = fallbackDate.day,
                hour = tonumber(h),
                min = tonumber(min),
                sec = 0
            })
        end

        error("Format de date invalide : " .. tostring(datetime))
    end

    -- On extrait la date de référence à partir du premier format complet disponible
    local fallbackDate = nil
    for _, dt in ipairs({d1, d2}) do
        local y, m, d = dt:match("^(%d%d%d%d)%-(%d%d)%-(%d%d)")
        if y then
            fallbackDate = {
                year = tonumber(y),
                month = tonumber(m),
                day = tonumber(d)
            }
            break
        end
    end

    if not fallbackDate then
        error("Impossible de déterminer une date de référence parmi d1 et d2")
    end

    local t1 = parseDateTime(d1, fallbackDate)
    local t2 = parseDateTime(d2, fallbackDate)
    return t1 - t2 -- positif : d1 après d2, négatif : d1 avant d2
end

function addSecondsToDateTime(datetime, secondsToAdd)
    local year, month, day, hour, min, sec = datetime:match("^(%d%d%d%d)%-(%d%d)%-(%d%d) (%d%d):(%d%d):(%d%d)$")
    if year and month and day and hour and min and sec then
        local timestamp = os.time({
            year = tonumber(year),
            month = tonumber(month),
            day = tonumber(day),
            hour = tonumber(hour),
            min = tonumber(min),
            sec = tonumber(sec)
        })

        local newTimestamp = timestamp + secondsToAdd
        return os.date("%Y-%m-%d %H:%M:%S", newTimestamp)
    else
        error("Format de date invalide : " .. tostring(datetime))
    end
end

function comparehHour(h1, h2)
    local function to_seconds(hms)
        local h, m, s = hms:match("^(%d%d):(%d%d):(%d%d)$")
        if h and m and s then
            return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
        end

        h, m = hms:match("^(%d%d):(%d%d)$")
        if h and m then
            return tonumber(h) * 3600 + tonumber(m) * 60
        end

        error("Format d'heure invalide : " .. tostring(hms))
    end

    return to_seconds(h1) >= to_seconds(h2)
end

function NbDaysBetweenTodayAnd(date)
    if date == "" then
        return 0
    end
    -- Séparation de la date en jour, mois et année
    local jour, mois, annee = date:match("(%d+)/(%d+)/(%d+)")
    
    -- Calcul du nombre de secondes entre les deux dates
    local t1 = os.time({year=tonumber(annee), month=tonumber(mois), day=tonumber(jour)})
    local t2 = os.time()
    local diff_secs = os.difftime(t2, t1)
    
    -- Calcul du nombre de jours en arrondissant à l'entier inférieur
    local diff_jours = math.floor(diff_secs / 86400)
    
    return diff_jours
end

function shuffleTable(tbl)
    math.randomseed(os.time()) -- initialiser le générateur de nombres aléatoires
    for j = 1, math.random(1, 5) do
        for i = #tbl, 2, -1 do
            local j = math.random(i)
            tbl[i], tbl[j] = tbl[j], tbl[i]
        end
    end
end

function CopyTable(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = CopyTable(value) -- Appel récursif pour copier les sous-tables
        else
            copy[key] = value
        end
    end
    return copy
end

function randomDelay()
	local random = math.random()
	if random < 0.05 then
		global:delay(math.random(8000, 10000))
	elseif random < 0.25 then
		global:delay(math.random(2500, 5000))
	elseif random < 0.5 then
		global:delay(math.random(1000, 2500))
	else
		global:delay(math.random(100, 1000))
	end
end

function mapDelay()
	local random = math.random()
    if random < 0.005 then
        global:printMessage("gros délais")
        global:delay(math.random(30000, 57000))
    elseif random < 0.05 then
		global:delay(math.random(7000, 11000))
	elseif random < 0.25 then
		global:delay(math.random(1000, 3000))
	elseif random < 0.5 then
		global:delay(math.random(300, 1000))
	else
		global:delay(math.random(100, 500))
	end
end

function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end


--- interaction bot bank ---

bankMaps = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

retryTimestamp = 0
givingMode = false
cannotConnect = false
botFound = false
connected = false


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
    local servers = merge(ServersMulti, ServersMono)
    for _, server in ipairs(servers) do
        global:printSuccess(server)
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

function writeToJsonFile(path, content)
    local jsonContent = json.encode(content)

    local file = io.open(path, "w")

    file:write(jsonContent)

    file:close()
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
                if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
                    return map:changeMap(bankMaps.zAstrub)
                else
                    return map:changeMap("havenbag")
                end
            else
                            debug("ok2")
                if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
                    return debugMoveToward(tonumber(bankMaps.bankAstrubInt))
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

function launchExchangeAndGive(minKamas, maxWaitingTime)
    local id = receiver.character():id()
    receiver:exchangeListen(false)
    receiver:exchangeListen(true)
    
    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

	local safetyCount = 0

    while not exchange:launchExchangeWithPlayer(id) and safetyCount < 70 do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
        randomDelay()
		safetyCount = safetyCount + 5
    end

	if safetyCount >= 70 then
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

function secondsToHours(time)
    return time / 60 / 60
end

function isAccountController(alias)
    return alias:find("controller") or alias:find("contrôleur")
end

function debug(msg)
    global:printSuccess("DEBUG: " .. msg)
end

function canReconnect(Alias)
    if not Alias:find("Reconnect") then
        return true
    end

    local reconnectTime = extractDateTime(Alias)
    if not reconnectTime then
        debug("impossible de trouver l'heure de reconnexion dans l'alias: " .. Alias)
        return false
    end
    -- Vérification si l'heure actuelle dépasse celle de reconnexion
    local currentTime = os.date("%Y-%m-%d %H:%M:%S")
    if compareDateTime(currentTime, reconnectTime) >= 0 then
        global:printSuccess(Alias .. ": L'heure actuelle " .. currentTime .. " est supérieure ou égale à l'heure de reconnexion " .. reconnectTime)
        return true
    end
end


function upgradeCharacteristics(vitality, strength, wisdom, intelligence, chance, agility)
    local message = developer:createMessage("CharacterCharacteristicUpgradeRequest")
    if message then
        message.vitality = vitality or 0
        message.strength = strength or 0
        message.wisdom = wisdom or 0
        message.intelligence = intelligence or 0
        message.chance = chance or 0
        message.agility = agility or 0

        developer:sendMessage(message)
    else
        global:printError("Impossible de créer le message de mise à niveau des caractéristiques.")
    end

end

function calculCharacteristicsPointsToSet(nbPoints)
    local gained = 0
    local remaining = nbPoints

    -- Palier 1 (100 points à 1 pour 1)
    local gain = math.min(remaining, 100)
    gained = gained + gain
    remaining = remaining - gain

    -- Palier 2 (100 points à 2 pour 1)
    gain = math.min(math.floor(remaining / 2), 100)
    gained = gained + gain
    remaining = remaining - gain * 2

    -- Palier 3 (100 points à 3 pour 1)
    gain = math.min(math.floor(remaining / 3), 100)
    gained = gained + gain
    remaining = remaining - gain * 3

    -- Palier 4+ (points illimités à 4 pour 1)
    gain = math.floor(remaining / 4)
    gained = gained + gain
    remaining = remaining - gain * 4

    return nbPoints - remaining
end



function GetServerByAlias(Alias)
    for _, Server in ipairs(AllServers) do
        if Alias:lower():find(Server:lower()) then
            return Server
        end
    end
    return nil
end

function findMKamas(stringalias)
    local stringKamas = { }
    local tabstring = stringalias:split()

    for index, element in ipairs(tabstring) do
        if tabstring[index] == "[" then
            for i = 1, 3 do
                if tabstring[i + index] ~= "m" then
                    stringKamas[i] = tabstring[i + index]
                end
            end
        end
    end
    stringKamas = join(stringKamas)
    return (tonumber(stringKamas) == nil or tonumber(stringKamas) <= 5) and 0 or tonumber(stringKamas) - 5
end


ipproxy = "193.252.210.41"

function connectAccountsWithFailleProxy()

    local loadedAccounts = snowbotController:getLoadedAccounts()
        local accountsToConnectByServer =  {
                   ["Imagiro"] = {}, ["Orukam"] = {}, ["Tylezia"] = {}, ["Hell Mina"] = {}, ["Tal Kasha"] = {}, ["Draconiros"] = {},
                        ["Dakal"] = {}, ["Kourial"] = {}, ["Mikhal"] = {}, ["Rafal"] = {}, ["Salar"] = {}, ["Brial"] = {}
    }

    for _, server in ipairs(AllServers) do
        for _, acc in ipairs(loadedAccounts) do
            if acc:getAlias():find(server) and (acc:getAlias():find("Mineur") or acc:getAlias():find("Bucheron") 
            or acc:getAlias("Combat") or acc:getAlias():find("LvlUp")) and not acc:getAlias():find("BAN")
            and not acc:isAccountConnected() and canReconnect(acc:getAlias()) then
                table.insert(accountsToConnectByServer[server], acc)
            end
        end
    end

    local nbVagues = 0
    for _, accounts in pairs(accountsToConnectByServer) do
        if #accounts > nbVagues then
            nbVagues = #accounts
        end
    end

    global:printSuccess("Il y a " .. nbVagues .. " vagues de connexion à faire")
    if nbVagues > 0 then
        local connexionFile = openFile(global:getCurrentScriptDirectory() .. "\\connexion.json")

        if not connexionFile or #connexionFile == 0 or not connexionFile[1].inUse then
            connexionFile[1] = {
                    inUse = true,
                    by = global:thisAccountController():getAlias(),
                    date = os.date("%Y-%m-%d %H:%M:%S")
                }

            writeToJsonFile(global:getCurrentScriptDirectory() .. "\\connexion.json", connexionFile)
        elseif connexionFile[1].inUse and compareDateTime(os.date("%Y-%m-%d %H:%M:%S"), connexionFile[1].date) < 20 * 60 then
            global:printError("Un autre script est déjà en train de se connecter, on continue le script")
            return 
        elseif connexionFile[1].inUse and compareDateTime(os.date("%Y-%m-%d %H:%M:%S"), connexionFile[1].date) >= 20 * 60 
        and json.decode(developer:getRequest("http://" .. ipproxy .. "/status?proxy=p:5001")).status then
            -- Si le script de connexion a planté, on le relance
            global:printError("Le script de connexion a planté, on le relance")
            connexionFile[1].inUse = false
            connexionFile[1].by = ""
            connexionFile[1].date = ""
            writeToJsonFile(global:getCurrentScriptDirectory() .. "\\connexion.json", connexionFile)
            return connectAccountsWithFailleProxy() -- Retenter la connexion
        end
    end

    -- 4. Connexion par vague
    for i = 1, nbVagues do
        global:printSuccess("----- Vague de connexion " .. i .. " -----")

        local ipDeBase = developer:getRequest("http://api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")
        global:printMessage("IP de base : " .. ipDeBase)

        developer:getRequestWithDelay("http://" .. ipproxy .. "/reset?proxy=p:5001", 15000)
        global:printMessage("On vient de rotate le proxy")

        local proxyReady = json.decode(developer:getRequest("http://" .. ipproxy .. "/status?proxy=p:5001"))

        while not proxyReady.status do
            debug("ip pas encore ready, on attend")
            global:delay(2000)
            proxyReady = json.decode(developer:getRequest("http://" .. ipproxy .. "/status?proxy=p:5001"))
        end

        global:delay(5000)

        local nouvelleIp = developer:getRequest("http://api.ipify.org", {}, {}, ipproxy .. ":5001:proxy:proxy123")

        if ipDeBase ~= nouvelleIp and #nouvelleIp < 20 then
            global:printMessage("Nouvelle IP : " .. nouvelleIp)
        else
            global:printError("L'IP n'a pas changé, on retente dans 10 secondes")

            local connexionFile = openFile(global:getCurrentScriptDirectory() .. "\\connexion.json")
            connexionFile[1].inUse = false
            connexionFile[1].by = ""
            connexionFile[1].date = ""
            writeToJsonFile(global:getCurrentScriptDirectory() .. "\\connexion.json", connexionFile)

            global:delay(10000) -- Attendre 1 minute avant de retenter
            return connectAccountsWithFailleProxy() -- Retenter la connexion
        end
        for server, accountList in pairs(accountsToConnectByServer) do
            local acc = accountList[i] -- on prend le i-ème compte si dispo
            if acc then
                global:printSuccess("Connexion de " .. acc:getAlias() .. " sur " .. server)
                acc:connect()
            end
        end

        local connexionFile = openFile(global:getCurrentScriptDirectory() .. "\\connexion.json")
        connexionFile[1].inUse = false
        connexionFile[1].by = ""
        connexionFile[1].date = ""
        writeToJsonFile(global:getCurrentScriptDirectory() .. "\\connexion.json", connexionFile)

        global:delay(20000) -- 20000 ms = 20 secondes
    end
end


--- interaction bot bank ---


function getCurrentAreaName()
    local areaEquivalences = {
    ["18"] = "Astrub",
    ["58"] = "Havres-Sac",
    ["7"] = "Bonta",
    ["Brâkmar"] = "Brâkmar",
    ["Sufokia"] = "Sufokia",
    ["48"] = "Île de Frigost",
    ["78"] = "Île de Pandala",
    ["Île de Nowel"] = "Nowel",
    ["Île de Grobe"] = "Grobe",
    ["Île des Wabbits"] = "Wabbit",
    ["Île de Moon"] = "Moon",
    ["Île de Frigost 3"] = "Frigost 3",
    ["8"] = "Plaines de Cania",
    ["28"] = "Montagne des Koalaks",
    ["12"] = "Landes de Sidimote",
    ["46"] = "Île d'Otomaï"
}

    local currentArea = map:currentArea()
    if not currentArea or not areaEquivalences[currentArea] then
        return "Inconnu"
    end

    -- On vérifie si l'ID de la zone est dans les équivalences
    local areaId = tostring(currentArea)
    if areaEquivalences[areaId] then
        return areaEquivalences[areaId]
    end

    -- Si pas d'équivalence, on retourne le nom de la zone
    return 0
end


function debugMoveToward(mapToward)
	if not map:moveToward(mapToward) then
		map:changeMap("top|bottom|left|right")
	end
end

function debugMoveTowardMap(x, y)
    		debug("aaaa")

	if not map:moveTowardMap(x, y) then
		map:changeMap("top|bottom|left|right")
	end
end


MapSansHavreSac = {
    {Id = 168035328, Door = "458"},
    {Id = 168034312, Door = "215"},
    {Id = 168034310, Door = "215"},
    {Id = 104859139, Path = "444"},
    {Id = 168167424, Door = "289"},
    {Id = 104861191, Path = "457"},
    {Id = 57017859, Path = "395"},
    {Id = 168036352, Door = "458"},
    {Id = 104860167, Path = "478"},
    {Id = 104862215, Path = "472"},
    {Id = 104859143, Path = "543"},
    {Id = 168034306, Door = "471"},
    {Id = 168034308, Door = "464"},
    {Id = 168034310, Door = "493"},
    {Id = 57017861, Path = "270"},
    {Id = 104860169, Path = "379"},
    {Id = 104858121, Path = "507"},
    {Id = 168034304, Door = "390"},
    {Id = 104862217, Path = "369"},
    {Id = 104861193, Path = "454"},
    {Id = 104859145, Path = "457"},
}

function treatMaps(maps, errorFn)
    errorFn = errorFn or function() map:changeMap("havenbag") end

    local msg = "[Erreur] - Aucune action à réaliser sur la map, on va dans le havre-sac"

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

    if map:onMap(206308353) then map:changeMap("left") end

    for _, element in ipairs(MapSansHavreSac) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            map:door(tonumber(element.Door))
        end
    end

    if map:currentSubArea() == "Canyon sauvage" then
        return
        {
            {map = "-16,11", path = "top"},
            {map = "-16,10", path = "left"},
            {map = "-17,10", path = "bottom"},
            {map = "-17,11", path = "left"},
            {map = "-18,11", path = "bottom"},
            {map = "-18,12", path = "left"},
            {map = "-19,12", path = "top(6)"},
            {map = "-19,11", path = "top"},
            {map = "-19,10", path = "right"},
            {map = "-18,10", path = "top"},
            {map = "-18,9", path = "right"},
            {map = "-19,9", path = "right"},
            {map = "-17,9", path = "top"},
            {map = "-17,8", path = "top"},
        }
    elseif getCurrentAreaName() == "Île du Minotoror" then 
        return
        {
            {map = "34476296", custom = function() npc:npc(783, 3) npc:reply(-2) npc:reply(-1) end},
            {map = "-43,-17", path = "bottom"},
            {map = "-43,-18", path = "bottom"},
            {map = "-43,-19", path = "bottom"},
            {map = "-40,-19", path = "bottom"},
            {map = "-40,-18", path = "bottom"},
            {map = "-40,-17", path = "bottom"},
            {map = "-40,-16", path = "left"},
            {map = "-41,-16", path = "left"},
            {map = "-42,-16", path = "left"},
            {map = "-41,-17", path = "left"},
            {map = "-41,-18", path = "left"},
            {map = "-42,-18", path = "left"},
            {map = "-42,-17", path = "top"},
            {map = "-41,-19", path = "left"},
            {map = "-42,-19", path = "left"},
            {map = "-43,-16", custom = function() npc:npc(770, 3) npc:reply(-1) npc:reply(-1) end}
        } 
    end

    return errorFn
        and errorFn()
        or global:printError(msg)
end