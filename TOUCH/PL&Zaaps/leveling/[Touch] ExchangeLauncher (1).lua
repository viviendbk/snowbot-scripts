pathrecevoirechange = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\ExchangeReceiver.lua"
pathpiou = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_24-43.lua"
pathconfig = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_Eni.xml"

-- Destinataire (Si vous ne le changez pas, une popup va apparaitre pour insérer le nom manuellement à chaque fois)
EXCHANGE_TARGET_NAME = "Beniix-Mitty"

-- Code secret avoir l'autorisation (pas obligatoire si les bots sont connectés sur la meme instance)
SECRET_CODE = "salutcava"

-- Kamas (-1 = Ne rien mettre, 0 = Mettre tout)
PUT_KAMAS_AMOUNT = -1

-- Mettre dans l'échange ou non tous les objets présents dans l'inventaire
PUT_ALL_OBJECTS = false

-- Si PUT_ALL_OBJECTS == true, liste des identifiants des objets à ne pas mettre dans l'échange
PUT_OBJECTS_EXCEPTIONS = { }

-- Si PUT_ALL_OBJECTS == false, liste des identifiants des objets à mettre dans l'échange, et leurs quantités
-- Exemple : PUT_OBJECTS_LIST = { {ID1, QTY1}, {ID2, QTY2}, {ID3, QTY3} }
-- QTY1 est la quantité, si QTY1 == -1, il va mettre dans l'échange tous les objets ID1 en sa possession.
PUT_OBJECTS_LIST = {}

local EstAbo = false
local function connectBotBanque()
 if EstAbo == false then
	global:printSuccess("Connexion du bot banque")
	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank_dodge") then
			if not acc:isAccountConnected() then
				acc:connect()
				botBank = acc
				global:printSuccess("attente de la connexion du bot banque")

				while not acc:isAccountFullyConnected() do
					global:delay(2000)
				end
				acc:loadScript(pathrecevoirechange)
				acc:startScript(pathrecevoirechange) 
				map:door(303)    	
			else
				global:printSuccess("bot déjà connecté, on attend 15 secondes")
				global:delay(15000)
				return connectBotBanque()
			end
		end
	end
 end
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

local function echange()
	-- Check
	local TARGET_NAME = EXCHANGE_TARGET_NAME
	if TARGET_NAME == "NOM_DU_DESTINATAIRE" then
		TARGET_NAME = global:input("Le nom du destinataire n'est pas défini dans le script, insérez le manuellement :")
		if TARGET_NAME == "" then
			global:printError("Veuillez saisir ue nom du destinataire valide !")
			return
		end
	end

	-- Check
	if SECRET_CODE == "VOTRE_CODE_ICI" then
		global:printError("Attention, le code secret n'est pas défini, si le destinataire n'est pas connecté sur cette instance alors il n'acceptera pas l'échange !")
	else
		chat:sendPrivateMessage(SECRET_CODE, TARGET_NAME)
	end

	-- Try
	while not exchange:launchExchangeWithPlayerByName(TARGET_NAME) do
		global:printError("Impossible de lancer l'échange, retentative dans 5 seconds ...")
		global:delay(5000)
		if SECRET_CODE ~= "VOTRE_CODE_ICI" then
			chat:sendPrivateMessage(SECRET_CODE, TARGET_NAME)
		end
	end

	-- Wait
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

	-- Validation
	chat:sendPrivateMessage(TARGET_NAME, TARGET_NAME)

	-- Confirmation
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 10000, true, "ExchangeLeaveMessage") then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end
	global:printSuccess("on déco le bot banque")
	botBank:disconnect()
	global:printSuccess("on achete le bonus pack")
	AchatBonusPack()
	global:printSuccess("Bonnus pack acheté")
	global:leaveDialog()
	EstAbo = true
	global:printSuccess("on sort de la banque")
	map:moveToCell(396)

	global:printSuccess("on charge le script suivant")
	global:loadConfiguration(pathconfig, start) 
	global:loadAndStart(pathpiou) --charge pas le script je capte pas
	
end

function AllerAstrub()
    npc:npc(888, 3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)

end

function AchatBonusPack()
	if character:bonusPackExpiration() == 0 then
		    character:getBonusPack(1)
	end
end

function move()
	return {
		{ map = "1,-21", path = "right" },
		{ map = "2,-21", path = "right" },
		{ map = "3,-21", path = "right" },
		{ map = "4,-21", path = "bottom" },
		{ map = "4,-20", path = "bottom" },

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
        {map = "9,3", custom = AllerAstrub},


		{map = "4,-19", path = "bottom"},
		{map = "4,-18", path = "bottom"},
		{map = "4,-17", path = "bottom"},
		{map = "-1,-14", path = "right"},
		{map = "0,-15", path = "right"},
		{map = "1,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "0,-14", path = "top"},
		{map = "1,-15", path = "top"},
		{map = "84674566", custom = connectBotBanque},
		{map = "83887104", custom = echange}
	  }	
end

function putObject(uid, qty)
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeObjectMoveMessage\",\"data\":{\"objectUID\":"..uid..",\"quantity\":"..qty.."}}}")
end