---@diagnostic disable: undefined-global, lowercase-global



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

local function connectBotBanque()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("bank_" .. character:serverName():lower()) then
            if not acc:isAccountConnected() then
                acc:connect()

                global:printMessage("attente de la connexion du bot banque")

                while not acc:isAccountFullyConnected() do
                    global:delay(2000)
                end

                global:printSuccess("le bot banque s'est connecté !")

				acc:loadScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Give_Abonnement.lua")
                acc:startScript()
                global:delay(10000)
                return acc
            else
                global:printSuccess("bot déjà connecté, on attend 5 secondes")
                global:delay(5000)
                return connectBotBanque()
            end
        end
    end
end

local function launchExchangeAndTakeStuff()
    AccountBank = connectBotBanque()

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

    AccountBank.global:setPrivate(false)
    AccountBank:exchangeListen(true)
    global:thisAccountController():exchangeListen(false)

    while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
    end

    global:delay(2000)

	-- Confirmation 
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 20000, true, "ExchangeLeaveMessage") then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end

    global:delay(2000)
    AccountBank:disconnect()

	if character:bonusPackExpiration() == 0 then
		character:getBonusPack(1)
	end

    global:addInMemory("deco_reco", true)
    global:reconnect(0)
    
    
end

local function PopoRappel()
    map:changeMap("zaap(84674563)")
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
    if global:remember("deco_reco") then
        global:deleteMemory("deco_reco")
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_24-43.lua")
    end
    if map:currentSubArea() ~= "Cité d'Astrub" and map:currentArea() ~= "Incarnam" then
        PopoRappel()
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