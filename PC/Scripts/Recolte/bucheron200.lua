---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")

dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\IA\\IA_SacriFeuRecolte.lua")


OPEN_BAGS = true 
GATHER_NEXT_DELAY_MIN = 0
GATHER_NEXT_DELAY_MAX = 50
GATHER_NEW_DELAY_MIN = 500
GATHER_NEW_DELAY_MAX = 2000
local DebutDuScript = true
local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local cpt = 0
local cptActualiser = 0

local hdvFull = false
STOP = false


local substrat_de_sylve = 16460
local CanSellSubstratDeSylve = true


------------------------

local phrase = nil
for i = 1, NB_BUCHERON do
    if global:thisAccountController():getAlias():find("Bucheron" .. i) then
        phrase = "Bucheron" .. i .. " " .. character:server()
        break
    end
end

local function RegenEnergie()
    local tableAchatEnergie = {
        {name = "Pain des champs", id = 1737},
        {name = "Potion axel raide", id = 16722},
        {name = "Potion Raide izdaide", id = 16414},
        {name = "Estouffade de Morue", id = 16481},
        {name = "Filet Mignon", id = 17199},
        {name = "Aileron de Requin", id = 1838},
        {name = "Daube aux Epices", id = 17195},
        {name = "Mantou", id = 527},
        {name = "Andouillette de Gibier", id = 17203},
        {name = "Espadon Poellé", id = 16485},
        {name = "Espadon Poellé", id = 16485},
        {name = "Aile de Raie", id = 1814},
    }
    for _, element in ipairs(tableAchatEnergie) do
        npc:npc(385,6)

        if inventory:itemCount(element.id) <= 20 and character:maxEnergyPoints() - character:energyPoints() > 500 then
            sale:buyItem(element.id, 10, 20000)
        end
        if inventory:itemCount(element.id) <= 10 and character:maxEnergyPoints() - character:energyPoints() > 500 then
            sale:buyItem(element.id, 1, 2000)
            sale:buyItem(element.id, 1, 2000)
            sale:buyItem(element.id, 1, 2000)
            sale:buyItem(element.id, 1, 2000)
        end
        global:leaveDialog()

        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints() - character:energyPoints() ~= 0 do
            inventory:useItem(element.id)
        end

    end

	npc:npc(385,5)
	global:delay(1500)
	if inventory:itemCount(678) >= 100 then
		itemname = inventory:itemNameId(678)
		Priceitem = GetPricesItemInHdvSell(678).Price100

		if Priceitem > 400 then -- 
			while (inventory:itemCount(678) >= 100) and (sale:availableSpace() > 0) do 
				sale:SellItem(678, 100, Priceitem -1) 
				global:printSuccess("1 lot de " .. 100 .. " x " .. itemname .. " à " .. Priceitem -1 .. "kamas")
			end 
		   end
		end
		if inventory:itemCount(680) >= 10 then

		itemname = inventory:itemNameId(680)
		Priceitem = GetPricesItemInHdvSell(678).Price10

		if Priceitem > 400 then -- 
			while (inventory:itemCount(680) >= 10) and (sale:availableSpace() > 0) do 
				sale:SellItem(680, 10, Priceitem -1) 
				global:printSuccess("1 lot de " .. 10 .. " x " .. itemname .. " à " .. Priceitem -1 .. "kamas")
			end 
		end
	end
		
	global:delay(1500)
	global:leaveDialog()
	map:changeMap("top")
end

local AreaEnergie = {
    {map = "0,0", path = "zaap(212600323)"},
	{map= "-31,-56", path="bottom"},
	{map= "-31,-55", path="bottom"},
	{map= "-31,-54", path="bottom"},
	{map = "-31,-53", custom = RegenEnergie}, 
}

local function achatSacStaca()
    buyWorthItem(1704) 
    inventory:equipItem(1704, 7)
    ChoosePath()
    map:changeMap("right")
end

local AreaAchatSacStaca = {
    {map = "0,0", path = "zaap(212600323)"},
    {map="212600323", path="bottom"},
    {map="-31,-55", custom = achatSacStaca},
}
 
local Frigost = {
    {map = "0,0", path = "zaap(54172969)"},
    {map = "-78,-41", path = "top"}, -- zone frigost
    {map = "-78,-42", path = "top"},
    {map = "-78,-43", path = "top"},
    {map = "-78,-44", path = "top"},
    {map = "-78,-45", path = "top"},
    {map = "-78,-46", path = "right"},
    {map = "-77,-46", path = "right"},
    {map = "-76,-46", path = "right"},
    {map = "-75,-46", path = "right"},
    {map = "-74,-46", path = "right"},
    {map = "-73,-46", path = "top", gather = true},
    {map = "-74,-52", path = "top", gather = true},
    {map = "-75,-49", path = "top", gather = true},
    {map = "-73,-49", path = "left", gather = true},
    {map = "-74,-54", path = "right", gather = true},
    {map = "-72,-54", path = "right", gather = true},
    {map = "-68,-60", path = "right", gather = true},
    {map = "-73,-53", path = "right", gather = true},
    {map = "-73,-48", path = "top"},
    {map = "-73,-47", path = "top"},
    {map = "-74,-50", path = "top"},
    {map = "-74,-51", path = "top"},
    {map = "-68,-54", path = "top"},
    {map = "-68,-55", path = "top"},
    {map = "-68,-56", path = "top"},
    {map = "-68,-57", path = "top"},
    {map = "-68,-58", path = "top"},
    {map = "-68,-59", path = "top", gather = true},
    {map = "-64,-61", path = "top"},
    {map = "-61,-63", path = "top"},
    {map = "-75,-50", path = "right"},
    {map = "-71,-54", path = "right"},
    {map = "-70,-54", path = "right"},
    {map = "-69,-54", path = "right"},
    {map = "-67,-60", path = "right", gather = true},
    {map = "-66,-60", path = "right"},
    {map = "-63,-63", path = "right"},
    {map = "-62,-63", path = "right"},
    {map = "-60,-64", path = "right"},
    {map = "-59,-64", path = "right"},
    {map = "-57,-68", path = "right"},
    {map = "-74,-49", path = "left", gather = true},
    {map = "-74,-53", path = "top"},
    {map = "-73,-54", path = "bottom"},
    {map = "-72,-53", path = "top"},
    {map = "-65,-60", path = "right", gather = true},
    {map = "-64,-60", path = "top", gather = true},
    {map = "-65,-63", path = "right", gather = true},
    {map = "-64,-63", path = "right", gather = true},
    {map = "-61,-64", path = "right", gather = true},
    {map = "-65,-62", path = "top"},
    {map = "-64,-62", path = "left"},
    {map = "-58,-65", path = "top"},
    {map = "-58,-66", path = "top"},
    {map = "-58,-67", path = "top"},
    {map = "-58,-64", path = "top", gather = true},
    {map = "-58,-68", path = "right", gather = true},
    {map = "-56,-68", path = "bottom", gather = true},
    {map = "-56,-67", path = "bottom"},
    {map = "-56,-66", path = "bottom"},
    {map ="-58,-55", path = "left"},
    {map = "-56,-65", path = "bottom"},
    {map = "-56,-64", path = "bottom"},
    {map = "-56,-63", path = "bottom"},
    {map = "-56,-62", path = "bottom"},
    {map = "-59,-61", path = "bottom", gather = true},
    {map = "-57,-59", path = "bottom", gather = true},
    {map = "-60,-53", path = "bottom", gather = true},
    {map = "-56,-61", path = "left"},
    {map = "-57,-61", path = "left"},
    {map = "-58,-61", path = "left"},
    {map = "-59,-60", path = "bottom"},
    {map = "-59,-59", path = "right"},
    {map = "-58,-59", path = "right"},
    {map = "-57,-58", path = "right"},
    {map = "-56,-58", path = "right"},
    {map = "-55,-58", path = "bottom"},
    {map = "-55,-57", path = "left", gather = true},
    {map = "-56,-57", path = "left"},
    {map = "-57,-57", path = "bottom"},
    {map = "-57,-56", path = "left", gather = true},
    {map = "-58,-54", path = "bottom", gather = true},
    {map = "-58,-56", path = "bottom"},
    {map = "-59,-55", path = "bottom"},
    {map = "-59,-54", path = "right"},
    {map = "-58,-53", path = "left"},
    {map = "-59,-53", path = "left"},
    {map = "-60,-52", path = "left"},
    {map = "-61,-52", path = "left"},
    {map = "-62,-52", path = "left"},
    {map = "-63,-52", path = "left"},
    {map = "-64,-52", path = "left"},
    {map = "-65,-52", path = "bottom"},
    {map = "-65,-51", path = "right"},
    {map = "-64,-51", path = "bottom"},
    {map = "-64,-50", path = "bottom"},
    {map = "-64,-49", path = "left", gather = true},
    {map = "-65,-49", path = "bottom"},
    {map = "-65,-48", path = "bottom"},
    {map = "-65,-47", path = "left", gather = true},
    {map = "-66,-47", path = "top", gather = true},
    {map = "-66,-48", path = "left", gather = true},
}

local Otomai = {
    {map = "0,0", path = "zaap(154642)"},
    {map = "-46,18", path = "left"},
    {map = "-47,19", path = "left"},
    {map = "-48,19", path = "left"},
    {map = "-49,19", path = "left"},
    {map = "-50,21", path = "left"},
    {map = "-47,18", path = "bottom"},
    {map = "-50,19", path = "bottom"},
    {map = "-50,20", path = "bottom"},
    {map = "-51,20", path = "top", gather = true},
    {map = "-51,18", path = "top", gather = true},
    {map = "-51,16", path = "top", gather = true},
    {map = "-51,13", path = "top", gather = true},
    {map = "-51,12", path = "left", gather = true},
    {map = "-52,12", path = "left", gather = true},
    {map = "-53,12", path = "top", gather = true},
    {map = "-53,10", path = "top", gather = true},
    {map = "-53,9", path = "left(252)", gather = true},
    {map = "-53,11", path = "left", gather = true},
    {map = "-54,11", path = "top"},
    {map = "-54,10", path = "right", gather = true},
    {map = "-54,9", path = "left", gather = true},
    {map = "-55,9", path = "bottom", gather = true},
    {map = "-55,10", path = "bottom", gather = true},
    {map = "-55,11", path = "bottom", gather = true},
    {map = "-51,19", path = "left", gather = true},
    {map = "-52,19", path = "top", gather = true},
    {map = "-52,18", path = "right"},
    {map = "-51,17", path = "left", gather = true},
    {map = "-52,17", path = "top", gather = true},
    {map = "-52,16", path = "right", gather = true},
    {map = "-51,15", path = "top"},
    {map = "-51,14", path = "left"},
    {map = "-52,14", path = "left"},
    {map = "-53,14", path = "top"},
    {map = "-53,13", path = "right", gather = true},
    {map = "-52,13", path = "right", gather = true},
    {map = "-55,12", path = "bottom", gather = true},
    {map = "-54,14", path = "bottom", gather = true},
    {map = "-54,15", path = "bottom", gather = true},
    {map = "-54,16", path = "bottom", gather = true},
    {map = "-56,15", path = "bottom", gather = true},
    {map = "-56,16", path = "bottom", gather = true},
    {map = "-56,17", path = "bottom", gather = true},
    {map = "-56,18", path = "bottom", gather = true},
    {map = "-56,19", path = "bottom", gather = true},
    {map = "-56,20", path = "right", gather = true},
    {map = "-55,21", path = "right", gather = true},
    {map = "-54,20", path = "right", gather = true},
    {map = "-54,13", path = "bottom"},
    {map = "-55,13", path = "right"},
    {map = "-54,17", path = "left", gather = true},
    {map = "-55,17", path = "top", gather = true},
    {map = "-55,16", path = "top"},
    {map = "-55,15", path = "left"},
    {map = "-55,20", path = "bottom", gather = true},
    {map = "-54,21", path = "top", gather = true},
    {map = "-53,20", path = "bottom", gather = true},
    {map = "-51,21", path = "top"},
}

local ForetCania = {
    {map = "0,0", path = "zaap(147590153)"}, 
	{map = "-17,-47", path = "right"},
		{map = "-16,-47", path = "right"},
		{map = "-15,-47", path = "top"},
		{map = "-15,-48", path = "top"},
		{map = "-15,-49", path = "top"},
		{map = "-15,-51", path = "top"},
		{map = "-15,-52", path = "top"},
		{map = "-14,-54", path = "right"},
		{map = "-13,-54", path = "bottom"},
		{map = "-13,-53", path = "left"},
		{map = "-14,-53", path = "bottom"},
		{map = "-14,-51", path = "bottom", gather = true},
		{map = "-14,-50", path = "right", gather = true},
		{map = "-13,-50", path = "right"},
		{map = "-12,-49", path = "bottom", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-15,-50", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-52", path = "bottom", gather = true},
		{map = "-12,-50", path = "bottom", gather = true},
		{map = "-13,-48", path = "bottom", gather = true},
		{map = "-13,-47", path = "bottom", gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "bottom", gather = true},
		{map = "-13,-43", path = "bottom", gather = true},
		{map = "-11,-46", path = "bottom", gather = true},
		{map = "-11,-44", path = "bottom", gather = true},
		{map = "-13,-42", path = "right", gather = true},
		{map = "-12,-46", path = "right", gather = true},
		{map = "-11,-42", path = "right", gather = true},
		{map = "-10,-42", path = "right(111)", gather = true},
		{map = "-12,-42", path = "top", gather = true},
		{map = "-12,-43", path = "top", gather = true},
		{map = "-12,-45", path = "top", gather = true},
		{map = "-9,-42", path = "top", gather = true},
		{map = "-9,-44", path = "top", gather = true},
		{map = "-9,-45", path = "top", gather = true},
		{map = "-12,-44", path = "top"},
		{map = "-11,-45", path = "bottom"},
		{map = "-11,-43", path = "bottom"},
		{map = "-9,-43", path = "top"},
		{map = "-9,-46", path = "left", gather = true},
		{map = "-10,-46", path = "bottom", gather = true},
		{map = "-22,-72", path = "bottom", gather = true},
		{map = "-15,-53", path = "left"},
		{map = "-16,-53", path = "left"},
		{map = "-17,-53", path = "left"},
		{map = "-18,-53", path = "top"},
		{map = "-18,-54", path = "top"},
		{map = "-18,-55", path = "top", gather = true},
		{map = "-18,-56", path = "right"},
		{map = "-17,-56", path = "right"},
		{map = "-16,-56", path = "top"},
		{map = "-16,-57", path = "top", gather = true},
		{map = "-16,-58", path = "top"},
		{map = "-16,-59", path = "top"},
		{map = "-16,-60", path = "right", gather = true},
		{map = "-15,-60", path = "right"},
		{map = "-14,-60", path = "right"},
		{map = "-11,-58", path = "left"},
		{map = "-12,-58", path = "left"},
		{map = "-13,-58", path = "left"},
		{map = "-14,-58", path = "left"},
		{map = "-15,-58", path = "bottom"},
		{map = "-15,-57", path = "bottom"},
		{map = "-15,-56", path = "bottom"},
		{map = "-15,-55", path = "bottom"},
		{map = "-8,-58", path = "left", gather = true},
		{map = "-8,-59", path = "bottom"},
		{map = "-9,-58", path = "left"},
		{map = "-12,-59", path = "right"},
		{map = "-11,-59", path = "right", gather = true},
		{map = "-10,-59", path = "right"},
		{map = "-9,-59", path = "right"},
		{map = "-10,-58", path = "left"},
		{map = "-13,-59", path = "right"},
		{map = "-13,-60", path = "bottom"},
}

local Koalak = {
    {map = "0,0", path = "zaap(73400320)"},
    {map = "-16,1", path = "bottom"}, -- zone koalak
    {map = "-16,2", path = "bottom"},
    {map = "-16,3", path = "bottom", gather = true},
    {map = "-16,4", path = "bottom"},
    {map = "-16,5", path = "bottom"},
    {map = "-16,6", path = "left"},
    {map = "-17,6", path = "left", gather = true},
    {map = "-18,6", path = "left", gather = true},
    {map = "-19,6", path = "top"},
    {map = "-19,5", path = "left"},
    {map = "-20,5", path = "bottom"},
    {map = "-20,6", path = "bottom"},
    {map = "-20,7", path = "left"},
    {map = "-21,7", path = "left"},
    {map = "-22,7", path = "top", gather = true},
    {map = "-22,6", path = "right", gather = true},
    {map = "-21,6", path = "top", gather = true},
    {map = "-21,5", path = "left"},
    {map = "-22,5", path = "top", gather = true},
    {map = "-22,4", path = "top"},
    {map = "-22,3", path = "top"},
    {map = "-22,2", path = "top"},
    {map = "-22,1", path = "top"},
    {map = "-22,0", path = "top"},
    {map = "-22,-1", path = "top"},
    {map = "-22,-2", path = "right", gather = true},
    {map = "-21,-2", path = "top"},
    {map = "-21,-3", path = "right", gather = true},
    {map = "-20,-3", path = "top"},
    {map = "-20,-4", path = "left"},
}

local Koalak2 = {
    {map = "-21,-4", path = "right", gather = true},
    {map = "-20,-4", path = "top"},
    {map = "-20,-5", path = "top", gather = true},
    {map = "-20,-6", path = "right"},
    {map = "-19,-6", path = "right", gather = true},
    {map = "-17,-6", path = "top"},
    {map = "-16,-7", path = "top"},
    {map = "-17,-7", path = "right", gather = true},
    {map = "-15,-7", path = "right", gather = true},
    {map = "-14,-7", path = "top", gather = true},
    {map = "-14,-8", path = "top"},
    {map = "-14,-9", path = "top"},
    {map = "-14,-10", path = "left"},
    {map = "-15,-10", path = "left", gather = true},
    {map = "-16,-8", path = "top", gather = true},
    {map = "-16,-9", path = "right"},
    {map = "-15,-9", path = "bottom(556)", gather = true},
    {map = "-15,-8", path = "bottom"},
    {map = "-16,-10", path = "top", gather = true},
    {map = "-16,-11", path = "right"},
    {map = "-15,-11", path = "right"},
    {map = "-14,-11", path = "right"},
    {map = "-13,-11", path = "bottom"},
    {map = "-13,-10", path = "bottom"},
    {map = "-13,-9", path = "right"},
    {map = "-12,-9", path = "bottom", gather = true},
    {map = "-18,-6", path = "bottom", gather = true},
    {map = "-17,-5", path = "top", gather = true},
    {map = "-18,-3", path = "right", gather = true},
    {map = "-18,-5", path = "bottom", gather = true},
    {map = "-18,-4", path = "bottom", gather = true},
    {map = "-17,-3", path = "top", gather = true},
    {map = "-17,-4", path = "top", gather = true},
}

local Pandala = {
    {map = "0,0", path = "zaap(207619076)"},
    {map = "207619076", path = "436"}, -- zaap pandala intérieur
    {map = "206307842", path = "left"}, -- sortie zaap pandala
    {map = "19,-30", path = "left"},
    {map = "18,-30", path = "left"},
    {map = "19,-29", path = "top", gather = true},
    {map = "17,-30", path = "left", gather = true},
    {map = "16,-30", path = "top", gather = true},
    {map = "18,-31", path = "top", gather = true},
    {map = "16,-33", path = "right", gather = true},
    {map = "16,-31", path = "right", gather = true},
    {map = "17,-31", path = "right", gather = true},
    {map = "18,-32", path = "left", gather = true},
    {map = "17,-32", path = "left", gather = true},
    {map = "16,-32", path = "top", gather = true},
    {map = "18,-35", path = "right", gather = true},
    {map = "17,-33", path = "right", gather = true},
    {map = "18,-33", path = "top", gather = true},
    {map = "18,-34", path = "top", gather = true},
    {map = "19,-35", path = "top"},
    {map = "19,-36", path = "right", gather = true},
    {map = "20,-36", path = "top", gather = true},
    {map = "20,-37", path = "right"},
    {map = "21,-37", path = "right"},
}

local Pandala2 = {
    {map = "22,-37", path = "left", gather = true},
    {map = "21,-37", path = "bottom"},
    {map = "21,-36", path = "bottom"},
    {map = "21,-35", path = "bottom"},
    {map = "21,-34", path = "right", gather = true},
    {map = "22,-34", path = "right"},
    {map = "23,-34", path = "right", gather = true},
    {map = "24,-34", path = "top"},
}

local Pandala3 = {
    {map = "24,-35", path = "bottom", gather = true},
    {map = "24,-34", path = "bottom"},
    {map = "24,-33", path = "right", gather = true},
    {map = "25,-33", path = "bottom", gather = true},
    {map = "25,-32", path = "bottom", gather = true},
    {map = "25,-31", path = "right", gather = true},
    {map = "27,-31", path = "bottom", gather = true},
    {map = "26,-31", path = "right"},
    {map = "27,-30", path = "bottom", gather = true},
    {map = "27,-29", path = "left", gather = true},
    {map = "26,-29", path = "top"},
    {map = "26,-30", path = "left", gather = true},
    {map = "25,-30", path = "left", gather = true},
    {map = "24,-30", path = "bottom", gather = true},
    {map = "24,-29", path = "left"},
    {map = "23,-29", path = "left", gather = true},
}

local Sidimote = {
    {map = "0,0", path = "zaap(171967506"},
    {map = "-25,11", path = "top", gather = true}, -- zone oliviolet
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
    {map = "-26,-5", path = "havenbag", gather = true},
}

local function TakeKamas()
    npc:npcBank(-1)
    global:delay(500)
    if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
        global:delay(500)
        global:printSuccess("j'ai récupérer les kamas, je retourne farmer")
        global:leaveDialog()
    elseif exchange:storageKamas() == 0 then
        global:printError("il n'y a pas de kamas dans la banque on attend un peu")
        global:leaveDialog()
        customReconnect(60)
    end
end

local GoTakeKamas = {
    {map="0,0",path="zaap(212600323)"},
    {map="-31,-56",path="top"},
    {map="212600322", door = "468"},
    {map = "217059328", custom = TakeKamas},
}

local TableWhichArea = {
	{MapSwitch = "-67,-48", Area = Frigost, AreaString = "Île de Frigost", Farmer = false},
	{MapSwitch = "-53,21", Area = Otomai, AreaString = "Île d'Otomaï", Farmer = false},
	{MapSwitch = "-10,-45", Area = ForetCania, AreaString = "Plaines de Cania", Farmer = false},
	{MapSwitch = "-21,-4", Area = Koalak, AreaString = "Montagne des Koalaks", Farmer = false},
    {MapSwitch = "-12,-8", Area = Koalak2, AreaString = "Montagne des Koalaks", Farmer = false},
	{MapSwitch = "21,-37", Area = Pandala, AreaString = "Île de Pandala", Farmer = false},
    {MapSwitch = "24,-34", Area = Pandala2, AreaString = "Île de Pandala", Farmer = false},
    {MapSwitch = "22,-29", Area = Pandala3, AreaString = "Île de Pandala", Farmer = false},
	{MapSwitch = "-26,-5", Area = Sidimote, AreaString = "Landes de Sidimote", Farmer = false},
}

local function randomRotate(table)
    local n = #table
    if n == 0 then return {} end

    -- Ensemble des MapSwitch interdits en 1ère position
    local forbidden = {
        ["-12,-8"] = true,  -- Koalak2
        ["24,-34"]  = true,  -- Pandala2
        ["22,-29"]  = true,  -- Pandala3
        ["-26,-5"]  = true,  -- Sidimote
    }

    -- Recherche d’un index de départ valide
    local startIdx
    local tries = 0
    repeat
        startIdx = math.random(1, n)
        tries = tries + 1
        -- sécurité : si on tourne trop, on abandonne et on prend 1
        if tries > 10 then
            startIdx = 1
            break
        end
    until not forbidden[table[startIdx].MapSwitch]

    -- Construction de la table tournée
    local rotated = {}
    for i = 1, n do
        -- (startIdx + i - 2) % n + 1 : calcule l’indice cyclique
        local idx = ((startIdx + i - 2) % n) + 1
        rotated[i] = table[idx]
    end

    return rotated
end

if not global:thisAccountController():getAlias():find("Bucheron1") then
    TableWhichArea = randomRotate(TableWhichArea)
end


local Planches = {
    {Name = "Planche de Salut", Id = 16499, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 7016, Quantity = 10}, {Id = 7014, Quantity = 10}, {Id = 472, Quantity = 10}, {Id = 7925, Quantity = 10}, {Id = 470, Quantity = 10}, {Id = 11107, Quantity = 10}, {Id = 449, Quantity = 10}, {Id = 16488, Quantity = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Planche a Dessin", Id = 16498, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 7016, Quantity = 10}, {Id = 474, Quantity = 10}, {Id = 472, Quantity = 10}, {Id = 7925, Quantity = 10}, {Id = 470, Quantity = 10}, {Id = 7013, Quantity = 10}, {Id = 449, Quantity = 10}, {Id = 16488, Quantity = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Planche a Pain", Id = 16497, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Quantity = 10}, {Id = 474, Quantity = 10}, {Id = 472, Quantity = 10}, {Id = 7925, Quantity = 10}, {Id = 7013, Quantity = 10}, {Id = 449, Quantity = 10}, {Id = 16488, Quantity = 10}}, lvlMax = 180, CanSell = true},
    {Name = "Planche de Gravure", Id = 16496, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Quantity = 10}, {Id = 474, Quantity = 10}, {Id = 2357, Quantity = 5}, {Id = 7013, Quantity = 10}, {Id = 449, Quantity = 10}, {Id = 16488, Quantity = 10}, {Id = 27375, Quantity = 5}}, lvlMax = 160, CanSell = true},
    {Name = "Planche a Patisserie", Id = 16495, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Quantity = 10}, {Id = 474, Quantity = 10}, {Id = 2357, Quantity = 5}, {Id = 7013, Quantity = 10}, {Id = 2358, Quantity = 10}, {Id = 471, Quantity = 10}, {Id = 27375, Quantity = 5}}, lvlMax = 140, CanSell = true},
    {Name = "Planche de Toilettes", Id = 16494, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 461, Quantity = 10}, {Id = 2357, Quantity = 5}, {Id = 460, Quantity = 10}, {Id = 2358, Quantity = 10}, {Id = 471, Quantity = 10}, {Id = 27375, Quantity = 5}}, lvlMax = 120, CanSell = true},
	{Name = "Planche a Repasser", Id = 16493, MaxHdv10 = 5, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Quantity = 10}, {Id = 460, Quantity = 10}, {Id = 2358, Quantity = 10}, {Id = 471, Quantity = 10}}, lvlMax = 100, CanSell = true},
    {Name = "Planche de Surf", Id = 16492, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Quantity = 10}, {Id = 303, Quantity = 10}, {Id = 460, Quantity = 10}, {Id = 473, Quantity = 10}}, lvlMax = 80, CanSell = true},
    {Name = "Planche a Griller", Id = 16491, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 476, Quantity = 10}, {Id = 303, Quantity = 10}, {Id = 473, Quantity = 10}}, lvlMax = 60, CanSell = true},
    {Name = "Planche Contreplaquee", Id = 16489, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 303, Quantity = 10}, {Id = 473, Quantity = 10}}, lvlMax = 40, CanSell = true},
}

for _, element in ipairs(Planches) do
    element.ListIdCraft = getRecipe(element.Id)
end

local Bois = {
    {Name = "Tremble", Id = 11107, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Bambou Sacre", Id = 7014, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Orme", Id = 470, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Bambou Sombre", Id = 7016, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Charme", Id = 472, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Kaliptus", Id = 7925, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Ebene", Id = 449, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Noisetier", Id = 16488, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Mersier", Id = 474, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Bambou", Id = 7013, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "If", Id = 461, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Oliviolet", Id = 2357, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Pin", Id = 27375, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Erable", Id = 471, MaxHdv100= 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Bombu", Id = 2358, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Chene", Id = 460, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Noyer", Id = 476, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Chataignier", Id = 473, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    {Name = "Frene", Id = 303, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
}

local TableGather = {
    {Name = "Frene", IdRessource = 1, IdObjet = 303, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Chataignier", IdRessource = 33, IdObjet = 473, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Noyer", IdRessource = 34, IdObjet = 476, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Chene", IdRessource = 8, IdObjet = 460, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Bombu", IdRessource = 98, IdObjet = 2358, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Erable", IdRessource = 31, IdObjet = 471, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Oliviolet", IdRessource = 101, IdObjet = 2357, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Pin", IdRessource = 27375, IdObjet = 401, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "If", IdRessource = 28, IdObjet = 461, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Bambou", IdRessource = 108, IdObjet = 7013, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Mersier", IdRessource = 35, IdObjet = 474, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Noisetier", IdRessource = 259, IdObjet = 16488, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Ebene", IdRessource = 29, IdObjet = 449, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Kaliptus", IdRessource = 121, IdObjet = 7925, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Charme", IdRessource = 32, IdObjet = 472, Max = 200 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Bambou Sombre", IdRessource = 109, IdObjet = 7016, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Orme", IdRessource = 30, IdObjet = 470, Max = 200 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Bambou Sacre", IdRessource = 110, IdObjet = 7014, Max = 150 * inventory:podsMax() / 6100, Farmer = true},
    {Name = "Tremble", IdRessource = 133, IdObjet = 11107, Max = 200 * inventory:podsMax() / 6100, Farmer = true},

}

local Seves = {
    {Name = "Seve de Frene", Id = 16909, CanSell = true},
    {Name = "Seve de Chataignier", Id = 16910, CanSell = true},
    {Name = "Seve de Noyer", Id = 16911, CanSell = true},
    {Name = "Seve de Chene", Id = 16912, CanSell = true},
    {Name = "Seve de Bombu", Id = 16913, CanSell = true},
    {Name = "Seve d'Erable", Id = 16914, CanSell = true},
    {Name = "Seve d'Oliviolet", Id = 16915, CanSell = true},
    {Name = "Seve d'If", Id = 16916, CanSell = true},
    {Name = "Seve de Bambou", Id = 16917, CanSell = true},
    {Name = "Seve de Merisier", Id = 16918, CanSell = true},
    {Name = "Seve de Noisetier", Id = 16919, CanSell = true},
    {Name = "Seve de Kaliptus", Id = 16921, CanSell = true},
    {Name = "Seve de Charme", Id = 16922, CanSell = true},
    {Name = "Seve de Bambou Sombre", Id = 16923, CanSell = true},
    {Name = "Seve de Bambou Sacre", Id = 16925, CanSell = true},
    {Name = "Seve d'Orme", Id = 16924, CanSell = true},
    {Name = "Seve de Tremble", Id = 16926, CanSell = true},
}

--- </init>


local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0 and job:level(2) < 200) and 2 or (toReturn == 0 and job:level(2) == 200) and 1
end


local function antiModo()
    -- if global:isModeratorPresent(30) then
	-- 	timerdisconnect = math.random(30000, 36000) 
    --     if not map:onMap("0,0") then
    --         map:changeMap("havenbag")
    --     end
    --     global:printError("Modérateur présent. On attend " .. timerdisconnect)
    --     if global:thisAccountController():getAlias():find("Bucheron2") then
    --         global:editAlias("Bucheron2 " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Bucheron3") then
    --         global:editAlias("Bucheron3 " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
    --     else
    --         global:editAlias("Bucheron " .. character:server() .. " [" .. job:level(2) .. "]  [MODO]", true)
    --     end
    --     global:delay(timerdisconnect)
    --     customReconnect(timerdisconnect / 1000)

    --     map:changeMap("havenbag")
	-- end
end


local function CheckEndFight(message)
    if not message.results[1].alive then
        global:restartScript(true)
    end
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
end


local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID
    developer:sendMessage(message)
end

local function ProcessBank() -- done
    logBotStats()
    if character:level() > 160 then
        settOrnament(14)
    end
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

    if hdvFull then
		exchange:putAllItems()
	else
        for _, element in ipairs(Bois) do
            if inventory:itemCount(element.Id) > 0 then
                exchange:putItem(element.Id, inventory:itemCount(element.Id))
            end
        end
        for _, element in ipairs(Planches) do
            if inventory:itemCount(element.Id) > 0 then
                exchange:putItem(element.Id, inventory:itemCount(element.Id))
            end
        end

		if inventory:itemCount(16420) > 0 then exchange:putItem(16420, inventory:itemCount(16420)) end -- potion de glandage
		if inventory:itemCount(16419) > 0 then exchange:putItem(16419, inventory:itemCount(16419)) end -- potion des ancêtre
		if inventory:itemCount(substrat_de_sylve) > 0 then exchange:putItem(substrat_de_sylve, inventory:itemCount(substrat_de_sylve)) end
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

    global:printSuccess("------------------------------")

    global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(substrat_de_sylve) .. " [" .. inventory:itemNameId(substrat_de_sylve) .. "]")

    for _, element in ipairs(Planches) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end
    
    for i = 1, 6 do
        TableGather[i].Farmer = exchange:storageItemQuantity(TableGather[i].IdObjet) > 1500
    end

    local podsAvailable = inventory:podsMax() - inventory:pods()

    for i = 1, 6 do 
        local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(Planches[i].Id)), exchange:storageItemQuantity(Planches[i].Id), Planches[i].MaxHdv10 * 10 + Planches[i].MaxHdv1)

        if QuantiteAPrendre >= 10 and Planches[i].CanSell and not hdvFull then
            exchange:getItem(Planches[i].Id, QuantiteAPrendre)

            podsAvailable = inventory:podsMax() - inventory:pods()
            Planches[i].CanSell = false
            NeedToSell = true
        end
    end

    if CanSellSubstratDeSylve and exchange:storageItemQuantity(substrat_de_sylve) >= 10 and not hdvFull and not STOP then
		exchange:getItem(substrat_de_sylve, exchange:storageItemQuantity(substrat_de_sylve))
		podsAvailable = inventory:podsMax() - inventory:pods()
		NeedToSell = true
	end

    if exchange:storageItemQuantity(substrat_de_sylve) < 10 and character:kamas() > 300000 and exchange:storageItemQuantity(Planches[1].Id) >= 4 and not Planches[1].CanSell  then
		CraftQuantity = math.min(math.floor(exchange:storageItemQuantity(Planches[1].Id)), 20)
        global:printSuccess("Possibilité de craft " .. CraftQuantity .. " [Substrat de Sylve]")
		exchange:getItem(Planches[1].Id, math.min(exchange:storageItemQuantity(Planches[1].Id, 20)))
		exchange:getItem(16419, math.min(exchange:storageItemQuantity(16419), 40))
		exchange:getItem(16420, math.min(exchange:storageItemQuantity(16420), 40))
		craftSubstratDeSylve = true
		NeedToSell = true
		NeedToCraft = true
	end

    for _, element in ipairs(Planches) do
        element.CanCraft = true
        for _, element2 in ipairs(element.ListIdCraft) do
            if not (exchange:storageItemQuantity(element2.Id) >= 50) or NeedToCraft or not element.CanSell then
                element.CanCraft = false	
                break
            end
        end
        if element.CanSell and element.CanCraft and not NeedToCraft and job:level(2) < element.lvlMax and not hdvFull then
            NeedToSell = false
            NeedToCraft = true
            CraftQuantity = math.floor(podsAvailable / (#element.ListIdCraft * 50))
            for _, element2 in ipairs(element.ListIdCraft) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(element2.Id) / element2.Quantity))
            end
            
            global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "] (Craft à " .. #element.ListIdCraft .. " cases)")

            for _, element2 in ipairs(element.ListIdCraft) do
                global:printSuccess("On prend " .. CraftQuantity * element2.Quantity .. "x [" .. element2.Id .. "]")
                exchange:getItem(element2.Id, CraftQuantity * element2.Quantity)
            end
        end
    end

    if not NeedToCraft then
        for _, element in ipairs(Bois) do
            local QuantiteAPrendre = math.min(math.floor(podsAvailable / 5), exchange:storageItemQuantity(element.Id), element.MaxHdv100 * 100 + element.MaxHdv10 * 10)
            if QuantiteAPrendre == (element.MaxHdv100 * 100 + element.MaxHdv10 * 10) and element.CanSell and not hdvFull then
                exchange:getItem(element.Id, QuantiteAPrendre)
                podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end

        for _, element in ipairs(Seves) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id))
			if QuantiteAPrendre > 0 and not hdvFull and element.CanSell then
				exchange:getItem(element.Id, QuantiteAPrendre)
                NeedToSell = true
			end
        end
    end

    podsAvailable = inventory:podsMax() - inventory:pods()

    if exchange:storageItemQuantity(10669) > 0 then
        exchange:getItem(10669, math.min(exchange:storageItemQuantity(10669), podsAvailable))
    end
    
    hdvFull = false
    STOP = false
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
            for _, element2 in ipairs(element.ListIdCraft) do
                craft:putItem(element2.Id, element2.Quantity)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            element.CanCraft = false
            global:delay(1000)
            craft:ready()
            global:delay(1000)
        end
    end
    if craftSubstratDeSylve then
        craftSubstratDeSylve = false
        craft:putItem(16420, 1) -- potion de glandage
        craft:putItem(16419, 1) -- potion des ancêtres
        craft:putItem(16499, 1)
        craft:changeQuantityToCraft(CraftQuantity)
		global:delay(1000)
        craft:ready()
    end

    global:leaveDialog() 
	global:delay(1000)
	map:moveToCell(341)
end
	
local function ProcessSell() -- done
    NeedToSell = false
    if mount:hasMount() and not DDNourrie then
        DDNourrie = true
        buyAndfeedDD()

        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end


    while craftSubstratDeSylve and not STOP and (inventory:itemCount(16420) < CraftQuantity or inventory:itemCount(16419) < CraftQuantity) do
        HdvSell()

        local priceSubstratDeSylve = GetPricesItemInHdvSell(substrat_de_sylve).Price1
        local priceGlandage = GetPricesItemInHdvSell(16420)
        local priceAncetre = GetPricesItemInHdvSell(16419)

        global:leaveDialog()
        HdvBuy()
        
        if ((priceGlandage.Price1 == 0 and priceGlandage.Price10 == 0) or (priceAncetre.Price1 == 0 and priceAncetre.Price10 == 0) 
        or (priceSubstratDeSylve - priceAncetre.AveragePrice - priceGlandage.AveragePrice) < 10000) 
        and (inventory:itemCount(16420) < CraftQuantity) and (inventory:itemCount(16419) < CraftQuantity) then
            craftSubstratDeSylve = false
            STOP = true
            break
        elseif inventory:itemCount(16420) < CraftQuantity then
            achat(16420, 10)
        elseif inventory:itemCount(16419) < CraftQuantity then
            achat(16419, 10)
        end

        global:leaveDialog()

    end 

	HdvSell()
    local MuflePrices = GetPricesItemInHdvSell(10669)
    MuflePrice1 = MuflePrices.Price1
    MuflePrice10 = MuflePrices.Price10
    MuflePrice100 = MuflePrices.Price100


	for _, element in ipairs(Planches) do
		local priceItem = GetPricesItemInHdvSell(element.Id)
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

        local priceItem = GetPricesItemInHdvSell(element.Id)
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

        local priceItem = GetPricesItemInHdvSell(element.Id)
        priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price1 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1
        cpt = get_quantity(element.Id).quantity["1"]

        while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < 10 do 
            sale:SellItem(element.Id, 1, priceItem.Price1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. priceItem.Price1 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

		if itemSold then
			randomDelay()
		end
     end

    local priceItem = GetPricesItemInHdvSell(substrat_de_sylve)
    priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100
    priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10

    cpt = get_quantity(substrat_de_sylve).quantity["10"]
    while inventory:itemCount(substrat_de_sylve) >= 10 and sale:availableSpace() > 0 and cpt < 4 do 
        sale:SellItem(substrat_de_sylve, 10, priceItem.Price10 - 1) 
        global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(substrat_de_sylve) .. " à " .. priceItem.Price10 - 1 .. "kamas")
        cpt = cpt + 1
    end

    cpt = get_quantity(substrat_de_sylve).quantity["1"]
    while inventory:itemCount(substrat_de_sylve) >= 1 and sale:availableSpace() > 0 and cpt < 10 do 
        sale:SellItem(substrat_de_sylve, 1, priceItem.Price1 - 1) 
        global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(substrat_de_sylve) .. " à " .. priceItem.Price1 - 1 .. "kamas")
        cpt = cpt + 1
    end

	global:leaveDialog()

    while inventory:itemCount(10669) < 20 and character:kamas() > 50000 and ((MuflePrice100 > 0 and MuflePrice100 < 20000) or (MuflePrice10 > 0 and MuflePrice10 < 2000) or (MuflePrice1 > 0 and MuflePrice1 < 200)) do
        
        HdvSell()

        local MuflePrices = GetPricesItemInHdvSell(10669)
        MuflePrice100 = MuflePrices.Price100
        MuflePrice10 = MuflePrices.Price10
        MuflePrice1 = MuflePrices.Price1


        global:leaveDialog()

        global:printSuccess("achat changement d'apparence")
        HdvSell()

        sale:buyItem(10669, 100, 20000)

        if MuflePrice10 > 0 and MuflePrice10 < 2000 and inventory:itemCount(10669) < 20 then
            sale:buyItem(10669, 10, 2000)
        end

        if MuflePrice1 > 0 and MuflePrice1 < 200 and inventory:itemCount(10669) < 20 then
            sale:buyItem(10669, 1, 200)
        end

        global:leaveDialog()
    end

    HdvSell()

    -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
    for i = 1, 6 do
        if get_quantity(Planches[i].Id).quantity["10"] >= Planches[i].MaxHdv10 and get_quantity(Planches[i].Id).quantity["1"] >= Planches[i].MaxHdv1 then
            Planches[i].CanSell = false
        else
            Planches[i].CanSell = true
        end
    end
    for _, element in ipairs(Bois) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 or element.Priceitem100 < element.MinPrice then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
    for _, element in ipairs(Seves) do
        if get_quantity(element.Id).quantity["1"] >= 1 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
    if get_quantity(substrat_de_sylve).quantity["10"] >= 4 and get_quantity(substrat_de_sylve).quantity["1"] >= 10 then 
		CanSellSubstratDeSylve = false 
	else
		CanSellSubstratDeSylve = true
	end

	if cptActualiser >= 3 and character:kamas() > 30000 then
		cptActualiser = 0
		global:printSuccess("on actualise")
        global:leaveDialog()
		openHdvAndUpdateItems()
	else
		cptActualiser = cptActualiser + 1
	end
		
    if sale:availableSpace() == 0 then 
        hdvFull = true 
        global:printError("l'hdv est plein") 
    else
        hdvFull = false
    end
    
    global:leaveDialog()
    StopAchat = false
    NeedToReturnBank = true
	map:changeMap("top")
end

local function defineGather()
    local insert = table.insert
    local result = {}
    for _, element in pairs(TableGather) do
        if inventory:itemCount(element.IdObjet) < element.Max and element.Farmer then
            insert(result, element.IdRessource)
        end
    end
    GATHER = result
    if result == nil or #result == 0 then
        global:printSuccess("On a plus rien à récolter, on va à la banque")
        return bank()
    end
    if #result < 7 and a == 29 then
        a = (a + 1) % 30
        global:printSuccess(#result .. " minerai différents récoltables")
    end
end

local function whichArea()
    hdvActualise = false
    if DebutDuScript then
        DebutDuScript = false
        for _, element in ipairs(TableWhichArea) do
            if not element.Farmer and getCurrentAreaName() == element.AreaString then
                element.Farmer = true
                cpt = cpt + 1
                break
            end
        end
        TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer = (cpt == 0) or TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer
    end
    if inventory:itemCount(1704) == 0 and job:level(2) > 180 and character:kamas() >= 150000 then
        return treatMaps(AreaAchatSacStaca)
    end
    if character:energyPoints() < 5000 then
        return treatMaps(AreaEnergie)
    end

    for i = 1, #TableWhichArea do
        if map:onMap(TableWhichArea[i].MapSwitch) and TableWhichArea[i].Farmer then
            TableWhichArea[i].Farmer = false
            TableWhichArea[IncrementTable(i, #TableWhichArea)].Farmer = true
            return treatMaps(TableWhichArea[IncrementTable(i, #TableWhichArea)].Area)
        elseif TableWhichArea[i].Farmer then
            return treatMaps(TableWhichArea[i].Area)
        end 
    end
end


function move()
    handleDisconnection()
    mapDelay()
    take50kIfNeeded(10000, 120, 1)

    while character:kamas() == 0 and map:onMap("4,-18") do
        npc:npcBank(-1)
        global:delay(500)
        if exchange:storageKamas() > 0 then
            exchange:getKamas(0)
            global:delay(500)
            global:printSuccess("j'ai récupérer les kamas, je retourne farmer")
            global:leaveDialog()
        elseif exchange:storageKamas() == 0 then
            global:printError("il n'y a pas de kamas dans la banque on attend un peu")
            global:leaveDialog()
            global:delay(1200000)
        end
    end
    if character:kamas() < 3000 then
        return treatMaps(GoTakeKamas)
    end

    for i = 1, NB_BUCHERON do
        if global:thisAccountController():getAlias():find("Bucheron" .. i) then
            global:editAlias("Bucheron" .. i .. " " .. character:server() .. " [" .. job:level(2) .. "] " .. getRemainingSubscription(true), true)
            break
        end
    end

    if getRemainingSubscription(true) <= 0 then
        Abonnement()
    end


    if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end

    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map = "-30,-55", path = "havenbag"}, -- map en haut de hdv ressources
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

    if job:level(2) < 180 then	
		global:printSuccess("changement de script")
		global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Recolte\\Bucheron_1_200.lua")
	end

    givingTriggerValue = (job:level(2) < 200) and (getRemainingSubscription(true) > 1) and 1000000 or 2500000
    minKamas = (getRemainingSubscription(true) == 0) and 1700000 or 300000

    forwardKamasBotBankIfNeeded(givingTriggerValue, minKamas, 120, 4)

    antiModo()

    defineGather()

    return whichArea()
end

function bank()
    if getRemainingSubscription(true) <= 0 then
        Abonnement()
    end
    mapDelay()

    for i = 1, NB_BUCHERON do
        if global:thisAccountController():getAlias():find("Bucheron" .. i) then
            global:editAlias("Bucheron" .. i .. " " .. character:server() .. " [" .. job:level(2) .. "] " .. getRemainingSubscription(true), true)
            break
        end
    end

	for _, element in ipairs(TableWhichArea) do
		element.Farmer = false
	end
	TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer = true
	
	if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end

    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map ="0,0", path = "zaap(147590153)"},
			{map = "-30,-55", path = "havenbag"}, -- map en haut de hdv ressources
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
	
    return treatMaps({ 
		{map ="104861191", path = "457"},
		{map ="104862217", path = "369"},
		{map ="104861193", path = "454"},
		{map ="104859145", path = "192"},
		{map ="104860169", path = "379"},
		{map ="104858121", path = "507"},
		{map ="104072451", path ="havenbag"},
		{map="0,0",path="zaap(212600323)"},
		{map="-31,-56",path="top"},
		{map="212600322", door = "468"},
		{map = "217059328", custom = ProcessBank},
    })
end

function stopped()
    map:changeMap("havenbag")
end

function banned()
    global:editAlias(phrase .. " [BAN]", true)
end

function phenix()
	return PHENIX
end