-- Code secret pour autoriser un joueur (pas obligatoire si les bots sont connectés sur la meme instance)
SECRET_CODE = "salutcava"

-- Joueurs autorisés (à ne pas toucher)
WHITELISTED_PLAYERS = {}

-- Kamas (-1 = Ne rien mettre, 0 = Mettre tout)
PUT_KAMAS_AMOUNT = 100

-- Mettre dans l'échange ou non tous les objets présents dans l'inventaire
PUT_ALL_OBJECTS = false

-- Si PUT_ALL_OBJECTS == true, liste des identifiants des objets à ne pas mettre dans l'échange
PUT_OBJECTS_EXCEPTIONS = { }

-- Si PUT_ALL_OBJECTS == false, liste des identifiants des objets à mettre dans l'échange, et leurs quantités
-- Exemple : PUT_OBJECTS_LIST = { {ID1, QTY1}, {ID2, QTY2}, {ID3, QTY3} }
-- QTY1 est la quantité, si QTY1 == -1, il va mettre dans l'échange tous les objets ID1 en sa possession.
PUT_OBJECTS_LIST = {  {7226 , 1}, {7230 , 1}, {7238 , 1}, {7250 , 1}, {7246 , 1}, {7242 , 1}, {7254 , 1} }

local StuffAventurier = {
    {Type = "Coiffe", Id = 7226 },
    {Type = "Cape", Id = 7230 },
    {Type = "Ceinture", Id = 7238 },
    {Type = "Amulette", Id = 7250 },
    {Type = "Anneau", Id = 7246 },
    {Type = "Bottes", Id = 7242 },
    {Type = "Arme", Id = 7254 },
}

function messagesRegistering()
	developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
	developer:registerMessage("ChatServerMessage", _ChatServerMessage)
end

function _ChatServerMessage(message)
	message = developer:toObject(message)
	if message.channel == 9 and message.content == SECRET_CODE and SECRET_CODE ~= "VOTRE_CODE_ICI" then
		WHITELISTED_PLAYERS[tostring(message.senderId)] = true
		global:printSuccess("Le joueur "..message.senderName.." a été ajouté dans WHITELISTED_PLAYERS.")
	elseif message.channel == 9 and isWhitelisted(message.senderId) ~= nil and message.content == character:name() then
		global:printSuccess("Confirmation ...")
		exchange:ready()
	end
end

function _ExchangeRequestedTradeMessage(message)
	message = developer:toObject(message)

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

	-- Put object
	global:printSuccess("Mise des objets en cours ...")
	if PUT_ALL_OBJECTS then
		exchange:putAllItemsExcept(PUT_OBJECTS_EXCEPTIONS)
	else
		local iContent = inventory:inventoryContent()
		for _, idAndQuantity in ipairs(PUT_OBJECTS_LIST) do
			local putCount = 0
			for _, item in ipairs(iContent) do
				if item.objectGID == idAndQuantity[1] then
					if idAndQuantity[2] == -1 then
						putObject(item.objectUID, item.quantity)
					else
						local remaining = idAndQuantity[2] - putCount
						if remaining > 0 then
							if item.quantity > remaining then
								putObject(item.objectUID, remaining)
								putCount = putCount + remaining
								break
							else
								putObject(item.objectUID, item.quantity)
								putCount = putCount + item.quantity
							end
						else
							break
						end
					end
				end
			end
			if idAndQuantity[2] ~= -1 and putCount ~= idAndQuantity[2] then
				global:printError("Quantité de l'objet ["..inventory:itemNameId(idAndQuantity[1]).."] inssufisante : "..putCount.."/"..idAndQuantity[2]..", on annule l'échange !")
				global:leaveDialog()
				return
			end
		end
	end
	global:printSuccess("Mise des objets terminée.")

	-- Wait
	global:printMessage("Attente de confirmation ...")
end

function putObject(uid, qty)
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeObjectMoveMessage\",\"data\":{\"objectUID\":"..uid..",\"quantity\":"..qty.."}}}")
end

function isWhitelisted(id)
	if WHITELISTED_PLAYERS[tostring(id)] ~= nil then
		return true
	end
	local lAccounts = ankabotController:getLoadedAccounts()
    for _, account in ipairs(lAccounts) do
        if account.character:id() == id then
        	return true
        end
    end
    return false
end

function move()
	global:printSuccess("On check la bank")
	inventory:openBank()
    for _, element in ipairs(StuffAventurier) do
        exchange:getItem(element.Id, 1)
        global:printSuccess("item pris")
    end
    global:leaveDialog()
    global:finishScript()
end