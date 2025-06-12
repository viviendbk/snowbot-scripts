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


local stuffAA = {
    {Type = "coiffe AA", Id = 8463, Position = 6},
    {Type = "cape AA", Id = 8464, Position = 7},
    {Type = "amu AA", Id = 8465, Position = 0},
    {Type = "Gelano", Id = 2469, Position = 4},
    {Type = "anneau AA", Id = 8466, Position = 2},
    {Type = "Ceinture AA", Id = 8468, Position = 3},
    {Type = "Bottes AA", Id = 8467, Position = 5},
    {Type = "Examinateur", Id = 13831, Position = 11}
}

function messagesRegistering()
	developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end


function _ExchangeRequestedTradeMessage(message)
    developer:unRegisterMessage("ExchangeRequestedTradeMessage")

	message = developer:toObject(message)

    global:printSuccess(message.source)
	-- Check
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

    -- Put stuff
    for _, element in ipairs(stuffAA) do
        if inventory:itemCount(element.Id) > 0 then
            exchange:putItem(element.Id, 1)
        end
    end
    

    global:delay(500)

    exchange:ready()

	-- Wait
	global:printMessage("Attente de confirmation ...")
    developer:suspendScriptUntil("ExchangeLeaveMessage", 5000, false, nil, 20)
    inventory:openBank()
    exchange:putAllItems()
    global:leaveDialog()
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
    global:editAlias("bank_" .. character:serverName():lower() .. " : [" .. truncKamas() .. "m]", true)

    if not map:onMap(83887104) then
        GoTo("84674566", function()
            map:door(303)
        end)
    else
        inventory:openBank()
        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end
        for _, element in ipairs(stuffAA) do
            if exchange:storageItemQuantity(element.Id) > 0 and inventory:itemCount(element.Id) == 0 then
                exchange:getItem(element.Id, 1)
            end
        end
        global:leaveDialog()
        for _, element in ipairs(stuffAA) do
            if exchange:storageItemQuantity(element.Id) > 0 and inventory:itemCount(element.Id) == 0 then
                exchange:getItem(element.Id, 1)
            end
        end
        global:finishScript()
    end
end

function bank()
    return move()
end