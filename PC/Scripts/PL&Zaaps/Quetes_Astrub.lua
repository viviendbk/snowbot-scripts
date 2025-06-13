dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")

if not global:remember("ETAPE_QUETE") then
    global:addInMemory("ETAPE_QUETE", 0)
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
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
end

function launch_hdv_activites()
    --map:door(hdv_door_id)
    message = developer:createMessage("NpcGenericActionRequestMessage")
    message.npcId = -1
    message.npcActionId = 5
    message.npcMapId = map:currentMapId()
    developer:sendMessage(message)
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 2000, true)
end

local tableVente = {
    {Name = "viande intangible", Id = 16663, MaxHdv100 = 3, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Laine Celeste", Id = 16511, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Peau de Gloot", Id = 16522, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Cendres Eternelles", Id = 1984, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Reliques d'Incarnam", Id = 16524, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Queue de Chapardam", Id = 16515, MaxHdv100 = 0, MaxHdv10 = 3, MaxHdv1 = 0},
    {Name = "Plume Chimérique", Id = 16512, MaxHdv100 = 0, MaxHdv10 = 2, MaxHdv1 = 5},
}

local function SellViande()

    launch_hdv_activites()

    for i, element in ipairs(tableVente) do
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

        cpt = get_quantity(element.Id).quantity["1"]

		local Priceitem3 = sale:getPriceItem(element.Id, 1)
		Priceitem3 = (Priceitem3 == nil or Priceitem3 == 0 or Priceitem3 == 1) and sale:getAveragePriceItem(element.Id, 1) * 1.5 or Priceitem3
        while (inventory:itemCount(element.Id) >= 1) and (sale:AvailableSpace() > 0) and (cpt < element.MaxHdv1) do 
            sale:SellItem(element.Id, 1, Priceitem3 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem3 - 1 .. "kamas")
            cpt = cpt + 1
		end
    end

    global:leaveDialog()
    global:restartScript(false)
end

local function increment()
    global:editInMemory("ETAPE_QUETE", global:remember("ETAPE_QUETE") + 1)
    global:printSuccess("Etape : " .. global:remember("ETAPE_QUETE"))
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
    mapDelay()
    global:printSuccess(global:remember("ETAPE_QUETE"))
    if global:remember("ETAPE_QUETE") == 0 then
        GoTo("192416776", function ()
            increment()
            npc:npc(4355, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            map:changeMap("left")
        end)
    elseif global:remember("ETAPE_QUETE") == 1 then
        GoTo("192413702", function ()
            increment()
            npc:npc(1502, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            npc:npc(1502, 3)
            npc:reply(-1)
            npc:reply(-1)

            map:moveToCell(486)
        end)
    elseif global:remember("ETAPE_QUETE") == 2 then
        GoTo("2,-20", function ()
            increment()
            npc:npc(4402, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            npc:npc(4405, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            npc:npc(4402, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_QUETE") == 3 then
        GoTo("192413702", function ()
            increment()
            npc:npc(1502, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            map:moveToCell(486)
        end)
    elseif global:remember("ETAPE_QUETE") == 4 then
        GoTo("2,-20", function ()
            increment()
            npc:npc(4402, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            
            map:changeMap("right")
        end)
    elseif global:remember("ETAPE_QUETE") == 5 then
        GoTo("192413696", function ()
            increment()
            npc:npc(4361, 3)
            npc:reply(-3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            map:moveToCell(484)
        end)
    elseif global:remember("ETAPE_QUETE") == 6 then
        GoTo("4,-17", function ()
            increment()
            npc:npc(4407, 3)
            npc:reply(-1)
            npc:reply(-1)

            npc:npc(4408, 3)
            npc:reply(-1)
            npc:reply(-1)
        end)
    elseif global:remember("ETAPE_QUETE") == 7 then
        GoTo("4,-17", function ()
            increment()
            npc:npc(4407, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            map:changeMap("top")

        end)
    elseif global:remember("ETAPE_QUETE") == 8 then
        GoTo("192415750", function ()
            increment()
            npc:npc(522, 3)
            npc:reply(-4)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)

            npc:npc(4410, 3)
            npc:reply(-1)
            npc:reply(-1)
            map:moveToCell(409)
        end)
    elseif global:remember("ETAPE_QUETE") == 9 then
        GoTo("192415748", function ()
            increment()
            npc:npc(4310, 3)
            npc:reply(-2)
            npc:reply(-1)

            npc:npc(4411, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)            
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)  
            
            npc:npc(4412, 3)
            npc:reply(-1)
            npc:reply(-1)  

            map:door(409)
        end)
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
    elseif global:remember("ETAPE_QUETE") == 1 then
        
    end

end




local function BestChoiceForZone(cellIdLauncher, spellId, nearestEnnemi, poMax, canHurtAllies)
	local entities = fightAction:getAllEntities()
	local spellZone = fightAction:getSpellZone(spellId, nearestEnnemi)
	local nbMonsterInZone = { }
	for i = 1, #spellZone do
		table.insert(nbMonsterInZone, 0)
	end

	-- calcul du nombre d'ennemi dans la zone
	for i, cellId in ipairs(spellZone) do
		newAdjCases = ((fightAction:getDistance(cellId, cellIdLauncher) < (poMax + 1)) 
						and (fightAction:getDistance(cellId, cellIdLauncher) > 1)
						and fightAction:inLineOfSight(cellIdLauncher, cellId)
						and fightAction:isWalkable(cellId))
						and fightAction:getSpellZone(spellId, cellId) or { }

		for _, element2 in ipairs(newAdjCases) do
			for _, element3 in ipairs(entities) do
				if (element2 == element3.CellId) and element3.Team and not iStop then
					nbMonsterInZone[i] = nbMonsterInZone[i] + 1
				end
				if not canHurtAllies and (element2 == element3.CellId) and not element3.Team then
					nbMonsterInZone[i] = 0
					iStop = true
				end
			end
		end
		iStop = false
	end

	local i = 1
	local nbMinMonter = 0
	for j = 1, #nbMonsterInZone do
		if nbMonsterInZone[j] > nbMinMonter then
			nbMinMonter = nbMonsterInZone[j]
			i = j
		end
	end


	if (nbMonsterInZone[i] == 1) and (fightAction:canCastSpellOnCell(cellIdLauncher, spellId, nearestEnnemi) == 0) then
        cellid = nearestEnnemi
	elseif i ~= 1 then
		cellid = spellZone[i]
	elseif (i == 1) and (nbMonsterInZone[i] ~= 0) then
		cellid = nil
	end

	return cellid
end

local function WeakerMonsterAdjacent()
    local entities = fightAction:getAllEntities()
    local cellulesAdj = fightAction:getAdjacentCells(fightCharacter:getCellId())
    local minPv = nil
    local CellToReturn = nil
    for i, element in ipairs(entities) do
        for _, element2 in ipairs(cellulesAdj) do
            if element2 ~= nil and element.Id == 4619 and element.CellId == element2 and element.Team then 
                CellToReturn = element.CellId
                break
            end
            if element2 ~= nil and element.CellId == element2 and (minPv == nil or element.LifePoints < minPv) and element.Team then
                minPv = element.LifePoints
                CellToReturn = element.CellId
            end
        end
    end
    return (CellToReturn ~= nil) and CellToReturn or fightAction:getNearestEnemy()
end

local function Attirance(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12735, cellid) == 0 then 
		fightAction:castSpellOnCell(12735, cellid)
	end
end

local function Hemmoragie(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12748, cellid) == 0 then 
		fightAction:castSpellOnCell(12748, cellid)
	end
end


local function Douleur_Cuisante()
	if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightCharacter:getCellId(), 12730, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12730, cellid) == 0 then 
			fightAction:castSpellOnCell(12730, cellid)
		end
	end
end

local function Assaut()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12733, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12745, fightAction:getNearestEnemy())
	end
end

local function Ravage()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12745, fightAction:getNearestEnemy())
	end
end

local function Hostilite()			
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12756, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12756, fightAction:getNearestEnemy())
	end	
end

local function Courrone_Epine()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12761, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12761, fightCharacter:getCellId())
	end	
end

local function BainDeSang()
	if fightCharacter:getAP() > 3 then
		local canLaunch = false
		local idCellTouched = fightAction:getCells_square(fightCharacter:getCellId(), 0, 1)
		local entities = fightAction:getAllEntities()
		for _, entity in ipairs(entities) do
			for _, cellid in ipairs(idCellTouched) do
				if entity.CellId == cellid and entity.Team then
					canLaunch = true
					break
				end
			end
		end
		if canLaunch and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12732, fightCharacter:getCellId()) == 0 then 
			fightAction:castSpellOnCell(12732, fightCharacter:getCellId())
		end	
	end
end

local function Deplacement()
	if fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) == false and fightCharacter:getMP() > 0 then
		fightAction:moveTowardCell(fightAction:getNearestEnemy())
	end
end


local function Epee_Vorace(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12744, cellid) == 0 then 
		fightAction:castSpellOnCell(12744, cellid)
	end
end

local function LaunchEpee_Vorace()
    local cellid = fightAction:getCells_cross(fightCharacter:getCellId(), 1, 3)
    table.sort(cellid, function(a, b) return fightAction:getDistance(a, fightAction:getNearestEnemy()) < fightAction:getDistance(b, fightAction:getNearestEnemy()) end)

    for i = 1, (fightCharacter:getAP() >= 3) and #cellid or 0 do
        if cellid[i] ~= nil and fightCharacter:getAP() >= 3 and fightAction:isWalkable(cellid[i]) and fightAction:isFreeCell(cellid[i]) then
            Epee_Vorace(cellid[i])
        end
    end
end

local function GetEntitiesAdjacents()
    local toReturn = 0
    local idCellTouched = fightAction:getCells_cross(fightCharacter:getCellId(), 1, 1)
    local entities = fightAction:getAllEntities()
    for _, entity in ipairs(entities) do
        for _, cellid in ipairs(idCellTouched) do
            if entity.CellId == cellid and entity.Team then
                toReturn = toReturn + 1
                break
            end

        end
    end
    return toReturn
end

local function Abandon()
    global:printSuccess("abandon")
    local message = developer:createMessage("GameContextQuitMessage")
    developer:sendMessage(message)
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

function fightManagement()
		-- Je vérifie dans un premier temps que c'est bien à moi de jouer :
			local cellId = fightCharacter:getCellId()

		if fightCharacter:getLevel()>=10 then

			if  fightCharacter:isItMyTurn() == true then
				
				
				if fightAction:getCurrentTurn() == 1 then
					lancable = 0
					incrementation = 0
				elseif fightAction:getCurrentTurn() > 100 then
					Abandon()
				end

				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				-- lancement mutilation
				
				cellId = fightCharacter:getCellId()
				local mutilation = 12737
				
				if lancable == 0  then 
					if incrementation == 1 then
						if fightCharacter:getAP() > 5 then
							BainDeSang()
						end
						if fightCharacter:getAP() > 4 and fightCharacter:getLevel() >= 22 then
							Ravage()
						end
					end
					fightAction:castSpellOnCell(mutilation,cellId)
					incrementation = (incrementation == 0) and 1 or 0
					lancable = lancable + incrementation
				else
					lancable = lancable - 1
				end
				
				if fightCharacter:getLevel() > 14 then
					if fightCharacter:getAP() > 5 and fightCharacter:getLevel() >= 22 then
						Ravage()
					end
					LaunchEpee_Vorace()
				end
				-- lancement bain de sang

				BainDeSang()	
				
				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				-- J'avance vers mon ennemi le plus proche
				Deplacement()
				
				-- lancement ravage
				if fightCharacter:getLevel() >= 22 then
					Ravage()
				end

				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) and (fightCharacter:getLevel() > 44) then
					Courrone_Epine()
				end
				
				-- lancement douleur cuisante
				
				Douleur_Cuisante()
				Douleur_Cuisante()

				-- lancement assaut
				if fightCharacter:getLevel() > 39 then
					Hostilite()
				elseif fightCharacter:getLevel() > 25 then
					local entities = fightAction:getAllEntities()
					local cpt = 0
					for _,entity in ipairs(entities) do
						if fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
							cpt = cpt + 1
						end
					end
					if cpt <= 2 then
						Assaut()
					end	
				end
				
				Hemmoragie(fightAction:getNearestEnemy())

				Deplacement()
			end			
		else
			if (fightCharacter:isItMyTurn() == true) then
				-- J'avance vers mon ennemi le plus proche
				Deplacement()

					
				Hemmoragie(fightAction:getNearestEnemy())
				Deplacement()
				Hemmoragie(fightAction:getNearestEnemy())

				if fightCharacter:getLevel() > 5 then
					Douleur_Cuisante()
					Douleur_Cuisante()
				end
				Attirance(fightAction:getNearestEnemy())

				Hemmoragie(fightAction:getNearestEnemy())
				Deplacement()
				Hemmoragie(fightAction:getNearestEnemy())

			end
		end	
end


