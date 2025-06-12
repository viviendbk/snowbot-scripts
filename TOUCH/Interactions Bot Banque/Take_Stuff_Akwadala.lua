---@diagnostic disable: undefined-global, lowercase-global


local scriptPath = "C:\\Users\\Administrator\\Desktop\\Script\\Give_Stuff_Akwadala.lua"
local pathDopeul = "C:\\Users\\Administrator\\Desktop\\Script\\trajets\\dopeul.lua"

local function join(tab, sep)
    local result = ''
    for k, v in ipairs(tab) do
        result = sep
            and result .. v .. sep
            or result .. v
    end

    return result
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

local function connectBotBanque()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("BanqueDodge") then
            if not acc:isAccountConnected() then
                acc:connect()

                global:printMessage("attente de la connexion du bot banque")

                while not acc:isAccountFullyConnected() do
                    global:delay(2000)
                end

                global:printSuccess("le bot banque s'est connecté !")

				acc:loadScript(scriptPath)
                acc:startScript()
                global:delay(10000)
                return acc
            else
                global:printSuccess("bot déjà connecté, on attend 2 minutes")
                global:delay(120000)
                return connectBotBanque()
            end
        end
    end
end

local function launchExchangeAndTakeStuff()
    AccountBank = connectBotBanque()

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

    while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
    end

    global:delay(20000)
    	-- Validation
    chat:sendPrivateMessage(AccountBank.character:name(), AccountBank.character:name())

	-- Confirmation
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 10000, true, "ExchangeLeaveMessage") then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end

    global:delay(2000)
    AccountBank:disconnect()

    global:loadAndStart(pathDopeul)
end

local function TPZaapAstrub()
    npc:npcBuy()
	global:delay(500)
    sale:buyItem(548, 1, 1000)
	global:delay(500)
    global:leaveDialog()
	global:delay(500)
    inventory:useItem(548)
end

function move()  
    if global:thisAccountController():getAlias():find("DOPEUL") then
        local Avoid = {"[", "D", "O", "P", "E", "U", "L", "]"}
        local newAlias = {}
        for _, element in ipairs(global:thisAccountController():getAlias():split()) do
            for _, element2 in ipairs(Avoid) do
                if element == element2 then
                    dontWrite = true
                end
            end
            if not dontWrite then
                table.insert(newAlias, element)
            end
            dontWrite = false
        end
        newAlias = join(newAlias)
        global:editAlias(newAlias, true)
    end

    if map:currentSubArea() ~= "Cité d'Astrub" and map:currentArea() ~= "Incarnam" then
        return {{map = map:currentMapId(), lockedCustom = TpZaapAstrub(), path = "top|left|right|bottom"}}
    elseif map:currentArea() == "Incarnam" then
        return {
            {map = "-5,-1", path = "bottom"},
            {map = "-4,0", path = "right"},
            {map = "-3,1", path = "right"},
            {map = "-2,2", path = "bottom"},
            {map = "0,3", path = "right"},
            {map = "1,3", path = "right"},
            {map = "2,3", path = "right"},
            {map = "3,3", path = "right"},
            {map = "4,3", path = "right"},
            {map = "6,3", path = "right"},
            {map = "5,3", path = "right"},
            {map = "7,3", path = "right"},
            {map = "8,3", path = "right"},
            {map = "9,3", lockedCustom = GoToAstrub},
        }
    elseif map:currentSubArea() == "Cité d'Astrub" then
        return {
            { map = "0,-22", path = "bottom" },
            { map = "1,-22", path = "bottom" },
            { map = "2,-22", path = "bottom" },
            { map = "4,-22", path = "bottom" },
            { map = "3,-22", path = "bottom" },
            { map = "5,-22", path = "bottom" },
            { map = "6,-21", path = "bottom" },
            { map = "7,-21", path = "bottom" },
            { map = "5,-21", path = "bottom" },
            { map = "4,-21", path = "bottom" },
            { map = "3,-21", path = "bottom" },
            { map = "2,-21", path = "bottom" },
            { map = "1,-21", path = "bottom" },
            { map = "0,-21", path = "bottom" },
            { map = "-1,-21", path = "bottom" },
            { map = "-1,-20", path = "bottom" },
            { map = "1,-20", path = "bottom" },
            { map = "0,-20", path = "bottom" },
            { map = "2,-20", path = "bottom" },
            { map = "3,-20", path = "bottom" },
            { map = "4,-20", path = "bottom" },
            { map = "5,-20", path = "bottom" },
            { map = "6,-20", path = "bottom" },
            { map = "7,-20", path = "bottom" },
            { map = "7,-19", path = "bottom" },
            { map = "7,-18", path = "bottom" },
            { map = "6,-19", path = "bottom" },
            { map = "6,-18", path = "bottom" },
            { map = "5,-19", path = "bottom" },
            { map = "5,-18", path = "bottom" },
            { map = "3,-19", path = "bottom" },
            { map = "4,-19", path = "bottom" },
            { map = "2,-19", path = "bottom" },
            { map = "1,-19", path = "bottom" },
            { map = "0,-19", path = "bottom" },
            { map = "-1,-19", path = "bottom" },
            { map = "-1,-18", path = "bottom" },
            { map = "0,-18", path = "bottom" },
            { map = "1,-18", path = "bottom" },
            { map = "2,-18", path = "bottom" },
            { map = "3,-18", path = "bottom" },
            { map = "4,-18", path = "bottom" },
            { map = "7,-17", path = "bottom" },
            { map = "6,-17", path = "bottom" },
            { map = "5,-17", path = "bottom" },
            { map = "4,-17", path = "bottom" },
            { map = "3,-17", path = "bottom" },
            { map = "2,-17", path = "bottom" },
            { map = "1,-17", path = "bottom" },
            { map = "-1,-17", path = "bottom" },
            { map = "-1,-16", path = "right" },
            { map = "0,-16", path = "right" },
            { map = "1,-16", path = "right" },
            { map = "2,-16", path = "right" },
            { map = "3,-16", path = "right" },
            { map = "-1,-15", path = "right" },
            { map = "0,-15", path = "right" },
            { map = "1,-15", path = "right" },
            { map = "2,-15", path = "right" },
            { map = "3,-15", path = "right" },
            { map = "-1,-14", path = "right" },
            { map = "0,-14", path = "right" },
            { map = "1,-14", path = "right" },
            { map = "2,-14", path = "right" },
            { map = "3,-14", path = "top" },
            { map = "7,-16", path = "left" },
            { map = "5,-16", path = "left" },
            { map = "6,-16", path = "left" },
            { map = "7,-15", path = "left" },
            { map = "6,-15", path = "left" },
            { map = "5,-15", path = "left" },
            { map = "4,-15", path = "top" },
            {map = "84674566", door = "303"},
            {map = "83887104", lockedCustom = launchExchangeAndTakeStuff},
        }
    end
end

function bank()
    return move()
end