---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")


AUTO_DELETE = {16821, 2467, 881, 2574, 2453, 393, 16824, 8680, 13487, 13494, 641, 374, 306, 2663, 2659, 2661, 2662, 16832,16828, 1681, 8537, 8536, 8534, 8533, 8532, 1356, 2587, 16440, 16489, 8538, 312, 303, 421, 289, 16525, 16524, 310, 16834, 2477, 8245, 8248, 10967, 311, 16512, 367, 16515, 1984, 2475, 16518, 16504, 2473, 16522, 16522, 16513, 519, 16503, 2478, 16523, 290, 16511, 385, 16505, 2476, 17168, 16670, 6929, 6928, 6927, 6926, 8221, 8241, 8236, 8217, 8229,  8223, 8247, 16830, 16825,16831, 8219, 19679, 13526, 9679, 351, 8145, 6857, 8246 ,450, 16829 ,643 ,7423,394 , 6909 ,6908 ,6910 ,16823,287, 8213, 8214, 8215, 8216, 8218, 8220, 8222, 8224, 8225, 8226, 8227, 8228, 8230, 8231, 8232, 8233, 8234, 8235, 8237, 8238, 8239, 8240, 8242, 8243, 8244}
GATHER = {}


if server == "Tal" then
	server = "Tal Kasha"
elseif server == "Hell" then
	server = "Hell Mina"
end

local pathDebug = {
	{map = "9,-18", path = "left"},
	{map = "8,-18", custom = function ()
		debugPath = false
		map:changeMap("top")
	end},
	{map = "9,-17", path = "left"},
	{map = "8,-17", custom = function ()
		debugPath = false
		map:changeMap("top")
	end}
}

local RouteDesAmes = {
		{ map = "153093378", path = "right", gather = false, fight = false }, -- 152045573
	{ map = "153092354", door = 409},
	{ map = "152045573", path = "right", gather = false, fight = false }, -- 152045573
	{ map = "152043521", path = "right", gather = false, fight = false }, -- 152045573
	{ map = "152046597", path = "right", gather = false, fight = false }, -- 152045573	
	{map = "-2,-3", path = "right", fight = true},
	{map = "-1,-3", path = "right", fight = true},
	{map = "0,-3", path = "right", fight = true},
	{map = "1,-3", path = "right", fight = true},
	{map = "2,-3", path = "right", fight = true},
	{map = "3,-3", path = "top", fight = true},
	{map = "4,-3", path = "top", fight = true},
	{map = "4,-4", path = "left"},
	{map = "3,-4", path = "left"},
	{map = "2,-4", path = "left"},
	{map = "1,-4", path = "left"},
	{map = "0,-4", path = "left"},
	{map = "-1,-4", path = "left"},
	{map = "-2,-4", path = "bottom"},
}

local Paturages = {
	{map = "-2,-3", path = "right"},
	{map = "-1,-3", path = "right"},
	{map = "0,-3", path = "right"},
	{map = "-3,-5", path = "right"},
	{map = "-2,-5", path = "right"},
	{map = "-1,-5", path = "right"},
	{map = "-2,-4", path = "right"},
	{map = "-1,-4", path = "right"},
	{map = "-3,-6", path = "right"},
	{map = "-2,-6", path = "right"},
	{map = "0,-4", path = "right"},
	{map = "-1,-6", path = "bottom"},
	{map = "0,-5", path = "bottom"},
	{map = "1,-3", path = "top"},
	{map = "1,-4", path = "top", fight = true},
	{map = "1,-5", path = "right", fight = true},
	{map = "2,-5", path = "right", fight = true},
	{map = "3,-5", path = "bottom", fight = true},
	{map = "3,-4", path = "left", fight = true},
	{map = "2,-4", path = "left", fight = true},
}

local Champs_Astrub = {
	{map = "7,-22", path = "left", fight = true},
	{map = "6,-22", path = "left", fight = true},
	{map = "5,-22", path = "left", fight = true},
	{map = "7,-24", path = "left", fight = true},
	{map = "6,-24", path = "left", fight = true},
	{map = "5,-24", path = "left", fight = true},
	{map = "7,-26", path = "left", fight = true},
	{map = "5,-26", path = "left", fight = true},
	{map = "6,-26", path = "left", fight = true},
	{map = "4,-22", path = "top", fight = true},
	{map = "7,-23", path = "top", fight = true},
	{map = "4,-24", path = "top", fight = true},
	{map = "7,-25", path = "top", fight = true},
	{map = "3,-26", path = "bottom", fight = true},
	{map = "3,-25", path = "bottom", fight = true},
	{map = "3,-24", path = "bottom", fight = true},
	{map = "3,-23", path = "bottom", fight = true},
	{map = "3,-22", path = "right", fight = true},
	{map = "4,-23", path = "right", fight = true},
	{map = "5,-23", path = "right", fight = true},
	{map = "6,-23", path = "right", fight = true},
	{map = "4,-25", path = "right", fight = true},
	{map = "5,-25", path = "right", fight = true},
	{map = "6,-25", path = "right", fight = true},
	{map = "4,-26", path = "left", fight = true},

	{map = "101715461", door = "175"},
	{map = "101715463", path = "121"},
	{map = "192415750", path = "409"},
	{map = "188484100", door = "155"},
	{map = "188483076", door = "476"},
	{map = "188482052", door = "532"},
	{map = "101713409", door = "160"},
	{map = "101713411", path = "138"},
	{map = "101712387", path = "474"}
}

local Champs = {
	{map = "3,-4", path = "bottom"},
	{ map = "153092354", door = 409},
  	{ map = "152045573", path = "right", gather = false, fight = false }, -- 152045573
  	{ map = "152043521", path = "right", gather = false, fight = false }, -- 152045573
  	{ map = "152046597", path = "right", gather = false, fight = false }, -- 152045573	
	{map = "5,-14", path = "right"},
	{map = "6,-14", path = "right"},
	{map = "7,-14", path = "right"},
	{map = "8,-14", path = "bottom"},
	{map = "8,-13", path = "left|right"},
	{map = "7,-13", path = "left|right"},
	{map = "6,-13", path = "left|right"},
	{map = "5,-13", path = "left|right"},
	{map = "4,-13", path = "right"},
	{map = "9,-13", path = "right"},
	{map = "-2,-3", path = "top"},
	{map = "-2,-4", path = "right", fight = true},
	{map = "-1,-4", path = "right", fight = true},
	{map = "0,-4", path = "top", fight = true},
	{map = "0,-5", path = "left", fight = true},
	{map = "-1,-6", path = "left", fight = true},
	{map = "-2,-6", path = "left", fight = true},
	{map = "-3,-6", path = "bottom", fight = true},
	{map = "-3,-5", path = "right", fight = true},
	{map = "-2,-5", path = "bottom", fight = true},
	{map = "-1,-5", path = "top", fight = true},
	{map = "4,-3", path = "left"},
	{map = "2,-3", path = "left"},
	{map = "3,-3", path = "left"},
	{map = "1,-3", path = "left"},
	{map = "0,-3", path = "left"},
	{map = "-1,-3", path = "left"},
	{map = "4,-4", path = "left"},
	{map = "2,-4", path = "left"},
	{map = "1,-4", path = "left"},
}

local Foret_Astrub = {
	{map = "0,-15", path = "left", fight = true},
	{map = "-1,-15", path = "left", fight = true},
	{map = "-2,-15", path = "left", fight = true},
	{map = "-1,-17", path = "left", fight = true},
	{map = "-2,-17", path = "left", fight = true},
	{map = "-1,-19", path = "left", fight = true},
	{map = "-2,-19", path = "left", fight = true},
	{map = "-1,-21", path = "left", fight = true},
	{map = "-2,-21", path = "left", fight = true},
	{map = "-3,-15", path = "top", fight = true},
	{map = "-1,-16", path = "top", fight = true},
	{map = "-3,-17", path = "top", fight = true},
	{map = "-1,-18", path = "top", fight = true},
	{map = "-3,-19", path = "top", fight = true},
	{map = "-1,-20", path = "top", fight = true},
	{map = "-3,-21", path = "top", fight = true},
	{map = "-2,-22", path = "top", fight = true},
	{map = "-3,-22", path = "right", fight = true},
	{map = "-3,-20", path = "right", fight = true},
	{map = "-2,-20", path = "right", fight = true},
	{map = "-3,-18", path = "right", fight = true},
	{map = "-2,-18", path = "right", fight = true},
	{map = "-3,-16", path = "right", fight = true},
	{map = "-2,-16", path = "right", fight = true},
	{map = "-2,-23", path = "top", fight = true},
	{map = "-2,-24", path = "top", fight = true},
	{map = "-2,-25", path = "top", fight = true},
	{map = "-2,-26", path = "top", fight = true},
	{map = "-2,-27", path = "top", fight = true},
	{map = "-2,-28", path = "right", fight = true},
	{map = "-1,-28", path = "right", fight = true},
	{map = "0,-28", path = "right", fight = true},
	{map = "1,-28", path = "right", fight = true},
	{map = "-1,-26", path = "right", fight = true},
	{map = "0,-26", path = "right", fight = true},
	{map = "1,-26", path = "right", fight = true},
	{map = "-1,-24", path = "right", fight = true},
	{map = "0,-24", path = "right", fight = true},
	{map = "1,-24", path = "right", fight = true},
	{map = "2,-28", path = "bottom", fight = true},
	{map = "-1,-27", path = "bottom", fight = true},
	{map = "2,-26", path = "bottom", fight = true},
	{map = "-1,-25", path = "bottom", fight = true},
	{map = "2,-24", path = "bottom", fight = true},
	{map = "2,-27", path = "left", fight = true},
	{map = "1,-27", path = "left", fight = true},
	{map = "0,-27", path = "left", fight = true},
	{map = "2,-25", path = "left", fight = true},
	{map = "1,-25", path = "left", fight = true},
	{map = "0,-25", path = "left", fight = true},
	{map = "2,-22", path = "left", fight = true},
	{map = "1,-23", path = "left", fight = true},
	{map = "0,-23", path = "left", fight = true},
	{map = "-1,-23", path = "bottom", fight = true},
	{map = "2,-23", path = "bottom", fight = true},
	{map = "1,-22", path = "top", fight = true},
	{map = "-1,-22", path = "right", fight = true},
	{map = "0,-22", path = "bottom", fight = true},
	{map = "0,-21", path = "bottom", fight = true},
	{map = "0,-20", path = "bottom", fight = true},
	{map = "0,-18", path = "bottom", fight = true},
	{map = "0,-19", path = "bottom", fight = true},
	{map = "0,-17", path = "bottom", fight = true},
	{map = "0,-16", path = "bottom", fight = true},

	{map = "101717512", path = "322"},
	{map = "101715461", door = "175"},
    {map = "101716487", path = "266"},
    {map = "101715463", path = "121"},
	{map = "101715465", path = "278"},
	{map = "101716489", path = "249"},
	{map = "192415750", path = "409"},

}

local PrairiesAstrub = {

	{map = "7,-26", path = "bottom"},
	{map = "6,-26", path = "bottom"},
	{map = "5,-26", path = "bottom"},
	{map = "4,-26", path = "bottom"},
	{map = "3,-26", path = "bottom"},
	{map = "3,-25", path = "bottom"},
	{map = "3,-24", path = "bottom"},
	{map = "4,-24", path = "bottom"},
	{map = "4,-25", path = "bottom"},
	{map = "5,-25", path = "bottom"},
	{map = "5,-24", path = "bottom"},
	{map = "6,-24", path = "bottom"},
	{map = "6,-25", path = "bottom"},
	{map = "7,-25", path = "bottom"},
	{map = "7,-24", path = "bottom"},
	{map = "7,-23", path = "bottom"},
	{map = "7,-22", path = "bottom"},
	{map = "6,-22", path = "bottom"},
	{map = "6,-23", path = "bottom"},
	{map = "5,-23", path = "bottom"},
	{map = "5,-22", path = "bottom"},
	{map = "4,-22", path = "bottom"},
	{map = "4,-23", path = "bottom"},
	{map = "3,-23", path = "bottom"},
	{map = "3,-22", path = "bottom"},

	{map = "7,-21", path = "bottom"},
	{map = "7,-20", path = "bottom"},
	{map = "7,-19", path = "bottom"},
	{map = "7,-18", path = "bottom"},
	{map = "7,-17", path = "bottom"},
	{map = "7,-16", path = "bottom"},
	{map = "7,-15", path = "bottom"},
	{map = "6,-15", path = "bottom"},
	{map = "6,-16", path = "bottom"},
	{map = "6,-21", path = "bottom"},
	{map = "5,-21", path = "bottom"},
	{map = "4,-21", path = "bottom"},
	{map = "3,-21", path = "bottom"},
	{map = "2,-21", path = "bottom"},
	{map = "2,-20", path = "bottom"},
	{map = "2,-19", path = "bottom"},
	{map = "2,-18", path = "bottom"},
	{map = "2,-17", path = "bottom"},
	{map = "2,-16", path = "bottom"},
	{map = "5,-19", path = "bottom"},
	{map = "4,-19", path = "bottom"},
	{map = "3,-19", path = "bottom"},
	{map = "1,-19", path = "bottom"},
	{map = "1,-20", path = "bottom"},
	{map = "1,-18", path = "bottom"},
	{map = "1,-17", path = "bottom"},
	{map = "1,-16", path = "bottom"},
	{map = "3,-16", path = "bottom"},
	{map = "4,-16", path = "bottom"},
	{map = "5,-16", path = "bottom"},
	{map = "5,-18", path = "bottom"},
	{map = "5,-17", path = "bottom"},
	{map = "4,-20", path = "bottom"},
	{map = "6,-20", path = "left"},
	{map = "5,-20", path = "left"},
	{map = "3,-20", path = "left"},
	{map = "6,-18", path = "left"},
	{map = "6,-17", path = "left"},
	{map = "6,-19", path = "left"},
	{map = "3,-18", path = "right"},
	{map = "4,-18", path = "right"},
	{map = "3,-17", path = "right"},
	{map = "4,-17", path = "right"},
	{map = "1,-15", path = "right"},
	{map = "2,-15", path = "right"},
	{map = "5,-15", path = "bottom"},
	{map = "4,-15", path = "bottom"},
	{map = "3,-15", path = "bottom"},
	{map = "3,-14", path = "right", fight = true},
	{map = "4,-14", path = "right", fight = true},
	{map = "5,-14", path = "right", fight = true},
	{map = "6,-14", path = "right", fight = true},
	{map = "7,-14", path = "right", fight = true},
	{map = "8,-14", path = "right", fight = true},
	{map = "9,-14", path = "right", fight = true},
	{map = "10,-14", path = "bottom", fight = true},
	{map = "10,-13", path = "left", fight = true},
	{map = "9,-13", path = "left", fight = true},
	{map = "8,-13", path = "left", fight = true},
	{map = "7,-13", path = "left", fight = true},
	{map = "6,-13", path = "left", fight = true},
	{map = "5,-13", path = "left", fight = true},
	{map = "4,-13", path = "bottom", fight = true},
	{map = "4,-12", path = "right", fight = true},
	{map = "5,-12", path = "right", fight = true},
	{map = "6,-12", path = "right", fight = true},
	{map = "8,-12", path = "right", fight = true},
	{map = "7,-12", path = "right", fight = true},
	{map = "9,-12", path = "right", fight = true},
	{map = "10,-12", path = "bottom", fight = true},
	{map = "10,-11", path = "left", fight = true},
	{map = "9,-11", path = "left", fight = true},
	{map = "8,-11", path = "left", fight = true},
	{map = "7,-11", path = "left", fight = true},
	{map = "6,-11", path = "left", fight = true},
	{map = "5,-11", path = "left", fight = true},
	{map = "4,-11", path = "bottom", fight = true},
	{map = "4,-10", path = "right", fight = true},
	{map = "5,-10", path = "right", fight = true},
	{map = "6,-10", path = "right", fight = true},
	{map = "7,-10", path = "right", fight = true},
	{map = "8,-10", path = "right", fight = true},
	{map = "9,-10", path = "bottom", fight = true},
	{map = "9,-9", path = "left", fight = true},
	{map = "8,-9", path = "left", fight = true},
	{map = "7,-9", path = "left", fight = true},
	{map = "6,-9", path = "left", fight = true},
	{map = "5,-9", path = "left", fight = true},
	{map = "4,-9", path = "left", fight = true},
	{map = "3,-9", path = "top", fight = true},
	{map = "3,-10", path = "top", fight = true},
	{map = "3,-11", path = "top", fight = true},
	{map = "3,-12", path = "top", fight = true},
	{map = "3,-13", path = "top", fight = true},
	{map = "192415750", path = "409"},
}

local Souterrain_Astrub1 = {
	{map = "188743685", door = "400"},
	{map = "188482052", door = "153", fight = true},
	{map = "188483076", door = "362", fight = true},
	{map = "188484100", door = "373", fight = true},
	{map = "101713409", path = "493", fight = true},
	{map = "101713411", custom = function() souterrain2 = true map:moveToCell(183) end, fight = true},
	--{map = "101712387", path = "474"},
			{map = "192415750", path = "409"},

}

local Souterrain_Astrub2 = {
	{map = "101712387", path = "474", fight = true},
	{map = "101713411", path = "138", fight = true},
	{map = "101713409", door = "160", fight = true},
	{map = "188484100", door = "155", fight = true},
	{map = "188483076", custom = function() souterrain2 = false map:door(476) end, fight = true},
			{map = "192415750", path = "409"},
}

local Calanques_Astrub = {

	{map = "11,-22", path = "top", fight = true},
	{map = "11,-23", path = "top", fight = true},
	{map = "11,-24", path = "top", fight = true},
	{map = "11,-25", path = "top", fight = true},
	{map = "11,-26", path = "top", fight = true},
	{map = "11,-27", path = "top", fight = true},
	{map = "9,-25", path = "top", fight = true},
	{map = "9,-26", path = "top", fight = true},
	{map = "11,-28", path = "left", fight = true},
	{map = "10,-28", path = "left", fight = true},
	{map = "9,-28", path = "left", fight = true},
	{map = "8,-28", path = "bottom", fight = true},
	{map = "8,-27", path = "bottom", fight = true},
	{map = "8,-26", path = "bottom", fight = true},
	{map = "10,-27", path = "bottom", fight = true},
	{map = "10,-26", path = "bottom", fight = true},
	{map = "10,-25", path = "bottom", fight = true},
	{map = "10,-24", path = "bottom", fight = true},
	{map = "10,-23", path = "bottom", fight = true},
	{map = "8,-25", path = "right", fight = true},
	{map = "9,-27", path = "right", fight = true},
	{map = "10,-22", path = "right", fight = true},
	{map = "192415750", path = "409"},
}

local Egouts_Astrub1 = {
	{map = "191105028", door = "198"},
	{map = "101715461", path = "477", fight = true},
	{map = "101715463", path = "391", fight = true},
	{map = "101716487", path = "293", fight = true},
	{map = "101717512", path = "536", fight = true},
	{map = "101716489", path = "519", fight = true},
	{map = "101715465", custom = function() egouts2 = true map:moveToCell(213) end, fight = true},
			{map = "192415750", path = "409"},
}

local Egouts_Astrub2 = {
	{map = "101715463", custom = function() egouts2 = false map:moveToCell(121) end, fight = true},
}

local FarmGlobalIncarnam = {
	{map = "-2,-3", path = "top", fight = true},
	{map = "-2,-4", path = "top", fight = true},
	{map = "-2,-5", path = "left", fight = true},
	{map = "-3,-6", path = "right", fight = true},
	{map = "-2,-6", path = "right", fight = true},
	{map = "-1,-5", path = "right", fight = true},
	{map = "0,-4", path = "right", fight = true},
	{map = "1,-5", path = "right", fight = true},
	{map = "2,-5", path = "right", fight = true},
	{map = "-3,-5", path = "top", fight = true},
	{map = "1,-4", path = "top", fight = true},
	{map = "3,-5", path = "bottom", fight = true},
	{map = "4,-4", path = "bottom", fight = true},
	{map = "4,-3", path = "left", fight = true},
	{map = "3,-3", path = "top", fight = true},
	{map = "3,-4", path = "left", fight = true},
	{map = "2,-4", path = "bottom", fight = true},
	{map = "-1,-6", path = "bottom", fight = true},
	{map = "0,-5", path = "bottom", fight = true},
	{map = "3,-2", path = "bottom", fight = true},
	{map = "3,-1", path = "bottom", fight = true},
	{map = "3,0", path = "left", fight = true},
	{map = "2,0", path = "top", fight = true},
	{map = "1,0", path = "left", fight = true},
	{map = "2,-2", path = "right", fight = true},
	{map = "2,-1", path = "left", fight = true},
	{map = "1,-1", path = "bottom", fight = true},
	{map = "0,1", path = "left", fight = true},
	{map = "-1,0", path = "left", fight = true},
	{map = "-1,1", path = "top", fight = true},
	{map = "0,0", path = "bottom", fight = true},
	{map = "-2,0", path = "top", fight = true},
	{map = "-2,-1", path = "right(223)", fight = true},
	{map = "-1,-1", path = "top", fight = true},
	{map = "-1,-2", path = "top", fight = true},
	{map = "-1,-3", path = "left", fight = true},
	{map = "2,-3", path = "left", fight = true},
	{map = "0,-2", path = "right", fight = true},
	{map = "0,-3", path = "bottom", fight = true},
	{map = "1,-3", path = "left", fight = true},
	{map = "1,-2", path = "right", fight = true},
}

function goToAstrub()
	npc:npc(4398,3)
	npc:reply(-1)
	npc:reply(-1)
end

local Piou = {
	{map = "153093378", path = "right"},
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
  { map = "4,-3", custom = goToAstrub}, -- 153880323
  { map = "192416776", path = "left"}, -- 192416776
  {map = "192415750", path = "409"},
  {map = "154011397", path = "top"},
  
 

	-- boucle trajet pious 
	{map = "5,-15", path = "left", fight = true},
	{map = "3,-15", path = "left", fight = true},
	{map = "1,-15", path = "top", fight = true},
	{map = "1,-17", path = "top", fight = true},
	{map = "1,-19", path = "top", fight = true},
	{map = "6,-17", path = "left", fight = true},
	{map = "3,-20", path = "right", fight = true},
	{map = "4,-20", path = "top", fight = true},
	{map = "4,-21", path = "right", fight = true},
	{map = "5,-21", path = "bottom", fight = true},
	{map = "6,-21", path = "right", fight = true},
	{map = "7,-21", path = "bottom", fight = true},
	{map = "4,-17", path = "top", fight = true},
	{map = "191104002", path = "right", fight = true},
	{map = "2,-17", path = "left", fight = true},
	{map = "2,-21", path = "right", fight = true},
	{map = "3,-21", path = "bottom", fight = true},
	{map = "5,-20", path = "right", fight = true},
	{map = "6,-20", path = "top", fight = true},
	{map = "7,-20", path = "bottom", fight = true},
	{map = "7,-19", path = "bottom", fight = true},
	{map = "4,-16", path = "left", fight = true},
	{map = "4,-15", path = "top", fight = true},
	{map = "3,-16", path = "bottom", fight = true},
	{map = "2,-15", path = "left", fight = true},
	{map = "2,-16", path = "top", fight = true},
	{map = "1,-16", path = "right", fight = true},
	{map = "1,-18", path = "right", fight = true},
	{map = "2,-18", path = "top", fight = true},
	{map = "2,-19", path = "left", fight = true},
	{map = "1,-20", path = "right", fight = true},
	{map = "2,-20", path = "top", fight = true},
	{map = "7,-18", path = "left", fight = true},
	{map = "6,-18", path = "top", fight = true},
	{map = "6,-19", path = "left", fight = true},
	{map = "5,-19", path = "left", fight = true},
	{map = "4,-19", path = "left", fight = true},
	{map = "3,-19", path = "bottom", fight = true},
	{map = "3,-18", path = "bottom", fight = true},
	{map = "3,-17", path = "right", fight = true},
	{map = "5,-18", path = "bottom", fight = true},
	{map = "5,-17", path = "bottom", fight = true},
	{map = "5,-16", path = "right", fight = true},
	{map = "6,-16", path = "right", fight = true},
	{map = "7,-16", path = "bottom", fight = true},
	{map = "7,-15", path = "left", fight = true},
	{map = "7,-17", path = "top", fight = true},
	{map = "6,-15", path = "left", fight = true},
}

local tableEquip = {
	{Type = "amulette", Id = 8217, Emplacement = 0, Equipe = false},
	{Type = "centure", Id = 8241, Emplacement = 3, Equipe = false},
	{Type = "cape", Id = 8236, Emplacement = 7, Equipe = false},
	{Type = "bottes", Id = 8229, Emplacement = 5, Equipe = false},
	{Type = "coiffe", Id = 8247, Emplacement = 6, Equipe = false},
	{Type = "anneauGauche", Id = 8223, Emplacement = 2, Equipe = false},
	{Type = "anneauDroit", Id = 8221, Emplacement = 4, Equipe = false},  -- anneau du piou violet
}

local tableauArmes = {
	{Name = "Dagues Tylo", Id = 1374, Price = 50000},
	{Name = "Agride", Id = 782, Price = 50000},
	{Name = "Elagueuse d'Oliviolet", Id = 2593, Price = 50000},
	{Name = "Pelle Teuze", Id = 484, Price = 50000},
}


local TableArea = {
    {Zone = {Piou}, MaxMonster = 8, MinMonster = 3, ListeVenteId = {6900, 6902, 6899, 6897, 6898, 6903}, Farmer = false, PourcentageHdv = 0, Stop = false},
}

local TABLE_VENTE_PL = {
	{Name = "Plume de Piou Rouge", Id = 6900, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Jaune", Id = 6902, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Vert", Id = 6899, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Bleu", Id = 6897, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Violet", Id = 6898, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Rose", Id = 6903, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Œil d'Arakmuté", Id = 2491, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils d'Arakne Malade", Id = 388, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Intestin d'Araknosé", Id = 373, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Bec du Tofu", Id = 366, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Conque Marine", Id = 13726, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Crème à bronzer", Id = 13727, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},


	{Name = "Peau de Larve Bleue", Id = 362, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Orange", Id = 363, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Verte", Id = 364, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Jaune", Id = 2563, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},

	{Name = "Crocs de Rats", Id = 2322, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Cuir de Scélérat Strubien", Id = 304, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},

	{Name = "Noisette", Id = 394, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Étoffe d'Écurouille", Id = 653, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils du Milimulou", Id = 1690, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Scalp de Milimulou", Id = 2576, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Pic du Prespic", Id = 407, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Queue de Prespic", Id = 2573, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils Darits", Id = 1672, CanSell = false, MaxHdv100 = 1, MaxHdv10 = 2},
	{Name = "Groin de Sanglier", Id = 386, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Défense du Sanglier", Id = 387, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Étoffe du Sanglier", Id = 652, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Viande Intangible", Id = 16663, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande Hachée", Id = 17123, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande faisandée", Id = 17124, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande Frelatée", Id = 17126, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},

	{Name = "Eklame Inférieur", Id = 31518, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Petale de rose demoniaque", Id = 309, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Oeuf de larve dorée", Id = 7423, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Fil de soie", Id = 643, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

}

local function equip()
	EquipementFini = true
	for _,element in ipairs(tableEquip) do
		if not element.Equipe and inventory:itemCount(element.Id) > 0 then
			element.Equipe = true
			inventory:equipItem(element.Id, element.Emplacement)
		end
		if not element.Equipe then
			EquipementFini = false
		end
	end
end


local function Selling()
    NeedToSell = false
	NeedToReturnBank = true

	table.sort(TABLE_VENTE_PL, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

	HdvSell()
	-- vente par 100, 10 des récoles alchimiste
	for i, element in ipairs(TABLE_VENTE_PL) do
		if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

		cpt = get_quantity(element.Id).quantity["100"]

		local Priceitem1 = sale:getPriceItem(element.Id, 3)
		Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and sale:getAveragePriceItem(element.Id, 3) * 1.5 or Priceitem1
    	while (inventory:itemCount(element.Id) >= 100) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv100) do 
            sale:SellItem(element.Id, 100, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
        end

		cpt = get_quantity(element.Id).quantity["10"]

		local Priceitem2 = sale:getPriceItem(element.Id, 2)
		Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem2
        while (inventory:itemCount(element.Id) >= 10) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv10) do 
            sale:SellItem(element.Id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
		end
    end

	global:leaveDialog()

	if sale:AvailableSpace() == 0 then 
		hdvFull = true 
		global:printError("l'hdv est plein") 
	else
		hdvFull = false
	end

	global:leaveDialog()
	global:delay(500)
	
	HdvSell()

    if LastSell then
		sale:updateAllItems()
	end
	-- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
	for _, element in ipairs(TABLE_VENTE_PL) do
		if (get_quantity(element.Id).quantity["100"] >= element.MaxHdv100) and (get_quantity(element.Id).quantity["10"] >= element.MaxHdv10) then
			element.CanSell = false
		else
			element.CanSell = true
		end
	end
	
	global:leaveDialog()

    map:changeMap("top")
end

local function ProcessBank()
	NeedToReturnBank = false
	npc:npcBank(-1)
    global:delay(500) 

	if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	

	for _, element in ipairs(TABLE_VENTE_PL) do
		if inventory:itemCount(element.Id) > 0 then
			exchange:putItem(element.Id, inventory:itemCount(element.Id))
		end
	end
	if not hdvFull then
        local cpt = 0
        for _, element in ipairs(TABLE_VENTE_PL) do
            local podsAvailable = inventory:podsMax() - inventory:pods()
            local TotalMax = element.MaxHdv100 * 100 + element.MaxHdv10 * 10
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.Id)))
            if ((element.MaxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.MaxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
		NeedToSell = (cpt > 5) or (inventory:podsP() > 50)
	end

	if character:level() >= global:remember("lvlWait11H") and not global:thisAccountController():getAlias():find("FAIT") and not global:thisAccountController():getAlias():find("bank") and not global:thisAccountController():getAlias():find("Requests") and character:level() < 50 then
		global:editAlias(botType .. " " .. server .. " [FAIT]", true)
		-- customReconnect(math.random(12 * 60, 14 * 60))
	end

	hdvFull = false

	global:leaveDialog()

    map:moveToCell(409)
end


local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID

    developer:sendMessage(message)
end

local function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    if not map:onMap(mapToward) then
        if #toward == 2 then
            return debugMoveTowardMap(tonumber(toward[1]), tonumber(toward[2]))
        elseif #toward == 1 then
            return debugMoveToward(tonumber(toward[1]))
        end
    else
        action()
    end
end


local function isBotBankConnected()
	for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank") and acc:getAlias():find(character:server()) then
			return true
		end
	end
	return false
end

function stop()

	if global:thisAccountController():getAlias():find("Requests") and character:level() >= 35 then
		if getRemainingSubscription(true) <= 0 then
			global:editAlias(global:thisAccountController():getAlias() .. " [NEED ABONNEMENT]", true)
		else
			global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\Zaaps&Stuffs.lua")
		end
	end

	_ExchangeMoneyMovementInformationMessage = developer:historicalMessage("ExchangeMoneyMovementInformationMessage")

	if not isBotBankConnected() then
		global:printMessage("il n'y a pas de bot bank chargé, on continue de farm")
		global:editInMemory("lvlFinish", global:remember("lvlFinish") + 1)
		map:moveToCell(409)
		return move()
	end

	if _ExchangeMoneyMovementInformationMessage ~= nil and #_ExchangeMoneyMovementInformationMessage > 0 then
		global:printSuccess(_ExchangeMoneyMovementInformationMessage[#_ExchangeMoneyMovementInformationMessage].limit)
		if _ExchangeMoneyMovementInformationMessage[#_ExchangeMoneyMovementInformationMessage].limit < 20000000 then
			global:printSuccess("le temps de jeu est pas suffisant")
			global:editInMemory("lvlFinish", global:remember("lvlFinish") + 1)
			customReconnect(120)
		else
			global:printSuccess("temps de jeu suffisant")
		end
	end

	if not phrase:find("LvlUp") then
		restat()
		upgradeCharacteristics(character:level() * 5 - 105, 0, 0, 100)
	end

	if global:thisAccountController():getAlias():find("Mineur2") then
		-- local LoadedAccounts = snowbotController:getLoadedAccounts()
		-- for _, acc in ipairs(LoadedAccounts) do
		-- 	if acc:getAlias():find("Mineur " .. character:server()) and (acc.job():level(24) < 50) and acc.character():level() > 45 then
		-- 		global:printSuccess("l'autre mineur est pas encore assez up, on reco dans 2h")
		-- 		customReconnect(120)
		-- 	end
		-- end
	elseif global:thisAccountController():getAlias():find("Bucheron2") then
		-- local LoadedAccounts = snowbotController:getLoadedAccounts()
		-- for _, acc in ipairs(LoadedAccounts) do
		-- 	if acc:getAlias():find("Bucheron " .. character:server()) and (acc.job():level(2) < 50) and acc.character():level() > 45 then
		-- 		global:printSuccess("l'autre mineur est pas encore assez up, on reco dans 2h")
		-- 		customReconnect(120)
		-- 	end
		-- end
	elseif global:thisAccountController():getAlias():find("LvlUp2") then
		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find("LvlUp2") and acc:getAlias():find(character:server()) and (acc:getUsername() ~= global:thisAccountController():getUsername()) and ((acc:isAccountConnected() or acc:getAlias():find("MODO")) 
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("199") and not acc:getAlias():find("199"))
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("200") and not acc:getAlias():find("200"))) then

				global:printSuccess("l'autre LvlUp2 n'est pas encore prêt, on attend 2h")
				customReconnect(120)
			end
			if acc:getAlias():find("LvlUp " .. character:server()) and acc.character():level() < 100 then
				-- global:printSuccess("l'autre LvlUp n'est pas encore lvl 100, on attend 2h")
				-- customReconnect(120)
			end
		end
	elseif global:thisAccountController():getAlias():find("LvlUp ") then
		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find("LvlUp ") and acc:getAlias():find(character:server()) and (acc:getUsername() ~= global:thisAccountController():getUsername()) and ((acc:isAccountConnected() or acc:getAlias():find("MODO")) 
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("199") and not acc:getAlias():find("199"))
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("200") and not acc:getAlias():find("200"))) then

				global:printSuccess("l'autre LvlUp n'est pas encore prêt, on attend 2h")
				customReconnect(120)
			end
		end
	end
	global:printSuccess("4")

	if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
		global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\ConfigRecolte.xml")
	end

	global:editAlias(botType .. " " .. server .. " [PRÊT]", true)
	
	for _, element in ipairs(TABLE_VENTE_PL) do
		inventory:deleteItem(element.Id,inventory:itemCount(element.Id))
	end
	
	inventory:deleteItem(287, inventory:itemCount(287))
	global:delay(500)
	settOrnament(34)
	global:delay(500)
	if phrase:find("bank") then
		global:editAlias(botType .. " " .. server, true)
		global:disconnect()
	end
	global:deleteAllMemory()
	if global:thisAccountController():getAlias():find("Craft") then
		global:disconnect()
	end
	global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\take-kamas.lua")
end

local function treatMapsAstrub(maps)
    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

	if not map:onMap(maps[1].map) then
		local toward = maps[1].map:split(",")
		if #toward == 2 then
			debugMoveTowardMap(tonumber(toward[1]), tonumber(toward[2]))
		elseif #toward == 1 then
			debugMoveToward(tonumber(maps[1].map))
		end
	end
end


function move()
	if job:level(24) > 5 or job:level(2) > 5 then
		global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\take-kamas.lua")
    end

	handleDisconnection()
	if character:level() == 1 and global:thisAccountController():getAlias():find("Requests") and not configLoaded then
		configLoaded = true
		global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_1-6X.xml")
	end

	forwardKamasBotBankIfNeeded(300000, 50000, 120, 4)


	mapDelay()
	if debugPath then
		return pathDebug
	end

    if NeedToSell then
        if not map:onMap("4,-17") then
            debugMoveTowardMap(4, -17)
        else
            Selling()
        end
    end
    if NeedToReturnBank then
        if not map:onMap("192415750") then
            debugMoveToward(192415750) 
        else
            ProcessBank()
        end
    end
	

	if (string.lower(global:thisAccountController():getAlias()):find("draconiros") and (character:server() ~= "Draconiros")) and character:level() >= 20 then
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
		  { map = "4,-3", custom = goToAstrub}, -- 153880323
		  {map = "3,-21", path = "bottom"},
		  {map = "3,-30", path = "bottom"},
		  {map = "3,-20", path = "left"},
		  {map = "4,-30", path = "bottom"},
		  {map = "5,-30", path = "bottom"},
		  {map = "6,-30", path = "bottom"},
		  {map = "6,-29", path = "bottom"},
		  {map = "5,-29", path = "bottom"},
		  {map = "3,-29", path = "bottom"},
		  {map = "3,-28", path = "bottom"},
		  {map = "4,-28", path = "bottom"},
		  {map = "4,-29", path = "bottom"},
		  {map = "5,-28", path = "bottom"},
		  {map = "6,-28", path = "bottom"},
		  {map = "7,-28", path = "bottom"},
		  {map = "7,-27", path = "bottom"},
		  {map = "6,-27", path = "bottom"},
		  {map = "5,-27", path = "bottom"},
		  {map = "4,-27", path = "bottom"},
		  {map = "3,-27", path = "bottom"},
		  {map = "3,-26", path = "bottom"},
		  {map = "4,-26", path = "bottom"},
		  {map = "5,-26", path = "bottom"},
		  {map = "6,-26", path = "bottom"},
		  {map = "7,-26", path = "bottom"},
		  {map = "7,-25", path = "bottom"},
		  {map = "6,-25", path = "bottom"},
		  {map = "5,-25", path = "bottom"},
		  {map = "4,-25", path = "bottom"},
		  {map = "3,-25", path = "bottom"},
		  {map = "3,-24", path = "bottom"},
		  {map = "4,-24", path = "bottom"},
		  {map = "5,-24", path = "bottom"},
		  {map = "6,-24", path = "bottom"},
		  {map = "7,-24", path = "bottom"},
		  {map = "4,-23", path = "bottom"},
		  {map = "4,-22", path = "bottom"},
		  {map = "7,-23", path = "left"},
		  {map = "7,-22", path = "left"},
		  {map = "6,-22", path = "left"},
		  {map = "6,-23", path = "left"},
		  {map = "5,-23", path = "left"},
		  {map = "5,-22", path = "left"},
		  {map = "3,-22", path = "right"},
		  {map = "3,-23", path = "right"},
		  {map = "8,-22", path = "left"},
		  {map = "8,-23", path = "left"},
		  {map = "8,-24", path = "left"},
		  {map = "9,-24", path = "left"},
		  {map = "9,-23", path = "left"},
		  {map = "9,-22", path = "left"},
		  {map = "2,-21", path = "right"},
		  {map = "7,-15", path = "left"},
		  {map = "7,-16", path = "left"},
		  {map = "7,-18", path = "left"},
		  {map = "6,-15", path = "left"},
		  {map = "6,-16", path = "left"},
		  {map = "6,-17", path = "left"},
		  {map = "6,-18", path = "left"},
		  {map = "6,-19", path = "left"},
		  {map = "7,-20", path = "left"},
		  {map = "7,-21", path = "left"},
		  {map = "6,-20", path = "left"},
		  {map = "6,-21", path = "left"},
		  {map = "5,-21", path = "left"},
		  {map = "5,-20", path = "left"},
		  {map = "4,-21", path = "bottom"},
		  {map = "5,-15", path = "top"},
		  {map = "5,-16", path = "top"},
		  {map = "5,-17", path = "top"},
		  {map = "4,-20", path = "bottom"},
		  {map = "4,-19", path = "bottom"},
		  {map = "5,-18", path = "left"},
		  {map = "3,-18", path = "right"},
		  {map = "3,-19", path = "right"},
		  {map = "3,-17", path = "right"},
		  {map = "2,-18", path = "right"},
		  {map = "1,-18", path = "right"},
		  {map = "1,-19", path = "right"},
		  {map = "1,-20", path = "right"},
		  {map = "1,-17", path = "right"},
		  {map = "1,-16", path = "right(405)"},
		  {map = "1,-15", path = "right(195)"},
		  {map = "2,-15", path = "top"},
		  {map = "2,-16", path = "top"},
		  {map = "2,-20", path = "bottom"},
		  {map = "2,-19", path = "bottom"},
		  {map = "2,-17", path = "top"},
		  {map = "3,-16", path = "right"},
		  {map = "3,-15", path = "right"},
		  {map = "4,-15", path = "right"},
		  {map = "4,-16", path = "right"},
		  {map = "4,-17", path = "top"},
		  {map = "5,-19", path = "left"},
		  {map = "7,-17", path = "top"},
		  {map = "7,-19", path = "top"},
		  {map = "191104002", custom = function() global:deleteAllMemory() global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\take-kamas-Draconiros.lua") end},
		}
	end

	if not global:thisAccountController():getAlias():find("Request") and not global:thisAccountController():getAlias():find("bank") then
		global:editAlias(botType .. " " .. server .. "  / lvl " .. character:level(), true)
	end
	

	if not EquipementFini then
		equip()
	end

	global:printSuccess(global:remember("lvlFinish"))
	
	if character:level() >= global:remember("lvlFinish") then
		if not LastSell then
			if map:onMap("192415750") then
				map:moveToCell(409)
			end

			if not map:onMap("4,-17") then
				debugMoveTowardMap(4, -17)
			end
			return
			{
				{map = "4,-17", custom = function() LastSell = true Selling() end},
			}
		end
		if not map:onMap("192415750") then
			debugMoveToward(192415750)
		else
			stop()
		end
	end

		debug("ok")

	-- craft couteau de chasse
	if (inventory:itemCount(1934) == 0) and (inventory:itemCount(519) < 3) and character:level() < 50 then
		MAX_MONSTERS = (character:level() < 8) and 2 or 3
		return (character:level() > 2) and Champs or RouteDesAmes
	elseif (inventory:itemCount(1934) == 0) and (inventory:itemCount(16511) < 3) and character:level() < 50 then
		MAX_MONSTERS = (character:level() < 8) and 2 or 3
		return Paturages
	elseif inventory:itemCount(1934) == 0 and character:level() < 50 then
		if not map:onMap(153355264) then
			debugMoveToward(153355264)
		else
			map:useById(489177, -1)
			craft:putItem(519, 3)
			craft:putItem(16511, 3)
			craft:ready()
			global:delay(500)
			global:leaveDialog()
			global:delay(500)
			inventory:equipItem(1934, 1)
			map:moveToCell(313)
		end
	end
	
		debug("ok")


	-- monter chasseur niveau 10
	if (inventory:itemCount(16663) < 78) and (job:level(41) < 10) then
		MAX_MONSTERS = (character:level() < 8) and 2 or 3
		return FarmGlobalIncarnam  -- si le métier chasseur est inférieur à 10, on farm la zone spéciale pour drop les viandes
	elseif job:level(41) < 9 then
		if not map:onMap(153355268) then -- quand on a suffisament de viandes pour monter niveau 10 le métier chasseur, on se rend à l'atelier pour craft
			debugMoveToward(153355268)
		else
			map:useById(489360, -1) -- dans l'atelier, on craft
			craft:putItem(16663, 1)
			craft:changeQuantityToCraft(inventory:itemCount(16663))
			craft:ready()
			global:leaveDialog()
			map:moveToCell(372)
		end
	end
	
		debug("ok")

	-- monter chaseur niv 20
	if (inventory:itemCount(17123) < 275) and (job:level(41) < 20) then
		MAX_MONSTERS = (character:level() < 10) and 1 or (character:level() < 18) and 3 or (character:level() < 30) and 5 or 8
		MIN_MONSTERS = (character:level() < 18) and 1 or (character:level() < 30) and 2 or 3
		return Piou
	elseif job:level(41) < 19 then
		if not map:onMap(192937994) then
			debugMoveToward(192937994)
		else
			map:useById(515869, -1)
			craft:putItem(17123, 1)
			craft:changeQuantityToCraft(inventory:itemCount(17123))
			craft:ready()
			global:leaveDialog()
			inventory:deleteItem(17168, inventory:itemCount(17168))
			map:moveToCell(389)
		end
	end
	-- mettre le script dofus argenté

	-- if inventory:itemCount(12660) == 0 and not global:remember("BUG") and global:remember("ETAPE") ~= 55 then
	-- 	inventory:deleteItem(287, inventory:itemCount(287))
	-- 	global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\PL&Zaaps\\Quetes_Incarnam.lua")
	-- end

	--
		debug("ok")

	if character:level() >= 64 then
		MAX_MONSTERS = 8
		MIN_MONSTERS = 2
		return treatMapsAstrub(PrairiesAstrub)
	elseif character:level() >= 63 then 
		MAX_MONSTERS = 8
		MIN_MONSTERS = 2
		return treatMapsAstrub(Piou)
	elseif character:level() >= 62 then
		MAX_MONSTERS = 6
		MIN_MONSTERS = 1
		return egouts2 and treatMapsAstrub(Egouts_Astrub2) or treatMapsAstrub(Egouts_Astrub1)
	elseif character:level() >= 61 and character:level() < 62 then 
		MAX_MONSTERS = 4
		MIN_MONSTERS = 1
		return treatMapsAstrub(Foret_Astrub)
	elseif character:level() >= 60 and character:level() < 61 then 
		MAX_MONSTERS = 6
		MIN_MONSTERS = 1
		return egouts2 and treatMapsAstrub(Egouts_Astrub2) or treatMapsAstrub(Egouts_Astrub1)
	elseif character:level() >= 42 and character:level() < 60 then 
		MAX_MONSTERS = (character:level() < 40) and 6 or 8
		MIN_MONSTERS = 2
		return treatMapsAstrub(PrairiesAstrub)

		-- mettre un script tainelia
	elseif character:level() >= 40 and character:level() < 42 then 
		MAX_MONSTERS = 5
		MIN_MONSTERS = 1
		return treatMapsAstrub(Calanques_Astrub)
	elseif character:level() >= 38 and character:level() < 40 then 
		MAX_MONSTERS = 5
		MIN_MONSTERS = 1
		return treatMapsAstrub(Champs_Astrub)
	elseif character:level() >= 30 and character:level() < 38 then 
		MAX_MONSTERS = 8
		MIN_MONSTERS = 1
		return souterrain2 and treatMapsAstrub(Souterrain_Astrub2) or treatMapsAstrub(Souterrain_Astrub1)
	elseif character:level() < 30 then
		
		MAX_MONSTERS = (character:level() < 10) and 1 or (character:level() < 18) and 3 or 5
		MIN_MONSTERS = (character:level() >= 18) and 2 or 1
		return treatMapsAstrub(Piou)
	end
end



function bank()
	mapDelay()

	while inventory:itemCount(8815) > 0 do
		inventory:useItem(8815)
	end
	
    if NeedToSell then
        if not map:onMap("4,-17") then
            debugMoveTowardMap(4, -17)
        else
            Selling()
        end
    end
    if NeedToReturnBank then
        if not map:onMap("192415750") then
            debugMoveToward(192415750) 
        else
            ProcessBank()
        end
    end
	
	
	if not map:onMap("4,-17") then
		debugMoveTowardMap(4, -17)
	end
    return
    {
        {map = "4,-17", custom = Selling},
    }
end


function PHENIX()
    return {
	{map = "190843392", custom = function() map:door(313) map:changeMap("top") end},
	{map = "-3,-13", path = "right"},
	{map = "-2,-13", path = "right"},
	{map = "-1,-13", path = "right"},
	{map = "0,-13", path = "right"},
	{map = "1,-13", path = "right"},
	{map = "2,-13", path = "top"},
	{map = "2,-14", door = "313"},
	}
end

function stopped()
	global:printSuccess("Script arrété")
	if map:onMap("9,-17") or map:onMap("9,-18") then
		lines = global:consoleLines()
		for _, line in ipairs(lines) do
			if line:find("bot n'a trouvé aucun chemin") or line:find("Impossible de trouver une") then
				global:printSuccess("Go débug ce perso")
				debugPath = true
				global:thisAccountController():startScript()
				break
			end
		end
	end
end

function banned()
    global:editAlias(phrase .. " [BAN]", true)
end


function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

	local i = 1
	for cell1, id1 in pairs(challengers) do
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end
		i = i + 1
	end

	local IndexMinimale = 0
	local distanceMinimale = 10000

	for index, element in ipairs(DistanceEmplacement) do
		if element < distanceMinimale then
			distanceMinimale = DistanceEmplacement[index]
			IndexMinimale = index
		end
	end
	i = 1
	for cell, id in pairs(challengers) do
    	if i == IndexMinimale then
    	    fightAction:chooseCell(cell)
			break
    	end
		i = i + 1
	end
end

function chooseChallenge(challengeId, i)
	global:delay(global:random(500, 1000))
	local ChallengeSelectionMessage = developer:createMessage("ChallengeSelectionMessage")
	ChallengeSelectionMessage.challengeId = challengeId
	developer:sendMessage(ChallengeSelectionMessage)
	global:printMessage("Le challenge ("..fightChallenge:challengeName(challengeId)..") a été choisi pour le slot N°"..tostring(i)..".")
	return challengeId
end

function challengeManagement(challengeCount, isMule)

	-- Choix le type de bonus
	-- 0 = XP
	-- 1 = DROP
	local challengeBonus = 0

	-- Choix du mode des challenges
	-- 0 = Manuéatoire
	local challengeMod = 1
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------

	-- Texte variables
	local challengeBonusText = { "XP", "DROP" }
	local challengeModText = { "Manuel", "Aléatoire" }

	-- Choix le type de bonus
	local ChallengeBonusChoiceMessage = developer:createMessage("ChallengeBonusChoiceMessage")
	ChallengeBonusChoiceMessage.challengeBonus = challengeBonus
	developer:sendMessage(ChallengeBonusChoiceMessage)

	-- Choix du mode des challenges
	local ChallengeModSelectMessage = developer:createMessage("ChallengeModSelectMessage")
	ChallengeModSelectMessage.challengeMod = challengeMod
	developer:sendMessage(ChallengeModSelectMessage)

	-- Message
	if not isMule then
		global:printSuccess("Challenges: "..challengeModText[challengeMod + 1].." - Bonus: "..challengeBonusText[challengeBonus + 1])
	else
		global:printSuccess("[MULE] Bonus: "..challengeBonusText[challengeBonus + 1])
		return
	end
end

function fightManagement()
		-- Je vérifie dans un premier temps que c'est bien à moi de jouer :
			local cellId = fightCharacter:getCellId()

		if fightCharacter:getLevel() >= 10 then

			if fightCharacter:isItMyTurn() then
				
				delayFightStartTurn()
				--debug("debut")
				if fightAction:getCurrentTurn() == 1 then
					lancable = 0
					incrementation = 0
				elseif fightAction:getCurrentTurn() > 100 then
					Abandon()
				end

				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				-- lancement mutilation
				
				cellId = fightCharacter:getCellId()
				local mutilation = 12737
				
				if lancable == 0  then 
					if incrementation == 2 then
						if fightCharacter:getAP() > 4 then
							Supplice()
						end
						if fightCharacter:getAP() > 4 and fightCharacter:getLevel() >= 22 then
							Ravage(WeakerMonsterAdjacent())
						end
					end
					fightAction:castSpellOnCell(mutilation,cellId)
					incrementation = (incrementation == 0) and 2 or 0
					lancable = lancable + incrementation
				else
					lancable = lancable - 1
				end
				
				if fightCharacter:getLevel() > 14 then
					LaunchEpee_Vorace()
				end
				-- lancement bain de sang
				--debug("1")
				Supplice()
				Supplice()

				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				--debug("2")
				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				
				-- lancement ravage
				if fightCharacter:getLevel() >= 22 then
					--debug("2.5")
					--debug(WeakerMonsterAdjacent())
					Ravage(WeakerMonsterAdjacent())
				end
				--debug("3")
				Supplice()

				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				-- lancement stase
				
				Stase()
				Stase()
				--debug("4")
				-- lancement assaut
				if fightCharacter:getLevel() > 39 then
					Hostilite(WeakerMonsterAdjacent())
				elseif fightCharacter:getLevel() > 25 then
					local entities = fightAction:getAllEntities()
					local cpt = 0
					for _,entity in ipairs(entities) do
						if fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
							cpt = cpt + 1
						end
					end
					if cpt <= 2 then
						Assaut()
					end	
				end
				--debug("5")
				Hemmoragie(fightAction:getNearestEnemy())

				Deplacement()
				fightAction:passTurn()
			end			
		else
			if fightCharacter:isItMyTurn() then
				-- J'avance vers mon ennemi le plus proche
				delayFightStartTurn()

				Deplacement()

					
				Supplice(fightAction:getNearestEnemy())
				Deplacement()
				Supplice(fightAction:getNearestEnemy())

				Stase()
				Deplacement()
				Stase()

				Absorption(fightAction:getNearestEnemy())
				Deplacement()
				Absorption(fightAction:getNearestEnemy())
				fightAction:passTurn()
			end
		end	
end


