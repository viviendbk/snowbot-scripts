dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")
Buyer = dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\auto_stuff\\classes\\buyer.lua")


local stop = false

local tableEquip = {
	{Type = "amulette", Id = 8262, Emplacement = 0, Equipe = false},
	{Type = "ceinture", Id = 8266, Emplacement = 3, Equipe = false},
	{Type = "cape", Id = 8265, Emplacement = 7, Equipe = false},
	{Type = "bottes", Id = 8264, Emplacement = 5, Equipe = false},
	{Type = "coiffe", Id = 8267, Emplacement = 6, Equipe = false},
	{Type = "anneauGauche", Id = 8263, Emplacement = 2, Equipe = false},
	{Type = "anneauDroit", Id = 2469, Emplacement = 4, Equipe = false}, 
    {Type = "arme", Id = 8827, Emplacement = 1, Equipe = false}, 
	{Type = "bouclier", Id = 18688, Equipe = false, Emplacement = 15},
    {Type = "compagnon", Id = 14966, Emplacement = 28, Equipe = false},

    --{Type = "dokoko", Id = 17078, Emplacement = 9, Equipe = false},
    --{Type = "dofus argenté", Id = 19629, Emplacement = 10, Equipe = false},
    --{Type = "forcené", Id = 13758, Emplacement = 10, Equipe = false}, remplacement du dofus argenté

    {Type = "dofus kaliptus", Id = 8072, Emplacement = 11, Equipe = false},
    {Type = "dofus emeraude", Id = 737, Emplacement = 12, Equipe = false},
    {Type = "dofus cawotte", Id = 972, Emplacement = 14, Equipe = false},
    {Type = "voyageur", Id = 13830, Emplacement = 13, Equipe = false},

}

local function equiper()
	for _, element in ipairs(tableEquip) do
		if inventory:itemCount(element.Id) > 0 then
			inventory:equipItem(element.Id, element.Emplacement)
		end
	end
    inventory:equipItem(17078, 9)
    -- inventory:equipItem(19629, 10)
    inventory:equipItem(13758, 10)
end

function _buyUIDZoth2(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toAnalyse = message.itemTypeDescriptions
    local ZothChasse = {}
    for _, element in ipairs(toAnalyse) do
        for _, effet in ipairs(element.effects) do
            if effet.actionId == 795 then -- c'est une arme de chasse
                ZothChasse[#ZothChasse+1] = {UID = element.objectUID, Price = element.prices[1]}
            end
        end
    end
    global:printSuccess(#ZothChasse)

    table.sort(ZothChasse, function (a, b)
        return a.Price < b.Price
    end)
    
    global:printSuccess("la hache la moins chère vaut " .. ZothChasse[1].Price)

    local message = developer:createMessage("ExchangeBidHouseBuyMessage")
    message.qty = 1
    message.uid = ZothChasse[1].UID
    message.price = ZothChasse[1].Price
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeBidHouseInListUpdatedMessage ", 5000, false, nil, 20)
    global:leaveDialog()
end

local function buyHacheZoth()
    HdvBuy()
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = 8827
    message.follow = true
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _buyUIDZoth2)
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
end


function _buyBouclierTaverne(message)
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")

    local toAnalyse = message.itemTypeDescriptions
    local Boucliers = {}
    for _, element in ipairs(toAnalyse) do
        for _, effet in ipairs(element.effects) do
            if effet.actionId == 2812 and effet.value == 11 then -- 11% de dommages
                Boucliers[#Boucliers+1] = {UID = element.objectUID, Price = element.prices[1]}
            end
        end
    end

    table.sort(Boucliers, function (a, b)
        return a.Price < b.Price
    end)
    
    global:printSuccess("le bouclier le moins cher vaut " .. Boucliers[1].Price)

    local message = developer:createMessage("ExchangeBidHouseBuyMessage")
    message.qty = 1
    message.uid = Boucliers[1].UID
    message.price = Boucliers[1].Price
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeBidHouseInListUpdatedMessage ", 5000, false, nil, 20)
    global:leaveDialog()
    inventory:equipItem(18688, 15)
end

local function buyBouclierTaverne()
    HdvBuy()
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")
    message.objectGID = 18688
    message.follow = true
    developer:unRegisterMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage")
    developer:registerMessage("ExchangeTypesItemsExchangerDescriptionForUserMessage", _buyBouclierTaverne)
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeTypesItemsExchangerDescriptionForUserMessage", 5000, false, nil, 20)
end

local function achatStuff()

    if inventory:itemCount(8827) == 0 then
        buyHacheZoth()
    end

    if inventory:itemCount(18688) == 0 then
        buyBouclierTaverne()
    end

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
    if (inventory:itemCount(13758) == 0) then
        sale:buyItem(13758, 1, 250000)
    end  
    if (inventory:itemCount(737) == 0) then
        sale:buyItem(737, 1, 2000000)
    end  
    if (inventory:itemCount(13830) == 0) then
        sale:buyItem(13830, 1, 2000000)
    end 
    if inventory:itemCount(972) == 0 then
        sale:buyItem(972, 1, 700000)
    end

    global:leaveDialog()

    local items = {}

    for i, element in ipairs(tableEquip) do
		if (inventory:itemCount(element.Id) == 0) and (element.Id ~= 14966) and (element.Id ~= 13830) and (element.Id ~= 737) and element.Id ~= 972 then
			table.insert(items, element.Id)
		end
	end

	buyWorthItem(items)


    global:leaveDialog()

    HdvBuy()

    for i, element in ipairs(tableEquip) do
		if (inventory:itemCount(element.Id) == 0) and (element.Id ~= 14966) and (element.Id ~= 13830) and (element.Id ~= 737) and element.Id ~= 972 then
			sale:buyItem(element.Id, 1, 1000000)
		end
	end

    global:leaveDialog()

    restat()

    upgradeCharacteristics(0, 600, 99)

    map:changeMap("zaapi(212601350)") -- hdv ressource
end


local function achatIdoles()


    local tableIdSorts = {12763, 12729}
    for _, element in ipairs(tableIdSorts) do
        local message = developer:createMessage("SpellVariantActivationRequestMessage")
        message.spellId = element
        developer:sendMessage(message)
    end


    map:changeMap("zaapi(212731651)")
end

local function achatParcho()
    npc:npc(385, 6)
    global:delay(1000)
    while inventory:itemCount(683) < 20 do
        sale:buyItem(683, 10, 100000)
    end
    while inventory:itemCount(683) < 25 do
        sale:buyItem(683, 1, 10000)
    end

    global:delay(1000)
    global:leaveDialog()
    
	for i = 1, 25 do
		inventory:useItem(683)
	end
    map:changeMap("zaapi(212600837)") -- hdv equip
end

function _getUIDCoiffe(message)
    developer:unRegisterMessage("ExchangeBidHouseInListRemovedMessage")
    UIDCoiffe = message.itemUID
end


function _getUIDCape(message)
    developer:unRegisterMessage("ExchangeBidHouseInListRemovedMessage")
    UIDCape = message.itemUID
end

local function achatShushi()
    npc:npc(286, 6)
    UIDCoiffe = 0
    UIDCape = 0
    developer:registerMessage("ExchangeBidHouseInListRemovedMessage", _getUIDCoiffe)
    sale:buyItem(18154, 1, 800000)
    developer:suspendScriptUntil("ExchangeBidHouseInListRemovedMessage", 5000, false, nil, 20)


    developer:registerMessage("ExchangeBidHouseInListRemovedMessage", _getUIDCape)
    sale:buyItem(18155, 1, 800000)
    developer:suspendScriptUntil("ExchangeBidHouseInListRemovedMessage", 5000, false, nil, 20)
    global:leaveDialog()



    equiper()
    inventory:equipItem(18154, 6)
    inventory:equipItem(18155, 7)

    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCoiffe
    message.livingPosition = 6
    message.skinId = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)


    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCoiffe
    message.livingPosition = 6
    message.skinId = 2
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)




    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCape
    message.livingPosition = 7
    message.skinId = 1
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)


    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    message.livingUID = UIDCape
    message.livingPosition = 7
    message.skinId = 2
    developer:sendMessage(message)
    developer:suspendScriptUntil("ObjectModifiedMessage", 5000, false, nil, 20)
    changement1 = true

    global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\dj_kwakwa.lua")
    -- global:finishScript()

end

local trajet = {
    {map = "0,0", path = "zaap(212600323)"},
    {map = "212600323", path = "zaapi(212600839)"}, -- mettre hdv consommable ici
    {map = "212600839", custom = achatParcho},
    {map = "212600837", custom = achatStuff},
    {map = "212601350", custom = achatIdoles},
    {map = "212731651", door = "192"}, -- extérieur cosmétique
    {map = "217064452", custom = achatShushi},
    -- mettre l'achat dd
}


local trajet2 = {
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
    if stop then global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\PL&Zaaps\\Up_Chasseur.lua") end
    if changement1 then
        return treatMaps(trajet2)
    end
    return treatMaps(trajet)
end

function bank()
    mapDelay()
    return move()
end


