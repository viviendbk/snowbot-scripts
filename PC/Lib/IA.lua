--- IA ---


--- IA TOOLS ---

function actionFightDelay()
	local random = math.random()
	if random < 0.02 then
		global:delay(math.random(5000, 7500))
    elseif random < 0.05 then
		global:delay(math.random(2000, 3000))
	elseif random < 0.25 then
		global:delay(math.random(800, 1500))
	elseif random < 0.5 then
		global:delay(math.random(400, 800))
	else
		global:delay(math.random(50, 400))
	end
end

function delayFightStartTurn()
    local random = math.random()
    if random < 0.05 then
        global:delay(math.random(6000, 7500))
    elseif random < 0.2 then
        global:delay(math.random(3000, 4000))
    else
        global:delay(math.random(500, 2000))
    end
end

function Abandon()
    global:printSuccess("abandon")
    local message = developer:createMessage("GameContextQuitMessage")
    developer:sendMessage(message)
end

function isKaskargoInFight()
    local entities = fightAction:getAllEntities()
    for _, element in ipairs(entities) do
        if element.CreatureGenericId == 1044 then
            return true
        end
    end
    return false
end

function IsHandToHandEnemy()
	local entities = fightAction:getAllEntities()
	
	for _, entity in ipairs(entities) do
		if entity.Team and entity.CellId and fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
			return true
		end
	end
	return false
end

function isEnemyInside(listeCellId)
	local entities = fightAction:getAllEntities()

	for _, cell in ipairs(listeCellId) do
		for _, entity in ipairs(entities) do
			if entity.Team  and entity.Stats.invisibilityState ~= 1 and entity.Stats.invisibilityState ~= 2 and entity.CellId == cell and entity.LifePoints > 0 then
				return true
			end
		end
	end
	return false
end

function GetEntitiesInZoneBain_De_Sang()
    local toReturn = {nbEntitiesInZone = 0,isOmbreInside = false}
    local idCellTouched = fightAction:getCells_square(fightCharacter:getCellId(), 0, 1)
    local entities = fightAction:getAllEntities()
    for _, entity in ipairs(entities) do
        for _, cellid in ipairs(idCellTouched) do
            if entity.CellId == cellid and entity.Team then
                toReturn.nbEntitiesInZone = toReturn.nbEntitiesInZone + 1
                break
            end
            if entity.CellId == cellid and entity.Companion then
                toReturn.isOmbreInside = true
            end
        end
    end
    return toReturn
end

function WeakerMonsterAdjacent()
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

function WeakerMonsterAdjacentSlave()
    local entities = fightAction:getAllEntities()
    local cellulesAdj = fightAction:getAdjacentCells(fightCharacter:getCellId())
    local minPv = nil
    local CellToReturn = nil
    for i, element in ipairs(entities) do
        for _, element2 in ipairs(cellulesAdj) do
            if (element2 ~= nil) and (element.CreatureGenericId == 1044) and (element.CellId == element2) and element.Team then 
                CellToReturn = element.CellId
                break
            end
            if (element2 ~= nil) and (element.CellId == element2) and (minPv == nil or element.LifePoints < minPv) and element.Team then
                minPv = element.LifePoints
                CellToReturn = element.CellId
            end
        end
    end
    return (CellToReturn ~= nil) and CellToReturn or fightSlave:getNearestEnemy()
end

function NbMontresAdjacents(cellid)
    local entities = fightAction:getAllEntities()
    local CompteurMonstreAdjacents = 0

    for _, element in ipairs(fightAction:getAdjacentCells(cellid)) do
        for _, element2 in ipairs(entities) do
            CompteurMonstreAdjacents = CompteurMonstreAdjacents + (element == nil and 0 or element == element2.CellId and 1 or 0)
        end
    end
    return CompteurMonstreAdjacents
end

function GetAllEnemiesFromTheNearest()

	local entities = fightAction:getAllEntities()
	local enemies = {}

	for _, entity in ipairs(entities) do
		if entity.Team and not entity.Stats.summoned and entity.Stats.invisibilityState ~= 1 and entity.Stats.invisibilityState ~= 2 and entity.LifePoints > 0 then
			table.insert(enemies, entity)
		end
	end

	table.sort(enemies, function (a, b)
		return fightAction:getDistance(fightCharacter:getCellId(), a.CellId ) < fightAction:getDistance(fightCharacter:getCellId(), b.CellId )
	end)
	return enemies
end

function printVar(variable, name, indent)
    name = name or "Variable"
    indent = indent or ""
    if type(variable) == "table" then
        global:printSuccess(indent .. name .. " = {")
        for k, v in pairs(variable) do
            printVar(v, k, indent .. "  ")
        end
        global:printSuccess(indent .. "}")
    else
        global:printSuccess(indent .. name .. " = " .. tostring(variable))
    end
end

function GetMonsterInCellId(cellId)
    local entities = fightAction:getAllEntities()
    for i, element in ipairs(entities) do
        if element.Team and element.CellId == cellId then 
            -- global:printSuccess(entities[i].Id)
            -- global:printSuccess(entities[i].LifePoints)

            -- -- printVar(entities[i].Stats)
            -- global:printSuccess(entities[i].Stats.neutralElementResistPercent)
            -- global:printSuccess(entities[i].Stats.earthElementResistPercent)
            -- global:printSuccess(entities[i].Stats.earthElementReduction)
            -- global:printSuccess(entities[i].Stats.pvpEarthElementResistPercent)
            -- global:printSuccess(entities[i].Stats.airElementResistPercent)

            -- global:printSuccess("b")

            return entities[i]
        end
    end
    return nil
end


function BestChoiceForZone(cellIdLauncher, spellId, nearestEnnemi, poMax, canHurtAllies)
    local entities = fightAction:getAllEntities()
    local cellIdWhereLaunchTheSpell = fightAction:getCells_lozenge(cellIdLauncher, 0, poMax)
	local monstersInZone = { }
    local iStop = false

    for i = 1, #cellIdWhereLaunchTheSpell do
		table.insert(monstersInZone, {entities = {}, totalDistanceFromCenter = 0})
	end

    for i, cellId in ipairs(cellIdWhereLaunchTheSpell) do
        if fightAction:canCastSpellOnCell(cellIdLauncher, spellId, cellId) == 0 then
            local spellZone = fightAction:getSpellZone(spellId, cellId)
            monstersInZone[i].cellId = cellId

            for _, cellIdSpellZone in ipairs(spellZone) do
                for _, entity in ipairs(entities) do
                    if entity.CellId == cellIdSpellZone and entity.Team and not iStop then
                        table.insert(monstersInZone[i].entities, entity)
                        monstersInZone[i].totalDistanceFromCenter = monstersInZone[i].totalDistanceFromCenter + fightAction:getDistance(cellId, entity.CellId)
                    end
                    if not canHurtAllies and (cellIdSpellZone == entity.CellId) and not entity.Team and cellIdSpellZone ~= cellIdLauncher then
                        monstersInZone[i] = {entities = {}, totalDistanceFromCenter = 0}
                        iStop = true
                    end
                end
            end
        end
        iStop = false
    end

    table.sort(monstersInZone, function(a,b) 
        if #a.entities ~= #b.entities then
            return #a.entities > #b.entities
        else
            return a.totalDistanceFromCenter < b.totalDistanceFromCenter
        end
    end)

	return monstersInZone[1].cellId
end

function getEntitiesInZone(cellIdLauncher, spellId, nearestEnnemi, poMax, canHurtAllies)


    local entities = fightAction:getAllEntities()
    local cellIdWhereLaunchTheSpell = fightAction:getCells_lozenge(cellIdLauncher, 0, poMax)
	local monstersInZone = { }
    local iStop = false
    for i = 1, #cellIdWhereLaunchTheSpell do
		table.insert(monstersInZone, {})
	end

    for i, cellId in ipairs(cellIdWhereLaunchTheSpell) do
        if fightAction:canCastSpellOnCell(cellIdLauncher, spellId, cellId) == 0 then
            local spellZone = fightAction:getSpellZone(spellId, cellId)

            for _, cellIdSpellZone in ipairs(spellZone) do
                for _, entity in ipairs(entities) do
                    if entity.CellId == cellIdSpellZone and entity.Team and not iStop then
                        table.insert(monstersInZone[i], entity)
                    end
                    if not canHurtAllies and (cellIdSpellZone == entity.CellId) and not entity.Team and cellIdSpellZone ~= cellIdLauncher then
                        monstersInZone[i] = {}
                        iStop = true
                    end
                end
            end
        end
        iStop = false
    end

    table.sort(monstersInZone, function(a,b) return #a > #b end)

    return monstersInZone[1]
end

function Eloignement()
    Hostilite(fightAction:getNearestEnemy())
    local possibleCellId = fightAction:getCells_lozenge(fightCharacter:getCellId(), 1, fightCharacter:getMP())
    local entities = fightAction:getAllEntities()
    local CellWithDistance = { }
    local DistanceEmplacement = { }

    for i, cell1 in ipairs(possibleCellId) do
        DistanceEmplacement[i] = 0
        for _, entity in ipairs(entities) do
            if entity.Team then
                DistanceEmplacement[i] = DistanceEmplacement[i] + fightAction:getDistance(cell1, entity.CellId)
            end
        end
        local element = {
            Cellid = cell1,
            DistanceTotale = DistanceEmplacement[i]
        }
        table.insert(CellWithDistance, element)
    end	

    table.sort(CellWithDistance, function(a, b) return a.DistanceTotale > b.DistanceTotale end)

    if (fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) == false) and (fightCharacter:getMP() > 0) then
		fightAction:moveTowardCell(CellWithDistance.CellId)
	end
end

function GetEntitiesAdjacents()
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

--- SACRI ---

function Deplacement()
    if map:currentSubArea() == "Bois de Litneg" then
        if fightAction:getCurrentTurn() > 10 and (fightAction:getCurrentTurn() % 2) == 0 and fightCharacter:getLevel() > 14 then
            LaunchEpee_Vorace()
        else
            if fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) == false and fightCharacter:getMP() > 0 then
                fightAction:moveTowardCell(fightAction:getNearestEnemy())
            end
        end
    elseif fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) == false and fightCharacter:getMP() > 0 then
		fightAction:moveTowardCell(fightAction:getNearestEnemy())
        global:delay(math.random(400, 700))
	end
end

function DeplacementProche()
    local enemy = fightAction:getNearestEnemy()
    local myCellId = fightCharacter:getCellId()
    local entities = fightAction:getAllEntities()
    local path = fightAction:getShortestPath(myCellId, enemy, entities)

    if path and #path > 0 then
        Deplacement()
    elseif not IsHandToHandEnemy() then
        local cellProches = fightAction:getCells_lozenge(enemy, 1, 4)
        table.sort(cellProches, function(a, b)
            local distA = fightAction:getDistance(enemy, a)
            local distB = fightAction:getDistance(enemy, b)
            local pathA = #fightAction:getShortestPath(myCellId, a, entities)
            local pathB = #fightAction:getShortestPath(myCellId, b, entities)
        
            if distA < distB or (distA == distB and pathA < pathB) then
                return true
            else
                return false -- Ajout d'un retour par défaut
            end
        end)
        
        for _, element in ipairs(cellProches) do
            local newPath = fightAction:getShortestPath(myCellId, element, entities)
            if newPath and #newPath > 0 then
                fightAction:moveTowardCell(element)
                global:delay(math.random(400, 700))
                break
            end
        end
    end
end

function MoveInLineOf(cellId, max)
    if not cellId then
        return
    end

	local listCellId = fightAction:getCells_cross(cellId, 1, max)
	local listCellIdWithDistance = {}
    local entities = fightAction:getAllEntities()
    debug("0")
    debug(type(entities))
    debug(type(cellId))
    debug(type(fightCharacter:getCellId()))
    local a = fightAction:getShortestPath(fightCharacter:getCellId(), cellId, entities)
    debug("ok")
    local distance = #fightAction:getShortestPath(fightCharacter:getCellId(), cellId, entities)

    debug("1")
    if distance <= fightCharacter:getMP() then
        Deplacement()
        return
    end
    debug("2")

	if (not Contain(listCellId, fightCharacter:getCellId()) and distance > max) 
	    or not fightAction:inLineOfSight(fightCharacter:getCellId(), cellId) then -- si on est déjà en ligne alors on ne bouge pas
        for _, cell in ipairs(listCellId) do
			if fightAction:isWalkable(cell) and fightAction:isFreeCell(cell) then
				local element = {
					CellId = cell,
					NbPMNeeded = #fightAction:getShortestPath(fightCharacter:getCellId(), cell, entities),
					IsInLineOfSight = fightAction:inLineOfSight(cell, cellId)
				}
				table.insert(listCellIdWithDistance, element)
			end
        end
        debug("3")
        table.sort(listCellIdWithDistance, function (a, b)
            return a.NbPMNeeded < b.NbPMNeeded
        end)
		for _, element in ipairs(listCellIdWithDistance) do
            debug("4")
			if not IsHandToHandEnemy() and element.NbPMNeeded ~= nil and (fightCharacter:getMP() >= element.NbPMNeeded) and element.IsInLineOfSight then
                local currentCellId = fightCharacter:getCellId()
				fightAction:moveTowardCell(element.CellId)
				if currentCellId == fightCharacter:getCellId() then
					fightAction:moveTowardCell(cellId)
				end
				break
			end
		end
	end
end

function Cac(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 0, cellid) == 0 and (fightCharacter:getAP() > 4) then 
		fightAction:castSpellOnCell(0, cellid)
        actionFightDelay()
	end
end

function Assaut()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12733, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12733, fightAction:getNearestEnemy())
        actionFightDelay()
	end
end

function Stase()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12728, fightAction:getNearestEnemy()) == 0 then 
		fightAction:castSpellOnCell(12728, fightAction:getNearestEnemy())
        actionFightDelay()
	end
end

function Hemmoragie(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12748, cellid) == 0 then 
		fightAction:castSpellOnCell(12748, cellid)
        actionFightDelay()
	end
end

function Condensation()
	if fightCharacter:getAP() > 2 then
		local cellid = BestChoiceForZone(fightCharacter:getCellId(), 12745, WeakerMonsterAdjacent(), 4, true)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12745, cellid) == 0 and isEnemyInside(fightAction:getSpellZone(12745, cellid)) then 
			fightAction:castSpellOnCell(12745, cellid)
            actionFightDelay()
		end
	end
end

function Absorption(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12734, cellid) == 0 then 
        fightAction:castSpellOnCell(12734, cellid)
        actionFightDelay()
    end
end

function Douleur_Cuisante()
	if fightCharacter:getAP() > 2 and fightCharacter:getLevel() > 114 then
		local cellid = BestChoiceForZone(fightCharacter:getCellId(), 12730, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12730, cellid) == 0 then 
			fightAction:castSpellOnCell(12730, cellid)
            actionFightDelay()
		end
	end
end

function Dissolution()
	if fightCharacter:getAP() > 3 then
		local cellid = BestChoiceForZone(fightCharacter:getCellId(), 12757, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12757, cellid) == 0 then 
			fightAction:castSpellOnCell(12757, cellid)
            actionFightDelay()
		end
	end
end

function Hecatombe()
	if fightCharacter:getAP() > 3 and fightCharacter:getLevel() > 74 then
		local cellid = BestChoiceForZone(fightCharacter:getCellId(), 12750, WeakerMonsterAdjacent(), 4, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12750, cellid) == 0 then 
			fightAction:castSpellOnCell(12750, cellid)
            actionFightDelay()
		end
	end
end

function BainDeSang()
	if fightCharacter:getAP() > 3 then
		local isOmbreInside = false
		local canLaunch = false
		local idCellTouched = fightAction:getCells_square(fightCharacter:getCellId(), 0, 1)
		local entities = fightAction:getAllEntities()
		for _, entity in ipairs(entities) do
			for _, cellid in ipairs(idCellTouched) do
				if entity.CellId == cellid and entity.Team and entity.id ~= 240 then
					canLaunch = true
					break
				end
				if entity.CellId == cellid and entity.Companion then
					isOmbreInside = true
				end
			end
		end
		if not isOmbreInside and canLaunch and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12732, fightCharacter:getCellId()) == 0 then 
			fightAction:castSpellOnCell(12732, fightCharacter:getCellId())
            actionFightDelay()
		end	
	end
end

function BainDeSang2()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12732, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12732, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Attirance(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12735, cellid) == 0 then 
		fightAction:castSpellOnCell(12735, cellid)
        actionFightDelay()
	end
end

function Ravage(cellid)
    debug("Ravage")
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
		fightAction:castSpellOnCell(12746, cellid)
        actionFightDelay()
    else
        debug("1")
        MoveInLineOf(fightAction:getNearestEnemy(), 6)
        debug("2")
        if not fightAction:isHandToHand(fightCharacter:getCellId(), cellid) then
            if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
                fightAction:castSpellOnCell(12746, cellid)
                actionFightDelay()
            else
                if not fightAction:isHandToHand(fightCharacter:getCellId(), cellid) then
                    MoveInLineOf(fightAction:getNearestEnemy(), 9)
                    Attirance(cellid)
                end
            end
        else
        end
    end
end

function Entaille()
    local cellid = WeakerMonsterAdjacent()
	if fightCharacter:getLevel() > 184 and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12751, cellid) == 0 then 
		fightAction:castSpellOnCell(12751, cellid)
        actionFightDelay()
	end
end

function Decimation()
    local nearestEnnemi = WeakerMonsterAdjacent()
    local bestCellId = BestChoiceForZone(fightCharacter:getCellId(), 12731, nearestEnnemi, 1, false)
    if bestCellId ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12731, nearestEnnemi) == 0 then 
        fightAction:castSpellOnCell(12731, nearestEnnemi)
        actionFightDelay()
    end
end

function Afflux()
    local canLaunch = false
	local idCellTouched = fightAction:getCells_cross(fightCharacter:getCellId(), 0, 3)
	local entities = fightAction:getAllEntities()
	for _, entity in ipairs(entities) do
		for _, cellid in ipairs(idCellTouched) do
			if entity.CellId == cellid and entity.Team then
				canLaunch = true
				break
			end
		end
	end
	if canLaunch and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12729, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12729, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Afflux2()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12729, fightCharacter:getCellId()) == 0  then 
		fightAction:castSpellOnCell(12729, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Supplice()
    local cellid = WeakerMonsterAdjacent()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12725, cellid) == 0 then
		fightAction:castSpellOnCell(12725, cellid)
        actionFightDelay()
	end
end

function Hostilite(cellId)			
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12756, cellId) == 0 then 
		fightAction:castSpellOnCell(12756, cellId)
        actionFightDelay()
	end	
end

function Pacte_De_Sang()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12762, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12762, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Berserk()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12743, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12743, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Courrone_Epine()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12761, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12761, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Fluctuation()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12763, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12763, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Libation()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12759, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12759, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Epee_Vorace(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12744, cellid) == 0 and fightAction:isWalkable(cellid) and fightAction:isFreeCell(cellid) then 
		fightAction:castSpellOnCell(12744, cellid)
        actionFightDelay()
	end
end

function LaunchEpee_Vorace()
    local cellid = fightAction:getCells_cross(fightCharacter:getCellId(), 1, 3)
    table.sort(cellid, function(a, b) return fightAction:getDistance(a, fightAction:getNearestEnemy()) < fightAction:getDistance(b, fightAction:getNearestEnemy()) end)

    for i = 1, (fightCharacter:getAP() >= 3) and #cellid or 0 do
        if cellid[i] ~= nil and fightCharacter:getAP() >= 3 and fightAction:isWalkable(cellid[i]) and fightAction:isFreeCell(cellid[i]) then
            Epee_Vorace(cellid[i])
        end
    end
end

function Sacrifice(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12739, cellid) == 0 then 
		fightAction:castSpellOnCell(12739, cellid)
        actionFightDelay()
	end
end

function Pilori()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 14011, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(14011, fightCharacter:getCellId())
        actionFightDelay()
	end	
end

function Punition(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12741, cellid) == 0 then 
		fightAction:castSpellOnCell(12741, cellid)
	end
end

function Nervosite()
	if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightCharacter:getCellId(), 12727, WeakerMonsterAdjacent(), 4, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12727, cellid) == 0 then 
			fightAction:castSpellOnCell(12727, cellid)
            actionFightDelay()
		end
	end
end

--- OMBRE ---

function DeplacementSlave()
	if fightAction:isHandToHand(fightSlave:cellId(), fightSlave:getNearestEnemy()) == false and fightSlave:entity().MP > 0 then
		fightSlave:moveToWardCell(fightSlave:getNearestEnemy())
		global:delay(math.random(400, 700))
	end
end

function DeplacementProcheSlave()
    local enemy = fightAction:getNearestEnemy()
    local myCellId = fightSlave:cellId()
    local entities = fightAction:getAllEntities()
    local path = fightAction:getShortestPath(myCellId, enemy, entities)

    if path and #path > 0 then
        DeplacementSlave()
    else
        local cellProches = fightAction:getCells_lozenge(enemy, 1, 4)
        table.sort(cellProches, function(a, b)
            local distA = fightAction:getDistance(enemy, a)
            local distB = fightAction:getDistance(enemy, b)
            local pathA = #fightAction:getShortestPath(myCellId, a, entities)
            local pathB = #fightAction:getShortestPath(myCellId, b, entities)
        
            if distA < distB or (distA == distB and pathA < pathB) then
                return true
            else
                return false -- Ajout d'un retour par défaut
            end
        end)
        for _, element in ipairs(cellProches) do
            local newPath = fightAction:getShortestPath(myCellId, element, entities)
            if newPath and #newPath > 0 then
                fightSlave:moveToWardCell(element)
                global:delay(math.random(400, 700))
                break
            end
        end
    end
end

function MoveInLineOfForSlave(cellId, max) -- uniquement pour Mot Concussifs
    if not cellId then
        return
    end
	local listCellId = fightAction:getCells_cross(cellId, 1, max)
	local listCellIdWithDistance = {}
    local entities = fightAction:getAllEntities()
    local distance = #fightAction:getShortestPath(fightCharacter:getCellId(), cellId, entities)

    if distance <= fightCharacter:getMP() then
        DeplacementSlave()
        return
    end
	if (not Contain(listCellId, fightSlave:cellId()) and distance > max) 
	    or not fightAction:inLineOfSight(fightSlave:cellId(), cellId) and (fightSlave:entity().MP > 0) then -- si on est déjà en ligne alors on ne bouge pas
        for _, cell in ipairs(listCellId) do
			if fightAction:isWalkable(cell) and fightAction:isFreeCell(cell) then
				local element = {
					CellId = cell,
					NbPMNeeded = #fightAction:getShortestPath(fightSlave:cellId(), cell, entities),
					IsInLineOfSight = fightAction:inLineOfSight(cell, cellId)
				}
				table.insert(listCellIdWithDistance, element)
			end
        end
        table.sort(listCellIdWithDistance, function (a, b)
            return a.NbPMNeeded < b.NbPMNeeded
        end)

		for _, element in ipairs(listCellIdWithDistance) do
			if not IsHandToHandEnemy() and element.NbPMNeeded ~= nil and (fightSlave:entity().MP >= element.NbPMNeeded) and element.IsInLineOfSight then
				fightSlave:moveToWardCell(element.CellId)
                global:delay(math.random(400, 700))
				break
			end
		end
	end
end

function Vengeance_Nocturne()
    local spellZone = fightAction:getCells_lozenge(fightSlave:cellId(), 1, 2)
    local entities = fightAction:getAllEntities()

    for _, entity in ipairs(entities) do
        for _, cellid in ipairs(spellZone) do
            if entity.CellId == cellid and entity.Team then
                if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4237, fightSlave:cellId()) == 0 then 
                    fightSlave:castSpellOnCell(4237, fightSlave:cellId())
                    actionFightDelay()
                end	                
                break
            end
        end
    end
end

function Vengeance_Nocturne2()
    if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4237, fightSlave:cellId()) == 0 then 
		fightSlave:castSpellOnCell(4237, fightSlave:cellId())
        actionFightDelay()
	end	
end

function Colere_Noire()
	local spellZone = fightAction:getCells_lozenge(fightSlave:cellId(), 1, 2)
    local entities = fightAction:getAllEntities()

    for _, entity in ipairs(entities) do
        for _, cellid in ipairs(spellZone) do
            if entity.CellId == cellid and entity.Team then
				if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4236, fightSlave:cellId()) == 0 then 
					fightSlave:castSpellOnCell(4236, fightSlave:cellId())
                    actionFightDelay()
				end	             
                break
            end
        end
    end
end

function Diabolo_Chiste(cellid)
	if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4234, cellid) == 0 then 
		fightSlave:castSpellOnCell(4234, cellid)
        actionFightDelay()
	end
end

function Cartilage(cellid)
    if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4233, cellid) == 0 then 
		fightSlave:castSpellOnCell(4233, cellid)
        actionFightDelay()
	end
end

function Crepuscule(cellid)
    if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4238, cellid) == 0 then 
		fightSlave:castSpellOnCell(4238, cellid)
        actionFightDelay()
	end
end

function Ombrolingo(cellid)

    if fightSlave:entity().AP > 2 then
        local entities = fightAction:getAllEntities()
        local casesAdjacentes = fightAction:getCells_cross(cellid, 0, 1)
        local cpt = {0, 0, 0, 0, 0}
    
        -- calcul du nombre d'ennemi dans la zone
        for i, element in ipairs(casesAdjacentes) do
            newAdjCases = ((fightAction:getDistance(element, fightSlave:cellId()) < 6) 
                            and (fightAction:getDistance(element, fightSlave:cellId()) > 1)
                            and fightAction:inLineOfSight(fightSlave:cellId(), element))
                            and fightAction:getCells_cross(element, 0, 1) or { }
    
            for _, element2 in ipairs(newAdjCases) do
                for _, element3 in ipairs(entities) do
                    if (element2 == element3.CellId) and element3.Team and not iStop then
                        cpt[i] = cpt[i] + 1
                    end
                    if (element2 == element3.CellId) and not element3.Team and not element3.Companion then
                        cpt[i] = 0
                        iStop = true
                    end
                end
            end
            iStop = false
        end
    
        local i = 1
        local nbMinMonter = 0
        for j = 1, #cpt do
            if cpt[j] > nbMinMonter then
                nbMinMonter = cpt[j]
                i = j
            end
        end
    
        if (cpt[i] == 1) and (fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4235, cellid) == 0) then

        elseif i ~= 1 then
            cellid = casesAdjacentes[i]
        elseif (i == 1) and (cpt[i] ~= 0) then
            cellid = nil
        end
        if cellid ~= nil and fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4235, cellid) == 0 then 
            fightSlave:castSpellOnCell(4235, cellid)
            actionFightDelay()
        end
    end
end



--- IA CHEVALIER D'ASTRUB ---

function Honsemotiv()
    if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4323, fightSlave:getNearestAlly()) == 0 then 
		fightSlave:castSpellOnCell(4323, fightSlave:getNearestAlly())
        actionFightDelay()
	end	
end

function Tranchantement(cellid)
    --if fightSlave:entity().AP > 2 then
        local entities = fightAction:getAllEntities()
        local casesAdjacentes = fightAction:getCells_cross(cellid, 0, 1)
        local cpt = {0, 0, 0, 0, 0}
    
        -- calcul du nombre d'ennemi dans la zone
        for i, element in ipairs(casesAdjacentes) do
            newAdjCases = ((fightAction:getDistance(element, fightSlave:cellId()) < 9) 
                            and (fightAction:getDistance(element, fightSlave:cellId()) > 4 )
                            and fightAction:inLineOfSight(fightSlave:cellId(), element))
                            and fightAction:getCells_cross(element, 0, 1) or { }
    
            for _, element2 in ipairs(newAdjCases) do
                for _, element3 in ipairs(entities) do
                    if (element2 == element3.CellId) and element3.Team and not iStop then
                        cpt[i] = cpt[i] + 1
                    end
                    if (element2 == element3.CellId) and not element3.Team and not element3.Companion then
                        cpt[i] = 0
                        iStop = true
                    end
                end
            end
            iStop = false
        end
    
        local i = 1
        local nbMinMonter = 0
        for j = 1, #cpt do
            if cpt[j] > nbMinMonter then
                nbMinMonter = cpt[j]
                i = j
            end
        end
    
        if (cpt[i] == 1) and (fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4321, cellid) == 0) then
		elseif i ~= 1 then
            global:printSuccess(casesAdjacentes[i])
            cellid = casesAdjacentes[i]
            if fightSlave:entity().AP == 4 and fightAction:getCurrentTurn() == 1 and fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4321, cellid) == 3 then
                fightSlave:castSpellOnCell(4321, cellid)
                actionFightDelay()
            end
        elseif (i == 1) and (cpt[i] ~= 0) then
            cellid = nil
        end
		if cellid ~= nil and fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4321, cellid) == 0 then 
			fightSlave:castSpellOnCell(4321, cellid)
            actionFightDelay()
		end
    --end
end

function Octavarice()
	if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4320, fightSlave:getNearestEnemy()) == 0 then 
		fightSlave:castSpellOnCell(4320, fightSlave:getNearestEnemy())
        actionFightDelay()
	end	
end

function Balestra()
	if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4322, fightSlave:getNearestEnemy()) == 0 then 
		fightSlave:castSpellOnCell(4322, fightSlave:getNearestEnemy())
        actionFightDelay()
	end	
end

function Estocard()
	if fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4324, fightSlave:getNearestEnemy()) == 0 then 
		fightSlave:castSpellOnCell(4324, fightSlave:getNearestEnemy())
        actionFightDelay()
	end	
end

function Boutonniere()
    if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightSlave:cellId(), 4325, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightSlave:canCastSpellOnCell(fightSlave:cellId(), 4325, cellid) == 0 then 
			fightSlave:castSpellOnCell(4325, cellid)
            actionFightDelay()
		end
	end
end