---@diagnostic disable: undefined-global, lowercase-global
GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = { 1734 }

MAX_MONSTERS = 2

MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}
		
local Alias = global:thisAccountController():getAlias()

local tableVente = {
	{Name = "Plume de Piou Rouge", Id = 6900},
	{Name = "Plume de Piou Jaune", Id = 6902},
	{Name = "Plume de Piou Vert", Id = 6899},
	{Name = "Plume de Piou Bleu", Id = 6897},
	{Name = "Plume de Piou Violet", Id = 6898},
	{Name = "Plume de Piou Rose", Id = 6903},
    {Name = "Graine de sésame", Id = 287}
}	

local tableEquip = {
	{Type = "amulette", Id = 2478, Emplacement = 0, Price = 0},
	{Type = "ceinture", Id = 2477, Emplacement = 3, Price = 0},
	{Type = "cape", Id = 2473, Emplacement = 7, Price = 0},
	{Type = "bottes", Id = 2476, Emplacement = 5, Price = 0},
	{Type = "coiffe", Id = 2474, Emplacement = 6, Price = 0},
	{Type = "anneauGauche", Id = 2475, Emplacement = 2, Price = 0},
}

local function Sell()
    npc:npcSale()

    for _, element in ipairs(tableVente) do
		if inventory:itemCount(element.Id) >= 100 then
			Priceitem = sale:getPriceItem(element.Id, 3) 
			if Priceitem > 10 then -- 
				while ((inventory:itemCount(element.Id) >= 100) and (sale:AvailableSpace() > 0)) do 
					sale:SellItem(element.Id, 100, Priceitem -1) 
					global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem -1 .. "kamas")
				end 
			end
        end
        if inventory:itemCount(element.Id) >= 10 then
			Priceitem = sale:getPriceItem(element.Id, 2) 
			if Priceitem > 10 then -- 
				while ((inventory:itemCount(element.Id) >= 10) and (sale:AvailableSpace() > 0)) do 
					sale:SellItem(element.Id, 10, Priceitem -1) 
					global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem -1 .. "kamas")
				end 
			end
        end
    end

    global:leaveDialog()
end

local function PanneauBuy()
    npc:npcBuy()

    for _, element in ipairs(tableEquip) do
        if inventory:itemCount(element.Id) == 0 then
            sale:buyItem(element.Id, 1, 2000)
        else
            StopBuying = true
        end
    end

    global:leaveDialog()

	for _,element in ipairs(tableEquip) do
		if inventory:itemCount(element.Id) > 0 then
			inventory:equipItem(element.Id, element.Emplacement)
		end
	end

end

function move()

    if character:level() > 43 then
        Sell()
        global:editAlias(Alias .. " [DOPEUL]", true)
        tableTeam = global:thisAccountController():getTeamAccounts()
        for _, element in ipairs(tableTeam) do
            element.global:editAlias(Alias .. " [DOPEUL]", true)
        end
        global:finishScript()
    end

    MAX_MONSTERS = character:level() < 10 and 1 or character:level() < 15 and 2 or character:level() < 20 and 3 or 4
    MIN_MONSTERS = character:level() < 15 and 1 or character:level() < 25 and 2 or 3 
    
    if character:level() >= 9 and inventory:itemCount(2474) == 0 and not StopBuying then
        return {{map = map:currentMapId(), lockedCustom = PanneauBuy, path = "top|left|right|bottom"}}
    end

    return {
		{map = "-5,-1", path = "bottom"},
		{map = "-4,0", path = "right"},
		{map = "-3,1", path = "right"},
		{map = "-2,2", path = "bottom"},
		{map = "0,3", path = "right"},
		{map = "1,3", path = "right"},
		{map = "2,3", path = "right"},
		{map = "3,3", path = "right"},
		{map = "4,3", path = "right"},
		{map = "6,3", path = "right"},
		{map = "5,3", path = "right"},
		{map = "7,3", path = "right"},
		{map = "8,3", path = "right"},
        {map = "9,3", lockedCustom = GoToAstrub},

        { map = "2,-13", path = "right" },
        { map = "3,-13", path = "right" },
        { map = "4,-13", path = "top" },
        { map = "4,-14", path = "top" },
        { map = "-1,-14", path = "top", fight = true },
        { map = "0,-14", path = "left", fight = true },
        { map = "-1,-15", path = "top", fight = true },
        { map = "-1,-16", path = "top", fight = true },
        { map = "-1,-17", path = "top", fight = true },
        { map = "-1,-18", path = "top", fight = true },
        { map = "-1,-19", path = "top", fight = true },
        { map = "-1,-20", path = "top", fight = true },
        { map = "-1,-21", path = "right", fight = true },
        { map = "0,-21", path = "top", fight = true },
        { map = "0,-22", path = "right", fight = true },
        { map = "1,-22", path = "right", fight = true },
        { map = "2,-22", path = "right", fight = true },
        { map = "3,-22", path = "right", fight = true },
        { map = "4,-22", path = "right", fight = true },
        { map = "5,-22", path = "bottom", fight = true },
        { map = "5,-21", path = "right", fight = true },
        { map = "6,-21", path = "right", fight = true },
        { map = "7,-21", path = "bottom", fight = true },
        { map = "7,-20", path = "left", fight = true },
        { map = "6,-20", path = "left", fight = true },
        { map = "5,-20", path = "left", fight = true },
        { map = "4,-20", path = "top", fight = true },
        { map = "4,-21", path = "left", fight = true },
        { map = "3,-21", path = "left", fight = true },
        { map = "2,-21", path = "left", fight = true },
        { map = "1,-21", path = "bottom", fight = true },
        { map = "1,-20", path = "left", fight = true },
        { map = "0,-20", path = "bottom", fight = true },
        { map = "0,-19", path = "bottom", fight = true },
        { map = "0,-18", path = "bottom", fight = true },
        { map = "0,-17", path = "bottom", fight = true },
        { map = "0,-16", path = "bottom", fight = true },
        { map = "0,-15", path = "right", fight = true },
        { map = "1,-15", path = "bottom", fight = true },
        { map = "1,-14", path = "right", fight = true },
        { map = "2,-14", path = "top", fight = true },
        { map = "2,-15", path = "top", fight = true },
        { map = "2,-16", path = "left", fight = true },
        { map = "1,-16", path = "top", fight = true },
        { map = "1,-17", path = "right", fight = true },
        { map = "2,-17", path = "right", fight = true },
        { map = "3,-17", path = "bottom", fight = true },
        { map = "3,-16", path = "bottom", fight = true },
        { map = "3,-15", path = "right", fight = true },
        { map = "4,-15", path = "right(223)", fight = true },
        { map = "5,-15", path = "right", fight = true },
        { map = "6,-15", path = "right", fight = true },
        { map = "7,-15", path = "top", fight = true },
        { map = "7,-16", path = "left", fight = true },
        { map = "6,-16", path = "left", fight = true },
        { map = "5,-16", path = "left", fight = true },
        { map = "4,-16", path = "top", fight = true },
        { map = "4,-17", path = "right", fight = true },
        { map = "5,-17", path = "right", fight = true },
        { map = "6,-17", path = "right", fight = true },
        { map = "7,-17", path = "top", fight = true },
        { map = "7,-18", path = "left", fight = true },
        { map = "6,-18", path = "left", fight = true },
        { map = "5,-18", path = "left", fight = true },
        { map = "4,-18", path = "left", fight = true },
        { map = "3,-18", path = "left", fight = true },
        { map = "2,-18", path = "left", fight = true },
        { map = "1,-18", path = "top", fight = true },
        { map = "1,-19", path = "right", fight = true },
        { map = "2,-19", path = "top", fight = true },
        { map = "2,-20", path = "right", fight = true },
        { map = "3,-19", path = "right", fight = true },
        { map = "3,-20", path = "bottom", fight = true },
        { map = "4,-19", path = "right" },
        { map = "5,-19", path = "right", fight = true },
        { map = "6,-19", path = "right", fight = true },
        { map = "7,-19", path = "top", fight = true },
		
		}
end

function bank()
    Sell()
    return move()
end

function GoToAstrub()
    npc:npc(888, 3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
end

function phenix()
    return{
        {map = "2,-12", custom = function() map:door(272) map:changeMap("top") end }
    }
end