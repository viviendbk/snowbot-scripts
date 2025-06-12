GATHER = {}
OPEN_BAGS = false


MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {274}
AUTO_DELETE = {1974, 1984, 1775, 1770, 2557, 1773, 2556}

local DebutDeScript = true

local trajetscarafeuilledépartzaap1 = {
        {map = "4,29", path = "left", fight = false},
		{map = "0,24", path = "bottom", fight = false},
		{map = "0,25", path = "bottom", fight = false},
		{map = "0,26", path = "bottom", fight = false},
		{map = "0,27", path = "bottom", fight = false},
		{map = "0,28", path = "bottom", fight = false},
		{map = "0,29", path = "bottom", fight = false},
		{map = "0,30", path = "right", fight = false},
		{map = "-1,24", path = "right", fight = false},
		{map = "0,23", path = "left", fight = false},
		{map = "1,30", path = "top", fight = false},
		{map = "1,29", path = "top", fight = false},
		{map = "1,28", path = "top", fight = false},
		{map = "1,27", path = "top", fight = false},
		{map = "1,26", path = "top", fight = false},
		{map = "1,25", path = "top", fight = false},
		{map = "1,24", path = "right", fight = false},
		{map = "2,24", path = "bottom", fight = false},
		{map = "2,25", path = "bottom", fight = false},
		{map = "2,26", path = "bottom", fight = false},
		{map = "2,27", path = "bottom", fight = false},
		{map = "2,28", path = "bottom", fight = false},
		{map = "2,29", path = "bottom", fight = false},
		{map = "2,30", path = "bottom", fight = false},
		{map = "2,31", path = "bottom", fight = false},
		{map = "2,32", path = "right", fight = false},
		{map = "3,32", path = "right", fight = false},
		{map = "4,32", path = "right", fight = false},
		{map = "5,32", path = "top", fight = false},
		{map = "4,31", path = "left", fight = false},
		{map = "5,31", path = "left", fight = false},
		{map = "3,31", path = "top", fight = false},
		{map = "3,30", path = "right", fight = false},
		{map = "4,30", path = "right", fight = false},
		{map = "5,30", path = "top", fight = false},
		{map = "5,29", path = "top", fight = false},
		{map = "5,28", path = "left", fight = false},
		{map = "4,28", path = "bottom", fight = false},
		{map = "3,29", path = "top", fight = false},
		{map = "3,28", path = "top", fight = false},
		{map = "3,27", path = "right", fight = false},
		{map = "4,27", path = "top", fight = false},
		{map = "4,26", path = "left", fight = false},
		{map = "3,26", path = "top", fight = false},
		{map = "3,25", path = "top", fight = false},
		{map = "3,24", path = "top", fight = false},
		{map = "3,23", path = "top", fight = false},
		{map = "3,22", path = "left", fight = false},
		{map = "2,22", path = "bottom", fight = false},
		{map = "2,23", path = "left", fight = false},
		{map = "1,23", path = "left", fight = false},
		
		}
		
		
local trajetscarafeuillearrivéezaap2  = {
        {map = "-1,23", path = "bottom", fight = false},
		{map = "-1,24", path = "zaap(88082704)" },
		}
		

		
		
local prepartiechampa  = {
        {map = "10,9", path = "right", fight = false},
		{map = "8,10", path = "right", fight = false},
		{map = "9,10", path = "right", fight = false},
		{map = "10,10", path = "top", fight = false},
		{map = "11,9", path = "bottom", fight = false},
		{map = "11,10", path = "right", fight = false},
		{map = "12,10", path = "bottom", fight = false},
		{map = "12,11", path = "left", fight = false},
		{map = "11,11", path = "left", fight = false},
		{map = "10,11", path = "left", fight = false},
		{map = "5,7", path = "right"},
		{map = "6,7", path = "right"},
		{map = "7,7", path = "right"},
		{map = "8,7", path = "bottom"},
		{map = "8,8", path = "bottom"},
		{map = "8,9", path = "bottom"},
		{map = "9,11", path = "left", fight = false},
		
		}

local deuxpartiechampa  = {
	
        {map = "8,11", path = "top", fight = false},
		{map = "8,10", path = "top", fight = false},
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
	{Area = departastrub, NameSubArea = {"Cité d'Astrub","Le coin des Bouftous"}, MapSwitch = 88212481, Farmer = false},
	{Area = trajetscarafeuilledépartzaap1, NameSubArea = {"Plaine des Scarafeuilles"}, MapSwitch = 88212480, Farmer = false},
	{Area = trajetscarafeuillearrivéezaap2, NameSubArea = {"Plaine des Scarafeuilles","Le coin des Bouftous"}, MapSwitch = 88082704, Farmer = false},
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

function move()

	if DebutDeScript then
		DebutDeScript = false
		for i, element in ipairs(TableWhichArea) do
			for _, element2 in ipairs(element.NameSubArea) do
				if map:currentSubArea() == element2 then
					element.Farmer = true
					break
				end
			end
			if i == #TableWhichArea then
				TableWhichArea[1].Farmer = true
			end
		end
	end
	
	return WhichArea()
end