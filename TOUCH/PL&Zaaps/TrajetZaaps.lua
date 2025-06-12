dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


if not global:remember("ETAPE_ZAAP") then
    global:addInMemory("ETAPE_ZAAP", 0)
end

if not global:remember("ExplorationFinished") then
    global:addInMemory("ExplorationFinished", false)
end

local function increment()
    global:editInMemory("ETAPE_ZAAP", global:remember("ETAPE_ZAAP") + 1)
    global:printSuccess("Etape : " .. global:remember("ETAPE_ZAAP"))
end


local function GoTo(mapToward, action)
    local toward = mapToward:split(",")
    if not map:onMap(mapToward) then
        if #toward == 2 then
            return map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
        elseif #toward == 1 then
            return map:moveToward(tonumber(toward[1]))
        end
    else
        action()
    end
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

local function CanonMoon()
	local AchatCasque =true
	local AchatAiles = true
	for i, v in ipairs(inventory:items()) do
		if v == 1019 then
			global:printSuccess("On a DEJA le casque")
			AchatCasque = false
			global:printSuccess(AchatCasque)
		elseif v == 1021 then
			global:printSuccess("On a deja les ailes")
			AchatAiles = false
			global:printSuccess(AchatAiles)
		end
	end

	if AchatCasque then
		npc:npcBuy()
		global:delay(500)
		sale:buyItem(1019, 1, 10000) --prix max a définir
		global:printSuccess("casque acheté")
		global:delay(500)
		global:leaveDialog()
	end
	if AchatAiles then
		npc:npcBuy()
		global:delay(500)
		sale:buyItem(1021, 1, 25000) --prix max a définir
		global:printSuccess("Aile acheté")
		global:delay(500)
		global:leaveDialog()
	end

	inventory:equipItem(1019, 6)
	global:printSuccess("Casque équipé")
	inventory:equipItem(1021, 7)
	global:printSuccess("Aile équipé")
    npc:npc(153,3)
    global:delay(500)
    npc:reply(-1)
	global:leaveDialog()
	map:door(355)
	global:printSuccess("Arrivée sur moon")
	
end

local function Nelween()
	npc:npc(983,3)
    global:delay(500)
    npc:reply(-1)
	global:leaveDialog()
end

local function treatMapsBrak(maps)
    for _, element in ipairs(maps) do
        if map:onMap(element.map) then
            return maps
        end
    end
    PopoBrakmar()
end
function move()
    if global:remember("ETAPE_ZAAP") == 0 then --Zaap Astrub
        return {
            { map = "5,-22", path = "top" },
            { map = "1,-21", path = "right" },
            { map = "2,-21", path = "right" },
            { map = "3,-21", path = "right" },
            { map = "4,-21", path = "bottom" },
            { map = "4,-20", path = "bottom" },
            {map = "4,-19", custom = function()
                map:useById(509434, -2)
                increment()
                map:changeMap("top")
            end},
        }

    elseif global:remember("ETAPE_ZAAP") == 1 then --Plaine des porckas
        return {
            { map = "4,-20", path = "left" },
            { map = "3,-20", path = "left" },
            { map = "1,-20", path = "left" },
            { map = "2,-20", path = "left" },
            { map = "0,-20", path = "left" },
            { map = "-1,-20", path = "left" },
            { map = "-2,-20", path = "left" },
            { map = "-3,-20", path = "left" },
            { map = "-4,-20", path = "left" },
            { map = "-5,-20", path = "top" },
            { map = "-5,-21", path = "top" },
            { map = "-5,-22", path = "top" },
            { map = "1,-21", path = "bottom" },
            {map = "-5,-23", custom = function()
                increment()
                map:changeMap("bottom")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 2 then --POPOBonta
        
        if inventory:itemCount(6965) == 0 then
            npc:npcBuy()
            global:delay(500)
            sale:buyItem(6965, 1, 1000)
            if inventory:itemCount(6965) == 0 then
                sale:buyItem(6965, 10, 10000)
            end
            global:delay(500)
            global:leaveDialog()
            global:delay(500)
        end
        inventory:useItem(6965)
        increment()
        map:changeMap("zaapi(147768)")
    
    elseif global:remember("ETAPE_ZAAP") == 3 then  --Bonta
        return {
            { map = "147768", path = "zaap(84806401)" },
            {map = "-5,-23", custom = function()
                increment()
                map:changeMap("bottom")
                global:printSuccess("oui")
            end},
        }

    elseif global:remember("ETAPE_ZAAP") == 4 then  --Massif de cania
        return {
            { map = "-5,-22", path = "bottom" },
            { map = "-5,-21", path = "left" },
            { map = "-6,-21", path = "left" },
            { map = "-7,-21", path = "left" },
            { map = "-8,-21", path = "left" },
            { map = "-9,-21", path = "left" },
            { map = "-10,-21", path = "left" },
            { map = "-11,-21", path = "left" },
            { map = "-12,-21", path = "left" },
            { map = "-13,-21", path = "top" },
            { map = "-13,-22", path = "top" },
            { map = "-13,-23", path = "top" },
            { map = "-13,-24", path = "top" },
            { map = "-13,-25", path = "top" },
            { map = "-13,-26", path = "top" },
            { map = "-13,-27", path = "top" },
            { map = "-13,-28", custom = function()
                increment()
                map:changeMap("bottom")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 5 then  --Route de la roche
        return {
            { map = "-13,-27", path = "bottom" },
            { map = "-13,-26", path = "bottom" },
            { map = "-13,-25", path = "bottom" },
            { map = "-13,-24", path = "bottom" },
            { map = "-13,-23", path = "bottom" },
            { map = "-13,-22", path = "bottom" },
            { map = "-13,-21", path = "bottom" },
            { map = "-13,-20", path = "left" },
            { map = "-14,-20", path = "left" },
            { map = "-15,-20", path = "left" },
            { map = "-16,-20", path = "left" },
            { map = "-17,-20", path = "left" },
            { map = "-18,-20", path = "left" },
            { map = "-19,-20", path = "left" },
            { map = "-20,-20", custom = function()
                increment()
                map:changeMap("bottom")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 6 then  --Vilage éleveur (lui faire prendre le zaap a la fin pour la continuité du trajet)
        return {
            { map = "-20,-19", path = "bottom" },
            { map = "-20,-20", path = "bottom" },
            { map = "-20,-18", path = "bottom" },
            { map = "-20,-17", path = "bottom" },
            { map = "-20,-16", path = "bottom" },
            { map = "-20,-15", path = "bottom" },
            { map = "-20,-14", path = "right" },
            { map = "-19,-14", path = "right" },
            { map = "-18,-14", path = "bottom" },
            { map = "-18,-13", path = "bottom" },
            { map = "-18,-12", path = "bottom" },
            { map = "-18,-11", path = "bottom" },
            { map = "-18,-10", path = "bottom" },
            { map = "-17,-6", path = "bottom" },
            { map = "-17,-5", path = "bottom" },
            { map = "-17,-7", path = "bottom" },
            { map = "-17,-8", path = "bottom" },
            { map = "-18,-9", path = "bottom" },
            { map = "-18,-8", path = "right" },
            { map = "-17,-4", path = "bottom" },
            { map = "-17,-3", path = "bottom" },
            { map = "-17,-2", path = "bottom" },
            { map = "-17,-1", path = "bottom" },
            { map = "-17,0", path = "bottom" },
            { map = "-17,1", path = "right" },
            { map = "73400320", path = "zaap(141588)" },
            { map = "-20,-20", custom = function()
                increment()
                map:changeMap("bottom")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 7 then  --Mont nésélite
        return {
            { map = "-20,-19", path = "bottom" },
            { map = "-20,-18", path = "bottom" },
            { map = "-20,-17", path = "bottom" },
            { map = "-20,-16", path = "bottom" },
            { map = "-20,-15", path = "left" },
            { map = "-21,-15", path = "left" },
            { map = "-22,-15", path = "left" },
            { map = "-23,-15", path = "left" },
            { map = "-24,-15", path = "left" },
            { map = "-25,-15", path = "left" },
            { map = "-26,-15", path = "left" },
            { map = "-27,-16", path = "top" },
            { map = "-27,-15", path = "top" },
            { map = "-27,-17", path = "top" },
            { map = "-27,-18", path = "top" },
            { map = "-27,-19", path = "top" },
            { map = "-27,-20", path = "top" },
            { map = "-27,-21", path = "top" },
            { map = "120718594", door = "220" },
            { map = "122683904", door = "347" },
            { map = "122684928", path = "right(279)" },
            { map = "120718595", path = "bottom" },
            { map = "120718083", path = "right" },
            { map = "120586499", path = "bottom" },
            { map = "120586498", path = "right" },
            { map = "120587010", path = "bottom" },
            { map = "-23,-19", custom = function()
                increment()
                map:changeMap("zaap(84674563)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 8 then  --Le village
        return {
            { map = "1,-21", path = "right" },

            { map = "2,-21", path = "right" },
            { map = "3,-21", path = "right" },
            { map = "4,-21", path = "bottom" },
            { map = "4,-20", path = "bottom" },
            { map = "4,-19", path = "bottom" },
            { map = "4,-18", path = "bottom" },
            { map = "4,-17", path = "bottom" },
            { map = "4,-16", path = "bottom" },
            { map = "4,-15", path = "bottom(557)" },
            { map = "4,-14", path = "bottom" },
            { map = "4,-13", path = "bottom" },
            { map = "4,-12", path = "bottom" },
            { map = "4,-11", path = "bottom" },
            { map = "4,-10", path = "left" },
            { map = "3,-10", path = "left" },
            { map = "2,-10", path = "bottom" },
            { map = "2,-9", path = "bottom" },
            { map = "2,-8", path = "left" },
            { map = "1,-8", path = "bottom(444)" },
            { map = "1,-7", path = "bottom" },
            { map = "1,-6", path = "bottom" },
            { map = "1,-5", path = "bottom" },
            { map = "1,-4", path = "bottom" },
            { map = "1,-3", path = "bottom" },
            { map = "1,-2", path = "left" },
            { map = "0,-2", path = "left" },
            { map = "-1,-2", path = "left" },
            { map = "-2,-2", path = "bottom" },
            { map = "-2,-1", path = "bottom" },
            { map = "-2,0", custom = function()
                increment()
                map:changeMap("right")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 9 then  --Coins des bouftous
        return {
            { map = "-1,0", path = "right" },

            { map = "0,0", path = "right" },
            { map = "1,0", path = "right" },
            { map = "2,0", path = "right" },
            { map = "3,0", path = "right" },
            { map = "4,0", path = "right" },
            { map = "5,1", path = "bottom" },
            { map = "5,0", path = "bottom" },
            { map = "5,2", path = "bottom" },
            { map = "5,3", path = "bottom" },
            { map = "5,5", path = "bottom" },
            { map = "5,4", path = "bottom" },
            { map = "5,6", path = "bottom" },
            { map = "5,7", custom = function()
                increment()
                map:changeMap("right")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 10 then  --Moon
        return {
            { map = "5,7", path = "right" },
            { map = "6,7", path = "right" },
            { map = "7,7", path = "right" },
            { map = "8,7", path = "right" },
            { map = "9,7", path = "right" },
            { map = "11,9", path = "bottom" },
            { map = "10,7", path = "bottom" },
            { map = "10,8", path = "bottom" },
            { map = "10,9", path = "right" },
            {map = "11,10", custom = CanonMoon},
            { map = "34,11", path = "right" },
            { map = "35,11", path = "bottom" },
            { map = "35,12", custom = function()
                increment()
                map:changeMap("zaap(88082704)")
                map:changeMap("left")

            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 11 then  --Bord de la foret maléfique
        return {
            { map = "5,7", path = "bottom" },
            { map = "5,8", path = "bottom" },
            { map = "5,9", path = "bottom" },
            { map = "5,10", path = "bottom" },
            { map = "5,11", path = "bottom" },
            { map = "5,13", path = "left" },
            { map = "4,13", path = "left" },
            { map = "3,13", path = "left" },
            { map = "2,13", path = "left" },
            { map = "1,13", path = "left" },
            { map = "0,13", path = "left" },
            { map = "5,12", path = "bottom" },
            { map = "5,7", path = "bottom" },

            { map = "-1,13", custom = function()
                increment()
                map:changeMap("left") 
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 12 then  --Route sombre
        return {
            { map = "88213258", door = " 213" },
            { map = "18352643", path = "left(336)" },
            { map = "18352131", path = "left(336)" },
            { map = "18351619", custom=Nelween },
            { map = "18351107", path = "left(392)" },
            { map = "18350595", path = "top(6)" },
            { map = "18350594", path = "left(336)" },
            { map = "18350082", path = "left(224)" },

            { map = "-24,12", custom = function()
                increment()
                map:changeMap("zaap(88212746)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 13 then  --Plaine des scarafeuilles
        return {
            { map = "-1,13", path = "right" },
            { map = "0,13", path = "right" },
            { map = "1,13", path = "right" },
            { map = "2,13", path = "bottom" },
            { map = "2,14", path = "bottom" },
            { map = "2,15", path = "bottom" },
            { map = "2,16", path = "bottom" },
            { map = "2,17", path = "bottom" },
            { map = "2,18", path = "bottom" },
            { map = "2,19", path = "bottom" },
            { map = "2,20", path = "bottom" },
            { map = "2,21", path = "bottom" },
            { map = "2,22", path = "bottom" },
            { map = "2,23", path = "bottom" },
            { map = "2,24", path = "left" },
            { map = "1,24", path = "left" },
            { map = "0,24", path = "left" },

            { map = "-1,24", custom = function()
                increment()
                map:changeMap("right") 
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 14 then  --sufokia
        return {
            { map = "0,24", path = "right" },
            { map = "1,24", path = "right" },
            { map = "2,24", path = "right" },
            { map = "3,24", path = "right" },
            { map = "4,24", path = "top" },
            { map = "4,23", path = "top" },
            { map = "4,22", path = "top" },
            { map = "4,21", path = "right" },
            { map = "5,21", path = "right" },
            { map = "6,21", path = "right" },
            { map = "7,21", path = "right" },
            { map = "8,21", path = "right" },
            { map = "9,21", path = "right" },
            { map = "10,21", path = "bottom" },

            { map = "10,22", custom = function()
                increment()
                map:changeMap("zaap(84674563)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 15 then  --Berceau
        return {
            { map = "10,22", path = "zaap(84674563)"},
            { map = "4,-19", path = "right" },
            { map = "5,-19", path = "top" },
            { map = "5,-20", path = "top" },
            { map = "5,-21", path = "top" },
            { map = "5,-23", path = "top" },
            { map = "5,-22", path = "top" },
            { map = "5,-25", path = "top" },
            { map = "5,-24", path = "top" },
            { map = "5,-27", path = "top" },
            { map = "5,-26", path = "top" },
            { map = "5,-28", path = "top" },
            { map = "5,-29", path = "top" },
            { map = "5,-30", path = "top" },
            { map = "5,-31", path = "left" },
            { map = "4,-31", path = "top" },
            { map = "4,-32", path = "left" },
            { map = "3,-32", path = "left" },
            { map = "2,-32", path = "left" },

            { map = "1,-32", custom = function()
                increment()
                map:changeMap("zaap(147768)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 16 then  --Cimetiere de bonta
        return {
            { map = "147768", path = "zaapi(144695)" },


            { map = "-26,-55", path = "top" },
            { map = "-26,-56", path = "right" },
            { map = "-25,-56", path = "right" },
            { map = "-24,-56", path = "right" },
            { map = "-23,-56", path = "right" },
            { map = "-22,-56", path = "right" },
            { map = "-21,-56", path = "right" },
            { map = "-20,-56", path = "right" },
            { map = "-19,-56", path = "bottom" },
            { map = "-19,-55", path = "bottom" },
            { map = "-19,-54", path = "bottom" },

            { map = "-19,-53", custom = function()
                increment()
                map:changeMap("zaap(84674563)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 17 then
        return treatMapsBrak({
            {map = "-26,36", path = "zaapi(144419)"},
            { map = "144419", custom = function()
                increment()
                map:changeMap("zaap(84674563)")
            end}
        })
    elseif global:remember("ETAPE_ZAAP") == 18 then
        inventory:equipItem(7226, 6)
        inventory:equipItem(7230, 7)

        inventory:equipItem(7238, 3)
        inventory:equipItem(7242, 5)
        inventory:equipItem(7246, 4)
        inventory:equipItem(7250, 0)
        global:printSuccess("panoakwadala equipée")

        if global:thisAccountController():getAlias():find("bank") then
            global:disconnect()
        end
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Solo.lua")
        increment()
    end
end
