-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}
--- </init>

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

function truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    return nbr:sub(1, nbr:find("%p") + size)
end

function truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return truncate(amount, 0)
end

function fini()
    global:printSuccess("prêt à recevoir les kamas")
end

function move()
	global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)

	if character:server() == "Draconiros" and getRemainingSubscription(true) < 2 then
		Abonnement()
	end
	if map:currentArea() == "Incarnam" then
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
		map:moveToward(192415750)
	end
	return {
		{map = "192415750", custom = fini},
	}
end

function bank()
	return move()
end


function phenix()
	return {
	}
end
