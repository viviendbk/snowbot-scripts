--- <Utilitaires>

local function Mot_Frayeur(cellId)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5883, cellId) == 0 then 
		fightAction:castSpellOnCell(5883, cellId)
	end
end

local function BestChoiceForZone(cellIdLauncher, spellId, cellIdEnemy, poMax, canHurtAllies)
	local entities = fightAction:getAllEntities()
	local spellZone = fightAction:getSpellZone(spellId, cellIdEnemy)
	local nbMonsterInZone = {}
	for i = 1, #spellZone do
		nbMonsterInZone[i] = 0
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
				if (element2 == element3.CellId) and element3.Team and element3.LifePoints > 0 and element3.Stats.invisibilityState ~= 1 and element3.Stats.invisibilityState ~= 2 and not iStop then
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


	if (nbMonsterInZone[i] == 1) and (fightAction:canCastSpellOnCell(cellIdLauncher, spellId, cellIdEnemy) == 0) then
        cellid = cellIdEnemy
	elseif i ~= 1 then
		cellid = spellZone[i]
	elseif (i == 1) and (nbMonsterInZone[i] ~= 0) then
		cellid = nil
	end

	return cellid
end

local function isEnemyStillHere(cellId)
	local entities = fightAction:getAllEntities()

	for _, entity in ipairs(entities) do
		if entity.Team and not entity.Stats.summoned and entity.Stats.invisibilityState ~= 1 and entity.Stats.invisibilityState ~= 2 and entity.CellId == cellId and entity.LifePoints > 0 then
			return true
		end
	end
	return false
end

local function isEnemyInside(listeCellId)
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

local function GetAllEnemiesFromTheNearest()

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

local function GetAllEnemiesFromTheLowest()

	local entities = fightAction:getAllEntities()
	local enemies = {}

	for _, entity in ipairs(entities) do
		if entity.Team and not entity.Stats.summoned and entity.Stats.invisibilityState ~= 1 and  entity.Stats.invisibilityState ~= 2 and entity.LifePoints > 0 then
			table.insert(enemies, entity)
		end
	end

	table.sort(enemies, function (a, b)
		return a.LifePoints < b.LifePoints
	end)
	return enemies
end

local function Contain(list, element)
	for _, x in ipairs(list) do
		if x == element then
			return true
		end
	end
	return false
end

local function IsHandToHandEnemy()
	local entities = fightAction:getAllEntities()
	
	for _, entity in ipairs(entities) do
		if entity.Team and fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
			return true
		end
	end
	return false
end

local function MoveTo(cellId, distanceMiniBetween, needLineOfSight)
    local listCellIdNearFromMonster = fightAction:getCells_lozenge(cellId, 1, distanceMiniBetween)
    local listCellIdWithDistance = {}

    if (fightAction:getDistance(fightCharacter:getCellId(), cellId) > distanceMiniBetween) or not fightAction:inLineOfSight(fightCharacter:getCellId(), cellId) then -- si on est déjà en ligne alors on ne bouge pas
		for _, cell in ipairs(listCellIdNearFromMonster) do
			if fightAction:isWalkable(cell) and fightAction:isFreeCell(cell) then
				local element = {
					CellId = cell,
					NbPMNeeded = #fightAction:getShortestPath(fightCharacter:getCellId(), cell, false),
					IsInLineOfSight = fightAction:inLineOfSight(cell, cellId)
				}
				table.insert(listCellIdWithDistance, element)
			end
		end
		table.sort(listCellIdWithDistance, function (a, b)
			return a.NbPMNeeded < b.NbPMNeeded
		end)
		for _, element in ipairs(listCellIdWithDistance) do
			if (not needLineOfSight or element.IsInLineOfSight) and not IsHandToHandEnemy() and element.NbPMNeeded ~= nil and (fightCharacter:getMP() >= element.NbPMNeeded) then
				fightAction:moveToWardCell(element.CellId)
				break
			end
		end
	end
end

local function MoveInLineOf(cellId) -- uniquement pour Mot Concussifs
	local listCellId = fightAction:getCells_cross(cellId, 1, 7)
	local listCellIdWithDistance = {}

	if IsHandToHandEnemy() and (fightCharacter:getAP() % 4) == 0 then
		Mot_Frayeur(fightAction:getNearestEnemy())
	end
	if (not Contain(listCellId, fightCharacter:getCellId()) and fightAction:getDistance(fightCharacter:getCellId(), cellId) > 7) 
	    or not fightAction:inLineOfSight(fightCharacter:getCellId(), cellId) then -- si on est déjà en ligne alors on ne bouge pas
        for _, cell in ipairs(listCellId) do
			if fightAction:isWalkable(cell) and fightAction:isFreeCell(cell) then
				local element = {
					CellId = cell,
					NbPMNeeded = #fightAction:getShortestPath(fightCharacter:getCellId(), cell, false),
					IsInLineOfSight = fightAction:inLineOfSight(cell, cellId)
				}
				table.insert(listCellIdWithDistance, element)
			end
        end
        table.sort(listCellIdWithDistance, function (a, b)
            return a.NbPMNeeded < b.NbPMNeeded
        end)

		for _, element in ipairs(listCellIdWithDistance) do
			if not IsHandToHandEnemy() and element.NbPMNeeded ~= nil and (fightCharacter:getMP() >= element.NbPMNeeded) and element.IsInLineOfSight then
				fightAction:moveToWardCell(element.CellId)
				break
			end
		end
	end
end

local function MoveAway(DistanceMax, DistanceMin) -- distance [max ou min] entre le perso et l'ennemi le plus proche
    local entities = GetAllEnemiesFromTheNearest()

	if entities ~= nil and #entities > 0 then

		if fightAction:getDistance(entities[1].CellId, fightCharacter:getCellId()) < DistanceMax then

			local CellWalkable = fightAction:getCells_lozenge(fightCharacter:getCellId(), 1, fightCharacter:getMP())
			local CellWalkableWithDistance = {}

			for _, cell in ipairs(CellWalkable) do
				local distance = 0
				for _, entity in ipairs(entities) do
					distance = distance + fightAction:getDistance(cell, entity.CellId)
				end
				local element = {
					CellId = cell,
					TotalDistance = distance
				}
				table.insert(CellWalkableWithDistance, element)
			end

			table.sort(CellWalkableWithDistance, function (a, b)
				return a.TotalDistance > b.TotalDistance           
			end)
	
			if fightCharacter:getMP() > 0 then
				local finalPath = fightAction:getShortestPath(fightCharacter:getCellId(), CellWalkableWithDistance[1].CellId, false)
				for i = 0, #finalPath - 1 do
					if fightAction:getDistance(entities[1].CellId, finalPath[#finalPath - i]) <= DistanceMax then
						fightAction:moveToWardCell(finalPath[#finalPath - i])
						return
					end
				end
			end

		end
		if fightAction:getDistance(entities[1].CellId, fightCharacter:getCellId()) >= DistanceMin then
			fightAction:moveToWardCell(entities[1].CellId)
		end
	end
end

--- <Utilitaires>

--- <Sorts>

local function Mot_Stimuant(cellId)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5803, cellId) == 0 then 
		fightAction:castSpellOnCell(5803, cellId)
	end	
end

local function Mot_Revitalisant()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 4951, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(4951, fightCharacter:getCellId())
	end	
end

local function Mot_Chaleureux(cellId)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 4947, cellId) == 0 then 
		fightAction:castSpellOnCell(4947,cellId)
	end	
end

local function Lapino(cellId)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5673, cellId) == 0 then 
		fightAction:castSpellOnCell(5673, cellId)
        Mot_Stimuant(cellId)
	end
end

local function LaunchLapino()
    local cellid = fightAction:getCells_lozenge(fightCharacter:getCellId(), 1, 2)
    table.sort(cellid, function(a, b) return fightAction:getDistance(a, fightAction:getNearestEnemy()) > fightAction:getDistance(b, fightAction:getNearestEnemy()) end)

    for i = 1, (fightCharacter:getAP() > 2) and #cellid or 0 do
        if cellid[i] ~= nil and fightCharacter:getAP() > 2 and fightAction:isWalkable(cellid[i]) and fightAction:isFreeCell(cellid[i]) then
            Lapino(cellid[i])
            break
        end
    end
end

local function Mot_Marquant(cellId)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5661, cellId) == 0 then 
		fightAction:castSpellOnCell(5661, cellId)
	end
end

local function Mot_Concussif(cellId)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5465, cellId) == 0 then 
		fightAction:castSpellOnCell(5465, cellId)
	end	
end

local function Mot_Accablant(cellId) -- niv 26
	cellId = BestChoiceForZone(fightCharacter:getCellId(), 4971, cellId, 4, true)
	if cellId ~= nil and (fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 4971, cellId) == 0) and isEnemyInside(fightAction:getSpellZone(4971, cellId)) then 
		fightAction:castSpellOnCell(4971, cellId)
	end
end

local function Mot_Vampyrique(cellId)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5663, cellId) == 0 then 
		fightAction:castSpellOnCell(5663, cellId)
	end	
end

local function Mot_Ereintant(cellId)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 5701, cellId) == 0 then 
		fightAction:castSpellOnCell(5701, cellId)
	end	
end

--- <Sorts>

function fightManagementPosition(challengers, defenders)

    local listCellIdWithDistance = {}

	for cell1, id1 in pairs(challengers) do
        local DistanceEmplacement = 0
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement = DistanceEmplacement + map:cellDistance(cell1, cell2)
			end
		end
        local element = {
            CellId = cell1,
            Distance = DistanceEmplacement
        }
        table.insert(listCellIdWithDistance, element)
	end

    table.sort(listCellIdWithDistance, function (a, b)
        return a.Distance < b.Distance
    end)

	local entities = fightAction:getAllEntities()
	local enemies = {}

	for _, entity in ipairs(entities) do
		if entity.Team then
			table.insert(enemies, entity)
		end
	end

	table.sort(enemies, function (a, b)
		return fightAction:getDistance(fightCharacter:getCellId(), a.CellId ) < fightAction:getDistance(fightCharacter:getCellId(), b.CellId )
	end)

    for _, element in ipairs(listCellIdWithDistance) do
        for _, enemy in pairs(enemies) do
            if fightAction:isHandToHand(element.CellId, enemy.CellId) then
                nextCell = true
                break
            end
        end
        if nextCell then
            nextCell = false
		elseif fightAction:isFreeCell(element.CellId) then
            fightAction:chooseCell(element.CellId)
			break
        end  
    end
end

function fightManagement()
    if fightCharacter:isItMyTurn() then

		local random = math.random()
		if random < 0.05 then
			global:delay(math.random(7000, 9000))
		elseif random < 0.2 then
			global:delay(math.random(2500, 3500))
		else
			global:delay(math.random(500, 1500))
		end
		
        if (fightAction:getCurrentTurn() - 1) % 3 == 0 then
            NbPa = fightCharacter:getAP()
            Mot_Stimuant(fightCharacter:getCellId())
            fightCharacter:forceAP(NbPa)
        end

		-- if l'ennemi le plus faible est à moins de 6 cases alors on va le rush
		local LowEnemies = GetAllEnemiesFromTheLowest()
		if LowEnemies ~= nil and #LowEnemies > 0 then
			for _, entity in ipairs(LowEnemies) do
				if fightCharacter:getAP() > 2 then
					if fightCharacter:getAP() > 3 and fightCharacter:getAP() < 5 then
						MoveInLineOf(entity.CellId)
						Mot_Vampyrique(entity.CellId)
					end
					MoveTo(entity.CellId, 8, true)
					Mot_Marquant(entity.CellId)
					if isEnemyStillHere(entity.CellId) and fightCharacter:getAP() > 3 then
						MoveInLineOf(entity.CellId)
						Mot_Vampyrique(entity.CellId)
						Mot_Concussif(entity.CellId)
					end
					if isEnemyStillHere(entity.CellId) then
						Mot_Accablant(entity.CellId)
					end
					if isEnemyStillHere(entity.CellId) then
						Mot_Accablant(entity.CellId)
					end
				end
			end
		end

		local enemies = GetAllEnemiesFromTheNearest()

		if enemies ~= nil and #enemies > 0 then
			for _, entity in ipairs(enemies) do
				if fightCharacter:getAP() > 2 then
					if fightCharacter:getAP() > 3 and fightCharacter:getAP() < 5 then
						MoveInLineOf(entity.CellId)
						Mot_Vampyrique(entity.CellId)
					end
					MoveTo(entity.CellId, 8, true)
					Mot_Marquant(entity.CellId)
					if isEnemyStillHere(entity.CellId) then
						Mot_Vampyrique(entity.CellId)
						Mot_Concussif(entity.CellId)
					end
				end
			end
		end

		enemies = GetAllEnemiesFromTheNearest()

		if enemies ~= nil and #enemies > 0 then
			for _, entity in ipairs(enemies) do
				if fightCharacter:getAP() > 3 then
					MoveInLineOf(entity.CellId)
					Mot_Vampyrique(entity.CellId)
					if isEnemyStillHere(entity.CellId) then
						Mot_Concussif(entity.CellId)
					end
				end
			end
		end

        enemies = GetAllEnemiesFromTheNearest()

		if enemies ~= nil and #enemies > 0 then
			for _, entity in ipairs(enemies) do
				if fightCharacter:getAP() > 2 then
					MoveTo(entity.CellId, 6, false)
					Mot_Accablant(entity.CellId)
					if isEnemyStillHere(entity.CellId) then
						Mot_Accablant(entity.CellId)
					end
					if isEnemyStillHere(entity.CellId) and fightCharacter:getLevel() > 59 then
						MoveTo(entity.CellId, 7, true)
						Mot_Ereintant(entity.CellId)
					end
				end
			end
			Mot_Marquant(fightAction:getNearestEnemy())
			Mot_Vampyrique(fightAction:getNearestEnemy())
			Mot_Accablant(fightAction:getNearestEnemy())
			
			if fightCharacter:getAP() > 3 and fightCharacter:getLevel() > 59 then
				MoveTo(fightAction:getNearestEnemy(), 7, true)
				Mot_Ereintant(fightAction:getNearestEnemy())
			end
			Mot_Frayeur(fightAction:getNearestEnemy())
		end

		Mot_Chaleureux(fightCharacter:getCellId())
        Mot_Chaleureux(fightCharacter:getCellId())
        Mot_Revitalisant()

        MoveAway(7, 10)
    end
end