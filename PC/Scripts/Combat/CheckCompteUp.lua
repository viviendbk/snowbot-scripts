---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")

local receiverAlias = "bank"
local configPath = "C:\\Users\\Administrator\\Documents\\ovh snowbot\\ConfigMineur\\configBank.xml"
-- Montant de kamas que le bot farm devra garder 
local minKamas = 8000
-- Montant de kamas qui déclenchera le transfert au bot bank
local givingTriggerValue = 10000

-- Temps d'attente maximal de la connexion du bot bank (en secondes)
local maxWaitingTime = 120

-- Temps d'attente avant de réessayer de connecter le bot bank (en heures)
local minRetryHours = 4

-- IDs des bots bank par serveur
local IDsEnum = {
    ["agride"] = 644474535972,
    ["furye"] = 355670950099,
    ["ush"] = 474298450127,
    ["pandore"] = 570980237518,
    ["mériana"] = 903765885133,
    ["julith"] = 569860096208,
    ["nidas"] = 488809824465,
    ["merkator"] = 317047636178,
    ["brumen"] = 300038619348,
	["jahash"] = 18807259376,
}


--- </parameters>


--- <variables>

local toGive = 0
local retryTimestamp = 0
local server = character:server():lower()

local bankMaps = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

--- </variables>


--- </functions>
local function connectReceiver()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find(receiverAlias .. "_" .. server) then
            BankAccount = acc
            if not acc:isAccountFullyConnected() then
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
                        cannotConnect = true
	
                        return acc
                    end
                end
				acc:loadConfig(configPath)
				acc:startScript()
                return acc
            else
                return acc
            end
        end
    end
end

local function rerollVar()
    if global:remember("failed") then
        global:deleteMemory("failed")
    end

    toGive, connected, movingPrinted, givingMode = 0, nil, nil, nil
end

local function launchExchangeAndGive()
	global:printSuccess("check de la banque")
	npc:npcBank(-1)
	global:delay(500) 

	if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	

	global:leaveDialog()

    if character:kamas() > 200000 then
        receiver = connectReceiver()
    else
        global:disconnect()
    end

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. BankAccount.character():id())

    while not exchange:launchExchangeWithPlayer(BankAccount.character():id()) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
    end

    toGive = character:kamas() - minKamas

    global:printSuccess(toGive .. " kamas")

    exchange:putKamas(toGive)

	
    exchange:ready()

    global:delay(2000)

    global:printSuccess("Kamas transférés.")
	receiver:reloadScript()
	receiver:startScript()

    rerollVar()
    snowbotController:deleteAccount(global:thisAccountController():getUsername())
end

local function goAstrubBank(inBankCallback)
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end
    if not getCurrentAreaName():find("Astrub") then
        if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
            return map:changeMap(bankMaps.zAstrub)
        else
            return map:changeMap("havenbag")
        end
    else
        if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
            return map:moveToward(tonumber(bankMaps.bankAstrubInt))
        else
            if inBankCallback then
                return inBankCallback()
            end
        end
    end
end

local function secondsToHours(time)
    return time / 60 / 60
end

function move()
    return goAstrubBank(launchExchangeAndGive)


end

function bank()
    return move()
end