dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")



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

local function equiper(stuff)
	for _, element in ipairs(stuff) do
		if inventory:itemCount(element.Id) > 0 then
			inventory:equipItem(element.Id, element.Emplacement)
		end
	end
end

local function BuyIdoles()
	npc:npc(333, 6)

	local listeIdoles = {
		{name = "dynamo", id_banque = 16864},
		{name = "kyoub", id_banque = 16964},
		{name = "leukide", id_banque = 16881},
	}

	for _, element in ipairs(listeIdoles) do
	    if inventory:itemCount(element.id_banque) == 0 then
			sale:buyItem(element.id_banque, 1, 500000)
		end
	end

	global:leaveDialog()
end

local function BuyStuff114()
	local tableEquipWithoutBigFonction = {
        {name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
        {name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
        {name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
        {name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
        {name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
        {name = "arme sasa", id = 478, emplacement = 1, equipe = false},
        {name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},
        {name = "trophet 1", id = 13748, equipe = false, emplacement = 9},
        {name = "dofus cawotte", id = 972, equipe = false, emplacement = 10},
        {name = "trophet 4", id = 13793, equipe = false, emplacement = 11},
        {name = "dofus argenté", id = 19629, emplacement = 12, equipe = false},
		{name = "ombre", id = 14966},
	}

	local prices = {}

	npc:npc(333, 5)

    for i, element in ipairs(tableEquipWithoutBigFonction) do
        prices[i] = sale:getAveragePriceItem(element.id, 1) * 1.5
    end

    global:leaveDialog()

    npc:npc(333, 6)
    for i, element in ipairs(tableEquipWithoutBigFonction) do
        if inventory:itemCount(element.id) == 0 then
            sale:buyItem(element.id, 1, prices[i])
            global:delay(500)
        end
    end
    if inventory:itemCount(14966) == 0 then
        sale:buyItem(14966, 1, 1000000)
    end
	if inventory:itemCount(17078) == 0 then
        sale:buyItem(17078, 1, 200000)
    end
    if inventory:itemCount(19629) == 0 then
        sale:buyItem(19629, 1, 200000)
    end   

    global:leaveDialog()
    npc:npc(333, 6)

    for i, element in ipairs(tableEquipWithoutBigFonction) do
        if inventory:itemCount(element.id) == 0 then
            sale:buyItem(element.id, 1, prices[i])
            global:delay(500)
        end
    end
    if inventory:itemCount(14966) == 0 then
        sale:buyItem(14966, 1, 1000000)
    end
	if inventory:itemCount(17078) == 0 then
        sale:buyItem(17078, 1, 200000)
    end
    if inventory:itemCount(19629) == 0 then
        sale:buyItem(19629, 1, 200000)
    end    

	global:leaveDialog()

	local tableStuff114 = {
		{Type = "coiffe", Id = 8463, Emplacement = 6},
		{Type = "amulette", Id = 8465, Emplacement = 0},
		{Type = "ceinture", Id = 8468, Emplacement = 3},
		{Type = "cape", Id = 8464, Emplacement = 7},
		{Type = "bottes", Id = 8467, Emplacement = 5},
		{Type = "arme", Id = 250, Emplacement = 1},
		{Type = "anneau gauche", Id = 8466, Emplacement = 2},
		{Type = "anneau droit", Id = 2469, Emplacement = 4},
		{Type = "bouclier", Id = 18690, Emplacement = 15},
		{Type = "dofus kaliptus", Id = 8072, Emplacement = 11}
	}
	local items = {}

	for _, element in ipairs(tableStuff114) do
		if inventory:itemCount(element.Id) == 0 then
			table.insert(items, element.Id)
		end
	end

	buyWorthItem(items)

	global:leaveDialog()

    npc:npc(255,6)	

    for _, item in ipairs(items) do
        if inventory:itemCount(item) == 0 then
            sale:buyItem(item, 1, 200000)
        end
    end
    global:leaveDialog()

	map:changeMap("right")
end

local function BuyStuff()

    local tableEquip = {
        {Type = "amulette", Id = 9149, Emplacement = 0, Equipe = false},
        {Type = "ceinture", Id = 9167, Emplacement = 3, Equipe = false},
        {Type = "cape", Id = 6942, Emplacement = 7, Equipe = false},
        {Type = "bottes", Id = 9158, Emplacement = 5, Equipe = false},
        {Type = "coiffe", Id = 2447, Emplacement = 6, Equipe = false},
        {Type = "anneauGauche", Id = 9122, Emplacement = 2, Equipe = false},
        {Type = "arme", Id = 1162, Emplacement = 1, Equipe = false},
    }

    npc:npc(255,6)	

    if (inventory:itemCount(2469) == 0) then
        sale:buyItem(2469, 1, 200000)
    end

    if (inventory:itemCount(19629) == 0) then
        sale:buyItem(19629, 1, 200000)
    end  

    local items = {}

    for _, element in ipairs(tableEquip) do
		if (inventory:itemCount(element.Id) == 0) then
			table.insert(items, element.Id)
		end
	end

    for _, element in ipairs(tableEquip) do
        if (inventory:itemCount(element.Id) == 0) then
            buyWorthItem(element.Id, 200000)
        end
    end

    global:leaveDialog()

    npc:npc(255,6)	

    for _, item in ipairs(items) do
        if inventory:itemCount(item) == 0 and charcter:kamas() > 50000 then
            sale:buyItem(item, 1, 100000)
        end
    end
    global:leaveDialog()

	equiper(tableEquip)
    inventory:equipItem(19629, 11)
    inventory:equipItem(2469, 4)

    map:changeMap("right")

end

local function BuyCityPotions()

    npc:npc(318,6)
    global:delay(1000)
    sale:buyItem(6965,1,20000)
    if inventory:itemCount(6965) < 1 then
        sale:buyItem(6965, 10, 20000)
    end
    sale:buyItem(6964,1,20000)
    if inventory:itemCount(6964) < 1 then
        sale:buyItem(6964, 10, 20000)
    end
    global:delay(1000)
    global:leaveDialog()
    
    inventory:useItem(6965)
end

local function BuyParhoSasa()
	npc:npc(385, 6)

	global:delay(1500)
	
	if inventory:itemCount(802) == 0 then
		sale:buyItem(802, 10, 100000) -- parcho sasa
		sale:buyItem(802, 10, 100000)
	end
	if inventory:itemCount(802) <= 20 then
		for i = 1, 5 do
			sale:buyItem(802, 1, 10000)
		end
	end

	global:leaveDialog()

	for i = 1, 25 do
		inventory:useItem(802)
	end
end

function  _GetBestPriceDDLvl1And100(message)
    BestPrice100 = 0
    BestPrice1 = 0
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)

    for _, element in ipairs(dd) do
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount" and element.effects[1].level == 100 and element.effects[1].isRideable then
            BestPrice100 = element.prices[1] - 1
            break
        end
    end

    for _, element in ipairs(dd) do
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount" and element.effects[1].isRideable then
            BestPrice1 = element.prices[1] - 1
            break
        end
    end
end

function  _BuyCheapestDD(message)
    local dd = message.itemTypeDescriptions

    table.sort(dd, function (a, b)
        return a.prices[1] < b.prices[1]
    end)
    for _, element in ipairs(dd) do
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount"and element.effects[1].isRideable then
            message = developer:createMessage("ExchangeBidHouseBuyMessage")
            message.uid = element.objectUID
            message.qty = 1
            message.price = element.prices[1]

            developer:sendMessage(message)
            developer:suspendScriptUntil("ExchangeBidHouseBuyResultMessage", 2000, true)
            global:leaveDialog()
            break
        end
    end
end

function achatDD()
    if not global:thisAccountController():getAlias():find("LvlUp") then
        local Ids = {7863, 7814, 7856, 7876, 7875, 7874, 7873, 7872, 7871, 7870, 7869, 7868, 7867, 7866, 7865, 7864, 7863,
        7863, 7862, 7861, 7860, 7859, 7858, 7857, 7856, 7855, 7854, 7853, 7852, 7851, 7850, 7849, 7848, 7847, 7846, 7845, 7844, 7843, 7842, 7841, 7840, 7839,
        7838, 7837, 7836, 7835, 7834, 7833, 7832, 7831, 7830, 7829, 7828, 7827, 7826, 7825, 7824, 7823, 7822, 7821, 7820, 7819, 7818, 7817, 7816, 7815, 7814, 7813, 7812, 7811, 7810
    
    }
    if not mount:hasMount() then
            local minPrice = 100000000
            local bestIndex = 1
            for i, Id in ipairs(Ids) do
                HdvBuy()
                local message = developer:createMessage("ExchangeBidHouseSearchMessage")
                message.objectGID = Id
                message.follow = true
                debug("oui")
                developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _GetBestPriceDDLvl1And100)
                developer:sendMessage(message)
                developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)

                global:leaveDialog()

                if BestPrice1 < minPrice and BestPrice1 > 0 then
                    global:printSuccess("la dd la moins chère coute " .. BestPrice1 .. " kamas")
                    bestIndex = i
                    minPrice = BestPrice1
                end
            end
        
            global:printSuccess("On passe à l'achat")
        
            HdvBuy()
            local message = developer:createMessage("ExchangeBidHouseSearchMessage")
            message.objectGID = Ids[bestIndex]
            message.follow = true
            developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _BuyCheapestDD)
            developer:sendMessage(message)
            developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)
        
            global:leaveDialog()
        end
    end

    map:changeMap("bottom")
    -- on a maintenant l'id de la dd qu'il nous faut acheter
end


function equiperDD()
    if not global:thisAccountController():getAlias():find("LvlUp") and not mount:hasMount() then
        equipDD(getUIDOfDD())
        ManageXpMount()
        -- local ddEquipables = GetDDInfLvl100()
        -- map:moveToCell(332)
        -- map:door(357)
        -- developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
        -- local message = developer:createMessage("ExchangeHandleMountsMessage")
        -- debug("ok")
        -- if ddEquipables[1][2] then
        --     message.actionType = 15
        --     message.ridesId = {ddEquipables[1][2]}
        --     developer:sendMessage(message)
        --     developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
        -- end
        -- debug("ok")
        -- global:delay(math.random(500, 1500))
        -- global:leaveDialog()
        -- global:delay(math.random(500, 1500))
        -- if not mount:isRiding() then
        --     mount:toggleRiding()
        -- end
    end
    increment()
    inventory:useItem(6964)
end


function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
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

function move()
        return treatMaps({
            {map = "0,0", path = "zaap(164364304)"},
            {map = "-20,-20", path = "bottom"},
            {map = "-20,-19", path = "bottom"},
            {map = "-20,-18", path = "bottom"},
            {map = "-20,-16", path = "bottom"},
            {map = "-20,-17", path = "bottom"},
            {map = "-20,-15", path = "bottom"},
            {map = "-20,-14", path = "bottom"},
            {map = "-20,-13", path = "bottom"},
            {map = "-24,-11", path = "bottom"},
            {map = "-24,-10", path = "bottom"},
            {map = "-24,-9", path = "bottom"},
            {map = "-24,-8", path = "bottom"},
            {map = "-24,-7", path = "left"},
            {map = "-25,-7", path = "bottom"},
            {map = "-25,-6", path = "right"},
            {map = "-24,-6", path = "bottom"},
            {map = "-24,-5", path = "bottom"},
            {map = "-24,-4", path = "bottom"},
            {map = "-24,-3", path = "bottom"},
            {map = "-24,-2", path = "bottom"},
            {map = "-24,-1", path = "bottom"},
            {map = "-24,0", path = "bottom"},
            {map = "-24,1", path = "bottom"},
            {map = "-24,2", path = "bottom"},
            {map = "-25,3", path = "bottom"},
            {map = "-25,4", path = "bottom"},
            {map = "-25,5", path = "bottom"},
            {map = "-25,6", path = "bottom"},
            {map = "-25,7", path = "bottom"},
            {map = "-25,8", path = "bottom"},
            {map = "-25,9", path = "bottom"},
            {map = "-25,10", path = "bottom"},
            {map = "-25,11", path = "bottom"},
            {map = "-20,-12", path = "left"},
            {map = "-21,-12", path = "left"},
            {map = "-22,-12", path = "left"},
            {map = "-23,-12", path = "left"},
            {map = "-24,-12", path = "bottom"},
            {map = "-24,3", path = "left"},
            {map = "-25,12", custom = function ()
        if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
        elseif global:thisAccountController():getAlias():find("LvlUp") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\zaap_otomai.lua")
        end            end},
        })
end

function bank()
    return move()
end

if not global:remember("lostCounter") then
    global:addInMemory("lostCounter", 0)
end

-- function stopped()
--     if character:energyPoints() > 0 then
--         global:editInMemory("lostCounter", global:remember("lostCounter") + 1)
--         if global:remember("lostCounter") > 10 then
--             global:printError(global:remember("lostCounter") .. " fois que le bot s'arrête, on relance le script")
--             global:editInMemory("ETAPE_ZAAP", 0)
--             global:editInMemory("lostCounter", 0)
--             global:delay(5000)
--             global:thisAccountController():startScript()
--         end
--         global:delay(5000)
--         global:thisAccountController():startScript()
--     end
-- end


function phenix()
	return {
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
		{map = "22,22", custom = function() map:door(387) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
		{map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() map:door(184) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
		{map = "-16,41", path = "top"},
		{map = "-16,40", path = "top"},
		{map = "-16,39", path = "top"},
		{map = "-16,38", path = "top"},
		{map = "-16,37", path = "top"},
		{map = "-13,28", path = "right"},
		{map = "-17,41", path = "right"},
		{map = "-16,36", custom = function() map:door(135) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
		{map = "-9,-54", path = "left"},
		{map = "-10,-54", custom = function() map:door(342) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("havenbag") end},
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
		{map = "-58,18", custom = function() map:door(354) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("right") end},
		{map = "-43,0", custom = function() map:door(259) global:editInMemory("ETAPE_ZAAP", 1) map:changeMap("bottom") end},

		{map = "-3,-13", path = "right"},
        {map = "-2,-13", path = "right"},
        {map = "-1,-13", path = "right"},
        {map = "0,-13", path = "right"},
        {map = "1,-13", path = "right"},
        {map = "2,-13", path = "top"},
        {map = "2,-14", custom = function ()
			map:door(313)
            global:editInMemory("ETAPE_ZAAP", 1)
			map:changeMap("havenbag")
        end},
	}
end


function stopped()
    global:delay(2000)
    global:thisAccountController():startScript()
end