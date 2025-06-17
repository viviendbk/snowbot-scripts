-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Lib\\IMPORT_LIBRARIES.lua")


GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}
--- </init>
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

function _HandleEchanfge(message)
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
	developer:registerMessage("ExchangeRequestedTradeMessage", _HandleEchanfge)
    global:printSuccess("prêt à donner les kamas")
end

function move()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)

	if enEchange then
		giveKamasAndValidate()
	end

	if character:server() == "Draconiros" and getRemainingSubscription(true) < 2 then
		Abonnement()
	end
	if getCurrentAreaName() == "Incarnam" then
		return {
			{map = "190843392", path = "top"},
			{ map = "153092354", door = 409},
		  { map = "152045573", path = "right", gather = false, fight = false }, -- 152045573
		  { map = "152043521", path = "right", gather = false, fight = false }, -- 152045573
		  { map = "152046597", path = "right", gather = false, fight = false }, -- 152045573
		  { map = "-2,-3", path = "right" }, -- 154010883
		  { map = "-2,-2", path = "top" }, -- 154010882
		  { map = "-1,-2", path = "top"}, -- 154010370
		  { map = "0,-2", path = "top"}, -- 153878786
		  { map = "1,-2", path = "top"}, -- 153879298
		  { map = "1,-3", path = "right" }, -- 153879299
		  { map = "0,-3", path = "right"}, -- 153878787
		  { map = "-1,-3", path = "right"}, -- 154010371
		  { map = "-1,-4", path = "bottom"}, -- 154010372
		  { map = "0,-4", path = "bottom" }, -- 153878788
		  { map = "0,-5", path = "bottom"}, -- 153878789
		  { map = "-1,-5", path = "right" }, -- 154010373
		  { map = "-2,-5", path = "right"}, -- 154010885
		  { map = "-2,-4", path = "bottom"}, -- 154010884
		  { map = "2,-3", path = "right"}, -- 153879811
		  { map = "3,-3", path = "right"}, -- 153880323
		  { map = "4,-3", custom = function()
			npc:npc(4398,3)
			npc:reply(-1)
			npc:reply(-1)
		  end}, -- 153880323
		}
	elseif not map:onMap(192415750) then
		debugMoveToward(192415750)
	end
	return {
		{map = "192415750", custom = fini},
	}
end

function bank()
	return move()
end


function PHENIX()
	return {
	}
end
