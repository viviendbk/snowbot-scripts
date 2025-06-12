GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = { 1734 }

MAX_MONSTERS = 4

MIN_MONSTERS = 2

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}
		
local scriptPath ="C:\\Users\\Administrator\\Documents\\Script touch dab\\de astrub aux bouftous.lua"

			
function move()

	if character:level() >= 43 then
		global:loadAndStart(scriptPath)
	end

    return {
		{map = "-1,-14", fight = true, path = "top"},
		{map = "-1,-15", fight = true, path = "top"},
		{map = "-1,-16", fight = true, path = "top"},
		{map = "-1,-17", fight = true, path = "top"},
		{map = "-1,-18", fight = true, path = "top"},
		{map = "-1,-19", fight = true, path = "top"},
		{map = "-1,-20", fight = true, path = "right"},
		{map = "0,-20", fight = true, path = "right"},
		{map = "1,-20", fight = true, path = "right"},
		{map = "2,-20", fight = true, path = "right"},
		{map = "3,-20", fight = true, path = "right"},
		{map = "4,-20", fight = true, path = "right"},
		{map = "5,-20", fight = true, path = "right"},
		{map = "6,-20", fight = true, path = "bottom"},
		{map = "6,-19", fight = true, path = "bottom"},
		{map = "6,-18", fight = true, path = "bottom"},
		{map = "6,-17", fight = true, path = "bottom"},
		{map = "6,-16", fight = true, path = "left"},
		{map = "5,-16", fight = true, path = "left"},
		{map = "4,-16", fight = true, path = "left"},
		{map = "3,-16", fight = true, path = "bottom"},
		{map = "3,-15", fight = true, path = "left"},
		{map = "2,-15", fight = true, path = "left"},
		{map = "1,-15", fight = true, path = "left"},
		{map = "0,-15", fight = true, path = "bottom"},
		{map = "0,-14", fight = true, path = "left"},
		
		}
end