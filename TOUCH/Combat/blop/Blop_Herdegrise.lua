AUTO_DELETE = {1974, 1984, 1770, 1773}

MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}

local DeconnecterBotBanque = false
local StopAchatDD = false

local Trajet = {
		{map = "-28,-12", path = "top", fight = true},
		{map = "-28,-13", path = "left", fight = true},
		{map = "-29,-13", path = "top", fight = true},
		{map = "-29,-14", path = "top", fight = true},
		{map = "-29,-15", path = "top", fight = true},
		{map = "-29,-16", path = "top", fight = true},
		{map = "-29,-17", path = "top", fight = true},
		{map = "-29,-18", path = "top", fight = true},
		{map = "-30,-19", path = "top", fight = true},
		{map = "-29,-19", path = "left", fight = true},
		{map = "-30,-20", path = "top", fight = true},
		{map = "-30,-21", path = "top", fight = true},
		{map = "-30,-22", path = "top", fight = true},
		{map = "-30,-23", path = "top", fight = true},
		{map = "-30,-24", path = "top", fight = true},
		{map = "-30,-25", path = "top", fight = true},
		{map = "-30,-26", path = "top", fight = true},
		{map = "-30,-28", path = "top", fight = true},
		{map = "-30,-27", path = "top", fight = true},
		{map = "-30,-29", path = "top", fight = true},
		{map = "-30,-30", path = "right", fight = true},
		{map = "-29,-30", path = "right", fight = true},
		{map = "-28,-30", path = "top", fight = true},
		{map = "-28,-31", path = "top", fight = true},
		{map = "-28,-32", path = "top", fight = true},
		{map = "-28,-33", path = "top", fight = true},
		{map = "-28,-34", path = "right", fight = true},
		{map = "-27,-34", path = "right", fight = true},
		{map = "-26,-34", path = "bottom", fight = true},
		{map = "-26,-33", path = "left", fight = true},
		{map = "-27,-33", path = "bottom", fight = true},
		{map = "-27,-32", path = "bottom", fight = true},
		{map = "-27,-31", path = "bottom", fight = true},
		{map = "-27,-30", path = "bottom", fight = true},
		{map = "-27,-29", path = "left", fight = true},
		{map = "-28,-29", path = "left", fight = true},
		{map = "-29,-29", path = "bottom", fight = true},
		{map = "-29,-28", path = "right", fight = true},
		{map = "-28,-28", path = "bottom", fight = true},
		{map = "-28,-27", path = "left", fight = true},
		{map = "-29,-27", path = "bottom", fight = true},
		{map = "-29,-26", path = "right", fight = true},
		{map = "-28,-26", path = "bottom", fight = true},
		{map = "-28,-25", path = "left", fight = true},
		{map = "-29,-25", path = "bottom", fight = true},
		{map = "-29,-24", path = "right", fight = true},
		{map = "-28,-24", path = "bottom", fight = true},
		{map = "-28,-23", path = "left", fight = true},
		{map = "-29,-23", path = "bottom", fight = true},
		{map = "-29,-22", path = "bottom", fight = true},
		{map = "-29,-21", path = "bottom", fight = true},
		{map = "-29,-20", path = "right", fight = true},
		{map = "-28,-20", path = "right", fight = true},
		{map = "-27,-20", path = "bottom", fight = true},
		{map = "-27,-19", path = "left", fight = true},
		{map = "-28,-19", path = "bottom", fight = true},
		{map = "-28,-18", path = "right", fight = true},
		{map = "-27,-18", path = "bottom", fight = true},
		{map = "-27,-17", path = "left", fight = true},
		{map = "-28,-17", path = "bottom", fight = true},
		{map = "-28,-16", path = "right", fight = true},
		{map = "-27,-16", path = "bottom", fight = true},
		{map = "-27,-15", path = "left", fight = true},
		{map = "-28,-15", path = "bottom", fight = true},
		{map = "-28,-14", path = "right", fight = true},
		{map = "-27,-14", path = "bottom", fight = true},
		{map = "-27,-13", path = "bottom", fight = true},
		{map = "-27,-12", path = "left", fight = true},
		{map = "-20,-15", path = "left"},
		{map = "-21,-15", path = "left"},
		{map = "-22,-15", path = "left"},
		{map = "-23,-15", path = "left"},
		{map = "-24,-15", path = "left"},
		{map = "-25,-15", path = "left"},
		{map = "-26,-15", path = "left"},
		{map = "20,-21", path = "left"},
		{map = "-20,-19", path = "bottom"},
		{map = "-20,-20", path = "bottom"},
		{map = "-20,-18", path = "bottom"},
		{map = "-20,-17", path = "bottom"},
		{map = "-20,-16", path = "bottom"},
		{map = "-1,-14", path = "right"},
		{map = "0,-15", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "1,-16", path = "right"},
		{map = "0,-14", path = "top"},
		{map = "1,-15", path = "top"},
		{map = "4,-16", path = "top"},
		{map = "4,-18", path = "top"},
		{map = "4,-17", path = "top"},
		{map = "4,-19", path = "zaap(141588)"},

}

local function Equip()
	global:printSuccess("dab de panneau")
    developer:sendMessage('{"call":"sendMessage","data":{"type":"InventoryPresetUseMessage","data":{"presetId":0}}}')
end

function messagesRegistering()
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

    if myMount ~= nil and (myMount.energyMax - myMount.energy) > 1000 and not StopAchatDD and character:kamas() > 6000 then
        nourrirDD()
    end

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
	
	return treatMaps(Trajet)

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
        {map = "84674566", door = "303"},
		{map = "83887104", lockedCustom = luBank, path = "396"},

        }
end

function phenix()
	return {
		{map = "-18,-57", lockedCustom = function() map:door(172) global:delay(500) TpZaapAstrub() end},
	}
end

