dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

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


local StuffAkwalada = {
    {Type = "Coiffe", Id = 7226, Position = 6},
    {Type = "Cape", Id = 7230, Position = 7},
    {Type = "Ceinture", Id = 7238, Position = 3},
    {Type = "Amulette", Id = 7250, Position = 0},
    {Type = "Anneau", Id = 7246, Position = 4},
    {Type = "Bottes", Id = 7242, Position = 5},
    --{Type = "Arme", Id = 7254, Position = 1},
}

function messagesRegistering()
	developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end


function _ExchangeRequestedTradeMessage(message)
    developer:unRegisterMessage("ExchangeRequestedTradeMessage")

	message = developer:toObject(message)

    global:printSuccess(message.source)
	-- Checks
	if not isWhitelisted(message.source) then
		global:printError("Échange reçu de la part d'un joueur inconnu, on refuse !")
		global:leaveDialog()
		return
	end
	-- Accept
	global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
    global:delay(1000)
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
	global:delay(1000)

    local kamasToGive = 100000
    
    exchange:putKamas(kamasToGive)

    global:delay(500)

    exchange:ready()

	-- Wait
	global:printMessage("Attente de confirmation ...")
end

function isWhitelisted(id)
	local lAccounts = ankabotController:getLoadedAccounts()
    for _, account in ipairs(lAccounts) do
        if account.character:id() == id then
        	return true
        end
    end
    return false
end

local function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    if not map:onMap(mapToward) then
        if #toward == 2 then
            return map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
        elseif #toward == 1 then
            return map:moveToward(tonumber(toward[1]))
        end
    else
        action()
    end
end

function move()
    if not map:onMap(83887104) then
        GoTo("84674566", function()
            map:door(303)
        end)
    else
        global:printSuccess("J'ouvre la banque")
        inventory:openBank()
        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end

        global:leaveDialog()
        global:finishScript()
    end
end

function bank()
    return move()
end