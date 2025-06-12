
AUTO_DELETE = {1974, 1984, 1770, 1773, 398, 1736, 2416, 2419, 2422, 2425, 2428, 885}

MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {3569, 3573, 3570, 3571, 372}
FORCE_MONSTERS = {274}

local DeconnecterBotBanque = false
local StopAchatDD = false

local Trajet = {
	{ map = "4,-19", path = "zaap(141588)" },
	
	{ map = "5,7", path = "bottom", fight = true },
	{ map = "5,8", path = "right", fight = true },
	{ map = "6,8", path = "bottom", fight = true },
	{ map = "6,9", path = "bottom", fight = true },
	{ map = "6,10", path = "right", fight = true },
	{ map = "7,10", path = "bottom", fight = true },
	{ map = "7,11", path = "left", fight = true },
	{ map = "6,11", path = "left", fight = true },
	{ map = "5,11", path = "top", fight = true },
	{ map = "4,11", path = "left", fight = true },
	{ map = "3,11", path = "top", fight = true },
	{ map = "5,10", path = "top", fight = true },
	{ map = "5,9", path = "left", fight = true },
	{ map = "4,9", path = "bottom", fight = true },
	{ map = "4,10", path = "bottom", fight = true },
	{ map = "3,10", path = "top", fight = true },
	{ map = "3,9", path = "left", fight = true },
	{ map = "2,9", path = "bottom", fight = true },
	{ map = "2,10", path = "bottom", fight = true },
	{ map = "2,11", path = "bottom", fight = true },
	{ map = "2,12", path = "left", fight = true },
	{ map = "1,12", path = "left", fight = true },
	{ map = "0,12", path = "top", fight = true },
	{ map = "0,11", path = "right", fight = true },
	{ map = "1,11", path = "top", fight = true },
	{ map = "1,10", path = "left", fight = true },
	{ map = "0,10", path = "top", fight = true },
	{ map = "1,9", path = "top", fight = true },
	{ map = "0,9", path = "right", fight = true },
	{ map = "1,8", path = "left", fight = true },
	{ map = "0,8", path = "top", fight = true },
	{ map = "0,7", path = "right", fight = true },
	{ map = "1,7", path = "right" },
	{ map = "2,7", path = "bottom" },
	{ map = "2,8", path = "right", fight = true },
	{ map = "3,8", path = "right", fight = true },
	{ map = "4,8", path = "right", fight = true },
	{ map = "4,-15", path = "bottom(541)" },
	{ map = "4,-14", path = "bottom" },

}


local function limitcombats()
	
	if global:maximumNumberFightsOfDay() then
		local Team = global:thisAccountController():getTeamAccounts()
		for _, acc in ipairs(Team) do
			acc.global:reconnectBis(350)
		end
		global:reconnectBis(350)
	 end
	 
end

local function Abonnement()
	if character:bonusPackExpiration() == 0 then

		character:getBonusPack(1)
		global:printSuccess("Bonus pack acheté")
		global:reconnectBis(0)
	
	
	 end
end



local function Equip()
	global:printSuccess("dab de panneau")
    developer:sendMessage('{"call":"sendMessage","data":{"type":"InventoryPresetUseMessage","data":{"presetId":0}}}')
end

local function RelancerLeScript(message)
	if not global:thisAccountController():isScriptPlaying() and global:isBoss() then 
		global:thisAccountController():startScript()
	end
end


function messagesRegistering()
	developer:registerMessage("ChatServerMessage", RelancerLeScript)
    developer:registerMessage("GameFightEndMessage", Equip)
end








local function nourrirDD()

    local index = 0
    local minPrice = 500000000
    local TableAchat = {
        {Name = "Poisson Pané", Id = 1750},
        {Name = "Crabe Sourimi", Id = 1757},
        {Name = "Goujon", Id = 1782},
        {Name = "Brochet", Id = 1847},
        {Name = "Sardine Brillante", Id = 1805},
        {Name = "Cuisse de Boufton", Id = 1911},
        {Name = "Cuisse de Bouftou **", Id = 1912},
        {Name = "Poisson-Chaton", Id = 603},
        {Name = "Bar Rikain", Id = 1779},
		{Name = "Chair d'insecte", Id = 1915},

    }

    npc:npcSale()

    global:printSuccess("Check du meilleur prix")

    for i, element in ipairs(TableAchat) do
        local Price = sale:getPriceItem(element.Id, 3)
        if Price ~= nil and Price ~= 0 and Price < minPrice then
            minPrice = Price
            index = i
        end
    end

    global:leaveDialog()

    global:delay(500)

    if  minPrice < 6000 then
        local myMount1 = mount:myMount()
        while (myMount1.energyMax - myMount1.energy) > 1000 and character:kamas() > 6000 do
            npc:npcBuy()
            sale:buyItem(TableAchat[index].Id, 100, 6000)
            global:leaveDialog()
            mount:feedMount(TableAchat[index].Id, 100)
            myMount1 = mount:myMount()
        end
            global:printSuccess("DD nourrie")
    else
        global:printSuccess("les prix sont trop cher, on a pas pu acheter")
        StopAchatDD = true
    end
	global:printSuccess("Fin de la fonction")
end

local function luBank() -- Le nom de notre fonction
	chat:sendPrivateMessage("meganecoeurdemavie","Maixpoaakc")
	
	while not exchange:launchExchangeWithPlayer(8700008) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(2000)
    end
	
  	exchange:putAllItemsExchange() -- La fonction pour déposer tous les objets de l'inventaire
  	exchange:ready() -- La fonction pour valider l'échange

	DeconnecterBotBanque = true
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

local function treatMaps(maps)
    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end
	global:printSuccess("popo rappel")
	return {{map = map:currentMapId(), lockedCustom = function() TPZaapAstrub() map:changeMap("zaap(141588)") end}}
end

function move()
	local myMount = mount:myMount()

	Abonnement()
	limitcombats()

    if myMount ~= nil and (myMount.energyMax - myMount.energy) > 1000 and not StopAchatDD and character:kamas() > 6000 then
        nourrirDD()
    end

	if not mount:isRiding() then
		mount:toggleRiding()
		global:printSuccess("dab de DD")
	end

	if DeconnecterBotBanque then
		DeconnecterBotBanque = false
		global:printSuccess("déconnection du bot banque")
		for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
			if acc:getAlias():find("Banque_Oshimo") then
				if acc:isAccountConnected() then
					acc:disconnect()
				end
			end
		end
	end
	
	return treatMaps(Trajet)

end

local function connectBotBanque()
  	if map:onMap(84674566) and global:isBoss() then
		global:printSuccess("Connexion du bot banque")
    	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
     		if acc:getAlias():find("Banque_Oshimo") then
            	if not acc:isAccountConnected() then
                	acc:connect()
					global:printSuccess("attente de la connexion du bot banque")

					while not acc:isAccountFullyConnected() do
						global:delay(2000)
					end
					                	
            	else
                	global:printSuccess("bot déjà connecté, on attend 2 minutes")
                	global:delay(120000)
                	return connectBotBanque()
            	end
        	end
		end
  	end
end

function bank()


	if map:currentSubArea() ~= "Cité d'Astrub" then 
		return {
			{map = map:currentMapId(), lockedCustom = TPZaapAstrub},
		}
	end
	
    return {
	
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
        {map = "84A3169F", custom = connectBotBanque(), door = "303"},
		{map = "83887104", lockedCustom = luBank, path = "396"},

        }
end

function phenix()
	return {
		{map = "-18,-57", lockedCustom = function() map:door(172) global:delay(5000) TpZaapAstrub() end},
	}
end

