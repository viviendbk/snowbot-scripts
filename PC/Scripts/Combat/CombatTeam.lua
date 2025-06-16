---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {20796, 1531, 1532 , 1533, 1534, 1535, 1536, 1537, 1538, 16836, 421, 2449, 6844, 6845, 6841, 6843, 450, 8252, 2058, 13733, 13503, 14279, 13499, 13338, 16829, 16821, 16822, 15073 , 11475, 11257, 11253, 11254, 11250, 11251, 16827, 11255, 13512, 2496, 8481 ,16820 ,2497 ,2486, 2306, 18369, 18370, 18411, 16827, 18366, 2305, 7903, 7904, 13731, 16826, 16830 ,8571, 16831 ,8570 ,2251,2495, 10832 ,16819 ,381,311,2584,16823,16828,1674 ,14017,7423,12132,362,364,643,10967,363,2563,6921 ,371 ,6916 ,6917 ,6918 ,6915 ,16835 ,6919 ,6920 ,6922 ,6914 ,1673,6913 ,6912 ,6911 ,16834 ,300, 13435 ,7030 ,2566 ,1676 ,2296, 2664, 544 ,2585, 417,1635,2295, 6928,6927,6929,6908,6909,6926,6910, 2303,16824 ,2302,8518 ,792 ,2583, 434, 435, 437, 2573, 1690, 464, 2576, 387, 407, 463, 1672, 652,398,1467,1528,679,16825, 2507,1526,1527,1529 ,16832,2508,1771
 }

FORBIDDEN_MONSTERS = {375, 450, 2428, 4015, 4622, 4618, 5074, 54, 110, 290, 291, 292, 396, 3239, 3240, 108, 5076, 2570, 5081, 2382, 4362, 4363, 4364, 5308, 5309, 5311, 5313, 2374, 2471, 2370, 2469}
MAX_MONSTERS = 8
MIN_MONSTERS = 3
AMOUNT_MONSTERS = {{1044, 0, 2}, {4298, 0, 1}}
PLANNING = {2, 3, 4, 5, 6, 7, 14, 15}

--PLANNING = {4, 9, 14, 19, 24}

TeamAcount = global:thisAccountController():getTeamAccounts()
lenghtTeam = 0
if global:isBoss() then
    lenghtTeam = #TeamAcount + 1
end


local phrase = nil
if global:thisAccountController():getAlias():find("Groupe") then
    phrase = "Groupe " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe2") then
    phrase = "Groupe2 " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe3") then
    phrase = "Groupe3 " .. character:server()
elseif global:thisAccountController():getAlias():find("Groupe4") then
    phrase = "Groupe4 " .. character:server()
end


-- if global:isBoss() and (inventory:podsP() < 50) then
--     for _, acc in ipairs(TeamAcount) do
--         if acc:isAccountFullyConnected() and acc.map:onMap(161351684) then
--             acc.map:useById(503232, -2)
--         end
--         if acc:isAccountFullyConnected() and not acc.map:onMap("0,0") and not acc.character():isInFight() and (character:energyPoints() > 0) then
--             acc.map:changeMap("havenbag")
--         end
--     end
--     if map:onMap(161351684) then
--         map:useById(503232, -2)
--     end
--     if not map:onMap("0,0") and not character:isInFight() and (character:energyPoints() > 0) then
--         map:changeMap("havenbag")
--     end
-- end


local lancable = 0
local incrementation = 0
local CompteurDeath = 0

local tableIdole = {
    {name = "dynamo", id_banque = 16864, id_message = 32, equipe = false},
    {name = "leukide", id_banque = 16881, id_message = 46, equipe = false},
    {name = "pého", id_banque = 16987, id_message = 95, equipe = false},
    {name = "yoche mineur", id_banque = 16959, id_message = 61, equipe = false},
}


local function venteParchoEtRegenEnergie()

    global:printSuccess("Vente de parchos")

	npc:npc(385,5)
	global:delay(500)

    local Priceitem = sale:getPriceItem(678, 3)
    while inventory:itemCount(678) >= 100 and sale:availableSpace() > 0 do 
        Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(678, 3) * 1.5 or Priceitem
        sale:SellItem(678, 100, Priceitem - 1) 
        global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(678)  .. " à " .. Priceitem - 1 .. "kamas")
    end

    local Priceitem = sale:getPriceItem(680, 2)
    while inventory:itemCount(680) >= 10 and sale:availableSpace() > 0 do 
        Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(680, 2) * 1.5 or Priceitem
        sale:SellItem(680, 10, Priceitem - 1) 
        global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(680)  .. " à " .. Priceitem - 1 .. "kamas")
    end

    GoSellParcho = false

	global:delay(500)
	global:leaveDialog()
	map:changeMap("left")
end

local AreaEnergieAndSellParcho = {
	{map = "0,0", path = "zaap(212600323)"},
	{map="212600323", path = "bottom"},
	{map="-31,-55", path = "bottom"},
	{map = "-31,-53", lockedCustom = venteParchoEtRegenEnergie}, 
	{map="-31,-54", path = "bottom"},
}

local ArbreHakam1 = {
    {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
    {map = "161220622", path = "top"},
    {map = "161220620", path = "right"},
    {map = "161221644", path = "top"},
    {map = "161220618", path = "left"},
    {map = "161219594", path = "top"},
    {map = "161219592", path = "left"},
    {map = "161218568", path = "top"},
    {map = "161350662", path = "top"},
    {map = "161350660", path = "left"},

    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right"},
    {map = "161357060", path = "right"},
    {map = "161356036", path = "top"},
    {map = "161356038", path = "right"},
    {map = "161355012", path = "bottom"},
    {map = "161355010", path = "right"},
    {map = "161353986", path = "right"},
    {map = "161352704", path = "right"},
    {map = "161351680", path = "bottom"},
    {map = "161350658", path = "right"},
    {map = "161218562", path = "right"},
    {map = "161219586", path = "bottom"},
    {map = "161219588", path = "bottom"},
    {map = "161220614", path = "bottom"},

    {map = "160959747", path = "left"},
    {map = "160959745", path = "left"},
    {map = "160958464", path = "left"},
    {map = "160957952", path = "left"},
    {map = "160957440", path = "left"},
    {map = "160956928", path = "top"},
    {map = "160956416", path = "right"},
    {map = "160956417", path = "right"},
    {map = "160956929", path = "top"},
    {map = "160956930", path = "top"},
    {map = "160956931", path = "top"},
    {map = "160957443", path = "top"},
    {map = "160957442", path = "top"},
    {map = "160957441", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957954", path = "top"},
    {map = "160957955", path = "top"},
    {map = "160958466", path = "top"},
    {map = "160958465", path = "top"},
    {map = "160957953", path = "top"},

    {map = "0,0", path = "zaap(20973313)"},
    {map = "20973313", lockedCustom = function()
        message = developer:createMessage("SpellVariantActivationRequestMessage")
        message.spellId = 14011
        if global:isBoss() then
            local team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                if acc.character():level() > 154 then
                    --acc.developer():sendMessage(message)
                    --global:delay(500)
                end
                acc.map:changeMap("bottom")
            end
            if character:level() > 154 then
                --developer:sendMessage(message)
            end            
            --global:delay(500)
            map:changeMap("bottom")
        end
        end},
    {map = "20973056", path = "bottom"},
    {map = "20973057", path = "right"},
    {map = "20973569", door = "471"},
    {map = "25692680", door = "492"},
    {map = "25691146", path = "top"},
    {map = "25691144", path = "257"},
    {map = "24118791", fight = true, path = "top"},
    {map = "24118790", fight = true, path = "left"},
    {map = "24118278", fight = true, path = "bottom"},

}

local ArbreHakam2 = {
    {map = "24118279", fight = true, path = "top"},
    {map = "24118278", fight = true, path = "left"},
    {map = "24117766", fight = true, path = "bottom"},
    {map = "24117767", fight = true, path = "434"},
    {map = "25691654", path = "top"},
    {map = "25691652", path = "top"},
    {map = "25691650", path = "540"},
    {map = "24117765", fight = true, path = "right"},
    {map = "24118277", fight = true, path = "right"},
    {map = "24118789", fight = true, door = "178"},
    {map = "24119314", fight = true, path = "left"},
    {map = "24118802", fight = true, door = "445"},
    {map = "25690624", path = "left"},
    {map = "25690112", path = "bottom"},
    {map = "24117761", fight = true, path = "right"},
    {map = "24118273", fight = true, path = "right"},
    {map = "24118785", fight = true, path = "bottom"},
    {map = "24118786", fight = true, path = "bottom"},
    {map = "24118787", fight = true, path = "left"},
    {map = "24118275", fight = true, path = "left"},
    {map = "24117763", fight = true, path = "top"},
    {map = "24117762", fight = true, path = "right"},
}

local ArbreHakam3 = {
    {map = "24118274", fight = true, path = "bottom"},
    {map = "24118275", fight = true, path = "524"},
    {map = "25694213", path = "havenbag"},
    {map = "0,0", path = "zaap(20973313)"},
    {map = "20973313", path = "bottom"},
    {map = "20973056", path = "bottom"},
    {map = "20973057", path = "right"},
    {map = "20973569", path = "right"},
    {map = "20974081", path = "top"},
    {map = "20974080", path = "253"},
    {map = "25690116", path = "338"},
    {map = "24118794", fight = true, path = "bottom"},
    {map = "24118795", fight = true, path = "539"},
    {map = "25694721", path = "left"},
    {map = "25694209", path = "left"},
    {map = "25693697", path = "top"},
    {map = "25693696", path = "318"},
    {map = "24117771", fight = true, path = "right"},
    {map = "24118283", fight = true, path = "top"},
    {map = "24118282", fight = true, path = "left"},
    {map = "24117770", fight = true, path = "top"},
    {map = "24117769", fight = true, path = "right"},
    {map = "24118281", fight = true, path = "right"},
    {map = "24118793", lockedCustom = function()
        message = developer:createMessage("SpellVariantActivationRequestMessage")
        message.spellId = 12761
        if global:isBoss() then
            local team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                if acc.character():level() > 154 then
                    acc.developer():sendMessage(message)
                end                
                global:delay(500)
                acc.map:door(135)
            end
            if character:level() > 154 then
                developer:sendMessage(message)
            end
            global:delay(500)
            map:door(135)
        end
        end},
}

local VillageZoth1 = {
    {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
    {map = "161220622", path = "top"},
    {map = "161220620", path = "right"},
    {map = "161221644", path = "top"},
    {map = "161220618", path = "left"},
    {map = "161219594", path = "top"},
    {map = "161219592", path = "left"},
    {map = "161218568", path = "top"},
    {map = "161350662", path = "top"},
    {map = "161350660", path = "left"},

    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right"},
    {map = "161357060", path = "right"},
    {map = "161356036", path = "top"},
    {map = "161356038", path = "right"},
    {map = "161355012", path = "bottom"},
    {map = "161355010", path = "right"},
    {map = "161353986", path = "right"},
    {map = "161352704", path = "right"},
    {map = "161351680", path = "bottom"},
    {map = "161350658", path = "right"},
    {map = "161218562", path = "right"},
    {map = "161219586", path = "bottom"},
    {map = "161219588", path = "bottom"},
    {map = "161220614", path = "bottom"},

    {map = "160959747", path = "left"},
    {map = "160959745", path = "left"},
    {map = "160958464", path = "left"},
    {map = "160957952", path = "left"},
    {map = "160957440", path = "left"},
    {map = "160956928", path = "top"},
    {map = "160956416", path = "right"},
    {map = "160956417", path = "right"},
    {map = "160956929", path = "top"},
    {map = "160956930", path = "top"},
    {map = "160956931", path = "top"},
    {map = "160957443", path = "top"},
    {map = "160957442", path = "top"},
    {map = "160957441", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957954", path = "top"},
    {map = "160957955", path = "top"},
    {map = "160958466", path = "top"},
    {map = "160958465", path = "top"},
    {map = "160957953", path = "top"},

    {map = "0,0", fight = true, path = "zaap(20973313)"},
    {map = "20973313", path = "top"},
    {map = "20973314", fight = true, path = "top"},
    {map = "20973315", fight = true, path = "top"},
    {map = "20973316", fight = true, path = "left"},
    {map = "20972804", fight = true, path = "left"},
    {map = "20972292", fight = true, path = "left"},
    {map = "20971780", fight = true, path = "bottom"},
    {map = "20971779", fight = true, path = "bottom"},
    {map = "20971778", fight = true, path = "bottom"},
    {map = "20971777", fight = true, path = "right"},
    {map = "20972289", fight = true, path = "right"},
}

local VillageZoth2 = {
    {map = "20972801", fight = true, path = "right"},
    {map = "20973313", fight = true, path = "bottom"},
    {map = "20973056", fight = true, path = "bottom"},
    {map = "20973057", fight = true, path = "left"},
    {map = "20972545", fight = true, path = "left"},
    {map = "20972033", fight = true, path = "left"},
    {map = "20971521", fight = true, path = "bottom"},
    {map = "20971522", fight = true, path = "bottom"},
    {map = "20971523", fight = true, path = "bottom"},
    {map = "20971524", fight = true, path = "right"},
    {map = "20972036", fight = true, path = "right"},
    {map = "20972548", fight = true, path = "right"},
    {map = "20973060", fight = true, path = "top"},
    {map = "20973059", fight = true, path = "top"},
}

local VillageZoth3 = {
    {map = "20973058", fight = true, path = "top"},
    {map = "20973057", fight = true, path = "right"},
    {map = "20973569", fight = true, path = "right"},
    {map = "20974081", fight = true, path = "right"},
    {map = "20974593", fight = true, path = "right"},
    {map = "20975105", fight = true, path = "right"},
    {map = "20975617", fight = true, path = "bottom"},
    {map = "20975618", fight = true, path = "bottom"},
    {map = "20975619", fight = true, path = "bottom"},
    {map = "20975620", fight = true, path = "left"},
    {map = "20975108", fight = true, path = "left"},
    {map = "20974596", fight = true, path = "left"},
    {map = "20974084", fight = true, path = "top"},
    {map = "20974083", fight = true, path = "top"},
}

local VillageZoth4 = {
    {map = "20974082", fight = true, path = "top"},
    {map = "20974081", fight = true, path = "top"},
    {map = "20974080", fight = true, path = "top"},
    {map = "20974337", fight = true, path = "top"},
    {map = "20974338", fight = true, path = "top"},
    {map = "20974339", fight = true, path = "top"},
    {map = "20974340", fight = true, path = "right"},
    {map = "20974852", fight = true, path = "right"},
    {map = "20975364", fight = true, path = "right"},
    {map = "20975876", fight = true, path = "bottom"},
    {map = "20975875", fight = true, path = "bottom"},
    {map = "20975874", fight = true, path = "bottom"},
    {map = "20975873", fight = true, path = "left"},
    {map = "20975361", fight = true, path = "left"},
}   

local PenatesCorbak = {
    {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
    {map = "161220622", path = "top"},
    {map = "161220620", path = "right"},
    {map = "161221644", path = "top"},
    {map = "161220618", path = "left"},
    {map = "161219594", path = "top"},
    {map = "161219592", path = "left"},
    {map = "161218568", path = "top"},
    {map = "161350662", path = "top"},
    {map = "161350660", path = "left"},

    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right"},
    {map = "161357060", path = "right"},
    {map = "161356036", path = "top"},
    {map = "161356038", path = "right"},
    {map = "161355012", path = "bottom"},
    {map = "161355010", path = "right"},
    {map = "161353986", path = "right"},
    {map = "161352704", path = "right"},
    {map = "161351680", path = "bottom"},
    {map = "161350658", path = "right"},
    {map = "161218562", path = "right"},
    {map = "161219586", path = "bottom"},
    {map = "161219588", path = "bottom"},
    {map = "161220614", path = "bottom"},

    {map = "160959747", path = "left"},
    {map = "160959745", path = "left"},
    {map = "160958464", path = "left"},
    {map = "160957952", path = "left"},
    {map = "160957440", path = "left"},
    {map = "160956928", path = "top"},
    {map = "160956416", path = "right"},
    {map = "160956417", path = "right"},
    {map = "160956929", path = "top"},
    {map = "160956930", path = "top"},
    {map = "160956931", path = "top"},
    {map = "160957443", path = "top"},
    {map = "160957442", path = "top"},
    {map = "160957441", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957954", path = "top"},
    {map = "160957955", path = "top"},
    {map = "160958466", path = "top"},
    {map = "160958465", path = "top"},
    {map = "160957953", path = "top"},

    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "top"},
    {map = "-17,-48", path = "top"},
    {map = "-17,-49", path = "top"},
    {map = "-17,-50", path = "top"},
    {map = "-17,-51", path = "top"},
    {map = "-17,-52", path = "top"},
    {map = "-17,-53", path = "top"},
    {map = "-17,-54", path = "top"},
    {map = "-17,-55", path = "top"},
    {map = "-17,-56", path = "top"},
    {map = "-17,-57", path = "top"},
    {map = "-17,-58", path = "top"},
    {map = "-17,-59", path = "top"},
    {map = "-17,-60", path = "right"},
    {map = "-16,-60", path = "right"},
    {map = "-15,-60", path = "right", fight = true},
    {map = "-14,-60", path = "right", fight = true},
    {map = "-13,-60", path = "right", fight = true},
    {map = "-12,-60", path = "right", fight = true},
    {map = "-11,-60", path = "top", fight = true},
    {map = "-15,-61", path = "top", fight = true},
    {map = "-11,-61", path = "left", fight = true},
    {map = "-12,-61", path = "left", fight = true},
    {map = "-13,-61", path = "left", fight = true},
    {map = "-14,-61", path = "left", fight = true},
    {map = "-15,-62", path = "right", fight = true},
    {map = "-14,-62", path = "right", fight = true},
    {map = "-13,-62", path = "right", fight = true},
    {map = "-12,-62", path = "right", fight = true},
}

local Grobe1 = {
    {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
    {map = "161220622", path = "top"},
    {map = "161220620", path = "right"},
    {map = "161221644", path = "top"},
    {map = "161220618", path = "left"},
    {map = "161219594", path = "top"},
    {map = "161219592", path = "left"},
    {map = "161218568", path = "top"},
    {map = "161350662", path = "top"},
    {map = "161350660", path = "left"},

    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right"},
    {map = "161357060", path = "right"},
    {map = "161356036", path = "top"},
    {map = "161356038", path = "right"},
    {map = "161355012", path = "bottom"},
    {map = "161355010", path = "right"},
    {map = "161353986", path = "right"},
    {map = "161352704", path = "right"},
    {map = "161351680", path = "bottom"},
    {map = "161350658", path = "right"},
    {map = "161218562", path = "right"},
    {map = "161219586", path = "bottom"},
    {map = "161219588", path = "bottom"},
    {map = "161220614", path = "bottom"},

    {map = "160959747", path = "left"},
    {map = "160959745", path = "left"},
    {map = "160958464", path = "left"},
    {map = "160957952", path = "left"},
    {map = "160957440", path = "left"},
    {map = "160956928", path = "top"},
    {map = "160956416", path = "right"},
    {map = "160956417", path = "right"},
    {map = "160956929", path = "top"},
    {map = "160956930", path = "top"},
    {map = "160956931", path = "top"},
    {map = "160957443", path = "top"},
    {map = "160957442", path = "top"},
    {map = "160957441", path = "top"},
    {map = "160957953", path = "top"},
    {map = "160957954", path = "top"},
    {map = "160957955", path = "top"},
    {map = "160958466", path = "top"},
    {map = "160958465", path = "top"},
    {map = "160957953", path = "top"},

    {map = "0,0", path = "zaap(207619076)"},
	{map = "207619076", path ="436"},
	{map = "206307842",path = "right" },
    {map = "21,-29", path = "right"},
    {map = "22,-29", path = "right"},
    {map = "23,-29", path = "right"},
    {map = "24,-29", path = "bottom"},
    {map = "24,-28", path = "bottom"},
    {map = "24,-27", path = "right"},
    {map = "25,-27", path = "right"},
    {map = "26,-27", path = "right"},
    {map = "27,-27", lockedCustom = function() 
        if global:isBoss() then
            for _, acc in ipairs(TeamAcount) do
                acc.npc():npc(4102, 3) 
                acc.npc():reply(-1)
            end
            npc:npc(4102, 3) 
            npc:reply(-1)
        end
        end},
    {map = "34,-40", fight = true, path = "left"},
    {map = "33,-40", fight = true, path = "top"},
    {map = "33,-41", fight = true, path = "top"},
    {map = "33,-42", fight = true, path = "top"},
    {map = "33,-43", fight = true, path = "right"},
    {map = "34,-43", fight = true, path = "bottom"},
    {map = "34,-42", fight = true, path = "bottom"},
    {map = "34,-41", fight = true, path = "right"},
    {map = "35,-41", fight = true, path = "bottom"},
    {map = "35,-40", fight = true, path = "right"},
    {map = "36,-40", fight = true, path = "right"},
    {map = "37,-40", fight = true, path = "top"},
    {map = "37,-41", fight = true, path = "top"},
    {map = "38,-41", fight = true, path = "top"},
    {map = "37,-42", fight = true, path = "left"},
    {map = "36,-42", fight = true, path = "left"},
    {map = "35,-42", fight = true, path = "top"},
    {map = "35,-43", fight = true, path = "top"},
    {map = "35,-44", fight = true, path = "right"},
    {map = "36,-44", fight = true, path = "bottom"},
    {map = "36,-43", fight = true, path = "right"},
    {map = "37,-43", fight = true, path = "top"},
    {map = "37,-44", fight = true, door = "275"},
}

local Grobe2 = {
    {map = "0,0", path = "zaap(207619076)"},
	{map = "207619076", path ="436"},
	{map = "206307842",path = "right" },
    {map = "21,-29", path = "right"},
    {map = "22,-29", path = "right"},
    {map = "23,-29", path = "right"},
    {map = "24,-29", path = "bottom"},
    {map = "24,-28", path = "bottom"},
    {map = "24,-27", path = "right"},
    {map = "25,-27", path = "right"},
    {map = "26,-27", path = "right"},
    {map = "27,-27", lockedCustom = function() 
        if global:isBoss() then
            for _, acc in ipairs(TeamAcount) do
                acc.npc():npc(4102, 3) 
                acc.npc():reply(-1)
            end
            npc:npc(4102, 3) 
            npc:reply(-1)
        end
        end},
    {map = "34,-40", path = "right"},
    {map = "35,-40", path = "right"},
    {map = "36,-40", path = "right"},
    {map = "37,-40", path = "top"},
    {map = "37,-41", path = "left"},
    {map = "36,-41", path = "top"},
    {map = "36,-42", path = "top"},
    {map = "36,-43", path = "right"},
    {map = "37,-43", path = "top"},
    {map = "37,-44", fight = true, door = "275"},
    {map = "37,-45", fight = true, path = "right"},
    {map = "38,-45", fight = true, path = "bottom"},
    {map = "38,-44", fight = true, path = "bottom"},
    {map = "38,-43", fight = true, path = "right"},
    {map = "39,-43", fight = true, path = "bottom"},
    {map = "39,-42", fight = true, path = "right"},
    {map = "40,-42", fight = true, path = "top"},
    {map = "40,-43", fight = true, path = "top"},
    {map = "40,-44", fight = true, path = "top"},
    {map = "40,-45", fight = true, path = "left"},
}

local Grobe3 = {
    {map = "38,-45", path = "top", fight = true},
    {map = "39,-45", path = "left", fight = true},
    {map = "38,-46", path = "left", fight = true},
    {map = "37,-46", path = "top", fight = true},
    {map = "37,-47", path = "left", fight = true},
    {map = "36,-47", path = "bottom", fight = true},
    {map = "36,-46", path = "left", fight = true},
    {map = "35,-46", path = "bottom", fight = true},
    {map = "35,-45", path = "bottom", fight = true},
}

local Ecaflipusbl1 = {
    
    {map = "161351684", path = "right"},
    {map = "161350660", path = "top", fight = true},
    {map = "161350658", path = "top", fight = true},
    {map = "161351680", path = "left", fight = true},
    {map = "161352704", path = "left", fight = true},
    {map = "161353986", path = "left", fight = true},
    {map = "161355010", path = "top", fight = true},
    {map = "161355012", path = "left", fight = true},
    {map = "161356038", path = "bottom", fight = true},
    {map = "161356036", path = "left", fight = true},
    {map = "161357060", path = "left", fight = true},
    {map = "161358084", path = "left", fight = true},
}

local Ecaflipusbl2 = {
    {map = "161480704", path = "bottom"},
    {map = "161358084", path = "right", fight = true},
    {map = "161357060", path = "right", fight = true},
    {map = "161356036", path = "top", fight = true},
    {map = "161356038", path = "right", fight = true},
    {map = "161355012", path = "bottom", fight = true},
    {map = "161355010", path = "right", fight = true},
    {map = "161353986", path = "right", fight = true},
    {map = "161352704", path = "right", fight = true},
    {map = "161351680", path = "bottom", fight = true},
    {map = "161350658", path = "right", fight = true},
    {map = "161218562", path = "right", fight = true},
    {map = "161219586", path = "bottom", fight = true},
    {map = "161219588", path = "bottom", fight = true},
    {map = "161220614", path = "bottom", fight = true},
    {map = "161219592", path = "bottom", fight = true},
    {map = "161219594", path = "right", fight = true},
    {map = "161220618", path = "bottom", fight = true},
    {map = "161221644", path = "left", fight = true},
    {map = "161220620", path = "bottom", fight = true},
}

local Ecaflipusbl3 = {
    {map = "161220622", path = "top", fight = true},
    {map = "161220620", path = "right", fight = true},
    {map = "161221644", path = "top", fight = true},
    {map = "161220618", path = "left", fight = true},
    {map = "161219594", path = "top", fight = true},
    {map = "161219592", path = "left", fight = true},
    {map = "161218568", path = "top", fight = true},
    {map = "161350662", path = "top", fight = true},
    {map = "161350660", path = "left", fight = true},
}

local Ecaflipushl1 = {
    {map = "161351684", path = "right"},
    {map = "161350660", path = "bottom"},
    {map = "161350662", path = "bottom"},
    {map = "161218568", path = "right"},
    {map = "161219592", path = "bottom"},
    {map = "161219594", path = "right"},
    {map = "161220618", path = "bottom"},
    {map = "161221644", path = "left"},
    {map = "161220620", path = "bottom"},
    {map = "161220622", path = "bottom"},
    {map = "160956928", path = "left", fight = true},
    {map = "160956416", path = "bottom", fight = true},
    {map = "160956417", path = "right", fight = true},
    {map = "160956929", path = "bottom", fight = true},
    {map = "160956930", path = "bottom", fight = true},
    {map = "160956931", path = "right", fight = true},
    {map = "160957443", path = "top", fight = true},
    {map = "160957442", path = "top", fight = true},
    {map = "160957441", path = "top", fight = true},
    {map = "160957440", path = "right", fight = true},
    {map = "160957952", path = "bottom", fight = true},
    {map = "160957953", path = "bottom", fight = true},
    {map = "160957954", path = "right", fight = true},
    {map = "160958466", path = "top", fight = true},
    {map = "160958465", path = "top", fight = true},
    {map = "160958464", path = "right", fight = true},
    {map = "160959745", path = "right", fight = true},
}

local TableArea = {
    {Zone = {
        {ArbreHakam1, "24118279", false}, {ArbreHakam2, "24118274", false}, {ArbreHakam3, "25690115", false},
    }, MaxMonster = (lenghtTeam == 2) and 5 or (lenghtTeam == 3) and 6 or 8, MinMonster = (lenghtTeam < 4) and 1 or 3, ListeVenteId = {8797, 8796, 8788, 8792, 8832, 8793, 8790, 8791, 8787, 8786}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
    {Zone = {
        {VillageZoth1, "20972801", false}, {VillageZoth2, "20973058", false}, --{VillageZoth3, "20974082", false}, --{VillageZoth4, "20974849", false},
    }, MaxMonster = (lenghtTeam == 3) and 7 or (lenghtTeam == 2) and 6 or 8, MinMonster = (lenghtTeam == 3) and 3 or (lenghtTeam == 2) and 2 or 4, ListeVenteId = {8800, 8803, 929, 8805, 8802, 8804, 8806}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
    {Zone = {
        {PenatesCorbak, "-11,-62", false},
    }, MaxMonster = 8, MinMonster = 4, ListeVenteId = {8249, 7024, 8249, 2060, 2059, 8250, 8816, 7006}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
    {Zone = {
        {Ecaflipusbl1, "161480704", false}, {Ecaflipusbl2, "161220622", false}, {Ecaflipusbl3, "161351684", false},
    }, MaxMonster = (lenghtTeam == 2) and 6 or 8, MinMonster = (lenghtTeam == 2) and 2 or 3, ListeVenteId = {17612, 17567, 17610, 17611, 17609}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},
    {Zone = {
        {Ecaflipushl1, "160959747", false}
    }, MaxMonster = 2, MinMonster = 1, ListeVenteId = {17616, 17567, 17617, 17618, 17615}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},
    --[[    {Zone = {
        {Grobe2, "39,-45", false}, {Grobe3, "35,-44", false}, 
    }, MaxMonster = (lenghtTeam < 4) and 2 or 3, MinMonster = 1, ListeVenteId = {7408, 7383, 7381, 7403, 7410}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},]]
    {Zone = {
        {Grobe1, "37,-45", false},
    }, MaxMonster = (lenghtTeam < 4) and 2 or 4, MinMonster = 1, ListeVenteId = {7404, 7379, 7405, 7407, 7384}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
}

if global:thisAccountController():getAlias():find("Groupe ") then
    TableArea = {
        {Zone = {
            {ArbreHakam1, "24118279", false}, {ArbreHakam2, "24118274", false}, {ArbreHakam3, "25690115", false},
        }, MaxMonster = (lenghtTeam == 2) and 5 or (lenghtTeam == 3) and 6 or 8, MinMonster = (lenghtTeam < 4) and 1 or 3, ListeVenteId = {8797, 8796, 8788, 8792, 8832, 8793, 8790, 8791, 8787, 8786}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
        {Zone = {
            {VillageZoth1, "20972801", false}, {VillageZoth2, "20973058", false}, --{VillageZoth3, "20974082", false}, --{VillageZoth4, "20974849", false},
        }, MaxMonster = (lenghtTeam == 3) and 7 or (lenghtTeam == 2) and 6 or 8, MinMonster = (lenghtTeam == 3) and 3 or (lenghtTeam == 2) and 2 or 4, ListeVenteId = {8800, 8803, 929, 8805, 8802, 8804, 8806}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
        {Zone = {
            {PenatesCorbak, "-11,-62", false},
        }, MaxMonster = 8, MinMonster = 4, ListeVenteId = {8249, 7024, 8249, 2060, 2059, 8250, 8816, 7006}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
        -- {Zone = {
        --     {Ecaflipusbl1, "161480704", false}, {Ecaflipusbl2, "161220622", false}, {Ecaflipusbl3, "161351684", false},
        -- }, MaxMonster = (lenghtTeam == 2) and 6 or 8, MinMonster = (lenghtTeam == 2) and 2 or 3, ListeVenteId = {17612, 17567, 17610, 17611, 17609}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},
        -- {Zone = {
        --     {Ecaflipushl1, "160959747", false}
        -- }, MaxMonster = 2, MinMonster = 1, ListeVenteId = {17616, 17567, 17617, 17618, 17615}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},
        --[[    {Zone = {
            {Grobe2, "39,-45", false}, {Grobe3, "35,-44", false}, 
        }, MaxMonster = (lenghtTeam < 4) and 2 or 3, MinMonster = 1, ListeVenteId = {7408, 7383, 7381, 7403, 7410}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = true},]]
        {Zone = {
            {Grobe1, "37,-45", false},
        }, MaxMonster = (lenghtTeam < 4) and 2 or 4, MinMonster = 1, ListeVenteId = {7404, 7379, 7405, 7407, 7384}, Farmer = false, PourcentageHdv = 0, Stop = false, Ecaflipus = false},
    }
end

--- </init>


local TableVente = {
    {Name = "Souche de l'Abrakleur clair", id = 8797, maxHdv100 = 10, maxHdv10 = 20, maxHdv1 = 10, canSell = true},
    {Name = "Nœud de l'Abrakleur clair", id = 8796, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Croupion du Bitouf aérien", id = 8788, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Coco du Bitouf aérien", id = 8792, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Bave du Kaskargo", id = 8832, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Coquille du Kaskargo", id = 8793, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Rembourrage de Meupette", id = 8790, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Étoffe de Meupette", id = 8791, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Cloaque du Poolay", id = 8787, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Tresse du Poolay", id = 8786, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},

    {Name = "Étoffe Zoth", id = 8800, maxHdv100 = 10, maxHdv10 = 10, maxHdv1 = 5, canSell = true},
    {Name = "Rotule du Disciple Zoth", id = 8803, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Kristalite", id = 929, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Mouchoir de la Gamine Zoth", id = 8805, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Tibia du Guerrier Zoth", id = 8802, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Braguette du Maître Zoth", id = 8804, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Écusson du Sergent Zoth", id = 8806, maxHdv100 = 2, maxHdv10 = 8, maxHdv1 = 5, canSell = true},

    {Name = "Plume de Buveur", id = 8249, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Coeur de Buveur", id = 2493, maxHdv100 = 3, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Pierre de Topaze", id = 7024, maxHdv100 = 3, maxHdv10 = 14, maxHdv1 = 3, canSell = true},
    {Name = "Plume de Buveur", id = 8249, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 5, canSell = true},
    {Name = "Patte de Corbac", id = 2060, maxHdv100 = 2, maxHdv10 = 10, maxHdv1 = 3, canSell = true},
    {Name = "Corbac Mort", id = 2059, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, canSell = true},
    {Name = "Plume de Renarbo", id = 8250, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 5, canSell = true},
    {Name = "Plume Pointue de Renarbo", id = 1670, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 4, canSell = true},

    {Name = "Os de Jiangshi-Nobi", id = 7404, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
    {Name = "Fleur d'Onabu-Geisha", id = 7379, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
    {Name = "Plastron de Tambouraï", id = 7405, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
    {Name = "Croissant de Tsukinochi", id = 7407, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true},
    {Name = "Étoffe de Samouraï fantôme", id = 7384, maxHdv100 = 2, maxHdv10 = 10, maxHdv1 = 3, canSell = true},

    {Name = "Kapokaza", id = 7408, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 0, canSell = true},
    {Name = "Yokayu", id = 7383, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 3, canSell = true},
    {Name = "Kaokurimono", id = 7381, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true},
    {Name = "Œil de Madura", id = 7403, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true},
    {Name = "Lanterne usée", id = 7410, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true},

    {Name = "Peau de Gériatique", id = 17612, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
    {Name = "Biscuit de chance", id = 17567, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
    {Name = "Œil de Morcac", id = 17610, maxHdv100 = 4, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
    {Name = "Palpe de Pikbul", id = 17611, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 5, canSell = true},
    {Name = "Patte de Pupuce", id = 17609, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 5, canSell = true},

    {Name = "Poil de Chacrebleu", id = 17616, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Biscuit de chance", id = 17567, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 5, canSell = true},
    {Name = "Collier de Chakichan", id = 17617, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Oreille de Chargus", id = 17618, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 5, canSell = true},
    {Name = "Queue de Chasquatch", id = 17615, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 5, canSell = true},

}

local hdv_door_id = 218

local NeedToReturnBank = false
local NeedToSell = false

local cptActualiser = 1
local hdvActualise = false


local hdvFull = false
local checkHdv = false
local DebutDuScript = true

--- <parameters>

local receiverAlias = "bank"
-- Montant de kamas que le bot farm devra garder 

local minKamas = nil

-- Montant de kamas qui déclenchera le transfert au bot bank
local givingTriggerValue = 2500000

-- Temps d'attente maximal de la connexion du bot bank (en secondes)
local maxWaitingTime = 120

-- Temps d'attente avant de réessayer de connecter le bot bank (en heures)
local minRetryHours = 6


--- </parameters>


--- <variables>

local toGive = 0
local retryTimestamp = 0
local server = character:server():lower()

local bankMaps = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

--- </variables>




--- </functions>


local function secondsToHours(time)
    return time / 60 / 60
end

string.split = function(self, sep, rawSep)
    local insert, result = table.insert, {}
    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end

    local rawSep = rawSep and sep or "([^" .. sep .. "]+)"

    for match in self:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

function UsePortail()
    global:printSuccess("Utilisation portail")
    monMessage = developer:createMessage("PortalUseRequestMessage")
    monMessage.portalId = 9 -- ça varie
    developer:sendMessage(monMessage)
    global:delay(2000)
    if getCurrentAreaName() ~= "Ecaflipus" then
        failPortail = true
        global:addInMemory("retryPortail", os.time())


        global:printSuccess("portail pas trouvé!")
        map:changeMap("havenbag")
    end
end



local function getmapIdPortal(dimension, server)
    local resRequest = developer:getRequest("https://www.ankabot.dev/API/Portal.php?key=dfeeef40eab189e39961f435414dbe6f&serveur="..server.."&portal="..dimension)

    local toReturn = resRequest:split("|")
    return toReturn[2]
end


local function connectReceiver()
    if global:isBoss() then
        global:printSuccess("Connexion du bot banque")

        for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
            if acc:getAlias():find(receiverAlias .. "_" .. server) then
                if not acc:isAccountConnected() then
                    acc:connect()
    
                    local safetyCount = 0
                    while not acc:isAccountFullyConnected() do
                        safetyCount = safetyCount + 1
    
                        if safetyCount == 1 then
                            global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                        end
    
                        global:delay(1000)
    
                        if safetyCount >= maxWaitingTime then
                            global:printError("Bot banque non-connecté après " .. maxWaitingTime .. " secondes, reprise du trajet")

                            if global:isBoss() then
                                TeamAcount = global:thisAccountController():getTeamAccounts()
                                for _, acc in ipairs(TeamAcount) do
                                    acc.global():deleteMemory("cannotConnect")
                                    acc.global():addInMemory("cannotConnect", true)
                                end
                                global:deleteMemory("cannotConnect")
                                global:addInMemory("cannotConnect", true)
                            end
                                
                            return acc
                        end
                    end
                    acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml")
                    acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\bot_banque.lua")
                    acc:startScript()
                    givingTriggerValue = givingTriggerValue - 50000
                    return acc
                else
                    return acc
                end
            end
        end
    end
end

local function rerollVar()
    if global:remember("failed") and global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("failed")
        end
        global:deleteMemory("failed")
    end


    toGive, connected, movingPrinted, givingMode = 0, nil, nil, nil
end

local function launchExchangeAndGive()
    local id = receiver.character():id()

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)
    if global:isBoss() then
        receiver:exchangeListen(false)
        receiver:exchangeListen(true)
        while not exchange:launchExchangeWithPlayer(id) do
            global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
            global:delay(5000)
        end
    
        toGive = character:kamas() - minKamas
    
        if toGive > 0 then
            exchange:putKamas(toGive)
        end
        exchange:ready()
    
        global:delay(3000)
    
        global:printSuccess("Kamas transférés. Reprise du trajet")
        global:delay(5000)
        receiver:reloadScript()
        receiver:startScript()
        global:delay(10000)
        receiver:disconnect()
        global:restartScript(true)
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteAllMemory()
        end
        global:deleteAllMemory()
        rerollVar()
    end

end

local function goAstrubBank(inBankCallback)
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end

    if not getCurrentAreaName():find("Astrub") then
        if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
            if global:isBoss() then
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:changeMap(bankMaps.zAstrub)
                end
                map:changeMap(bankMaps.zAstrub)
            end
        else
            if global:isBoss() then
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:changeMap("havenbag")
                end
                map:changeMap("havenbag")
            end
        end
    else
        if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
            if global:isBoss() then
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:moveToward(tonumber(bankMaps.bankAstrubInt))
                end
                map:moveToward(tonumber(bankMaps.bankAstrubInt))
            end
        else
            if inBankCallback then
                return inBankCallback()
            end
        end
    end
end

local function secondsToHours(time)
    return time / 60 / 60
end

local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end

local function CheckEndFight(message)
    global:printSuccess("aaaa")
    if lenghtTeam == 5 then
        if not message.results[1].alive and not message.results[2].alive and not message.results[3].alive and not message.results[4].alive and not  message.results[5].alive then
            message = developer:createMessage("SpellVariantActivationRequestMessage")
            message.spellId = 12761
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    if acc.character():level() > 154 then
                        acc.developer():sendMessage(message)
                    end               
                end
                if character:level() > 154 then
                    developer:sendMessage(message)
                end
            end

            CompteurDeath = CompteurDeath + 1
    
            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    if CompteurDeath < 2 then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
    elseif lenghtTeam == 4 then
        if not message.results[1].alive and not message.results[2].alive and not message.results[3].alive and not message.results[4].alive then
            message = developer:createMessage("SpellVariantActivationRequestMessage")
            message.spellId = 12761
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    if acc.character():level() > 154 then
                        acc.developer():sendMessage(message)
                    end                end
                if character:level() > 154 then
                    developer:sendMessage(message)
                end            
            end

            CompteurDeath = CompteurDeath + 1
    
            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    if CompteurDeath < 2 then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
    elseif lenghtTeam == 3 then
        if not message.results[1].alive and not message.results[2].alive and not message.results[3].alive then
            global:printSuccess("ok1")

            message = developer:createMessage("SpellVariantActivationRequestMessage")
            message.spellId = 12761
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    if acc.character():level() > 154 then
                        acc.developer():sendMessage(message)
                    end                end
                if character:level() > 154 then
                    developer:sendMessage(message)
                end
            end
            CompteurDeath = CompteurDeath + 1
            global:printSuccess("ok2")

            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    global:printSuccess("ok3")
                    if CompteurDeath < 2 then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
    elseif lenghtTeam == 2 then
        if not message.results[1].alive and not message.results[2].alive then
            global:printSuccess("ok1")

            message = developer:createMessage("SpellVariantActivationRequestMessage")
            message.spellId = 12761
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    if acc.character():level() > 154 then
                        acc.developer():sendMessage(message)
                    end                end
                if character:level() > 154 then
                    developer:sendMessage(message)
                end
            end
            CompteurDeath = CompteurDeath + 1
            global:printSuccess("ok2")

            for i, element in ipairs(TableArea) do
                if element.Farmer then
                    global:printSuccess("ok3")
                    if CompteurDeath < ((element.ListeVenteId[1] == 8797) and 3 or 2) then
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on continue de la farm")
                        for index, element2 in ipairs(element.Zone) do
                            element2[3] = (index == 1)
                        end
                        for index, element2 in ipairs(element.Zone) do
                            global:printSuccess(element2[3])
                        end
                    else
                        global:printSuccess(CompteurDeath .. " ème fois qu'on perd un combat dans cette zone, on farm la suivante")
                        for index, element2 in ipairs(TableArea) do
                            if not TableArea[IncrementTable(i + index - 1, #TableArea)].Stop then
                                global:printSuccess(IncrementTable(i + index - 1, #TableArea) .. " ème zone")
                                element.Farmer = false
                                TableArea[IncrementTable(i + index - 1, #TableArea)].Farmer = true
                                for index2, element3 in ipairs(TableArea[IncrementTable(i + index - 1, #TableArea)].Zone) do
                                    element3[3] = (index2 == 1)
                                end
                                break
                            end
                        end
                        CompteurDeath = 0
                    end
                    break
                end
            end
        end
        
    end
end

local function isWhitelisted(id)
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

local function _ExchangeRequestedTradeMessage(message)
    if not global:isBoss() then
        global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
        developer:sendMessage(developer:createMessage("ExchangeAcceptMessage"))
        global:delay(1000)
    
        local toGive = (getRemainingSubscription(true) <= 5) and (character:kamas() - 1200000) or (character:kamas() - 400000)
        -- Put kamas
        if toGive > 0 then
            global:printSuccess("Je mets dans l'échange ".. toGive .." kamas.")
            exchange:putKamas(toGive)
        end
    
        global:printSuccess("je mets les ressources")
    
        exchange:putAllItems()
    
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

local function MoveToAnotherCell(message)
    map:moveToCell(math.random(0, 559))
end

local function Stop()
    if global:isBoss() and not global:thisAccountController():isScriptPlaying() then
        global:thisAccountController():startScript()
    end
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
    developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
    --developer:registerMessage("ChatServerMessage", Stop)
    --developer:registerMessage("BasicNoOperationMessage", MoveToAnotherCell)
end


local function antiModo()
    if global:isModeratorPresent(30) then
        timerdisconnect = math.random(30000, 36000) 

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                if not acc.map:onMap("0,0") then
                    acc.map:changeMap("havenbag")
                end
            end
            if not map:onMap("0,0") then
                map:changeMap("havenbag")
            end        
        end

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 2000 .. " secondes")

        if global:thisAccountController():getAlias():find("Groupe2") then
            global:editAlias("Groupe2 " .. character:server() .. " [MODO]", true)
        elseif global:thisAccountController():getAlias():find("Groupe3")  then
            global:editAlias("Groupe3 " .. character:server() .. " [MODO]", true)
        else
            global:editAlias("Groupe " .. character:server() .. " [MODO]", true)
        end
        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global():reconnectBis(timerdisconnect / 2000)
            end
            global:reconnectBis((timerdisconnect + 10) / 1000)
        end
    end
end

local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID
    developer:sendMessage(message)
end

local function CheckOrnement()
    local TableOrnementLvl ={
        {Lvl = 525, Id = 120},
        {Lvl = 475, Id = 119},
        {Lvl = 450, Id = 118},
        {Lvl = 425, Id = 117},
        {Lvl = 375, Id = 116},
        {Lvl = 350, Id = 115},
        {Lvl = 325, Id = 114},
        {Lvl = 275, Id = 113},
        {Lvl = 250, Id = 112},
        {Lvl = 225, Id = 111},
    }

    for _, element in ipairs(TableOrnementLvl) do
        if character:level() >= element.Lvl then
            settOrnament(element.Id)
            break
        end
    end
end

function ProcessSell()
    NeedToSell = false
    if not DebutDuScript then
        NeedToReturnBank = true
    end

    if mount:hasMount() and not StopAchatGoujon then
        local myMount = mount:myMount()
        if (myMount.energyMax - myMount.energy) > 1000 then
            local index = 0
            local minPrice = 500000000
            local TableAchat = {
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
        
            npc:npc(333, 5)
        
            global:printSuccess("Check du meilleur prix")
        
            for i, element in ipairs(TableAchat) do
                local Price = sale:getPriceItem(element.Id, 3)
                if Price ~= nil and Price ~= 0 and Price < minPrice then
                    minPrice = Price
                    index = i
                end
            end
        
            global:leaveDialog()
        
            global:delay(500)
        
            if  minPrice < 6000 then
                local myMount1 = mount:myMount()
                while (myMount1.energyMax - myMount1.energy) > 1000 and character:kamas() > 10000 and (inventory:podsMax() - inventory:pods()) > 200 do
                    npc:npc(333, 6)
                    sale:buyItem(TableAchat[index].Id, 100, 10000)
                    global:leaveDialog()
                    mount:feedMount(TableAchat[index].Id, 100)
                    myMount1 = mount:myMount()
                end
                    global:printSuccess("DD nourrie")
            else
                global:printSuccess("les prix sont trop cher, on a pas pu acheter")
            end
        end	
        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end

    if (inventory:itemCount(14966) == 0) then
        HdvBuy()
        sale:buyItem(14966, 1, 1000000)
        global:leaveDialog()
        inventory:equipItem(14966, 28)
    end


    if not DebutDuScript then
        if global:isBoss() then
            table.sort(TableVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)

            HdvSell()
            -- vente par 100, 10 des récoles alchimiste
            local indexSuivant = 0

            for i, element in ipairs(TableVente) do
                if inventory:itemCount(element.id) == 0 then 
                    indexSuivant = i
                    global:printSuccess("on a plus rien à vendre") 
                    break 
                end

                local itemSold = false

                cpt = get_quantity(element.id).quantity["100"]
                local Priceitem = sale:getPriceItem(element.id, 3)
                while inventory:itemCount(element.id) >= 100 and sale:availableSpace() > 0 and cpt < element.maxHdv100 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.id, 3) * 1.5 or Priceitem
                    sale:SellItem(element.id, 100, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                    itemSold = true
                end
                element.remaining100 = element.maxHdv100 - cpt

                cpt = get_quantity(element.id).quantity["10"]
                local Priceitem = sale:getPriceItem(element.id, 2)
                while inventory:itemCount(element.id) >= 10 and sale:availableSpace() > 0 and cpt < element.maxHdv10 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.id, 2) * 1.5 or Priceitem
                    sale:SellItem(element.id, 10, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(element.id) .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                    itemSold = true
                end
                element.remaining10 = element.maxHdv10 - cpt

                cpt = get_quantity(element.id).quantity["1"]
                local Priceitem = sale:getPriceItem(element.id, 1)
                while inventory:itemCount(element.id) >= 1 and sale:availableSpace() > 0 and cpt < element.maxHdv1 do 
                    Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.id, 1) * 1.5 or Priceitem
                    element.maxHdv1 =  (Priceitem < 100) and 0 or element.maxHdv1
                    sale:SellItem(element.id, 1, Priceitem - 1) 
                    global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.id)  .. " à " .. Priceitem - 1 .. "kamas")
                    cpt = cpt + 1
                    itemSold = true
                end
                element.remaining1 = element.maxHdv1 - cpt

                if itemSold then
                    randomDelay()
                end
            end

            for i = indexSuivant, #TableVente do
                TableVente[i].remaining100 = TableVente[i].maxHdv100 - get_quantity(TableVente[i].id).quantity["100"]
                TableVente[i].remaining10 = TableVente[i].maxHdv10 - get_quantity(TableVente[i].id).quantity["10"]
                TableVente[i].remaining1 = TableVente[i].maxHdv1 - get_quantity(TableVente[i].id).quantity["1"]
            end
    
            if cptActualiser >= 2 and not hdvActualise and character:kamas() > 150000 then
                global:printSuccess("Actualisation des prix")
                hdvActualise = true
                cptActualiser = 0
                sale:updateAllItems()
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
            global:delay(500)
        end
    end

    if global:isBoss() then
        HdvSell()
        -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
        for _, element in ipairs(TableVente) do
            if get_quantity(element.id).quantity["100"] >= element.maxHdv100 and get_quantity(element.id).quantity["10"] >= element.maxHdv10 and get_quantity(element.id).quantity["1"] >= element.maxHdv1 then
                element.canSell = false
            else
                element.canSell = true
            end
        end
        for i, element in ipairs(TableArea) do
            local compteur = 0
            for _, element2 in ipairs(element.ListeVenteId) do
                for _, element3 in ipairs(TableVente) do -- trouve l'id dans la tableVente
                    if element2 == element3.id then
                        element.PourcentageHdv = element.PourcentageHdv + (get_quantity(element2).total_lots / (element3.maxHdv100 + element3.maxHdv10 + element3.maxHdv1))
                        compteur = compteur + 1
                    end
                end
            end
            element.PourcentageHdv = math.floor(element.PourcentageHdv * 100 / compteur)		
            global:printSuccess(element.PourcentageHdv)
            element.Stop = element.PourcentageHdv >= 85
        end
    
        global:leaveDialog()
    
        table.sort(TableArea, function(a1, a2) return a1.PourcentageHdv < a2.PourcentageHdv end)
    end

    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("TableArea")
            acc.global():addInMemory("TableArea", TableArea)
        end
        global:deleteMemory("TableArea")
        global:addInMemory("TableArea", TableArea)
    end

    TableArea = global:remember("TableArea")

    inventory:equipItem(14966, 28)
    message = developer:createMessage("SpellVariantActivationRequestMessage")
    message.spellId = 12761
    if global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            if acc.character():level() > 154 then
                acc.developer():sendMessage(message)
            end
        end
        if character:level() > 154 then
            developer:sendMessage(message)
        end
    end
    --if not global:isBoss() then
        for _, element in ipairs(TableArea) do
            global:printSuccess(element.PourcentageHdv)
        end
    --end
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

    tradeDone = false
    if not tradeDone and global:isBoss() and not map:onMap("0,0") then   

        IdsAvailable = global:getTeamMembersIds()

        TeamAcount = global:thisAccountController():getTeamAccounts()

        tradeDone = true

        for _, acc in ipairs(TeamAcount) do
            if not acc.map:onMap(map:currentMapId()) then
                tradeDone = false
                break
            end
            if acc.inventory():podsP() > 5 then
                acc.global():setPrivate(false)
                while not exchange:launchExchangeWithPlayer(acc.character():id()) do
                    global:printMessage("Attente de l'acceptation de l'échange (1 secondes)")
                    global:delay(1000)
                end
    
                local kamasToGive = 1200000 - acc.character():kamas()
                local tableAlias = acc:getAlias():split(" ")
                local nbDaysRemaining = tonumber(tableAlias[#tableAlias])
            
                if kamasToGive > 0 and character:kamas() > kamasToGive * 1.1 and nbDaysRemaining < 3 then
                    global:printSuccess("je donne " .. kamasToGive .. " à la mule " .. acc:getAlias())
                    exchange:putKamas(kamasToGive)
                end
                developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
                exchange:ready()
    
                acc.global():setPrivate(true)
            end
        end
    end

    DebutDuScript = false

    global:printSuccess("Actualisaton de l'ornement")
    global:delay(500)
    CheckOrnement()
    global:delay(500)

	map:changeMap("top")
end

local function CheckOrnement()

    local TableOrnementLvl ={
        {Lvl = 525, Id = 120},
        {Lvl = 475, Id = 119},
        {Lvl = 450, Id = 118},
        {Lvl = 425, Id = 117},
        {Lvl = 375, Id = 116},
        {Lvl = 350, Id = 115},
        {Lvl = 325, Id = 114},
        {Lvl = 275, Id = 113},
        {Lvl = 250, Id = 112},
        {Lvl = 225, Id = 111},
    }

    for _, element in ipairs(TableOrnementLvl) do
        if character:level() >= element.Lvl then
            settOrnament(element.Id)
            break
        end
    end
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

    if hdvFull then
		exchange:putAllItemsExcept({16864, 16881, 16987, 16959, 14966})
    else
        for _, element in ipairs(TableVente) do
            if inventory:itemCount(element.id) > 0 then
                exchange:putItem(element.id, inventory:itemCount(element.id))
            end
        end
    end
    if not hdvFull and global:isBoss() then
        local itemToSell = {}
        local podsAvailable = inventory:podsMax() - inventory:pods()
        for _, element in ipairs(TableVente) do
            local TotalMax = element.remaining100 * 100 + element.remaining10 * 10 + element.remaining1
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.id)))
            if ((element.remaining100 > 0 and QuantiteAPrendre >= 100) or (element.remaining10 > 0 and QuantiteAPrendre >= 10)) and element.canSell then
                local element = {id = element.id, quantity = QuantiteAPrendre}
                table.insert(itemToSell, element)
                podsAvailable = podsAvailable - QuantiteAPrendre * inventory:itemWeight(element.id)
            end
        end
        if #itemToSell > 5 then
            for _, element in ipairs(itemToSell) do
                exchange:getItem(element.id, element.quantity)
            end
            NeedToSell = true
        end
    end

    hdvFull = false

    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("NeedToSell")
            acc.global():addInMemory("NeedToSell", NeedToSell)
            acc:callScriptFunction("CheckOrnement")
        end
        global:deleteMemory("NeedToSell")
        global:addInMemory("NeedToSell", NeedToSell)
        CheckOrnement()
    end

    NeedToSell = global:remember("NeedToSell")

	global:leaveDialog()
    
	return map:door(518)
end

local function treatMapsGroup(maps)
    local msg = "[Erreur] - Aucune action à réaliser sur la map"

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end
    if global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.map:changeMap("havenbag")
        end
        map:changeMap("havenbag")
    end
end

local function GoToDimension()
    if ((not map:onMap("0,0") and not goingToDimension) or map:onMap("0,0")) and global:isBoss() then
        posEcaflipus = getmapIdPortal("Ecaflipus", character:server())

        local TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            if not acc.map:onMap("0,0") then
                acc.map:changeMap("havenbag")
            end
        end
        if not map:onMap("0,0") then
            map:changeMap("havenbag")
        end        
        closestZapp = map:closestZaapV2(tonumber(posEcaflipus))
        global:leaveDialog()

        if closestZapp > 0 then
            goingToDimension = true
            if global:isBoss() then
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:changeMap("zaap(" .. closestZapp .. ")")
                end
                map:changeMap("zaap(" .. closestZapp .. ")")
            end
        elseif closestZapp == -1 then
            global:leaveDialog()
            global:printSuccess("On est déjà au zaap le plus proche !")
            goingToDimension = true

        else
            for _, acc in ipairs(TeamAcount) do
                acc:setScriptVariable("failPortail", true)
            end
            failPortail = true
            global:leaveDialog()
            global:printSuccess("Impossible de trouver un zaap proche, on va farm une autre zone")
            return move()
        end
    end
    if global:isBoss() and not map:onMap(tonumber(posEcaflipus)) then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.map:moveToward(tonumber(posEcaflipus))
        end
        if not map:moveToward(tonumber(posEcaflipus)) then
            failPortail = true
            for _, acc in ipairs(TeamAcount) do
                acc:setScriptVariable("failPortail", true)
                acc.map:changeMap("havenbag")
            end
            map:changeMap("havenbag")
        end
        -- return {
        --     {map = map:currentMapId(), lockedCustom = function ()
        --         map:moveToward(tonumber(posEcaflipus))
        --     end}
        -- }
    elseif global:isBoss() then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc:callScriptFunction("UsePortail")
        end
        UsePortail()
    end
end

local function WhichArea()
    tradeDone = false
    hdvActualise = false
    for i in ipairs(TableArea) do
        local Zone = TableArea[i].Zone
        for j in ipairs(Zone) do

            if map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) <= #Zone then
                -- si on arrive à la map de changement de sous zone
                MAX_MONSTERS = TableArea[i].MaxMonster
                MIN_MONSTERS = TableArea[i].MinMonster
                Zone[j][3] = false
                Zone[j + 1][3] = true
                return treatMapsGroup(Zone[j + 1][1])

            elseif map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) > #Zone then

                global:printSuccess(i + 1 .. " ème zone")
                CompteurDeath = 0
                -- si on arrive à la map de changement de sous zone et à la fin de la table
                Zone[j][3] = false
                TableArea[i].Farmer = false

                for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                    local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                    
                    if not ZoneSuivante.Stop then

                        if ZoneSuivante.Ecaflipus and not failPortail then
                            GoToDimension()
                        elseif ZoneSuivante.Ecaflipus and failPortail then
                            ZoneSuivante = TableArea[IncrementTable(i + index, #TableArea)]
                        end
                        MAX_MONSTERS = ZoneSuivante.MaxMonster
                        MIN_MONSTERS = ZoneSuivante.MinMonster

                        ZoneSuivante.Farmer = true
                        ZoneSuivante.Zone[1][3] = true
                        return treatMapsGroup(ZoneSuivante.Zone[1][1])

                    end

                end
                -- si on a pas trouvé d'autre zone, on refarm la même

                return treatMapsGroup(Zone[1][1])

            elseif Zone[j][3] and TableArea[i].Farmer then
                global:printSuccess(i)
                local myZone = TableArea[i]

                if myZone.Ecaflipus and not failPortail and (getCurrentAreaName() ~= "Ecaflipus") then
                    GoToDimension()
                elseif myZone.Ecaflipus and failPortail then
                    global:printSuccess(i + 1 .. " ème zone")
                    CompteurDeath = 0
                    -- si on arrive à la map de changement de sous zone et à la fin de la table
                    Zone[j][3] = false
                    TableArea[i].Farmer = false
                    for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer
                        local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                        
                        if not ZoneSuivante.Stop then
    
                            if ZoneSuivante.Ecaflipus and not failPortail then
                                GoToDimension()
                            elseif ZoneSuivante.Ecaflipus and failPortail then
                                ZoneSuivante = TableArea[IncrementTable(i + index, #TableArea)]
                            end
                            MAX_MONSTERS = ZoneSuivante.MaxMonster
                            MIN_MONSTERS = ZoneSuivante.MinMonster
    
                            ZoneSuivante.Farmer = true
                            ZoneSuivante.Zone[1][3] = true
                            return treatMapsGroup(ZoneSuivante.Zone[1][1])
    
                        end
    
                    end
                else
                    MAX_MONSTERS = myZone.MaxMonster
                    MIN_MONSTERS = myZone.MinMonster

                    return treatMapsGroup(myZone.Zone[j][1])
                end
            end
        end 
    end
end


function ManageXpMount()
    local myMount = mount:myMount()
    if myMount ~= nil then
        if myMount.level < 100 and character:level() > 154 then
            global:printSuccess("dd level : " .. myMount.level)
            mount:setXpRatio(90)
        else
            mount:setXpRatio(0)
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end
end


function move()
    if global:isBoss() then
        mapDelay()
    else
        local random = math.random()
        if random < 0.05 then
            global:delay(math.random(700, 1100))
        elseif random < 0.25 then
            global:delay(math.random(400, 650))
        elseif random < 0.5 then
            global:delay(math.random(200, 400))
        else
            global:delay(math.random(100, 250))
        end
    end
    TeamAcount = global:thisAccountController():getTeamAccounts()
    if global:isBoss() then
        for _, acc in ipairs(TeamAcount) do
            PLANNING = {2, 3, 4, 5, 6, 7, 14, 15}
            global:printSuccess(getRemainingSubscription(true, acc))
            if getRemainingSubscription(true, acc) < 2 then
                PLANNING = {}
                break
            end
        end
        PLANNING = {2, 3, 4, 5, 6, 7, 14, 15}
       global:printSuccess(getRemainingSubscription(true))

        if getRemainingSubscription(true) < 2 then
            PLANNING = {}
        end
    end

    if global:isBoss() and global:afterFight() then
        for _, acc in ipairs(TeamAcount) do
            acc:callScriptFunction("ManageXpMount")
        end
        ManageXpMount()
    end

    if not ScriptStarted then
        if global:isBoss() then
            for _, acc in ipairs(TeamAcount) do
                acc.global():deleteMemory("retryPortail")
                acc.global():deleteMemory("lenghtTeam")
                acc.global():addInMemory("lenghtTeam", lenghtTeam)
                local tableIdSorts = {{Id = 12725, Lvl = 110}, {Id = 12751, Lvl = 185}, {Id = 12729, Lvl = 145}, {Id = 12763, Lvl = 140}, {Id = 12734, Lvl = 1}}
                for _, element in ipairs(tableIdSorts) do
                    if acc.character():level() >= element.Lvl then
                        message = developer:createMessage("SpellVariantActivationRequestMessage")
                        message.spellId = element.Id
                        acc.developer():sendMessage(message)
                        global:delay(math.random(1000, 2500))
                    end
                end
            end

            local tableIdSorts = {{Id = 12725, Lvl = 110}, {Id = 12751, Lvl = 185}, {Id = 12729, Lvl = 145}, {Id = 12763, Lvl = 140}, {Id = 12734, Lvl = 1}}
            for _, element in ipairs(tableIdSorts) do
                if character:level() >= element.Lvl then
                    message = developer:createMessage("SpellVariantActivationRequestMessage")
                    message.spellId = element.Id
                    developer:sendMessage(message)
                end
            end

            global:deleteMemory("retryPortail")
            global:deleteMemory("lenghtTeam")
            global:addInMemory("lenghtTeam", lenghtTeam)
        end
        lenghtTeam = global:remember("lenghtTeam")
        ScriptStarted = true
    end
    
    if global:thisAccountController():getAlias():find("Groupe2") then
        global:editAlias("Groupe2 " .. character:server() .. " " .. getRemainingSubscription(true), true)
    elseif global:thisAccountController():getAlias():find("Groupe3")  then
        global:editAlias("Groupe3 " .. character:server() .. " " .. getRemainingSubscription(true), true)
    else
        global:editAlias("Groupe " .. character:server() .. " " .. getRemainingSubscription(true), true)
    end

    if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        Abonnement()
    elseif getRemainingHoursSubscription() < 4 and character:server() == "Draconiros" then
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end

    if global:remember("retryPortail") ~= nil and secondsToHours(os.time() - global:remember("retryPortail")) >= 5 and failPortail then
        global:editInMemory("retryPortail", 0)
        failPortail = false
    end
    
    if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212601350", lockedCustom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", lockedCustom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    minKamas = (getRemainingSubscription(true) == 0) and 1000000 or 400000


    if global:remember("failed") then
        if not global:remember("retryTimestamp") and global:isBoss() then 
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global():addInMemory("retryTimestamp", os.time()) 
            end
            global:addInMemory("retryTimestamp", os.time()) 
        end

        if secondsToHours(os.time() - global:remember("retryTimestamp")) >= minRetryHours then
            rerollVar()
            if global:isBoss() then
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.global():editInMemory("retryTimestamp", 0)
                end
            end
            global:editInMemory("retryTimestamp", 0)
        end
    end


    if global:isBoss() and (character:kamas() >= givingTriggerValue) and not global:remember("failed") and getCurrentAreaName() ~= "Ecaflipus" then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("givingMode")
            acc.global():addInMemory("givingMode", true)
        end
        global:deleteMemory("givingMode")
        global:addInMemory("givingMode", true)
    elseif global:isBoss() then 
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("givingMode")
            acc.global():addInMemory("givingMode", false)
        end
        global:deleteMemory("givingMode")
        global:addInMemory("givingMode", false)
    end

    givingMode = global:remember("givingMode")

    if givingMode then
        if not connected then
            receiver = connectReceiver()

            cannotConnect = global:remember("cannotConnect")

            if cannotConnect then

                rerollVar()
                if global:isBoss() then
                    receiver:disconnect()
                    TeamAcount = global:thisAccountController():getTeamAccounts()
                    for _, acc in ipairs(TeamAcount) do
                        acc.global():editInMemory("retryTimestamp", os.time())
                        acc.global():addInMemory("failed", true)
                    end
                    global:editInMemory("retryTimestamp", os.time())
                    global:addInMemory("failed", true)
                end

				cannotConnect = false
            else
				connected = true
            end
        end
        
        if not global:remember("failed") then
            return goAstrubBank(launchExchangeAndGive)
        end
    end

    antiModo()
    
    if DebutDuScript and getCurrentAreaName() == "Ecaflipus" then
        return treatMapsGroup({
            {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
            {map = "161220622", path = "top"},
            {map = "161220620", path = "right"},
            {map = "161221644", path = "top"},
            {map = "161220618", path = "left"},
            {map = "161219594", path = "top"},
            {map = "161219592", path = "left"},
            {map = "161218568", path = "top"},
            {map = "161350662", path = "top"},
            {map = "161350660", path = "left"},

            {map = "161480704", path = "bottom"},
            {map = "161358084", path = "right"},
            {map = "161357060", path = "right"},
            {map = "161356036", path = "top"},
            {map = "161356038", path = "right"},
            {map = "161355012", path = "bottom"},
            {map = "161355010", path = "right"},
            {map = "161353986", path = "right"},
            {map = "161352704", path = "right"},
            {map = "161351680", path = "bottom"},
            {map = "161350658", path = "right"},
            {map = "161218562", path = "right"},
            {map = "161219586", path = "bottom"},
            {map = "161219588", path = "bottom"},
            {map = "161220614", path = "bottom"},

            {map = "160959747", path = "left"},
            {map = "160959745", path = "left"},
            {map = "160958464", path = "left"},
            {map = "160957952", path = "left"},
            {map = "160957440", path = "left"},
            {map = "160956928", path = "top"},
            {map = "160956416", path = "right"},
            {map = "160956417", path = "right"},
            {map = "160956929", path = "top"},
            {map = "160956930", path = "top"},
            {map = "160956931", path = "top"},
            {map = "160957443", path = "top"},
            {map = "160957442", path = "top"},
            {map = "160957441", path = "top"},
            {map = "160957953", path = "top"},
            {map = "160957954", path = "top"},
            {map = "160957955", path = "top"},
            {map = "160958466", path = "top"},
            {map = "160958465", path = "top"},
            {map = "160957953", path = "top"},
        })
    elseif DebutDuScript then
        if getCurrentAreaName() == "Amakna" then
            return {
                {map = map:currentMap(), path = "havenbag"}
            }
        end
        return treatMapsGroup({
            {map = "212600323", path = "bottom"},
            {map = "212600837", path = "bottom"},
            {map = "212600838", path = "right"},
            {map = "0,0", path = "zaap(212600323)"},
            {map = "212601350", custom = function()
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc:callScriptFunction("ProcessSell")
                end
                ProcessSell()
            end}, -- Map HDV ressources bonta
        })
    end

    if global:isBoss() and (inventory:itemCount(678) >= 200 or inventory:itemCount(680) >= 20) then
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.global():deleteMemory("GoSellParcho")
            acc.global():addInMemory("GoSellParcho", true)
        end
        global:deleteMemory("GoSellParcho")
        global:addInMemory("GoSellParcho", true)
    end

    GoSellParcho = global:remember("GoSellParcho")

    if GoSellParcho then
		return treatMapsGroup(AreaEnergieAndSellParcho)
    end

    return WhichArea()
end


function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end

function bank()
    mapDelay()
    if not tradeDone and global:isBoss() and not map:onMap("0,0") then   

        IdsAvailable = global:getTeamMembersIds()

        TeamAcount = global:thisAccountController():getTeamAccounts()

        tradeDone = true

        for _, acc in ipairs(TeamAcount) do
            if not acc.map:onMap(map:currentMapId()) then
                tradeDone = false
                break
            end
            if acc.inventory():podsP() > 5 then
                acc.global():setPrivate(false)
                while not exchange:launchExchangeWithPlayer(acc.character():id()) do
                    global:printMessage("Attente de l'acceptation de l'échange (1 secondes)")
                    global:delay(1000)
                end
    
                local kamasToGive = 1200000 - acc.character():kamas()
                local tableAlias = acc:getAlias():split(" ")
                local nbDaysRemaining = tonumber(tableAlias[#tableAlias])
            
                if kamasToGive > 0 and character:kamas() > kamasToGive * 1.1 and nbDaysRemaining < 3 then
                    global:printSuccess("je donne " .. kamasToGive .. " à la mule " .. acc:getAlias())
                    exchange:putKamas(kamasToGive)
                end
                developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
                exchange:ready()
    
                acc.global():setPrivate(true)
            end
        end
    end

    if getCurrentAreaName() == "Ecaflipus" then
        return treatMapsGroup({
            {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
            {map = "161220622", path = "top"},
            {map = "161220620", path = "right"},
            {map = "161221644", path = "top"},
            {map = "161220618", path = "left"},
            {map = "161219594", path = "top"},
            {map = "161219592", path = "left"},
            {map = "161218568", path = "top"},
            {map = "161350662", path = "top"},
            {map = "161350660", path = "left"},

            {map = "161480704", path = "bottom"},
            {map = "161358084", path = "right"},
            {map = "161357060", path = "right"},
            {map = "161356036", path = "top"},
            {map = "161356038", path = "right"},
            {map = "161355012", path = "bottom"},
            {map = "161355010", path = "right"},
            {map = "161353986", path = "right"},
            {map = "161352704", path = "right"},
            {map = "161351680", path = "bottom"},
            {map = "161350658", path = "right"},
            {map = "161218562", path = "right"},
            {map = "161219586", path = "bottom"},
            {map = "161219588", path = "bottom"},
            {map = "161220614", path = "bottom"},

            {map = "160959747", path = "left"},
            {map = "160959745", path = "left"},
            {map = "160958464", path = "left"},
            {map = "160957952", path = "left"},
            {map = "160957440", path = "left"},
            {map = "160956928", path = "top"},
            {map = "160956416", path = "right"},
            {map = "160956417", path = "right"},
            {map = "160956929", path = "top"},
            {map = "160956930", path = "top"},
            {map = "160956931", path = "top"},
            {map = "160957443", path = "top"},
            {map = "160957442", path = "top"},
            {map = "160957441", path = "top"},
            {map = "160957953", path = "top"},
            {map = "160957954", path = "top"},
            {map = "160957955", path = "top"},
            {map = "160958466", path = "top"},
            {map = "160958465", path = "top"},
            {map = "160957953", path = "top"},
        })
    end

    if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212601350", lockedCustom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", lockedCustom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end


	if map:currentMap() == "11,10" then map:changeMap("right") end
	
    return treatMapsGroup({
        {map = "161351684", lockedCustom = function() map:useById(503232, -2) end},
        {map = "161220622", path = "top"},
        {map = "161220620", path = "right"},
        {map = "161221644", path = "top"},
        {map = "161220618", path = "left"},
        {map = "161219594", path = "top"},
        {map = "161219592", path = "left"},
        {map = "161218568", path = "top"},
        {map = "161350662", path = "top"},
        {map = "161350660", path = "left"},

        {map = "161480704", path = "bottom"},
        {map = "161358084", path = "right"},
        {map = "161357060", path = "right"},
        {map = "161356036", path = "top"},
        {map = "161356038", path = "right"},
        {map = "161355012", path = "bottom"},
        {map = "161355010", path = "right"},
        {map = "161353986", path = "right"},
        {map = "161352704", path = "right"},
        {map = "161351680", path = "bottom"},
        {map = "161350658", path = "right"},
        {map = "161218562", path = "right"},
        {map = "161219586", path = "bottom"},
        {map = "161219588", path = "bottom"},
        {map = "161220614", path = "bottom"},

        {map = "160959747", path = "left"},
        {map = "160959745", path = "left"},
        {map = "160958464", path = "left"},
        {map = "160957952", path = "left"},
        {map = "160957440", path = "left"},
        {map = "160956928", path = "top"},
        {map = "160956416", path = "right"},
        {map = "160956417", path = "right"},
        {map = "160956929", path = "top"},
        {map = "160956930", path = "top"},
        {map = "160956931", path = "top"},
        {map = "160957443", path = "top"},
        {map = "160957442", path = "top"},
        {map = "160957441", path = "top"},
        {map = "160957953", path = "top"},
        {map = "160957954", path = "top"},
        {map = "160957955", path = "top"},
        {map = "160958466", path = "top"},
        {map = "160958465", path = "top"},
        {map = "160957953", path = "top"},

        {map = "212600323", path = "bottom"},
        {map = "212600837", path = "bottom"},
        {map = "212600838", path = "right"},
        {map = "0,0", path = "zaap(212600323)"},
        {map = "212601350", lockedCustom = ProcessSell}, -- Map HDV ressources bonta
    })
end

local function UsePhenix1()
    if global:isBoss() then
        map:door(354)
        global:delay(500)
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.map:door(354)
            acc.global():delay(500)
        end
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            if not acc.mount():isRiding() then
                acc.mount():toggleRiding()
            end
            acc.map:changeMap("havenbag")
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
        map:changeMap("havenbag")
    end
end

local function UsePhenix2()
    if global:isBoss() then
        map:door(306)
        global:delay(500)
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            acc.map:door(306)
            acc.global():delay(500)
        end
        TeamAcount = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(TeamAcount) do
            if not acc.mount():isRiding() then
                acc.mount():toggleRiding()
            end
            acc.map:changeMap("havenbag")
        end
        if not mount:isRiding() then
            mount:toggleRiding()
        end
        map:changeMap("havenbag")
    end
end


function banned()
    global:editAlias(phrase .. " [BAN]", true)
end

function phenix()
	return {
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", lockedCustom = function() map:door(219) map:changeMap("havenbag") end},
		{map = "22,22", lockedCustom = function() map:door(387) map:changeMap("havenbag") end},
		{map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", lockedCustom = function() map:door(184) map:changeMap("havenbag") end},
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", lockedCustom = function() map:door(219) map:changeMap("havenbag") end},
		{map = "-16,41", path = "top"},
		{map = "-16,40", path = "top"},
		{map = "-16,39", path = "top"},
		{map = "-16,38", path = "top"},
		{map = "-16,37", path = "top"},
		{map = "-13,28", path = "right"},
		{map = "-17,41", path = "right"},
		{map = "-16,36", lockedCustom = function() map:door(135) map:changeMap("havenbag") end},
		{map = "-9,-54", path = "left"},
		{map = "-10,-54", lockedCustom = function() map:door(342) map:changeMap("havenbag") end},
        {map = "23331073", path = "bottom"},
		{map = "23330816", path = "bottom"},
		{map = "159769", path = "left"},
		{map = "-57,25", path = "left"},
		{map = "-58,24", path = "top"},
		{map = "-58,25", path = "top"},
		{map = "-58,23", path = "top"},
		{map = "-58,22", path = "top"},
		{map = "-58,21", path = "top"},
		{map = "-58,20", path = "top"},
		{map = "-58,19", path = "top"},
		{map = "-58,18", lockedCustom = UsePhenix1},
		{map = "-43,0", lockedCustom = function() map:door(259) map:changeMap("havenbag") end},

        {map = "37,-43", path = "left"},
        {map = "36,-43", path = "left"},
        {map = "35,-43", path = "bottom"},
        {map = "35,-42", path = "bottom"},
        {map = "35,-41", path = "bottom"},
        {map = "35,-40", lockedCustom = UsePhenix2},
        {map = "-3,-13", path = "right"},
        {map = "-2,-13", path = "right"},
        {map = "-1,-13", path = "right"},
        {map = "0,-13", path = "right"},
        {map = "1,-13", path = "right"},
        {map = "2,-13", path = "top"},
        {map = "2,-14", lockedCustom = function ()
            if global:isBoss() then
                map:door(313)
                global:delay(500)
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:door(313)
                    acc.global():delay(500)
                end
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    if not acc.mount():isRiding() then
                        acc.mount():toggleRiding()
                    end
                    
                    acc.map:changeMap("havenbag")
                end
                if not mount:isRiding() then
                    mount:toggleRiding()
                end
                map:changeMap("havenbag")
            end
        end},

        {map = "-9,-54", path = "left"},
        {map = "-10,-54", lockedCustom = function ()
            if global:isBoss() then
                map:door(342)
                global:delay(500)
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    acc.map:door(342)
                    acc.global():delay(500)
                end
                TeamAcount = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(TeamAcount) do
                    if not acc.mount():isRiding() then
                        acc.mount():toggleRiding()
                    end
                    acc.map:changeMap("havenbag")
                end
                if not mount:isRiding() then
                    mount:toggleRiding()
                end
                map:changeMap("havenbag")
            end
        end},
	}
end

function stopped()
    global:printSuccess("stopped")
    local lines = global:consoleLines()
    for _, line in ipairs(lines) do
        if line:find("Recherche du Zaap le plus proche de la carte") then
            global:thisAccountController():startScript()
            break
        end
    end
    global:printSuccess(lines[#lines - 3])
    if lines[#lines - 3]:find("variante") or lines[#lines - 3]:find("banque d'Astrub") or lines[#lines - 3]:find("1")then
        global:thisAccountController():startScript()
    end
end


function Ravage(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
		fightAction:castSpellOnCell(12746, cellid)
    else
        local path = fightAction:getShortestPath(fightCharacter:getCellId(), cellid, false)
        if path and #path > 0 then
            if fightCharacter:getMP() < #path then
                Fluctuation()
            end
            MoveInLineOf(cellid, 6)
            if not fightAction:isHandToHand(fightCharacter:getCellId(), cellid) then
                if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
                    fightAction:castSpellOnCell(12746, cellid)
                else
                    if not fightAction:isHandToHand(fightCharacter:getCellId(), cellid) then
                        MoveInLineOf(fightAction:getNearestEnemy(), 9)
                        if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
                            fightAction:castSpellOnCell(12746, cellid)
                        else
                            Attirance(cellid)
                        end
                    end
                end
            else
                Supplice()
            end
        end
    end
end


function prefightManagement(challengers, defenders) --bugé
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local CellIdOmbre = {}
	local CellulesWithDistance = { }

	local i = 1 
	for cell1, id1 in pairs(challengers) do
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end
		if not fightAction:isFreeCell(cell1) and (id1 < 0) then
            local element = {
                Cellid = cell1,
                DistanceTotale = DistanceEmplacement[i]
            }
            table.insert(CellIdOmbre, element)
		end
		local element = {
			Cellid = cell1,
			DistanceTotale = DistanceEmplacement[i]
		}
		table.insert(CellulesWithDistance, element)
		i = i + 1
	end

    if global:thisAccountController():getAlias():find("Mule") then
        table.sort(CellulesWithDistance, function(a, b) return a.DistanceTotale > b.DistanceTotale end)
    else
    	table.sort(CellulesWithDistance, function(a, b) return a.DistanceTotale < b.DistanceTotale end)
    end
	table.sort(CellIdOmbre, function(a, b) return a.DistanceTotale > b.DistanceTotale end)

	for i = 1, 11 do
		if not fightAction:isFreeCell(CellulesWithDistance[i].Cellid) and CellIdOmbre[1].Cellid == CellulesWithDistance[1].CellId then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
			message.requestedId = -1
			message.cellId = CellIdOmbre[1].Cellid
			developer.sendMessage(message)

			break
		end
		if fightAction:isFreeCell(CellulesWithDistance[i + 1].Cellid) and fightAction:isFreeCell(CellulesWithDistance[i].Cellid) then
            if global:thisAccountController():getAlias():find("Mule") then
                local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
                message.cellId = CellulesWithDistance[i].Cellid
                developer.sendMessage(message)
                break
            end
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			if CellIdOmbre[1].Cellid ~= 0 then
				message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
				message.requestedId = -1
				message.cellId = CellIdOmbre[1].Cellid
				developer.sendMessage(message)

				message = developer:createMessage("GameFightPlacementPositionRequestMessage")
				message.cellId = CellulesWithDistance[i].Cellid
				developer.sendMessage(message)
			end
			break
		end
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
	local challengeBonus = 1

	-- Choix du mode des challenges
	-- 0 = Manuel
	-- 1 = Aléatoire
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

    if fightCharacter:isItMyTurn() == true then
        if fightAction:getCurrentTurn() == 1 then
            lancable = 0
            incrementation = 0
        elseif fightAction:getCurrentTurn() > 100 then
            Abandon()
        end

        delayFightStartTurn()

        local enemies = GetAllEnemiesFromTheNearest()
        if enemies ~= nil and #enemies > 0 then
            for _, entity in ipairs(enemies) do
                local PM = fightCharacter:getMP()
                if PM > 0 and not IsHandToHandEnemy() and entity.CellId then
                    local cellId = fightCharacter:getCellId()
                    MoveInLineOf(entity.CellId, 6)
                    if cellId == fightCharacter:getCellId() then
                        MoveInLineOf(entity.CellId, 9)
                    end
                    if PM ~= fightCharacter:getMP() then
                        break
                    end
                end
            end
        end

        -- J'avance vers mon ennemi le plus proche
        -- lancement mutilation
        if lancable == 0 then 
            if incrementation == 1 then
                Libation()
                if fightCharacter:getAP() > 5 then
                    Entaille()
                end
                if fightCharacter:getAP() > 8 then
                    Supplice()
                end
                if fightCharacter:getAP() > 5 then
                    Entaille()
                end
                if fightCharacter:getAP() > 4 then
                    Supplice()
                end
                if (fightCharacter:getAP() > 5) then
                    Ravage(WeakerMonsterAdjacent())
                end
                if fightCharacter:getAP() > 5 then
                    Entaille()
                end
                if fightCharacter:getAP() > 5 then
                    Entaille()
                end
                if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (map:currentSubArea() ~= "Tronc de l'arbre Hakam") and (fightCharacter:getAP() > 4) and fightCharacter:getLevel() > 154 then
                    Courrone_Epine()
                end
                if fightCharacter:getAP() > 4 then
                    Supplice()
                end
            end
            fightAction:castSpellOnCell(12737, fightCharacter:getCellId())
            incrementation = (incrementation == 0) and 1 or 0
            lancable = lancable + incrementation
        else
            lancable = lancable - 1
        end

        if isKaskargoInFight() and fightCharacter:getLevel() > 154 then
            --Pilori()
        end

        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        if (map:currentSubArea() == "Tronc de l'arbre Hakam") then
            Ravage(WeakerMonsterAdjacent())
            Deplacement()
            LaunchEpee_Vorace()
        end

        if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (map:currentSubArea() ~= "Tronc de l'arbre Hakam")  and fightCharacter:getLevel() > 154 then
            Courrone_Epine()
        end

        if fightCharacter:getAP() == 8 or fightCharacter:getAP() == 4 then
            Entaille()
            Entaille()
        else
            Supplice()
            Entaille()
        end


        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        if (fightCharacter:getLifePointsP() < 50) and (fightCharacter:getAP() == 6) and (fightCharacter:getAP() == 3) then
            Supplice()
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
        end

        Entaille()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        Entaille()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        Supplice()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)

        Ravage(WeakerMonsterAdjacent())
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        Entaille()

        if (fightCharacter:getLifePointsP() < 50) and (fightCharacter:getAP() == 6) and (fightCharacter:getAP() == 3) then
            Supplice()
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
            Supplice()
        end


        Entaille()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        Entaille()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        Supplice()
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
    
        DeplacementProche()

        if fightCharacter:getLevel() > 144 then
            Afflux()
            Afflux()
        end
        Absorption(fightAction:getNearestEnemy())
        Stase(fightAction:getNearestEnemy())
        Stase(fightAction:getNearestEnemy())

        if map:currentSubArea() == "Tronc de l'arbre Hakam" and fightCharacter:getLevel() > 154 then
            --Pilori()
        end

        LaunchEpee_Vorace()

        if fightCharacter:getMP() > 0 then
            local entities = fightAction:getAllEntities()
            for _, element in ipairs(entities) do
                -- on cherche le sacrieur
                if element.CreatureGenericId == 4298 then
                    local zone = fightAction:getCells_square(element.CellId, 1, 1)
                    for _, cellId in ipairs(zone) do
                        -- on regarde si on se trouve à côté d'un Chakichan
                        if fightCharacter:getCellId() == cellId then
                            -- si c'est le cas on regarde pour finir son tour dans sa case adjacente la plus éloignée du Chakichan
                            local cellWhereMove = fightAction:getCells_lozenge(fightSlave:cellId(), 1, 3)
                            table.sort(cellWhereMove, function(a, b) return fightAction:getDistance(a, element.CellId) > fightAction:getDistance(b, element.CellId) end)
                            fightAction:moveTowardCell(cellWhereMove[1])
                            break
                        end
                    end
                    break
                end
            end
        end
        fightAction:passTurn()
    else
        global:printSuccess("Ombre")
        
        delayFightStartTurn()
        
        MoveInLineOfForSlave(fightSlave:getNearestEnemy(), 6)

        Colere_Noire()

        Vengeance_Nocturne()

        DeplacementProcheSlave()

        local nearestEnnemi = WeakerMonsterAdjacentSlave()
        Diabolo_Chiste(nearestEnnemi)

        local entities = fightAction:getAllEntities()
        local AdjCases = fightAction:getAdjacentCells(fightSlave:cellId())
        local newEnnemi = nil

        for _, cellId in ipairs(AdjCases) do
            for _, entity in ipairs(entities) do
                if (entity.CellId == cellId) and entity.Team and (entity.CellId ~= nearestEnnemi) then
                    newEnnemi = entity.CellId
                end
            end
        end
        if newEnnemi == nil then
            newEnnemi = fightSlave:getNearestEnemy()
        end
        if newEnnemi ~= nearestEnnemi then
            Diabolo_Chiste(newEnnemi)
        end

        DeplacementSlave()

        Cartilage(WeakerMonsterAdjacentSlave())
        DeplacementSlave()
        Diabolo_Chiste(WeakerMonsterAdjacentSlave())
        DeplacementSlave()
        Vengeance_Nocturne()
        DeplacementSlave()
        Ombrolingo(WeakerMonsterAdjacentSlave())
        DeplacementSlave()
        Ombrolingo(WeakerMonsterAdjacentSlave())
        
        Crepuscule(WeakerMonsterAdjacentSlave())
        DeplacementSlave()
        Crepuscule(fightSlave:getNearestEnemy())

        Vengeance_Nocturne2()
        global:printSuccess("Fin Ombre")
        fightAction:passTurn()
    end
end


