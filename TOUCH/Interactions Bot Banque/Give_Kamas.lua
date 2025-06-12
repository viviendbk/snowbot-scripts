---@diagnostic disable: undefined-global, lowercase-global

PUT_KAMAS_AMOUNT = 150000

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


	-- Put kamas
	if PUT_KAMAS_AMOUNT > 0 then
		if character:kamas() >= PUT_KAMAS_AMOUNT then
			global:printSuccess("Je mets dans l'échange "..PUT_KAMAS_AMOUNT.." kamas.")
			exchange:putKamas(PUT_KAMAS_AMOUNT)
		else
			global:printError("Je ne possède pas "..PUT_KAMAS_AMOUNT.." kamas, on annule l'échange !")
			global:leaveDialog()
			return
		end
	elseif PUT_KAMAS_AMOUNT == 0 and character:kamas() > 0 then
		global:printSuccess("Je mets dans l'échange "..character:kamas().." kamas.")
		exchange:putKamas(0)
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
    global:editAlias("bank_" .. character:server():lower() .. " [" .. character:kamas() .. "]", true)
end