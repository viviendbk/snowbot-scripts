---@diagnostic disable: undefined-global, lowercase-global

local FightDone = false
local EquipementFini = false

local tableEquip = {
	{Type = "amulette", Id = 7250, Emplacement = 0},
	{Type = "centure", Id = 7238, Emplacement = 3},
	{Type = "cape", Id = 7230, Emplacement = 7},
	{Type = "bottes", Id = 7242, Emplacement = 5},
	{Type = "coiffe", Id = 7226, Emplacement = 6},
	{Type = "anneauDroit", Id = 7246, Emplacement = 4}, 
    {Type = "arme", Id = 7254, Emplacement = 1}, 
}

local function LaunchFight()
    FightDone = true
    npc:npc(434, 3)
    npc:reply(-1)
    npc:reply(-2)
    npc:reply(-1)
end

local function Equip()
	EquipementFini = true
	for _,element in ipairs(tableEquip) do
		inventory:equipItem(element.Id, element.Emplacement)
	end
end

local function AchatSortAndRestat()
    npc:npc(434, 3)
    npc:reply(-3)
    npc:reply(-2)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
    global:leaveDialog()

    --augmenter 200 chance et le reste en vita

    global:editAlias(global:thisAccountController():getAlias() .. " [GROUPE]")
    global:finishScript()
    --global:thisAccountController():unloadAccount()
end

function move()
    if not EquipementFini then
        Equip()
    end

    if FightDone then
        return {{map = "17047554", custom = AchatSortAndRestat}}
    end
    return {
        {map = "1,-8", path = "444"},
        { map = "4,-18", path = "bottom" },
        { map = "4,-17", path = "bottom" },
        { map = "4,-19", path = "bottom" },
        {map = "83887104", path = "396"},
        {map = "84674566", path = "bottom"},
        { map = "4,-15", path = "bottom(555)" },
        { map = "4,-14", path = "bottom" },
        { map = "4,-13", path = "bottom" },
        { map = "4,-12", path = "bottom" },
        { map = "4,-11", path = "bottom" },
        { map = "4,-10", path = "left" },
        { map = "3,-10", path = "left" },
        { map = "2,-10", path = "bottom" },
        { map = "2,-9", path = "bottom" },
        { map = "2,-8", path = "left" },
        { map = "1,-7", path = "bottom" },
        { map = "1,-6", path = "bottom" },
        { map = "1,-5", path = "bottom" },
        { map = "1,-4", path = "bottom" },
        { map = "1,-3", path = "bottom" },
        { map = "1,-2", path = "bottom" },
        { map = "1,-1", path = "bottom" },
        { map = "1,0", path = "bottom" },
        { map = "1,1", path = "bottom" },
        { map = "1,2", path = "bottom" },
        { map = "1,3", path = "bottom" },
        { map = "5,-22", path = "left" },
        { map = "5,-21", path = "left" },
        { map = "5,-20", path = "left" },
        { map = "6,-21", path = "left" },
        { map = "7,-21", path = "left" },
        { map = "7,-20", path = "left" },
        { map = "6,-20", path = "left" },
        { map = "6,-19", path = "left" },
        { map = "5,-19", path = "left" },
        { map = "7,-19", path = "left" },
        { map = "5,-18", path = "left" },
        { map = "6,-18", path = "left" },
        { map = "7,-18", path = "left" },
        { map = "7,-17", path = "left" },
        { map = "6,-17", path = "left" },
        { map = "5,-17", path = "left" },
        { map = "5,-16", path = "left" },
        { map = "6,-16", path = "left" },
        { map = "7,-16", path = "left" },
        { map = "7,-15", path = "left" },
        { map = "5,-15", path = "left" },
        { map = "6,-15", path = "left" },
        { map = "0,-22", path = "right" },
        { map = "-1,-21", path = "right" },
        { map = "0,-21", path = "right" },
        { map = "-1,-20", path = "right" },
        { map = "-1,-19", path = "right" },
        { map = "-1,-18", path = "right" },
        { map = "-1,-17", path = "right" },
        { map = "-1,-16", path = "right" },
        { map = "-1,-15", path = "right" },
        { map = "-1,-14", path = "right" },
        { map = "0,-14", path = "right" },
        { map = "0,-15", path = "right" },
        { map = "1,-15", path = "right" },
        { map = "1,-14", path = "right" },
        { map = "2,-14", path = "right" },
        { map = "2,-15", path = "right" },
        { map = "2,-16", path = "right" },
        { map = "1,-16", path = "right" },
        { map = "0,-16", path = "right" },
        { map = "0,-17", path = "right" },
        { map = "1,-17", path = "right" },
        { map = "2,-17", path = "right" },
        { map = "3,-17", path = "right" },
        { map = "3,-16", path = "right" },
        { map = "3,-15", path = "right" },
        { map = "3,-14", path = "top" },
        { map = "0,-18", path = "right" },
        { map = "1,-18", path = "right" },
        { map = "2,-18", path = "right" },
        { map = "3,-18", path = "right" },
        { map = "0,-19", path = "right" },
        { map = "1,-19", path = "right" },
        { map = "2,-19", path = "right" },
        { map = "3,-19", path = "right" },
        { map = "3,-20", path = "right" },
        { map = "2,-20", path = "right" },
        { map = "1,-20", path = "right" },
        { map = "0,-20", path = "right" },
        { map = "1,-21", path = "right" },
        { map = "1,-22", path = "right" },
        { map = "2,-22", path = "right" },
        { map = "3,-22", path = "right" },
        { map = "3,-21", path = "right" },
        { map = "2,-21", path = "right" },
        { map = "4,-22", path = "bottom" },
        { map = "4,-21", path = "bottom" },
        { map = "4,-20", path = "bottom" },
        {map = "88080660", door = "356"},
        {map = "17047556", path = "429"},
        {map = "17047554", custom = LaunchFight}
    }

end

function bank()
    return move()
end