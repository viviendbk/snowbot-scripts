dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


local hasPanneau = true

local Stuff70 = {
    {Type = "Coiffe", Id = 2531, Position = 6},
    {Type = "Cape", Id = 2532, Position = 7},
    {Type = "Ceinture", Id = 2683, Position = 3},
    {Type = "Amulette", Id = 10836, Position = 0},
    {Type = "AnneauGauche", Id = 2469, Position = 4},
    {Type = "AnneauDroit", Id = 1559, Position = 2},
    {Type = "Bottes", Id = 6470, Position = 5},
    {Type = "Trophet", Id = 13781, Position = 9},
    {Type = "Bouclier", Id = 14993, Position = 15},
    {Type = "Taquin Mineur", Id = 13766, emplacement = 10},
    {Type = "Chanceux Mineur", Id = 19407, emplacement = 11},
    {Type = "Taquin", Id = 13767, emplacement = 12},
    {Type = "Saccageur Eau Mineur", Id = 13781, emplacement = 14},
}

local TableCraft = {
    {Name = "Caracoiffe", Id = 2531, Type = "Chapeau", ListIdCraft = {{Id = 997, Nb = 6}, {Id = 17092, Nb = 15}, {Id = 2624, Nb = 25}, {Id = 15572, Nb = 1}}},
    {Name = "Caracape", Id = 2532, Type = "Cape", ListIdCraft = {{Id = 13489, Nb = 10}, {Id = 17104, Nb = 1}, {Id = 2618 , Nb = 20}, {Id = 7059, Nb = 30}}},
    {Name = "Boufbamu", Id = 10836, Type = "Amulette", ListIdCraft = {{Id = 385, Nb = 6}, {Id = 887, Nb = 18}, {Id = 1777, Nb = 19}, {Id = 15573, Nb = 1}}},
    {Name = "Gelano", Id = 2469, Type = "Anneau", ListIdCraft = {{Id = 2437, Nb = 2}, {Id = 757, Nb = 20}, {Id = 9940, Nb = 6}, {Id = 15585, Nb = 1}, {Id = 2242, Nb = 2}}},
    {Name = "Abranneau Mou", Id = 1559, Type = "Anneau", ListIdCraft = {{Id = 401, Nb = 30}, {Id = 463, Nb = 6}, {Id = 435, Nb = 15}, {Id = 432, Nb = 12}}},
    {Name = "Ceinture Tortue Bleue", Id = 2683, Type = "Ceinture", ListIdCraft = {{Id = 1002, Nb = 18}, {Id = 997, Nb = 4}, {Id = 2624, Nb = 13}, {Id = 2613, Nb = 20}}},
    {Name = "Bottes de l'Eleveur de Bouftous", Id = 6470, Type = "Bottes", ListIdCraft = {{Id = 460, Nb = 20}, {Id = 1777, Nb = 22}, {Id = 9940, Nb = 5}, {Id = 15573, Nb = 1}, {Id = 1771, Nb = 26}}},
}
local StuffAkwalada = {
    {Type = "Coiffe", Id = 7226, Position = 6},
    {Type = "Cape", Id = 7230, Position = 7},
    {Type = "Ceinture", Id = 7238, Position = 3},
    {Type = "Amulette", Id = 7250, Position = 0},
    {Type = "Anneau", Id = 7246, Position = 4},
    {Type = "Bottes", Id = 7242, Position = 5},
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



local function launchExchangeAndTakeStuff()
    AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Give_Stuff_70.lua")
    for _, item in ipairs(StuffAkwalada) do
        inventory:equipItem(item.Id, 63)
        global:delay(500)
    end

    global:delay(10000)

    for _, item in ipairs(TableCraft) do
        if AccountBank.inventory:itemCount(item.Id) == 0 then
            global:printSuccess("On va faire craft la panneau au bot bank")
            global:printMessage("Analyse des couts de fabrication..")
            global:printMessage("--------------------------------------")
    
            local TotalCost = 0
    
            for _, item in ipairs(TableCraft) do
    
                local Cost = 0
                npc:npcSale()
    
                for _, Ressource in ipairs(item.ListIdCraft) do
                    local Prices = GetPricesItem(Ressource.Id)
                    Cost = Cost + Prices.AveragePrice * Ressource.Nb
                    TotalCost = TotalCost + Prices.AveragePrice * Ressource.Nb
                end
    
                global:printMessage("Total des couts pour craft " .. inventory:itemNameId(item.Id) .. " : " .. Cost)
                global:leaveDialog()
                
            end
            global:printSuccess("Total des couts pour craft " .. 1 .. " x Stuff 70 :" .. TotalCost * 1)
    
            global:printMessage("--------------------------------------")
            global:printMessage("Analyse terminée!")
            
            if AccountBank.character:kamas() * 0.9 < TotalCost then
                global:printSuccess("Le bot bank n'a pas assez de kamas, on attend 2 heures")
                AccountBank:disconnect()
                global:reconnect(2)
            else
                AccountBank.global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\MetierCraft\\CraftPanneau70.lua")
                global:reconnectBis(7)
            end
        end
    end

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

    for _, item in ipairs(StuffAkwalada) do
        if inventory:itemCount(item.Id) > 0 then
            exchange:putItem(item.Id, 1)
        end
    end
    local toGive = character:kamas() - 60000
    if toGive > 0 then
        exchange:putKamas(toGive)
    end

	-- Confirmation 
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 20000, true, "ExchangeLeaveMessage", 20) then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end

    global:delay(10000)
    AccountBank:disconnect()

	if character:bonusPackExpiration() == 0 then
		character:getBonusPack(1)
	end

    for _, item in ipairs(Stuff70) do
        inventory:equipItem(item.Id, item.Position)
    end
    
    if global:thisAccountController():getAlias():find("Chasseur") then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua")
    else
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Team.lua")
    end
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
    for _, element in ipairs(TableCraft) do
        if inventory:itemCount(element.Id) == 0 then
            global:printSuccess("Le perso n'a pas l'item " .. inventory:itemNameId(element.Id))
            hasPanneau = false
        end
    end
    if hasPanneau then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Team.lua")
    end

    if global:thisAccountController():isItATeam() and global:isBoss() then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Team.lua")
    end
    if not map:onMap("5,7") and not map:onMap("10,22") and not map:onMap("-16,1") and map:currentSubArea() ~= "Cité d'Astrub" then
        PopoRappel()
    elseif map:currentSubArea() ~= "Cité d'Astrub" then
        return {
            { map = "5,7", path = "zaap(84674563)" },
            { map = "10,22", path = "zaap(84674563)"},
            { map = "-16,1", path = "zaap(84674563)"},
        }
    elseif map:currentSubArea() == "Cité d'Astrub" then
        if not map:onMap(83887104) then
            GoTo("84674566", function()
                map:door(303)
            end)
        else
            launchExchangeAndTakeStuff()
        end
    end
end

function bank()
    return move()
end