AUTO_DELETE = {1974, 1984, 1770, 1773, 398}

MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {654,2427}
FORCE_MONSTERS = {}

local DeconnecterBotBanque = false
local DebutDeScript = true
local StopAchatDD = false

local trajetscarafeuilledépartzaap1 = {
        {map = "4,29", path = "left", fight = true},
		{map = "0,24", path = "bottom", fight = true},
		{map = "0,25", path = "bottom", fight = true},
		{map = "0,26", path = "bottom", fight = true},
		{map = "0,27", path = "bottom", fight = true},
		{map = "0,28", path = "bottom", fight = true},
		{map = "0,29", path = "bottom", fight = true},
		{map = "0,30", path = "right", fight = true},
		{map = "-1,24", path = "right", fight = true},
		{map = "0,23", path = "left", fight = true},
		{map = "1,30", path = "top", fight = true},
		{map = "1,29", path = "top", fight = true},
		{map = "1,28", path = "top", fight = true},
		{map = "1,27", path = "top", fight = true},
		{map = "1,26", path = "top", fight = true},
		{map = "1,25", path = "top", fight = true},
		{map = "1,24", path = "right", fight = true},
		{map = "2,24", path = "bottom", fight = true},
		{map = "2,25", path = "bottom", fight = true},
		{map = "2,26", path = "bottom", fight = true},
		{map = "2,27", path = "bottom", fight = true},
		{map = "2,28", path = "bottom", fight = true},
		{map = "2,29", path = "bottom", fight = true},
		{map = "2,30", path = "bottom", fight = true},
		{map = "2,31", path = "bottom", fight = true},
		{map = "2,32", path = "right", fight = true},
		{map = "3,32", path = "right", fight = true},
		{map = "4,32", path = "right", fight = true},
		{map = "5,32", path = "top", fight = true},
		{map = "4,31", path = "left", fight = true},
		{map = "5,31", path = "left", fight = true},
		{map = "3,31", path = "top", fight = true},
		{map = "3,30", path = "right", fight = true},
		{map = "4,30", path = "right", fight = true},
		{map = "5,30", path = "top", fight = true},
		{map = "5,29", path = "top", fight = true},
		{map = "5,28", path = "left", fight = true},
		{map = "4,28", path = "bottom", fight = true},
		{map = "3,29", path = "top", fight = true},
		{map = "3,28", path = "top", fight = true},
		{map = "3,27", path = "right", fight = true},
		{map = "4,27", path = "top", fight = true},
		{map = "4,26", path = "left", fight = true},
		{map = "3,26", path = "top", fight = true},
		{map = "3,25", path = "top", fight = true},
		{map = "3,24", path = "top", fight = true},
		{map = "3,23", path = "top", fight = true},
		{map = "3,22", path = "left", fight = true},
		{map = "2,22", path = "bottom", fight = true},
		{map = "2,23", path = "left", fight = true},
		{map = "1,23", path = "left", fight = true},
		
		}
		
		
local trajetscarafeuillearrivéezaap2  = {
        {map = "-1,23", path = "bottom", fight = true},
		{map = "-1,24", path = "zaap(88082704)" },
		}
		

		
		
local prepartiechampa  = {
        {map = "10,9", path = "right", fight = true},
		{map = "8,10", path = "right", fight = true},
		{map = "9,10", path = "right", fight = true},
		{map = "10,10", path = "top", fight = true},
		{map = "11,9", path = "bottom", fight = true},
		{map = "11,10", path = "right", fight = true},
		{map = "12,10", path = "bottom", fight = true},
		{map = "12,11", path = "left", fight = true},
		{map = "11,11", path = "left", fight = true},
		{map = "10,11", path = "left", fight = true},
		{map = "5,7", path = "right"},
		{map = "6,7", path = "right"},
		{map = "7,7", path = "right"},
		{map = "8,7", path = "bottom"},
		{map = "8,8", path = "bottom"},
		{map = "8,9", path = "bottom"},
		{map = "9,11", path = "left", fight = true},
		}

local deuxpartiechampa  = {
	
        {map = "8,11", path = "top", fight = true},
		{map = "8,10", path = "top", fight = true},
		{map = "8,9", path = "top"},
		{map = "8,8", path = "top"},
		{map = "8,7", path = "left"},
		{map = "7,7", path = "left"},
		{map = "6,7", path = "left"},
		{map = "5,7", path = "zaap(88212481)" },
		}
		
		
local departastrub  = {
	
	    {map = "4,-19", path = "zaap(88212481)" },

		}

local function TPZaapAstrub()
    npc:npcBuy()
	global:delay(500)
    sale:buyItem(548, 1, 500)
	global:delay(500)
    global:leaveDialog()
	global:delay(500)
    inventory:useItem(548)
end

local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 2
end

local TableWhichArea = {
	{Area = departastrub, NameSubArea = {"Cité d'Astrub"}, MapSwitch = 88212481, Farmer = false},
	{Area = trajetscarafeuilledépartzaap1, NameSubArea = {"Plaine des Scarafeuilles"}, MapSwitch = 88212480, Farmer = false},
	{Area = trajetscarafeuillearrivéezaap2, NameSubArea = {"Plaine des Scarafeuilles"}, MapSwitch = 88082704, Farmer = false},
	{Area = prepartiechampa, NameSubArea = {"Le champ des inglasses","Le coin des Bouftous","Clairière de Brouce Boulgour"}, MapSwitch = "8,11", Farmer = false},
	{Area = deuxpartiechampa, NameSubArea = {"Le champ des inglasses","Le coin des Bouftous","Clairière de Brouce Boulgour"}, MapSwitch = 88212481, Farmer = false},
}

local function treatMaps(maps)
    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end
	global:printSuccess("popo rappel")
	TPZaapAstrub()
end

function WhichArea()
    for i = 1, #TableWhichArea do
        if map:onMap(TableWhichArea[i].MapSwitch) and TableWhichArea[i].Farmer then
            TableWhichArea[i].Farmer = false
            TableWhichArea[IncrementTable(i, #TableWhichArea)].Farmer = true
            return treatMaps(TableWhichArea[IncrementTable(i, #TableWhichArea)].Area)
        elseif TableWhichArea[i].Farmer then
			global:printSuccess(i)
            return treatMaps(TableWhichArea[i].Area)
        end 
    end
end


local function luBank() -- Le nom de notre fonction
	chat:sendPrivateMessage("meganecoeurdemavie","Beniix-Mitty")
	
	while not exchange:launchExchangeWithPlayer(2917425) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(2000)
    end
	
  	exchange:putAllItemsExchange() -- La fonction pour déposer tous les objets de l'inventaire
  	exchange:ready() -- La fonction pour valider l'échange

	DeconnecterBotBanque = true
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

end

local function Equip()
    developer:sendMessage('{"call":"sendMessage","data":{"type":"InventoryPresetUseMessage","data":{"presetId":0}}}')
end

function move()

	if DebutDeScript then

		developer:sendMessage('{"call":"sendMessage","data":{"type":")InventoryPresetSaveMessage","data":{"presetId":0,"symbolId":0,"saveEquipment":true}}}')
		DebutDeScript = false
		for i, element in ipairs(TableWhichArea) do
			for _, element2 in ipairs(element.NameSubArea) do
				if map:currentSubArea() == element2 then
					for _, element3 in ipairs(element.Area) do
						if map:onMap(element3.map) then
							element.Farmer = true
							break
						end
					end
					TableWhichArea[i + 1].Farmer = true
					break
				end
			end
			if element.Farmer then
				break
			end
			if i == #TableWhichArea then
				global:printSuccess("dab inversé")
				TableWhichArea[1].Farmer = true
			end
		end
	end
	
	local myMount = mount:myMount()
	
	if myMount ~= nil and (myMount.energyMax - myMount.energy) > 1000 and not StopAchatDD and character:kamas() > 6000 then
		nourrirDD()
	end
	
	if DeconnecterBotBanque then
		for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
			if acc:getAlias():find("BanqueDodge") then
				if acc:isAccountConnected() then
					DeconnecterBotBanque = false
					acc:disconnect()
				end
			end
		end
	end
	
	return WhichArea()	
end

function messagesRegistering()
    developer:registerMessage("GameFightEndMessage", Equip)
end

function bank()

	StopAchatDD = false
	
	for _, element in ipairs(TableWhichArea) do
		element.Farmer = false
	end
	TableWhichArea[1].Farmer = true
	
	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("BanqueDodge") then
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
        {map = "84674566", door = "303"},
		{map = "83887104", lockedCustom = luBank, path = "396"},

        }
end
