dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")
local Moon1 = { --départ zaapAstrub 35,12 arrivvé 36,5
    { map = "84674563", path = "zaap(17932)"},
	{ map = "34,12", path = "left", fight = true},
	{ map = "35,11", path = "left", fight = true},
	{ map = "34,11", path = "bottom", fight = true},
	{ map = "35,12", path = "top", fight = true},
	{ map = "33,12", path = "top", fight = true},
	{ map = "33,11", path = "left", fight = true},
	{ map = "32,11", path = "top", fight = true},
	{ map = "32,10", path = "top", fight = true},
	{ map = "32,9", path = "top", fight = true},
	{ map = "32,8", path = "top", fight = true},
	{ map = "32,7", path = "right", fight = true},
	{ map = "33,7", path = "top", fight = true},
	{ map = "33,6", path = "right", fight = true},
	{ map = "34,6", path = "top", fight = true},
	{ map = "34,5", path = "right", fight = true},
	{ map = "35,5", path = "top", fight = true},
	{ map = "35,4", path = "right", fight = true},
	{ map = "36,4", path = "bottom", fight = true},
 
}

local Moon2 = { --départ 36,5 arrivvé 35,12
	{ map = "36,4", path = "left", fight = true },
	{ map = "36,5", path = "top", fight = true},
	{ map = "35,4", path = "bottom", fight = true},
	{ map = "35,5", path = "left", fight = true},
	{ map = "34,5", path = "bottom", fight = true},
	{ map = "34,6", path = "left", fight = true},
	{ map = "33,6", path = "bottom", fight = true},
	{ map = "33,7", path = "left", fight = true},
	{ map = "32,7", path = "bottom", fight = true},
	{ map = "32,8", path = "bottom", fight = true},
	{ map = "32,9", path = "bottom", fight = true},
	{ map = "32,10", path = "bottom", fight = true},
	{ map = "32,11", path = "right", fight = true},
	{ map = "33,11", path = "bottom", fight = true},
	{ map = "33,12", path = "right", fight = true},
	{ map = "34,12", path = "top", fight = true},
	{ map = "34,11", path = "right", fight = true},
	{ map = "35,11", path = "bottom", fight = true},
 
}

local EntreeJungle = { --départ 36,5 arrivvé 35,12
	{ map = "35,10", path = "bottom" }, --backup des bots
	{ map = "36,10", path = "bottom" },
	{ map = "36,11", path = "left" },
	{ map = "35,11", path = "left" },
	{ map = "34,11", path = "left" },
	{ map = "35,12", path = "left" },
	{ map = "34,12", path = "top" },
	{ map = "33,12", path = "top" },
	{ map = "33,11", path = "top" },
	{ map = "33,10", path = "left" },
	{ map = "32,10", path = "top" },
	{ map = "32,9", path = "top" },
	{ map = "32,8", path = "top" },
	{ map = "32,7", path = "right" },
	{ map = "33,7", path = "top" },
	{ map = "32,6", path = "right" },
	{ map = "33,8", path = "left" },
	{ map = "33,6", path = "right" },
	{ map = "34,6", path = "top" },
	{ map = "35,5", path = "left" },
	{ map = "36,5", path = "left" },
	{ map = "35,4", path = "bottom" },
	{ map = "36,4", path = "bottom" },
 
}

local Achatkoko = false --mettre false si on veut pas acheter
local CarapaceVerte =false
local CarapaceJaune =false
local CarapaceRouge =false
local CarapaceBleue =false


local function Carapace()

	if inventory:itemCount(1010) ~= 0 then
		global:printSuccess("On a la carapace verte")
		CarapaceVerte = true
    end
	if inventory:itemCount(1011) ~= 0 then
		global:printSuccess("On a la carapace jaune")
		CarapaceJaune = true
    end
	if inventory:itemCount(1012) ~= 0 then
		global:printSuccess("On a la carapace rouge")
		CarapaceRouge = true
    end
	if inventory:itemCount(1013) ~= 0 then
		global:printSuccess("On a la carapace bleu")
		CarapaceBleue = true
	end
end





function move()

	if not Achatkoko then
		global:printSuccess("on a choisi de pas acheter les kokos")
		global:printSuccess(CarapaceVerte)
		global:printSuccess(CarapaceJaune)
		global:printSuccess(CarapaceRouge)
		global:printSuccess(CarapaceBleue)
		
		Carapace()
		if CarapaceVerte and CarapaceJaune and CarapaceRouge and CarapaceBleue and inventory:itemCount(997)>=90 then
			global:printSuccess("On est pret a tapper les connon d'orf")
			selectedPath = EntreeJungle
    
        elseif  map:onMap(17932) or map:onMap(84674563) then
            selectedPath = Moon1
        elseif map:onMap(18437) and (selectedPath == Moon1) then
            selectedPath = Moon2
        end
        return selectedPath

	elseif Achatkoko then
		global:printSuccess("on a choisi d'acheter les kokos")
		Carapace()

		global:printSuccess(CarapaceVerte)
		global:printSuccess(CarapaceJaune)
		global:printSuccess(CarapaceRouge)
		global:printSuccess(CarapaceBleue)

		if CarapaceVerte and CarapaceJaune and CarapaceRouge and CarapaceBleue and inventory:itemCount(997)>=90 then
			global:printSuccess("On est pret a tapper les connon d'orf")
			selectedPath = EntreeJungle
	
	    elseif CarapaceVerte and CarapaceJaune and CarapaceRouge and CarapaceBleue and inventory:itemCount(997)<90 then
			global:printSuccess("On a toute les carapaces achetons les noix de kokoko")
			npc:npcBuy()
			global:delay(500)
			while inventory:itemCount(997)<90 do
				sale:buyItem(997, 10, 25000)
				global:printSuccess("10 kokoko achetée")
				global:delay(500)
			end
			global:leaveDialog()
		else
			global:printSuccess("début du farm des carapaces")
			Carapace()
			if  map:onMap(17932) or map:onMap(84674563) then
				selectedPath = Moon1
			elseif map:onMap(18437) and (selectedPath == Moon1) then
				selectedPath = Moon2
			end
			return selectedPath
		end
	end
end

local function banque()
    inventory:openBank()
    exchange:putAllItemsExchange()
end

function bank()
    banque()
    return selectedPath
end