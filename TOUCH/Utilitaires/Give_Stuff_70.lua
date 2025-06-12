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


local Stuff70 = {
    {Type = "Coiffe", Id = 2531, Position = 6},
    {Type = "Cape", Id = 2532, Position = 7},
    {Type = "Ceinture", Id = 2683, Position = 3},
    {Type = "Amulette", Id = 10836, Position = 0},
    {Type = "AnneauGauche", Id = 2469, Position = 4},
    {Type = "AnneauDroit", Id = 1559, Position = 2},
    {Type = "Bottes", Id = 6470, Position = 5},
    {Type = "Bouclier", Id = 14993, Position = 15},
    {Type = "Taquin Mineur", Id = 13766, emplacement = 10},
    {Type = "Chanceux Mineur", Id = 19407, emplacement = 11},
    {Type = "Taquin", Id = 13767, emplacement = 12},
    {Type = "Saccageur Eau Mineur", Id = 13781, emplacement = 14},
    {Type = "ares", Id = 250, emplacement = 1},
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
    for _, element in ipairs(Stuff70) do
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
        for _, element in ipairs(Stuff70) do
            if exchange:storageItemQuantity(element.Id) > 0 and inventory:itemCount(element.Id) == 0 then
                exchange:getItem(element.Id, 1)
            end
        end
        global:leaveDialog()
        for _, element in ipairs(Stuff70) do
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