---@diagnostic disable: undefined-global, lowercase-global

PUT_KAMAS_AMOUNT = 150000


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
	developer:registerMessage("ChatServerMessage", _ChatServerMessage)
end

function _ChatServerMessage(message)
	message = developer:toObject(message)
	if message.channel == 9 and isWhitelisted(message.senderId) ~= nil and message.content == character:name() then
		global:printSuccess("Confirmation ...")
		exchange:ready()
	end
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

    -- Put stuff
    for _, element in ipairs(StuffAkwalada) do
        exchange:putItem(element.Id, 1)
    end

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



function move()
    npc:npcBank(522)
    for _, element in ipairs(StuffAkwalada) do
        exchange:getItem(element.Id, 1)
    end
    global:leaveDialog()
    global:finishScript()
end