dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Piou.lua")
dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


AUTO_DELETE = {792, 519, 1915, 385, 1736, 385, 383, 2414, 2416, 2425, 2428, 10967, 1900, 364, 1730, 15479, 1690, 407, 1734, 1975}



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

local tableVente = {
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Blanc", Id = 881 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Noir", Id = 885 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Racine d'Abraknyde", Id = 435 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Résine végétale", Id = 1985 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Patte dArakne", Id = 365 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Peau de Larve Bleue", Id = 362 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve", Id = 1898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Orange", Id = 363 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau", Id = 1927 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Ailes de Moskito", Id = 307 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Mesure de Poivre", Id = 1978 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir de Sanglier", Id = 486 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Carré de Porc", Id = 1917 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Tatouage de Mauvais Garçon", Id = 13342 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},

    {Name = "Poils de souris", Id = 761 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Graine de Sésame", Id = 287 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},

    {Name = "Plume de Piou Bleu", Id = 6897 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Plume de Piou Violet", Id = 6898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Plume de Piou Vert", Id = 6899 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Plume de Piou Rouge", Id = 6900 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Plume de Piou Jaune", Id = 6902 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},
    {Name = "Plume de Piou Rose", Id = 6903 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 5, CanSell = true},    

}

local TrajetPL = {
    { map = "83887104", path = "396",},
    { map = "-3,-14", path = "top", fight = true },
    { map = "-3,-16", path = "top", fight = true },
    { map = "-3,-18", path = "top", fight = true },
    { map = "-2,-19", path = "top", fight = true },
    { map = "-3,-20", path = "top", fight = true },
    { map = "-2,-14", path = "left", fight = true },
    { map = "-2,-15", path = "top", fight = true },
    { map = "-2,-17", path = "top", fight = true },
    { map = "-2,-16", path = "left", fight = true },
    { map = "-2,-18", path = "left", fight = true },
    { map = "-2,-20", path = "left", fight = true },
    { map = "-3,-15", path = "right", fight = true },
    { map = "-3,-17", path = "right", fight = true },
    { map = "-3,-19", path = "right", fight = true },
    { map = "-3,-21", path = "right" },
    { map = "-2,-21", path = "top", fight = true },
    { map = "-2,-22", path = "right", fight = true },
    { map = "-1,-22", path = "top", fight = true },
    { map = "-1,-23", path = "right", fight = true },
    { map = "0,-23", path = "right", fight = true },
    { map = "1,-23", path = "right", fight = true },
    { map = "2,-23", path = "right", fight = true },
    { map = "3,-23", path = "right", fight = true },
    { map = "4,-23", path = "right", fight = true },
    { map = "6,-22", path = "right", fight = true },
    { map = "5,-23", path = "right", fight = true },
    { map = "7,-22", path = "right", fight = true },
    { map = "8,-22", path = "bottom", fight = true },
    { map = "8,-21", path = "bottom", fight = true },
    { map = "8,-20", path = "bottom", fight = true },
    { map = "8,-19", path = "bottom", fight = true },
    { map = "8,-18", path = "bottom", fight = true },
    { map = "8,-16", path = "bottom", fight = true },
    { map = "8,-17", path = "bottom", fight = true },
    { map = "8,-15", path = "bottom", fight = true },
    { map = "8,-14", path = "left", fight = true },
    { map = "7,-14", path = "left", fight = true },
    { map = "6,-14", path = "left", fight = true },
    { map = "5,-14", path = "left", fight = true },
    { map = "4,-13", path = "left", fight = true },
    { map = "2,-13", path = "left", fight = true },
    { map = "3,-13", path = "left", fight = true },
    { map = "1,-13", path = "left", fight = true },
    { map = "0,-13", path = "left", fight = true },
    { map = "-1,-13", path = "left", fight = true },
    { map = "-2,-13", path = "left", fight = true },
    { map = "-3,-13", path = "top", fight = true },
    { map = "4,-14", path = "bottom" },
    { map = "6,-23", path = "bottom" },  

    { map = "7,-15", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "6,-21", path = "left" },
    { map = "6,-20", path = "left" },
    { map = "6,-19", path = "left" },
    { map = "6,-18", path = "left" },
    { map = "6,-17", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "6,-15", path = "left" },
    { map = "84674566", path = "left" },
    { map = "5,-15", path = "left" },
    { map = "5,-16", path = "left" },
    { map = "5,-17", path = "left" },
    { map = "5,-18", path = "left" },
    { map = "5,-19", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "5,-22", path = "left" },
    { map = "4,-22", path = "left" },
    { map = "4,-20", path = "left" },
    { map = "4,-18", path = "left" },
    { map = "4,-17", path = "left" },
    { map = "4,-19", path = "left" },
    { map = "4,-15", path = "left" },
    { map = "3,-14", path = "left" },
    { map = "3,-15", path = "left" },
    { map = "3,-16", path = "left" },
    { map = "3,-17", path = "left" },
    { map = "3,-18", path = "left" },
    { map = "3,-19", path = "left" },
    { map = "3,-20", path = "left" },
    { map = "3,-21", path = "left" },
    { map = "3,-22", path = "left" },
    { map = "4,-21", path = "left" },
    { map = "5,-21", path = "left" },
    { map = "2,-22", path = "left" },
    { map = "2,-21", path = "left" },
    { map = "2,-20", path = "left" },
    { map = "2,-19", path = "left" },
    { map = "2,-18", path = "left" },
    { map = "2,-17", path = "left" },
    { map = "2,-15", path = "left" },
    { map = "2,-14", path = "left" },
    { map = "2,-16", path = "left" },
    { map = "1,-15", path = "left" },
    { map = "1,-14", path = "left" },
    { map = "0,-14", path = "left" },
    { map = "0,-15", path = "left" },
    { map = "1,-16", path = "left" },
    { map = "0,-17", path = "left" },
    { map = "0,-16", path = "left" },
    { map = "-1,-14", path = "left" },
    { map = "1,-17", path = "left" },
    { map = "1,-18", path = "left" },
    { map = "0,-18", path = "left" },
    { map = "0,-19", path = "left" },
    { map = "1,-19", path = "left" },
    { map = "1,-20", path = "left" },
    { map = "0,-20", path = "left" },
    { map = "0,-21", path = "left" },
    { map = "1,-21", path = "left" },
    { map = "0,-22", path = "left" },
    { map = "-1,-20", path = "left" },
    { map = "-1,-21", path = "bottom" },
    { map = "-1,-15", path = "bottom" },
    { map = "-1,-16", path = "bottom" },
    { map = "-1,-17", path = "top" },
    { map = "-1,-19", path = "top" },
    { map = "7,-17", path = "left" },
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

local function ProcessSell()
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true)

    global:delay(1000)

    table.sort(tableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(tableVente) do
        global:printSuccess(_ .. "ème item à vendre...")
        if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end
		local Priceitem = GetPricesItem(element.Id)

        local cpt = get_quantity(element.Id).quantity["100"]        
        local Priceitem1 = Priceitem.Price100
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
			Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and Priceitem.AveragePrice * 100 * 1.5 or Priceitem1
            sale:sellItem(element.Id, 100, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        local Priceitem2 = Priceitem.Price10
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and Priceitem.AveragePrice * 10 * 1.5 or Priceitem2
            sale:sellItem(element.Id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["1"]
        local Priceitem3 = Priceitem.Price1
        Priceitem3 = ((Priceitem3 == nil) or (Priceitem3 == 0) or (Priceitem3 == 1)) and Priceitem.AveragePrice * 1.5 or Priceitem3
        while (inventory:itemCount(element.Id) >= 1) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv1) do 
            element.MaxHdv1 =  (Priceitem3 < 100) and 0 or element.MaxHdv1
            sale:sellItem(element.Id, 1, Priceitem3 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(element.Id)  .. " à " .. Priceitem3 - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    global:leaveDialog()
end

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
end

local function PopoRappel()
    if inventory:itemCount(548) == 0 then
        npc:npcBuy()
        global:delay(500)
        sale:buyItem(548, 1, 1000)

        if inventory:itemCount(548) == 0 then
            sale:buyItem(548, 10, 10000)
        end
        global:delay(500)
        global:leaveDialog()
        global:delay(500)
    end
    inventory:useItem(548)
end

local function treatMaps(maps)
    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

	if not map:onMap(maps[1].map) then
		local toward = maps[1].map:split(",")
		if #toward == 2 then
			map:moveToward(tonumber(toward[1]), tonumber(toward[2]))
		elseif #toward == 1 then
			map:moveToward(tonumber(maps[1].map))
		end
	end
end

function antiModo()
    if global:isModeratorPresent(30) then
        timerdisconnect = math.random(30000, 36000) 

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

        if not global:thisAccountController():getAlias():find("bank") and not global:thisAccountController():getAlias():find("Next") then
            local Alias = global:thisAccountController():getAlias():split(" ")

            if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) and global:thisAccountController():getAlias():find("FAIT") then
                global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level() .. "[FAIT] [MODO]", true)
            elseif Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
                global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level() .. " [MODO]", true)
            elseif global:thisAccountController():getAlias():find("FAIT") then
                global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level() .. "[FAIT] [MODO]", true)
            else
                global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level() .. " [MODO]", true)
            end
        end

        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global:reconnectBis((timerdisconnect + 10) / 1000)
            end
            global:reconnectBis(timerdisconnect / 1000)
        elseif not global:thisAccountController():isItATeam() then
            global:reconnectBis(timerdisconnect / 1000)
        end

    end
end

function EditAlias()
    if not global:thisAccountController():getAlias():find("Next") then
        local Alias = global:thisAccountController():getAlias():split(" ")
        if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) and global:thisAccountController():getAlias():find("FAIT") then
            global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level() .. "[FAIT]", true)
        elseif Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
            global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level(), true)
        elseif global:thisAccountController():getAlias():find("FAIT") then
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level() .. "[FAIT]", true)
        else
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level(), true)
        end
    end
end

local function HasAllStuff()
    local StuffAkwalada = {
        {Type = "Coiffe", Id = 7226, Position = 6},
        {Type = "Cape", Id = 7230, Position = 7},
        {Type = "Ceinture", Id = 7238, Position = 3},
        {Type = "Amulette", Id = 7250, Position = 0},
        {Type = "Anneau", Id = 7246, Position = 4},
        {Type = "Bottes", Id = 7242, Position = 5},
    }
    for _, element in ipairs(StuffAkwalada) do
        if inventory:itemCount(element.Id) == 0 then
            return false
        end
    end
    return true
end

local function equip()
	EquipementFini = true
    local tableEquip = {
        {Type = "amulette", Id = 1661, Emplacement = 0, Equipe = false},
        {Type = "cape", Id = 6916, Emplacement = 7, Equipe = false},
        {Type = "coiffe", Id = 6917, Emplacement = 6, Equipe = false},
        {Type = "anneauDroit", Id = 6915, Emplacement = 4, Equipe = false}, 
    }
	for _,element in ipairs(tableEquip) do
		if not element.Equipe and inventory:itemCount(element.Id) > 0 then
			element.Equipe = true
			inventory:equipItem(element.Id, element.Emplacement)
		end
		if not element.Equipe then
			EquipementFini = false
		end
	end
end


function move()
    -- if character:level() >= 30 and not global:thisAccountController():getAlias():find("FAIT") and not global:thisAccountController():getAlias():find("bank") and character:level() < 50 then
    --     local phrase = global:thisAccountController():getAlias()
	-- 	global:editAlias(phrase .. " [FAIT]", true)
	-- 	global:reconnectBis(math.random(11 * 60, 12 * 60))
	-- end

    if not EquipementFini then
		equip()
	end
    if character:bonusPackExpiration() <= 0 and character:kamas() > 50000 then
        character:getBonusPack(1)
        global:reconnect(0)
    end
    if global:maximumNumberFightsOfDay() then
        global:editAlias(global:thisAccountController():getAlias() .. " [MAX FIGHT]")
        global:reconnect(math.random(2, 3)) -- Je me deconnecte
    end
    if not global:thisAccountController():getAlias():find("bank") then
        EditAlias()
    end
    antiModo()
    if (character:level() >= 43 and not global:thisAccountController():getAlias():find("bank")) or character:level() > 85 then
        if not Rappel then
            Rappel = true
            PopoRappel()
        end
        ProcessSell()
        global:printSuccess("Niveau 43")
        if global:thisAccountController():getAlias():find("Next") then
            global:editAlias(global:thisAccountController():getAlias() .. " Done", true)
            global:disconnect()
        end

        if not HasAllStuff() and character:level() < 50 then
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Take_Stuff_Akwadala.lua")
        end
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\TrajetZaaps.lua") 
    end

    MIN_MONSTERS = 2
    return treatMaps(TrajetPL)
end


function bank()
    inventory:openBank()
    if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	
    global:leaveDialog()
    ProcessSell()
    return treatMaps(TrajetPL)
end


function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end


function phenix()
    return {
        { map = "-3,-11", path = "right" },
        { map = "-2,-11", path = "right" },
        { map = "-1,-11", path = "right" },
        { map = "1,-11", path = "right" },
        { map = "0,-11", path = "right" },
        { map = "2,-11", path = "top" },
        { map = "2,-12", custom = function() map:door(272) map:changeMap("top") end},
    }
end