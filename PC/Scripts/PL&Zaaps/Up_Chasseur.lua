dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


if not global:remember("VidageBanqueFait") then
	global:addInMemory("VidageBanqueFait", job:level(41) > 30)
end

local tableCraft = {
    {Name = "Boulette de Viande", Id = 17168, MaxHdv10 = 10, MaxHdv1 = 15, Level = 10, ListIdCraft = {
        {Id = 17123, Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
    }, PodsNeededToCraft = 3},
    {Name = "Beignet Astrubien", Id = 17169, MaxHdv10 = 10, MaxHdv1 = 15, Level = 20, ListIdCraft = {
        {Id = 17124, Nb = 1},
        {Id = 289, Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
    }, PodsNeededToCraft = 5},
    {Name = "Roulade de Carne", Id = 17171, MaxHdv10 = 10, MaxHdv1 = 15, Level = 30, ListIdCraft = {
        {Id = 17126 , Nb = 1},
        {Id = 289  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
    }, PodsNeededToCraft = 5},
    {Name = "Papillote au Citron", Id = 17173, MaxHdv10 = 10, MaxHdv1 = 15, Level = 40, ListIdCraft = {
        {Id = 17128  , Nb = 1},
        {Id = 400  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1736  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Salade Sufokienne", Id = 17175, MaxHdv10 = 10, MaxHdv1 = 15, Level = 50, ListIdCraft = {
        {Id = 17130  , Nb = 1},
        {Id = 400  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1974  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Friture Amaknéenne", Id = 17177, MaxHdv10 = 10, MaxHdv1 = 15, Level = 60, ListIdCraft = {
        {Id = 17132  , Nb = 1},
        {Id = 533  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1973  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Parmentier à l'Oignon", Id = 17179, MaxHdv10 = 10, MaxHdv1 = 15, Level = 70, ListIdCraft = {
        {Id = 17134  , Nb = 1},
        {Id = 533  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1975  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Terrine Bontarienne", Id = 17181, MaxHdv10 = 10, MaxHdv1 = 15, Level = 80, ListIdCraft = {
        {Id = 17136  , Nb = 1},
        {Id = 401  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1983  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Pot-au-feu Goûteux", Id = 17183, MaxHdv10 = 10, MaxHdv1 = 15, Level = 90, ListIdCraft = {
        {Id = 17138  , Nb = 1},
        {Id = 401 , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1731  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Poêlée Paysanne", Id = 17185, MaxHdv10 = 10, MaxHdv1 = 15, Level = 100, ListIdCraft = {
        {Id = 17140  , Nb = 1},
        {Id = 423  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 2331  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Pemmican aux Haricots", Id = 17187, MaxHdv10 = 10, MaxHdv1 = 15, Level = 110, ListIdCraft = {
        {Id = 423  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 17142  , Nb = 1},
        {Id = 6671  , Nb = 1},
    }, PodsNeededToCraft = 6},
    {Name = "Grillade Brâkmarienne", Id = 17189, MaxHdv10 = 10, MaxHdv1 = 15, Level = 120, ListIdCraft = {
        {Id = 17144  , Nb = 1},
        {Id = 532  , Nb = 1}, -- Nb = nombre de cette ressource qu'il faut pour craft l'item
        {Id = 1984  , Nb = 1},
    }, PodsNeededToCraft = 6},
}

local function treatMaps(maps)

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end

    map:changeMap("havenbag")
end

local function Vidage_Banque()
    npc:npcBank(-1)

    if exchange:storageItemQuantity(17123) > 100 then
        exchange:getItem(17123, exchange:storageItemQuantity(17123))
        NeedToCraft = true
    end

    if exchange:storageItemQuantity(15556) > 100 then
        exchange:getItem(15556, exchange:storageItemQuantity(15556))
    end

    global:leaveDialog()

    global:editInMemory("VidageBanqueFait", true)

    map:door(518)
end

local function AchatRessourcesCraft()
    NeedToCraft = true
    local message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 6
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true)

    for _, element in ipairs(tableCraft) do
        local podsAvailable = inventory:podsMax() - inventory:pods()

        if job:level(41) < element.Level + 10 and (podsAvailable > (element.PodsNeededToCraft * 200)) then
            global:printSuccess("go Craft " .. element.Name)
            for _, element2 in ipairs(element.ListIdCraft) do
                if inventory:itemCount(element2.Id) < 200 then
                    global:printSuccess(math.floor(inventory:itemCount(element2.Id) / 100))
                    for i = math.floor(inventory:itemCount(element2.Id) / 100), 1 do
                        sale:buyItem(element2.Id, 100, 200000)
                    end
                end

                if inventory:itemCount(element2.Id) < 200 then
                    for i = math.floor(inventory:itemCount(element2.Id) / 10), 19 do
                        sale:buyItem(element2.Id, 10, 20000)
                    end
                end
            end
        end
    end

    global:leaveDialog()
    map:changeMap("zaapi(212601865)")
end

local function Crafting()
    NeedToCraft = false

    map:useById(521493, -1)
	global:delay(500)
	
    for _, element in ipairs(tableCraft) do
        if inventory:itemCount(element.ListIdCraft[1].Id) >= element.ListIdCraft[1].Nb and job:level(41) >= element.Level then
            for _, data in ipairs(element.ListIdCraft) do
                craft:putItem(data.Id, data.Nb)
            end
            craft:changeQuantityToCraft(inventory:itemCount(element.ListIdCraft[1].Id))
            global:delay(500)
            craft:ready()
            global:delay(500)
        end
    end

    global:leaveDialog()

    for _, element in ipairs(tableCraft) do
        if inventory:itemCount(element.Id) > 0 then
            inventory:deleteItem(element.Id, inventory:itemCount(element.Id))
        end
    end

	global:delay(500)
	map:door(381)
end

local GoBankBonta = {
    {map="0,0", path = "zaap(212600323)"},
    {map="-31,-56", path = "top"},
    {map="212600322", door = "468"},
    {map = "217059328", custom = Vidage_Banque},
}

local GoHdvRessource = {
    {map ="0,0", path = "zaap(212600323)"},				
    {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
    {map = "-31,-56", path = "bottom"},
    {map = "-31,-55", path = "bottom"},
    {map = "-31,-54", path = "right"},
    {map = "212601865", path = "zaapi(212601350)"},
    {map = "212600322", path = "bottom"},
    {map = "212601350", custom = AchatRessourcesCraft}, -- Map HDV ressouces bonta

}

local GoAtelierChasseur = {
    {map ="0,0", path = "zaap(212600323)"},		
    {map = "-31,-55", path = "zaapi(212601865)"},
    {map = "-30,-54", path = "zaapi(212601865)"},
    {map = "212600322", path = "zaapi(212601865)"}, -- Map extérieure de la banque de bonta

    {map = "212601865", door = "300"},
    {map = "217062404", custom = Crafting},
}

function move()
    mapDelay()
    if job:level(41) > 130 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\Combat+Archi.lua")
    end
    if not global:remember("VidageBanqueFait") then
        return treatMaps(GoBankBonta)
    end

    if NeedToCraft then
        return treatMaps(GoAtelierChasseur)
    end

    return treatMaps(GoHdvRessource)
end

function bank()
    return move()
end