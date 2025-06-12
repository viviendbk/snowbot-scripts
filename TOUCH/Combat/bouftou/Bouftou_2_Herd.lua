AUTO_DELETE = {1974, 1984, 1770, 1773, 398}

MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {3570,3572}
FORCE_MONSTERS = {148}

local DeconnecterBotBanque = false
local StopAchatDD = false

local function Equip()
    developer:sendMessage('{"call":"sendMessage","data":{"type":"InventoryPresetUseMessage","data":{"presetId":0}}}')
end

function messagesRegistering()
    developer:registerMessage("GameFightEndMessage", Equip)
end

local function TPZaapAstrub()
    npc:npcBuy()
    sale:buyItem(548, 1, 1000)
    global:leaveDialog()
    inventory:useItem(548)
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
	chat:sendPrivateMessage("meganecoeurdemavie","Mahmagg")
	
	while not exchange:launchExchangeWithPlayer(5032713) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(2000)
    end
	
  	exchange:putAllItemsExchange() -- La fonction pour déposer tous les objets de l'inventaire
  	exchange:ready() -- La fonction pour valider l'échange

	DeconnecterBotBanque = true
end

local function TPZapAstrub()
    npc:npcBuy()
    sale:buyItem(548, 1, 1000)
    global:leaveDialog()
    inventory:useItem(548)
end

function move()

	if DeconnecterBotBanque then
		for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
			if acc:getAlias():find("Banque_Herdegrise") then
				if acc:isAccountConnected() then
					DeconnecterBotBanque = false
					acc:disconnect()
				end
			end
		end
	end
	return {
	    {map = "-1,-14", path = "right"},
		{map = "0,-15", path = "right"},
		{map = "1,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "0,-14", path = "top"},
		{map = "1,-15", path = "top"},
		{map = "4,-16", path = "top"},
		{map = "4,-17", path = "top"},
		{map = "4,-18", path = "top"},
	    {map = "4,-19", path = "zaap(88082704)" },
		{map = "1,7", path = "left", fight = true},
		{map = "2,11", path = "left", fight = true},
		{map = "1,10", path = "right", fight = true},
		{map = "2,10", path = "right", fight = true},
		{map = "1,12", path = "right", fight = true},
		{map = "0,12", path = "right", fight = true},
		{map = "0,7", path = "bottom", fight = true},
		{map = "0,8", path = "bottom", fight = true},
		{map = "0,9", path = "bottom", fight = true},
		{map = "0,10", path = "bottom", fight = true},
		{map = "0,11", path = "bottom", fight = true},
		{map = "1,11", path = "top", fight = true},
		{map = "2,12", path = "top", fight = true},
		{map = "3,10", path = "bottom", fight = true},
		{map = "3,11", path = "right", fight = true},
		{map = "4,11", path = "right", fight = true},
		{map = "5,11", path = "right", fight = true},
		{map = "6,11", path = "right", fight = true},
		{map = "7,11", path = "top", fight = true},
		{map = "7,10", path = "left", fight = true},
		{map = "6,10", path = "top", fight = true},
		{map = "6,9", path = "top", fight = true},
		{map = "6,8", path = "left", fight = true},
		{map = "5,8", path = "bottom", fight = true},
		{map = "5,9", path = "bottom", fight = true},
		{map = "5,10", path = "left", fight = true},
		{map = "4,10", path = "top", fight = true},
		{map = "4,9", path = "top", fight = true},
		{map = "4,8", path = "left", fight = true},
		{map = "3,8", path = "bottom", fight = true},
		{map = "3,9", path = "left", fight = true},
		{map = "2,9", path = "top", fight = true},
		{map = "2,8", path = "top|left", fight = true},
		{map = "1,8", path = "bottom|left", fight = true},
		{map = "1,9", path = "bottom|left", fight = true},
		{map = "2,7", path = "left", fight = true},
		{map = "5,7", path = "bottom"},
		{map = "-1,-14", path = "right"},
		{map = "0,-15", path = "right"},
		{map = "1,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "4,-16", path = "top"},
		{map = "4,-17", path = "top"},
		{map = "4,-18", path = "top"},
		{map = "0,-14", path = "top"},
		{map = "1,-15", path = "top"},
		
		
	}
end

function bank()

	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("Banque_Herdegrise") then
            if not acc:isAccountConnected() then
                acc:connect()
            end
        end
    end

	if map:currentSubArea() ~= "Cité d'Astrub" then 
		return {
			{map = map:currentMapId(), lockedCustom = TPZaapAstrub},
		}
	end
	
    return {
	    {map = "-1,-14", path = "right"},
		{map = "0,-15", path = "right"},
		{map = "1,-15", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "2,-15", path = "top"},
		{map = "0,-14", path = "top"},
        {map = "4,-19", path = "bottom"},
        {map = "4,-18", path = "bottom"},
        {map = "4,-17", path = "bottom"},
        {map = "84674566", door = "303"},
		{map = "83887104", lockedCustom = luBank, path = "396"},

        }
end
