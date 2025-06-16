AUTO_DELETE = {2416, 2419, 2422, 2425, 2428, 311 } --j'ai pas suprimé les citrons car ils sont utiles dans certains craft mais on peut le faire

local cptActualiser = 0
local NeedToCraft = 0
local NeedToSell = false
local NeedToBreak = false

--[[
    Atelier 
    0 -> rien
    1 -> bijoutier
    2 -> tailleur
    3 -> cordonier
    4 -> forgerons
    5 -> sculpteurs
    6 -> alchimistes
]]


local TableOutilAtelier = {
    ["Cape"] = {ElementId = 455865, Rep = -1},
    ["Sac à dos"] = {ElementId = 455865, Rep = -2},
    ["Chapeau"] = {ElementId = 455866, Rep = -1},
    ["Amulette"] = {ElementId = 455835, Rep = -2},
    ["Anneau"] = {ElementId = 455835, Rep = -1},
    ["Botte"] = {ElementId = 455863, Rep = -2},
    ["Ceinture"] = {ElementId = 455863, Rep = -1},
    ["Dague"] = {ElementId = 455861, Rep = -1},
    ["Marteau"] = {ElementId = 455861, Rep = -2},
    ["Epee"] = {ElementId = 455861, Rep = -3},
    ["Pelle"] = {ElementId = 455861, Rep = -4},
    ["Hache"] = {ElementId = 455861, Rep = -5},
    ["Baton"] = {ElementId = 455854, Rep = -1},
    ["Baguette"] = {ElementId = 455854, Rep = -2},
    ["Arc"] = {ElementId = 455854, Rep = -3},
}


local TableVente = {
    -- Runes
    {Name = "Rune ga pa", Id = 1557, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune ga pme", Id = 1558, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune ré pme", Id = 11643, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune po", Id = 7438, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune prospe", Id = 7451, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune pa prospe", Id = 10662, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune invo", Id = 7442, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Rune invo", Id = 1548, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    
    --Ressources

    --Bouftou
    {Name = "Cuir de Bouftou Royal", Id = 886, MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true}, 
    {Name = "Laine de bouftou royal", Id = 880 , MaxHdv100 = 0, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},

    --Marecage
    {Name = "Peau de crocodaille", Id = 6739 , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Ecaille de crocodaille", Id = 1663  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true}, 
    {Name = "Boue du boo", Id = 417  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true}, 
    {Name = "Ecaille de chef crocodaille", Id = 1613  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true}, 

    --Moon
    {Name = "Noix de kokoko", Id = 997  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Tronc de kokoko", Id = 1002  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "kole", Id = 1018  , MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Bourgeon de fourbasse", Id = 6736, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Fleur de Gloutovore", Id = 2253, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Poupée Vaudou Archer", Id = 2628, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Poupée Vaudou Jav", Id = 2626, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Poupée Vaudou Thierry", Id = 2625, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Poupée Vaudou Sarbak", Id = 2627, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Pétale de Trukikol", Id = 2602, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Saphir", Id = 466, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Nœud de Marin", Id = 13343, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Rubis", Id = 467, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
    {Name = "Radius de Canon Dorf", Id = 17086, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},

    
    {Name = "Coquille de Dragoeuf Saphir", Id = 1129, MaxHdv100 = 100, MaxHdv10 = 0, MaxHdv1 = 0, CanSell = true},
}

local TableCraftRentable = {

    -- Refaire les tables pour faire en sorte de mettre UNIQUEMENT les Id qu'il faut pas acheter dans ListIdCraftNotToBuy et celles qu'on doit acheter dans ListIdResourcesToBuy
    {Name = "Essence de Bouftou Royal", Id = 15573, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 886, Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 880 , Nb = 3}, 
    }, ListIdResourcesToBuy = {
        {Id = xx, Nb = xx, MaxPrice = xx}
    }, PodsNeededToCraft = 4, Atelier = 6, Type = "Essence"},

	{Name = "Boufbamu", Id = 10836, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 385, Nb = 6}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 887, Nb = 18}, 
        {Id = 1777, Nb = 19}, 
        {Id = 15573, Nb = 1}, 
    }, PodsNeededToCraft = 44, Atelier = 1, Type = "Amulette"}, -- nb de pods qu'il faut pour porter tous les ressources nécessaires à un craft

    {Name = "Coiffe du bouftou", Id = 2411 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 887, Nb = 12}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 881 , Nb = 12}, 
        {Id = 1736 , Nb = 20}, 
        {Id = 383 , Nb = 12}, 
    }, PodsNeededToCraft = 56, Atelier = 2, Type = "Coiffe"},

    {Name = "Essence de Colonimb", Id = 16794, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 535 , Nb = 2}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 15350, Nb = 1},
        {Id = 1847, Nb = 10},
        {Id = 15427, Nb = 3},
        {Id = 15426, Nb = 5},
    }, PodsNeededToCraft = 44, Atelier = 6, Type = "Essence"},

    {Name = "Rasoir de poche", Id = 15385, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 749, Nb = 3}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 17086 , Nb = 23},
        {Id = 16794 , Nb = 1},
        {Id = 15430 , Nb = 21},
        {Id = 13731 , Nb = 6},
    }, PodsNeededToCraft = 96, Atelier = 1, Type = "Amulette"},

    {Name = "Essence de dragon cochon", Id = 15583, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 1966  , Nb = 2}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 487 , Nb = 1},
        {Id = 532 , Nb = 10},
        {Id = 8391 , Nb = 5},
        {Id = 2645 , Nb = 3},
    }, PodsNeededToCraft = 40, Atelier = 6, Type = "Essence"},

    {Name = "Mules du dragon cochon", Id = 8278, MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 8391, Nb = 24}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 17086, Nb = 22},
        {Id = 16294 , Nb = 7},
        {Id = 1918 , Nb = 46},
        {Id = 15583, Nb = 1},
    }, PodsNeededToCraft = 192, Atelier = 3, Type = "Bottes"},

    {Name = "Essence du coffre des forgerons", Id = 17108 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 17106 , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 13140 , Nb = 3},
    }, PodsNeededToCraft = 16, Atelier = 6, Type = "Essence"},

    {Name = "Boffes cottre", Id = 13139 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 6739, Nb = 5}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 383, Nb = 13},
        {Id = 313, Nb = 40},
        {Id = 17108 , Nb = 1},
    }, PodsNeededToCraft = 264, Atelier = 3, Type = "Bottes"},

    {Name = "Pantoufles Crochues du Chef Crocodaille", Id = 6825 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 17108, Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 2556, Nb = 7},
        {Id = 1663, Nb = 26},
        {Id = 1770, Nb = 27},
        {Id = 594, Nb = 46},
    }, PodsNeededToCraft = 211, Atelier = 3, Type = "Bottes"},

    {Name = "Amulette du Chef Crocodaille", Id = 6817 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 1129, Nb = 30}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 17102, Nb = 1},
        {Id = 748, Nb = 1},
        {Id = 2556, Nb = 8},
        {Id = 1663, Nb = 27},
    }, PodsNeededToCraft = 304, Atelier = 1, Type = "Amulette"},

    {Name = "Essence de Mob l Eponge", Id = 17102 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 1129, Nb = 30}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 17102, Nb = 1},
        {Id = 748, Nb = 1},
        {Id = 2556, Nb = 8},
        {Id = 1663, Nb = 27},
    }, PodsNeededToCraft = 211, Atelier = 6, Type = "Essence"},

    {Name = "Sabots de Farle", Id = 6774 , MaxHdv1 = 2, CanCraft = false, ListIdCraftNotToBuy = {
        {Id = 2625, Nb = 20}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 843, Nb = 25},
        {Id = 1613, Nb = 22},
        {Id = 8801, Nb = 6},
        {Id = 15576, Nb = 1},
    }, PodsNeededToCraft = 282, Atelier = 3, Type = "Bottes"},

}

---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
local function get_quantity(id)
    if object_in_hdv then
        local informations = {
            id = id,
            quantity = {
                ["1"] = 0,
                ["10"] = 0,
                ["100"] = 0
            },
            total_quantity = 0,
            total_lots = 0,
        }

        for _, info in ipairs(object_in_hdv) do
            if info.id == id then
                informations.quantity["1"] = info.quantity["1"]
                informations.quantity["10"] = info.quantity["10"]
                informations.quantity["100"] = info.quantity["100"]
                informations.total_quantity = info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
                informations.total_lots = info.quantity["1"] + info.quantity["10"] + info.quantity["100"]
            end
        end

        return informations
    else
        global:printError("[INFO] - l'HDV n'a pas été scanné je ne peux donc pas resortir les quantités demandées.")
    end
end

---Fonction qui permet de scanner l'hotel de vente.
local function stack_items_informations(message)
    message = developer:toObject(message)
    object_in_hdv = {}
    may_add_id = true

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                may_add_id = false

                break
            end
        end

        if may_add_id then
            table.insert(object_in_hdv,{ id = item.objectGID, quantity = {["1"] = 0, ["10"] = 0, ["100"] = 0}})
        end

        may_add_id = true
    end

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                info.quantity[tostring(item.quantity)] = info.quantity[tostring(item.quantity)] + 1
            end
        end
    end
end

local function isWhitelisted(id)
	local lAccounts = ankabotController:getLoadedAccounts()
    for _, account in ipairs(lAccounts) do
        if account.character:id() == id then
        	return true
        end
    end
    return false
end

local function _ExchangeRequestedTradeMessage(message)
	message = developer:toObject(message)
	-- Check
	if not isWhitelisted(message.source) then
		global:printError("Échange reçu de la part d'un joueur inconnu, on refuse !")
		global:leaveDialog()
		return
	end
	-- Accept
	global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
	developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
end

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
	developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
end

local function Selling()

    table.sort(TableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    npc:npcSale()

    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true)


    for _, element in ipairs(TableVente) do
        if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

        cpt = get_quantity(element.Id).quantity["100"]
        local Priceitem = sale:getPriceItem(element.Id, 3)
        Priceitem = ((Priceitem == nil) or (Priceitem == 0) or (Priceitem == 1)) and sale:getAveragePriceItem(element.Id, 3) * 1.5 or Priceitem
        while (inventory:itemCount(element.Id) >= 100) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv100) do 
            sale:SellItem(element.Id, 100, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        Priceitem = sale:getPriceItem(element.Id, 2)
        Priceitem = ((Priceitem == nil) or (Priceitem == 0) or (Priceitem == 1)) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
        while (inventory:itemCount(element.Id) >= 10) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv10) do 
            sale:SellItem(element.Id, 10, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(element.Id) .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["1"]
        Priceitem = sale:getPriceItem(element.Id, 1)
        Priceitem = ((Priceitem == nil) or (Priceitem == 0) or (Priceitem == 1)) and sale:getAveragePriceItem(element.Id, 1) * 1.5 or Priceitem
        while (inventory:itemCount(element.Id) >= 1) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv1) do 
            element.MaxHdv1 =  (Priceitem < 100) and 0 or element.MaxHdv1
            sale:SellItem(element.Id, 1, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    if cptActualiser >= 2 and not hdvActualise and character:kamas() > 150000 then
        global:printSuccess("Actualisation des prix")
        hdvActualise = true
        cptActualiser = 0
        sale:updateAllItems()
        global:leaveDialog()
        npc:npcSale()
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
	
	npc:npcSale()

	-- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
	for _, element in ipairs(TableVente) do
		if (get_quantity(element.Id).quantity["100"] >= element.MaxHdv100) and (get_quantity(element.Id).quantity["10"] >= element.MaxHdv10) and (get_quantity(element.Id).quantity["1"] >= element.maxHdv1) then
			element.CanSell = false
		else
			element.CanSell = true
		end
	end
    global:leaveDialog()

    ScanBank()
end

local function Achat(IdItem, qtt)
    npc:npcBuy()
    global:delay(500)

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    while qtt > 0 do           
        if qtt >= 100 then
            sale:buyItem(IdItem, 100, 20000)
            qtt = qtt - 100             
        elseif qtt >= 10 and qtt < 100 then
            sale:buyItem(IdItem, 10, 2000)
            qtt = qtt - 10 
        elseif qtt >= 1 and qtt < 10 then
            sale:buyItem(IdItem, 1, 200)
            qtt = qtt - 1 
        end
    end

    global:leaveDialog()

    if inventory:itemCount(IdItem) < NbDeBdase + Quantite then
        local difference = NbDeBdase + Quantite - inventory:itemCount(IdItem)
        if difference >= 10 and difference < 100 then
            return Achat(IdItem, 100)
        elseif difference > 99 then
            for i = 1, math.floor(difference / 10) do
                Achat(IdItem, 10)
            end
        elseif difference < 10 then
            return Achat(IdItem, 10)
        end
    end
end

local function ProcessCraft(elementId, rep, cellId)
    NeedToCraft = 0
    map:useById(elementId, rep)
	global:delay(500)
	
    for _, element in ipairs(TableCraftRentable) do
        if element.CanCraft then
            element.CanCraft = false
            for _, data in ipairs(element.ListIdCraftNotToBuy) do
                CraftQuantity = math.min(CraftQuantity, inventory:itemCount(data.Id) / data.Nb)
                craft:putItem(data.Id, data.Nb)
            end
            for _, data in ipairs(element.ListIdResourcesToBuy) do
                CraftQuantity = math.min(CraftQuantity, inventory:itemCount(data.Id) / data.Nb)
                craft:putItem(data.Id, data.Nb)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(500)
            craft:ready()
            global:delay(500)
            break
        end
    end

    global:leaveDialog()

    global:delay(500)

    map:moveToCell(cellId)
end

function ScanBank()
    inventory:openBank()

    if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	

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
        local cpt = 0
        for _, element in ipairs(TableVente) do
            local podsAvailable = inventory:podsMax() - inventory:pods()
            local TotalMax = element.MaxHdv100 * 100 + element.MaxHdv10 * 10 + element.MaxHdv1
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.Id)))
            if ((element.MaxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.MaxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
        NeedToSell = cpt > 5
    end

    if NeedToSell then
        global:leaveDialog()
        return Selling()
    end

    -- si on a plus rien à vendre, on va craft-briser des items

    for _, element in ipairs(TableCraftRentable) do
        element.CanCraft = true

        for _, data in ipairs(element.ListIdCraftNotToBuy) do
            if not (exchange:storageItemQuantity(data.Id) >= 50) or (NeedToCraft > 0) then
                element.CanCraft = false
                break
            end
        end
        if element.CanCraft and (NeedToCraft == 0) then
            local podsAvailable = inventory:podsMax() - inventory:pods()

            CraftQuantity = math.floor(podsAvailable / element.PodsNeededToCraft)

            for _, data in ipairs(element.ListIdCraftNotToBuy) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(data.Id) / data.Nb))
            end   
            
            if CraftQuantity >= 5 then
                NeedToCraft = element.Atelier
                typeCraft = element.Type
                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")

                for _, data in ipairs(element.ListIdCraft) do
                    exchange:getItem(data.Id, CraftQuantity * data.Nb)
                end
                for _, data in ipairs(element.ListIdResourcesToBuy) do
                    if exchange:storageItemQuantity(data.Id) > 0 then
                        exchange:getItem(data.Id, math.min(exchange:storageItemQuantity(data.Id), CraftQuantity * data.Nb))
                    end
                end
            end
        end
    end

    global:leaveDialog()

    for _, element in ipairs(TableCraftRentable) do
        if element.CanCraft then
            for _, data in ipairs(element.ListIdResourcesToBuy) do
                if inventory:itemCount(data.Id) * data.Nb < CraftQuantity then
                    local amountNeeded = CraftQuantity - inventory:itemCount(data.Id) * data.Nb
                    global:printSuccess("Besoin d'acheter " .. amountNeeded .. " x item d'id " .. data.Id)
                    Achat(data.Id, amountNeeded)
                end
            end
        end
    end
    

end

function move()
    -- pour chaque trajet, faire le trajet de n'importe quel atelier à l'autre + le trajet partant de la milice bonta et du zaap bonta
    if NeedToCraft == 1 then
        return {
            { map = "-29,-56", path = "zaapi(148797)" },
            { map = "-29,-58", path = "zaapi(148797)" },
            { map = "-28,-55", path = "zaapi(148797)" },
            { map = "-28,-61", path = "zaapi(148797)" },
            { map = "-29,-53", path = "zaapi(148797)" },
            { map = "-32,-56", path = "zaapi(148797)" },
            { map = "148797", door = "510" },
            {map = "3145733", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep, 396)} -- xxx = mapId de l'atelier intérieur, 111 = elementId du truc qu'on utilse pour craft, 222 = cellId pour sortir de l'atelier
        }
    end
    if NeedToCraft == 2 then
        return {
            { map = "-34,-61", path = "zaapi(146232)" },
            { map = "-29,-58", path = "zaapi(146232)" },
            { map = "-28,-55", path = "zaapi(146232)" },
            { map = "-28,-61", path = "zaapi(146232)" },
            { map = "-29,-53", path = "zaapi(146232)" },
            { map = "-32,-56", path = "zaapi(146232)" },
            { map = "146232", door = "329" },
            {map = "7864327", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep, 396)} --chapeau xxx = mapId de l'atelier intérieur, 111 = elementId du truc qu'on utilse pour craft, 222 = cellId pour sortir de l'atelier
        }
    end
    if NeedToCraft == 3 then
        return {
            { map = "-34,-61", path = "zaapi(146234)" },
            { map = "-29,-56", path = "zaapi(146234)" },
            { map = "-28,-55", path = "zaapi(146234)" },
            { map = "-28,-61", path = "zaapi(146234)" },
            { map = "-29,-53", path = "zaapi(146234)" },
            { map = "-32,-56", path = "zaapi(146234)" },
            { map = "146234", door = "352" },
            {map = "7864328", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep 424)} 
        }
    end
    if NeedToCraft == 4 then
        return {
            { map = "-34,-61", path = "zaapi(145719)" },
            { map = "-29,-56", path = "zaapi(145719)" },
            { map = "-29,-58", path = "zaapi(145719)" },
            { map = "-28,-61", path = "zaapi(145719)" },
            { map = "-29,-53", path = "zaapi(145719)" },
            { map = "-32,-56", path = "zaapi(145719)" },
            { map = "145719", door = "495" },
            {map = "7340038", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep, 408)} 
        }
    end
    if NeedToCraft == 5 then
        return {

            { map = "-34,-61", path = "zaapi(145725)" },
            { map = "-29,-56", path = "zaapi(145725)" },
            { map = "-29,-58", path = "zaapi(145725)" },
            { map = "-28,-55", path = "zaapi(145725)" },
            { map = "-29,-53", path = "zaapi(145725)" },
            { map = "-32,-56", path = "zaapi(145725)" },
            { map = "145725", door = "116" },
            {map = "6815750", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep, 437)} 
        }
    end
    if NeedToCraft == 6 then
        return {
            { map = "-34,-61", path = "zaapi(146229)" },
            { map = "-29,-56", path = "zaapi(146229)" },
            { map = "-29,-58", path = "zaapi(146229)" },
            { map = "-28,-55", path = "zaapi(146229)" },
            { map = "-28,-61", path = "zaapi(146229)" },
            { map = "-32,-56", path = "zaapi(146229)" },
            { map = "146229", door = "303" },
            {map = "2884113", custom = ProcessCraft(TableOutilAtelier[typeCraft].ElementId, TableOutilAtelier[typeCraft].Rep, 382)} 
        }
    end
    if NeedToBreak then
        return {

        }
    end
    ScanBank()

end

function bank()
    return move()
end