dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")


if not global:remember("isInsideDj") then
    global:addInMemory("isInsideDj", false)
end

if not global:remember("ETAPEDJ") then
    global:addInMemory("ETAPEDJ", 0)
end

if not global:remember("djFinished") then
    global:addInMemory("djFinished", false)
end

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


local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end

function stop()
	if _ExchangeMoneyMovementInformationMessage ~= nil and #_ExchangeMoneyMovementInformationMessage > 0 then
		global:printSuccess(_ExchangeMoneyMovementInformationMessage[#_ExchangeMoneyMovementInformationMessage].limit)
		if _ExchangeMoneyMovementInformationMessage[#_ExchangeMoneyMovementInformationMessage].limit < 20000000 then
			global:printSuccess("le temps de jeu est pas suffisant")
			global:editInMemory("lvlFinish", global:remember("lvlFinish") + 1)
			customReconnect(120)
		else
			global:printSuccess("temps de jeu suffisant")
		end
	end

	if not phrase:find("LvlUp") then
		restat()

        upgradeCharacteristics(150, 0,  0, calculCharacteristicsPointsToSet(character:level() * 5 - 155))
	end
	_ExchangeMoneyMovementInformationMessage = developer:historicalMessage("ExchangeMoneyMovementInformationMessage")

	if global:thisAccountController():getAlias():find("Mineur2") then
		local LoadedAccounts = snowbotController:getLoadedAccounts()
		for _, acc in ipairs(LoadedAccounts) do
			if acc:getAlias():find("Mineur " .. character:server()) and not (acc.job():level(24) > 70) then
				global:printSuccess("l'autre mineur est pas encore assez up, on reco dans 2h")
				customReconnect(120)
			end
		end
	elseif global:thisAccountController():getAlias():find("Bucheron2") then
		local LoadedAccounts = snowbotController:getLoadedAccounts()
		for _, acc in ipairs(LoadedAccounts) do
			if acc:getAlias():find("Bucheron " .. character:server()) and not (acc.job():level(2) > 55) then
				global:printSuccess("l'autre mineur est pas encore assez up, on reco dans 2h")
				customReconnect(120)
			end
		end
	elseif global:thisAccountController():getAlias():find("LvlUp2") then
		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find("LvlUp2") and acc:getAlias():find(character:server()) and (acc:getUsername() ~= global:thisAccountController():getUsername()) and ((acc:isAccountConnected() or acc:getAlias():find("MODO")) 
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("199") and not acc:getAlias():find("199"))
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("200") and not acc:getAlias():find("200"))) then

				global:printSuccess("l'autre LvlUp2 n'est pas encore prêt, on attend 2h")
				customReconnect(120)
			end
			if acc:getAlias():find("LvlUp " .. character:server()) and acc.character():level() < 155 then
				global:printSuccess("l'autre LvlUp n'est pas encore lvl 155, on attend 2h")
				customReconnect(120)
			end
		end
	elseif global:thisAccountController():getAlias():find("LvlUp ") then
		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find("LvlUp ") and acc:getAlias():find(character:server()) and (acc:getUsername() ~= global:thisAccountController():getUsername()) and ((acc:isAccountConnected() or acc:getAlias():find("MODO")) 
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("199") and not acc:getAlias():find("199"))
				or (not acc:isAccountConnected() and global:getCurrentScriptDirectory():find("200") and not acc:getAlias():find("200"))) then

				global:printSuccess("l'autre LvlUp n'est pas encore prêt, on attend 2h")
				customReconnect(120)
			end
		end
	end

	global:editAlias(phrase .. " [PRÊT]", true)
	global:printSuccess("bot niveau 60")
	for _, element in ipairs(tableVente) do
		inventory:deleteItem(element.Id,inventory:itemCount(element.Id))
	end
	inventory:deleteItem(287, inventory:itemCount(287))
	global:delay(500)
	settOrnament(34)
	global:delay(500)
	if phrase:find("bank") then
		global:editAlias(phrase, true)
		global:disconnect()
	end
	global:deleteAllMemory()
	global:loadAndStart(pathConfig)
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


local function idolsGUI(open)
    local message = developer:createMessage("IdolPartyRegisterRequestMessage")
    message.register = open == true and true or false

    developer:sendMessage(message)

    if open then developer:suspendScriptUntil("IdolListMessage", 500, false) end
end

local function send_equip(ID_idole)
        monMessage = developer:createMessage(6587)
        monMessage.idolId = ID_idole
        monMessage.activate = true
		monMessage.party = false
        developer:sendMessage(monMessage)
end


function move()
    d2data:exportD2O("Items")
    global:finishScript()
    mapDelay()
    global:printSuccess(global:remember("ETAPEDJ"))
    if job:level(24) >= 5 or job:level(2) >= 5 then
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
	end

    if global:remember("ETAPEDJ") == 0 then
        if inventory:itemCount(16666) == 0 then
            GoTo("191104004", function ()
                global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
                message = developer:createMessage("NpcGenericActionRequestMessage")
                message.npcId = -1
                message.npcActionId = 6
                message.npcMapId = map:currentMapId()
                developer:sendMessage(message)
                developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
                sale:buyItem(16666, 1, 20000)
                global:leaveDialog()
                idolsGUI(true)
                send_equip(6)
                idolsGUI(false)
                map:changeMap("top")
            end)
        else
            global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
            map:changeMap("top")
        end
    elseif global:remember("ETAPEDJ") == 1 then
        if not global:remember("isInsideDj") then
            GoTo("192937992", function ()
                global:editInMemory("isInsideDj", true)
                npc:npc(4370, 3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)

                global:delay(math.random(300, 800))
                
                npc:npc(780, 3)
                npc:reply(-1)
                npc:reply(-1)
            end)
        end
        if global:remember("djFinished") then
            GoTo("192413696", function ()
                global:editInMemory("djFinished", false)
                global:editInMemory("isInsideDj", false)
                global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
                npc:npc(4370, 3)
                npc:reply(-1)
                npc:reply(-1)

                npc:npc(4370, 3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                global:leaveDialog()

                map:moveToCell(484)
            end)
        end
        return {
            {map = "190449664", forcefight = true},
            {map = "190448640", forcefight = true},
            {map = "190316544", forcefight = true},
            {map = "190317568", forcefight = true},
            {map = "190318592", forcefight = true},
            {map = "190318594", custom = function ()
                global:editInMemory("djFinished", true)
                npc:npc(780, 3)
                npc:reply(-1)
            end}
        }
    elseif global:remember("ETAPEDJ") == 2 then
        if not global:remember("isInsideDj") then
            GoTo("120063489", function ()
                global:editInMemory("isInsideDj", true)
                npc:npc(173, 3)
                npc:reply(-1)
                npc:reply(-1)
            end)
        end
        if global:remember("djFinished") then
            GoTo("192413696", function ()
                global:editInMemory("djFinished", false)
                global:editInMemory("isInsideDj", false)
                global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
                npc:npc(4370, 3)
                npc:reply(-1)
                npc:reply(-1)

                map:moveToCell(484)
            end)
        end
        return {
            {map = "121373185", forcefight = true},
            {map = "121374209", forcefight = true},
            {map = "121375233", forcefight = true},
            {map = "121373187", forcefight = true},
            {map = "121374211", forcefight = true},
            {map = "121375235", custom = function ()
                global:editInMemory("djFinished", true)
                npc:npc(173, 3)
                npc:reply(-1)
            end}
        }
    elseif global:remember("ETAPEDJ") == 3 then
        GoTo("188743687", function ()
            global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
            npc:npc(1577, 3)
            npc:reply(-3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            map:changeMap("right")
        end)
    elseif global:remember("ETAPEDJ") == 4 then
        if not global:remember("isInsideDj") then
            GoTo("190056961", function ()
                global:editInMemory("isInsideDj", true)
                npc:npc(798, 3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
            end)
        end
        if global:remember("djFinished") then
            GoTo("188743687", function ()
                global:editInMemory("djFinished", false)
                global:editInMemory("isInsideDj", false)
                global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
                npc:npc(1577, 3)
                npc:reply(-3)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)
                npc:reply(-1)

                map:changeMap("right")
            end)
        end
        if map:onMap(190056961) then
            global:editInMemory("ETAPEDJ", 6)
            map:changeMap("havenbag")
        end
        return {
            {map = "193725440", forcefight = true},
            {map = "193726464", forcefight = true},
            {map = "193727488", forcefight = true},
            {map = "193728512", forcefight = true},
            {map = "193729536", forcefight = true},
            {map = "193730560", custom = function ()
                global:editInMemory("djFinished", true)
                npc:npc(798, 3)
                npc:reply(-1)
                npc:reply(-1)
            end}
        }
    elseif global:remember("ETAPEDJ") == 5 then
        if not global:remember("isInsideDj") then
            if getCurrentAreaName() ~= "Plaines de Cania" and getCurrentAreaName() ~= "Foire du Trool" and getCurrentAreaName() ~= "Havres-Sacs" then
                map:changeMap("havenbag")
            end
            if map:onMap("0,0") then
                map:changeMap("zaap(165152263)")
            end
            return {
                {map = "-13,-28", path = "top"},
                {map = "-13,-29", path = "top"},
                {map = "-11,-30", path = "top"},
                {map = "-11,-31", path = "top"},
                {map = "-11,-32", path = "top"},
                {map = "-11,-33", path = "top"},
                {map = "-11,-34", path = "top"},
                {map = "-11,-36", path = "top"},
                {map = "-11,-37", path = "top"},
                {map = "-11,-38", path = "top"},
                {map = "-11,-39", path = "top"},
                {map = "-11,-40", path = "top"},
                {map = "-11,-41", path = "left"},
                {map = "-12,-41", path = "left"},
                {map = "-13,-30", path = "right"},
                {map = "-12,-30", path = "right"},
                {map = "-12,-35", path = "top"},
                {map = "-11,-35", path = "left"},
                {map = "-12,-36", path = "right"},
                {map = "139723265", custom = function ()
                    global:editInMemory("isInsideDj", true)
                    npc:npc(1387, 3)
                    npc:reply(-2)
                    npc:reply(-1)
                end}
            }
        end
        if global:remember("djFinished") then
            if getCurrentAreaName() ~= "Astrub" and getCurrentAreaName() ~= "Havres-Sacs" then
                map:changeMap("havenbag")
            end
            if map:onMap("0,0") then
                map:changeMap("zaap(191105026)")
            end
            inventory:equipItem(15018, 28)
            global:editInMemory("djFinished", false)
            global:editInMemory("isInsideDj", false)
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
        end
        return {
            {map = "139723265", custom = function ()
                npc:npc(1387, 3)
                npc:reply(-2)
                npc:reply(-1)
            end},
            {map = "163578368", forcefight = true},
            {map = "163579392", forcefight = true},
            {map = "163580416", forcefight = true},
            {map = "163581440", forcefight = true},
            {map = "163582464", forcefight = true},
            {map = "163583488", custom = function ()
                global:editInMemory("djFinished", true)
                npc:npc(1387, 3)
                npc:reply(-1)
            end}

        }
    elseif global:remember("ETAPEDJ") == 6 then
        if getCurrentAreaName() ~= "Havres-Sacs" and not map:onMap(191105026) then
            map:changeMap("havenbag")
        end
        if map:onMap("0,0") then
            map:changeMap("zaap(191105026)")
        end
        inventory:equipItem(15018, 28)
        global:editInMemory("djFinished", false)
        global:editInMemory("isInsideDj", false)
        global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\quete_pandala.lua")
    end

end

function bank()
    return move()
end

function phenix()
    return {
        {map = "-3,-13", path = "right"},
        {map = "-2,-13", path = "right"},
        {map = "-1,-13", path = "right"},
        {map = "0,-13", path = "right"},
        {map = "1,-13", path = "right"},
        {map = "2,-13", path = "top"},
        {map = "2,-14", custom = function ()
            global:editInMemory("ETAPEDJ", 6)
            map:door(313)
            map:changeMap("top")
        end},

        {map = "-9,-54", path = "left"},
        {map = "-10,-54", custom = function ()
            global:editInMemory("ETAPEDJ", global:remember("ETAPEDJ") + 1)
            map:door(342)
            map:changeMap("right")
        end}
    }
end


function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

	local i = 1
	for cell1, id1 in pairs(challengers) do
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end
		i = i + 1
	end

	local IndexMinimale = 0
	local distanceMinimale = 10000

	for index, element in ipairs(DistanceEmplacement) do
		if element < distanceMinimale then
			distanceMinimale = DistanceEmplacement[index]
			IndexMinimale = index
		end
	end

	i = 1
	for cell, id in pairs(challengers) do
    	if i == IndexMinimale then
    	    fightAction:chooseCell(cell)
			break
    	end
		i = i + 1
	end
end

lancable = 0
incrementation = 0

function fightManagement()
    -- Je vérifie dans un premier temps que c'est bien à moi de jouer :

        if fightCharacter:isItMyTurn() == true then

            if fightAction:getCurrentTurn()==1 then
                lancable = 0
                incrementation = 0
            end
            
            Deplacement()
            -- lancement mutilation
            if lancable == 0 then 
                if incrementation == 1 then
                    Absorbtion()
					if fightCharacter:getAP() > 4 and not map:onMap("193729536") and (fightChallenge:getChallengeId() ~= 120) then
						Absorbtion()
					end
                    if fightCharacter:getAP() > 4 then
                        Douleur_Cuisante()
                    end
                    if fightCharacter:getAP() > 3 then
                        Hostilite()
                    end
                end

                fightAction:castSpellOnCell(12737,fightCharacter:getCellId())
                incrementation = (incrementation == 0) and 1 or 0
                lancable = lancable + incrementation
            else
                lancable = lancable - 1
            end
        			

            -- J'avance vers mon ennemi le plus proche
            Deplacement()


            Absorbtion()
            if not map:onMap("190318592") and not map:onMap("193729536") then
                LaunchEpee_Vorace()
            end    

            if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) then
                Courrone_Epine()
            end

            if not map:onMap("193729536") and (fightChallenge:getChallengeId() ~= 120) then
                Absorbtion()
            end
             -- lancement douleur cuisante

            Douleur_Cuisante()
            if not map:onMap("193729536") and (fightChallenge:getChallengeId() ~= 120) then
                Douleur_Cuisante()
            end

            Hostilite()

            Courrone_Epine()
            
            Deplacement()
            
        end	
end