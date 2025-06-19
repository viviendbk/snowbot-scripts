-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 
dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}
--- </init>
local resourceToGive = {}
local enEchange = false


function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end


local function takeRandomRessources()
	npc:npcBank(-1)
	local content = exchange:storageItems()
	local nbResourcesToTake = math.random(1, math.min(8, #content))

	for i = 1, nbResourcesToTake do

		local random = math.random(1, #content)
		for i, id in ipairs(content) do
			if i == random then
				local randomQuantity = math.random(1, math.min(exchange:storageItemQuantity(id), 5))
				exchange:getItem(id, randomQuantity)
				table.insert(resourceToGive, {id = id, quantity = randomQuantity})
				global:printSuccess("Je prends " .. randomQuantity .. " x " .. inventory:itemNameId(id))
			end
		end
	end
end

local function giveResourcesKamasAndValidate()
	global:printMessage("Je vais mettre les ressources dans l'échange")
	for _, element in ipairs(resourceToGive) do
		local quantityInInventory = inventory:itemCount(element.id)
		if quantityInInventory > 0 then
			exchange:putItem(element.id, math.min(element.quantity, quantityInInventory))
			global:printSuccess(element.quantity .. " x " .. inventory:itemNameId(element.id))
		end
	end
	
	local quantityKamas = math.random(1, 5000)
	if character:kamas() > quantityKamas then
		global:printSuccess("Je mets " .. quantityKamas .. " kamas")
		exchange:putKamas(quantityKamas)
		global:delay(math.random(2000, 4000))
	end

	global:printSuccess("J'accepte l'échange")
	exchange:ready()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)
end

function _handleExchange(message)
    if isAccountKnown(message.source) then
        global:printSuccess("on connait le personnage, echange accepté")
        developer:sendMessage(developer:createMessage("ExchangeAcceptMessage"))
    else
        global:printError("on ne connait pas le personnage, echange refusé")
        global:leaveDialog()
    end
    enEchange = true
	global:thisAccountController():startScript()
end

local function fini()
	global:printMessage("On prend des ressources random ")
	takeRandomRessources()
	developer:registerMessage("ExchangeRequestedTradeMessage", _handleExchange)


    global:printSuccess("prêt à recevoir les kamas")
end

function move()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)

	if enEchange then
		giveResourcesKamasAndValidate()
	end

	if IsInTable(SERVERS_MONO, character:server()) and getRemainingSubscription(true) < 2 then
		Abonnement()
	end
	debug("oui")
	goAstrubBank(fini)

end

function bank()
	return move()
end


function phenix()
	return {
	}
end
