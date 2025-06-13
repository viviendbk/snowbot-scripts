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


function handleDisconnection()
    local currentTime = os.time()

    local nextDisconnection = global:remember("nextDisconnection")

    -- Si la variable n'existe pas, on l'initialise
    if not nextDisconnection then
        local random = math.random()
        local minutesDisconnection = 0

        if random < 0.02 then
            minutesDisconnection = math.random(400, 600)
        elseif random < 0.03 then
            minutesDisconnection = math.random(35, 55)
        elseif random < 0.15 then
            minutesDisconnection = math.random(90, 120)    
        elseif random < 0.35 then
            minutesDisconnection = math.random(120, 150)          
        elseif random < 0.65 then
            minutesDisconnection = math.random(150, 180)    
        else
            minutesDisconnection = math.random(180, 240)   
        end
        global:addInMemory("nextDisconnection", currentTime + minutesDisconnection * 60)
        return
    end

    -- Si l'horaire est dépassé de plus de 5 minutes (300 secondes)
    if currentTime > (nextDisconnection + 300) then
                local random = math.random()
        local minutesDisconnection = 0

        if random < 0.02 then
            minutesDisconnection = math.random(400, 600)
        elseif random < 0.03 then
            minutesDisconnection = math.random(35, 55)
        elseif random < 0.15 then
            minutesDisconnection = math.random(90, 120)    
        elseif random < 0.35 then
            minutesDisconnection = math.random(120, 150)          
        elseif random < 0.65 then
            minutesDisconnection = math.random(150, 180)    
        else
            minutesDisconnection = math.random(180, 240)   
        end
        global:addInMemory("nextDisconnection", currentTime + minutesDisconnection * 60)
        return
    end

    -- si l'horaire est dépassé de moins de 5 minutes, on se déconnecte
    if currentTime >= nextDisconnection then
        global:printError("Le script est en pause jusqu'à " .. os.date("%H:%M:%S", nextDisconnection) .. ". Déconnexion du compte.")
        local random = math.random()
        local minutesDisconnection = 0
        if random < 0.05 then
            -- Rare : pause longue
            minutesDisconnection = math.random(200, 400)
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

        global:printMessage("Le script sera en pause pendant " .. minutesDisconnection .. " minutes.")
        global:reconnectBis(minutesDisconnection)
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
		global:delay(math.random(3000, 5000))
	elseif random < 0.5 then
		global:delay(math.random(1500, 3000))
	else
		global:delay(math.random(500, 1500))
	end
end

function mapDelay()
	local random = math.random()
	if random < 0.05 then
		global:delay(math.random(7000, 11000))
	elseif random < 0.25 then
		global:delay(math.random(4000, 6500))
	elseif random < 0.5 then
		global:delay(math.random(2000, 4000))
	else
		global:delay(math.random(1000, 2500))
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
connected = false


function isBotBankAvailable()
    local json = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. character:server() .. "\\botBankAvailability.json")
    return not json[1].connected
end

function setBotBankConnected(server, bool)
    global:printSuccess(server)
    local jsonMemory = openFile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. server .. "\\botBankAvailability.json")

    global:printSuccess(server)
    global:printSuccess(bool)
    jsonMemory[1].connected = bool
    jsonMemory[1].lastUpdate = getCurrentDateTime()

    local new_content = json.encode(jsonMemory)
    -- Écrire les modifications dans le fichier JSON

    local file = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Temp\\" .. server .. "\\botBankAvailability.json", "w")

    file:write(new_content)
    file:close()
end

function resetBotBankAvailability(force)
    local servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Draconiros"}
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

            if cannotConnect then
                rerollVar()
                receiver:disconnect()
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
            if not map:currentArea():find("Astrub") then
                if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
                    return map:changeMap(bankMaps.zAstrub)
                else
                    return map:changeMap("havenbag")
                end
            else
                if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
                    return map:moveToward(tonumber(bankMaps.bankAstrubInt))
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

    while not exchange:launchExchangeWithPlayer(id) and safetyCount < 120 do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
		safetyCount = safetyCount + 5
    end
	if safetyCount >= 120 then
		global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
		receiver:disconnect()
		return
	end

    local toGive = (character:kamas() - minKamas) > 100000 and (character:kamas() - minKamas) or 1

    exchange:putKamas(toGive)
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



function debug(msg)
    global:printSuccess("DEBUG: " .. msg)
    
end
--- interaction bot bank ---