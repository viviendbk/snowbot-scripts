pathrecevoirechange = "C:\\Users\\Administrator\\Desktop\\Script\\leveling\\receiveurAkwadala.lua"
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

local aLaStatut = false
local AlaPano = false
local function connectBotBanque()
 if AlaPano == false then
	global:printSuccess("Connexion du bot banque")
	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("Banque Dodge") then
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
	AlaPano = true
    global:printSuccess("on equipe la pano")

    inventory:equipItem(7226, 6)
    inventory:equipItem(7230, 7)
    inventory:equipItem(7238, 3)
    inventory:equipItem(7242, 5)
    inventory:equipItem(7246, 2)
    inventory:equipItem(7250, 0)
    inventory:equipItem(7254, 1)
    global:printSuccess("pano equipée")

	global:printSuccess("on sort de la banque")
	map:moveToCell(396)
    global:printSuccess("on change l'getAlias")
    global:editAlias(global:thisAccountController():getAlias() .. " GROUPE", true)
	global:printSuccess("fin de script")

end


function StringTabl()
    stringalias = "Team1 OSHIMO"
    tabstring = stringalias:split(" ")
    a = tabstring[1].." Herdegrise"
    global:editAlias(a , true)
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

function Statue()
    global:printSuccess(aLaStatut)
	if not aLaStatut and map:onMap("1,-21") then
        aLaStatut = true
        global:printSuccess(aLaStatut)
    elseif not map:onMap("1,-21") and not aLaStatut then
        global:printSuccess("on est pas a la statue")
        aLaStatut = true
        TPZaapAstrub()
        
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

function Leandre()
    if not map:onMap("1,-21") and not potionUtilisee then
        potionUtilisee = true
        TPZaapAstrub()
    end
end

function move()
    Leandre()

    return {
		{ map = "1,-21", path = "right" },
        { map = "2,-21", path = "right" },
        { map = "3,-21", path = "right" },
        { map = "4,-21", path = "bottom" },
        { map = "4,-20", path = "bottom" },
        { map = "4,-19", path = "bottom" },
        { map = "4,-18", path = "bottom" },
        { map = "4,-17", path = "bottom" },
        {map = "84674566", custom = connectBotBanque},
		{map = "83887104", custom = echange}

	}	
end

function putObject(uid, qty)
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeObjectMoveMessage\",\"data\":{\"objectUID\":"..uid..",\"quantity\":"..qty.."}}}")
end