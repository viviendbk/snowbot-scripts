dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")


local hasPanneau = true

local Stuff70 = {
    {Type = "Coiffe", Id = 2531, Position = 6},
    {Type = "Cape", Id = 2532, Position = 7},
    {Type = "Ceinture", Id = 2683, Position = 3},
    {Type = "Amulette", Id = 10836, Position = 0},
    {Type = "AnneauDroit", Id = 1559, Position = 2},
    {Type = "Bottes", Id = 6470, Position = 5},
    {Type = "Chanceux Mineur", Id = 19407, Position = 11},
}

local TableCraft = {
    {Name = "coiffe AA", Id = 8463, Type = "Chapeau", ListIdCraft = {{Id = 437, Nb = 30}, {Id = 1694, Nb = 7}, {Id = 2267, Nb = 30}, {Id = 11253, Nb = 36}, {Id = 15259, Nb = 2}, {Id = 15565, Nb = 1}}},
    {Name = "cape AA", Id = 8464, Type = "Cape", ListIdCraft = {{Id = 7016, Nb = 45}, {Id = 8249, Nb = 36}, {Id = 13492 , Nb = 12}, {Id = 13698, Nb = 30}, {Id = 15259, Nb = 2}, {Id = 15565, Nb = 1}}},
    {Name = "amu AA", Id = 8465, Type = "Amulette", ListIdCraft = {{Id = 1612, Nb = 36}, {Id = 7655, Nb = 10}, {Id = 13528, Nb = 32}, {Id = 15743, Nb = 3}}, {Id = 15259, Nb = 2}, {Id = 15565, Nb = 1}},
    {Name = "anneau AA", Id = 8466, Type = "Anneau", ListIdCraft = {{Id = 1694, Nb = 12}, {Id = 2267, Nb = 25}, {Id = 8066, Nb = 36}, {Id = 13724, Nb = 32}}, {Id = 15259, Nb = 2}, {Id = 15565, Nb = 1}},
    {Name = "Ceinture AA", Id = 8468, Type = "Ceinture", ListIdCraft = {{Id = 1612, Nb = 35}, {Id = 1660, Nb = 35}, {Id = 8055, Nb = 30}, {Id = 17082, Nb = 8}, {Id = 15259, Nb = 2}, {Id = 15565, Nb = 1}}},
    {Name = "Bottes AA", Id = 8467, Type = "Bottes", ListIdCraft = {{Id = 470, Nb = 10}, {Id = 1612, Nb = 32}, {Id = 8250, Nb = 34}, {Id = 8765, Nb = 10}, {Id = 13366, Nb = 2}, {Id = 15565, Nb = 1}}},
}
local stuffAA = {
    {Type = "coiffe AA", Id = 8463, Position = 6},
    {Type = "cape AA", Id = 8464, Position = 7},
    {Type = "amu AA", Id = 8465, Position = 0},
    {Type = "Gelano", Id = 2469, Position = 4},
    {Type = "anneau AA", Id = 8466, Position = 2},
    {Type = "Ceinture AA", Id = 8468, Position = 3},
    {Type = "Bottes AA", Id = 8467, Position = 5},
    {Type = "Examinateur", Id = 13831, Position = 11}
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
    for _, item in ipairs(Stuff70) do
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

    for _, item in ipairs(Stuff70) do
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