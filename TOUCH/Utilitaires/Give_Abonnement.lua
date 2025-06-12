---@diagnostic disable: undefined-global, lowercase-global

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
    {Type = "Coiffe", Id = 7226},
    {Type = "Cape", Id = 7230},
    {Type = "Ceinture", Id = 7238},
    {Type = "Amulette", Id = 7250},
    {Type = "Anneau", Id = 7246},
    {Type = "Bottes", Id = 7242},
    {Type = "Arme", Id = 7254},

}
function messagesRegistering()
	developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end


function _ExchangeRequestedTradeMessage(message)
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
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
	global:delay(1000)

    local kamasToGive = 150000

    -- Put stuf
    
    exchange:putKamas(kamasToGive)

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
        inventory:openBank()
        for _, element in ipairs(StuffAkwalada) do
            if exchange:storageItemQuantity(element.Id) > 0 then
                exchange:getItem(element.Id, 1)
            end
        end
        global:leaveDialog()
        global:finishScript()
    end
end