dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")

PATH = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\auto_stuff"
local Buyer = dofile(PATH .. "\\classes\\buyer.lua")


local stop = false

local tableEquip = {
	{Type = "amulette", Id = 9149, Emplacement = 0, Equipe = false},
	{Type = "ceinture", Id = 9167, Emplacement = 3, Equipe = false},
	{Type = "cape", Id = 8265, Emplacement = 7, Equipe = false},
	{Type = "bottes", Id = 9158, Emplacement = 5, Equipe = false},
	{Type = "coiffe", Id = 8267, Emplacement = 6, Equipe = false},
	{Type = "anneauGauche", Id = 9122, Emplacement = 2, Equipe = false},
	{Type = "anneauDroit", Id = 2469, Emplacement = 4, Equipe = false}, 
    {Type = "arme", Id = 1162, Emplacement = 1, Equipe = false}, 
	--{Type = "bouclier", Id = 18690, Equipe = false, Emplacement = 15},
    --{Type = "compagnon", Id = 14966, Emplacement = 28, Equipe = false},

    --{Type = "dokoko", Id = 17078, Emplacement = 9, Equipe = false},
    {Type = "dofus argenté", Id = 19629, Emplacement = 10, Equipe = false},
    --{Type = "dofus kaliptus", Id = 8072, Emplacement = 11, Equipe = false}
}


local function equiper()
	for _, element in ipairs(tableEquip) do
		if inventory:itemCount(element.Id) > 0 then
			inventory:equipItem(element.Id, element.Emplacement)
		end
	end
    inventory:equipItem(17078, 9)
    inventory:equipItem(19629, 10)
end


local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

local function achatStuff()
    npc:npc(333, 6)

    -- if (inventory:itemCount(14966) == 0) then
    --     sale:buyItem(14966, 1, 1000000)
    -- end
    -- if (inventory:itemCount(17078) == 0) then
    --     sale:buyItem(17078, 1, 200000)
    -- end
    -- if (inventory:itemCount(19629) == 0) then
    --     sale:buyItem(19629, 1, 200000)
    -- end  

    for i, element in ipairs(tableEquip) do
        if inventory:itemCount(element.Id) == 0 then
            sale:buyItem(element.Id, 1, 1000000)
        end
	end

    global:leaveDialog()
    npc:npc(333, 6)

    for i, element in ipairs(tableEquip) do
        if inventory:itemCount(element.Id) == 0 then
            sale:buyItem(element.Id, 1, 1000000)
        end
	end
    local items = {}

    -- for i, element in ipairs(tableEquip) do
	-- 	if (inventory:itemCount(element.Id) == 0) and (element.Id ~= 14966) and (element.Id ~= 18690) then
	-- 		table.insert(items, element.Id)
	-- 	end
	-- end
	-- Buyer:many(items)

    global:leaveDialog()
    equiper()

    restat()

    upgradeCharacteristics(0, 0,  0, calculCharacteristicsPointsToSet(character:level() * 5 - 5))
    
    map:changeMap("right")
end

local function achatIdoles()

    map:changeMap("zaapi(212601345)")
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
        if #element.effects > 0 and tostring(element.effects[1]) == "SwiftBot.ObjectEffectMount" and element.effects[1].isRideable then
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

    local Ids = {7863, 7814, 7856}
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


    HdvBuy()
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = Ids[bestIndex]
    message.follow = true
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _BuyCheapestDD)
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 2000, true)

    global:leaveDialog()
    map:changeMap("bottom")
    -- on a maintenant l'id de la dd qu'il nous faut acheter
end


function equiperDD()    
    equipDD(getUIDOfDD())
    ManageXpMount()
    global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
end

local trajet = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "bottom"},
    {map = "-31,-55", lockedCustom = achatStuff},
    {map = "-30,-55", path = "bottom"},
    {map = "-30,-54", lockedCustom = achatIdoles},
    {map = "-30,-59", lockedCustom = achatDD},
    {map = "212601346", lockedCustom = equiperDD}
}


function move()
    if job:level(24) > 5 or job:level(2) > 5 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\quete_pandala.lua")
    end
    
    mapDelay()
    if stop then global:disconnect() end
    return treatMaps(trajet)
end

function bank()
    return move()
end
