dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")
Buyer = dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\auto_stuff\\classes\\buyer.lua")



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

	Buyer:many(items)

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

    global:printSuccess("o")
	Buyer:many(items)
    global:printSuccess("oss")

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
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].level == 100 and element.effects[1].isRideable then
            BestPrice100 = element.prices[1] - 1
            break
        end
    end
    for _, element in ipairs(dd) do
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].isRideable then
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
        if #element.effects > 0 and developer:typeOf(element.effects[1]) == "ObjectEffectMount" and element.effects[1].isRideable then
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
        local minPrice = 100000000
        local bestIndex = 1
        for i, Id in ipairs(Ids) do
            HdvBuy()
            local message = developer:createMessage("ExchangeBidHouseSearchMessage")
            message.objectGID = Id
            message.follow = true
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

    map:changeMap("bottom")
    -- on a maintenant l'id de la dd qu'il nous faut acheter
end


function equiperDD()
    if not global:thisAccountController():getAlias():find("LvlUp") then
        local ddEquipables = GetDDInfLvl100()
        map:moveToCell(332)
        map:door(357)
        developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
        local message = developer:createMessage("ExchangeHandleMountsMessage")
        if ddEquipables[1][2] then
            message.actionType = 15
            message.ridesId = {ddEquipables[1][2]}
            developer:sendMessage(message)
            developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
        end
        global:delay(math.random(500, 1500))
        global:leaveDialog()
        global:delay(math.random(500, 1500))
        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end
    increment()
    inventory:useItem(6964)
end

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
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

function move()
    -- global:printSuccess("ETAPE_ZAAP : " .. global:remember("ETAPE_ZAAP"))
    if character:level() == 1 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\PL_1-6X.lua")
    end
    mapDelay()
    if getRemainingSubscription(true) <= 0 and character:kamas() > (character:server() == "Draconiros"  and 700000 or 1200000) then
        global:printSuccess("il reste " .. getRemainingSubscription(true) .. "jours d'abonnement, on tente de s'abonner à nouveau")
        Abonnement()
    end

	-- if job:level(24) >= 6 or job:level(2) >= 6 or map:currentSubArea() == "Carrière d'Astrub" then
    --     global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
	-- elseif character:level() > 70 and global:thisAccountController():getAlias():find("LvlUp") then
    --     global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\PL_6X-114.lua")
    -- end

    if global:thisAccountController():getAlias():find("Draconiros") and not character:server():find("Draconiros") then
        global:thisAccountController():forceDelete(character:name())
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
    end
    
    if global:remember("ETAPE_ZAAP") == 0 then
        if map:currentArea() ~= "Astrub" and not map:onMap("0,0") then
            map:changeMap("havenbag")
        elseif map:currentArea() ~= "Astrub" then
            map:changeMap("zaap(191105026)")
        end
        if map:onMap(192415750) then
            map:moveToCell(409)
        end
        GoTo("3,-19", function() 
            increment() 
            BuyCityPotions() 
        end)
    elseif global:remember("ETAPE_ZAAP") == 1 then -- bonta 1/2
        global:printSuccess("ok")
        if map:onMap(192415750) then
            map:moveToCell(409)
        end
        if map:currentArea() == "Astrub" then
            global:editInMemory("ETAPE_ZAAP", 0)
        end
        return {
        

            --map equipementoù on achète les stuffs
            --map ressource où on archète les idoles si besoin
            {map = "217318404", door = "463"},
            {map = "217317382", door = "546"},
            {map = "212599810", path = "right"},
            {map = "-31,-57", path = "bottom"},
            {map = "-31,-56", path = "bottom"},
            {map = "-31,-55", custom = function ()
                if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
                    BuyStuff()
                elseif global:thisAccountController():getAlias():find("Requests") then
                    global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Craft\\GetAllPrices.lua")
                else
                    BuyStuff114()
                end 
            end},
            {map = "-30,-55", path = "bottom"},
            {map = "-30,-54", custom = function ()
                if not global:thisAccountController():getAlias():find("Mineur") and not global:thisAccountController():getAlias():find("Bucheron") then
                    BuyIdoles()
                end
                global:printSuccess("Hdv Ressources")
                map:changeMap("zaapi(212731651)")
            end},
            {map = "-35,-60", path = "zaapi(212600839)"},
            {map = "-31,-53", custom = function ()
                if global:thisAccountController():getAlias():find("LvlUp") then
                    BuyParhoSasa()
                end
                global:printSuccess("Parcho sasa")
                map:changeMap("zaapi(212601345)")
            end},
            {map = "212601345", custom = achatDD},
            {map = "212601346", custom = equiperDD},
            {map = "-34,-54", path = "top"},
            {map = "-34,-55", path = "left"},
            {map = "212598789", custom = function()
                increment()
                map:door(89)
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 2 then -- bonta 2/2 & brakmar 1/3
        return {
            {map = "216401666", door = "390"},
            {map = "212598789", path = "right"},
            {map = "-34,-55", path = "bottom"},
            {map = "-34,-54", path = "zaapi(212601345)"},
            {map = "-30,-59", path = "top"},
            {map = "-30,-60", path = "right"},
            {map = "-29,-61", path = "top"},
            {map = "-29,-62", path = "top"},
            {map = "-29,-63", path = "right"},
            {map = "-28,-63", path = "right"},
            {map = "-27,-63", path = "right"},
            {map = "-26,-63", path = "right"},
            {map = "-25,-63", path = "right"},
            {map = "-24,-63", path = "right"},
            {map = "-23,-63", path = "bottom"},
            {map = "-23,-62", custom = function ()
                inventory:useItem(6964)
            end},
            {map = "216530944", door = "521"},
            {map = "212862464", path = "left"},
            {map = "-26,33", path = "zaapi(212860931)"},
            {map = "-28,36", path = "right"},
            {map = "-26,37", path = "zaapi(212862469)"},
            {map = "-25,38", path = "bottom"},
            {map = "212862470", custom = function()
                increment()
                map:door(233)
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 3 then -- brakmar 2/3
        return {
            {map = "216924682", door = "233"},
            {map = "212862470", path = "bottom"},
            {map = "-25,40", custom = function ()
                increment()
                map:changeMap("left")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 4 then --brakmar 3/3
        return {
            {map = "-26,41", path = "right"},
            {map = "-25,40", path = "top"},
            {map = "-25,39", path = "top"},
            {map = "-25,38", path = "zaapi(212864004)"},
            {map = "-22,37", path = "top"},
            {map = "-22,36", path = "right"},
            {map = "-21,36", path = "right"},
            {map = "-19,37", path = "right"},
            {map = "-18,37", path = "bottom"},
            {map = "-18,38", path = "bottom"},
            {map = "-18,39", path = "right"},
            {map = "-17,39", path = "havenbag"},
            {map = "0,0", custom = function ()
                increment()
                map:changeMap("zaap(191105026)")
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 5 then
        if map:onMap(70778880) then
            map:moveToCell(443)
        end
        GoTo("-2,0", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 6 then
        GoTo("-1,13", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 7 then
        GoTo("-1,24", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 8 then
        GoTo("10,22", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 9 then
        GoTo("5,7", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 10 then
        GoTo("7,-4", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 11 then
        GoTo("12,-6", function ()
            increment()
            npc:npc(3464,3)
            npc:reply(-1)
        end)
    elseif global:remember("ETAPE_ZAAP") == 12 then
        GoTo("15,-58", function ()
            increment()
            map:changeMap("zaap(191105026)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 13 then
        GoTo("-5,-23", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 14 then
        GoTo("-13,-28", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 15 then
        GoTo("-3,-42", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 16 then
        GoTo("-9,-43", function ()
            increment()
            map:changeMap("top")
        end)
    elseif global:remember("ETAPE_ZAAP") == 17 then
        GoTo("0,-56", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 18 then
        GoTo("-12,-60", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 19 then
        GoTo("-17,-47", function ()
            increment()
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_ZAAP") == 20 then
        GoTo("-27,-36", function ()
            increment()
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_ZAAP") == 21 then
        GoTo("-20,-20", function ()
            increment()
            map:changeMap("bottom")
        end)
    elseif global:remember("ETAPE_ZAAP") == 22 then
        GoTo("-36,-10", function ()
            increment()
            npc:npc(770, 3) 
            npc:reply(-1) 
            npc:reply(-1) 
            npc:reply(-1) 
        end)
    elseif global:remember("ETAPE_ZAAP") == 23 then
        GoTo("152849", function ()
            increment()
            npc:npc(783, 3)
            npc:reply(-1)
        end)
    elseif global:remember("ETAPE_ZAAP") == 24 then
        GoTo("34476296", function ()
            increment()
            map:door(218)
        end)
    elseif global:remember("ETAPE_ZAAP") == 25 then

        return {
            {map = "136316674", door = "402"},
            {map = "34476296", custom = function ()
                npc:npc(783, 3)
                npc:reply(-2)
                npc:reply(-1)
            end},
            {map = "152849", path = "top"},
            {map = "-43,-17", path = "bottom"},
            {map = "-43,-18", path = "bottom"},
            {map = "-43,-19", path = "bottom"},
            {map = "-40,-19", path = "bottom"},
            {map = "-40,-18", path = "bottom"},
            {map = "-40,-17", path = "bottom"},
            {map = "-40,-16", path = "left"},
            {map = "-41,-16", path = "left"},
            {map = "-42,-16", path = "left"},
            {map = "-41,-17", path = "left"},
            {map = "-41,-18", path = "left"},
            {map = "-42,-18", path = "left"},
            {map = "-41,-19", path = "left"},
            {map = "-42,-19", path = "left"},
            {map = "-43,-16", custom = function() 
                increment()
                npc:npc(770, 3) 
                npc:reply(-1) 
                npc:reply(-1) 
            end}
        }
    elseif global:remember("ETAPE_ZAAP") == 26 then
        return {
            {map = "-36,-10", path = "right"},
            {map = "-35,-10", path = "right"},
            {map = "-34,-10", path = "right"},
            {map = "-33,-10", path = "right"},
            {map = "-32,-10", path = "top"},
            {map = "-32,-11", path = "top"},
            {map = "-32,-13", path = "top"},
            {map = "-32,-12", path = "top"},
            {map = "-32,-14", path = "top"},
            {map = "-32,-15", path = "left"},
            {map = "-33,-15", path = "left"},
            {map = "167380484",custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-46,-25", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-65,-21", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map ="-83,-31", custom = function ()
                npc:npc( 1236,3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
            end},
			{map = "-81,-37", custom = function ()
                npc:npc( 1236,3)
                global:leaveDialog()
                map:changeMap("right")
            end},
            {map = "-80,-38", path = "right"},
			{map = "-79,-38", path = "right"},
			{map = "-78,-38", path = "top"},
			{map = "-78,-39", path = "top"},
			{map = "-78,-40", path = "top"},
			{map = "-78,-41", custom = function ()
                increment()
                map:changeMap("zaap(164364304)")
            end},
        }
    elseif global:remember("ETAPE_ZAAP") == 27 then
        GoTo("-25,12", function ()
            increment()
            map:changeMap("zaap(164364304)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 28 then
        GoTo("-16,1", function ()
            increment()
            map:changeMap("zaap(191105026)")
        end)
    elseif global:remember("ETAPE_ZAAP") == 29 then
        if global:thisAccountController():getAlias():find("Mineur") or global:thisAccountController():getAlias():find("Bucheron") then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
        elseif global:thisAccountController():getAlias():find("LvlUp") then
            global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\zaap_otomai.lua")
        end
    end
end



if not global:remember("lostCounter") then
    global:addInMemory("lostCounter", 0)
end

function stopped()
    if character:energyPoints() > 0 then
        global:editInMemory("lostCounter", global:remember("lostCounter") + 1)
        if global:remember("lostCounter") > 10 then
            global:printError(global:remember("lostCounter") .. " fois que le bot s'arrête, on relance le script")
            global:editInMemory("ETAPE_ZAAP", 0)
            global:editInMemory("lostCounter", 0)
            global:delay(5000)
            global:thisAccountController():startScript()
        end
        global:delay(5000)
        global:thisAccountController():startScript()
    end
end


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