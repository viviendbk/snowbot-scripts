---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\IA\\IA_SacriFeuRecolte.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")

OPEN_BAGS = true 
GATHER_NEXT_DELAY_MIN = 0
GATHER_NEXT_DELAY_MAX = 50
GATHER_NEW_DELAY_MIN = 500
GATHER_NEW_DELAY_MAX = 2000
local ZoneBis = false
local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local cptActualiser = 0
local achatOliviolet = false
local achatBambou = false

local hdv_door_id = 218

local phrase = nil

for i = 1, NB_BUCHERON do
    if global:thisAccountController():getAlias():find("Bucheron" .. i) then
        phrase = "Bucheron" .. i .. " " .. character:server()
        break
    end
end

local scriptPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\bucheron200.lua"

--PLANNING = {3, 8, 13, 18, 23}

local MAPS_SANS_HAVRESAC = {
    {Id = 206308353, Path = "left"},
	{Id = 153621, Path = "left"},
    {Id = 168035328, Door = "458"},
    {Id = 168034312, Door = "215"},
    {Id = 168034310, Door = "215"},
    {Id = 104859139, Path = "444"},
    {Id = 168167424, Door = "289"},
    {Id = 104861191, Path = "457"},
    {Id = 57017859, Path = "395"},
    {Id = 168036352, Door = "458"},
    {Id = 104860167, Path = "478"},
    {Id = 104862215, Path = "472"},
    {Id = 104859143, Path = "543"},
	{Id = 153621, Path = "left"},
}		

local function GoToHavresac()
	for _, element in ipairs(MAPS_SANS_HAVRESAC) do
		if not element.Door and map:onMap(tostring(element.Id)) then
			return {{map = tostring(element.Id), path = element.Path}}
		elseif map:onMap(tostring(element.Id)) then
			return {{map = tostring(element.Id), door = element.Door}}
		end
	 end	
	 map:changeMap("havenbag")
end

local pathTakeKamas = {
	{map = "6,-19", path = "left"},
	{map = "5,-19", path = "bottom"},
	{map = "5,-18", path = "left"},
	{map = "191104002", door = "288"},
	{map = "192415750", custom = takeKamas},
}

local firstArea = {
	{map = "192415750", path = "409"},
    {map = "189530124", path = "left", gather = true},
    {map = "0,0", path = "zaap(191105026)"},
    {map = "191104002", path = "right(447)"},
    {map = "5,-18", path = "bottom"},
    {map = "5,-17", path = "bottom"},
    {map = "5,-16", path = "bottom"},
    {map = "4,-15", path = "bottom", gather = true},
    {map = "5,-15", path = "left"},
    {map = "4,-14", path = "left"},
    {map = "3,-14", path = "left"},
    {map = "2,-14", path = "left", gather = true},
    {map = "1,-14", path = "left", gather = true},
    {map = "0,-14", path = "top", gather = true},
    {map = "0,-15", path = "left", gather = true},
    {map = "-1,-15", path = "bottom", gather = true},
    {map = "-1,-14", path = "left", gather = true},
    {map = "-2,-14", path = "left", gather = true},
    {map = "-3,-14", path = "top", gather = true},
    {map = "-3,-15", path = "top", gather = true},
    {map = "-3,-16", path = "right", gather = true},
    {map = "-2,-16", path = "right", gather = true},
    {map = "-1,-16", path = "right", gather = true},
    {map = "0,-16", path = "top", gather = true},
    {map = "0,-17", path = "left", gather = true},
    {map = "-1,-17", path = "left", gather = true},
    {map = "-3,-17", path = "top", gather = true},
    {map = "1,-18", path = "top", gather = true},
    {map = "-3,-18", path = "right", gather = true},
    {map = "-2,-18", path = "right", gather = true},
    {map = "-1,-18", path = "right", gather = true},
    {map = "0,-18", path = "right", gather = true},
    {map = "1,-19", path = "left", gather = true},
    {map = "0,-19", path = "left", gather = true},
    {map = "-1,-19", path = "left", gather = true},
    {map = "-2,-19", path = "left", gather = true},
    {map = "-3,-19", path = "top", gather = true},
    {map = "0,-20", path = "top", gather = true},
    {map = "-3,-21", path = "top", gather = true},
    {map = "-3,-20", path = "right", gather = true},
    {map = "-2,-20", path = "right", gather = true},
    {map = "-1,-20", path = "right", gather = true},
    {map = "0,-21", path = "left", gather = true},
    {map = "-1,-21", path = "left", gather = true},
    {map = "-2,-21", path = "left", gather = true},
    {map = "-3,-22", path = "right", gather = true},
    {map = "-2,-22", path = "right", gather = true},
    {map = "-1,-22", path = "right", gather = true},
    {map = "0,-22", path = "right", gather = true},
    {map = "1,-22", path = "right", gather = true},
    {map = "2,-22", path = "top", gather = true},
    {map = "2,-23", path = "left", gather = true},
    {map = "1,-23", path = "left", gather = true},
    {map = "0,-23", path = "left", gather = true},
    {map = "-1,-23", path = "left", gather = true},
    {map = "-2,-23", path = "top", gather = true},
    {map = "-2,-24", path = "right", gather = true},
    {map = "-1,-24", path = "right", gather = true},
    {map = "0,-24", path = "right", gather = true},
    {map = "1,-24", path = "right", gather = true},
    {map = "2,-24", path = "top", gather = true},
    {map = "2,-25", path = "left", gather = true},
    {map = "1,-25", path = "left", gather = true},
    {map = "0,-25", path = "left", gather = true},
    {map = "-1,-25", path = "left", gather = true},
    {map = "-2,-25", path = "top", gather = true},
    {map = "-2,-26", path = "right", gather = true},
    {map = "-1,-26", path = "right", gather = true},
    {map = "0,-26", path = "right", gather = true},
    {map = "1,-26", path = "right", gather = true},
    {map = "2,-26", path = "top", gather = true},
    {map = "2,-27", path = "left", gather = true},
    {map = "1,-27", path = "left", gather = true},
    {map = "0,-27", path = "left", gather = true},
    {map = "-1,-27", path = "left", gather = true},
    {map = "-2,-27", path = "top", gather = true},
    {map = "-2,-28", path = "right", gather = true},
    {map = "-1,-28", path = "right", gather = true},
    {map = "0,-28", path = "right", gather = true},
    {map = "1,-28", path = "right", gather = true},
    {map = "2,-28", path = "top", gather = true},
    {map = "2,-29", path = "top", gather = true},
    {map = "2,-30", path = "right", gather = true},
    {map = "3,-30", path = "bottom"},
    {map = "3,-29", path = "bottom"},
    {map = "3,-28", path = "bottom"},
    {map = "3,-27", path = "bottom"},
    {map = "3,-26", path = "bottom"},
    {map = "3,-24", path = "bottom"},
    {map = "3,-25", path = "bottom"},
    {map = "3,-23", path = "bottom"},
    {map = "3,-22", path = "right"},
    {map = "4,-22", path = "bottom"},
    {map = "4,-21", path = "bottom"},
    {map = "4,-20", path = "bottom"},
    {map = "4,-19", path = "bottom"}
}

local secondArea = {
    {map = "162791424", path = "zaap(84806401)"},
    {map = "-5,-23", path = "left", gather = true},
    {map = "-6,-23", path = "bottom", gather = true},
    {map = "-6,-22", path = "bottom", gather = true},
    {map = "-6,-21", path = "bottom", gather = true},
    {map = "-6,-20", path = "bottom", gather = true},
    {map = "-6,-19", path = "left", gather = true},
    {map = "-7,-19", path = "left", gather = true},
    {map = "-8,-19", path = "top", gather = true},
    {map = "-8,-20", path = "right", gather = true},
    {map = "-7,-20", path = "top", gather = true},
    {map = "-7,-21", path = "top", gather = true},
    {map = "-7,-22", path = "top", gather = true},
    {map = "-7,-23", path = "left", gather = true},
    {map = "-7,-25", path = "left", gather = true},
    {map = "-8,-23", path = "top", gather = true},
    {map = "-7,-24", path = "top", gather = true},
    {map = "-8,-25", path = "top", gather = true},
    {map = "-7,-26", path = "top", gather = true},
    {map = "-8,-24", path = "right", gather = true},
    {map = "-8,-26", path = "right", gather = true},
    {map = "-8,-29", path = "right", gather = true},
    {map = "-9,-32", path = "right", gather = true},
    {map = "-8,-31", path = "left", gather = true},
    {map = "-7,-30", path = "left", gather = true},
    {map = "-7,-28", path = "left", gather = true},
    {map = "-7,-27", path = "top", gather = true},
    {map = "-8,-28", path = "top", gather = true},
    {map = "-7,-29", path = "top", gather = true},
    {map = "-8,-30", path = "top", gather = true},
    {map = "-9,-31", path = "top", gather = true},
    {map = "-8,-32", path = "right", gather = true},
    {map = "-7,-32", path = "bottom", gather = true},
    {map = "-7,-31", path = "right", gather = true},
    {map = "-6,-31", path = "top", gather = true},
    {map = "-6,-32", path = "top", gather = true},
    {map = "-6,-33", path = "left", gather = true},
    {map = "-7,-33", path = "left", gather = true},
    {map = "-8,-33", path = "left", gather = true},
    {map = "-9,-33", path = "top", gather = true},
    {map = "-9,-34", path = "left", gather = true},
    {map = "-10,-33", path = "left", gather = true},
    {map = "-11,-32", path = "left", gather = true},
    {map = "-10,-34", path = "bottom", gather = true},
    {map = "-11,-33", path = "bottom", gather = true},
    {map = "-12,-32", path = "top", gather = true},
    {map = "-12,-33", path = "top", gather = true},
    {map = "-12,-34", path = "top", gather = true},
    {map = "-12,-35", path = "top", gather = true},
    {map = "-14,-35", path = "left", gather = true},
    {map = "-15,-36", path = "left", gather = true},
    {map = "-17,-35", path = "left", gather = true},
    {map = "-16,-35", path = "left", gather = true},
    {map = "-15,-35", path = "top", gather = true},
    {map = "-13,-35", path = "left", gather = true},
    {map = "-18,-35", path = "top", gather = true},
    {map = "-12,-36", path = "left", gather = true},
    {map = "-13,-36", path = "bottom", gather = true},
    {map = "-16,-36", path = "bottom", gather = true},
    {map = "-18,-36", path = "left", gather = true},
    {map = "-19,-36", path = "left", gather = true},
    {map = "-17,-43", path = "top", gather = true},
    {map = "-17,-44", path = "top", gather = true},
    {map = "-17,-46", path = "top", gather = true},
    {map = "-17,-45", path = "top", gather = true},
    {map = "-20,-36", path = "top", gather = true},
    {map = "-19,-37", path = "top", gather = true},
    {map = "-20,-37", path = "right", gather = true},
    {map = "-19,-38", path = "left", gather = true},
    {map = "-20,-38", path = "top", gather = true},
    {map = "-20,-39", path = "top", gather = true},
    {map = "-20,-40", path = "right", gather = true},
    {map = "-19,-40", path = "right", gather = true},
    {map = "-18,-40", path = "top", gather = true},
    {map = "-18,-41", path = "top", gather = true},
    {map = "-17,-42", path = "top", gather = true},
    {map = "-18,-42", path = "right", gather = true},
    {map = "-17,-47", path = "zaap(84806401)"}
}

local thirdArea = { -- bois d'oliviolet
		{map = "0,0", path = "zaap(171967506)"},
   		{map = "-25,11", path = "top", gather = true},
		{map = "-25,10", path = "top", gather = true},
		{map = "-24,9", path = "top", gather = true},
		{map = "-26,8", path = "top", gather = true},
		{map = "-25,6", path = "top", gather = true},
		{map = "-27,4", path = "top", gather = true},
		{map = "-25,9", path = "right", gather = true},
		{map = "-24,8", path = "left", gather = true},
		{map = "-26,7", path = "left", gather = true},
		{map = "-27,7", path = "top", gather = true},
		{map = "-27,6", path = "right"},
		{map = "-26,6", path = "right"},
		{map = "-25,5", path = "top", gather = true},
		{map = "-25,4", path = "left"},
		{map = "-26,4", path = "left", gather = true},
		{map = "-28,3", path = "top", gather = true},
		{map = "-26,3", path = "right", gather = true},
		{map = "-24,3", path = "top", gather = true},
		{map = "-24,2", path = "left", gather = true},
		{map = "-25,2", path = "left", gather = true},
		{map = "-28,2", path = "right"},
		{map = "-27,3", path = "right"},
		{map = "-27,2", path = "bottom"},
		{map = "-25,3", path = "right"},
		{map = "-26,2", path = "top", gather = true},
		{map = "-26,1", path = "right"},
		{map = "-25,1", path = "right", gather = true},
		{map = "-24,1", path = "top"},
		{map = "-24,0", path = "left", gather = true},
		{map = "-25,0", path = "left", gather = true},
		{map = "-27,0", path = "left", gather = true},
		{map = "-26,0", path = "left"},
		{map = "-28,0", path = "top", gather = true},
		{map = "-28,-1", path = "right", gather = true},
		{map = "-27,-1", path = "right"},
		{map = "-26,-1", path = "right"},
		{map = "-25,-1", path = "right", gather = true},
		{map = "-24,-1", path = "right"},
		{map = "-23,-1", path = "top"},
		{map = "-23,-2", path = "left", gather = true},
		{map = "-24,-2", path = "left", gather = true},
		{map = "-25,-2", path = "left", gather = true},
		{map = "-26,-2", path = "left", gather = true},
		{map = "-27,-2", path = "top", gather = true},
		{map = "-27,-3", path = "right", gather = true},
		{map = "-25,-3", path = "right", gather = true},
		{map = "-24,-3", path = "top", gather = true},
		{map = "-23,-4", path = "right", gather = true},
		{map = "-22,-4", path = "top", gather = true},
		{map = "-22,-5", path = "left", gather = true},
		{map = "-23,-5", path = "left", gather = true},
		{map = "-25,-5", path = "left", gather = true},
		{map = "-26,-3", path = "right"},
		{map = "-24,-4", path = "right"},
		{map = "-24,-5", path = "left"},
		{map = "-27,12", path = "top", gather = true},
		{map = "-26,12", path = "left", gather = true},
		{map = "-27,11", path = "right", gather = true},
		{map = "-26,11", path = "right"},
		{map = "-25,12", path = "right"},
		{map = "-25,8", path = "left"},
		{map = "-24,12", path = "bottom", gather = true},
		{map = "-24,13", path = "bottom", gather = true},
		{map = "-21,18", path = "bottom", gather = true},
		{map = "-21,19", path = "bottom", gather = true},
		{map = "-21,20", path = "bottom", gather = true},
		{map = "-21,21", path = "left"},
		{map = "-22,21", path = "top", gather = true},
		{map = "-22,20", path = "top", gather = true},
		{map = "-22,18", path = "top", gather = true},
		{map = "-22,19", path = "top"},
		{map = "-22,17", path = "left"},
		{map = "-23,17", path = "top"},
		{map = "-23,16", path = "left", gather = true},
		{map = "-24,16", path = "top"},
		{map = "-24,15", path = "left", gather = true},
		{map = "-25,15", path = "top"},
		{map = "-25,14", path = "top", gather = true},
		{map = "-25,13", path = "left", gather = true},
		{map = "-26,13", path = "top"},
		{map = "-24,14", path = "right", gather = true},
		{map = "-23,14", path = "bottom"},
		{map = "-23,15", path = "right", gather = true},
		{map = "-22,16", path = "right", gather = true},
		{map = "-22,15", path = "bottom"},
		{map = "-20,16", path = "bottom"},
		{map = "-21,16", path = "right"},
		{map = "-20,17", path = "left", gather = true},
		{map = "-21,17", path = "bottom"},
		{map = "-21,13", path = "bottom"},
		{map = "-26,-5", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local thirdAreaBis = {
    {map = "0,0", path = "zaap(54172969)"},
	{map = "-78,-41", path = "top"},
	{map = "-78,-42", path = "top"},
	{map = "-78,-43", path = "top"},
	{map = "-78,-44", path = "top"},
	{map = "-78,-45", path = "top"},
	{map = "-78,-46", path = "right"},
	{map = "-77,-46", path = "right"},
	{map = "-76,-46", path = "top"},
	{map = "-76,-47", path = "top"},
	{map = "-76,-48", path = "top"},
	{map = "-76,-49", path = "right", gather = true},
	{map = "-75,-48", path = "right", gather = true},
	{map = "-74,-49", path = "right", gather = true},
	{map = "-75,-49", path = "bottom", gather = true},
	{map = "-73,-49", path = "bottom", gather = true},
	{map = "-73,-46", path = "right", gather = true},
	{map = "-70,-48", path = "right", gather = true},
	{map = "-69,-48", path = "right", gather = true},
	{map = "-68,-48", path = "bottom", gather = true},
	{map = "-68,-47", path = "bottom", gather = true},
	{map = "-68,-46", path = "right", gather = true},
	{map = "-67,-46", path = "top"},
	{map = "-67,-47", path = "right", gather = true},
	{map = "-65,-48", path = "top", gather = true},
	{map = "-66,-51", path = "top", gather = true},
	{map = "-65,-51", path = "left", gather = true},
	{map = "-62,-49", path = "top", gather = true},
	{map = "-61,-50", path = "top", gather = true},
	{map = "-62,-50", path = "right", gather = true},
	{map = "-61,-51", path = "left", gather = true},
	{map = "-62,-51", path = "top", gather = true},
	{map = "-62,-52", path = "right"},
	{map = "-61,-52", path = "right", gather = true},
	{map = "-59,-51", path = "top", gather = true},
	{map = "-58,-52", path = "top", gather = true},
	{map = "-59,-54", path = "top", gather = true},
	{map = "-59,-52", path = "right", gather = true},
	{map = "-58,-54", path = "left", gather = true},
	{map = "-58,-53", path = "top"},
	{map = "-59,-55", path = "right", gather = true},
	{map = "-58,-55", path = "top", gather = true},
	{map = "-58,-56", path = "top", gather = true},
	{map = "-58,-57", path = "right", gather = true},
	{map = "-57,-57", path = "right", gather = true},
	{map = "-56,-57", path = "top", gather = true},
	{map = "-56,-58", path = "top", gather = true},
	{map = "-56,-59", path = "top", gather = true},
	{map = "-56,-60", path = "left"},
	{map = "-57,-60", path = "top", gather = true},
	{map = "-57,-61", path = "left", gather = true},
	{map = "-58,-61", path = "top", gather = true},
	{map = "-58,-62", path = "right", gather = true},
	{map = "-57,-62", path = "top"},
	{map = "-57,-63", path = "left", gather = true},
	{map = "-58,-63", path = "left", gather = true},
	{map = "-59,-63", path = "top", gather = true},
	{map = "-59,-64", path = "left", gather = true},
	{map = "-60,-64", path = "left", gather = true},
	{map = "-61,-63", path = "left", gather = true},
	{map = "-62,-63", path = "bottom", gather = true},
	{map = "-62,-62", path = "left", gather = true},
	{map = "-63,-62", path = "left", gather = true},
	{map = "-64,-62", path = "left", gather = true},
	{map = "-65,-62", path = "bottom", gather = true},
	{map = "-65,-61", path = "left", gather = true},
	{map = "-67,-61", path = "bottom", gather = true},
	{map = "-67,-60", path = "bottom", gather = true},
	{map = "-67,-59", path = "left", gather = true},
	{map = "-68,-59", path = "left", gather = true},
	{map = "-69,-59", path = "bottom", gather = true},
	{map = "-74,-48", path = "top"},
	{map = "-73,-48", path = "bottom"},
	{map = "-73,-47", path = "bottom"},
	{map = "-72,-46", path = "right"},
	{map = "-71,-46", path = "right"},
	{map = "-70,-46", path = "top"},
	{map = "-70,-47", path = "top"},
	{map = "-66,-47", path = "top"},
	{map = "-66,-48", path = "right"},
	{map = "-65,-49", path = "top"},
	{map = "-65,-50", path = "top"},
	{map = "-66,-52", path = "right"},
	{map = "-65,-52", path = "right"},
	{map = "-64,-52", path = "right"},
	{map = "-64,-51", path = "bottom"},
	{map = "-64,-50", path = "bottom"},
	{map = "-64,-49", path = "right"},
	{map = "-63,-49", path = "right"},
	{map = "-60,-51", path = "right"},
	{map = "-60,-52", path = "bottom"},
	{map = "-61,-64", path = "bottom"},
	{map = "-66,-61", path = "left"},
	{map = "-63,-52", path = "bottom"},
	{map = "-63,-51", path = "left"},
}

local thirdAreaBisANCIEN = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "top", gather = true},
    {map = "-15,-48", path = "top", gather = true},
    {map = "-15,-49", path = "top", gather = true},
    {map = "-15,-50", path = "top", gather = true},
    {map = "-14,-51", path = "top", gather = true},
    {map = "-14,-52", path = "top", gather = true},
    {map = "-13,-53", path = "top", gather = true},
    {map = "-13,-54", path = "top", gather = true},
    {map = "-13,-55", path = "top", gather = true},
    {map = "-13,-56", path = "top", gather = true},
    {map = "-13,-57", path = "top", gather = true},
    {map = "-13,-58", path = "top", gather = true},
    {map = "-13,-59", path = "left", gather = true},
    {map = "-14,-59", path = "bottom", gather = true},
    {map = "-14,-58", path = "bottom", gather = true},
    {map = "-14,-56", path = "bottom", gather = true},
    {map = "-14,-55", path = "bottom", gather = true},
    {map = "-15,-51", path = "right", gather = true},
    {map = "-14,-53", path = "right", gather = true},
    {map = "-14,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local forthArea = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", custom = function() map:moveToCell(329) map:changeMap("right") end, gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-10,-53", path = "bottom", gather = true},
		{map = "-10,-52", path = "bottom", gather = true},
		{map = "-10,-51", path = "bottom", gather = true},
		{map = "-10,-50", path = "bottom", gather = true},
		{map = "-10,-49", path = "bottom", gather = true},
		{map = "-10,-48", path = "right", gather = true},
		{map = "-9,-48", path = "right", gather = true},
		{map = "-9,-46", path = "left", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", custom = function() map:moveToCell(255) map:changeMap("bottom") end, gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true}
}

local forthAreaV2 = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", path = "right", gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-9,-46", path = "left", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", path = "bottom", gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true},
		{map = "-10,-53", path = "right", gather = true},
		{map = "-9,-53", path = "right", gather = true},
		{map = "-8,-53", path = "right", gather = true},
		{map = "-6,-54", path = "bottom", gather = true},
		{map = "-7,-53", path = "top", gather = true},
		{map = "-7,-54", path = "right", gather = true},
		{map = "-6,-53", path = "bottom", gather = true},
		{map = "-6,-52", path = "left", gather = true},
		{map = "-7,-52", path = "bottom", gather = true},
		{map = "-7,-51", path = "right", gather = true},
		{map = "-6,-51", path = "right", gather = true},
		{map = "-5,-51", path = "right", gather = true},
		{map = "-4,-51", path = "right", gather = true},
		{map = "-3,-51", path = "bottom", gather = true},
		{map = "-3,-50", path = "right", gather = true},
		{map = "-2,-50", path = "bottom", gather = true},
		{map = "-2,-49", path = "left", gather = true},
		{map = "-3,-49", path = "left", gather = true},
		{map = "-4,-50", path = "left", gather = true},
		{map = "-5,-50", path = "left", gather = true},
		{map = "-6,-50", path = "left", gather = true},
		{map = "-7,-50", path = "left", gather = true},
		{map = "-8,-50", path = "bottom", gather = true},
		{map = "-8,-49", path = "bottom", gather = true},
		{map = "-4,-49", path = "top", gather = true}
}

local forthAreaV3 = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", path = "right", gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", path = "bottom", gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true},
		{map = "-10,-53", path = "right", gather = true},
		{map = "-9,-53", path = "right", gather = true},
		{map = "-8,-53", path = "right", gather = true},
		{map = "-6,-54", path = "bottom", gather = true},
		{map = "-7,-53", path = "top", gather = true},
		{map = "-6,-53", path = "bottom", gather = true},
		{map = "-6,-52", path = "left", gather = true},
		{map = "-7,-52", path = "bottom", gather = true},
		{map = "-7,-51", path = "right", gather = true},
		{map = "-6,-51", path = "right", gather = true},
		{map = "-5,-51", path = "right", gather = true},
		{map = "-4,-51", path = "right", gather = true},
		{map = "-3,-51", path = "bottom", gather = true},
		{map = "-3,-50", path = "right", gather = true},
		{map = "-2,-50", path = "bottom", gather = true},
		{map = "-2,-49", path = "left", gather = true},
		{map = "-3,-49", path = "left", gather = true},
		{map = "-4,-50", path = "left", gather = true},
		{map = "-5,-50", path = "left", gather = true},
		{map = "-6,-50", path = "left", gather = true},
		{map = "-7,-50", path = "left", gather = true},
		{map = "-8,-50", path = "bottom", gather = true},
		{map = "-8,-49", path = "bottom", gather = true},
		{map = "-4,-49", path = "top", gather = true},
		{map = "-7,-54", path = "top", gather = true},
		{map = "-7,-55", path = "top", gather = true},
		{map = "-7,-56", path = "top", gather = true},
		{map = "-7,-57", path = "top", gather = true},
		{map = "-7,-58", path = "right", gather = true},
		{map = "-6,-58", path = "right", gather = true},
		{map = "-5,-58", path = "right", gather = true},
		{map = "-4,-58", path = "right", gather = true},
		{map = "-3,-58", path = "bottom", gather = true},
		{map = "-3,-57", path = "left", gather = true},
		{map = "-4,-57", path = "left", gather = true},
		{map = "-5,-57", path = "left", gather = true},
		{map = "-5,-55", path = "left", gather = true},
		{map = "-6,-57", path = "bottom", gather = true},
		{map = "-5,-56", path = "bottom", gather = true},
		{map = "-6,-55", path = "bottom", gather = true},
		{map = "-6,-56", path = "right", gather = true},
		{map = "-9,-46", path = "bottom", gather = true},
		{map = "-9,-45", path = "bottom", gather = true},
		{map = "-9,-44", path = "bottom", gather = true},
		{map = "-9,-43", path = "bottom", gather = true},
		{map = "-9,-42", path = "left", gather = true},
		{map = "-10,-42", path = "left", gather = true},
		{map = "-11,-42", path = "left", gather = true},
		{map = "-12,-42", path = "left", gather = true},
		{map = "-13,-42", path = "top", gather = true},
		{map = "-13,-43", path = "right", gather = true},
		{map = "-12,-43", path = "top", gather = true},
		{map = "-12,-44", path = "top", gather = true},
		{map = "-10,-45", path = "top", gather = true},
		{map = "-12,-45", path = "right", gather = true},
		{map = "-11,-45", path = "right", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true}
}

local fifthArea = {
    {map = "162791424", path = "zaap(154642)"},
    {map = "-47,19", path = "left"},
    {map = "-48,19", path = "left"},
    {map = "-46,18", path = "left"},
    {map = "-47,18", path = "bottom"},
    {map = "-49,19", path = "top"},
    {map = "-49,18", path = "top"},
    {map = "-49,17", path = "top"},
    {map = "-49,16", path = "top"},
    {map = "-49,15", path = "top"},
    {map = "-49,14", path = "top"},
    {map = "-49,13", path = "top"},
    {map = "-49,12", path = "left"},
    {map = "-50,12", path = "left", gather = true},
    {map = "-51,12", path = "left", gather = true},
    {map = "-52,12", path = "top", gather = true},
    {map = "-52,11", path = "top", gather = true},
    {map = "-52,10", path = "left", gather = true},
    {map = "-54,10", path = "bottom", gather = true},
    {map = "-54,11", path = "left", gather = true},
    {map = "-55,11", path = "bottom", gather = true},
    {map = "-55,12", path = "bottom", gather = true},
    {map = "-55,13", path = "left", gather = true},
    {map = "-56,13", path = "bottom", gather = true},
    {map = "-56,14", path = "bottom", gather = true},
    {map = "-56,15", path = "bottom", gather = true},
    {map = "-56,16", path = "bottom", gather = true},
    {map = "-56,17", path = "bottom", gather = true},
    {map = "-56,18", path = "bottom", gather = true},
    {map = "-56,19", path = "bottom", gather = true},
    {map = "-56,20", path = "right", gather = true},
    {map = "-55,20", path = "top", gather = true},
    {map = "-55,19", path = "top", gather = true},
    {map = "-55,18", path = "top", gather = true},
    {map = "-55,17", path = "top", gather = true},
    {map = "-55,16", path = "top", gather = true},
    {map = "-55,15", path = "top", gather = true},
    {map = "-55,14", path = "right", gather = true},
    {map = "-54,14", path = "top", gather = true},
    {map = "-54,13", path = "right", gather = true},
    {map = "-53,13", path = "bottom", gather = true},
    {map = "-53,14", path = "bottom", gather = true},
    {map = "-53,15", path = "left", gather = true},
    {map = "-54,15", path = "bottom", gather = true},
    {map = "-54,16", path = "bottom", gather = true},
    {map = "-54,17", path = "bottom", gather = true},
    {map = "-54,18", path = "bottom", gather = true},
    {map = "-54,19", path = "bottom", gather = true},
    {map = "-54,20", path = "bottom", gather = true},
    {map = "-54,21", path = "right", gather = true},
    {map = "-53,21", path = "top", gather = true},
    {map = "-53,19", path = "top", gather = true},
    {map = "-52,19", path = "left", gather = true},
    {map = "-53,18", path = "right", gather = true},
    {map = "-52,18", path = "top", gather = true},
    {map = "-52,17", path = "top", gather = true},
    {map = "-52,20", path = "top", gather = true},
    {map = "-52,16", path = "top", gather = true},
    {map = "-52,15", path = "top", gather = true},
    {map = "-52,14", path = "top", gather = true},
    {map = "-52,13", path = "right", gather = true},
    {map = "-51,13", path = "bottom", gather = true},
    {map = "-51,14", path = "bottom", gather = true},
    {map = "-51,15", path = "right", gather = true},
    {map = "-50,15", path = "bottom", gather = true},
    {map = "-50,16", path = "left", gather = true},
    {map = "-51,16", path = "bottom", gather = true},
    {map = "-51,17", path = "right", gather = true},
    {map = "-50,17", path = "bottom", gather = true},
    {map = "-50,18", path = "left", gather = true},
    {map = "-51,18", path = "bottom", gather = true},
    {map = "-51,19", path = "bottom", gather = true},
    {map = "-51,20", path = "bottom", gather = true},
    {map = "-51,21", path = "right"},
    {map = "-50,21", path = "right"},
    {map = "-49,21", path = "top"},
    {map = "-49,20", path = "top"},
    {map = "-53,10", path = "top", gather = true},
	{map = "-53,9", path = "left(196)", gather = true},
	{map = "-54,9", path = "left", gather = true},
	{map = "-55,9", path = "bottom", gather = true},
	{map = "-55,10", path = "right", gather = true},
    {map = "-53,20", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local fifthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
	{map = "-17,-47", path = "right"},
	{map = "-16,-47", path = "right"},
	{map = "-15,-47", path = "right"},
	{map = "-14,-47", path = "right"},
	{map = "-13,-47", path = "bottom", gather = true},
	{map = "-13,-46", path = "bottom", gather = true},
	{map = "-13,-44", path = "bottom", gather = true},
	{map = "-13,-43", path = "bottom", gather = true},
	{map = "-13,-42", path = "right", gather = true},
	{map = "-12,-42", path = "top", gather = true},
	{map = "-12,-43", path = "right"},
	{map = "-11,-43", path = "bottom", gather = true},
	{map = "-11,-42", path = "right", gather = true},
	{map = "-10,-42", path = "right(139)", gather = true},
	{map = "-9,-42", path = "top", gather = true},
	{map = "-9,-43", path = "top", gather = true},
	{map = "-9,-44", path = "top", gather = true},
	{map = "-9,-45", path = "top", gather = true},
	{map = "-9,-46", path = "left", gather = true},
	{map = "-10,-46", path = "left", gather = true},
	{map = "-11,-46", path = "left", gather = true},
	{map = "-12,-46", path = "top", gather = true},
	{map = "-12,-47", path = "top", gather = true},
	{map = "-12,-48", path = "top", gather = true},
	{map = "-12,-49", path = "top", gather = true},
	{map = "-12,-50", path = "top", gather = true},
	{map = "-12,-51", path = "top", gather = true},
	{map = "-12,-52", path = "top", gather = true},
	{map = "-12,-53", path = "top", gather = true},
	{map = "-12,-54", path = "top", gather = true},
	{map = "-12,-55", path = "top", gather = true},
	{map = "-12,-56", path = "right", gather = true},
	{map = "-11,-56", path = "top", gather = true},
	{map = "-12,-57", path = "top", gather = true},
	{map = "-12,-58", path = "top", gather = true},
	{map = "-11,-57", path = "left", gather = true},
	{map = "-12,-59", path = "right", gather = true},
	{map = "-11,-59", path = "right", gather = true},
	{map = "-10,-59", path = "right"},
	{map = "-9,-59", path = "right"},
	{map = "-8,-59", path = "right"},
	{map = "-7,-59", path = "right"},
	{map = "-6,-59", path = "bottom"},
	{map = "-6,-58", path = "right", gather = true},
	{map = "-5,-58", path = "right"},
	{map = "-4,-58", path = "right", gather = true},
	{map = "-3,-58", path = "bottom", gather = true},
	{map = "-3,-57", path = "left", gather = true},
	{map = "-4,-57", path = "left"},
	{map = "-5,-57", path = "left", gather = true},
	{map = "-6,-57", path = "bottom", gather = true},
	{map = "-5,-56", path = "bottom", gather = true},
	{map = "-6,-55", path = "bottom", gather = true},
	{map = "-6,-54", path = "left", gather = true},
	{map = "-7,-54", path = "left", gather = true},
	{map = "-12,-45", path = "bottom", gather = true},
	{map = "-13,-45", path = "right", gather = true},
	{map = "-12,-44", path = "left", gather = true},
	{map = "-8,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local fifthAreaV2 = {
		{map = "162791424", path = "zaap(154642)"},
		{map = "-47,19", path = "left"},
		{map = "-48,19", path = "left"},
		{map = "-46,18", path = "left"},
		{map = "-47,18", path = "bottom"},
		{map = "-49,19", path = "top"},
		{map = "-49,18", path = "top"},
		{map = "-49,17", path = "top"},
		{map = "-49,16", path = "top"},
		{map = "-49,15", path = "top"},
		{map = "-49,14", path = "top"},
		{map = "-49,13", path = "top"},
		{map = "-49,12", path = "left"},
		{map = "-50,12", path = "left", gather = true},
		{map = "-51,12", path = "left", gather = true},
		{map = "-52,12", path = "top", gather = true},
		{map = "-52,11", path = "top", gather = true},
		{map = "-52,10", path = "left", gather = true},
		{map = "-54,10", path = "bottom", gather = true},
		{map = "-54,11", path = "left", gather = true},
		{map = "-55,11", path = "bottom", gather = true},
		{map = "-55,12", path = "bottom", gather = true},
		{map = "-55,13", path = "left", gather = true},
		{map = "-56,13", path = "bottom", gather = true},
		{map = "-56,14", path = "bottom", gather = true},
		{map = "-56,15", path = "bottom", gather = true},
		{map = "-56,16", path = "bottom", gather = true},
		{map = "-56,17", path = "bottom", gather = true},
		{map = "-56,18", path = "bottom", gather = true},
		{map = "-56,19", path = "bottom", gather = true},
		{map = "-56,20", path = "right", gather = true},
		{map = "-55,20", path = "top", gather = true},
		{map = "-55,19", path = "top", gather = true},
		{map = "-55,18", path = "top", gather = true},
		{map = "-55,17", path = "top", gather = true},
		{map = "-55,16", path = "top", gather = true},
		{map = "-55,15", path = "top", gather = true},
		{map = "-55,14", path = "right", gather = true},
		{map = "-54,14", path = "top", gather = true},
		{map = "-54,13", path = "right", gather = true},
		{map = "-53,13", path = "bottom", gather = true},
		{map = "-53,14", path = "bottom", gather = true},
		{map = "-53,15", path = "left", gather = true},
		{map = "-54,15", path = "bottom", gather = true},
		{map = "-54,16", path = "bottom", gather = true},
		{map = "-54,17", path = "bottom", gather = true},
		{map = "-54,18", path = "bottom", gather = true},
		{map = "-54,19", path = "bottom", gather = true},
		{map = "-54,20", path = "bottom", gather = true},
		{map = "-54,21", path = "right", gather = true},
		{map = "-53,21", path = "top", gather = true},
		{map = "-53,19", path = "top", gather = true},
		{map = "-52,19", path = "left", gather = true},
		{map = "-53,18", path = "right", gather = true},
		{map = "-52,18", path = "top", gather = true},
		{map = "-52,17", path = "top", gather = true},
		{map = "-52,20", path = "top", gather = true},
		{map = "-52,16", path = "top", gather = true},
		{map = "-52,15", path = "top", gather = true},
		{map = "-52,14", path = "top", gather = true},
		{map = "-52,13", path = "right", gather = true},
		{map = "-51,13", path = "bottom", gather = true},
		{map = "-51,14", path = "bottom", gather = true},
		{map = "-51,15", path = "right", gather = true},
		{map = "-50,15", path = "bottom", gather = true},
		{map = "-50,16", path = "left", gather = true},
		{map = "-51,16", path = "bottom", gather = true},
		{map = "-51,17", path = "right", gather = true},
		{map = "-50,17", path = "bottom", gather = true},
		{map = "-50,18", path = "left", gather = true},
		{map = "-51,18", path = "bottom", gather = true},
		{map = "-51,19", path = "bottom", gather = true},
		{map = "-51,20", path = "bottom", gather = true},
		{map = "-51,21", path = "right"},
		{map = "-50,21", path = "right"},
		{map = "-49,21", path = "top"},
		{map = "-49,20", path = "top"},
		{map = "-53,10", path = "top", gather = true},
		{map = "-53,9", path = "left(196)", gather = true},
		{map = "-54,9", path = "left", gather = true},
		{map = "-55,9", path = "bottom", gather = true},
		{map = "-55,10", path = "right", gather = true},
		{map = "-53,20", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},
}

local fifthAreaV2Bis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-47", path = "right"},
    {map = "-13,-47", path = "bottom", gather = true},
    {map = "-13,-46", path = "bottom", gather = true},
    {map = "-13,-44", path = "bottom", gather = true},
    {map = "-13,-43", path = "bottom", gather = true},
    {map = "-13,-42", path = "right", gather = true},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right"},
    {map = "-11,-42", path = "right", gather = true},
    {map = "-9,-42", path = "top", gather = true},
    {map = "-9,-43", path = "top", gather = true},
    {map = "-9,-44", path = "top", gather = true},
    {map = "-9,-45", path = "top", gather = true},
    {map = "-9,-46", path = "left", gather = true},
    {map = "-10,-46", path = "left", gather = true},
    {map = "-11,-46", path = "left", gather = true},
    {map = "-12,-46", path = "top", gather = true},
    {map = "-12,-47", path = "top", gather = true},
    {map = "-12,-49", path = "top", gather = true},
    {map = "-12,-50", path = "left", gather = true},
    {map = "-12,-51", path = "top", gather = true},
    {map = "-12,-52", path = "top", gather = true},
    {map = "-12,-53", path = "top", gather = true},
    {map = "-12,-55", path = "top", gather = true},
    {map = "-12,-56", path = "right", gather = true},
    {map = "-11,-56", path = "top", gather = true},
    {map = "-12,-58", path = "left", gather = true},
    {map = "-11,-57", path = "left", gather = true},
    {map = "-12,-59", path = "right", gather = true},
    {map = "-11,-59", path = "right", gather = true},
    {map = "-10,-59", path = "right"},
    {map = "-9,-59", path = "right"},
    {map = "-8,-59", path = "right"},
    {map = "-7,-59", path = "right"},
    {map = "-6,-59", path = "bottom"},
    {map = "-6,-58", path = "right", gather = true},
    {map = "-5,-58", path = "right"},
    {map = "-4,-58", path = "right", gather = true},
    {map = "-3,-58", path = "bottom", gather = true},
    {map = "-3,-57", path = "left", gather = true},
    {map = "-4,-57", path = "left"},
    {map = "-5,-57", path = "left", gather = true},
    {map = "-6,-57", path = "bottom", gather = true},
    {map = "-5,-56", path = "bottom", gather = true},
    {map = "-6,-55", path = "bottom", gather = true},
    {map = "-6,-54", path = "left", gather = true},
    {map = "-7,-54", path = "left", gather = true},
    {map = "-12,-45", path = "bottom", gather = true},
    {map = "-13,-45", path = "right", gather = true},
    {map = "-12,-44", path = "left", gather = true},
    {map = "-12,-48", path = "left", gather = true},
    {map = "-13,-48", path = "top", gather = true},
    {map = "-13,-49", path = "right", gather = true},
    {map = "-13,-50", path = "left", gather = true},
    {map = "-14,-50", path = "left", gather = true},
    {map = "-15,-50", path = "top", gather = true},
    {map = "-15,-51", path = "right", gather = true},
    {map = "-13,-51", path = "right", gather = true},
    {map = "-14,-51", path = "top", gather = true},
    {map = "-14,-52", path = "right", gather = true},
    {map = "-13,-52", path = "bottom", gather = true},
    {map = "-11,-43", path = "bottom", gather = true},
    {map = "-12,-54", path = "top", gather = true},
    {map = "-15,-57", path = "left", gather = true},
    {map = "-16,-57", path = "left", gather = true},
    {map = "-17,-57", path = "left", gather = true},
    {map = "-18,-57", path = "top", gather = true},
    {map = "-18,-58", path = "right", gather = true},
    {map = "-17,-58", path = "right", gather = true},
    {map = "-16,-58", path = "right", gather = true},
    {map = "-15,-58", path = "right", gather = true},
    {map = "-14,-57", path = "left", gather = true},
    {map = "-13,-57", path = "left", gather = true},
    {map = "-12,-57", path = "top", gather = true},
    {map = "-13,-58", path = "bottom", gather = true},
    {map = "-14,-58", path = "top", gather = true},
    {map = "-14,-59", path = "right", gather = true},
    {map = "-13,-59", path = "right", gather = true},
    {map = "-10,-42", path = "right(139)", gather = true},
    {map = "-8,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local sixthArea = { -- bois de bambou, if, erable, chene
		{map = "0,0", path = "zaap(207619076)"},
		{map = "207619076", path = "436"},
		{map = "24,-34", door = "294", gather = true},
		{map = "23,-29", path = "right", gather = true},
		{map = "25,-28", path = "right", gather = true},
		{map = "26,-28", path = "top", gather = true},
		{map = "26,-29", path = "right", gather = true},
		{map = "27,-30", path = "top", gather = true},
		{map = "27,-31", path = "left", gather = true},
		{map = "26,-31", path = "left", gather = true},
		{map = "25,-30", custom = function() map:moveToCell(271) map:moveToCell(342) map:changeMap("left") end},
		{map = "24,-30", path = "top", gather = true},
		{map = "24,-31", path = "right", gather = true},
		{map = "25,-34", path = "left", gather = true},
		{map = "19,-29", path = "top", gather = true},
		{map = "21,-27", path = "right", gather = true},
		{map = "20,-30", path = "right", gather = true},
		{map = "20,-31", path = "right", gather = true},
		{map = "23,-28", path = "top", gather = true},
		{map = "23,-27", path = "top", gather = true},
		{map = "21,-26", path = "top", gather = true},
		{map = "19,-26", path = "bottom", gather = true},
		{map = "19,-25", path = "right", gather = true},
		{map = "21,-25", path = "top", gather = true},
		{map = "206307842", path = "left"},
		{map = "19,-30", path = "right", gather = true},
		{map = "21,-31", path = "bottom"},
		{map = "21,-30", path = "bottom"},
		{map = "21,-29", path = "bottom"},
		{map = "21,-28", path = "left"},
		{map = "20,-28", path = "bottom"},
		{map = "20,-27", path = "bottom", gather = true},
		{map = "20,-26", path = "left"},
		{map = "20,-25", path = "right"},
		{map = "22,-27", path = "right"},
		{map = "24,-29", path = "bottom"},
		{map = "24,-28", path = "right"},
		{map = "27,-29", path = "top"},
		{map = "25,-31", path = "top|bottom"},
		{map = "25,-32", path = "top"},
		{map = "25,-33", path = "top"},
		{map = "23,-34", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local sixthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "top", gather = true},
    {map = "-14,-51", path = "top", gather = true},
    {map = "-13,-59", path = "bottom", gather = true},
    {map = "-14,-58", path = "bottom", gather = true},
    {map = "-14,-48", path = "top", gather = true},
    {map = "-15,-48", path = "right", gather = true},
    {map = "-14,-49", path = "top", gather = true},
    {map = "-14,-50", path = "top", gather = true},
    {map = "-13,-52", path = "right"},
    {map = "-12,-53", path = "top", gather = true},
    {map = "-12,-52", path = "top", gather = true},
    {map = "-12,-54", path = "top", gather = true},
    {map = "-14,-52", path = "right", gather = true},
    {map = "-12,-55", path = "top", gather = true},
    {map = "-12,-56", path = "right"},
    {map = "-11,-58", path = "top", gather = true},
    {map = "-11,-59", path = "left", gather = true},
    {map = "-11,-56", path = "top", gather = true},
    {map = "-11,-57", path = "left", gather = true},
    {map = "-12,-58", path = "right", gather = true},
    {map = "-12,-59", path = "left", gather = true},
    {map = "-12,-57", path = "top", gather = true},
    {map = "-13,-58", path = "left", gather = true},
    {map = "-14,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local seventhArea = { --  bois de bambu sombre, charme, mérisier
		{map = "0,0", path = "zaap(207619076)"},
		{map = "207619076", path = "436"},
		{map = "23,-29", path = "right", gather = true},
		{map = "25,-28", path = "right", gather = true},
		{map = "26,-28", path = "top", gather = true},
		{map = "26,-29", path = "right", gather = true},
		{map = "27,-30", path = "top", gather = true},
		{map = "27,-31", path = "left", gather = true},
		{map = "26,-31", path = "left", gather = true},
		{map = "25,-30", path = "left", gather = true},
		{map = "24,-30", path = "top", gather = true},
		{map = "24,-31", path = "right", gather = true},
		{map = "25,-34", path = "left", gather = true},
		{map = "24,-34", door = "294", gather = true},
		{map = "19,-29", path = "top", gather = true},
		{map = "21,-27", path = "right", gather = true},
		{map = "20,-30", path = "right", gather = true},
		{map = "20,-31", path = "right", gather = true},
		{map = "23,-28", path = "top", gather = true},
		{map = "23,-27", path = "top", gather = true},
		{map = "21,-26", path = "top", gather = true},
		{map = "19,-26", path = "bottom", gather = true},
		{map = "19,-25", path = "right", gather = true},
		{map = "21,-25", path = "top", gather = true},
		{map = "206307842", path = "left"},
		{map = "19,-30", path = "right", gather = true},
		{map = "21,-31", path = "bottom"},
		{map = "21,-30", path = "bottom"},
		{map = "21,-29", path = "bottom"},
		{map = "21,-28", path = "left"},
		{map = "20,-28", path = "bottom"},
		{map = "20,-27", path = "bottom", gather = true},
		{map = "20,-26", path = "left"},
		{map = "20,-25", path = "right"},
		{map = "22,-27", path = "right"},
		{map = "24,-29", path = "bottom"},
		{map = "24,-28", path = "right"},
		{map = "27,-29", path = "top"},
		{map = "25,-31", path = "top|bottom"},
		{map = "25,-32", path = "top"},
		{map = "25,-33", path = "top"},
		{map = "23,-34", path = "left", gather = true},
		{map = "22,-34", path = "left"},
		{map = "21,-34", path = "left"},
		{map = "20,-34", path = "left"},
		{map = "19,-34", path = "top"},
		{map = "19,-35", path = "left"},
		{map = "18,-35", path = "left", gather = true},
		{map = "17,-35", path = "top|left", gather = true},
		{map = "18,-36", path = "left", gather = true},
		{map = "17,-36", path = "bottom", gather = true},
		{map = "16,-36", path = "bottom", gather = true},
		{map = "16,-35", path = "left", gather = true},
		{map = "15,-35", path = "bottom", gather = true},
		{map = "15,-34", path = "left", gather = true},
		{map = "14,-34", path = "bottom", gather = true},
		{map = "14,-33", path = "bottom", gather = true},
		{map = "14,-32", path = "right", gather = true},
		{map = "15,-32", path = "top", gather = true},
		{map = "15,-33", path = "right", gather = true},
		{map = "16,-33", path = "bottom", gather = true},
		{map = "16,-31", path = "bottom", gather = true},
		{map = "16,-32", path = "bottom", gather = true},
		{map = "16,-30", path = "right", gather = true},
		{map = "17,-30", path = "right", gather = true},
		{map = "18,-30", path = "top", gather = true},
		{map = "18,-31", path = "left", gather = true},
		{map = "17,-31", path = "top", gather = true},
		{map = "17,-32", path = "right", gather = true},
		{map = "18,-32", path = "top", gather = true},
		{map = "18,-33", path = "left", gather = true},
		{map = "17,-33", path = "top", gather = true},
		{map = "17,-34", path = "left", gather = true},
		{map = "16,-34", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},
}

local seventhAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-48", path = "right"},
    {map = "-14,-47", path = "top"},
    {map = "-14,-48", path = "right"},
    {map = "-13,-48", path = "bottom", gather = true},
    {map = "-13,-47", path = "bottom", gather = true},
    {map = "-13,-46", path = "right", gather = true},
    {map = "-12,-46", path = "right", gather = true},
    {map = "-11,-46", path = "right"},
    {map = "-10,-46", path = "right", gather = true},
    {map = "-9,-46", path = "bottom", gather = true},
    {map = "-9,-45", path = "bottom"},
    {map = "-9,-44", path = "bottom", gather = true},
    {map = "-9,-43", path = "bottom"},
    {map = "-9,-42", path = "left"},
    {map = "-10,-42", path = "left", gather = true},
    {map = "-11,-42", path = "left"},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right"},
    {map = "-11,-43", path = "top"},
    {map = "-11,-44", custom = function() ZoneBis = false map:changeMap("havenbag") end, gather = true}
}

local eigthArea = { -- kaliptus et charme
		{map = "0,0", path = "zaap(73400320)"},
		{map = "-17,1", path = "left"},
		{map = "-16,1", path = "left"},
		{map = "-18,1", path = "left"},
		{map = "-19,1", path = "left"},
		{map = "-20,1", path = "left"},
		{map = "-21,1", path = "top"},
		{map = "-21,0", path = "top"},
		{map = "-21,-2", path = "right"},
		{map = "-21,-1", path = "top", gather = true},
		{map = "-20,-2", path = "top", gather = true},
		{map = "-20,-3", path = "top"},
		{map = "-20,-4", path = "top"},
		{map = "-20,-5", path = "top", gather = true},
		{map = "-20,-6", path = "top"},
		{map = "-20,-7", path = "top"},
		{map = "-20,-8", path = "right", gather = true},
		{map = "-19,-8", path = "top", gather = true},
		{map = "-19,-9", path = "right", gather = true},
		{map = "-18,-9", path = "right", gather = true},
		{map = "-17,-9", path = "right", gather = true},
		{map = "-16,-9", path = "right", gather = true},
		{map = "-15,-9", path = "bottom(543)", gather = true},
		{map = "-15,-7", path = "bottom", gather = true},
		{map = "-14,-7", path = "left", gather = true},
		{map = "-15,-8", path = "right"},
		{map = "-14,-8", path = "bottom"},
		{map = "-15,-6", path = "left", gather = true},
		{map = "-16,-6", path = "left", gather = true},
		{map = "-17,-6", path = "left"},
		{map = "-18,-6", path = "bottom", gather = true},
		{map = "-18,-5", path = "bottom", gather = true},
		{map = "-18,-4", path = "bottom", gather = true},
		{map = "-18,-3", path = "right", gather = true},
		{map = "-17,-3", path = "top", gather = true},
		{map = "-17,-4", path = "right", gather = true},
		{map = "-16,-4", path = "right", gather = true},
		{map = "-15,-4", path = "bottom"},
		{map = "-15,-3", path = "left"},
		{map = "-16,-3", path = "bottom"},
		{map = "-16,-2", path = "right", gather = true},
		{map = "-15,-2", path = "right", gather = true},
		{map = "-14,-2", path = "bottom"},
		{map = "-14,-1", path = "right", gather = true},
		{map = "-13,-1", path = "bottom", gather = true},
		{map = "-13,0", path = "bottom", gather = true},
		{map = "-13,2", path = "bottom", gather = true},
		{map = "-13,1", path = "bottom"},
		{map = "-13,3", path = "right"},
		{map = "-12,3", path = "top"},
		{map = "-12,2", path = "top", gather = true},
		{map = "-12,1", path = "top", gather = true},
		{map = "-12,0", path = "top", gather = true},
		{map = "-12,-1", path = "right", gather = true},
		{map = "-11,2", path = "bottom", gather = true},
		{map = "-11,3", path = "bottom", gather = true},
		{map = "-11,1", path = "bottom"},
		{map = "-11,-1", path = "bottom"},
		{map = "-11,0", path = "bottom", gather = true},
		{map = "-11,4", path = "bottom"},
		{map = "-11,5", path = "bottom", gather = true},
		{map = "-10,6", path = "bottom", gather = true},
		{map = "-11,7", path = "bottom", gather = true},
		{map = "-10,8", path = "bottom", gather = true},
		{map = "-11,9", path = "bottom", gather = true},
		{map = "-11,10", path = "bottom", gather = true},
		{map = "-11,11", path = "bottom", gather = true},
		{map = "-9,10", path = "bottom", gather = true},
		{map = "-9,11", path = "bottom", gather = true},
		{map = "-7,12", path = "bottom", gather = true},
		{map = "-9,13", path = "bottom", gather = true},
		{map = "-11,6", path = "right", gather = true},
		{map = "-11,8", path = "right", gather = true},
		{map = "-11,12", path = "right", gather = true},
		{map = "-9,12", path = "bottom", gather = true},
		{map = "-9,14", path = "right", gather = true},
		{map = "-8,12", path = "right", gather = true},
		{map = "-7,14", path = "right", gather = true},
		{map = "-7,13", path = "bottom", gather = true},
		{map = "-6,14", path = "top", gather = true},
		{map = "-8,14", path = "top", gather = true},
		{map = "-8,13", path = "top", gather = true},
		{map = "-10,12", path = "top", gather = true},
		{map = "-10,11", path = "top", gather = true},
		{map = "-10,9", path = "left", gather = true},
		{map = "-10,7", path = "bottom", gather = true},
		{map = "-10,10", path = "right", gather = true},
		{map = "-6,13", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},	
}

local eigthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-47", path = "bottom"},
    {map = "-14,-46", path = "right"},
    {map = "-13,-46", path = "top", gather = true},
    {map = "-13,-47", path = "top", gather = true},
    {map = "-12,-47", path = "bottom", gather = true},
    {map = "-12,-46", path = "right", gather = true},
    {map = "-11,-46", path = "right", gather = true},
    {map = "-10,-46", path = "right", gather = true},
    {map = "-9,-46", path = "bottom", gather = true},
    {map = "-9,-45", path = "bottom", gather = true},
    {map = "-9,-44", path = "bottom", gather = true},
    {map = "-9,-43", path = "bottom", gather = true},
    {map = "-9,-42", path = "left", gather = true},
    {map = "-10,-42", path = "left", gather = true},
    {map = "-11,-42", path = "left", gather = true},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right", gather = true},
    {map = "-11,-43", path = "top", gather = true},
    {map = "-13,-48", path = "right", gather = true},
    {map = "-12,-48", path = "bottom", gather = true},
    {map = "-11,-44", custom = function() ZoneBis = false map:changeMap("havenbag") end, gather = true},
}

local Planches = {
    {Name = "Planche de Salut", Id = 16499, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 7016, Nb = 10}, {Id = 7014, Nb = 10}, {Id = 472, Nb = 10}, {Id = 7925, Nb = 10}, {Id = 470, Nb = 10}, {Id = 11107, Nb = 10}, {Id = 449, Nb = 10}, {Id = 16488, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Planche a Dessin", Id = 16498, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 7016, Nb = 10}, {Id = 474, Nb = 10}, {Id = 472, Nb = 10}, {Id = 7925, Nb = 10}, {Id = 470, Nb = 10}, {Id = 7013, Nb = 10}, {Id = 449, Nb = 10}, {Id = 16488, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Planche a Pain", Id = 16497, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Nb = 10}, {Id = 474, Nb = 10}, {Id = 472, Nb = 10}, {Id = 7925, Nb = 10}, {Id = 7013, Nb = 10}, {Id = 449, Nb = 10}, {Id = 16488, Nb = 10}}, lvlMax = 180, CanSell = true},
    {Name = "Planche de Gravure", Id = 16496, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Nb = 10}, {Id = 474, Nb = 10}, {Id = 2357, Nb = 5}, {Id = 7013, Nb = 10}, {Id = 449, Nb = 10}, {Id = 16488, Nb = 10}, {Id = 27375, Nb = 5}}, lvlMax = 160, CanSell = true},
    {Name = "Planche a Patisserie", Id = 16495, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Nb = 10}, {Id = 474, Nb = 10}, {Id = 2357, Nb = 5}, {Id = 7013, Nb = 10}, {Id = 2358, Nb = 10}, {Id = 471, Nb = 10}, {Id = 27375, Nb = 5}}, lvlMax = 140, CanSell = true},
    {Name = "Planche de Toilettes", Id = 16494, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Nb = 10}, {Id = 2357, Nb = 5}, {Id = 460, Nb = 10}, {Id = 2358, Nb = 10}, {Id = 471, Nb = 10}, {Id = 27375, Nb = 5}}, lvlMax = 120, CanSell = true},
	{Name = "Planche a Repasser", Id = 16493, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Nb = 10}, {Id = 460, Nb = 10}, {Id = 2358, Nb = 10}, {Id = 471, Nb = 10}}, lvlMax = 100, CanSell = true},
    {Name = "Planche de Surf", Id = 16492, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Nb = 10}, {Id = 303, Nb = 10}, {Id = 460, Nb = 10}, {Id = 473, Nb = 10}}, lvlMax = 80, CanSell = true},
    {Name = "Planche a Griller", Id = 16491, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Nb = 10}, {Id = 303, Nb = 10}, {Id = 473, Nb = 10}}, lvlMax = 60, CanSell = true},
    {Name = "Planche Contreplaquee", Id = 16489, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 303, Nb = 10}, {Id = 473, Nb = 10}}, lvlMax = 40, CanSell = true},
}

          
local Bois = {
    {Name = "Tremble", Id = 11107, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou Sacre", Id = 7014, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Orme", Id = 470, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou Sombre", Id = 7016, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Charme", Id = 472, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Kaliptus", Id = 7925, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Ebene", Id = 449, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Noisetier", Id = 16488, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Mersier", Id = 474, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou", Id = 7013, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "If", Id = 461, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Oliviolet", Id = 2357, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
	{Name = "Pin", Id = 27375, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Erable", Id = 471, MaxHdv100= 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 140},
    {Name = "Bombu", Id = 2358, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Chene", Id = 460, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Noyer", Id = 476, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 100},
    {Name = "Chataignier", Id = 473, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Frene", Id = 303, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 80 },
}

local Seves = {
    {Name = "Seve de Frene", Id = 16909,},
    {Name = "Seve de Chataignier", Id = 16910},
    {Name = "Seve de Noyer", Id = 16911},
    {Name = "Seve de Chene", Id = 16912},
    {Name = "Seve de Bombu", Id = 16913},
    {Name = "Seve d'Erable", Id = 16914},
    {Name = "Seve d'Oliviolet", Id = 16915},
    {Name = "Seve d'If", Id = 16916},
    {Name = "Seve de Bambou", Id = 16917},
    {Name = "Seve de Merisier", Id = 16918},
    {Name = "Seve de Noisetier", Id = 16919},
    {Name = "Seve de Kaliptus", Id = 16921},
    {Name = "Seve de Charme", Id = 16922},
    {Name = "Seve de Bambou Sombre", Id = 16923},
    {Name = "Seve de Bambou Sacre", Id = 16925},
    {Name = "Seve d'Orme", Id = 16924},
    {Name = "Seve de Tremble", Id = 16926},
}

for _, element in ipairs(TABLE_VENTE_PL) do
	element.MaxHdv100 = 1
	element.MaxHdv10 = 1
end


local TableWichArea = {
	{MaxBucheron = 70, FirstArea = firstArea, SecondArea = firstArea, Gath = {1, 33, 34, 8}},
	{MaxBucheron = 80, FirstArea = secondArea, SecondArea = secondArea, Gath = {98, 8, 34}},
	{MaxBucheron = 90, FirstArea = forthArea, SecondArea = forthArea, Gath = {31, 8, 34}},
	{MaxBucheron = 100, FirstArea = thirdArea, SecondArea = thirdAreaBis, Gath = {101, 31, 8, 401}},
	{MaxBucheron = 110, FirstArea = forthAreaV2, SecondArea = forthAreaV2, Gath = {31, 8, 28, 35, 259, 29, 98}},
	{MaxBucheron = 120, FirstArea = sixthArea, SecondArea = sixthAreaBis, Gath = {108, 31, 8, 28}},
	{MaxBucheron = 140, FirstArea = forthAreaV3, SecondArea = forthAreaV3, Gath = {31, 28, 35, 259, 29, 98}},
	{MaxBucheron = 150, FirstArea = fifthArea, SecondArea = fifthAreaBis, Gath = {259, 29, 32, 35, 28}},
	{MaxBucheron = 160, FirstArea = eigthArea, SecondArea = eigthAreaBis, Gath = {121, 32, 35, 29, 28}},
	{MaxBucheron = 170, FirstArea = fifthAreaV2, SecondArea = fifthAreaV2Bis, Gath = {259, 29, 32, 35, 28}},
    {MaxBucheron = 180, FirstArea = seventhArea, SecondArea = seventhAreaBis, Gath = {108, 109}},
    {MaxBucheron = 201, FirstArea = fifthAreaV2, SecondArea = fifthAreaV2Bis, Gath = {259, 29, 32, 35, 28}},
}



local function antiModo()
    -- if global:isModeratorPresent(30) and job:level(2) > 5 then
	-- 	timerdisconnect = math.random(30000, 36000) 
    --     if not map:onMap("0,0") then
    --         map:changeMap("havenbag")
    --     end
    --     global:printError("Modérateur présent. On attend " .. timerdisconnect)
	-- 	if global:thisAccountController():getAlias():find("Bucheron2") then
    --         global:editAlias("Bucheron2 " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Bucheron3") then
	-- 		global:editAlias("Bucheron3 " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
	-- 	else
    --         global:editAlias("Bucheron " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
    --     end
    --     global:delay(timerdisconnect)
	-- 	customReconnect(timerdisconnect / 1000)
    --     map:changeMap("havenbag")
	-- end
end

local function ProcessBank() -- done
    NeedToReturnBank = false
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:putAllItems()
		global:delay(500)
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		exchange:putAllItems()
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end	
	
	    -- on prends les poissons en banque
    if not DDNourrie and mount:hasMount() then
        local tablePoisson = {
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
        for _, element in ipairs(tablePoisson) do
            if exchange:storageItemQuantity(element.Id) > 0 then
                exchange:getItem(element.Id, math.min(exchange:storageItemQuantity(element.Id), 200))
                break
            end
        end
    end

    for _, element in ipairs(Bois) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end

	local podsAvailable = inventory:podsMax() - inventory:pods()
	
	if exchange:storageItemQuantity(2357) < 100 and job:level(2) > 100 and character:kamas() >= 100000 and not StopOliviolet then
		global:printSuccess("je vais acheter de l'oliviolet")
		actualiser = false
		NeedToSell = true
		achatOliviolet = true
	end
	if exchange:storageItemQuantity(7013)  < 100 and job:level(2) > 120 and character:kamas() >= 100000 and not StopBambou then
		global:printSuccess("je vais acheter du bambou")
		actualiser = false
		NeedToSell = true
		achatBambou = true
	end

    for _, element in ipairs(Planches) do
        element.CanCraft = true
        for _, element2 in ipairs(element.ListIdCraft) do
            if not (exchange:storageItemQuantity(element2.Id) >= 50) or NeedToCraft then
                element.CanCraft = false
				break
            end
        end
        if element.CanCraft and not NeedToCraft and job:level(2) < element.lvlMax then
            NeedToSell = false
            NeedToCraft = true
            CraftQuantity = math.floor(podsAvailable/ (#element.ListIdCraft * 50))
            for _, element2 in ipairs(element.ListIdCraft) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(element2.Id) / element2.Nb))
            end

            global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")

            for _, element2 in ipairs(element.ListIdCraft) do
                exchange:getItem(element2.Id, CraftQuantity * element2.Nb)
            end
        end
    end
	
    if not NeedToCraft and not NeedToSell then
        for _, element in ipairs(Bois) do
            if element.LvlMinToSell ~= nil and job:level(2) >= element.LvlMinToSell and exchange:storageItemQuantity(element.Id) >= 330 and element.CanSell then
			    local QuantiteAPrendre = math.min(math.floor(podsAvailable / 5), exchange:storageItemQuantity(element.Id), 330)
                exchange:getItem(element.Id, QuantiteAPrendre)
				podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end
        for _, element in ipairs(Planches) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id), 33)
            if QuantiteAPrendre >= 20 and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
				podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end
		for _, element in ipairs(Seves) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id))
			if QuantiteAPrendre > 0 then
				exchange:getItem(element.Id, QuantiteAPrendre)
			end
        end
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
		if not NeedToSell then
        	NeedToSell = (cpt > 5) or (inventory:podsP() > 30)
		end
		
    end

    global:leaveDialog()
    global:delay(1000)
    map:door(518)
end
	
local function ProcessCraft() -- done
    NeedToCraft = false
	NeedToSell = true
	map:useById(500388, -1)
	global:delay(2000)
	
    for _, element in ipairs(Planches) do
        if element.CanCraft then
			global:printSuccess(element.Name)
            for _, element2 in ipairs(element.ListIdCraft) do
                craft:putItem(element2.Id, element2.Nb)
            end
			global:printSuccess(CraftQuantity)
            craft:changeQuantityToCraft(CraftQuantity)
            element.CanCraft = false
            global:delay(1000)
            craft:ready()
            global:delay(1000)
        end
    end

    global:leaveDialog() 
	global:delay(1000)
	map:moveToCell(341)
end
	
local function ProcessSell() -- done
    if mount:hasMount() and not DDNourrie then
        DDNourrie = true
        buyAndfeedDD()

        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end
    NeedToSell = false
	HdvSell()

	for _, element in ipairs(Planches) do
		local priceItem = GetPricesItem(element.Id)
        priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10
		priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price1 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
            sale:SellItem(element.Id, 10, priceItem.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

        cpt = get_quantity(element.Id).quantity["1"]
        while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < element.MaxHdv1 do 
            sale:SellItem(element.Id, 1, priceItem.Price1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. priceItem.Price1 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

		if itemSold then
            randomDelay()
        end
    end

    for _, element in ipairs(Bois) do
		local itemSold = false

        local priceItem = GetPricesItem(element.Id)
		priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100
		priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10

        cpt = get_quantity(element.Id).quantity["100"]
    	while inventory:itemCount(element.Id) >= 100 and sale:availableSpace() > 0 and cpt < element.MaxHdv100 do 
            sale:SellItem(element.Id, 100, priceItem.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. priceItem.Price100 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
            sale:SellItem(element.Id, 10, priceItem.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end

		if itemSold then
			randomDelay()
		end
    end

     for _, element in ipairs(Seves) do
		local itemSold = false

        local priceItem = GetPricesItem(element.Id)
		priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price0 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1
        cpt = get_quantity(element.Id).quantity["1"]

        while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < element.MaxHdv1 do 
            sale:SellItem(element.Id, 1, priceItem.Price1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. priceItem.Price1 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

		if itemSold then
			randomDelay()
		end
     end

	global:leaveDialog()
		
	table.sort(TABLE_VENTE_PL, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

	HdvSell()
	-- vente par 100, 10 des récoles alchimiste
	for i, element in ipairs(TABLE_VENTE_PL) do
		if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

        local priceItem = GetPricesItem(element.Id)
		priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100
		priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10

        cpt = get_quantity(element.Id).quantity["100"]
    	while inventory:itemCount(element.Id) >= 100 and sale:availableSpace() > 0 and cpt < element.MaxHdv100 do 
            sale:SellItem(element.Id, 100, priceItem.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. priceItem.Price100 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
            sale:SellItem(element.Id, 10, priceItem.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
            cpt = cpt + 1
        end

    end

	global:leaveDialog()

    HdvSell()

    -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
    for _, element in ipairs(Planches) do
        if get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 and get_quantity(element.Id).quantity["1"] >= element.MaxHdv1  then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
    for _, element in ipairs(Bois) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
	for _, element in ipairs(TABLE_VENTE_PL) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end

	if cptActualiser == 3 then
		cptActualiser = 0
		global:printSuccess("on actualise")
		sale:updateAllItems()
	else
		cptActualiser = cptActualiser + 1
	end
		
	if sale:AvailableSpace() == 0 then
	    global:printError(" il n'y a plus de place dans l'hdv")
	elseif sale:AvailableSpace() > 0 then
	    NeedToReturnBank = true
	end

    global:leaveDialog()

	if achatOliviolet then
		npc:npc(333, 6) 
		global:delay(500)
		sale:buyItem(2357,100,30000)
		global:delay(500)
		achatOliviolet = false
		if inventory:itemCount(2357) < 100 then
			StopOliviolet = true
		end
		global:leaveDialog()
	end
	if achatBambou then
		npc:npc(333, 6) 
		global:delay(500)
		sale:buyItem(7013,100,30000)
		global:delay(500)
		achatBambou = false
		if inventory:itemCount(7013) < 100 then
			StopBambou = true
		end
		global:leaveDialog()
	end
	map:changeMap("top")
end


local function whichArea()
    for _, element in ipairs(TableWichArea) do
        if job:level(2) < element.MaxBucheron and not ZoneBis then
            GATHER = element.Gath
            return treatMaps(element.FirstArea, function() map:changeMap("havenbag") end)
        elseif job:level(2) < element.MaxBucheron and ZoneBis then
            GATHER = element.Gath
            return treatMaps(element.SecondArea, function() map:changeMap("havenbag") end)
        end
    end
end


local function takeKamas()
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end
	global:leaveDialog()
	if character:kamas() > 1200000 then
		global:loadAndStart(scriptPath)
	else
		global:printSuccess("Reco dans 2h")
		customReconnect(math.random(80, 120))
	end
end

if not global:remember("increm") then
	global:addInMemory("increm", 0)
end


function move()
	handleDisconnection()
	mapDelay()
	if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
		global:thisAccountController():forceDelete(character:name())
		global:disconnect()
	end
	--[[job:level(2) < 50 and global:getCountGather() > 0 and (global:getCountGather() + global:remember("increm")) % (global:remember("increm") == 0 and 50 or 400) == 0 then
		global:editInMemory("increm", global:remember("increm") + 1)
		customReconnect(math.random(80, 120))

	end]]
	if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end
	if getRemainingSubscription(true) < 0 then
		for _, element in ipairs(pathTakeKamas) do
			if map:onMap(element.map) then
				return pathTakeKamas
			end
		end
		map:moveToward(192415750)
	end
	antiModo()

    for i = 1, NB_BUCHERON do
        if global:thisAccountController():getAlias():find("Bucheron" .. i) then
            global:editAlias("Bucheron" .. i .. " " .. character:server() .. " [" .. job:level(2) .. "] " .. getRemainingSubscription(true), true)
            break
        end
    end

	if job:level(2) >= 180 then	
		global:printSuccess("changement de script")
		global:loadAndStart(scriptPath)
	end

    if map:currentMapId() == 206308353 then 
        map:changeMap("bottom")
	elseif map:onMap(153621) then
		map:changeMap("left")
	end
	
    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map ="0,0", path = "zaap(147590153)"},
			{map = "-17,-47", path = "right"},
			{map = "-16,-47", path = "right"},
			{map = "-15,-47", path = "right"},
			{map = "-14,-47", path = "right"},
			{map = "-13,-47", path = "top"},
			{map = "-13,-48", path = "top"},
			{map = "-13,-49", path = "top"},
			{map = "-13,-50", path = "top"},
            {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
            {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
        }
    end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "zaapi(212601350)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end

	
    givingTriggerValue = ((getRemainingSubscription(true) > 0) and (job:level(2) < 150)) and 750000 or ((getRemainingSubscription(true) > 0) and (job:level(2) < 200)) and 1000000 or 2000000
	minKamas = (getRemainingSubscription(true) == 0) and 1700000 or 300000

	forwardKamasBotBankIfNeeded(givingTriggerValue, minKamas, 120, 6)

    return whichArea()
end

function bank()
	mapDelay()
    ZoneBis = false

    for i = 1, NB_BUCHERON do
        if global:thisAccountController():getAlias():find("Bucheron" .. i) then
            global:editAlias("Bucheron" .. i .. " " .. character:server() .. " [" .. job:level(2) .. "] " .. getRemainingSubscription(true), true)
            break
        end
    end

    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map ="0,0", path = "zaap(147590153)"},
			{map = "-17,-47", path = "right"},
			{map = "-16,-47", path = "right"},
			{map = "-15,-47", path = "right"},
			{map = "-14,-47", path = "right"},
			{map = "-13,-47", path = "top"},
			{map = "-13,-48", path = "top"},
			{map = "-13,-49", path = "top"},
			{map = "-13,-50", path = "top"},
            {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
            {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
        }
    end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "zaapi(212601350)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end


    for _, element in ipairs(MAPS_SANS_HAVRESAC) do
       if not element.Door and map:onMap(tostring(element.Id)) then
		if map:currentCell() == tonumber(element.Path) then
			map:moveToCell(math.random(50, 500))
		end
           return {{map = tostring(element.Id), path = element.Path}}
       elseif map:onMap(tostring(element.Id)) then
           return {{map = tostring(element.Id), door = element.Door}}
       end
    end		
		
	if map:currentMapId()~=217059328 and map:currentMap()~= "-31,-57" and map:currentMap()~= "-31,-56" and map:currentMap()~=104861191 and map:currentMap()~=104862215 and map:currentMap()~=104859143  and map:currentMap()~=104859145 and map:currentMap()~=104860169 and map:currentMap()~=104861193   and map:currentMap()~=104862217 and map:currentMap()~=2885641 and map:currentMap()~=145209 and map:currentMap()~=2884113 and map:currentMapId()~=2885641 and map:currentMapId()~=147768 and map:currentMapId()~=162791424 and map:currentMapId()~=191104004 and map:currentMapId()~=7340551 and map:currentMapId()~="-32,-56" and map:currentMap()~="-4,2" and map:currentMapId()~=191104004  then 
		return{
			{map=tostring(map:currentMap()),path="havenbag"}}
		end
	
    return { 
		{map ="104861191", path = "457"},
		{map ="104862217", path = "369"},
		{map ="104861193", path = "454"},
		{map ="104859145", path = "192"},
		{map ="104860169", path = "379"},
		{map ="104858121", path = "507"},
		{map ="104072452", custom = easy },
		{map ="104072451", path ="havenbag"},
		{map="0,0",path="zaap(212600323)"},
		{map="-31,-56",path="top"},
		{map="212600322", door = "468"},
		{map = "217059328", custom = ProcessBank},
    }
end

function stopped()
    map:changeMap("havenbag")
end

function banned()
    global:editAlias(phrase .. " [BAN]", true)
end

function PHENIX()
	return PHENIX
end