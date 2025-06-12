---@diagnostic disable: undefined-global, lowercase-global

dofile(global:getCurrentScriptDirectory() .. "\\Settings.lua")


local hdv_door_id = 218

local function launch_hdv_activites(hdv_door_id)
    map:door(hdv_door_id)
    message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
end


local function connectReceiver()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find(receiverAlias .. "_" .. server) then
            if not acc:isAccountFullyConnected() then
                acc:connect()

                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1

                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        global:printError("Bot banque non-connecté après " .. maxWaitingTime .. " secondes, reprise du trajet")
                        cannotConnect = true
	
                        return acc
                    end
                end
                if CONFIG_BANK then
                    acc:loadConfig(CONFIG_BANK)
                end
                if SCRIPT_BANK then
                    acc:loadScript(SCRIPT_BANK)				
                end
                if LAUNCH then
                    acc:startScript()
                end			
                return acc
            else
                return acc
            end
        end
    end
    cannotConnect = true
end

local function rerollVar()
    if global:remember("failed") then
        global:deleteMemory("failed")
    end

    toGive, connected, movingPrinted, givingMode = 0, nil, nil, nil
end

local function launchExchangeAndGive()
    local id = receiver.character():id()
    receiver:exchangeListen(false)
    receiver:exchangeListen(true)
    
    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

	local safetyCount = 0

    while not exchange:launchExchangeWithPlayer(id) and safetyCount < 120 do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
		safetyCount = safetyCount + 5
    end
	if safetyCount >= 120 then
		global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
		receiver:disconnect()
		return
	end

    toGive = (character:kamas() - minKamas) > 100000 and (character:kamas() - minKamas) or 1
    global:printSuccess("on transfère " .. toGive .. " kamas")

    exchange:putKamas(toGive)
    exchange:ready()

    global:delay(3000)

    global:printSuccess("Kamas transférés. Reprise du trajet")
	global:delay(3000)
    rerollVar()
    receiver:disconnect()

    global:restartScript(true)
end

local function goAstrubBank(inBankCallback)
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end
    for _, element in ipairs(MapSansHavreSac) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            map:door(tonumber(element.Door))
        end
    end
    if not map:currentArea():find("Astrub") then
        if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
            return map:changeMap(bankMaps.zAstrub)
        else
            return map:changeMap("havenbag")
        end
    else
        if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
            return map:moveToward(tonumber(bankMaps.bankAstrubInt))
        else
            if inBankCallback then
                return inBankCallback()
            end
        end
    end
end

local function secondsToHours(time)
    return time / 60 / 60
end

local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end

local function RegenEnergie()
    npc:npc(385,6)
    global:delay(1500)

    for _, element in ipairs(tableAchatEnergie) do
        npc:npc(385,6)
        global:delay(1500)
        if inventory:itemCount(element.id) <= 20 and character:maxEnergyPoints()-character:energyPoints() > 500 then
            sale:buyItem(element.id, 10, 20000)
        end
        global:leaveDialog()
        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints()-character:energyPoints() ~=0 do
            inventory:useItem(element.id)
        end
    end
    
    map:changeMap("top")
end

local AreaEnergie = {
    {map = "0,0", path = "zaap(212600323)"},
	{map= "-31,-56", path="bottom"},
	{map= "-31,-55", path="bottom"},
	{map= "-31,-54", path="bottom"},
	{map = "-31,-53", custom = RegenEnergie}, 
}

local function treatMaps(maps)

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end
    global:printSuccess("havresac")
    for _, element in ipairs(MapSansHavreSac) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            map:door(tonumber(element.Door))
        end
    end

    map:changeMap("havenbag")

end

if job:level(2) < 180 then

OPEN_BAGS = true 
local ZoneBis = false
local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local cptActualiser = 0
local achatOliviolet = false
local achatBambou = false

local hdv_door_id = 218

--PLANNING = {3, 8, 13, 18, 23}

local MapSansHavreSac = {
    {Id = 206308353, Path = "left"},
	{Id = 153621, Path = "left"},
    {Id = 168035328, Door = "458"},
    {Id = 168034312, Door = "215"},
    {Id = 168034310, Door = "215"},
    {Id = 104859139, Path = "444"},
    {Id = 168167424, Door = "289"},
    {Id = 104861191, Path = "457"},
    {Id = 57017859, Path = "395"},
    {Id = 168036352, Door = "458"},
    {Id = 104860167, Path = "478"},
    {Id = 104862215, Path = "472"},
    {Id = 104859143, Path = "543"},
	{Id = 153621, Path = "left"},
}		

local function GoToHavresac()
	for _, element in ipairs(MapSansHavreSac) do
		if not element.Door and map:onMap(tostring(element.Id)) then
			return {{map = tostring(element.Id), path = element.Path}}
		elseif map:onMap(tostring(element.Id)) then
			return {{map = tostring(element.Id), door = element.Door}}
		end
	 end	
	 map:changeMap("havenbag")
end

local firstArea = {
	{map = "192415750", path = "409"},
    {map = "189530124", path = "left", gather = true},
    {map = "0,0", path = "zaap(191105026)"},
    {map = "191104002", path = "right(447)"},
    {map = "5,-18", path = "bottom"},
    {map = "5,-17", path = "bottom"},
    {map = "5,-16", path = "bottom"},
    {map = "4,-15", path = "bottom", gather = true},
    {map = "5,-15", path = "left"},
    {map = "4,-14", path = "left"},
    {map = "3,-14", path = "left"},
    {map = "2,-14", path = "left", gather = true},
    {map = "1,-14", path = "left", gather = true},
    {map = "0,-14", path = "top", gather = true},
    {map = "0,-15", path = "left", gather = true},
    {map = "-1,-15", path = "bottom", gather = true},
    {map = "-1,-14", path = "left", gather = true},
    {map = "-2,-14", path = "left", gather = true},
    {map = "-3,-14", path = "top", gather = true},
    {map = "-3,-15", path = "top", gather = true},
    {map = "-3,-16", path = "right", gather = true},
    {map = "-2,-16", path = "right", gather = true},
    {map = "-1,-16", path = "right", gather = true},
    {map = "0,-16", path = "top", gather = true},
    {map = "0,-17", path = "left", gather = true},
    {map = "-1,-17", path = "left", gather = true},
    {map = "-3,-17", path = "top", gather = true},
    {map = "1,-18", path = "top", gather = true},
    {map = "-3,-18", path = "right", gather = true},
    {map = "-2,-18", path = "right", gather = true},
    {map = "-1,-18", path = "right", gather = true},
    {map = "0,-18", path = "right", gather = true},
    {map = "1,-19", path = "left", gather = true},
    {map = "0,-19", path = "left", gather = true},
    {map = "-1,-19", path = "left", gather = true},
    {map = "-2,-19", path = "left", gather = true},
    {map = "-3,-19", path = "top", gather = true},
    {map = "0,-20", path = "top", gather = true},
    {map = "-3,-21", path = "top", gather = true},
    {map = "-3,-20", path = "right", gather = true},
    {map = "-2,-20", path = "right", gather = true},
    {map = "-1,-20", path = "right", gather = true},
    {map = "0,-21", path = "left", gather = true},
    {map = "-1,-21", path = "left", gather = true},
    {map = "-2,-21", path = "left", gather = true},
    {map = "-3,-22", path = "right", gather = true},
    {map = "-2,-22", path = "right", gather = true},
    {map = "-1,-22", path = "right", gather = true},
    {map = "0,-22", path = "right", gather = true},
    {map = "1,-22", path = "right", gather = true},
    {map = "2,-22", path = "top", gather = true},
    {map = "2,-23", path = "left", gather = true},
    {map = "1,-23", path = "left", gather = true},
    {map = "0,-23", path = "left", gather = true},
    {map = "-1,-23", path = "left", gather = true},
    {map = "-2,-23", path = "top", gather = true},
    {map = "-2,-24", path = "right", gather = true},
    {map = "-1,-24", path = "right", gather = true},
    {map = "0,-24", path = "right", gather = true},
    {map = "1,-24", path = "right", gather = true},
    {map = "2,-24", path = "top", gather = true},
    {map = "2,-25", path = "left", gather = true},
    {map = "1,-25", path = "left", gather = true},
    {map = "0,-25", path = "left", gather = true},
    {map = "-1,-25", path = "left", gather = true},
    {map = "-2,-25", path = "top", gather = true},
    {map = "-2,-26", path = "right", gather = true},
    {map = "-1,-26", path = "right", gather = true},
    {map = "0,-26", path = "right", gather = true},
    {map = "1,-26", path = "right", gather = true},
    {map = "2,-26", path = "top", gather = true},
    {map = "2,-27", path = "left", gather = true},
    {map = "1,-27", path = "left", gather = true},
    {map = "0,-27", path = "left", gather = true},
    {map = "-1,-27", path = "left", gather = true},
    {map = "-2,-27", path = "top", gather = true},
    {map = "-2,-28", path = "right", gather = true},
    {map = "-1,-28", path = "right", gather = true},
    {map = "0,-28", path = "right", gather = true},
    {map = "1,-28", path = "right", gather = true},
    {map = "2,-28", path = "top", gather = true},
    {map = "2,-29", path = "top", gather = true},
    {map = "2,-30", path = "right", gather = true},
    {map = "3,-30", path = "bottom"},
    {map = "3,-29", path = "bottom"},
    {map = "3,-28", path = "bottom"},
    {map = "3,-27", path = "bottom"},
    {map = "3,-26", path = "bottom"},
    {map = "3,-24", path = "bottom"},
    {map = "3,-25", path = "bottom"},
    {map = "3,-23", path = "bottom"},
    {map = "3,-22", path = "right"},
    {map = "4,-22", path = "bottom"},
    {map = "4,-21", path = "bottom"},
    {map = "4,-20", path = "bottom"},
    {map = "4,-19", path = "bottom"}
}

local secondArea = {
    {map = "162791424", path = "zaap(84806401)"},
    {map = "-5,-23", path = "left", gather = true},
    {map = "-6,-23", path = "bottom", gather = true},
    {map = "-6,-22", path = "bottom", gather = true},
    {map = "-6,-21", path = "bottom", gather = true},
    {map = "-6,-20", path = "bottom", gather = true},
    {map = "-6,-19", path = "left", gather = true},
    {map = "-7,-19", path = "left", gather = true},
    {map = "-8,-19", path = "top", gather = true},
    {map = "-8,-20", path = "right", gather = true},
    {map = "-7,-20", path = "top", gather = true},
    {map = "-7,-21", path = "top", gather = true},
    {map = "-7,-22", path = "top", gather = true},
    {map = "-7,-23", path = "left", gather = true},
    {map = "-7,-25", path = "left", gather = true},
    {map = "-8,-23", path = "top", gather = true},
    {map = "-7,-24", path = "top", gather = true},
    {map = "-8,-25", path = "top", gather = true},
    {map = "-7,-26", path = "top", gather = true},
    {map = "-8,-24", path = "right", gather = true},
    {map = "-8,-26", path = "right", gather = true},
    {map = "-8,-29", path = "right", gather = true},
    {map = "-9,-32", path = "right", gather = true},
    {map = "-8,-31", path = "left", gather = true},
    {map = "-7,-30", path = "left", gather = true},
    {map = "-7,-28", path = "left", gather = true},
    {map = "-7,-27", path = "top", gather = true},
    {map = "-8,-28", path = "top", gather = true},
    {map = "-7,-29", path = "top", gather = true},
    {map = "-8,-30", path = "top", gather = true},
    {map = "-9,-31", path = "top", gather = true},
    {map = "-8,-32", path = "right", gather = true},
    {map = "-7,-32", path = "bottom", gather = true},
    {map = "-7,-31", path = "right", gather = true},
    {map = "-6,-31", path = "top", gather = true},
    {map = "-6,-32", path = "top", gather = true},
    {map = "-6,-33", path = "left", gather = true},
    {map = "-7,-33", path = "left", gather = true},
    {map = "-8,-33", path = "left", gather = true},
    {map = "-9,-33", path = "top", gather = true},
    {map = "-9,-34", path = "left", gather = true},
    {map = "-10,-33", path = "left", gather = true},
    {map = "-11,-32", path = "left", gather = true},
    {map = "-10,-34", path = "bottom", gather = true},
    {map = "-11,-33", path = "bottom", gather = true},
    {map = "-12,-32", path = "top", gather = true},
    {map = "-12,-33", path = "top", gather = true},
    {map = "-12,-34", path = "top", gather = true},
    {map = "-12,-35", path = "top", gather = true},
    {map = "-14,-35", path = "left", gather = true},
    {map = "-15,-36", path = "left", gather = true},
    {map = "-17,-35", path = "left", gather = true},
    {map = "-16,-35", path = "left", gather = true},
    {map = "-15,-35", path = "top", gather = true},
    {map = "-13,-35", path = "left", gather = true},
    {map = "-18,-35", path = "top", gather = true},
    {map = "-12,-36", path = "left", gather = true},
    {map = "-13,-36", path = "bottom", gather = true},
    {map = "-16,-36", path = "bottom", gather = true},
    {map = "-18,-36", path = "left", gather = true},
    {map = "-19,-36", path = "left", gather = true},
    {map = "-17,-43", path = "top", gather = true},
    {map = "-17,-44", path = "top", gather = true},
    {map = "-17,-46", path = "top", gather = true},
    {map = "-17,-45", path = "top", gather = true},
    {map = "-20,-36", path = "top", gather = true},
    {map = "-19,-37", path = "top", gather = true},
    {map = "-20,-37", path = "right", gather = true},
    {map = "-19,-38", path = "left", gather = true},
    {map = "-20,-38", path = "top", gather = true},
    {map = "-20,-39", path = "top", gather = true},
    {map = "-20,-40", path = "right", gather = true},
    {map = "-19,-40", path = "right", gather = true},
    {map = "-18,-40", path = "top", gather = true},
    {map = "-18,-41", path = "top", gather = true},
    {map = "-17,-42", path = "top", gather = true},
    {map = "-18,-42", path = "right", gather = true},
    {map = "-17,-47", path = "zaap(84806401)"}
}

local thirdArea = { -- bois d'oliviolet
		{map = "0,0", path = "zaap(171967506)"},
   		{map = "-25,11", path = "top", gather = true},
		{map = "-25,10", path = "top", gather = true},
		{map = "-24,9", path = "top", gather = true},
		{map = "-26,8", path = "top", gather = true},
		{map = "-25,6", path = "top", gather = true},
		{map = "-27,4", path = "top", gather = true},
		{map = "-25,9", path = "right", gather = true},
		{map = "-24,8", path = "left", gather = true},
		{map = "-26,7", path = "left", gather = true},
		{map = "-27,7", path = "top", gather = true},
		{map = "-27,6", path = "right"},
		{map = "-26,6", path = "right"},
		{map = "-25,5", path = "top", gather = true},
		{map = "-25,4", path = "left"},
		{map = "-26,4", path = "left", gather = true},
		{map = "-28,3", path = "top", gather = true},
		{map = "-26,3", path = "right", gather = true},
		{map = "-24,3", path = "top", gather = true},
		{map = "-24,2", path = "left", gather = true},
		{map = "-25,2", path = "left", gather = true},
		{map = "-28,2", path = "right"},
		{map = "-27,3", path = "right"},
		{map = "-27,2", path = "bottom"},
		{map = "-25,3", path = "right"},
		{map = "-26,2", path = "top", gather = true},
		{map = "-26,1", path = "right"},
		{map = "-25,1", path = "right", gather = true},
		{map = "-24,1", path = "top"},
		{map = "-24,0", path = "left", gather = true},
		{map = "-25,0", path = "left", gather = true},
		{map = "-27,0", path = "left", gather = true},
		{map = "-26,0", path = "left"},
		{map = "-28,0", path = "top", gather = true},
		{map = "-28,-1", path = "right", gather = true},
		{map = "-27,-1", path = "right"},
		{map = "-26,-1", path = "right"},
		{map = "-25,-1", path = "right", gather = true},
		{map = "-24,-1", path = "right"},
		{map = "-23,-1", path = "top"},
		{map = "-23,-2", path = "left", gather = true},
		{map = "-24,-2", path = "left", gather = true},
		{map = "-25,-2", path = "left", gather = true},
		{map = "-26,-2", path = "left", gather = true},
		{map = "-27,-2", path = "top", gather = true},
		{map = "-27,-3", path = "right", gather = true},
		{map = "-25,-3", path = "right", gather = true},
		{map = "-24,-3", path = "top", gather = true},
		{map = "-23,-4", path = "right", gather = true},
		{map = "-22,-4", path = "top", gather = true},
		{map = "-22,-5", path = "left", gather = true},
		{map = "-23,-5", path = "left", gather = true},
		{map = "-25,-5", path = "left", gather = true},
		{map = "-26,-3", path = "right"},
		{map = "-24,-4", path = "right"},
		{map = "-24,-5", path = "left"},
		{map = "-27,12", path = "top", gather = true},
		{map = "-26,12", path = "left", gather = true},
		{map = "-27,11", path = "right", gather = true},
		{map = "-26,11", path = "right"},
		{map = "-25,12", path = "right"},
		{map = "-25,8", path = "left"},
		{map = "-24,12", path = "bottom", gather = true},
		{map = "-24,13", path = "bottom", gather = true},
		{map = "-21,18", path = "bottom", gather = true},
		{map = "-21,19", path = "bottom", gather = true},
		{map = "-21,20", path = "bottom", gather = true},
		{map = "-21,21", path = "left"},
		{map = "-22,21", path = "top", gather = true},
		{map = "-22,20", path = "top", gather = true},
		{map = "-22,18", path = "top", gather = true},
		{map = "-22,19", path = "top"},
		{map = "-22,17", path = "left"},
		{map = "-23,17", path = "top"},
		{map = "-23,16", path = "left", gather = true},
		{map = "-24,16", path = "top"},
		{map = "-24,15", path = "left", gather = true},
		{map = "-25,15", path = "top"},
		{map = "-25,14", path = "top", gather = true},
		{map = "-25,13", path = "left", gather = true},
		{map = "-26,13", path = "top"},
		{map = "-24,14", path = "right", gather = true},
		{map = "-23,14", path = "bottom"},
		{map = "-23,15", path = "right", gather = true},
		{map = "-22,16", path = "right", gather = true},
		{map = "-22,15", path = "bottom"},
		{map = "-20,16", path = "bottom"},
		{map = "-21,16", path = "right"},
		{map = "-20,17", path = "left", gather = true},
		{map = "-21,17", path = "bottom"},
		{map = "-21,13", path = "bottom"},
		{map = "-26,-5", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local thirdAreaBis = {
    {map = "0,0", path = "zaap(54172969)"},
	{map = "-78,-41", path = "top"},
	{map = "-78,-42", path = "top"},
	{map = "-78,-43", path = "top"},
	{map = "-78,-44", path = "top"},
	{map = "-78,-45", path = "top"},
	{map = "-78,-46", path = "right"},
	{map = "-77,-46", path = "right"},
	{map = "-76,-46", path = "top"},
	{map = "-76,-47", path = "top"},
	{map = "-76,-48", path = "top"},
	{map = "-76,-49", path = "right", gather = true},
	{map = "-75,-48", path = "right", gather = true},
	{map = "-74,-49", path = "right", gather = true},
	{map = "-75,-49", path = "bottom", gather = true},
	{map = "-73,-49", path = "bottom", gather = true},
	{map = "-73,-46", path = "right", gather = true},
	{map = "-70,-48", path = "right", gather = true},
	{map = "-69,-48", path = "right", gather = true},
	{map = "-68,-48", path = "bottom", gather = true},
	{map = "-68,-47", path = "bottom", gather = true},
	{map = "-68,-46", path = "right", gather = true},
	{map = "-67,-46", path = "top"},
	{map = "-67,-47", path = "right", gather = true},
	{map = "-65,-48", path = "top", gather = true},
	{map = "-66,-51", path = "top", gather = true},
	{map = "-65,-51", path = "left", gather = true},
	{map = "-62,-49", path = "top", gather = true},
	{map = "-61,-50", path = "top", gather = true},
	{map = "-62,-50", path = "right", gather = true},
	{map = "-61,-51", path = "left", gather = true},
	{map = "-62,-51", path = "top", gather = true},
	{map = "-62,-52", path = "right"},
	{map = "-61,-52", path = "right", gather = true},
	{map = "-59,-51", path = "top", gather = true},
	{map = "-58,-52", path = "top", gather = true},
	{map = "-59,-54", path = "top", gather = true},
	{map = "-59,-52", path = "right", gather = true},
	{map = "-58,-54", path = "left", gather = true},
	{map = "-58,-53", path = "top"},
	{map = "-59,-55", path = "right", gather = true},
	{map = "-58,-55", path = "top", gather = true},
	{map = "-58,-56", path = "top", gather = true},
	{map = "-58,-57", path = "right", gather = true},
	{map = "-57,-57", path = "right", gather = true},
	{map = "-56,-57", path = "top", gather = true},
	{map = "-56,-58", path = "top", gather = true},
	{map = "-56,-59", path = "top", gather = true},
	{map = "-56,-60", path = "left"},
	{map = "-57,-60", path = "top", gather = true},
	{map = "-57,-61", path = "left", gather = true},
	{map = "-58,-61", path = "top", gather = true},
	{map = "-58,-62", path = "right", gather = true},
	{map = "-57,-62", path = "top"},
	{map = "-57,-63", path = "left", gather = true},
	{map = "-58,-63", path = "left", gather = true},
	{map = "-59,-63", path = "top", gather = true},
	{map = "-59,-64", path = "left", gather = true},
	{map = "-60,-64", path = "left", gather = true},
	{map = "-61,-63", path = "left", gather = true},
	{map = "-62,-63", path = "bottom", gather = true},
	{map = "-62,-62", path = "left", gather = true},
	{map = "-63,-62", path = "left", gather = true},
	{map = "-64,-62", path = "left", gather = true},
	{map = "-65,-62", path = "bottom", gather = true},
	{map = "-65,-61", path = "left", gather = true},
	{map = "-67,-61", path = "bottom", gather = true},
	{map = "-67,-60", path = "bottom", gather = true},
	{map = "-67,-59", path = "left", gather = true},
	{map = "-68,-59", path = "left", gather = true},
	{map = "-69,-59", path = "bottom", gather = true},
	{map = "-74,-48", path = "top"},
	{map = "-73,-48", path = "bottom"},
	{map = "-73,-47", path = "bottom"},
	{map = "-72,-46", path = "right"},
	{map = "-71,-46", path = "right"},
	{map = "-70,-46", path = "top"},
	{map = "-70,-47", path = "top"},
	{map = "-66,-47", path = "top"},
	{map = "-66,-48", path = "right"},
	{map = "-65,-49", path = "top"},
	{map = "-65,-50", path = "top"},
	{map = "-66,-52", path = "right"},
	{map = "-65,-52", path = "right"},
	{map = "-64,-52", path = "right"},
	{map = "-64,-51", path = "bottom"},
	{map = "-64,-50", path = "bottom"},
	{map = "-64,-49", path = "right"},
	{map = "-63,-49", path = "right"},
	{map = "-60,-51", path = "right"},
	{map = "-60,-52", path = "bottom"},
	{map = "-61,-64", path = "bottom"},
	{map = "-66,-61", path = "left"},
	{map = "-63,-52", path = "bottom"},
	{map = "-63,-51", path = "left"},
}

local forthArea = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", custom = function() map:moveToCell(329) map:changeMap("right") end, gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-10,-53", path = "bottom", gather = true},
		{map = "-10,-52", path = "bottom", gather = true},
		{map = "-10,-51", path = "bottom", gather = true},
		{map = "-10,-50", path = "bottom", gather = true},
		{map = "-10,-49", path = "bottom", gather = true},
		{map = "-10,-48", path = "right", gather = true},
		{map = "-9,-48", path = "right", gather = true},
		{map = "-9,-46", path = "left", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", custom = function() map:moveToCell(255) map:changeMap("bottom") end, gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true}
}

local forthAreaV2 = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", path = "right", gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-9,-46", path = "left", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", path = "bottom", gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true},
		{map = "-10,-53", path = "right", gather = true},
		{map = "-9,-53", path = "right", gather = true},
		{map = "-8,-53", path = "right", gather = true},
		{map = "-6,-54", path = "bottom", gather = true},
		{map = "-7,-53", path = "top", gather = true},
		{map = "-7,-54", path = "right", gather = true},
		{map = "-6,-53", path = "bottom", gather = true},
		{map = "-6,-52", path = "left", gather = true},
		{map = "-7,-52", path = "bottom", gather = true},
		{map = "-7,-51", path = "right", gather = true},
		{map = "-6,-51", path = "right", gather = true},
		{map = "-5,-51", path = "right", gather = true},
		{map = "-4,-51", path = "right", gather = true},
		{map = "-3,-51", path = "bottom", gather = true},
		{map = "-3,-50", path = "right", gather = true},
		{map = "-2,-50", path = "bottom", gather = true},
		{map = "-2,-49", path = "left", gather = true},
		{map = "-3,-49", path = "left", gather = true},
		{map = "-4,-50", path = "left", gather = true},
		{map = "-5,-50", path = "left", gather = true},
		{map = "-6,-50", path = "left", gather = true},
		{map = "-7,-50", path = "left", gather = true},
		{map = "-8,-50", path = "bottom", gather = true},
		{map = "-8,-49", path = "bottom", gather = true},
		{map = "-4,-49", path = "top", gather = true}
}

local forthAreaV3 = {
		{map = "162791424", path = "zaap(147590153)"},
		{map = "-16,-46", path = "top", gather = true},
		{map = "-14,-47", path = "right", gather = true},
		{map = "-13,-47", path = "right", gather = true},
		{map = "-12,-47", path = "top", gather = true},
		{map = "-12,-48", path = "left", gather = true},
		{map = "-13,-48", path = "left", gather = true},
		{map = "-14,-48", path = "left", gather = true},
		{map = "-15,-48", path = "top", gather = true},
		{map = "-15,-49", path = "top", gather = true},
		{map = "-15,-50", path = "right", gather = true},
		{map = "-14,-50", path = "bottom", gather = true},
		{map = "-14,-49", path = "right", gather = true},
		{map = "-13,-49", path = "right", gather = true},
		{map = "-12,-49", path = "right", gather = true},
		{map = "-11,-49", path = "top", gather = true},
		{map = "-11,-50", path = "left", gather = true},
		{map = "-12,-50", path = "left", gather = true},
		{map = "-13,-50", path = "top", gather = true},
		{map = "-13,-51", path = "left", gather = true},
		{map = "-14,-51", path = "left", gather = true},
		{map = "-15,-51", path = "top", gather = true},
		{map = "-15,-52", path = "right", gather = true},
		{map = "-14,-52", path = "right", gather = true},
		{map = "-13,-52", path = "right", gather = true},
		{map = "-12,-52", path = "right", gather = true},
		{map = "-11,-52", path = "top", gather = true},
		{map = "-11,-53", path = "left", gather = true},
		{map = "-12,-53", path = "left", gather = true},
		{map = "-13,-53", path = "left", gather = true},
		{map = "-14,-53", path = "left", gather = true},
		{map = "-15,-53", path = "top", gather = true},
		{map = "-15,-54", path = "right", gather = true},
		{map = "-14,-54", path = "right", gather = true},
		{map = "-13,-54", path = "top", gather = true},
		{map = "-13,-55", path = "right", gather = true},
		{map = "-12,-55", path = "bottom", gather = true},
		{map = "-12,-54", path = "right", gather = true},
		{map = "-11,-54", path = "top", gather = true},
		{map = "-11,-55", path = "top", gather = true},
		{map = "-11,-56", path = "top", gather = true},
		{map = "-11,-57", path = "left", gather = true},
		{map = "-12,-57", path = "top", gather = true},
		{map = "-12,-58", path = "left", gather = true},
		{map = "-13,-58", path = "bottom", gather = true},
		{map = "-13,-57", path = "bottom", gather = true},
		{map = "-13,-56", path = "left", gather = true},
		{map = "-14,-56", path = "left", gather = true},
		{map = "-15,-56", path = "top", gather = true},
		{map = "-15,-57", path = "right", gather = true},
		{map = "-14,-57", path = "top", gather = true},
		{map = "-14,-58", path = "left", gather = true},
		{map = "-15,-58", path = "top", gather = true},
		{map = "-15,-59", path = "right", gather = true},
		{map = "-14,-59", path = "right", gather = true},
		{map = "-13,-59", path = "right", gather = true},
		{map = "-12,-59", path = "right", gather = true},
		{map = "-11,-59", path = "bottom", gather = true},
		{map = "-11,-58", path = "right", gather = true},
		{map = "-10,-58", path = "bottom", gather = true},
		{map = "-14,-46", path = "top", gather = true},
		{map = "-15,-46", path = "bottom", gather = true},
		{map = "-15,-45", path = "right", gather = true},
		{map = "-14,-45", path = "top", gather = true},
		{map = "-17,-47", path = "right", gather = true},
		{map = "-10,-57", path = "bottom", gather = true},
		{map = "-10,-56", path = "bottom", gather = true},
		{map = "-10,-55", path = "bottom", gather = true},
		{map = "-10,-54", path = "bottom", gather = true},
		{map = "-12,-46", path = "left", gather = true},
		{map = "-8,-48", path = "right", gather = true},
		{map = "-7,-48", path = "bottom", gather = true},
		{map = "-7,-47", path = "left", gather = true},
		{map = "-8,-47", path = "left", gather = true},
		{map = "-9,-47", path = "bottom", gather = true},
		{map = "-13,-46", path = "bottom", gather = true},
		{map = "-13,-45", path = "bottom", gather = true},
		{map = "-13,-44", path = "left", gather = true},
		{map = "-14,-44", path = "left", gather = true},
		{map = "-15,-44", path = "left", gather = true},
		{map = "-16,-44", path = "top", gather = true},
		{map = "-16,-47", path = "right", gather = true},
		{map = "-15,-47", path = "bottom", gather = true},
		{map = "-16,-45", path = "top", gather = true},
		{map = "-10,-53", path = "right", gather = true},
		{map = "-9,-53", path = "right", gather = true},
		{map = "-8,-53", path = "right", gather = true},
		{map = "-6,-54", path = "bottom", gather = true},
		{map = "-7,-53", path = "top", gather = true},
		{map = "-6,-53", path = "bottom", gather = true},
		{map = "-6,-52", path = "left", gather = true},
		{map = "-7,-52", path = "bottom", gather = true},
		{map = "-7,-51", path = "right", gather = true},
		{map = "-6,-51", path = "right", gather = true},
		{map = "-5,-51", path = "right", gather = true},
		{map = "-4,-51", path = "right", gather = true},
		{map = "-3,-51", path = "bottom", gather = true},
		{map = "-3,-50", path = "right", gather = true},
		{map = "-2,-50", path = "bottom", gather = true},
		{map = "-2,-49", path = "left", gather = true},
		{map = "-3,-49", path = "left", gather = true},
		{map = "-4,-50", path = "left", gather = true},
		{map = "-5,-50", path = "left", gather = true},
		{map = "-6,-50", path = "left", gather = true},
		{map = "-7,-50", path = "left", gather = true},
		{map = "-8,-50", path = "bottom", gather = true},
		{map = "-8,-49", path = "bottom", gather = true},
		{map = "-4,-49", path = "top", gather = true},
		{map = "-7,-54", path = "top", gather = true},
		{map = "-7,-55", path = "top", gather = true},
		{map = "-7,-56", path = "top", gather = true},
		{map = "-7,-57", path = "top", gather = true},
		{map = "-7,-58", path = "right", gather = true},
		{map = "-6,-58", path = "right", gather = true},
		{map = "-5,-58", path = "right", gather = true},
		{map = "-4,-58", path = "right", gather = true},
		{map = "-3,-58", path = "bottom", gather = true},
		{map = "-3,-57", path = "left", gather = true},
		{map = "-4,-57", path = "left", gather = true},
		{map = "-5,-57", path = "left", gather = true},
		{map = "-5,-55", path = "left", gather = true},
		{map = "-6,-57", path = "bottom", gather = true},
		{map = "-5,-56", path = "bottom", gather = true},
		{map = "-6,-55", path = "bottom", gather = true},
		{map = "-6,-56", path = "right", gather = true},
		{map = "-9,-46", path = "bottom", gather = true},
		{map = "-9,-45", path = "bottom", gather = true},
		{map = "-9,-44", path = "bottom", gather = true},
		{map = "-9,-43", path = "bottom", gather = true},
		{map = "-9,-42", path = "left", gather = true},
		{map = "-10,-42", path = "left", gather = true},
		{map = "-11,-42", path = "left", gather = true},
		{map = "-12,-42", path = "left", gather = true},
		{map = "-13,-42", path = "top", gather = true},
		{map = "-13,-43", path = "right", gather = true},
		{map = "-12,-43", path = "top", gather = true},
		{map = "-12,-44", path = "top", gather = true},
		{map = "-10,-45", path = "top", gather = true},
		{map = "-12,-45", path = "right", gather = true},
		{map = "-11,-45", path = "right", gather = true},
		{map = "-10,-46", path = "left", gather = true},
		{map = "-11,-46", path = "left", gather = true}
}

local fifthArea = {
    {map = "162791424", path = "zaap(154642)"},
    {map = "-47,19", path = "left"},
    {map = "-48,19", path = "left"},
    {map = "-46,18", path = "left"},
    {map = "-47,18", path = "bottom"},
    {map = "-49,19", path = "top"},
    {map = "-49,18", path = "top"},
    {map = "-49,17", path = "top"},
    {map = "-49,16", path = "top"},
    {map = "-49,15", path = "top"},
    {map = "-49,14", path = "top"},
    {map = "-49,13", path = "top"},
    {map = "-49,12", path = "left"},
    {map = "-50,12", path = "left", gather = true},
    {map = "-51,12", path = "left", gather = true},
    {map = "-52,12", path = "top", gather = true},
    {map = "-52,11", path = "top", gather = true},
    {map = "-52,10", path = "left", gather = true},
    {map = "-54,10", path = "bottom", gather = true},
    {map = "-54,11", path = "left", gather = true},
    {map = "-55,11", path = "bottom", gather = true},
    {map = "-55,12", path = "bottom", gather = true},
    {map = "-55,13", path = "left", gather = true},
    {map = "-56,13", path = "bottom", gather = true},
    {map = "-56,14", path = "bottom", gather = true},
    {map = "-56,15", path = "bottom", gather = true},
    {map = "-56,16", path = "bottom", gather = true},
    {map = "-56,17", path = "bottom", gather = true},
    {map = "-56,18", path = "bottom", gather = true},
    {map = "-56,19", path = "bottom", gather = true},
    {map = "-56,20", path = "right", gather = true},
    {map = "-55,20", path = "top", gather = true},
    {map = "-55,19", path = "top", gather = true},
    {map = "-55,18", path = "top", gather = true},
    {map = "-55,17", path = "top", gather = true},
    {map = "-55,16", path = "top", gather = true},
    {map = "-55,15", path = "top", gather = true},
    {map = "-55,14", path = "right", gather = true},
    {map = "-54,14", path = "top", gather = true},
    {map = "-54,13", path = "right", gather = true},
    {map = "-53,13", path = "bottom", gather = true},
    {map = "-53,14", path = "bottom", gather = true},
    {map = "-53,15", path = "left", gather = true},
    {map = "-54,15", path = "bottom", gather = true},
    {map = "-54,16", path = "bottom", gather = true},
    {map = "-54,17", path = "bottom", gather = true},
    {map = "-54,18", path = "bottom", gather = true},
    {map = "-54,19", path = "bottom", gather = true},
    {map = "-54,20", path = "bottom", gather = true},
    {map = "-54,21", path = "right", gather = true},
    {map = "-53,21", path = "top", gather = true},
    {map = "-53,19", path = "top", gather = true},
    {map = "-52,19", path = "left", gather = true},
    {map = "-53,18", path = "right", gather = true},
    {map = "-52,18", path = "top", gather = true},
    {map = "-52,17", path = "top", gather = true},
    {map = "-52,20", path = "top", gather = true},
    {map = "-52,16", path = "top", gather = true},
    {map = "-52,15", path = "top", gather = true},
    {map = "-52,14", path = "top", gather = true},
    {map = "-52,13", path = "right", gather = true},
    {map = "-51,13", path = "bottom", gather = true},
    {map = "-51,14", path = "bottom", gather = true},
    {map = "-51,15", path = "right", gather = true},
    {map = "-50,15", path = "bottom", gather = true},
    {map = "-50,16", path = "left", gather = true},
    {map = "-51,16", path = "bottom", gather = true},
    {map = "-51,17", path = "right", gather = true},
    {map = "-50,17", path = "bottom", gather = true},
    {map = "-50,18", path = "left", gather = true},
    {map = "-51,18", path = "bottom", gather = true},
    {map = "-51,19", path = "bottom", gather = true},
    {map = "-51,20", path = "bottom", gather = true},
    {map = "-51,21", path = "right"},
    {map = "-50,21", path = "right"},
    {map = "-49,21", path = "top"},
    {map = "-49,20", path = "top"},
    {map = "-53,10", path = "top", gather = true},
	{map = "-53,9", path = "left(196)", gather = true},
	{map = "-54,9", path = "left", gather = true},
	{map = "-55,9", path = "bottom", gather = true},
	{map = "-55,10", path = "right", gather = true},
    {map = "-53,20", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local fifthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
	{map = "-17,-47", path = "right"},
	{map = "-16,-47", path = "right"},
	{map = "-15,-47", path = "right"},
	{map = "-14,-47", path = "right"},
	{map = "-13,-47", path = "bottom", gather = true},
	{map = "-13,-46", path = "bottom", gather = true},
	{map = "-13,-44", path = "bottom", gather = true},
	{map = "-13,-43", path = "bottom", gather = true},
	{map = "-13,-42", path = "right", gather = true},
	{map = "-12,-42", path = "top", gather = true},
	{map = "-12,-43", path = "right"},
	{map = "-11,-43", path = "bottom", gather = true},
	{map = "-11,-42", path = "right", gather = true},
	{map = "-10,-42", path = "right(139)", gather = true},
	{map = "-9,-42", path = "top", gather = true},
	{map = "-9,-43", path = "top", gather = true},
	{map = "-9,-44", path = "top", gather = true},
	{map = "-9,-45", path = "top", gather = true},
	{map = "-9,-46", path = "left", gather = true},
	{map = "-10,-46", path = "left", gather = true},
	{map = "-11,-46", path = "left", gather = true},
	{map = "-12,-46", path = "top", gather = true},
	{map = "-12,-47", path = "top", gather = true},
	{map = "-12,-48", path = "top", gather = true},
	{map = "-12,-49", path = "top", gather = true},
	{map = "-12,-50", path = "top", gather = true},
	{map = "-12,-51", path = "top", gather = true},
	{map = "-12,-52", path = "top", gather = true},
	{map = "-12,-53", path = "top", gather = true},
	{map = "-12,-54", path = "top", gather = true},
	{map = "-12,-55", path = "top", gather = true},
	{map = "-12,-56", path = "right", gather = true},
	{map = "-11,-56", path = "top", gather = true},
	{map = "-12,-57", path = "top", gather = true},
	{map = "-12,-58", path = "top", gather = true},
	{map = "-11,-57", path = "left", gather = true},
	{map = "-12,-59", path = "right", gather = true},
	{map = "-11,-59", path = "right", gather = true},
	{map = "-10,-59", path = "right"},
	{map = "-9,-59", path = "right"},
	{map = "-8,-59", path = "right"},
	{map = "-7,-59", path = "right"},
	{map = "-6,-59", path = "bottom"},
	{map = "-6,-58", path = "right", gather = true},
	{map = "-5,-58", path = "right"},
	{map = "-4,-58", path = "right", gather = true},
	{map = "-3,-58", path = "bottom", gather = true},
	{map = "-3,-57", path = "left", gather = true},
	{map = "-4,-57", path = "left"},
	{map = "-5,-57", path = "left", gather = true},
	{map = "-6,-57", path = "bottom", gather = true},
	{map = "-5,-56", path = "bottom", gather = true},
	{map = "-6,-55", path = "bottom", gather = true},
	{map = "-6,-54", path = "left", gather = true},
	{map = "-7,-54", path = "left", gather = true},
	{map = "-12,-45", path = "bottom", gather = true},
	{map = "-13,-45", path = "right", gather = true},
	{map = "-12,-44", path = "left", gather = true},
	{map = "-8,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local fifthAreaV2 = {
		{map = "162791424", path = "zaap(154642)"},
		{map = "-47,19", path = "left"},
		{map = "-48,19", path = "left"},
		{map = "-46,18", path = "left"},
		{map = "-47,18", path = "bottom"},
		{map = "-49,19", path = "top"},
		{map = "-49,18", path = "top"},
		{map = "-49,17", path = "top"},
		{map = "-49,16", path = "top"},
		{map = "-49,15", path = "top"},
		{map = "-49,14", path = "top"},
		{map = "-49,13", path = "top"},
		{map = "-49,12", path = "left"},
		{map = "-50,12", path = "left", gather = true},
		{map = "-51,12", path = "left", gather = true},
		{map = "-52,12", path = "top", gather = true},
		{map = "-52,11", path = "top", gather = true},
		{map = "-52,10", path = "left", gather = true},
		{map = "-54,10", path = "bottom", gather = true},
		{map = "-54,11", path = "left", gather = true},
		{map = "-55,11", path = "bottom", gather = true},
		{map = "-55,12", path = "bottom", gather = true},
		{map = "-55,13", path = "left", gather = true},
		{map = "-56,13", path = "bottom", gather = true},
		{map = "-56,14", path = "bottom", gather = true},
		{map = "-56,15", path = "bottom", gather = true},
		{map = "-56,16", path = "bottom", gather = true},
		{map = "-56,17", path = "bottom", gather = true},
		{map = "-56,18", path = "bottom", gather = true},
		{map = "-56,19", path = "bottom", gather = true},
		{map = "-56,20", path = "right", gather = true},
		{map = "-55,20", path = "top", gather = true},
		{map = "-55,19", path = "top", gather = true},
		{map = "-55,18", path = "top", gather = true},
		{map = "-55,17", path = "top", gather = true},
		{map = "-55,16", path = "top", gather = true},
		{map = "-55,15", path = "top", gather = true},
		{map = "-55,14", path = "right", gather = true},
		{map = "-54,14", path = "top", gather = true},
		{map = "-54,13", path = "right", gather = true},
		{map = "-53,13", path = "bottom", gather = true},
		{map = "-53,14", path = "bottom", gather = true},
		{map = "-53,15", path = "left", gather = true},
		{map = "-54,15", path = "bottom", gather = true},
		{map = "-54,16", path = "bottom", gather = true},
		{map = "-54,17", path = "bottom", gather = true},
		{map = "-54,18", path = "bottom", gather = true},
		{map = "-54,19", path = "bottom", gather = true},
		{map = "-54,20", path = "bottom", gather = true},
		{map = "-54,21", path = "right", gather = true},
		{map = "-53,21", path = "top", gather = true},
		{map = "-53,19", path = "top", gather = true},
		{map = "-52,19", path = "left", gather = true},
		{map = "-53,18", path = "right", gather = true},
		{map = "-52,18", path = "top", gather = true},
		{map = "-52,17", path = "top", gather = true},
		{map = "-52,20", path = "top", gather = true},
		{map = "-52,16", path = "top", gather = true},
		{map = "-52,15", path = "top", gather = true},
		{map = "-52,14", path = "top", gather = true},
		{map = "-52,13", path = "right", gather = true},
		{map = "-51,13", path = "bottom", gather = true},
		{map = "-51,14", path = "bottom", gather = true},
		{map = "-51,15", path = "right", gather = true},
		{map = "-50,15", path = "bottom", gather = true},
		{map = "-50,16", path = "left", gather = true},
		{map = "-51,16", path = "bottom", gather = true},
		{map = "-51,17", path = "right", gather = true},
		{map = "-50,17", path = "bottom", gather = true},
		{map = "-50,18", path = "left", gather = true},
		{map = "-51,18", path = "bottom", gather = true},
		{map = "-51,19", path = "bottom", gather = true},
		{map = "-51,20", path = "bottom", gather = true},
		{map = "-51,21", path = "right"},
		{map = "-50,21", path = "right"},
		{map = "-49,21", path = "top"},
		{map = "-49,20", path = "top"},
		{map = "-53,10", path = "top", gather = true},
		{map = "-53,9", path = "left(196)", gather = true},
		{map = "-54,9", path = "left", gather = true},
		{map = "-55,9", path = "bottom", gather = true},
		{map = "-55,10", path = "right", gather = true},
		{map = "-53,20", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},
}

local fifthAreaV2Bis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-47", path = "right"},
    {map = "-13,-47", path = "bottom", gather = true},
    {map = "-13,-46", path = "bottom", gather = true},
    {map = "-13,-44", path = "bottom", gather = true},
    {map = "-13,-43", path = "bottom", gather = true},
    {map = "-13,-42", path = "right", gather = true},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right"},
    {map = "-11,-42", path = "right", gather = true},
    {map = "-9,-42", path = "top", gather = true},
    {map = "-9,-43", path = "top", gather = true},
    {map = "-9,-44", path = "top", gather = true},
    {map = "-9,-45", path = "top", gather = true},
    {map = "-9,-46", path = "left", gather = true},
    {map = "-10,-46", path = "left", gather = true},
    {map = "-11,-46", path = "left", gather = true},
    {map = "-12,-46", path = "top", gather = true},
    {map = "-12,-47", path = "top", gather = true},
    {map = "-12,-49", path = "top", gather = true},
    {map = "-12,-50", path = "left", gather = true},
    {map = "-12,-51", path = "top", gather = true},
    {map = "-12,-52", path = "top", gather = true},
    {map = "-12,-53", path = "top", gather = true},
    {map = "-12,-55", path = "top", gather = true},
    {map = "-12,-56", path = "right", gather = true},
    {map = "-11,-56", path = "top", gather = true},
    {map = "-12,-58", path = "left", gather = true},
    {map = "-11,-57", path = "left", gather = true},
    {map = "-12,-59", path = "right", gather = true},
    {map = "-11,-59", path = "right", gather = true},
    {map = "-10,-59", path = "right"},
    {map = "-9,-59", path = "right"},
    {map = "-8,-59", path = "right"},
    {map = "-7,-59", path = "right"},
    {map = "-6,-59", path = "bottom"},
    {map = "-6,-58", path = "right", gather = true},
    {map = "-5,-58", path = "right"},
    {map = "-4,-58", path = "right", gather = true},
    {map = "-3,-58", path = "bottom", gather = true},
    {map = "-3,-57", path = "left", gather = true},
    {map = "-4,-57", path = "left"},
    {map = "-5,-57", path = "left", gather = true},
    {map = "-6,-57", path = "bottom", gather = true},
    {map = "-5,-56", path = "bottom", gather = true},
    {map = "-6,-55", path = "bottom", gather = true},
    {map = "-6,-54", path = "left", gather = true},
    {map = "-7,-54", path = "left", gather = true},
    {map = "-12,-45", path = "bottom", gather = true},
    {map = "-13,-45", path = "right", gather = true},
    {map = "-12,-44", path = "left", gather = true},
    {map = "-12,-48", path = "left", gather = true},
    {map = "-13,-48", path = "top", gather = true},
    {map = "-13,-49", path = "right", gather = true},
    {map = "-13,-50", path = "left", gather = true},
    {map = "-14,-50", path = "left", gather = true},
    {map = "-15,-50", path = "top", gather = true},
    {map = "-15,-51", path = "right", gather = true},
    {map = "-13,-51", path = "right", gather = true},
    {map = "-14,-51", path = "top", gather = true},
    {map = "-14,-52", path = "right", gather = true},
    {map = "-13,-52", path = "bottom", gather = true},
    {map = "-11,-43", path = "bottom", gather = true},
    {map = "-12,-54", path = "top", gather = true},
    {map = "-15,-57", path = "left", gather = true},
    {map = "-16,-57", path = "left", gather = true},
    {map = "-17,-57", path = "left", gather = true},
    {map = "-18,-57", path = "top", gather = true},
    {map = "-18,-58", path = "right", gather = true},
    {map = "-17,-58", path = "right", gather = true},
    {map = "-16,-58", path = "right", gather = true},
    {map = "-15,-58", path = "right", gather = true},
    {map = "-14,-57", path = "left", gather = true},
    {map = "-13,-57", path = "left", gather = true},
    {map = "-12,-57", path = "top", gather = true},
    {map = "-13,-58", path = "bottom", gather = true},
    {map = "-14,-58", path = "top", gather = true},
    {map = "-14,-59", path = "right", gather = true},
    {map = "-13,-59", path = "right", gather = true},
    {map = "-10,-42", path = "right(139)", gather = true},
    {map = "-8,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local sixthArea = { -- bois de bambou, if, erable, chene
		{map = "0,0", path = "zaap(207619076)"},
		{map = "207619076", path = "436"},
		{map = "24,-34", door = "294", gather = true},
		{map = "23,-29", path = "right", gather = true},
		{map = "25,-28", path = "right", gather = true},
		{map = "26,-28", path = "top", gather = true},
		{map = "26,-29", path = "right", gather = true},
		{map = "27,-30", path = "top", gather = true},
		{map = "27,-31", path = "left", gather = true},
		{map = "26,-31", path = "left", gather = true},
		{map = "25,-30", custom = function() map:moveToCell(271) map:moveToCell(342) map:changeMap("left") end},
		{map = "24,-30", path = "top", gather = true},
		{map = "24,-31", path = "right", gather = true},
		{map = "25,-34", path = "left", gather = true},
		{map = "19,-29", path = "top", gather = true},
		{map = "21,-27", path = "right", gather = true},
		{map = "20,-30", path = "right", gather = true},
		{map = "20,-31", path = "right", gather = true},
		{map = "23,-28", path = "top", gather = true},
		{map = "23,-27", path = "top", gather = true},
		{map = "21,-26", path = "top", gather = true},
		{map = "19,-26", path = "bottom", gather = true},
		{map = "19,-25", path = "right", gather = true},
		{map = "21,-25", path = "top", gather = true},
		{map = "206307842", path = "left"},
		{map = "19,-30", path = "right", gather = true},
		{map = "21,-31", path = "bottom"},
		{map = "21,-30", path = "bottom"},
		{map = "21,-29", path = "bottom"},
		{map = "21,-28", path = "left"},
		{map = "20,-28", path = "bottom"},
		{map = "20,-27", path = "bottom", gather = true},
		{map = "20,-26", path = "left"},
		{map = "20,-25", path = "right"},
		{map = "22,-27", path = "right"},
		{map = "24,-29", path = "bottom"},
		{map = "24,-28", path = "right"},
		{map = "27,-29", path = "top"},
		{map = "25,-31", path = "top|bottom"},
		{map = "25,-32", path = "top"},
		{map = "25,-33", path = "top"},
		{map = "23,-34", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true}
}

local sixthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "top", gather = true},
    {map = "-14,-51", path = "top", gather = true},
    {map = "-13,-59", path = "bottom", gather = true},
    {map = "-14,-58", path = "bottom", gather = true},
    {map = "-14,-48", path = "top", gather = true},
    {map = "-15,-48", path = "right", gather = true},
    {map = "-14,-49", path = "top", gather = true},
    {map = "-14,-50", path = "top", gather = true},
    {map = "-13,-52", path = "right"},
    {map = "-12,-53", path = "top", gather = true},
    {map = "-12,-52", path = "top", gather = true},
    {map = "-12,-54", path = "top", gather = true},
    {map = "-14,-52", path = "right", gather = true},
    {map = "-12,-55", path = "top", gather = true},
    {map = "-12,-56", path = "right"},
    {map = "-11,-58", path = "top", gather = true},
    {map = "-11,-59", path = "left", gather = true},
    {map = "-11,-56", path = "top", gather = true},
    {map = "-11,-57", path = "left", gather = true},
    {map = "-12,-58", path = "right", gather = true},
    {map = "-12,-59", path = "left", gather = true},
    {map = "-12,-57", path = "top", gather = true},
    {map = "-13,-58", path = "left", gather = true},
    {map = "-14,-54", custom = function() ZoneBis = false map:changeMap("havenbag") end}
}

local seventhArea = { --  bois de bambu sombre, charme, mérisier
		{map = "0,0", path = "zaap(207619076)"},
		{map = "207619076", path = "436"},
		{map = "23,-29", path = "right", gather = true},
		{map = "25,-28", path = "right", gather = true},
		{map = "26,-28", path = "top", gather = true},
		{map = "26,-29", path = "right", gather = true},
		{map = "27,-30", path = "top", gather = true},
		{map = "27,-31", path = "left", gather = true},
		{map = "26,-31", path = "left", gather = true},
		{map = "25,-30", path = "left", gather = true},
		{map = "24,-30", path = "top", gather = true},
		{map = "24,-31", path = "right", gather = true},
		{map = "25,-34", path = "left", gather = true},
		{map = "24,-34", door = "294", gather = true},
		{map = "19,-29", path = "top", gather = true},
		{map = "21,-27", path = "right", gather = true},
		{map = "20,-30", path = "right", gather = true},
		{map = "20,-31", path = "right", gather = true},
		{map = "23,-28", path = "top", gather = true},
		{map = "23,-27", path = "top", gather = true},
		{map = "21,-26", path = "top", gather = true},
		{map = "19,-26", path = "bottom", gather = true},
		{map = "19,-25", path = "right", gather = true},
		{map = "21,-25", path = "top", gather = true},
		{map = "206307842", path = "left"},
		{map = "19,-30", path = "right", gather = true},
		{map = "21,-31", path = "bottom"},
		{map = "21,-30", path = "bottom"},
		{map = "21,-29", path = "bottom"},
		{map = "21,-28", path = "left"},
		{map = "20,-28", path = "bottom"},
		{map = "20,-27", path = "bottom", gather = true},
		{map = "20,-26", path = "left"},
		{map = "20,-25", path = "right"},
		{map = "22,-27", path = "right"},
		{map = "24,-29", path = "bottom"},
		{map = "24,-28", path = "right"},
		{map = "27,-29", path = "top"},
		{map = "25,-31", path = "top|bottom"},
		{map = "25,-32", path = "top"},
		{map = "25,-33", path = "top"},
		{map = "23,-34", path = "left", gather = true},
		{map = "22,-34", path = "left"},
		{map = "21,-34", path = "left"},
		{map = "20,-34", path = "left"},
		{map = "19,-34", path = "top"},
		{map = "19,-35", path = "left"},
		{map = "18,-35", path = "left", gather = true},
		{map = "17,-35", path = "top|left", gather = true},
		{map = "18,-36", path = "left", gather = true},
		{map = "17,-36", path = "bottom", gather = true},
		{map = "16,-36", path = "bottom", gather = true},
		{map = "16,-35", path = "left", gather = true},
		{map = "15,-35", path = "bottom", gather = true},
		{map = "15,-34", path = "left", gather = true},
		{map = "14,-34", path = "bottom", gather = true},
		{map = "14,-33", path = "bottom", gather = true},
		{map = "14,-32", path = "right", gather = true},
		{map = "15,-32", path = "top", gather = true},
		{map = "15,-33", path = "right", gather = true},
		{map = "16,-33", path = "bottom", gather = true},
		{map = "16,-31", path = "bottom", gather = true},
		{map = "16,-32", path = "bottom", gather = true},
		{map = "16,-30", path = "right", gather = true},
		{map = "17,-30", path = "right", gather = true},
		{map = "18,-30", path = "top", gather = true},
		{map = "18,-31", path = "left", gather = true},
		{map = "17,-31", path = "top", gather = true},
		{map = "17,-32", path = "right", gather = true},
		{map = "18,-32", path = "top", gather = true},
		{map = "18,-33", path = "left", gather = true},
		{map = "17,-33", path = "top", gather = true},
		{map = "17,-34", path = "left", gather = true},
		{map = "16,-34", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},
}

local seventhAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-48", path = "right"},
    {map = "-14,-47", path = "top"},
    {map = "-14,-48", path = "right"},
    {map = "-13,-48", path = "bottom", gather = true},
    {map = "-13,-47", path = "bottom", gather = true},
    {map = "-13,-46", path = "right", gather = true},
    {map = "-12,-46", path = "right", gather = true},
    {map = "-11,-46", path = "right"},
    {map = "-10,-46", path = "right", gather = true},
    {map = "-9,-46", path = "bottom", gather = true},
    {map = "-9,-45", path = "bottom"},
    {map = "-9,-44", path = "bottom", gather = true},
    {map = "-9,-43", path = "bottom"},
    {map = "-9,-42", path = "left"},
    {map = "-10,-42", path = "left", gather = true},
    {map = "-11,-42", path = "left"},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right"},
    {map = "-11,-43", path = "top"},
    {map = "-11,-44", custom = function() ZoneBis = false map:changeMap("havenbag") end, gather = true}
}

local eigthArea = { -- kaliptus et charme
		{map = "0,0", path = "zaap(73400320)"},
		{map = "-17,1", path = "left"},
		{map = "-16,1", path = "left"},
		{map = "-18,1", path = "left"},
		{map = "-19,1", path = "left"},
		{map = "-20,1", path = "left"},
		{map = "-21,1", path = "top"},
		{map = "-21,0", path = "top"},
		{map = "-21,-2", path = "right"},
		{map = "-21,-1", path = "top", gather = true},
		{map = "-20,-2", path = "top", gather = true},
		{map = "-20,-3", path = "top"},
		{map = "-20,-4", path = "top"},
		{map = "-20,-5", path = "top", gather = true},
		{map = "-20,-6", path = "top"},
		{map = "-20,-7", path = "top"},
		{map = "-20,-8", path = "right", gather = true},
		{map = "-19,-8", path = "top", gather = true},
		{map = "-19,-9", path = "right", gather = true},
		{map = "-18,-9", path = "right", gather = true},
		{map = "-17,-9", path = "right", gather = true},
		{map = "-16,-9", path = "right", gather = true},
		{map = "-15,-9", path = "bottom(543)", gather = true},
		{map = "-15,-7", path = "bottom", gather = true},
		{map = "-14,-7", path = "left", gather = true},
		{map = "-15,-8", path = "right"},
		{map = "-14,-8", path = "bottom"},
		{map = "-15,-6", path = "left", gather = true},
		{map = "-16,-6", path = "left", gather = true},
		{map = "-17,-6", path = "left"},
		{map = "-18,-6", path = "bottom", gather = true},
		{map = "-18,-5", path = "bottom", gather = true},
		{map = "-18,-4", path = "bottom", gather = true},
		{map = "-18,-3", path = "right", gather = true},
		{map = "-17,-3", path = "top", gather = true},
		{map = "-17,-4", path = "right", gather = true},
		{map = "-16,-4", path = "right", gather = true},
		{map = "-15,-4", path = "bottom"},
		{map = "-15,-3", path = "left"},
		{map = "-16,-3", path = "bottom"},
		{map = "-16,-2", path = "right", gather = true},
		{map = "-15,-2", path = "right", gather = true},
		{map = "-14,-2", path = "bottom"},
		{map = "-14,-1", path = "right", gather = true},
		{map = "-13,-1", path = "bottom", gather = true},
		{map = "-13,0", path = "bottom", gather = true},
		{map = "-13,2", path = "bottom", gather = true},
		{map = "-13,1", path = "bottom"},
		{map = "-13,3", path = "right"},
		{map = "-12,3", path = "top"},
		{map = "-12,2", path = "top", gather = true},
		{map = "-12,1", path = "top", gather = true},
		{map = "-12,0", path = "top", gather = true},
		{map = "-12,-1", path = "right", gather = true},
		{map = "-11,2", path = "bottom", gather = true},
		{map = "-11,3", path = "bottom", gather = true},
		{map = "-11,1", path = "bottom"},
		{map = "-11,-1", path = "bottom"},
		{map = "-11,0", path = "bottom", gather = true},
		{map = "-11,4", path = "bottom"},
		{map = "-11,5", path = "bottom", gather = true},
		{map = "-10,6", path = "bottom", gather = true},
		{map = "-11,7", path = "bottom", gather = true},
		{map = "-10,8", path = "bottom", gather = true},
		{map = "-11,9", path = "bottom", gather = true},
		{map = "-11,10", path = "bottom", gather = true},
		{map = "-11,11", path = "bottom", gather = true},
		{map = "-9,10", path = "bottom", gather = true},
		{map = "-9,11", path = "bottom", gather = true},
		{map = "-7,12", path = "bottom", gather = true},
		{map = "-9,13", path = "bottom", gather = true},
		{map = "-11,6", path = "right", gather = true},
		{map = "-11,8", path = "right", gather = true},
		{map = "-11,12", path = "right", gather = true},
		{map = "-9,12", path = "bottom", gather = true},
		{map = "-9,14", path = "right", gather = true},
		{map = "-8,12", path = "right", gather = true},
		{map = "-7,14", path = "right", gather = true},
		{map = "-7,13", path = "bottom", gather = true},
		{map = "-6,14", path = "top", gather = true},
		{map = "-8,14", path = "top", gather = true},
		{map = "-8,13", path = "top", gather = true},
		{map = "-10,12", path = "top", gather = true},
		{map = "-10,11", path = "top", gather = true},
		{map = "-10,9", path = "left", gather = true},
		{map = "-10,7", path = "bottom", gather = true},
		{map = "-10,10", path = "right", gather = true},
		{map = "-6,13", custom = function() ZoneBis = true map:changeMap("havenbag") end, gather = true},	
}

local eigthAreaBis = {
    {map = "0,0", path = "zaap(147590153)"},
    {map = "-17,-47", path = "right"},
    {map = "-16,-47", path = "right"},
    {map = "-15,-47", path = "right"},
    {map = "-14,-47", path = "bottom"},
    {map = "-14,-46", path = "right"},
    {map = "-13,-46", path = "top", gather = true},
    {map = "-13,-47", path = "top", gather = true},
    {map = "-12,-47", path = "bottom", gather = true},
    {map = "-12,-46", path = "right", gather = true},
    {map = "-11,-46", path = "right", gather = true},
    {map = "-10,-46", path = "right", gather = true},
    {map = "-9,-46", path = "bottom", gather = true},
    {map = "-9,-45", path = "bottom", gather = true},
    {map = "-9,-44", path = "bottom", gather = true},
    {map = "-9,-43", path = "bottom", gather = true},
    {map = "-9,-42", path = "left", gather = true},
    {map = "-10,-42", path = "left", gather = true},
    {map = "-11,-42", path = "left", gather = true},
    {map = "-12,-42", path = "top", gather = true},
    {map = "-12,-43", path = "right", gather = true},
    {map = "-11,-43", path = "top", gather = true},
    {map = "-13,-48", path = "right", gather = true},
    {map = "-12,-48", path = "bottom", gather = true},
    {map = "-11,-44", custom = function() ZoneBis = false map:changeMap("havenbag") end, gather = true},
}

local Planches = {
	{Name = "Planche de Salut", Id = 16499, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {7016, 7014, 472, 7925, 470, 11107, 449, 16488}, lvlMax = 201, CanSell = true},
	{Name = "Planche a Dessin", Id = 16498, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {7016, 474, 472, 7925, 470, 7013, 449, 16488}, lvlMax = 201, CanSell = true},
	{Name = "Planche a Pain", Id = 16497, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 474, 472, 7925, 7013, 449, 16488}, lvlMax = 180, CanSell = true},
	{Name = "Planche de Gravure", Id = 16496, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 474, 2357, 7013, 449, 16488, 27375}, lvlMax = 160, CanSell = true},
	{Name = "Planche a Patisserie", Id = 16495, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 474, 2357, 7013, 2358, 471, 27375}, lvlMax = 140, CanSell = true},
	{Name = "Planche de Toilettes", Id = 16494, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 2357, 460, 2358, 471, 27375}, lvlMax = 120, CanSell = true},
	{Name = "Planche a Repasser", Id = 16493, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 460, 2358, 471}, lvlMax = 100, CanSell = true},
	{Name = "Planche de Surf", Id = 16492, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 303, 460, 473}, lvlMax = 80, CanSell = true},
	{Name = "Planche a Griller", Id = 16491, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 303, 473}, lvlMax = 60, CanSell = true},
	{Name = "Planche Contreplaquee", Id = 16489, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {303, 473}, lvlMax = 40, CanSell = true},
}
          
local Bois = {
    {Name = "Tremble", Id = 11107, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou Sacre", Id = 7014, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Orme", Id = 470, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou Sombre", Id = 7016, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Charme", Id = 472, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Kaliptus", Id = 7925, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Ebene", Id = 449, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Noisetier", Id = 16488, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Mersier", Id = 474, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bambou", Id = 7013, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "If", Id = 461, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Oliviolet", Id = 2357, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
	{Name = "Pin", Id = 27375, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Erable", Id = 471, MaxHdv100= 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 140},
    {Name = "Bombu", Id = 2358, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Chene", Id = 460, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Noyer", Id = 476, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 100},
    {Name = "Chataignier", Id = 473, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Frene", Id = 303, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 80 },
}

local Seves = {
    {Name = "Seve de Frene", Id = 16909,},
    {Name = "Seve de Chataignier", Id = 16910},
    {Name = "Seve de Noyer", Id = 16911},
    {Name = "Seve de Chene", Id = 16912},
    {Name = "Seve de Bombu", Id = 16913},
    {Name = "Seve d'Erable", Id = 16914},
    {Name = "Seve d'Oliviolet", Id = 16915},
    {Name = "Seve d'If", Id = 16916},
    {Name = "Seve de Bambou", Id = 16917},
    {Name = "Seve de Merisier", Id = 16918},
    {Name = "Seve de Noisetier", Id = 16919},
    {Name = "Seve de Kaliptus", Id = 16921},
    {Name = "Seve de Charme", Id = 16922},
    {Name = "Seve de Bambou Sombre", Id = 16923},
    {Name = "Seve de Bambou Sacre", Id = 16925},
    {Name = "Seve d'Orme", Id = 16924},
    {Name = "Seve de Tremble", Id = 16926},
}

local tableVenteRestePL = {
	{Name = "Plume de Piou Rouge", Id = 6900, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Plume de Piou Jaune", Id = 6902, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Plume de Piou Vert", Id = 6899, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Plume de Piou Bleu", Id = 6897, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Plume de Piou Violet", Id = 6898, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Plume de Piou Rose", Id = 6903, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},

	{Name = "Œil d'Arakmuté", Id = 2491, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Poils d'Arakne Malade", Id = 388, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Intestin d'Araknosé", Id = 373, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Bec du Tofu", Id = 366, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},

	{Name = "Conque Marine", Id = 13726, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Crème à bronzer", Id = 13727, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},


	{Name = "Peau de Larve Bleue", Id = 362, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Peau de Larve Orange", Id = 363, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Peau de Larve Verte", Id = 364, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Peau de Larve Jaune", Id = 2563, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},

	{Name = "Crocs de Rats", Id = 2322, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Cuir de Scélérat Strubien", Id = 304, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},

	{Name = "Noisette", Id = 394, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Étoffe d'Écurouille", Id = 653, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Poils du Milimulou", Id = 1690, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Scalp de Milimulou", Id = 2576, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Pic du Prespic", Id = 407, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Queue de Prespic", Id = 2573, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Poils Darits", Id = 1672, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Groin de Sanglier", Id = 386, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Défense du Sanglier", Id = 387, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},
	{Name = "Étoffe du Sanglier", Id = 652, CanSell = true, MaxHdv100 = 1, MaxHdv10 = 1},

	{Name = "Viande Intangible", Id = 16663, CanSell = true, MaxHdv100 = 2, MaxHdv10 = 1},
	{Name = "Viande Hachée", Id = 17123, CanSell = true, MaxHdv100 = 2, MaxHdv10 = 1},
	{Name = "Viande faisandée", Id = 17124, CanSell = true, MaxHdv100 = 2, MaxHdv10 = 1},
	{Name = "Viande Frelatée", Id = 17126, CanSell = true, MaxHdv100 = 2, MaxHdv10 = 1},

}

local TableWichArea = {
	{MaxBucheron = 70, FirstArea = firstArea, SecondArea = firstArea, Gath = {1, 33, 34, 8}},
	{MaxBucheron = 80, FirstArea = secondArea, SecondArea = secondArea, Gath = {98, 8, 34}},
	{MaxBucheron = 90, FirstArea = forthArea, SecondArea = forthArea, Gath = {31, 8, 34}},
	{MaxBucheron = 100, FirstArea = thirdArea, SecondArea = thirdAreaBis, Gath = {101, 31, 8, 401}},
	{MaxBucheron = 110, FirstArea = forthAreaV2, SecondArea = forthAreaV2, Gath = {31, 8, 28, 35, 259, 29, 98}},
	{MaxBucheron = 120, FirstArea = sixthArea, SecondArea = sixthAreaBis, Gath = {108, 31, 8, 28}},
	{MaxBucheron = 140, FirstArea = forthAreaV3, SecondArea = forthAreaV3, Gath = {31, 28, 35, 259, 29, 98}},
	{MaxBucheron = 150, FirstArea = fifthArea, SecondArea = fifthAreaBis, Gath = {259, 29, 32, 35, 28}},
	{MaxBucheron = 160, FirstArea = eigthArea, SecondArea = eigthAreaBis, Gath = {121, 32, 35, 29, 28}},
	{MaxBucheron = 170, FirstArea = fifthAreaV2, SecondArea = fifthAreaV2Bis, Gath = {259, 29, 32, 35, 28}},
    {MaxBucheron = 180, FirstArea = seventhArea, SecondArea = seventhAreaBis, Gath = {108, 109}},
    {MaxBucheron = 201, FirstArea = fifthAreaV2, SecondArea = fifthAreaV2Bis, Gath = {259, 29, 32, 35, 28}},
}

--- <variables>

local toGive = 0

local bankMaps = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

--- </variables>


--- </functions>



local function GetLength(Table)
    local cpt = 0
    for _, element in ipairs(Table) do
        cpt = cpt + 1
    end
    return cpt
end


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

function messagesRegistering()
    developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
    developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
end


local function ProcessBank() -- done
    NeedToReturnBank = false
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:putAllItems()
		global:delay(500)
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		exchange:putAllItems()
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end	
    
    for _, element in ipairs(Bois) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end

	local podsAvailable = inventory:podsMax() - inventory:pods()
	
	if exchange:storageItemQuantity(2357) < 100 and job:level(2) > 100 and character:kamas() >= 100000 and not StopOliviolet then
		global:printSuccess("je vais acheter de l'oliviolet")
		actualiser = false
		NeedToSell = true
		achatOliviolet = true
	end
	if exchange:storageItemQuantity(7013)  < 100 and job:level(2) > 120 and character:kamas() >= 100000 and not StopBambou then
		global:printSuccess("je vais acheter du bambou")
		actualiser = false
		NeedToSell = true
		achatBambou = true
	end

    for _, element in ipairs(Planches) do
        element.CanCraft = true
        for _, Id in ipairs(element.ListIdCraft) do
            if not (exchange:storageItemQuantity(Id) >= 50) or NeedToCraft then
                element.CanCraft = false
				break
            end
        end
        if element.CanCraft and not NeedToCraft and job:level(2) < element.lvlMax then
            NeedToSell = false
            NeedToCraft = true
            CraftQuantity = math.floor(podsAvailable/ (GetLength(element.ListIdCraft) * 50))
            for _, Id in ipairs(element.ListIdCraft) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(Id) / 10))
            end

            global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")

            for _, Id in ipairs(element.ListIdCraft) do
                exchange:getItem(Id, CraftQuantity * 10)
            end
        end
    end
	
    if not NeedToCraft and not NeedToSell then
        for _, element in ipairs(Bois) do
            if element.LvlMinToSell ~= nil and job:level(2) >= element.LvlMinToSell and exchange:storageItemQuantity(element.Id) >= 330 and element.CanSell then
			    local QuantiteAPrendre = math.min(math.floor(podsAvailable / 5), exchange:storageItemQuantity(element.Id), 330)
                exchange:getItem(element.Id, QuantiteAPrendre)
				podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end
        for _, element in ipairs(Planches) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id), 33)
            if QuantiteAPrendre >= 20 and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
				podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end
		for _, element in ipairs(Seves) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id))
			if QuantiteAPrendre > 0 then
				exchange:getItem(element.Id, QuantiteAPrendre)
			end
        end
		local cpt = 0
        for _, element in ipairs(tableVenteRestePL) do
            local podsAvailable = inventory:podsMax() - inventory:pods()
            local TotalMax = element.MaxHdv100 * 100 + element.MaxHdv10 * 10
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.Id)))
            if ((element.MaxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.MaxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
		if not NeedToSell then
        	NeedToSell = (cpt > 5) or (inventory:podsP() > 30)
		end
		
    end

    global:leaveDialog()
    global:delay(1000)
    map:door(518)
end
	
local function ProcessCraft() -- done
    NeedToCraft = false
	NeedToSell = true
	map:useById(500388, -1)
	global:delay(2000)
	
    for _, element in ipairs(Planches) do
        if element.CanCraft then
			global:printSuccess(element.Name)
            for _, Id in ipairs(element.ListIdCraft) do
                craft:putItem(Id, 10)
            end
			global:printSuccess(CraftQuantity)
            craft:changeQuantityToCraft(CraftQuantity)
            element.CanCraft = false
            global:delay(1000)
            craft:ready()
            global:delay(1000)
        end
    end

    global:leaveDialog() 
	global:delay(1000)
	map:moveToCell(341)
end
	
local function ProcessSell() -- done
    NeedToSell = false
	launch_hdv_activites(hdv_door_id)

	for _, element in ipairs(Planches) do
	    cpt = get_quantity(element.Id).quantity["10"]
	    local Priceitem = sale:getPriceItem(element.Id, 2) 
		while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
			Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
			sale:SellItem(element.Id, 10, Priceitem - 1) 
			global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
			cpt = cpt + 1
        end
       	cpt = get_quantity(element.Id).quantity["1"]
	   	local Priceitem = sale:getPriceItem(element.Id, 1)
		while inventory:itemCount(element.Id) >= 1 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv1 do 
			Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
			sale:SellItem(element.Id, 1, Priceitem - 1) 
			global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
			cpt = cpt + 1
		end
    end

    for _, element in ipairs(Bois) do
        cpt = get_quantity(element.Id).quantity["100"]
		local Priceitem = sale:getPriceItem(element.Id, 3)
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv100 do 
			Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 100, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
        cpt = get_quantity(element.Id).quantity["10"]
		local Priceitem = sale:getPriceItem(element.Id, 2)
        while inventory:itemCount(element.Id) >= 1 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
			Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 10, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
     end

     for _, element in ipairs(Seves) do
		local Priceitem = sale:getPriceItem(element.Id, 1)
        while inventory:itemCount(element.Id) >= 1 and sale:AvailableSpace() > 0 do 
			Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 1, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
     end

	global:leaveDialog()
		
	table.sort(tableVenteRestePL, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

	launch_hdv_activites(hdv_door_id)
	-- vente par 100, 10 des récoles alchimiste
	for _, element in ipairs(tableVenteRestePL) do
		if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

		cpt = get_quantity(element.Id).quantity["100"]

		local Priceitem1 = sale:getPriceItem(element.Id, 3)
		Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and sale:getAveragePriceItem(element.Id, 3) * 1.5 or Priceitem1
    	while (inventory:itemCount(element.Id) >= 100) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv100) do 
            sale:SellItem(element.Id, 100, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
        end

		cpt = get_quantity(element.Id).quantity["10"]

		local Priceitem2 = sale:getPriceItem(element.Id, 2)
		Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem2
        while (inventory:itemCount(element.Id) >= 10) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv10) do 
            sale:SellItem(element.Id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
		end
    end

	global:leaveDialog()

    launch_hdv_activites(hdv_door_id)

    -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
    for _, element in ipairs(Planches) do
        if get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 and get_quantity(element.Id).quantity["1"] >= element.MaxHdv1  then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
    for _, element in ipairs(Bois) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
	for _, element in ipairs(tableVenteRestePL) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end

	if cptActualiser == 3 then
		cptActualiser = 0
		global:printSuccess("on actualise")
		sale:updateAllItems()
	else
		cptActualiser = cptActualiser + 1
	end
		
	if sale:AvailableSpace() == 0 then
	    global:printError(" il n'y a plus de place dans l'hdv")
	elseif sale:AvailableSpace() > 0 then
	    NeedToReturnBank = true
	end

    global:leaveDialog()

	if achatOliviolet then
		npc:npc(333, 6) 
		global:delay(500)
		sale:buyItem(2357,100,30000)
		global:delay(500)
		achatOliviolet = false
		if inventory:itemCount(2357) < 100 then
			StopOliviolet = true
		end
		global:leaveDialog()
	end
	if achatBambou then
		npc:npc(333, 6) 
		global:delay(500)
		sale:buyItem(7013,100,30000)
		global:delay(500)
		achatBambou = false
		if inventory:itemCount(7013) < 100 then
			StopBambou = true
		end
		global:leaveDialog()
	end
	map:changeMap("top")
end

local function treatMaps(maps, errorFn)
    local msg = "[Erreur] - Aucune action à réaliser sur la map"

    for _, element in ipairs(maps) do
        local condition = element.map == map:currentMap() 
            or tostring(element.map) == tostring(map:currentMapId())
            
        if condition then
            return maps
        end
    end

    return errorFn
        and errorFn()
        or global:printError(msg)
end

local function whichArea()
    for _, element in ipairs(TableWichArea) do
        if job:level(2) < element.MaxBucheron and not ZoneBis then
            GATHER = element.Gath
            return treatMaps(element.FirstArea, function() map:changeMap("havenbag") end)
        elseif job:level(2) < element.MaxBucheron and ZoneBis then
            GATHER = element.Gath
            return treatMaps(element.SecondArea, function() map:changeMap("havenbag") end)
        end
    end
end

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

local function takeKamas()
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end
	global:leaveDialog()
	if character:kamas() > 1200000 then
		global:loadAndStart(scriptPath)
	else
		global:printSuccess("Reco dans 2h")
		global:reconnectBis(math.random(80, 120))
	end
end

if not global:remember("increm") then
	global:addInMemory("increm", 0)
end

function move()
    if getRemainingSubscription(true) <= (NbJoursRestantsTrigger - 1) and (character:kamas() > NbKamasMiniToTryAbonnement) then
        Abonnement()
    elseif getRemainingSubscription(true) < (NbJoursRestantsTrigger - 1) then
        Abonnement()
    end

	if getRemainingSubscription(true) < 0 then
		return {
			{map = "6,-19", path = "left"},
			{map = "5,-19", path = "bottom"},
			{map = "5,-18", path = "left"},
			{map = "191104002", door = "288"},
			{map = "192415750", custom = takeKamas},
		}
	end

    if EDIT_ALIAS then
        EditAlias()
    end

	if job:level(2) >= 180 then	
		global:restartScript(true)
	end

    if map:currentMapId() == 206308353 then 
        map:changeMap("bottom")
	elseif map:onMap(153621) then
		map:changeMap("left")
	end
	
    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map ="0,0", path = "zaap(147590153)"},
			{map = "-17,-47", path = "right"},
			{map = "-16,-47", path = "right"},
			{map = "-15,-47", path = "right"},
			{map = "-14,-47", path = "right"},
			{map = "-13,-47", path = "top"},
			{map = "-13,-48", path = "top"},
			{map = "-13,-49", path = "top"},
			{map = "-13,-50", path = "top"},
            {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
            {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
        }
    end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end


    if BANK_ACTIVATED then
        if global:remember("failed") then
            if not global:remember("retryTimestamp") then global:addInMemory("retryTimestamp", os.time()) end
    
            if secondsToHours(os.time() - global:remember("retryTimestamp")) >= minRetryHours then
                rerollVar()
                global:editInMemory("retryTimestamp", 0)
            end
        end
    
        if character:kamas() >= givingTriggerValue and not global:remember("failed") then
            givingMode = true
        end
    
        if givingMode then
            if not connected then
                receiver = connectReceiver()
    
                if cannotConnect then
                    rerollVar()
                    receiver:disconnect()
                    global:editInMemory("retryTimestamp", os.time())
                    global:addInMemory("failed", true)
                    global:restartScript(true)
                else
                    connected = true
                end
            end
    
            if not global:remember("failed") then
                return goAstrubBank(launchExchangeAndGive)
            end
        end
    end

    if character:energyPoints() < 5000 then
        return treatMaps(AreaEnergie)
    end

    return whichArea()
end

function bank()
    ZoneBis = false
    if EDIT_ALIAS then
        EditAlias()
    end

    if NeedToCraft then
        return {
            {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
			{map ="0,0", path = "zaap(147590153)"},
			{map = "-17,-47", path = "right"},
			{map = "-16,-47", path = "right"},
			{map = "-15,-47", path = "right"},
			{map = "-14,-47", path = "right"},
			{map = "-13,-47", path = "top"},
			{map = "-13,-48", path = "top"},
			{map = "-13,-49", path = "top"},
			{map = "-13,-50", path = "top"},
            {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
            {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
        }
    end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end

    if NeedToSell then
        return {
			{map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
			{map ="0,0", path = "zaap(212600323)"},				
            {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212600322", path = "bottom"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end

    for _, element in ipairs(MapSansHavreSac) do
       if not element.Door and map:onMap(tostring(element.Id)) then
		if map:currentCell() == tonumber(element.Path) then
			map:moveToCell(math.random(50, 500))
		end
           return {{map = tostring(element.Id), path = element.Path}}
       elseif map:onMap(tostring(element.Id)) then
           return {{map = tostring(element.Id), door = element.Door}}
       end
    end		
		
	if map:currentMapId()~=217059328 and map:currentMap()~= "-31,-57" and map:currentMap()~= "-31,-56" and map:currentMap()~=104861191 and map:currentMap()~=104862215 and map:currentMap()~=104859143  and map:currentMap()~=104859145 and map:currentMap()~=104860169 and map:currentMap()~=104861193   and map:currentMap()~=104862217 and map:currentMap()~=2885641 and map:currentMap()~=145209 and map:currentMap()~=2884113 and map:currentMapId()~=2885641 and map:currentMapId()~=147768 and map:currentMapId()~=162791424 and map:currentMapId()~=191104004 and map:currentMapId()~=7340551 and map:currentMapId()~="-32,-56" and map:currentMap()~="-4,2" and map:currentMapId()~=191104004  then 
		return{
			{map=tostring(map:currentMap()),path="havenbag"}}
		end
	
    return { 
		{map ="104861191", path = "457"},
		{map ="104862217", path = "369"},
		{map ="104861193", path = "454"},
		{map ="104859145", path = "192"},
		{map ="104860169", path = "379"},
		{map ="104858121", path = "507"},
		{map ="104072452", custom = easy },
		{map ="104072451", path ="havenbag"},
		{map="0,0",path="zaap(212600323)"},
		{map="-31,-56",path="top"},
		{map="212600322", door = "468"},
		{map = "217059328", custom = ProcessBank},
    }
end

function stopped()
    map:changeMap("havenbag")
end

function phenix()
	return
	{
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) map:changeMap("havenbag") end},
		{map = "22,22", custom = function() map:door(387) map:changeMap("havenbag") end},
		{map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() map:door(184) map:changeMap("havenbag") end},
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) map:changeMap("havenbag") end},

        {map = "35,-42", path = "bottom"},
        {map = "35,-41", path = "bottom"},
        {map = "35,-40", custom = function() map:door(306) map:changeMap("havenbag") end},
		{map = "-9,-54", path = "left"},
		{map = "-10,-54", custom = function() map:door(342) map:changeMap("top") end},
		{map = "23330816", path = "bottom"},
		{map = "159769", path = "left"},
		{map = "-57,25", path = "left"},
		{map = "-58,24", path = "top"},
		{map = "-58,25", path = "top"},
		{map = "-58,23", path = "top"},
		{map = "-58,22", path = "top"},
		{map = "-58,21", path = "top"},
		{map = "-58,20", path = "top"},
		{map = "-58,19", path = "top"},
		{map = "-58,18", custom = function() map:door(354) map:changeMap("havenbag") end},
		{map = "-3,-13", path = "right"},
        {map = "-2,-13", path = "right"},
        {map = "-1,-13", path = "right"},
        {map = "0,-13", path = "right"},
        {map = "1,-13", path = "right"},
        {map = "2,-13", path = "top"},
		{map = "2,-14", custom = function() map:door(313) map:changeMap("havenbag") end},

		{map = "146800640", custom = function() map:door(200) map:door(333) end}
	}
end
else    
    
    OPEN_BAGS = true 
    local DebutDuScript = true
    local NeedToCraft = false
    local NeedToReturnBank = false
    local NeedToSell = false
    local cpt = 0
    local cptActualiser = 0
    local hdvActualise = false
    
    local maxEnergy = 6200
    local gid = 1782 
    local hdvFull = false
    local hdv_door_id = 218
    STOP = false
    
    
    local substrat_de_sylve = 16460
    local CanSellSubstratDeSylve = true    
    
    
    local MapSansHavreSac = {
        {Id = 168035328, Door = "458"},
        {Id = 168034312, Door = "215"},
        {Id = 168034310, Door = "215"},
        {Id = 104859139, Path = "444"},
        {Id = 168167424, Door = "289"},
        {Id = 104861191, Path = "457"},
        {Id = 57017859, Path = "395"},
        {Id = 168036352, Door = "458"},
        {Id = 104860167, Path = "478"},
        {Id = 104862215, Path = "472"},
        {Id = 104859143, Path = "543"},
    }	
    
    
    local function achatSacStaca()
        message = developer:createMessage("NpcGenericActionRequestMessage")
        message.npcId = -1
        message.npcActionId = 6
        message.npcMapId = map:currentMapId()
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
    
        sale:buyItem(1704, 1, 500000)
        global:leaveDialog()
        inventory:equipItem(1704, 7)
        global:restartScript(true)
        map:changeMap("right")
    end
    
    local AreaAchatSacStaca = {
        {map = "0,0", path = "zaap(212600323)"},
        {map="212600323", path="bottom"},
        {map="-31,-55", custom = achatSacStaca},
    }
     
    local Frigost = {
        {map = "0,0", path = "zaap(54172969)"},
        {map = "-78,-41", path = "top"}, -- zone frigost
        {map = "-78,-42", path = "top"},
        {map = "-78,-43", path = "top"},
        {map = "-78,-44", path = "top"},
        {map = "-78,-45", path = "top"},
        {map = "-78,-46", path = "right"},
        {map = "-77,-46", path = "right"},
        {map = "-76,-46", path = "right"},
        {map = "-75,-46", path = "right"},
        {map = "-74,-46", path = "right"},
        {map = "-73,-46", path = "top", gather = true},
        {map = "-74,-52", path = "top", gather = true},
        {map = "-75,-49", path = "top", gather = true},
        {map = "-73,-49", path = "left", gather = true},
        {map = "-74,-54", path = "right", gather = true},
        {map = "-72,-54", path = "right", gather = true},
        {map = "-68,-60", path = "right", gather = true},
        {map = "-73,-53", path = "right", gather = true},
        {map = "-73,-48", path = "top"},
        {map = "-73,-47", path = "top"},
        {map = "-74,-50", path = "top"},
        {map = "-74,-51", path = "top"},
        {map = "-68,-54", path = "top"},
        {map = "-68,-55", path = "top"},
        {map = "-68,-56", path = "top"},
        {map = "-68,-57", path = "top"},
        {map = "-68,-58", path = "top"},
        {map = "-68,-59", path = "top", gather = true},
        {map = "-64,-61", path = "top"},
        {map = "-61,-63", path = "top"},
        {map = "-75,-50", path = "right"},
        {map = "-71,-54", path = "right"},
        {map = "-70,-54", path = "right"},
        {map = "-69,-54", path = "right"},
        {map = "-67,-60", path = "right", gather = true},
        {map = "-66,-60", path = "right"},
        {map = "-63,-63", path = "right"},
        {map = "-62,-63", path = "right"},
        {map = "-60,-64", path = "right"},
        {map = "-59,-64", path = "right"},
        {map = "-57,-68", path = "right"},
        {map = "-74,-49", path = "left", gather = true},
        {map = "-74,-53", path = "top"},
        {map = "-73,-54", path = "bottom"},
        {map = "-72,-53", path = "top"},
        {map = "-65,-60", path = "right", gather = true},
        {map = "-64,-60", path = "top", gather = true},
        {map = "-65,-63", path = "right", gather = true},
        {map = "-64,-63", path = "right", gather = true},
        {map = "-61,-64", path = "right", gather = true},
        {map = "-65,-62", path = "top"},
        {map = "-64,-62", path = "left"},
        {map = "-58,-65", path = "top"},
        {map = "-58,-66", path = "top"},
        {map = "-58,-67", path = "top"},
        {map = "-58,-64", path = "top", gather = true},
        {map = "-58,-68", path = "right", gather = true},
        {map = "-56,-68", path = "bottom", gather = true},
        {map = "-56,-67", path = "bottom"},
        {map = "-56,-66", path = "bottom"},
        {map ="-58,-55", path = "left"},
        {map = "-56,-65", path = "bottom"},
        {map = "-56,-64", path = "bottom"},
        {map = "-56,-63", path = "bottom"},
        {map = "-56,-62", path = "bottom"},
        {map = "-59,-61", path = "bottom", gather = true},
        {map = "-57,-59", path = "bottom", gather = true},
        {map = "-60,-53", path = "bottom", gather = true},
        {map = "-56,-61", path = "left"},
        {map = "-57,-61", path = "left"},
        {map = "-58,-61", path = "left"},
        {map = "-59,-60", path = "bottom"},
        {map = "-59,-59", path = "right"},
        {map = "-58,-59", path = "right"},
        {map = "-57,-58", path = "right"},
        {map = "-56,-58", path = "right"},
        {map = "-55,-58", path = "bottom"},
        {map = "-55,-57", path = "left", gather = true},
        {map = "-56,-57", path = "left"},
        {map = "-57,-57", path = "bottom"},
        {map = "-57,-56", path = "left", gather = true},
        {map = "-58,-54", path = "bottom", gather = true},
        {map = "-58,-56", path = "bottom"},
        {map = "-59,-55", path = "bottom"},
        {map = "-59,-54", path = "right"},
        {map = "-58,-53", path = "left"},
        {map = "-59,-53", path = "left"},
        {map = "-60,-52", path = "left"},
        {map = "-61,-52", path = "left"},
        {map = "-62,-52", path = "left"},
        {map = "-63,-52", path = "left"},
        {map = "-64,-52", path = "left"},
        {map = "-65,-52", path = "bottom"},
        {map = "-65,-51", path = "right"},
        {map = "-64,-51", path = "bottom"},
        {map = "-64,-50", path = "bottom"},
        {map = "-64,-49", path = "left", gather = true},
        {map = "-65,-49", path = "bottom"},
        {map = "-65,-48", path = "bottom"},
        {map = "-65,-47", path = "left", gather = true},
        {map = "-66,-47", path = "top", gather = true},
        {map = "-66,-48", path = "left", gather = true},
    }
    
    local Otomai = {
        {map = "0,0", path = "zaap(154642)"},
        {map = "-46,18", path = "left"},
        {map = "-47,19", path = "left"},
        {map = "-48,19", path = "left"},
        {map = "-49,19", path = "left"},
        {map = "-50,21", path = "left"},
        {map = "-47,18", path = "bottom"},
        {map = "-50,19", path = "bottom"},
        {map = "-50,20", path = "bottom"},
        {map = "-51,20", path = "top", gather = true},
        {map = "-51,18", path = "top", gather = true},
        {map = "-51,16", path = "top", gather = true},
        {map = "-51,13", path = "top", gather = true},
        {map = "-51,12", path = "left", gather = true},
        {map = "-52,12", path = "left", gather = true},
        {map = "-53,12", path = "top", gather = true},
        {map = "-53,10", path = "top", gather = true},
        {map = "-53,9", path = "left(252)", gather = true},
        {map = "-53,11", path = "left", gather = true},
        {map = "-54,11", path = "top"},
        {map = "-54,10", path = "right", gather = true},
        {map = "-54,9", path = "left", gather = true},
        {map = "-55,9", path = "bottom", gather = true},
        {map = "-55,10", path = "bottom", gather = true},
        {map = "-55,11", path = "bottom", gather = true},
        {map = "-51,19", path = "left", gather = true},
        {map = "-52,19", path = "top", gather = true},
        {map = "-52,18", path = "right"},
        {map = "-51,17", path = "left", gather = true},
        {map = "-52,17", path = "top", gather = true},
        {map = "-52,16", path = "right", gather = true},
        {map = "-51,15", path = "top"},
        {map = "-51,14", path = "left"},
        {map = "-52,14", path = "left"},
        {map = "-53,14", path = "top"},
        {map = "-53,13", path = "right", gather = true},
        {map = "-52,13", path = "right", gather = true},
        {map = "-55,12", path = "bottom", gather = true},
        {map = "-54,14", path = "bottom", gather = true},
        {map = "-54,15", path = "bottom", gather = true},
        {map = "-54,16", path = "bottom", gather = true},
        {map = "-56,15", path = "bottom", gather = true},
        {map = "-56,16", path = "bottom", gather = true},
        {map = "-56,17", path = "bottom", gather = true},
        {map = "-56,18", path = "bottom", gather = true},
        {map = "-56,19", path = "bottom", gather = true},
        {map = "-56,20", path = "right", gather = true},
        {map = "-55,21", path = "right", gather = true},
        {map = "-54,20", path = "right", gather = true},
        {map = "-54,13", path = "bottom"},
        {map = "-55,13", path = "right"},
        {map = "-54,17", path = "left", gather = true},
        {map = "-55,17", path = "top", gather = true},
        {map = "-55,16", path = "top"},
        {map = "-55,15", path = "left"},
        {map = "-55,20", path = "bottom", gather = true},
        {map = "-54,21", path = "top", gather = true},
        {map = "-53,20", path = "bottom", gather = true},
        {map = "-51,21", path = "top"},
    }
    
    local ForetCania = {
        {map = "0,0", path = "zaap(147590153)"}, 
        {map = "-17,-47", path = "right"},
            {map = "-16,-47", path = "right"},
            {map = "-15,-47", path = "top"},
            {map = "-15,-48", path = "top"},
            {map = "-15,-49", path = "top"},
            {map = "-15,-51", path = "top"},
            {map = "-15,-52", path = "top"},
            {map = "-14,-54", path = "right"},
            {map = "-13,-54", path = "bottom"},
            {map = "-13,-53", path = "left"},
            {map = "-14,-53", path = "bottom"},
            {map = "-14,-51", path = "bottom", gather = true},
            {map = "-14,-50", path = "right", gather = true},
            {map = "-13,-50", path = "right"},
            {map = "-12,-49", path = "bottom", gather = true},
            {map = "-12,-48", path = "left", gather = true},
            {map = "-15,-50", path = "top", gather = true},
            {map = "-15,-54", path = "right", gather = true},
            {map = "-14,-52", path = "bottom", gather = true},
            {map = "-12,-50", path = "bottom", gather = true},
            {map = "-13,-48", path = "bottom", gather = true},
            {map = "-13,-47", path = "bottom", gather = true},
            {map = "-13,-46", path = "bottom", gather = true},
            {map = "-13,-45", path = "bottom", gather = true},
            {map = "-13,-44", path = "bottom", gather = true},
            {map = "-13,-43", path = "bottom", gather = true},
            {map = "-11,-46", path = "bottom", gather = true},
            {map = "-11,-44", path = "bottom", gather = true},
            {map = "-13,-42", path = "right", gather = true},
            {map = "-12,-46", path = "right", gather = true},
            {map = "-11,-42", path = "right", gather = true},
            {map = "-10,-42", path = "right(111)", gather = true},
            {map = "-12,-42", path = "top", gather = true},
            {map = "-12,-43", path = "top", gather = true},
            {map = "-12,-45", path = "top", gather = true},
            {map = "-9,-42", path = "top", gather = true},
            {map = "-9,-44", path = "top", gather = true},
            {map = "-9,-45", path = "top", gather = true},
            {map = "-12,-44", path = "top"},
            {map = "-11,-45", path = "bottom"},
            {map = "-11,-43", path = "bottom"},
            {map = "-9,-43", path = "top"},
            {map = "-9,-46", path = "left", gather = true},
            {map = "-10,-46", path = "bottom", gather = true},
            {map = "-22,-72", path = "bottom", gather = true},
            {map = "-15,-53", path = "left"},
            {map = "-16,-53", path = "left"},
            {map = "-17,-53", path = "left"},
            {map = "-18,-53", path = "top"},
            {map = "-18,-54", path = "top"},
            {map = "-18,-55", path = "top", gather = true},
            {map = "-18,-56", path = "right"},
            {map = "-17,-56", path = "right"},
            {map = "-16,-56", path = "top"},
            {map = "-16,-57", path = "top", gather = true},
            {map = "-16,-58", path = "top"},
            {map = "-16,-59", path = "top"},
            {map = "-16,-60", path = "right", gather = true},
            {map = "-15,-60", path = "right"},
            {map = "-14,-60", path = "right"},
            {map = "-11,-58", path = "left"},
            {map = "-12,-58", path = "left"},
            {map = "-13,-58", path = "left"},
            {map = "-14,-58", path = "left"},
            {map = "-15,-58", path = "bottom"},
            {map = "-15,-57", path = "bottom"},
            {map = "-15,-56", path = "bottom"},
            {map = "-15,-55", path = "bottom"},
            {map = "-8,-58", path = "left", gather = true},
            {map = "-8,-59", path = "bottom"},
            {map = "-9,-58", path = "left"},
            {map = "-12,-59", path = "right"},
            {map = "-11,-59", path = "right", gather = true},
            {map = "-10,-59", path = "right"},
            {map = "-9,-59", path = "right"},
            {map = "-10,-58", path = "left"},
            {map = "-13,-59", path = "right"},
            {map = "-13,-60", path = "bottom"},
    }
    
    local Koalak = {
        {map = "0,0", path = "zaap(73400320)"},
        {map = "-16,1", path = "bottom"}, -- zone koalak
        {map = "-16,2", path = "bottom"},
        {map = "-16,3", path = "bottom", gather = true},
        {map = "-16,4", path = "bottom"},
        {map = "-16,5", path = "bottom"},
        {map = "-16,6", path = "left"},
        {map = "-17,6", path = "left", gather = true},
        {map = "-18,6", path = "left", gather = true},
        {map = "-19,6", path = "top"},
        {map = "-19,5", path = "left"},
        {map = "-20,5", path = "bottom"},
        {map = "-20,6", path = "bottom"},
        {map = "-20,7", path = "left"},
        {map = "-21,7", path = "left"},
        {map = "-22,7", path = "top", gather = true},
        {map = "-22,6", path = "right", gather = true},
        {map = "-21,6", path = "top", gather = true},
        {map = "-21,5", path = "left"},
        {map = "-22,5", path = "top", gather = true},
        {map = "-22,4", path = "top"},
        {map = "-22,3", path = "top"},
        {map = "-22,2", path = "top"},
        {map = "-22,1", path = "top"},
        {map = "-22,0", path = "top"},
        {map = "-22,-1", path = "top"},
        {map = "-22,-2", path = "right", gather = true},
        {map = "-21,-2", path = "top"},
        {map = "-21,-3", path = "right", gather = true},
        {map = "-20,-3", path = "top"},
        {map = "-20,-4", path = "left"},
    }
    
    local Koalak2 = {
        {map = "-21,-4", path = "right", gather = true},
        {map = "-20,-4", path = "top"},
        {map = "-20,-5", path = "top", gather = true},
        {map = "-20,-6", path = "right"},
        {map = "-19,-6", path = "right", gather = true},
        {map = "-17,-6", path = "top"},
        {map = "-16,-7", path = "top"},
        {map = "-17,-7", path = "right", gather = true},
        {map = "-15,-7", path = "right", gather = true},
        {map = "-14,-7", path = "top", gather = true},
        {map = "-14,-8", path = "top"},
        {map = "-14,-9", path = "top"},
        {map = "-14,-10", path = "left"},
        {map = "-15,-10", path = "left", gather = true},
        {map = "-16,-8", path = "top", gather = true},
        {map = "-16,-9", path = "right"},
        {map = "-15,-9", path = "bottom(556)", gather = true},
        {map = "-15,-8", path = "bottom"},
        {map = "-16,-10", path = "top", gather = true},
        {map = "-16,-11", path = "right"},
        {map = "-15,-11", path = "right"},
        {map = "-14,-11", path = "right"},
        {map = "-13,-11", path = "bottom"},
        {map = "-13,-10", path = "bottom"},
        {map = "-13,-9", path = "right"},
        {map = "-12,-9", path = "bottom", gather = true},
        {map = "-18,-6", path = "bottom", gather = true},
        {map = "-17,-5", path = "top", gather = true},
        {map = "-18,-3", path = "right", gather = true},
        {map = "-18,-5", path = "bottom", gather = true},
        {map = "-18,-4", path = "bottom", gather = true},
        {map = "-17,-3", path = "top", gather = true},
        {map = "-17,-4", path = "top", gather = true},
    }
    
    local Pandala = {
        {map = "0,0", path = "zaap(207619076)"},
        {map = "207619076", path = "436"}, -- zaap pandala intérieur
        {map = "206307842", path = "left"}, -- sortie zaap pandala
        {map = "19,-30", path = "left"},
        {map = "18,-30", path = "left"},
        {map = "19,-29", path = "top", gather = true},
        {map = "17,-30", path = "left", gather = true},
        {map = "16,-30", path = "top", gather = true},
        {map = "18,-31", path = "top", gather = true},
        {map = "16,-33", path = "right", gather = true},
        {map = "16,-31", path = "right", gather = true},
        {map = "17,-31", path = "right", gather = true},
        {map = "18,-32", path = "left", gather = true},
        {map = "17,-32", path = "left", gather = true},
        {map = "16,-32", path = "top", gather = true},
        {map = "18,-35", path = "right", gather = true},
        {map = "17,-33", path = "right", gather = true},
        {map = "18,-33", path = "top", gather = true},
        {map = "18,-34", path = "top", gather = true},
        {map = "19,-35", path = "top"},
        {map = "19,-36", path = "right", gather = true},
        {map = "20,-36", path = "top", gather = true},
        {map = "20,-37", path = "right"},
        {map = "21,-37", path = "right"},
    }
    
    local Pandala2 = {
        {map = "22,-37", path = "left", gather = true},
        {map = "21,-37", path = "bottom"},
        {map = "21,-36", path = "bottom"},
        {map = "21,-35", path = "bottom"},
        {map = "21,-34", path = "right", gather = true},
        {map = "22,-34", path = "right"},
        {map = "23,-34", path = "right", gather = true},
        {map = "24,-34", path = "top"},
    }
    
    local Pandala3 = {
        {map = "24,-35", path = "bottom", gather = true},
        {map = "24,-34", path = "bottom"},
        {map = "24,-33", path = "right", gather = true},
        {map = "25,-33", path = "bottom", gather = true},
        {map = "25,-32", path = "bottom", gather = true},
        {map = "25,-31", path = "right", gather = true},
        {map = "27,-31", path = "bottom", gather = true},
        {map = "26,-31", path = "right"},
        {map = "27,-30", path = "bottom", gather = true},
        {map = "27,-29", path = "left", gather = true},
        {map = "26,-29", path = "top"},
        {map = "26,-30", path = "left", gather = true},
        {map = "25,-30", path = "left", gather = true},
        {map = "24,-30", path = "bottom", gather = true},
        {map = "24,-29", path = "left"},
        {map = "23,-29", path = "left", gather = true},
    }
    
    local Sidimote = {
        {map = "0,0", path = "zaap(171967506"},
        {map = "-25,11", path = "top", gather = true}, -- zone oliviolet
        {map = "-25,10", path = "top", gather = true},
        {map = "-24,9", path = "top", gather = true},
        {map = "-26,8", path = "top", gather = true},
        {map = "-25,6", path = "top", gather = true},
        {map = "-27,4", path = "top", gather = true},
        {map = "-25,9", path = "right", gather = true},
        {map = "-24,8", path = "left", gather = true},
        {map = "-26,7", path = "left", gather = true},
        {map = "-27,7", path = "top", gather = true},
        {map = "-27,6", path = "right"},
        {map = "-26,6", path = "right"},
        {map = "-25,5", path = "top", gather = true},
        {map = "-25,4", path = "left"},
        {map = "-26,4", path = "left", gather = true},
        {map = "-28,3", path = "top", gather = true},
        {map = "-26,3", path = "right", gather = true},
        {map = "-24,3", path = "top", gather = true},
        {map = "-24,2", path = "left", gather = true},
        {map = "-25,2", path = "left", gather = true},
        {map = "-28,2", path = "right"},
        {map = "-27,3", path = "right"},
        {map = "-27,2", path = "bottom"},
        {map = "-25,3", path = "right"},
        {map = "-26,2", path = "top", gather = true},
        {map = "-26,1", path = "right"},
        {map = "-25,1", path = "right", gather = true},
        {map = "-24,1", path = "top"},
        {map = "-24,0", path = "left", gather = true},
        {map = "-25,0", path = "left", gather = true},
        {map = "-27,0", path = "left", gather = true},
        {map = "-26,0", path = "left"},
        {map = "-28,0", path = "top", gather = true},
        {map = "-28,-1", path = "right", gather = true},
        {map = "-27,-1", path = "right"},
        {map = "-26,-1", path = "right"},
        {map = "-25,-1", path = "right", gather = true},
        {map = "-24,-1", path = "right"},
        {map = "-23,-1", path = "top"},
        {map = "-23,-2", path = "left", gather = true},
        {map = "-24,-2", path = "left", gather = true},
        {map = "-25,-2", path = "left", gather = true},
        {map = "-26,-2", path = "left", gather = true},
        {map = "-27,-2", path = "top", gather = true},
        {map = "-27,-3", path = "right", gather = true},
        {map = "-25,-3", path = "right", gather = true},
        {map = "-24,-3", path = "top", gather = true},
        {map = "-23,-4", path = "right", gather = true},
        {map = "-22,-4", path = "top", gather = true},
        {map = "-22,-5", path = "left", gather = true},
        {map = "-23,-5", path = "left", gather = true},
        {map = "-25,-5", path = "left", gather = true},
        {map = "-26,-3", path = "right"},
        {map = "-24,-4", path = "right"},
        {map = "-24,-5", path = "left"},
        {map = "-27,12", path = "top", gather = true},
        {map = "-26,12", path = "left", gather = true},
        {map = "-27,11", path = "right", gather = true},
        {map = "-26,11", path = "right"},
        {map = "-25,12", path = "right"},
        {map = "-25,8", path = "left"},
        {map = "-24,12", path = "bottom", gather = true},
        {map = "-24,13", path = "bottom", gather = true},
        {map = "-21,18", path = "bottom", gather = true},
        {map = "-21,19", path = "bottom", gather = true},
        {map = "-21,20", path = "bottom", gather = true},
        {map = "-21,21", path = "left"},
        {map = "-22,21", path = "top", gather = true},
        {map = "-22,20", path = "top", gather = true},
        {map = "-22,18", path = "top", gather = true},
        {map = "-22,19", path = "top"},
        {map = "-22,17", path = "left"},
        {map = "-23,17", path = "top"},
        {map = "-23,16", path = "left", gather = true},
        {map = "-24,16", path = "top"},
        {map = "-24,15", path = "left", gather = true},
        {map = "-25,15", path = "top"},
        {map = "-25,14", path = "top", gather = true},
        {map = "-25,13", path = "left", gather = true},
        {map = "-26,13", path = "top"},
        {map = "-24,14", path = "right", gather = true},
        {map = "-23,14", path = "bottom"},
        {map = "-23,15", path = "right", gather = true},
        {map = "-22,16", path = "right", gather = true},
        {map = "-22,15", path = "bottom"},
        {map = "-20,16", path = "bottom"},
        {map = "-21,16", path = "right"},
        {map = "-20,17", path = "left", gather = true},
        {map = "-21,17", path = "bottom"},
        {map = "-21,13", path = "bottom"},
        {map = "-26,-5", path = "havenbag", gather = true},
    }
    
    local function TakeKamas()
        npc:npcBank(-1)
        global:delay(500)
        if exchange:storageKamas() > 0 then
            exchange:getKamas(0)
            global:delay(500)
            global:printSuccess("j'ai récupérer les kamas, je retourne farmer")
            global:leaveDialog()
        elseif exchange:storageKamas() == 0 then
            global:printError("il n'y a pas de kamas dans la banque on attend un peu")
            global:leaveDialog()
            global:reconnect(1)
        end
    end
    
    local GoTakeKamas = {
        {map="0,0",path="zaap(212600323)"},
        {map="-31,-56",path="top"},
        {map="212600322", door = "468"},
        {map = "217059328", custom = TakeKamas},
    }
    
    local TableWhichArea = {
        {MapSwitch = "-67,-48", Area = Frigost, AreaString = "Île de Frigost", Farmer = false},
        {MapSwitch = "-53,21", Area = Otomai, AreaString = "Île d'Otomaï", Farmer = false},
        {MapSwitch = "-10,-45", Area = ForetCania, AreaString = "Plaines de Cania", Farmer = false},
        {MapSwitch = "-21,-4", Area = Koalak, AreaString = "Montagne des Koalaks", Farmer = false},
        {MapSwitch = "-12,-8", Area = Koalak2, AreaString = "Montagne des Koalaks", Farmer = false},
        {MapSwitch = "21,-37", Area = Pandala, AreaString = "Île de Pandala", Farmer = false},
        {MapSwitch = "24,-34", Area = Pandala2, AreaString = "Île de Pandala", Farmer = false},
        {MapSwitch = "22,-29", Area = Pandala3, AreaString = "Île de Pandala", Farmer = false},
        {MapSwitch = "-26,-5", Area = Sidimote, AreaString = "Landes de Sidimote", Farmer = false},
    }
    
    local Planches = {
        {Name = "Planche de Salut", Id = 16499, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {7016, 7014, 472, 7925, 470, 11107, 449, 16488}, lvlMax = 201, CanSell = true},
        {Name = "Planche a Dessin", Id = 16498, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {7016, 474, 472, 7925, 470, 7013, 449, 16488}, lvlMax = 201, CanSell = true},
        {Name = "Planche a Pain", Id = 16497, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {461, 474, 472, 7925, 7013, 449, 16488}, lvlMax = 201, CanSell = true},
        {Name = "Planche de Gravure", Id = 16496, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {461, 474, 2357, 7013, 449, 16488, 27375}, lvlMax = 201, CanSell = true},
        {Name = "Planche a Patisserie", Id = 16495, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 474, 2357, 7013, 2358, 471, 27375}, lvlMax = 140, CanSell = true},
        {Name = "Planche de Toilettes", Id = 16494, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {461, 2357, 460, 2358, 471, 27375}, lvlMax = 120, CanSell = true},
        {Name = "Planche a Repasser", Id = 16493, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 460, 2358, 471}, lvlMax = 100, CanSell = true},
        {Name = "Planche de Surf", Id = 16492, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 303, 460, 473}, lvlMax = 80, CanSell = true},
        {Name = "Planche a Griller", Id = 16491, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {476, 303, 473}, lvlMax = 60, CanSell = true},
        {Name = "Planche Contreplaquee", Id = 16489, Weight = 10, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {303, 473}, lvlMax = 40, CanSell = true},
    }
    
    local Bois = {
        {Name = "Tremble", Id = 11107, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Bambou Sacre", Id = 7014, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Orme", Id = 470, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Bambou Sombre", Id = 7016, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Charme", Id = 472, MaxHdv100 = 5, MaxHdv10 = 5, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Kaliptus", Id = 7925, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Ebene", Id = 449, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Noisetier", Id = 16488, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Mersier", Id = 474, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Bambou", Id = 7013, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "If", Id = 461, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Oliviolet", Id = 2357, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Pin", Id = 27375, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Erable", Id = 471, MaxHdv100= 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Bombu", Id = 2358, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Chene", Id = 460, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Noyer", Id = 476, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Chataignier", Id = 473, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
        {Name = "Frene", Id = 303, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = false, MinPrice = 5000, Priceitem100 = 0},
    }
    
    local TableGather = {
        {Name = "Frene", IdRessource = 1, IdObjet = 303, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Chataignier", IdRessource = 33, IdObjet = 473, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Noyer", IdRessource = 34, IdObjet = 476, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Chene", IdRessource = 8, IdObjet = 460, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Bombu", IdRessource = 98, IdObjet = 2358, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Erable", IdRessource = 31, IdObjet = 471, Max = 40 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Oliviolet", IdRessource = 101, IdObjet = 2357, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Pin", IdRessource = 27375, IdObjet = 401, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "If", IdRessource = 28, IdObjet = 461, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Bambou", IdRessource = 108, IdObjet = 7013, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Mersier", IdRessource = 35, IdObjet = 474, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Noisetier", IdRessource = 259, IdObjet = 16488, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Ebene", IdRessource = 29, IdObjet = 449, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Kaliptus", IdRessource = 121, IdObjet = 7925, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Charme", IdRessource = 32, IdObjet = 472, Max = 200 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Bambou Sombre", IdRessource = 109, IdObjet = 7016, Max = 90 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Orme", IdRessource = 30, IdObjet = 470, Max = 200 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Bambou Sacre", IdRessource = 110, IdObjet = 7014, Max = 150 * inventory:podsMax() / 6100, Farmer = true},
        {Name = "Tremble", IdRessource = 133, IdObjet = 11107, Max = 200 * inventory:podsMax() / 6100, Farmer = true},
    
    }
    
    local Seves = {
        {Name = "Seve de Frene", Id = 16909, CanSell = true},
        {Name = "Seve de Chataignier", Id = 16910, CanSell = true},
        {Name = "Seve de Noyer", Id = 16911, CanSell = true},
        {Name = "Seve de Chene", Id = 16912, CanSell = true},
        {Name = "Seve de Bombu", Id = 16913, CanSell = true},
        {Name = "Seve d'Erable", Id = 16914, CanSell = true},
        {Name = "Seve d'Oliviolet", Id = 16915, CanSell = true},
        {Name = "Seve d'If", Id = 16916, CanSell = true},
        {Name = "Seve de Bambou", Id = 16917, CanSell = true},
        {Name = "Seve de Merisier", Id = 16918, CanSell = true},
        {Name = "Seve de Noisetier", Id = 16919, CanSell = true},
        {Name = "Seve de Kaliptus", Id = 16921, CanSell = true},
        {Name = "Seve de Charme", Id = 16922, CanSell = true},
        {Name = "Seve de Bambou Sombre", Id = 16923, CanSell = true},
        {Name = "Seve de Bambou Sacre", Id = 16925, CanSell = true},
        {Name = "Seve d'Orme", Id = 16924, CanSell = true},
        {Name = "Seve de Tremble", Id = 16926, CanSell = true},
    }
    
    --- </init>
    
    local function getRemainingSubscription(inDay, acc)
        local accDeveloper = acc and acc.developer or developer
    
        local endDate = developer:historicalMessage("IdentificationSuccessMessage")[1].subscriptionEndDate 
        local now = os.time(os.date("!*t")) * 1000
    
        endDate = math.floor((endDate - now) / 3600000)
    
        return inDay and math.floor(endDate / 24) or endDate
    end
    

    --- <variables>
    
    local toGive = 0
    local server = character:server():lower()
    
    local bankMaps = {
        zAstrub = "zaap(191105026)",
        idHavenbag = 162791424,
        mapZAstrub = 191105026,
        bankAstrubExt = 191104002,
        bankAstrubInt = 192415750,
    }
    
    --- </variables>
    
    local function IncrementTable(i, Taille)
        local toReturn = (i + 1) % (Taille + 1)
        return (toReturn > 0) and toReturn or (toReturn == 0 and job:level(2) < 200) and 2 or (toReturn == 0 and job:level(2) == 200) and 1
    end
    
    local function GetLength(Table)
        local cpt = 0
        for _, element in ipairs(Table) do
            cpt = cpt + 1
        end
        return cpt
    end
    
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
    
    
    local function CheckEndFight(message)
        if not message.results[1].alive then
            global:restartScript(true)
        end
    end
    
    function messagesRegistering()
        developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
        developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
        developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
        developer:registerMessage("GameFightEndMessage", CheckEndFight)
    end
    
    ---Fonction qui permet de lancer la communication avec l'HDV.
    local function launch_hdv_activites(hdv_door_id)
        map:door(hdv_door_id)
        message = developer:createMessage("NpcGenericActionRequestMessage")
        message.npcId = -1
        message.npcActionId = 5
        message.npcMapId = map:currentMapId()
        developer:sendMessage(message)
        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
    end
    
    local function ProcessBank() -- done
        NeedToReturnBank = false
        npc:npcBank(-1)
        global:delay(500)
        if exchange:storageKamas() > 0 then
            exchange:putAllItems()
            global:delay(500)
            exchange:getKamas(0)
            global:delay(500)
            global:printSuccess("j'ai récupérer les kamas, je vais vendre")
        elseif exchange:storageKamas() == 0 then
            exchange:putAllItems()
            global:delay(500)
            global:printError("il n'y a pas de kamas dans la banque")
        end	
    
        if hdvFull then
            exchange:putAllItems()
        else
            for _, element in ipairs(Bois) do
                if inventory:itemCount(element.Id) > 0 then
                    exchange:putItem(element.Id, inventory:itemCount(element.Id))
                end
            end
            for _, element in ipairs(Planches) do
                if inventory:itemCount(element.Id) > 0 then
                    exchange:putItem(element.Id, inventory:itemCount(element.Id))
                end
            end
    
            if inventory:itemCount(16420) > 0 then exchange:putItem(16420, inventory:itemCount(16420)) end -- potion de glandage
            if inventory:itemCount(16419) > 0 then exchange:putItem(16419, inventory:itemCount(16419)) end -- potion des ancêtre
            if inventory:itemCount(substrat_de_sylve) > 0 then exchange:putItem(substrat_de_sylve, inventory:itemCount(substrat_de_sylve)) end
        end
        
        for _, element in ipairs(Bois) do
            global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
        end
    
        global:printSuccess("------------------------------")
    
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(substrat_de_sylve) .. " [" .. inventory:itemNameId(substrat_de_sylve) .. "]")
    
        for _, element in ipairs(Planches) do
            global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
        end
        
        for i = 1, 6 do
            TableGather[i].Farmer = exchange:storageItemQuantity(TableGather[i].IdObjet) > 1500
        end
    
        local podsAvailable = inventory:podsMax() - inventory:pods()
    
        for i = 1, 6 do 
            local QuantiteAPrendre = math.min(math.floor(podsAvailable / Planches[i].Weight), exchange:storageItemQuantity(Planches[i].Id), Planches[i].MaxHdv10 * 10 + Planches[i].MaxHdv1)
            if QuantiteAPrendre >= 10 and Planches[i].CanSell and not hdvFull then
                exchange:getItem(Planches[i].Id, QuantiteAPrendre)
                podsAvailable = inventory:podsMax() - inventory:pods()
                Planches[i].CanSell = false
                NeedToSell = true
            end
        end
    
        if CanSellSubstratDeSylve and exchange:storageItemQuantity(substrat_de_sylve) >= 10 and not hdvFull and not STOP then
            exchange:getItem(substrat_de_sylve, exchange:storageItemQuantity(substrat_de_sylve))
            podsAvailable = inventory:podsMax() - inventory:pods()
            NeedToSell = true
        end
    
        if exchange:storageItemQuantity(substrat_de_sylve) < 10 and character:kamas() > 300000 and exchange:storageItemQuantity(Planches[1].Id) >= 4 and not Planches[1].CanSell  then
            CraftQuantity = math.min(math.floor(exchange:storageItemQuantity(Planches[1].Id) / 2), 20)
            global:printSuccess("Possibilité de craft " .. CraftQuantity .. " [Substrat de Sylve]")
            exchange:getItem(Planches[1].Id, math.min(exchange:storageItemQuantity(Planches[1].Id, 20)))
            exchange:getItem(16419, math.min(exchange:storageItemQuantity(16419), 40))
            exchange:getItem(16420, math.min(exchange:storageItemQuantity(16420), 40))
            craftSubstratDeSylve = true
            NeedToSell = true
            NeedToCraft = true
        end
    
        for _, element in ipairs(Planches) do
            element.CanCraft = true
            for _, Id in ipairs(element.ListIdCraft) do
                if not (exchange:storageItemQuantity(Id) >= 50) or NeedToCraft or not element.CanSell then
                    element.CanCraft = false	
                    break
                end
            end
            if element.CanSell and element.CanCraft and not NeedToCraft and job:level(2) < element.lvlMax and not hdvFull then
                NeedToSell = false
                NeedToCraft = true
                CraftQuantity = math.floor(podsAvailable / (GetLength(element.ListIdCraft) * 50))
                for _, Id in ipairs(element.ListIdCraft) do 
                    CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(Id) / 10))
                end
    
                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")
    
                for _, Id in ipairs(element.ListIdCraft) do
                    exchange:getItem(Id, CraftQuantity * 10)
                end
            end
        end
    
        if not NeedToCraft then
            for _, element in ipairs(Bois) do
                local QuantiteAPrendre = math.min(math.floor(podsAvailable / 5), exchange:storageItemQuantity(element.Id), element.MaxHdv100 * 100 + element.MaxHdv10 * 10)
                if QuantiteAPrendre == (element.MaxHdv100 * 100 + element.MaxHdv10 * 10) and element.CanSell and not hdvFull then
                    exchange:getItem(element.Id, QuantiteAPrendre)
                    podsAvailable = inventory:podsMax() - inventory:pods()
                    NeedToSell = true
                end
            end
    
            for _, element in ipairs(Seves) do
                local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id))
                if QuantiteAPrendre > 0 and not hdvFull and element.CanSell then
                    exchange:getItem(element.Id, QuantiteAPrendre)
                    NeedToSell = true
                end
            end
        end
    
        podsAvailable = inventory:podsMax() - inventory:pods()
    
        if exchange:storageItemQuantity(10669) > 0 then
            exchange:getItem(10669, math.min(exchange:storageItemQuantity(10669), podsAvailable))
        end
        
        hdvFull = false
        STOP = false
        global:leaveDialog()
        global:delay(1000)
        map:door(518)
    end
        
    local function ProcessCraft() -- done
        NeedToCraft = false
        NeedToSell = true
        map:useById(500388, -1)
        global:delay(2000)
        
        for _, element in ipairs(Planches) do
            if element.CanCraft then
                for _, Id in ipairs(element.ListIdCraft) do
                    craft:putItem(Id, 10)
                end
                craft:changeQuantityToCraft(CraftQuantity)
                element.CanCraft = false
                global:delay(1000)
                craft:ready()
                global:delay(1000)
            end
        end
        if craftSubstratDeSylve then
            craftSubstratDeSylve = false
            craft:putItem(16420, 1)
            craft:putItem(16419, 1)
            craft:putItem(16499, 2)
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(1000)
            craft:ready()
        end
    
        global:leaveDialog() 
        global:delay(1000)
        map:moveToCell(341)
    end
        
    local function ProcessSell() -- done
        NeedToSell = false
        if mount:hasMount() and maxEnergy-mount:getEnergy() > 1000 then
            --global:printSuccess(" il faut acheter" .. math.floor((maxEnergy-mount:getEnergy())/10) .. "goujons pour que la dd soit full énergie")
            npc:npc(333,6)
            if inventory:itemCount(gid) <= 1000 then
                itemname = inventory:itemNameId(gid)
                Priceitem = sale:getPriceItem(gid, 3)
                if inventory:itemCount(gid) < math.floor((maxEnergy-mount:getEnergy())/10) then
                    while ( (inventory:itemCount(gid) < math.floor((maxEnergy-mount:getEnergy())/10)) and (sale:availableSpace() > 0) and (inventory:podsMax() - inventory:pods() > 200)) do 
                        sale:buyItem(gid,100,10000)
                    end 
                end
            end
            npc:leaveDialog()
            mount:feedMount(gid, math.floor((maxEnergy-mount:getEnergy())/10))
            --global:printSuccess("je viens de nourir la dd")
            if not mount:isRiding() then mount:toggleRiding()
            --global:printSuccess("je monte sur la dd")
            end
        end
    
    
        while craftSubstratDeSylve and not STOP and (inventory:itemCount(16420) < CraftQuantity or inventory:itemCount(16419) < CraftQuantity) do
            npc:npc(333, 5)
    
            local Priceitem1Glandage = sale:getPriceItem(16420, 1) -- potion de glandage
            local Priceitem10Glandage = sale:getPriceItem(16420, 2)
            local Priceitem1Ancetre = sale:getPriceItem(16419, 1) -- potion des ancêtre
            local Priceitem10Ancetre = sale:getPriceItem(16419, 2)
    
            global:leaveDialog()
            npc:npc(333, 6)
    
            if ((Priceitem1Glandage == 0 and Priceitem10Glandage == 0 or (Priceitem10Glandage > 200000 and Priceitem1Glandage > 20000)) and inventory:itemCount(16420) < CraftQuantity) or 
            ((Priceitem1Ancetre == 0 and Priceitem10Ancetre == 0 or (Priceitem10Ancetre > 200000 and Priceitem1Ancetre > 20000)) and inventory:itemCount(16419) < CraftQuantity)  then
                craftSubstratDeSylve = false
                STOP = true
            elseif inventory:itemCount(16420) < CraftQuantity and Priceitem10Glandage ~= 0 then
                sale:buyItem(16420, 10, 200000)
            elseif inventory:itemCount(16420) < CraftQuantity and Priceitem1Glandage ~= 0 then
                sale:buyItem(16420, 1, 20000)
            elseif inventory:itemCount(16419) < CraftQuantity and Priceitem10Ancetre ~= 0 then
                sale:buyItem(16419, 10, 200000)
            elseif inventory:itemCount(16419) < CraftQuantity and Priceitem1Ancetre ~= 0 then
                sale:buyItem(16419, 1, 20000)
            end
            global:leaveDialog()
    
        end 
        
        launch_hdv_activites(hdv_door_id)
        
        MuflePrice1 = sale:getPriceItem(10669, 1)
        MuflePrice10 = sale:getPriceItem(10669, 2)
        MuflePrice100 = sale:getPriceItem(10669, 3)
    
        for _, element in ipairs(Planches) do
               cpt = get_quantity(element.Id).quantity["10"]
               local Priceitem = sale:getPriceItem(element.Id, 2)
            while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
                Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
                sale:SellItem(element.Id, 10, Priceitem - 1) 
                global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
                cpt = cpt + 1
            end
               cpt = get_quantity(element.Id).quantity["1"]
               local Priceitem = sale:getPriceItem(element.Id, 1)
            while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < element.MaxHdv1 do 
                Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
                sale:SellItem(element.Id, 1, Priceitem - 1) 
                global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
                cpt = cpt + 1
            end
        end
    
        for _, element in ipairs(Bois) do
            cpt = get_quantity(element.Id).quantity["100"]
            element.Priceitem100 = sale:getPriceItem(element.Id, 3)
            element.Priceitem100 = (element.Priceitem100 == nil or element.Priceitem100 == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or element.Priceitem100
            while inventory:itemCount(element.Id) >= 100 and sale:availableSpace() > 0 and cpt < element.MaxHdv100 and element.Priceitem100 > element.MinPrice do 
                sale:SellItem(element.Id, 100, element.Priceitem100 - 1) 
                global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. element.Priceitem100 - 1 .. "kamas")
                cpt = cpt + 1
            end
            cpt = get_quantity(element.Id).quantity["10"]
            local Priceitem = sale:getPriceItem(element.Id, 2)
            while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 and element.Priceitem100 > element.MinPrice do 
                Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
                sale:SellItem(element.Id, 10, Priceitem - 1) 
                global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
                cpt = cpt + 1
            end
        end
    
        for _, element in ipairs(Seves) do
            cpt = get_quantity(element.Id).quantity["1"]
            local Priceitem = sale:getPriceItem(element.Id, 1)
            while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < 2 do 
                Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
                sale:SellItem(element.Id, 1, Priceitem - 1) 
                global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
                cpt = cpt + 1
            end
        end
    
        cpt = get_quantity(substrat_de_sylve).quantity["10"]
        local Priceitem = sale:getPriceItem(substrat_de_sylve, 2)
        while inventory:itemCount(substrat_de_sylve) >= 10 and sale:availableSpace() > 0 and cpt < 4 do 
            Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(substrat_de_sylve, 10, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. inventory:itemNameId(substrat_de_sylve) .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
        cpt = get_quantity(substrat_de_sylve).quantity["1"]
        local Priceitem = sale:getPriceItem(substrat_de_sylve, 1)
        while inventory:itemCount(substrat_de_sylve) >= 1 and sale:availableSpace() > 0 and cpt < 10 do 
            Priceitem = (Priceitem == nil or Priceitem == 0) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(substrat_de_sylve, 1, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. inventory:itemNameId(substrat_de_sylve) .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
    
        global:leaveDialog()
            
        while inventory:itemCount(10669) < 20 and character:kamas() > 50000 and ((MuflePrice100 > 0 and MuflePrice100 < 20000) or (MuflePrice10 > 0 and MuflePrice10 < 2000) or (MuflePrice1 > 0 and MuflePrice1 < 200)) do
            
            npc:npc(333, 5)
    
            MuflePrice1 = sale:getPriceItem(10669, 1)
            MuflePrice10 = sale:getPriceItem(10669, 2)
            MuflePrice100 = sale:getPriceItem(10669, 3)
    
            global:leaveDialog()
    
            global:printSuccess("achat changement d'apparence")
            npc:npc(333,6)
    
            sale:buyItem(10669, 100, 20000)
    
            if MuflePrice10 > 0 and MuflePrice10 < 2000 and inventory:itemCount(10669) < 20 then
                sale:buyItem(10669, 10, 2000)
            end
    
            if MuflePrice1 > 0 and MuflePrice1 < 200 and inventory:itemCount(10669) < 20 then
                sale:buyItem(10669, 1, 200)
            end
    
            global:leaveDialog()
        end
    
        launch_hdv_activites(hdv_door_id)
    
        -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
        for i = 1, 6 do
            if get_quantity(Planches[i].Id).quantity["10"] >= Planches[i].MaxHdv10 and get_quantity(Planches[i].Id).quantity["1"] >= Planches[i].MaxHdv1 then
                Planches[i].CanSell = false
            else
                Planches[i].CanSell = true
            end
        end
        for _, element in ipairs(Bois) do
            if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 or element.Priceitem100 < element.MinPrice then
                element.CanSell = false
            else
                element.CanSell = true
            end
        end
        for _, element in ipairs(Seves) do
            if get_quantity(element.Id).quantity["1"] >= 1 then
                element.CanSell = false
            else
                element.CanSell = true
            end
        end
        if get_quantity(substrat_de_sylve).quantity["10"] >= 4 and get_quantity(substrat_de_sylve).quantity["1"] >= 10 then 
            CanSellSubstratDeSylve = false 
        else
            CanSellSubstratDeSylve = true
        end
    
        if cptActualiser >= 3 and character:kamas() > 30000 then
            cptActualiser = 0
            global:printSuccess("on actualise")
            sale:updateAllItems()
        else
            cptActualiser = cptActualiser + 1
        end
            
        if sale:availableSpace() == 0 then 
            hdvFull = true 
            global:printError("l'hdv est plein") 
        else
            hdvFull = false
        end
        
        global:leaveDialog()
        StopAchat = false
        NeedToReturnBank = true
        map:changeMap("top")
    end
    
    local function treatMaps(maps)
    
        for _, element in ipairs(maps) do
            local condition = map:onMap(element.map)
    
            if condition then
                return maps
            end
        end
    
        if map:onMap(206308353) then map:changeMap("left") end
    
        for _, element in ipairs(MapSansHavreSac) do
            if not element.Door and map:onMap(tostring(element.Id)) then
                if map:currentCell() == tonumber(element.Path) then
                    map:moveToCell(math.random(50, 500))
                end
                map:moveToCell(tonumber(element.Path))
            elseif map:onMap(tostring(element.Id)) then
                map:door(tonumber(element.Door))
            end
        end
    
        map:changeMap("havenbag")
    end
    
    local function defineGather()
        local insert = table.insert
        local result = {}
        for _, element in pairs(TableGather) do
            if inventory:itemCount(element.IdObjet) < element.Max and element.Farmer then
                insert(result, element.IdRessource)
            end
        end
        GATHER = result
        if result == nil or #result == 0 then
            global:printSuccess("On a plus rien à récolter, on va à la banque")
            return bank()
        end
        if #result < 4 then
            global:printSuccess(#result .. " minerai à recolter")
        end
    end
    
    local function whichArea()
        hdvActualise = false
        if DebutDuScript then
            DebutDuScript = false
            for _, element in ipairs(TableWhichArea) do
                if not element.Farmer and map:currentArea() == element.AreaString then
                    element.Farmer = true
                    cpt = cpt + 1
                    break
                end
            end
            TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer = (cpt == 0) or TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer
        end
        if inventory:itemCount(1704) == 0 and job:level(2) > 180 and character:kamas() >= 150000 then
            return treatMaps(AreaAchatSacStaca)
        end
        if character:energyPoints() < 5000 then
            return treatMaps(AreaEnergie)
        end
    
        for i = 1, GetLength(TableWhichArea) do
            if map:onMap(TableWhichArea[i].MapSwitch) and TableWhichArea[i].Farmer then
                TableWhichArea[i].Farmer = false
                TableWhichArea[IncrementTable(i, GetLength(TableWhichArea))].Farmer = true
                return treatMaps(TableWhichArea[IncrementTable(i, GetLength(TableWhichArea))].Area)
            elseif TableWhichArea[i].Farmer then
                return treatMaps(TableWhichArea[i].Area)
            end 
        end
    end
    
    function move()
    
        while character:kamas() == 0 and map:onMap("4,-18") do
            npc:npcBank(-1)
            global:delay(500)
            if exchange:storageKamas() > 0 then
                exchange:getKamas(0)
                global:delay(500)
                global:printSuccess("j'ai récupérer les kamas, je retourne farmer")
                global:leaveDialog()
            elseif exchange:storageKamas() == 0 then
                global:printError("il n'y a pas de kamas dans la banque on attend un peu")
                global:leaveDialog()
                global:delay(1200000)
            end
        end
        if character:kamas() < 3000 then
            return treatMaps(GoTakeKamas)
        end
        if EDIT_ALIAS then
            EditAlias()
        end
    
        if getRemainingSubscription(true) <= (NbJoursRestantsTrigger - 1) and (character:kamas() > NbKamasMiniToTryAbonnement) then
            Abonnement()
        elseif getRemainingSubscription(true) < (NbJoursRestantsTrigger - 1) then
            Abonnement()
        end
    
        if NeedToSell then
            return {
                {map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
                {map ="0,0", path = "zaap(212600323)"},				
                {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
                {map = "-31,-56", path = "bottom"},
                {map = "-31,-55", path = "bottom"},
                {map = "-31,-54", path = "right"},
                {map = "212600322", path = "bottom"},
                {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
            }
        end
    
        if NeedToCraft then
            return {
                {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
                {map = "-30,-55", path = "havenbag"}, -- map en haut de hdv ressources
                {map ="0,0", path = "zaap(147590153)"},
                {map = "-17,-47", path = "right"},
                {map = "-16,-47", path = "right"},
                {map = "-15,-47", path = "right"},
                {map = "-14,-47", path = "right"},
                {map = "-13,-47", path = "top"},
                {map = "-13,-48", path = "top"},
                {map = "-13,-49", path = "top"},
                {map = "-13,-50", path = "top"},
                {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
                {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
            }
        end
    
        if NeedToReturnBank then
            return {
                {map = "-30,-55", path = "top"},
                {map = "-30,-56", door = "437"},
                {map = "-31,-56", path = "top"},
                {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
                {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
            }
        end

    
        if BANK_ACTIVATED then
            if global:remember("failed") then
                if not global:remember("retryTimestamp") then global:addInMemory("retryTimestamp", os.time()) end
        
                if secondsToHours(os.time() - global:remember("retryTimestamp")) >= minRetryHours then
                    rerollVar()
                    global:editInMemory("retryTimestamp", 0)
                end
            end
        
            if character:kamas() >= givingTriggerValue and not global:remember("failed") then
                givingMode = true
            end
        
            if givingMode then
                if not connected then
                    receiver = connectReceiver()
        
                    if cannotConnect then
                        rerollVar()
                        receiver:disconnect()
                        global:editInMemory("retryTimestamp", os.time())
                        global:addInMemory("failed", true)
                        global:restartScript(true)
                    else
                        connected = true
                    end
                end
        
                if not global:remember("failed") then
                    return goAstrubBank(launchExchangeAndGive)
                end
            end
        end
        
        defineGather()
    
        return whichArea()
    end
    
    function bank()
        if EDIT_ALIAS then
            EditAlias()
        end
        for _, element in ipairs(TableWhichArea) do
            element.Farmer = false
        end
        TableWhichArea[(job:level(2) < 200) and 2 or 1].Farmer = true
        
        if NeedToSell then
            return {
                {map = "155976712", path = "havenbag"}, -- map extérieur atelier bucheron
                {map ="0,0", path = "zaap(212600323)"},				
                {map = "212600322", path = "bottom"}, -- Map extérieure de la banque de bonta
                {map = "-31,-56", path = "bottom"},
                {map = "-31,-55", path = "bottom"},
                {map = "-31,-54", path = "right"},
                {map = "212600322", path = "bottom"},
                {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
            }
        end
    
        if NeedToCraft then
            return {
                {map = "212600322", path = "havenbag"}, -- Map extérieure de la banque d'bonta
                {map ="0,0", path = "zaap(147590153)"},
                {map = "-30,-55", path = "havenbag"}, -- map en haut de hdv ressources
                {map = "-17,-47", path = "right"},
                {map = "-16,-47", path = "right"},
                {map = "-15,-47", path = "right"},
                {map = "-14,-47", path = "right"},
                {map = "-13,-47", path = "top"},
                {map = "-13,-48", path = "top"},
                {map = "-13,-49", path = "top"},
                {map = "-13,-50", path = "top"},
                {map = "155976712", door = " 259"}, -- Map extérieure Atelier bucheron bonta
                {map = "158597120", custom = ProcessCraft}, -- Map intérieur Atelier bucheron bonta
            }
        end
    
        if NeedToReturnBank then
            return {
                {map = "-30,-55", path = "top"},
                {map = "-30,-56", door = "437"},
                {map = "-31,-56", path = "top"},
                {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
                {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
            }
        end
    
        if map:currentMapId()~=217059328 and map:currentMap()~= "-31,-57" and map:currentMap()~= "-31,-56" and map:currentMap()~=104861191 and map:currentMap()~=104862215 and map:currentMap()~=104859143  and map:currentMap()~=104859145 and map:currentMap()~=104860169 and map:currentMap()~=104861193   and map:currentMap()~=104862217 and map:currentMap()~=2885641 and map:currentMap()~=145209 and map:currentMap()~=2884113 and map:currentMapId()~=2885641 and map:currentMapId()~=147768 and map:currentMapId()~=162791424 and map:currentMapId()~=191104004 and map:currentMapId()~=7340551 and map:currentMapId()~="-32,-56" and map:currentMap()~="-4,2" and map:currentMapId()~=191104004  then 
            return{
                {map=tostring(map:currentMap()),path="havenbag"}}
            end
        
        return { 
            {map ="104861191", path = "457"},
            {map ="104862217", path = "369"},
            {map ="104861193", path = "454"},
            {map ="104859145", path = "192"},
            {map ="104860169", path = "379"},
            {map ="104858121", path = "507"},
            {map ="104072451", path ="havenbag"},
            {map="0,0",path="zaap(212600323)"},
            {map="-31,-56",path="top"},
            {map="212600322", door = "468"},
            {map = "217059328", custom = ProcessBank},
        }
    end
    
    function stopped()
        map:changeMap("havenbag")
    end
    
    function phenix()
        return
        {
            {map = "35,-42", path = "bottom"},
            {map = "35,-41", path = "bottom"},
            {map = "35,-40", custom = function() map:door(306) map:changeMap("havenbag") end},
            {map = "-9,-54", path = "left"},
            {map = "-10,-54", custom = function() map:door(342) map:changeMap("top") end},
            {map = "23330816", path = "bottom"},
            {map = "159769", path = "left"},
            {map = "-57,25", path = "left"},
            {map = "-58,24", path = "top"},
            {map = "-58,25", path = "top"},
            {map = "-58,23", path = "top"},
            {map = "-58,22", path = "top"},
            {map = "-58,21", path = "top"},
            {map = "-58,20", path = "top"},
            {map = "-58,19", path = "top"},
            {map = "-58,18", custom = function() map:door(354) map:changeMap("havenbag") end},
        }
    end
end

