dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


local stop = false

local tableEquip = {
	{Type = "amulette", Id = 8262, Emplacement = 0, Equipe = false},
	{Type = "ceinture", Id = 8266, Emplacement = 3, Equipe = false},
	{Type = "cape", Id = 8265, Emplacement = 7, Equipe = false},
	{Type = "bottes", Id = 8264, Emplacement = 5, Equipe = false},
	{Type = "coiffe", Id = 8267, Emplacement = 6, Equipe = false},
	{Type = "anneauGauche", Id = 8263, Emplacement = 2, Equipe = false},
	{Type = "anneauDroit", Id = 2469, Emplacement = 4, Equipe = false}, 
    {Type = "arme", Id = 462, Emplacement = 1, Equipe = false}, 
	{Type = "bouclier", Id = 18690, Equipe = false, Emplacement = 15},
    {Type = "compagnon", Id = 14966, Emplacement = 28, Equipe = false},

    --{Type = "dokoko", Id = 17078, Emplacement = 9, Equipe = false},
    --{Type = "dofus argenté", Id = 19629, Emplacement = 10, Equipe = false},
    {Type = "dofus kaliptus", Id = 8072, Emplacement = 11, Equipe = false}
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

local function achatStuff()
    npc:npc(333, 6)

    if (inventory:itemCount(14966) == 0) then
        sale:buyItem(14966, 1, 1000000)
    end
    if (inventory:itemCount(17078) == 0) then
        sale:buyItem(17078, 1, 200000)
    end
    if (inventory:itemCount(19629) == 0) then
        sale:buyItem(19629, 1, 200000)
    end  


    global:leaveDialog()

    local items = {}

    for i, element in ipairs(tableEquip) do
		if (inventory:itemCount(element.Id) == 0) and (element.Id ~= 14966) and (element.Id ~= 18690) then
			table.insert(items, element.Id)
		end
	end
    if character:server() == "Draconiros" and inventory:itemCount(18690) == 0 then
        table.insert(items, 18690)
    end

    for _, element in ipairs(items) do
        if inventory:itemCount(element) == 0 then
            buyWorthItem(element, 1000000)
        end
    end
	buyWorthItem(items)

    global:leaveDialog()

    HdvBuy()

    for i, element in ipairs(tableEquip) do
		if (inventory:itemCount(element.Id) == 0) and (element.Id ~= 14966) and (element.Id ~= 18690) then
			sale:buyItem(element.Id, 1, 1000000)
		end
	end
    global:leaveDialog()

    equiper()


    
    map:changeMap("right")
end

local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

local function achatIdoles()
    restat()
    upgradeCharacteristics(0, 700, 0, 0, 0, 10)

    local tableIdSorts = {{Id = 12725, Lvl = 110}, {Id = 12751, Lvl = 170}, {Id = 12729, Lvl = 145}, {Id = 12763, Lvl = 140}}
    for _, element in ipairs(tableIdSorts) do
        if character:level() >= element.Lvl then
            message = developer:createMessage("SpellVariantActivationRequestMessage")
            message.spellId = element.Id
            developer:sendMessage(message)
        end
    end

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
        if BestPrice1 < minPrice then
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
    local ddEquipables = GetDDInfLvl100()
    map:moveToCell(332)
    map:door(357)
    developer:suspendScriptUntil("ExchangeStartOkMountWithOutPaddockMessage", 5000, true)
    local message = developer:createMessage("ExchangeHandleMountsMessage")
    message.actionType = 15
    message.ridesId = {ddEquipables[1][2]}
    developer:sendMessage(message)
    developer:suspendScriptUntil("InventoryWeightMessage", 2000, true)
    global:delay(math.random(500, 1500))
    global:leaveDialog()
    global:delay(math.random(500, 1500))
    ManageXpMount()
    global:disconnect()
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

local function treatMaps(maps)

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

    return {{map = map:currentMap(), path = "havenbag"}}
end

function move()
    mapDelay()
    if stop then global:disconnect() end
    return treatMaps(trajet)
end

function bank()
    mapDelay()
    return move()
end