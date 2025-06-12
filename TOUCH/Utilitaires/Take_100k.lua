dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local StuffAkwalada = {
    {Type = "Coiffe", Id = 7226, Position = 6},
    {Type = "Cape", Id = 7230, Position = 7},
    {Type = "Ceinture", Id = 7238, Position = 3},
    {Type = "Amulette", Id = 7250, Position = 0},
    {Type = "Anneau", Id = 7246, Position = 4},
    {Type = "Bottes", Id = 7242, Position = 5},
    {Type = "Arme", Id = 7254, Position = 1},
}

local Stuff70 = {
    {Type = "Coiffe", Id = 2531, Position = 6},
    {Type = "Cape", Id = 2532, Position = 7},
    {Type = "Ceinture", Id = 2683, Position = 3},
    {Type = "Amulette", Id = 10836, Position = 0},
    {Type = "AnneauGauche", Id = 2469, Position = 4},
    {Type = "AnneauDroit", Id = 1559, Position = 2},
    {Type = "Bottes", Id = 6470, Position = 5},
    {Type = "Trophet", Id = 12727, Position = 9},
    {Type = "Bouclier", Id = 14993, Position = 15}
}

local TableCraft = {
    {Name = "Chapeau Akwadala", Id = 7226, Type = "Chapeau", ListIdCraft = {{Id = 9940, Nb = 4}, {Id = 17100, Nb = 1}, {Id = 367, Nb = 4}, {Id = 17062, Nb = 15}}, NbToCraft = 1},
    {Name = "Cape Akwadala", Id = 7230, Type = "Cape", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 378, Nb = 12}, {Id = 380 , Nb = 30}, {Id = 6897, Nb = 10}}, NbToCraft = 1},
    {Name = "Amulette Akwadala", Id = 7250, Type = "Amulette", ListIdCraft = {{Id = 7013, Nb = 22}, {Id = 367, Nb = 5}, {Id = 1455, Nb = 19}, {Id = 13502, Nb = 17}}, NbToCraft = 1},
    {Name = "Alliance Akwadala", Id = 7246, Type = "Anneau", ListIdCraft = {{Id = 1778, Nb = 16}, {Id = 6897, Nb = 12}, {Id = 747, Nb = 3}, {Id = 2358, Nb = 12}}, NbToCraft = 1},
    {Name = "Ceinture Akwadala", Id = 7238, Type = "Ceinture", ListIdCraft = {{Id = 288, Nb = 10}, {Id = 1891, Nb = 12}, {Id = 2613, Nb = 12}, {Id = 417, Nb = 12}}, NbToCraft = 1},
    {Name = "Geta Akwadala", Id = 7242, Type = "Bottes", ListIdCraft = {{Id = 1778, Nb = 15}, {Id = 476, Nb = 30}, {Id = 13728, Nb = 14}}, NbToCraft = 1},
}

local function launchExchangeAndTakeStuff()
    AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Give_100k.lua")

    global:delay(10000)

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

    AccountBank.global:setPrivate(false)
    AccountBank:exchangeListen(false)
    global:thisAccountController():exchangeListen(false)

    while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
        lines = AccountBank.global:consoleLines()
        if lines ~= nil then
            for i, ligne in ipairs(lines) do
                if ligne:find("Le serveur a coupé la connexion inopinément") then
                    global:printSuccess("Le bot bank a bug, on le recharge")
                    ankabotController:unloadAccountByAlias(AccountBank:getAlias())
                    global:delay(500)
                    return launchExchangeAndTakeStuff()
                end
            end
        end   
    end

    global:delay(2000)

	-- Confirmation 
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 20000, true, "ExchangeLeaveMessage", 20) then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end

    global:delay(2000)
    AccountBank:unloadAccount()

    global:disconnect()
end

local GoToBankAstrub = {
    { map = "3,-14", path = "right" },
    { map = "3,-15", path = "right" },
    { map = "3,-16", path = "right" },
    { map = "3,-17", path = "right" },
    { map = "3,-18", path = "right" },
    { map = "3,-19", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "3,-22", path = "right" },
    { map = "3,-20", path = "right" },
    { map = "2,-22", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "2,-20", path = "right" },
    { map = "2,-19", path = "right" },
    { map = "2,-18", path = "right" },
    { map = "2,-17", path = "right" },
    { map = "2,-16", path = "right" },
    { map = "2,-15", path = "right" },
    { map = "2,-14", path = "right" },
    { map = "2,-13", path = "right" },
    { map = "3,-13", path = "right" },
    { map = "1,-13", path = "right" },
    { map = "1,-14", path = "right" },
    { map = "1,-15", path = "right" },
    { map = "1,-16", path = "right" },
    { map = "1,-18", path = "right" },
    { map = "1,-17", path = "right" },
    { map = "1,-19", path = "right" },
    { map = "1,-20", path = "right" },
    { map = "1,-22", path = "right" },
    { map = "1,-21", path = "right" },
    { map = "0,-21", path = "right" },
    { map = "0,-22", path = "right" },
    { map = "0,-20", path = "right" },
    { map = "0,-19", path = "right" },
    { map = "0,-18", path = "right" },
    { map = "0,-17", path = "right" },
    { map = "0,-16", path = "right" },
    { map = "0,-15", path = "right" },
    { map = "0,-14", path = "right" },
    { map = "-1,-14", path = "right" },
    { map = "-1,-15", path = "right" },
    { map = "-1,-16", path = "right" },
    { map = "-1,-17", path = "right" },
    { map = "-1,-18", path = "right" },
    { map = "-1,-19", path = "right" },
    { map = "-1,-20", path = "right" },
    { map = "-1,-21", path = "right" },
    { map = "-1,-13", path = "right" },
    { map = "0,-13", path = "right" },
    { map = "4,-13", path = "top" },
    { map = "4,-14", path = "top" },
    { map = "4,-15", path = "top" },
    { map = "5,-13", path = "top" },
    { map = "6,-13", path = "top" },
    { map = "7,-13", path = "top" },
    { map = "8,-13", path = "top" },
    { map = "8,-14", path = "top" },
    { map = "8,-15", path = "top" },
    { map = "8,-16", path = "top" },
    { map = "8,-17", path = "top" },
    { map = "8,-18", path = "top" },
    { map = "7,-14", path = "left" },
    { map = "6,-14", path = "left" },
    { map = "6,-15", path = "left" },
    { map = "5,-15", path = "left" },
    { map = "5,-14", path = "left" },
    { map = "5,-16", path = "left" },
    { map = "6,-16", path = "left" },
    { map = "7,-16", path = "left" },
    { map = "7,-15", path = "left" },
    { map = "7,-17", path = "left" },
    { map = "6,-17", path = "left" },
    { map = "5,-18", path = "left" },
    { map = "6,-18", path = "left" },
    { map = "5,-17", path = "left" },
    { map = "7,-18", path = "left" },
    { map = "7,-19", path = "left" },
    { map = "6,-19", path = "left" },
    { map = "5,-19", path = "left" },
    { map = "5,-20", path = "left" },
    { map = "7,-20", path = "left" },
    { map = "6,-20", path = "left" },
    { map = "6,-21", path = "left" },
    { map = "7,-21", path = "left" },
    { map = "5,-21", path = "left" },
    { map = "5,-22", path = "left" },
    { map = "8,-19", path = "left" },
    { map = "7,-22", path = "left" },
    { map = "6,-22", path = "left" },
    { map = "8,-22", path = "left" },
    { map = "8,-23", path = "left" },
    { map = "7,-23", path = "left" },
    { map = "6,-23", path = "left" },
    { map = "0,-23", path = "right" },
    { map = "-1,-23", path = "right" },
    { map = "1,-23", path = "right" },
    { map = "2,-23", path = "right" },
    { map = "3,-23", path = "right" },
    { map = "4,-23", path = "right" },
    { map = "-2,-20", path = "right" },
    { map = "-2,-14", path = "top" },
    { map = "-2,-13", path = "top" },
    { map = "-2,-15", path = "top" },
    { map = "-2,-16", path = "top" },
    { map = "-3,-14", path = "top" },
    { map = "-3,-15", path = "top" },
    { map = "-3,-17", path = "top" },
    { map = "-3,-16", path = "top" },
    { map = "-2,-17", path = "top" },
    { map = "-2,-18", path = "top" },
    { map = "-3,-19", path = "top" },
    { map = "-2,-19", path = "top" },
    { map = "-3,-18", path = "top" },
    { map = "-2,-22", path = "bottom" },
    { map = "-2,-21", path = "bottom" },
    { map = "-3,-21", path = "bottom" },
    { map = "-3,-23", path = "bottom" },
    { map = "-2,-23", path = "bottom" },
    { map = "-3,-22", path = "bottom" },
    { map = "-1,-22", path = "top" },
    { map = "4,-22", path = "bottom" },
    { map = "4,-21", path = "bottom" },
    { map = "4,-20", path = "bottom" },
    { map = "8,-21", path = "bottom" },
    { map = "8,-20", path = "bottom" },
    { map = "4,-19", path = "bottom" },
    { map = "4,-18", path = "bottom" },
    { map = "4,-17", path = "bottom" },
    { map = "84674566", door = "303"},
    { map = "83887104", custom = launchExchangeAndTakeStuff},

}


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


local function PopoRappel()
    --map:changeMap("zaap(84674563)")

    global:printSuccess("J'ouvre la banque")
    inventory:openBank()
    if exchange:storageKamas() > 0 then
        global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
        exchange:getKamas(0)
        global:delay(500)
    elseif exchange:storageKamas() == 0 then
        global:printError("Il n'y a pas de kamas en banque")
        global:delay(500)
    end
    global:printSuccess("Je prend le stuff")
    for _, element in ipairs(StuffAkwalada) do
        if exchange:storageItemQuantity(element.Id) > 0 and inventory:itemCount(element.Id) == 0 then
            exchange:getItem(element.Id, 1)
            global:delay(500)
        end
    end
    
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
    if character:kamas() > 3000000 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Chasseur_Team.lua")
    end
    if not map:onMap("5,7") and not map:onMap("147768") and not map:onMap("10,22") and not map:onMap("-16,1") and not map:onMap("-1,13") and not map:onMap("-5,23") and not map:onMap("-23,-19") and not map:onMap("35,12") and map:currentSubArea() ~= "Cité d'Astrub" then
        PopoRappel()
    elseif map:currentSubArea() ~= "Cité d'Astrub" then
        return {
            { map = "147768", path = "zaap(84674563)" },
            { map = "5,7", path = "zaap(84674563)" },
            { map = "10,22", path = "zaap(84674563)"},
            { map = "-16,1", path = "zaap(84674563)"},
            {map = "-1,13", path = "zaap(84674563)"}, --marecage
            {map = "35,12", path = "zaap(84674563)"}, -- moon
            {map = "-5,-23", path = "zaap(84674563)"}, -- champa
            {map = "-23,-19", path = "zaap(84674563)"}, --mont neselite
        }
    elseif map:currentSubArea() == "Cité d'Astrub" then
        return GoToBankAstrub
    end
end

function bank()
    return move()
end