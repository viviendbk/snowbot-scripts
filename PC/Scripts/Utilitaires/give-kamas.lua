-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")


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


function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end


local function giveKamasAndValidate()
	global:printMessage("Je vais mettre les ressources dans l'échange")

    openFile()
	local quantityKamas = math.random(1, 5000)
	if character:kamas() > quantityKamas then
		global:printSuccess("Je mets " .. quantityKamas .. " kamas")
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
	developer:registerMessage("ExchangeRequestedTradeMessage", _handleExchange)
    global:printSuccess("prêt à donner les kamas")
end

function move()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)

	if enEchange then
		giveKamasAndValidate()
	end

	if IsInTable(SERVERS_MONO, character:server()) and getRemainingSubscription(true) < 2 then
		Abonnement()
	end

	goAstrubBank(fini)

end

function bank()
	return move()
end


function PHENIX()
	return {
	}
end
