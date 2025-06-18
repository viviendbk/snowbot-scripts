---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")
dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {603, 1805, 1847, 2277, 351, 2150, 2495, 2012, 1730, 1984, 1974, 2551, 2598, 2599, 426, 398, 679, 2419, 2422, 1975, 1771, 1977, 9472, 1734, 407, 1690, 15479, 364, 1900, 10967, 2428, 2425, 2416, 2414, 383, 385, 792, 311, 17126, 10831, 519, 1635, 17080, 1736, 398, 8482, 1978, 519, 15873, 15868, 18495, 678, 2411, 2478, 643, 1934, 10664, 1532, 1533, 1534, 1535, 1536, 9472, 15867, 679, 1526, 1528, 1529 }

--PLANNING = {11, 12, 19, 20, 21, 22, 23}

FORBIDDEN_MONSTERS = {450}

AMOUNT_MONSTERS = {}

if not global:remember("Increment") then
    global:addInMemory("Increment", 1)
end


local GoToAstrubBank = {
    -- mettre tous les zaaps des zones qu'on farm vers le zaap astrub + le trajet vers la banque astrub
    {map = "147768", path = "zaap(84674563)"}, --bonta
    {map = "-1,24", path = "zaap(84674563)"}, --scarafeuille
    {map = "-1,13", path = "zaap(84674563)"}, --marecage
    {map = "35,12", path = "zaap(84674563)"}, -- moon
    {map = "-5,-23", path = "zaap(84674563)"}, -- champa
    {map = "-23,-19", path = "zaap(84674563)"}, --mont neselite
    {map = "-19,-53", path = "zaap(84674563)"}, -- cimetiere bonta
    {map = "10,22", path = "zaap(84674563)"}, -- cimetiere bonta
    { map = "-20,-20", path = "zaap(84674563)"}, -- route de la cote
    { map = "5,7", path = "zaap(84674563)"}, -- route de la cote

    {map = "4,-19", path = "bottom"},
    {map = "4,-18", path = "bottom"},
    {map = "4,-17", path = "bottom"},
    {map = "84674566", door = "303"},
    {map = "83887104", custom = function ()
        AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Bot_Bank.lua")
        LaunchExchange = true
        launchExchangeAndGiveItems()
    end}
}

local Marecages = {
    {map = "-20,-20", path = "zaap(88212746)"},
    {map = "-19,-53", path = "zaap(88212746)"},
    { map = "4,-19", path = "zaap(88212746)"}, -- astrub
    {map = "147768", path = "zaap(88212746)"}, --bonta
    {map = "-1,24", path = "zaap(88212746)"}, --scarafeuille
    {map = "35,12", path = "zaap(88212746)"}, -- moon
    {map = "-5,-23", path = "zaap(88212746)"}, -- champa
    {map = "-23,-19", path = "zaap(88212746)"}, --mont neselite
    {map = "5,7", path = "zaap(88212746)"}, -- coin des bouftou
    {map = "143372", path = "zaap(88212746)"}, -- landes de sidimote

    -- { map = "88212746", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(472655, -2)
    --             acc.map:changeMap("left")
    --         end
    --         map:useById(472655, -2)
    --         map:changeMap("left")
    --     end
    -- end},  
    { map = "88212746", path = "left"}, 
    
    {map = "134666", door = "86"},
    { map = "-3,13", path = "left" },
    { map = "-2,13", path = "left" },
    { map = "-4,13", path = "top", fight = true },
    { map = "-4,12", path = "left|bottom", fight = true },
    { map = "-5,12", path = "top|left|right", fight = true },
    { map = "-5,11", path = "left|bottom", fight = true },
    { map = "-6,11", path = "top|left|right|bottom", fight = true },
    { map = "-6,12", path = "top|right", fight = true },
    { map = "-6,10", path = "left|bottom", fight = true },
    { map = "-8,8", path = "left|bottom", fight = true },
    { map = "-9,8", path = "top|right", fight = true },
    { map = "-9,7", path = "top|right|bottom", fight = true },
    { map = "-9,6", path = "top|right|bottom", fight = true },
    { map = "-9,5", path = "top|left|right|bottom", fight = true },
    { map = "-10,5", path = "top|right", fight = true },
    { map = "-8,10", path = "top|bottom", fight = true },
    { map = "-8,11", path = "top", fight = true },
    { map = "-8,9", path = "top|bottom", fight = true },
    { map = "-8,7", path = "top|left", fight = true },
    { map = "-7,5", path = "top|left", fight = true },
    { map = "-7,4", path = "left|bottom", fight = true },
    { map = "-8,4", path = "left|right|bottom", fight = true },
    { map = "-7,11", path = "top|right", fight = true },
    { map = "-8,6", path = "top(5)|left|bottom", fight = true },
    { map = "-8,5", path = "top|left|right|bottom", fight = true },
    { map = "-9,4", path = "top|left|right|bottom", fight = true },
    { map = "-9,3", path = "bottom", fight = true },
    { map = "-10,3", path = "top|bottom", fight = true },
    { map = "-10,4", path = "top|right|bottom", fight = true },
    { map = "-10,2", path = "bottom", fight = true },
}

local Dragoeuf = {
    -- { map = "88212481", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(472735, -2)
    --             acc.map:changeMap("left")
    --         end
    --         map:useById(472735, -2)
    --         map:changeMap("left")
    --     end
    -- end},
    {map = "-20,-20", path = "zaap(88212481)"},
    { map = "88212481", path = "left"},
    {map = "-16,1", path = "zaap(88212481)"},
    { map = "4,-19", path = "zaap(88212481)"}, -- astrub
    {map = "-19,-53", path = "zaap(88212481)"},
    {map = "147768", path = "zaap(88212481)"}, --bonta
    {map = "-1,13", path = "zaap(88212481)"}, --marecage
    {map = "35,12", path = "zaap(88212481)"}, -- moon
    {map = "-5,-23", path = "zaap(88212481)"}, -- champa
    {map = "-23,-19", path = "zaap(88212481)"}, --mont neselite
    {map = "10,22", path = "zaap(88212481)"}, -- rivage sufokien
    {map = "5,7", path = "zaap(88212481)"}, -- coin des bouftou
    {map = "143372", path = "zaap(88212481)"}, -- landes de sidimote

    { map = "-2,24", path = "bottom" },
    { map = "-2,25", path = "left|right|bottom", fight = true },
    { map = "-1,25", path = "left|bottom", fight = true },
    { map = "-1,26", path = "top|left", fight = true },
    { map = "-2,26", path = "top|left|right|bottom", fight = true },
    { map = "-2,27", path = "top|left|bottom", fight = true },
    { map = "-2,28", path = "top|left|right|bottom", fight = true },
    { map = "-1,28", path = "left|bottom", fight = true },
    { map = "-1,29", path = "top|left|bottom", fight = true },
    { map = "-1,30", path = "top|left", fight = true },
    { map = "-2,30", path = "top|left|right", fight = true },
    { map = "-3,30", path = "left|right|bottom", fight = true },
    { map = "-3,29", path = "top|right|bottom", fight = true },
    { map = "-3,28", path = "top|left|right|bottom", fight = true },
    { map = "-2,29", path = "top|left|right|bottom", fight = true },
    { map = "-3,31", path = "top|left|bottom", fight = true },
    { map = "-3,32", path = "top|left", fight = true },
    { map = "-4,32", path = "top|left|right", fight = true },
    { map = "-5,32", path = "top|left|right", fight = true },
    { map = "-6,32", path = "top|left|right", fight = true },
    { map = "-7,32", path = "top|right", fight = true },
    { map = "-7,31", path = "top|right|bottom", fight = true },
    { map = "-7,30", path = "top|right|bottom", fight = true },
    { map = "-7,29", path = "top|right|bottom", fight = true },
    { map = "-7,28", path = "top|right|bottom", fight = true },
    { map = "-7,27", path = "right|bottom", fight = true },
    { map = "-6,27", path = "top|left|right|bottom", fight = true },
    { map = "-6,26", path = "left|right", fight = true },
    { map = "-7,26", path = "top|right", fight = true },
    { map = "-7,25", path = "right|bottom", fight = true },
    { map = "-6,25", path = "top|left|right", fight = true },
    { map = "-6,24", path = "right|bottom", fight = true },
    { map = "-5,24", path = "left|right|bottom", fight = true },
    { map = "-4,24", path = "left|right|bottom", fight = true },
    { map = "-3,24", path = "left|bottom", fight = true },
    { map = "-3,26", path = "top|left|right|bottom", fight = true },
    { map = "-3,25", path = "top|left|right|bottom", fight = true },
    { map = "-4,27", path = "top|left|right|bottom", fight = true },
    { map = "-4,26", path = "top|left|right|bottom", fight = true },
    { map = "-4,25", path = "top|left|right|bottom", fight = true },
    { map = "-5,25", path = "left|right|bottom", fight = true },
    { map = "-3,27", path = "left|right|bottom", fight = true },
    { map = "-5,26", path = "top|left|right|bottom", fight = true },
    { map = "-5,27", path = "top|left|right|bottom", fight = true },
    { map = "-5,28", path = "top|left|right|bottom", fight = true },
    { map = "-6,28", path = "top|left|right|bottom", fight = true },
    { map = "-6,29", path = "top|left|right|bottom", fight = true },
    { map = "-6,30", path = "top|left|right|bottom", fight = true },
    { map = "-6,31", path = "top|left|right|bottom", fight = true },
    { map = "-5,31", path = "top|left|right|bottom", fight = true },
    { map = "-4,31", path = "top|left|right|bottom", fight = true },
    { map = "-4,30", path = "top|left|right|bottom", fight = true },
    { map = "-4,29", path = "right|bottom", fight = true },
    { map = "-5,30", path = "top|left|right|bottom", fight = true },
    { map = "-5,29", path = "top|left|right|bottom", fight = true },
    { map = "-4,28", path = "top|left|right", fight = true },

}

local Moon = {
    -- { map = "17932", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(458282, -2)
    --             acc.map:changeMap("left")
    --         end
    --         map:useById(458282, -2)
    --         map:changeMap("left")
    --     end
    -- end},  
    {map = "-20,-20", path = "zaap(17932)"},

    {map = "17932", path = "left"},
    { map = "4,-19", path = "zaap(17932)"}, -- astrub
    {map = "-16,1", path = "zaap(17932)"},
    {map = "10,22", path = "zaap(17932)"}, -- rivage sufokien
    {map = "5,7", path = "zaap(17932)"}, -- coin des bouftou

    {map = "-19,-53", path = "zaap(17932)"},
    {map = "147768", path = "zaap(17932)"}, --bonta
    {map = "-1,24", path = "zaap(17932)"}, --scarafeuille
    {map = "-1,13", path = "zaap(17932)"}, --marecage
    {map = "-5,-23", path = "zaap(17932)"}, -- champa
    {map = "-23,-19", path = "zaap(17932)"}, --mont neselite
    {map = "143372", path = "zaap(17932)"}, -- landes de sidimote

    { map = "35,10", path = "right|bottom", fight = true },
    { map = "36,10", path = "left", fight = true },
    { map = "35,11", path = "top|left", fight = true },
    { map = "34,11", path = "left|right|bottom", fight = true },
    { map = "34,12", path = "top|left", fight = true },
    { map = "33,12", path = "top|right", fight = true },
    { map = "33,11", path = "top|left|right|bottom", fight = true },
    { map = "33,10", path = "left|bottom", fight = true },
    { map = "32,10", path = "top|right|bottom", fight = true },
    { map = "32,11", path = "top|right", fight = true },
    { map = "32,9", path = "top|bottom", fight = true },
    { map = "32,7", path = "right|bottom", fight = true },
    { map = "33,7", path = "top|left|bottom", fight = true },
    { map = "33,8", path = "top|left", fight = true },
    { map = "32,8", path = "top|right|bottom", fight = true },
    { map = "33,6", path = "right|bottom", fight = true },
    { map = "34,6", path = "top|left", fight = true },
    { map = "34,5", path = "right|bottom", fight = true },
    { map = "35,5", path = "top|left|right", fight = true },
    { map = "36,5", path = "top|left", fight = true },
    { map = "36,4", path = "left|bottom", fight = true },
    { map = "35,4", path = "right|bottom", fight = true },
 
}

local Champa = {
    -- { map = "84806401", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(475744, -2)
    --             acc.map:changeMap("bottom")
    --         end
    --         map:useById(458282, -2)
    --         map:changeMap("bottom")
    --     end
    -- end},  
    {map = "-20,-20", path = "zaap(84806401)"},
    {map = "-16,1", path = "zaap(84806401)"},
    {map = "10,22", path = "zaap(84806401)"}, -- rivage sufokien
    {map = "5,7", path = "zaap(84806401)"}, -- coin des bouftou
    { map = "4,-19", path = "zaap(84806401)"}, -- astrub
    { map = "84806401", path = "bottom"},
    {map = "147768", path = "zaap(84806401)"}, --bonta
    {map = "-19,-53", path = "zaap(84806401)"},
    {map = "-1,24", path = "zaap(84806401)"}, --scarafeuille
    {map = "-1,13", path = "zaap(84806401)"}, --marecage
    {map = "35,12", path = "zaap(84806401)"}, -- moon
    {map = "-23,-19", path = "zaap(84806401)"}, --mont neselite
    {map = "143372", path = "zaap(84806401)"}, -- landes de sidimote

    { map = "-5,-22", path = "bottom" },
    { map = "-5,-21", path = "bottom" },
    { map = "-5,-20", path = "bottom" },
    { map = "-5,-19", path = "bottom" },
    { map = "-5,-18", path = "left|right", fight = true },
    { map = "-4,-18", path = "left|bottom", fight = true },
    { map = "-4,-17", path = "top|bottom", fight = true },
    { map = "-4,-16", path = "top|bottom", fight = true },
    { map = "-4,-15", path = "top|bottom", fight = true },
    { map = "-4,-14", path = "top|bottom", fight = true },
    { map = "-4,-13", path = "top|bottom", fight = true },
    { map = "-4,-12", path = "top|bottom", fight = true },
    { map = "-4,-10", path = "top", fight = true },
    { map = "-4,-11", path = "top|left|bottom", fight = true },
    { map = "-5,-11", path = "left|right", fight = true },
    { map = "-6,-11", path = "left|right|bottom", fight = true },
    { map = "-7,-11", path = "right|bottom", fight = true },
    { map = "-6,-10", path = "top|left", fight = true },
    { map = "-7,-10", path = "top|right|bottom", fight = true },
    { map = "-7,-9", path = "top|bottom", fight = true },
    { map = "-7,-8", path = "top|bottom", fight = true },
    { map = "-7,-7", path = "top|bottom", fight = true },
    { map = "-7,-6", path = "top|left", fight = true },
    { map = "-8,-6", path = "right|bottom", fight = true },
    { map = "-8,-5", path = "top|left", fight = true },
    { map = "-9,-5", path = "left|right", fight = true },
    { map = "-10,-5", path = "left|right|bottom", fight = true },
    { map = "-10,-4", path = "top|left", fight = true },
    { map = "-11,-4", path = "top|right", fight = true },
    { map = "-11,-6", path = "left|bottom", fight = true },
    { map = "-11,-5", path = "top|right|bottom", fight = true },
    { map = "-12,-6", path = "top|right", fight = true },
    { map = "-12,-8", path = "left" },
    { map = "-12,-7", path = "top" },
    { map = "-13,-8", path = "top|bottom", fight = true },
    { map = "-13,-7", path = "top", fight = true },
    { map = "-13,-9", path = "left|bottom", fight = true },
    { map = "-14,-9", path = "top|right", fight = true },
    { map = "-14,-10", path = "left|bottom", fight = true },
    { map = "-15,-10", path = "left|right", fight = true },
    { map = "-16,-10", path = "top|right", fight = true },
    { map = "-16,-11", path = "top|bottom", fight = true },
    { map = "-16,-12", path = "left|bottom", fight = true },
    { map = "-17,-12", path = "top|right", fight = true },
    { map = "-17,-13", path = "top|bottom", fight = true },
    { map = "-17,-14", path = "top|bottom", fight = true },
    { map = "-17,-15", path = "top|bottom", fight = true },
    { map = "-17,-16", path = "top|bottom", fight = true },
    { map = "-17,-17", path = "top|right|bottom", fight = true },
    { map = "-16,-17", path = "top|left", fight = true },
    { map = "-16,-18", path = "left|right|bottom", fight = true },
    { map = "-17,-18", path = "right|bottom", fight = true },
    { map = "-15,-18", path = "left|right", fight = true },
    { map = "-14,-18", path = "left|right", fight = true },
    { map = "-13,-18", path = "left|right", fight = true },
    { map = "-12,-18", path = "left|right", fight = true },
    { map = "-11,-18", path = "left|right", fight = true },
    { map = "-10,-18", path = "left|right", fight = true },
    { map = "-9,-18", path = "left|right", fight = true },
    { map = "-8,-18", path = "left|right", fight = true },
    { map = "-7,-18", path = "left|right", fight = true },
    { map = "-6,-18", path = "left|right", fight = true },
}

local EgoutBonta = {
    -- { map = "147768", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(260872, -2)
    --             acc.map:changeMap("zaapi(148283)")
    --         end
    --         map:useById(260872, -2)
    --         map:changeMap("zaapi(148283)")
    --     end
    -- end},  
    {map = "-20,-20", path = "zaap(147768)"},
    {map = "10,22", path = "zaap(147768)"}, -- rivage sufokien
    {map = "-16,1", path = "zaap(147768)"},
    { map = "4,-19", path = "zaap(147768)"}, -- astrub
    { map = "147768", path = "zaapi(148283"},
    {map = "-19,-53", path = "zaap(147768)"},
    {map = "-1,24", path = "zaap(147768)"}, --scarafeuille
    {map = "-1,13", path = "zaap(147768)"}, --marecage
    {map = "35,12", path = "zaap(147768)"}, -- moon
    {map = "-5,-23", path = "zaap(147768)"}, -- champa
    {map = "-23,-19", path = "zaap(147768)"}, --mont neselite
    {map = "5,7", path = "zaap(147768)"}, -- coin des bouftou
    {map = "143372", path = "zaap(147768)"}, -- landes de sidimote

    { map = "-33,-59", path = "left" },
    { map = "-34,-59", door = "263" },
    { map = "24903939", path = "left|right", fight = true },
    { map = "24904451", path = "top|left|right", fight = true },
    { map = "24904452", path = "bottom", fight = true },
    { map = "24904963", path = "top|left|right", fight = true },
    { map = "24904964", path = "bottom|left|right", fight = true },
    { map = "24905476", path = "bottom|left|right", fight = true },
    { map = "24905475", path = "top|left", fight = true },
    { map = "24905988", path = "bottom|left", fight = true },
    { map = "24905987", path = "top|right", fight = true },
    { map = "24906499", path = "top|left|right", fight = true },
    { map = "24906500", path = "bottom|right", fight = true },
    { map = "24907012", path = "left|right", fight = true },
    { map = "24907524", path = "bottom|left|right", fight = true },
    { map = "24908036", path = "left", fight = true },
    { map = "24907523", path = "top|right", fight = true },
    { map = "24908035", path = "left|bottom", fight = true },
    { map = "24908034", path = "top|bottom", fight = true },
    { map = "24908033", path = "top|bottom", fight = true },
    { map = "24907776", path = "top|left", fight = true },
    { map = "24907264", path = "right|left", fight = true },
    { map = "24906752", path = "right|top", fight = true },
    { map = "24907009", path = "bottom|top", fight = true },
    { map = "24907010", path = "bottom|top", fight = true },
    { map = "24907011", path = "bottom|left", fight = true },
    { map = "25035523", path = "bottom|right", fight = true },
    { map = "25035522", path = "bottom|top|right", fight = true },
    { map = "25035521", path = "top|right", fight = true },
    { map = "24903937", path = "top|left|right", fight = true },
    { map = "24903938", path = "bottom|left", fight = true },
    { map = "24904449", path = "bottom|left|right", fight = true },
    { map = "24904192", path = "top|right", fight = true },
    { map = "24904704", path = "top|left|right", fight = true },
    { map = "24904961", path = "bottom|left|right", fight = true },
    { map = "24905473", path = "bottom|left|right", fight = true },
    { map = "24905216", path = "top|left|right", fight = true },
    { map = "24905728", path = "top|left|right", fight = true },
    { map = "24905985", path = "bottom|left|right", fight = true },
    { map = "24906497", path = "left", fight = true },
    { map = "24906240", path = "left", fight = true },

}

local ForetDeCania = {
    {map = "-20,-20", path = "zaap(129894405)"},
    {map = "-16,1", path = "zaap(129894405)"},
    {map = "10,22", path = "zaap(129894405)"}, -- rivage sufokien
    { map = "4,-19", path = "zaap(129894405)"}, -- astrub
    { map = "-1,24", path = "zaap(129894405)"}, --scarafeuille
    { map = "-1,13", path = "zaap(129894405)"}, --marecage
    { map = "35,12", path = "zaap(129894405)"}, -- moon
    { map = "-5,-23", path = "zaap(129894405)"}, -- champa
    { map = "-23,-19", path = "zaap(129894405)"}, --mont neselite 
    {map = "147768", path = "zaap(129894405)"}, --bonta
    {map = "5,7", path = "zaap(129894405)"}, -- coin des bouftou
    {map = "143372", path = "zaap(129894405)"}, -- landes de sidimote

    { map = "-19,-53", path = "bottom" },
    { map = "-19,-52", path = "bottom" },
    { map = "-19,-51", path = "bottom" },
    { map = "-19,-50", path = "bottom" },
    { map = "-19,-49", path = "bottom" },
    { map = "-19,-48", path = "bottom" },
    { map = "-19,-46", path = "bottom" },
    { map = "-19,-47", path = "bottom" },
    { map = "-19,-45", path = "right" },
    { map = "-18,-45", path = "bottom" },
    { map = "-18,-44", path = "bottom" },
    { map = "-18,-43", path = "bottom" },
    { map = "-21,-38", path = "top", fight = true },
    { map = "-21,-40", path = "top|right|bottom", fight = true },
    { map = "-21,-41", path = "top|right|bottom", fight = true },
    { map = "-21,-42", path = "right|bottom", fight = true },
    { map = "-20,-42", path = "left|right|bottom", fight = true },
    { map = "-19,-42", path = "left|right|bottom", fight = true },
    { map = "-18,-42", path = "left|right|bottom", fight = true },
    { map = "-17,-42", path = "left|right|bottom", fight = true },
    { map = "-16,-42", path = "left|bottom", fight = true },
    { map = "-16,-41", path = "top|left|right|bottom", fight = true },
    { map = "-15,-41", path = "left|right|bottom", fight = true },
    { map = "-14,-41", path = "left|bottom", fight = true },
    { map = "-14,-40", path = "top|left|bottom", fight = true },
    { map = "-14,-39", path = "top|left|bottom", fight = true },
    { map = "-14,-38", path = "top", fight = true },
    { map = "-16,-39", path = "top|left|right", fight = true },
    { map = "-15,-39", path = "top|left|right", fight = true },
    { map = "-17,-39", path = "top|left|right|bottom", fight = true },
    { map = "-17,-38", path = "top|left|right", fight = true },
    { map = "-16,-38", path = "left", fight = true },
    { map = "-18,-38", path = "top|left|right", fight = true },
    { map = "-19,-38", path = "top|right", fight = true },
    { map = "-19,-39", path = "top|left|right|bottom", fight = true },
    { map = "-20,-39", path = "top|left|right", fight = true },
    { map = "-21,-39", path = "top|right|bottom", fight = true },
    { map = "-20,-40", path = "top|left|right|bottom", fight = true },
    { map = "-20,-41", path = "top|left|right|bottom", fight = true },
    { map = "-19,-40", path = "top|left|right|bottom", fight = true },
    { map = "-19,-41", path = "top|left|right|bottom", fight = true },
    { map = "-18,-41", path = "top|left|right|bottom", fight = true },
    { map = "-18,-40", path = "top|left|right|bottom", fight = true },
    { map = "-18,-39", path = "top|left|right|bottom", fight = true },
    { map = "-17,-40", path = "top|left|right|bottom", fight = true },
    { map = "-17,-41", path = "top|left|right|bottom", fight = true },
    { map = "-16,-40", path = "top|left|right|bottom", fight = true },


}

local MontNeselite = {
    -- { map = "120587009", custom = function ()
    --     if global:isBoss() then
    --         team = global:thisAccountController():getTeamAccounts()
    --         for _, acc in ipairs(team) do
    --             acc.map:useById(509584, -2)
    --             acc.map:changeMap("top")
    --         end
    --         map:useById(509584, -2)
    --         map:changeMap("top")
    --     end
    -- end}, 
    { map = "4,-19", path = "zaap(120587009)"}, -- astrub
    {map = "-16,1", path = "zaap(120587009)"},
    {map = "10,22", path = "zaap(120587009)"}, -- rivage sufokien
    {map = "120587009", path = "top"},
    {map = "-19,-53", path = "zaap(120587009)"},
    {map = "147768", path = "zaap(120587009)"}, --bonta
    {map = "-1,24", path = "zaap(120587009)"}, --scarafeuille
    {map = "-1,13", path = "zaap(120587009)"}, --marecage
    {map = "35,12", path = "zaap(120587009)"}, -- moon
    {map = "-5,-23", path = "zaap(120587009)"}, -- champa
    {map = "-20,-20", path = "zaap(120587009)"},
    {map = "5,7", path = "zaap(120587009)"}, -- coin des bouftou
    {map = "143372", path = "zaap(120587009)"}, -- landes de sidimote

    { map = "120718083", door = "508", fight = true },
    { map = "120586752", door = "254", fight = true },
    { map = "-23,-20", path = "top|left", fight = true },
    { map = "-23,-21", path = "left|bottom", fight = true },
    { map = "-24,-21", path = "top|left|right|bottom", fight = true },
    { map = "-24,-22", path = "bottom", fight = true },
    { map = "-25,-20", path = "top|right", fight = true },
    { map = "-24,-20", path = "top|left|right|bottom", fight = true },
    { map = "-24,-19", path = "top", fight = true },
    { map = "-26,-20", path = "top|bottom", fight = true },
    { map = "-26,-19", path = "top|right", fight = true },
    { map = "-25,-19", path = "left|bottom", fight = true },
    { map = "-25,-18", path = "top|right", fight = true },
    { map = "-24,-18", path = "left|right", fight = true },
    { map = "-26,-21", path = "bottom", fight = true },


}

local RouteDeLaCote = {
    { map = "4,-19", path = "zaap(141588)"}, -- astrub
    {map = "-16,1", path = "zaap(141588)"},
    {map = "10,22", path = "zaap(141588)"}, -- rivage sufokien
    {map = "-19,-53", path = "zaap(141588)"},
    {map = "147768", path = "zaap(141588)"}, --bonta
    {map = "-1,24", path = "zaap(141588)"}, --scarafeuille
    {map = "-1,13", path = "zaap(141588)"}, --marecage
    {map = "35,12", path = "zaap(141588)"}, -- moon
    {map = "-5,-23", path = "zaap(141588)"}, -- champa
    {map = "5,7", path = "zaap(141588)"}, -- coin des bouftou
    {map = "143372", path = "zaap(141588)"}, -- landes de sidimote

    { map = "-20,-20", path = "bottom" },
    { map = "-20,-19", path = "bottom" },
    { map = "-20,-18", path = "bottom" },
    { map = "-20,-17", path = "bottom" },
    { map = "-20,-16", path = "bottom" },
    { map = "-20,-15", path = "left" },
    { map = "-22,-15", path = "left" },
    { map = "-21,-15", path = "left" },
    { map = "-23,-15", path = "left" },
    { map = "-24,-15", path = "left" },
    { map = "-25,-15", path = "left" },
    { map = "-26,-15", path = "left" },
    { map = "-28,-12", path = "top", fight = true },
    { map = "-27,-12", path = "left", fight = true },
    { map = "-29,-13", path = "top", fight = true },
    { map = "-29,-15", path = "top", fight = true },
    { map = "-29,-14", path = "right", fight = true },
    { map = "-29,-16", path = "right", fight = true },
    { map = "-28,-17", path = "top", fight = true },
    { map = "-30,-19", path = "top", fight = true },
    { map = "-29,-19", path = "left", fight = true },
    { map = "-30,-30", path = "right", fight = true },
    { map = "-29,-30", path = "bottom", fight = true },
    { map = "-29,-24", path = "bottom", fight = true },
    { map = "-28,-20", path = "bottom" },
    { map = "-27,-19", path = "bottom" },
    { map = "-27,-18", path = "bottom", fight = true },
    { map = "-28,-19", path = "right" },
    { map = "-29,-20", path = "right" },
    { map = "-30,-21", path = "top|right", fight = true },
    { map = "-30,-22", path = "top|right", fight = true },
    { map = "-30,-24", path = "top|right", fight = true },
    { map = "-30,-23", path = "top|right", fight = true },
    { map = "-30,-25", path = "top|right", fight = true },
    { map = "-30,-26", path = "top|right", fight = true },
    { map = "-30,-27", path = "top|right", fight = true },
    { map = "-30,-28", path = "top|right", fight = true },
    { map = "-30,-29", path = "top|right", fight = true },
    { map = "-29,-29", path = "top|left|bottom", fight = true },
    { map = "-29,-27", path = "top|left|bottom", fight = true },
    { map = "-29,-28", path = "top|left|bottom", fight = true },
    { map = "-29,-25", path = "top|left|bottom", fight = true },
    { map = "-29,-26", path = "top|left|bottom", fight = true },
    { map = "-29,-23", path = "top|left|bottom", fight = true },
    { map = "-29,-22", path = "top|left|bottom", fight = true },
    { map = "-29,-21", path = "top|left|bottom", fight = true },
    { map = "-27,-13", path = "top|left|bottom", fight = true },
    { map = "-27,-14", path = "top|left|bottom", fight = true },
    { map = "-27,-15", path = "top|left|bottom", fight = true },
    { map = "-27,-16", path = "top|left|bottom", fight = true },
    { map = "-28,-16", path = "top|left|bottom", fight = true },
    { map = "-28,-15", path = "top|left|bottom", fight = true },
    { map = "-28,-14", path = "top|left|bottom", fight = true },
    { map = "-28,-13", path = "top|left|bottom", fight = true },
    { map = "-28,-18", path = "left|bottom", fight = true },
    { map = "-29,-18", path = "top|right", fight = true },
    { map = "-30,-20", path = "top|right", fight = true },
}

local ChampsCania = {
    { map = "4,-19", path = "zaap(147768)"}, -- astrub
    {map = "-16,1", path = "zaap(147768)"},
    {map = "10,22", path = "zaap(147768)"}, -- rivage sufokien
    {map = "120587009", path = "top"},
    {map = "-19,-53", path = "zaap(147768)"},
    {map = "-1,24", path = "zaap(147768)"}, --scarafeuille
    {map = "-1,13", path = "zaap(147768)"}, --marecage
    {map = "35,12", path = "zaap(147768)"}, -- moon
    {map = "-5,-23", path = "zaap(147768)"}, -- champa
    {map = "5,7", path = "zaap(147768)"}, -- coin des bouftou
    {map = "143372", path = "zaap(147768)"}, -- landes de sidimote

    {map = "-20,-20", path = "zaap(147768)"},
    { map = "147768", path = "zaapi(146226)"},    


    { map = "-29,-50", path = "bottom"},
    { map = "-29,-49", path = "bottom" },
    { map = "-29,-48", path = "bottom" },
    { map = "-29,-47", path = "bottom" },
    { map = "-29,-46", path = "bottom" },
    { map = "-29,-45", path = "left|right|bottom", fight = true },
    { map = "-30,-45", path = "left|right|bottom", fight = true },
    { map = "-31,-45", path = "left|right|bottom", fight = true },
    { map = "-32,-45", path = "right|bottom", fight = true },
    { map = "-32,-44", path = "top|right|bottom", fight = true },
    { map = "-32,-43", path = "top|right|bottom", fight = true },
    { map = "-32,-42", path = "top|right|bottom", fight = true },
    { map = "-32,-41", path = "top|right|bottom", fight = true },
    { map = "-32,-40", path = "top|right|bottom", fight = true },
    { map = "-32,-39", path = "top|right|bottom", fight = true },
    { map = "-32,-38", path = "top|right", fight = true },
    { map = "-31,-38", path = "top|left|right|bottom", fight = true },
    { map = "-31,-37", path = "top|right", fight = true },
    { map = "-30,-37", path = "top|left|right|bottom", fight = true },
    { map = "-30,-36", path = "top|right|bottom", fight = true },
    { map = "-30,-35", path = "top|right", fight = true },
    { map = "-29,-35", path = "top|left|right", fight = true },
    { map = "-28,-35", path = "top|left|right", fight = true },
    { map = "-27,-35", path = "top|left|right", fight = true },
    { map = "-26,-35", path = "top|left|right", fight = true },
    { map = "-25,-35", path = "top|left|right", fight = true },    
    { map = "-24,-35", path = "top|left", fight = true },
    { map = "-24,-36", path = "top|left|right", fight = true },
    { map = "-23,-36", path = "top|left|right", fight = true },
    { map = "-22,-36", path = "top|left|right", fight = true },
    { map = "-21,-36", path = "top|left", fight = true },
    { map = "-21,-37", path = "left|bottom", fight = true },
    { map = "-22,-37", path = "top|left|right|bottom", fight = true },
    { map = "-22,-38", path = "top|left|bottom", fight = true },
    { map = "-22,-39", path = "top|left|bottom", fight = true },
    { map = "-22,-40", path = "left|bottom", fight = true },
    { map = "-23,-40", path = "left|right|bottom", fight = true },
    { map = "-24,-40", path = "top|left|right|bottom", fight = true },
    { map = "-24,-41", path = "left|bottom", fight = true },
    { map = "-25,-41", path = "top|left|right|bottom", fight = true },
    { map = "-25,-42", path = "left|bottom", fight = true },
    { map = "-26,-42", path = "top|left|right|bottom", fight = true },
    { map = "-26,-43", path = "top|left|bottom", fight = true },
    { map = "-26,-44", path = "top|left|bottom", fight = true },
    { map = "-26,-45", path = "left|bottom", fight = true },
    { map = "-28,-45", path = "left|right|bottom", fight = true },
    { map = "-27,-45", path = "left|right|bottom", fight = true },
    { map = "-31,-44", path = "top|left|right|bottom", fight = true },
    { map = "-30,-44", path = "top|left|right|bottom", fight = true },
    { map = "-29,-44", path = "top|left|right|bottom", fight = true },
    { map = "-28,-44", path = "top|left|right|bottom", fight = true },
    { map = "-27,-44", path = "top|left|right|bottom", fight = true },
    { map = "-27,-43", path = "top|left|right|bottom", fight = true },
    { map = "-28,-43", path = "top|left|right|bottom", fight = true },
    { map = "-29,-43", path = "top|left|right|bottom", fight = true },
    { map = "-31,-43", path = "top|left|right|bottom", fight = true },
    { map = "-30,-43", path = "top|left|right|bottom", fight = true },
    { map = "-31,-42", path = "top|left|right|bottom", fight = true },
    { map = "-30,-42", path = "top|left|right|bottom", fight = true },
    { map = "-29,-42", path = "top|left|right|bottom", fight = true },
    { map = "-28,-42", path = "top|left|right|bottom", fight = true },
    { map = "-27,-42", path = "top|left|right|bottom", fight = true },
    { map = "-27,-41", path = "top|left|right|bottom", fight = true },
    { map = "-26,-41", path = "top|left|right|bottom", fight = true },
    { map = "-29,-41", path = "top|left|right|bottom", fight = true },
    { map = "-28,-41", path = "top|left|right|bottom", fight = true },
    { map = "-30,-41", path = "top|left|right|bottom", fight = true },
    { map = "-31,-41", path = "top|left|right|bottom", fight = true },
    { map = "-31,-40", path = "top|left|right|bottom", fight = true },
    { map = "-30,-40", path = "top|left|right|bottom", fight = true },
    { map = "-29,-40", path = "top|left|right|bottom", fight = true },
    { map = "-27,-40", path = "top|left|right|bottom", fight = true },
    { map = "-28,-40", path = "top|left|right|bottom", fight = true },
    { map = "-26,-40", path = "top|left|right|bottom", fight = true },
    { map = "-25,-40", path = "top|left|right|bottom", fight = true },
    { map = "-24,-39", path = "top|left|right|bottom", fight = true },
    { map = "-23,-39", path = "top|left|right|bottom", fight = true },
    { map = "-23,-37", path = "top|left|right|bottom", fight = true },
    { map = "-23,-38", path = "top|left|right|bottom", fight = true },
    { map = "-24,-38", path = "top|left|right|bottom", fight = true },
    { map = "-24,-37", path = "top|left|right|bottom", fight = true },
    { map = "-26,-37", path = "top|left|right|bottom", fight = true },
    { map = "-25,-37", path = "top|left|right|bottom", fight = true },
    { map = "-25,-36", path = "top|left|right|bottom", fight = true },
    { map = "-26,-36", path = "top|left|right|bottom", fight = true },
    { map = "-28,-36", path = "top|left|right|bottom", fight = true },
    { map = "-27,-36", path = "top|left|right|bottom", fight = true },
    { map = "-29,-36", path = "top|left|right|bottom", fight = true },
    { map = "-29,-37", path = "top|left|right|bottom", fight = true },
    { map = "-28,-37", path = "top|left|right|bottom", fight = true },
    { map = "-27,-37", path = "top|left|right|bottom", fight = true },
    { map = "-27,-38", path = "top|left|right|bottom", fight = true },
    { map = "-28,-38", path = "top|left|right|bottom", fight = true },
    { map = "-30,-38", path = "top|left|right|bottom", fight = true },
    { map = "-31,-39", path = "top|left|right|bottom", fight = true },
    { map = "-30,-39", path = "top|left|right|bottom", fight = true },
    { map = "-29,-39", path = "top|left|right|bottom", fight = true },
    { map = "-29,-38", path = "top|left|right|bottom", fight = true },
    { map = "-28,-39", path = "top|left|right|bottom", fight = true },
    { map = "-27,-39", path = "top|left|right|bottom", fight = true },
    { map = "-26,-39", path = "top|left|right|bottom", fight = true },
    { map = "-26,-38", path = "top|left|right|bottom", fight = true },
    { map = "-25,-38", path = "top|left|right|bottom", fight = true },
    { map = "-25,-39", path = "top|left|right|bottom", fight = true },
}

local LandesSidimote = {
    { map = "4,-19", path = "zaap(143372)"}, -- astrub
    {map = "-16,1", path = "zaap(143372)"},
    {map = "10,22", path = "zaap(143372)"}, -- rivage sufokien
    {map = "-19,-53", path = "zaap(143372)"},
    {map = "147768", path = "zaap(143372)"}, --bonta
    {map = "-1,24", path = "zaap(143372)"}, --scarafeuille
    {map = "-1,13", path = "zaap(143372)"}, --marecage
    {map = "35,12", path = "zaap(143372)"}, -- moon
    {map = "-5,-23", path = "zaap(143372)"}, -- champa
    {map = "5,7", path = "zaap(143372)"}, -- coin des bouftou
    {map = "-20,-20", path = "zaap(143372)"},

    { map = "-24,12", path = "bottom" },
    { map = "-24,13", path = "left", fight = true },
    { map = "-27,12", path = "top|right|bottom", fight = true },
    { map = "-27,11", path = "top|right|bottom", fight = true },
    { map = "-27,10", path = "top|right|bottom", fight = true },
    { map = "-27,9", path = "top|right|bottom", fight = true },
    { map = "-27,8", path = "top|right|bottom", fight = true },
    { map = "-27,6", path = "top|right|bottom", fight = true },
    { map = "-27,7", path = "top|right|bottom", fight = true },
    { map = "-27,5", path = "top|right|bottom", fight = true },
    { map = "-27,13", path = "top|right", fight = true },
    { map = "-26,13", path = "top|left|right", fight = true },
    { map = "-25,13", path = "top|left|right", fight = true },
    { map = "-26,12", path = "top|left|right|bottom", fight = true },
    { map = "-26,11", path = "top|left|right|bottom", fight = true },
    { map = "-25,11", path = "top|left|right|bottom", fight = true },
    { map = "-25,12", path = "top|left|right|bottom", fight = true },
    { map = "-25,10", path = "top|left|right|bottom", fight = true },
    { map = "-26,10", path = "top|left|right|bottom", fight = true },
    { map = "-26,9", path = "top|left|right|bottom", fight = true },
    { map = "-25,9", path = "top|left|right|bottom", fight = true },
    { map = "-25,8", path = "top|left|right|bottom", fight = true },
    { map = "-26,7", path = "top|left|right|bottom", fight = true },
    { map = "-26,6", path = "top|left|right|bottom", fight = true },
    { map = "-26,5", path = "top|left|right|bottom", fight = true },
    { map = "-25,5", path = "top|left|right|bottom", fight = true },
    { map = "-25,6", path = "top|left|right|bottom", fight = true },
    { map = "-26,8", path = "top|left|right|bottom", fight = true },
    { map = "-24,11", path = "top|left|right|bottom", fight = true },
    { map = "-24,10", path = "top|left|right|bottom", fight = true },
    { map = "-24,9", path = "top|left|right|bottom", fight = true },
    { map = "-24,8", path = "top|left|right|bottom", fight = true },
    { map = "-25,7", path = "top|left|right|bottom", fight = true },
    { map = "-24,6", path = "top|left|right|bottom", fight = true },
    { map = "-24,7", path = "top|left|right|bottom", fight = true },
    { map = "-23,12", path = "top|left|right|bottom", fight = true },
    { map = "-23,11", path = "top|left|right|bottom", fight = true },
    { map = "-23,9", path = "top|left|right|bottom", fight = true },
    { map = "-23,8", path = "top|left|right|bottom", fight = true },
    { map = "-23,7", path = "left", fight = true },
    { map = "-23,6", path = "left", fight = true },
    { map = "-23,5", path = "left", fight = true },
    { map = "-24,5", path = "left", fight = true },
    { map = "-23,13", path = "left", fight = true },
    { map = "-22,12", path = "left", fight = true },
    { map = "-22,11", path = "left", fight = true },
    { map = "-22,10", path = "left", fight = true },
    { map = "-23,10", path = "left", fight = true },
    { map = "-22,9", path = "left", fight = true },
    { map = "-22,8", path = "left", fight = true },
}

local FantomesSidimote = {
    { map = "4,-19", path = "zaap(144419)"}, -- astrub
    {map = "-16,1", path = "zaap(144419)"},
    {map = "10,22", path = "zaap(144419)"}, -- rivage sufokien
    {map = "-19,-53", path = "zaap(144419)"},
    {map = "147768", path = "zaap(144419)"}, --bonta
    {map = "-1,24", path = "zaap(144419)"}, --scarafeuille
    {map = "-1,13", path = "zaap(144419)"}, --marecage
    {map = "35,12", path = "zaap(144419)"}, -- moon
    {map = "-5,-23", path = "zaap(144419)"}, -- champa
    {map = "5,7", path = "zaap(144419)"}, -- coin des bouftou
    {map = "-20,-20", path = "zaap(144419)"}, 
    { map = "-24,12",  path = "zaap(144419)"}, -- landes de sidimote

    {map = "144419", path = "zaapi(141346)"},
    { map = "-17,32", path = "top", fight = true },
    { map = "-17,33", path = "top" },
    { map = "-17,34", path = "top" },
    { map = "-18,34", path = "right" },
    { map = "-19,34", path = "right" },
    { map = "-20,34", path = "right" },
    { map = "-17,31", path = "top|left|right", fight = true },
    { map = "-17,30", path = "top|left|right|bottom", fight = true },
    { map = "-18,30", path = "top|left|right|bottom", fight = true },
    { map = "-17,29", path = "top|left|right|bottom", fight = true },
    { map = "-18,29", path = "top|left|right|bottom", fight = true },
    { map = "-16,29", path = "top|left|right|bottom", fight = true },
    { map = "-16,30", path = "top|left|right|bottom", fight = true },
    { map = "-15,29", path = "top|left|right|bottom", fight = true },
    { map = "-15,28", path = "top|left|right|bottom", fight = true },
    { map = "-16,28", path = "top|left|right|bottom", fight = true },
    { map = "-17,28", path = "top|left|right|bottom", fight = true },
    { map = "-18,28", path = "top|left|right|bottom", fight = true },
    { map = "-18,27", path = "top|left|right|bottom", fight = true },
    { map = "-17,27", path = "top|left|right|bottom", fight = true },
    { map = "-16,27", path = "top|left|right|bottom", fight = true },
    { map = "-15,27", path = "top|left|right|bottom", fight = true },
    { map = "-15,26", path = "top|left|right|bottom", fight = true },
    { map = "-16,26", path = "top|left|right|bottom", fight = true },
    { map = "-17,26", path = "top|left|right|bottom", fight = true },
    { map = "-18,26", path = "top|left|right|bottom", fight = true },
    { map = "-16,31", path = "top", fight = true },
    { map = "-18,31", path = "top", fight = true },
    { map = "-19,30", path = "top|right", fight = true },
    { map = "-19,25", path = "top|right|bottom", fight = true },
    { map = "-19,26", path = "top|right|bottom", fight = true },
    { map = "-19,27", path = "top|right|bottom", fight = true },
    { map = "-19,28", path = "top|right|bottom", fight = true },
    { map = "-19,29", path = "top|right|bottom", fight = true },
    { map = "-19,24", path = "top|right|bottom", fight = true },
    { map = "-19,23", path = "top|right|bottom", fight = true },
    { map = "-19,22", path = "right|bottom", fight = true },
    { map = "-18,25", path = "top|left|right|bottom", fight = true },
    { map = "-18,24", path = "top|left|right|bottom", fight = true },
    { map = "-18,23", path = "top|left|right|bottom", fight = true },
    { map = "-17,23", path = "top|left|right|bottom", fight = true },
    { map = "-17,24", path = "top|left|right|bottom", fight = true },
    { map = "-17,25", path = "top|left|right|bottom", fight = true },
    { map = "-16,24", path = "top|left|right|bottom", fight = true },
    { map = "-16,25", path = "top|left|right|bottom", fight = true },
    { map = "-15,25", path = "top|left|right|bottom", fight = true },
    { map = "-15,24", path = "top|left|right|bottom", fight = true },
    { map = "-16,23", path = "top|left|right|bottom", fight = true },
    { map = "-15,23", path = "top|left|right|bottom", fight = true },
    { map = "-14,27", path = "top|left|right|bottom", fight = true },
    { map = "-14,28", path = "top|left|right|bottom", fight = true },
    { map = "-14,26", path = "top|left|right|bottom", fight = true },
    { map = "-14,25", path = "top|left|right|bottom", fight = true },
    { map = "-14,24", path = "top|left|right|bottom", fight = true },
    { map = "-14,23", path = "top|left|right|bottom", fight = true },
    { map = "-18,22", path = "left|right|bottom", fight = true },
    { map = "-17,22", path = "left|right|bottom", fight = true },
    { map = "-16,22", path = "left|right|bottom", fight = true },
    { map = "-15,22", path = "left|right|bottom", fight = true },
    { map = "-14,22", path = "left|right|bottom", fight = true },
    { map = "-13,22", path = "left", fight = true },
    { map = "-13,23", path = "left", fight = true },
    { map = "-13,24", path = "left", fight = true },
    { map = "-13,25", path = "left", fight = true },
    { map = "-13,26", path = "left", fight = true },
    { map = "-13,27", path = "left", fight = true },
    { map = "-13,28", path = "left", fight = true },
    { map = "-14,29", path = "left", fight = true },
    { map = "-15,30", path = "left", fight = true },
}

--- </init>
local TableArea = {
    --{Zone = Marecages, MaxMonster = 4, MinMonster = 3, ListeVenteId = {365, 1652, 417, 6739, 1613, 1663, 8500, 544}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = Dragoeuf, MaxMonster = 4, MinMonster = 3, ListeVenteId = {1924, 545, 308, 847, 546, 1129, 844, 842, 845, 843, 846 }, Farmer = false, PourcentageHdv = 0, Stop = false, Level = 80},
    {Zone = Moon, MaxMonster = 4, MinMonster = 3, ListeVenteId = {997, 2624, 1002, 2618, 2613, 2609, 2610, 2611}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = Champa, MaxMonster = 4, MinMonster = 3, ListeVenteId = {1915, 290, 17062, 17060, 378, 1674, 1679, 382, 1927, 2264}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = EgoutBonta, MaxMonster = 4, MinMonster = 3, ListeVenteId = {18324, 686, 2322, 8484, 8481, 1915}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = ForetDeCania, MaxMonster = 4, MinMonster = 3, ListeVenteId = {16294, 16290, 1921, 16288, 16292, 16284}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = MontNeselite, MaxMonster = 4, MinMonster = 3, ListeVenteId = {7024, 7023, 546, 545, 543, 15426, 15432, 15428, 15433, 15430}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = RouteDeLaCote, MaxMonster = 4, MinMonster = 3, ListeVenteId = {2556, 2557, 1770, 1772, 1773, 1774, 1775, 1776, 1777, 1778}, Farmer = false, PourcentageHdv = 0, Stop = false},
    {Zone = ChampsCania, MaxMonster = 4, MinMonster = 3, ListeVenteId = {424, 1891, 1916, 18328}, Farmer = false, PourcentageHdv = 0, Stop = false},
    --{Zone = LandesSidimote, MaxMonster = 4, MinMonster = 3, ListeVenteId = {1889, 1893, 2502}, Farmer = false, PourcentageHdv = 0, Stop = false},
    --{Zone = FantomesSidimote, MaxMonster = 4, MinMonster = 3, ListeVenteId = {13491, 6480, 14284, 17076}, Farmer = false, PourcentageHdv = 0, Stop = false}, (combat infinissables)

}


local TableVente = {
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Blanc", Id = 881 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Noir", Id = 885 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Racine d'Abraknyde", Id = 435 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Gland", Id = 393 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Résine végétale", Id = 1985 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Patte dArakne", Id = 365 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Bleue", Id = 362 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve", Id = 1898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve**", Id = 1899 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Orange", Id = 363 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau", Id = 1927 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Ailes de Moskito", Id = 307 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Mesure de Poivre", Id = 1978 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir de Sanglier", Id = 486 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    --{Name = "Carré de Porc", Id = 1917 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Tatouage de Mauvais Garçon", Id = 13342 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true}, --début des 2 zones (piou et contour astrub)

    {Name = "Poils de souris", Id = 761 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Graine de Sésame", Id = 287 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Plume de Piou Bleu", Id = 6897 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Violet", Id = 6898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Vert", Id = 6899 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rouge", Id = 6900 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Jaune", Id = 6902 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rose", Id = 6903 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Parchemin Doré", Id = 680 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 10, CanSell = true},


    {Name = "Dent de Dragodinde", Id = 2179 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Aile de Dragodinde Dorée", Id = 13488 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "DragoViande", Id = 1922 , MaxHdv100 = 0, MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},
    {Name = "DragoViande **", Id = 1923 , MaxHdv100 = 0 , MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau **", Id = 1929 , MaxHdv100 = 3, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Viande de Kanigrou", Id = 8498 , MaxHdv100 = 0, MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},

    {Name = "Viande de Kanigrou Conservée", Id = 8501, MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5},
    {Name = "Dragoviande Conservée", Id = 2014, MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5},
    {Name = "Carré de Porc Conservé", Id = 2004, MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5},

    {Name = "Noix de Kokoko", Id = 997, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Feuille de Grokoko", Id = 2624, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Tronc de Kokoko", Id = 1002, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Kokopaille", Id = 2618, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Carapace Bleue VIde", Id = 2613, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Carapace Verte VIde", Id = 2609, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Carapace Rouge VIde", Id = 2610, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Carapace Jaune VIde", Id = 2611, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Patte d'Arakne", Id = 365, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Patte d'Arakne Majeure", Id = 1652, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Boue du Boo", Id = 417, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Peau de Crocodaille", Id = 6739, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Écaille de Chef Crocodaille", Id = 1613, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre d'Émeraude", Id = 544, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Écaille de Crocodaille", Id = 1663, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Viande de Crocodaille", Id = 8500, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "DragoViande ***", Id = 1924, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Cristal", Id = 545, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Coquille de Dragoeuf Blanc", Id = 308, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Oeuf de Dragoeuf Blanc", Id = 847, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Saphir", Id = 546, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Coquille de Dragoeuf Saphir", Id = 1129, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Oeuf de Dragoeuf de Saphir", Id = 844, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Coquille de Dragoeuf Doré", Id = 842, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Oeuf de Dragoeuf Doré", Id = 845, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Rubis", Id = 547, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Coquille de Dragoeuf Noir", Id = 843, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Oeuf de Dragoeuf Noir", Id = 846, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Chair d'Insecte", Id = 1915, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Champignon", Id = 290, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Poudre explosive du champa", Id = 17062, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Herbe Folle", Id = 17060, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Sporme du Champ Champ", Id = 378, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Champignon Luidegît", Id = 1674, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Crystaloboule", Id = 1679, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Ongle de Chevaucheur de Karne", Id = 382, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Museau", Id = 1927, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Peau de Gobelin", Id = 2264, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Grand Parchemin d'Intelligence", Id = 18324, MaxHdv100 = 0, MaxHdv10 = 2, MaxHdv1 = 5, CanSell = true},
    {Name = "Petit Parchemin d'Intelligence", Id = 686, MaxHdv100 = 0, MaxHdv10 = 2, MaxHdv1 = 5, CanSell = true},
    {Name = "Crocs de Rats", Id = 2322, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Poil de Chamane d'Egoutant", Id = 8484, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Poil de Rat d'Hyoactif", Id = 8481, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Estomac de Gligli", Id = 16294, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Défense de Gliglicérin", Id = 16290, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Carré de Porc ***", Id = 1921, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Sabot de Gliglidromel", Id = 16288, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Étoffe de Gliglimuable", Id = 16292, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Cuir de Gliglitch", Id = 16284, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Pierre de Topaze", Id = 7024, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre d'Aigue-Marine", Id = 7023, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Saphir", Id = 546, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Cristal", Id = 545, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pierre de Diamant", Id = 543, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Chope vide", Id = 15426, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Fronde du cavalier Brise-pierre", Id = 15432, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Poils de barbe du cavalier Ronimbos", Id = 15428, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Jambières de Cogneroc", Id = 15433, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Dent de Cuirhacher", Id = 15430, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Pollen de Blop", Id = 2556, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Pétale de Blop", Id = 2557, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Bout de Blop Coco", Id = 1770, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Fleur de Blop Coco", Id = 1772, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Bout de Blop Reinette", Id = 1773, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Fleur de Blop Reinette", Id = 1774, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Bout de Blop Griotte", Id = 1775, MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 10, CanSell = true},
    {Name = "Fleur de Blop Griotte", Id = 1776, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Bout de Blop Indigo", Id = 1777, MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 10, CanSell = true},
    {Name = "Fleur de Blop Indigo", Id = 1778, MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Fibre de Lin", Id = 424 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Duvet de Bourdard", Id = 1891 , MaxHdv100 = 3, MaxHdv10 = 10, MaxHdv1 = 10, CanSell = true},
    {Name = "Grand Parchemin de Force", Id = 18328 , MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 10, CanSell = true},

    {Name = "Plume de Corbac", Id = 1889 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Queue de scorbute", Id = 1893 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Papatte de Croc Gland", Id = 2502 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

    {Name = "Relique Familiale", Id = 13491 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Osier Sombre", Id = 6480 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Flamme Spectrale", Id = 14284 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},
    {Name = "Etoffe de Fantôme Hicide", Id = 17076 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 5, CanSell = true},

}

local cptActualiser = 1
local hdvActualise = false


local hdvFull = false
local DebutDuScript = true

--- </functions>

function launchExchangeAndGiveItems()
    
    inventory:openBank()
    global:delay(500)

    -- for _, element in ipairs(TableVente) do
    --     local podsAvailable = inventory:podsMax() - inventory:pods()
    --     local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), math.floor(podsAvailable / inventory:itemWeight(element.Id)))
    --     if QuantiteAPrendre > 0 then
    --         global:printSuccess("on refait un échange")
    --         LaunchExchange = true
    --         exchange:getItem(element.Id, QuantiteAPrendre)
    --     end
    -- end
    global:delay(500)
    global:leaveDialog()
    global:delay(500)

    if LaunchExchange then
        global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

        AccountBank.global:setPrivate(false)
        AccountBank:exchangeListen(false)

        while AccountBank:isScriptPlaying() do
            global:delay(2000)
        end 

        while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
            if ConsoleRead(AccountBank, "Le serveur a coupé la connexion") then
                AccountBank.global:clearConsole()
                AccountBank:unloadAccount()
                AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Bot_Bank.lua")
            end
            global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
            global:delay(5000)
        end

        local toGive = character:kamas() - 100000
        if toGive > 0 then
            global:printSuccess("on transfère " .. toGive .. "kamas")
            exchange:putKamas(toGive)
        end

        for _, element in ipairs(TableVente) do
            if inventory:itemCount(element.Id) > 0 then
                exchange:putItem(element.Id, inventory:itemCount(element.Id))
            end
        end

        global:delay(500)
        exchange:ready()

        global:delay(2000)
        LaunchExchange = false
        return launchExchangeAndGiveItems()
    end
    global:printSuccess("on lance le script du bot bank")
    -- si on a plus rien à donner au bot banque, on retourne farm
    exchangeDone = true
    AccountBank:startScript()
    global:editAlias(global:thisAccountController():getAlias() .. " Need4", true)
    PopoRappel()
end


local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end

function isWhitelisted(id)
    local IdsAvailable = global:getTeamMembersIds()
    global:printSuccess(id)

    for _, Id in ipairs(IdsAvailable) do
        global:printSuccess(Id)
        if Id == id then
        	return true
        end
    end
    return false
end

function _ExchangeRequestedTradeMessage(message)
    if not global:isBoss() then
        global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
        developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
        global:delay(1000)
    
        local toGive = character:kamas() - 70000
        -- Put kamas
        if toGive > 0 then
            global:printSuccess("Je mets dans l'échange ".. toGive .." kamas.")
            exchange:putKamas(toGive)
        end
    
        global:printSuccess("je mets les ressources")
    
        for _, element in ipairs(TableVente) do
            if inventory:itemCount(element.Id) > 0 then
                exchange:putItem(element.Id, inventory:itemCount(element.Id))
            end
        end
    
        global:printSuccess("on valide l'échange")
    
        exchange:ready()
        -- Wait
        global:printMessage("Attente de confirmation ...")
    end
    global:printSuccess("bug")
	-- Check
	--[[if not isWhitelisted(message.source) then
		global:printError("Échange reçu de la part d'un joueur inconnu, on refuse !")
		global:leaveDialog()
		return
	end]]
	-- Accept
end

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
    developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end

---Fonction qui permet de lancer la communication avec l'HDV.

local function antiModo()
    if global:isModeratorPresent(25) then
        timerdisconnect = math.random(30000, 36000) 

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

        local Alias = global:thisAccountController():getAlias():split(" ")

        if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
            global:editAlias("Team 1 " .. character:serverName() .. " CombatBL [MODO]", true)
        else
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. " CombatBL [MODO]", true)
        end

        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global:reconnectBis(timerdisconnect / 1000)
            end
            global:reconnectBis((timerdisconnect + 10) / 1000)
        elseif not global:thisAccountController():isItATeam() then
            global:reconnectBis(timerdisconnect / 1000)
        end
    end
end

local function ProcessSell()

    if not DebutDuScript then
        if global:isBoss() then

            npc:npcSale()

            developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

            table.sort(TableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

            global:delay(1000)

            local indexSuivant = 0
            for i, element in ipairs(TableVente) do
                if inventory:itemCount(element.Id) == 0 then 
                    indexSuivant = i
                    global:printSuccess("on a plus rien à vendre") 
                    break 
                end

                local Prices = GetPricesItem(element.Id)
        
                cpt = get_quantity(element.Id).quantity["100"]
                while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
                    Prices.Price100 = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and (Prices.AveragePrice * 100) or Prices.Price100
                    sale:SellItem(element.Id, 100, Prices.Price100 - 1) 
                    global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Prices.Price100 - 1 .. "kamas")
                    cpt = cpt + 1
                end
                element.Remaining100 = element.MaxHdv100 - cpt

                cpt = get_quantity(element.Id).quantity["10"]
                while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and element.MaxHdv10 ~= nil and cpt < element.MaxHdv10 do 
                    Prices.Price10 = (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and (Prices.AveragePrice * 10) or Prices.Price10
                    sale:SellItem(element.Id, 10, Prices.Price10 - 1) 
                    global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Prices.Price10 - 1 .. "kamas")
                    cpt = cpt + 1
                end
                element.Remaining10 = element.MaxHdv10 - cpt

                cpt = get_quantity(element.Id).quantity["1"]
                while inventory:itemCount(element.Id) >= 1 and sale:AvailableSpace() > 0 and element.MaxHdv1 ~= nil and cpt < element.MaxHdv1 do 
                    Prices.Price1 = (Prices.Price1 == nil or Prices.Price1 == 0 or Prices.Price1 == 1) and Prices.AveragePrice or Prices.Price1
                    sale:SellItem(element.Id, 1, Prices.Price1 - 1) 
                    global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Prices.Price1 - 1 .. "kamas")
                    cpt = cpt + 1
                end
                element.Remaining1 = element.MaxHdv1 - cpt
            end

            for i = indexSuivant, #TableVente do
                TableVente[i].Remaining100 = TableVente[i].MaxHdv100 - get_quantity(TableVente[i].Id).quantity["100"]
                TableVente[i].Remaining10 = TableVente[i].MaxHdv10 - get_quantity(TableVente[i].Id).quantity["10"]
                TableVente[i].Remaining1 = TableVente[i].MaxHdv1 - get_quantity(TableVente[i].Id).quantity["1"]
            end

            if cptActualiser >= 3 and not hdvActualise and character:kamas() > 150000 then
                global:printSuccess("Actualisation des prix")
                hdvActualise = true
                cptActualiser = 0
                sale:updateAllItems()
            else
                cptActualiser = cptActualiser + 1
            end
    
            if sale:AvailableSpace() == 0 then 
                hdvFull = true 
                global:printError("l'hdv est plein") 
            else
                hdvFull = false
            end
    
            global:leaveDialog()
            global:delay(500)
        end
    end


    if global:isBoss() then
        npc:npcSale()

        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

        global:delay(1000)

        -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
        for _, element in ipairs(TableVente) do
            if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 and get_quantity(element.Id).quantity["1"] >= element.MaxHdv1 then
                element.CanSell = false
            else
                element.CanSell = true
            end
        end
        for i, element in ipairs(TableArea) do
            local compteur = 0
            for _, element2 in ipairs(element.ListeVenteId) do
                for _, element3 in ipairs(TableVente) do -- trouve l'id dans la tableVente
                    if element2 == element3.Id then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).total_lots / (element3.MaxHdv100 + element3.MaxHdv10 + element3.MaxHdv1))
                        compteur = compteur + 1
                    end
                end
            end
            element.PourcentageHdv = math.floor(element.PourcentageHdv * 100 / compteur)		
            global:printSuccess(element.PourcentageHdv)
            --element.Stop = element.PourcentageHdv >= 85
        end
    
        global:leaveDialog()
    
        table.sort(TableArea, function(a1, a2) return a1.PourcentageHdv < a2.PourcentageHdv end)
    end


    --[[for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("Groupe " .. character:server()) then
            
        end
    end]]


    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global:deleteMemory("TableArea")
            acc.global:addInMemory("TableArea", TableArea)
        end
        global:deleteMemory("TableArea")
        global:addInMemory("TableArea", TableArea)
    end

    TableArea = global:remember("TableArea")

    for _, element in ipairs(TableArea) do
        element.Farmer = false
        for _, element2 in ipairs(element.Zone) do
            element2[3] = false
        end
        element.PourcentageHdv = 0
    end

    for _, element in ipairs(TableArea) do
        if not element.Stop then
            element.Farmer = true
            element.Zone[1][3] = true
            break
        end
    end

    if not DebutDuScript then
        ProcessBank()
    end
    DebutDuScript = false
end

local function treatMaps(maps)
    local msg = "[Erreur] - Aucune action à réaliser sur la map"

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

    if global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc:callScriptFunction("PopoRappel")
        end
        PopoRappel()
    elseif not global:thisAccountController():isItATeam() then
        PopoRappel()
    end
end

local function WhichArea()
    tradeDone = false
    hdvActualise = false
    for i in ipairs(TableArea) do

        if ((global:getCountFight() + global:remember("Increment")) % 40) == 0 and global:isBoss() and TableArea[i].Farmer and (not TableArea[i].Level or character:level() > TableArea[i].Level) then

            global:editInMemory("Increment", global:remember("Increment") + 1)
            global:printSuccess("Changement de zone")
            global:printSuccess(i + 1 .. " ème zone")

            -- changement de zone
            TableArea[i].Farmer = false

            for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                global:printSuccess(i + index - 1)
                global:printSuccess(#TableArea)
                local increment = IncrementTable(i + index - 1, #TableArea)

                if not TableArea[increment].Stop then

                    MAX_MONSTERS = TableArea[increment].MaxMonster
                    MIN_MONSTERS = TableArea[increment].MinMonster

                    TableArea[increment].Farmer = true

                    if global:isBoss() then
                        local Team = global:thisAccountController():getTeamAccounts()
                        for _, acc in ipairs(Team) do
                            acc:setScriptVariable("TableArea", TableArea)
                        end
                    end

                    return treatMaps(TableArea[increment].Zone)
                end
            end
            -- si on a pas trouvé d'autre zone, on refarm la même

            return treatMaps(TableArea[i].Zone[1][1])

        elseif TableArea[i].Farmer then
            global:printSuccess(i)
            local myZone = TableArea[i]

            MAX_MONSTERS = myZone.MaxMonster
            MIN_MONSTERS = myZone.MinMonster

            return treatMaps(myZone.Zone)
        end
    end
end

local function EditAlias()
    local Alias = global:thisAccountController():getAlias():split(" ")
    if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
        global:editAlias("Team 1 " .. character:serverName() .. " CombatBL [" .. character:level() .. "]", true)
    else
        global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. " CombatBL [" .. character:level() .. "]", true)
    end
end

function move()

    if #global:thisAccountController():getTeamAccounts() == 1 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Team.lua")
    end

    if not global:thisAccountController():isItATeam() and character:kamas() < (character:level() < 85 and 400000 or 650000) then
        global:editAlias(global:thisAccountController():getAlias() .. " Need4", true)
        global:disconnect()
    end

    if not global:thisAccountController():isItATeam() and not exchangeDone then
        return treatMaps(GoToAstrubBank)
    elseif not global:thisAccountController():isItATeam() and exchangeDone then
        global:disconnect()
    end

    if global:isBoss() then
        if character:kamas() > (character:level() < 85 and 500000 or 750000) then
            local team = global:thisAccountController():getTeamAccounts()
            if not rappel1 then
                rappel1 = true
                for _, account in ipairs(team) do
                    account:callScriptFunction("PopoRappel")
                end
                PopoRappel()
            end
            for _, acc in ipairs(team) do
                acc:callScriptFunction("EditAlias")
                acc.global:editAlias(acc.global:thisAccountController():getAlias() .. " Need4", true)
            end
            EditAlias()
            global:editAlias(global:thisAccountController():getAlias() .. " Need1", true)
            global:disconnect()
        end
        if inventory:itemCount(250) > 1 then
            local TeamAcount = global:thisAccountController():getTeamAccounts()
            if not rappel then
                rappel = true
                for _, account in ipairs(TeamAcount) do
                    account:callScriptFunction("PopoRappel")
                end
                PopoRappel()
            end

            for _, acc in ipairs(TeamAcount) do
                if acc.inventory:itemCount(250) == 0 then
                    acc.global:setPrivate(false)
                    while not exchange:launchExchangeWithPlayer(acc.character:id()) do
                        global:printMessage("Attente de l'acceptation de l'échange (1 secondes)")
                        global:delay(1000)
                    end
    
                    exchange:putItem(250, 1)
                    developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
                    exchange:ready()
        
                    acc.global:setPrivate(true)
                    acc.inventory:equipItem(250, 1)
                end
            end
            inventory:equipItem(250, 1)
        end
    end

    TakeBonusPackForTeam()
    
    if global:afterFight() and global:isBoss() then
        if not mount:hasMount() then
            global:printSuccess("Ce bot n'a pas de dd")
        end
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            if not acc.mount:hasMount() then
                acc.global:printSuccess("Ce bot n'a pas de dd")
            end
            acc:callScriptFunction("ManageMount")
        end
        ManageMount()
    end


    if DebutDuScript then
        ProcessSell()
    end

    EditAlias()

    antiModo()


    return WhichArea()
end

function ProcessBank()
    inventory:openBank()

    if exchange:storageKamas() > 0 then
        global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
        exchange:getKamas(0)
        global:delay(500)
    elseif exchange:storageKamas() == 0 then
        global:printError("Il n'y a pas de kamas en banque")
        global:delay(500)
    end

    if global:isBoss() then
        if hdvFull then
            exchange:putAllItems()
        else
            for _, element in ipairs(TableVente) do
                if inventory:itemCount(element.Id) > 0 then
                    exchange:putItem(element.Id, inventory:itemCount(element.Id))
                end
            end
        end
        if not hdvFull then
            local itemToSell = {}
            local podsAvailable = inventory:podsMax() - inventory:pods()
            for _, element in ipairs(TableVente) do
                local TotalMax = element.Remaining100 * 100 + element.Remaining10 * 10 + element.Remaining1
                local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable * 0.95 / inventory:itemWeight(element.Id)))
                if ((element.Remaining100 > 0 and QuantiteAPrendre >= 100) or (element.Remaining10 > 0 and QuantiteAPrendre >= 10)) and element.CanSell then
                    local element = {Id = element.Id, quantity = QuantiteAPrendre}
                    table.insert(itemToSell, element)
                    podsAvailable = podsAvailable - QuantiteAPrendre * inventory:itemWeight(element.Id)
                end
            end
            if itemToSell ~= nil and #itemToSell > 2 then
                for _, element in ipairs(itemToSell) do
                    exchange:getItem(element.Id, element.quantity)
                end
                ProcessSell()
            end
        end
    end

    hdvFull = false

	global:leaveDialog()
    local team = global:thisAccountController():getTeamAccounts()
    for _, acc in ipairs(team) do
        acc:callScriptFunction("PopoRappel")
    end
    PopoRappel()
end

function bank()
    EditAlias()
    DebutDuScript = false

    if not global:thisAccountController():isItATeam() and not exchangeDone and character:kamas() > (character:level() < 85 and 400000 or 650000) then
        return treatMaps(GoToAstrubBank)
    elseif not global:thisAccountController():isItATeam() and character:kamas() <= (character:level() < 85 and 400000 or 650000) then
        return move()
    elseif not global:thisAccountController():isItATeam() and exchangeDone then
        global:disconnect()
    end

    if not tradeDone and global:isBoss() then   

        local itemsToAdd = {
            {name = "Taquin Mineur", id = 13766, emplacement = 10},
            {name = "Chanceux Mineur", id = 19407, emplacement = 11},
            {name = "Taquin", id = 13767, emplacement = 12},
            {name = "Saccageur Eau Mineur", id = 13781, emplacement = 13},
            {name = "ares", id = 250, emplacement = 1}
        }
        for _, item in ipairs(itemsToAdd) do
            if inventory:getLevel(item.id) <= character:level() and inventory:itemCount(item.id) == 0 and (not item.name == "ares" or character:level() > 99) then
                npc:npcSale()
                local price = GetPricesItem(item.id).Price1
                global:leaveDialog()
                if (character:kamas() - price) > 100000 and price > 0 then
                    Achat(item.id, 1)
                end
            end
        end

        for _, item in ipairs(itemsToAdd) do
            if inventory:itemCount(item.id) > 0 and inventory:itemPosition(item.id) == 63 then
                inventory:equipItem(item.id, item.emplacement)
            end
        end

        local TeamAcount = global:thisAccountController():getTeamAccounts()

        for _, acc in ipairs(TeamAcount) do
            if not acc.map:onMap(map:currentMapId()) then
                tradeDone = false
                break
            end
            if acc.inventory:podsP() > 5 then
                for _, item in ipairs(itemsToAdd) do
                    if acc.inventory:getLevel(item.id) <= acc.character:level() and acc.inventory:itemCount(item.id) == 0 and (not item.name == "ares" or acc.character:level() > 99) then
                        npc:npcSale()
                        local price = GetPricesItem(item.id).Price1
                        global:leaveDialog()
                        if (character:kamas() - price) > 100000 and price > 0 then
                            Achat(item.id, 1)
                        end
                    end
                end
                acc.global:setPrivate(false)
                while not exchange:launchExchangeWithPlayer(acc.character:id()) do
                    global:printMessage("Attente de l'acceptation de l'échange (1 secondes)")
                    global:delay(1000)
                end
    
                local kamasToGive = (character:level() < 85 and 500000 or 750000) - acc.character:kamas()
                local tableAlias = acc:getAlias():split(" ")
                local nbDaysRemaining = tonumber(tableAlias[#tableAlias])

                local content = inventory:inventoryContent()
                for _, element in ipairs(content) do
                    for _, item in ipairs(itemsToAdd) do
                        if element.objecttGID == item.id and element.position == 63 and inventory:itemCount(item.id) > 0 and acc.inventory:itemCount(item.id) == 0 then
                            exchange:putItem(item.id, 1)
                        end
                    end
                end
                
                for _, item in ipairs(itemsToAdd) do
                    if inventory:itemCount(item.id) > 0 and acc.inventory:itemCount(item.id) == 0 then
                        exchange:putItem(item.id, 1)
                    end
                end

                if kamasToGive > 0 and character:kamas() > kamasToGive * 1.1 and nbDaysRemaining < 2 then
                    global:printSuccess("je donne " .. kamasToGive .. " à la mule " .. acc:getAlias())
                    exchange:putKamas(kamasToGive)
                end
                developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
                exchange:ready()

                for _, item in ipairs(itemsToAdd) do
                    if acc.inventory:itemCount(item.id) > 0 and acc.inventory:itemPosition(item.id) == 63 then
                        acc.inventory:equipItem(item.id, item.emplacement)
                    end
                end
    
                acc.global:setPrivate(true)
            end
        end

        for _, acc in ipairs(TeamAcount) do
            if acc.character:level() < 85 then
                acc.inventory:openBank()
                if acc.exchange:storageKamas() > 0 then
                    acc.global:printSuccess("Il y a " .. acc.exchange:storageKamas() .. " kamas en banque, on les prend")
                    acc.exchange:getKamas(0)
                    global:delay(500)
                elseif exchange:storageKamas() == 0 then
                    acc.global:printError("Il n'y a pas de kamas en banque")
                    global:delay(500)
                end
                acc.global:leaveDialog()
                global:delay(500)
            end

            acc.global:setPrivate(false)
            local counter = 0
            while not exchange:launchExchangeWithPlayer(acc.character:id()) do
                if counter >= 60 then
                    global:restartScript(true)
                end
                global:printMessage("Attente de l'acceptation de l'échange (2 secondes)")
                global:delay(2000)
                counter = counter + 1
            end

            local kamasToGive = 60000 - acc.character:kamas()
        
            if kamasToGive > 0 and character:kamas() > kamasToGive * 1.1 then
                global:printSuccess("je donne " .. kamasToGive .. " à la mule " .. acc:getAlias())
                exchange:putKamas(kamasToGive)
            end
            
            developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
            exchange:ready()

            acc.global:setPrivate(true)
        end
        tradeDone = true
    end

    if global:isBoss() or not global:thisAccountController():isItATeam() then
        ProcessSell()
    end
end

function phenix()
    return {
        { map = "-18,-57", custom = function (acc)
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(172)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(172)
            mount:toggleRiding()
            PopoRappel()
        end},

        { map = "8,16", path = "right" },
        { map = "9,16", path = "right" },

        { map = "32,11", path = "top" },
        { map = "32,10", path = "top" },
        { map = "32,9", path = "top" },
        { map = "32,8", path = "top" },
        { map = "33,7", path = "top" },
        { map = "34,6", path = "top" },
        { map = "32,7", path = "right" },
        { map = "33,6", path = "right" },
        { map = "34,5", path = "right" },
        { map = "34,6", path = "top" },
        { map = "35,5", path = "right" },
        {map = "36,5", custom = function (acc)
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(327)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(327)
            mount:toggleRiding()
            PopoRappel()
        end},

        {map = "-14,30", path = "bottom"},
        {map = "-13,30", path = "left"},
        {map = "-13,31", path = "left"},

        {map = "-15,32", path = "right"},
        {map = "-13,32", path = "left"},
        {map = "-14,32", path = "top"},
        {map = "-14,31", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(243)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(243)
            mount:toggleRiding()
            PopoRappel()
        end},

        {map = "-18,-57", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(172)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(172)
            mount:toggleRiding()
            PopoRappel()
        end},
        {map = "-11,16", path = "top"},
        {map = "-11,15", path = "top"},
        {map = "-11,14", path = "top"},
        {map = "-11,13", path = "right"},
        {map = "-13,13", path = "right"},

        {map = "64489222", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(354)
                    acc.mount:toggleRiding()
                    acc.map:door(218)
                end
            end
            map:door(354)
            mount:toggleRiding()
            map:door(218)
        end},
        {map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() 
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(184)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(184)
            mount:toggleRiding()
            PopoRappel()
        end},
        {map = "-10,-6", custom = function() 
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(185)
                    acc.mount:toggleRiding()
                    acc:callScriptFunction("PopoRappel")
                end
            end
            map:door(185)
            mount:toggleRiding()
            PopoRappel()
        end},
    }
end


function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end