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
local enEchange = false
local resourceToGive = {}
local additionalKamas = 0

local listeItemAPrendre = {
	{name = "coiffe aa", id = 8463},
	{name = "amulette aa", id = 8465},
	{name = "ceinture aa", id = 8468},
	{name = "cape aa", id = 8464},
	{name = "bottes aa", id = 8467},
	{name = "ares", id = 250},
	{name = "anneau aa", id = 8466},
	{name = "gelano", id = 2469},
	{name = "bouclier", id = 18690},
	{name = "trophet 1", id = 13748},
	{name = "trophet 4", id = 13793},
	{name = "dofus cawotte", id = 972},
	{name = "dokoko", id = 17078},
	{name = "dofus argenté", id = 19629},
	{name = "dofus kaliptus", id = 8072},


	{name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
	{name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
	{name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
	{name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
	{name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
	{name = "arme sasa", id = 478, emplacement = 1, equipe = false},
	{name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},

	{name = "signe d'ombre", id = 14966}
}

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

function takeStuff()
	
	npc:npcBank(-1)
	global:delay(500)
	for _, element in ipairs(listeItemAPrendre) do
		if exchange:storageItemQuantity(element.id) > 0 then
			exchange:getItem(element.id, 1)
		else
			global:printError("L'item " .. element.name .. " n'est pas dans la bank")
			additionalKamas = additionalKamas + (element.name:find("trophet1") and 50000 or element.name:find("bouclier") and 0 or 150000)
		end
	end
    exchange:getKamas(0)
	global:delay(500)
	global:leaveDialog()
end

local function giveKamasandStuffAndValidate()
	global:printMessage("Je vais mettre les ressources dans l'échange")

    local orderInfos = fetchKamasOrders()
	local quantityKamas = orderInfos.kamasAmount + additionalKamas
	for _, element in ipairs(listeItemAPrendre) do
		if inventory:itemCount(element.id) > 0 then
			exchange:putItem(element.id, 1)
		end
	end
	if character:kamas() > quantityKamas then
		global:printSuccess("Je mets " .. quantityKamas .. " kamas")
		exchange:putKamas(quantityKamas)
		global:delay(math.random(2000, 4000))
	end

	exchange:ready()
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
	global:editInMemory("reloadNumber", global:remember("reloadNumber") + 1)
	if global:remember("reloadNumber") > 5 then
		global:editInMemory("reloadNumber", 0)
		global:printError("Trop de reloads, on arrête le bot")
		setBotBankConnected(character:server(), false)
		global:disconnect()
		return
	end
	global:printMessage("On prend des ressources random ")
	if global:remember("reloadNumber") > 1 then
		global:printMessage("On a déjà relancé " .. global:remember("reloadNumber") .. " fois, on ne prend pas les ressources")
	else
		takeStuff()
	end

	developer:registerMessage("ExchangeRequestedTradeMessage", _handleExchange)


    global:printSuccess("prêt à recevoir les kamas")
end


function move()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)

	if enEchange then
		giveKamasandStuffAndValidate()
	end

	if IsInTable(SERVERS_MONO, character:server()) and getRemainingSubscription(true) < 2 then
		Abonnement()
	end

	return goAstrubBank(fini)

end

function bank()
	return move()
end


function phenix()
	return {
	}
end
