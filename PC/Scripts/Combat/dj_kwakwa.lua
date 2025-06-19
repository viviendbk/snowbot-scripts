dofile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Lib\\IMPORT_LIBRARIES.lua")

local done = false

local path = {
    {map = "0,0", path = "zaap(88213271)"},
   { map = "-2,0", path = "top" },
   { map = "-2,-1", path = "top" },
   { map = "-2,-2", path = "top" },
   { map = "-2,-3", path = "top" },
   { map = "-2,-4", path = "top" },
   { map = "-2,-5", path = "top" },
   { map = "-2,-6", path = "top" },
   { map = "-2,-7", path = "left" },
   { map = "-1,-3", path = "top" },
   { map = "-1,-5", path = "left" },
   { map = "-3,-7", path = "left" },

}

function move()
    
    mapDelay()
    global:printSuccess(done)
    if not done then
        if not map:onMap("-4,-7") then
            return treatMaps(path, function() map:changeMap("havenbag") end)
        end
        if map:onMap("185861122") then
            local tableIdSorts = {{Id = 12730, Lvl = 10}, {Id = 12731, Lvl = 10}, {Id = 12729, Lvl = 10}}
            for _, element in ipairs(tableIdSorts) do
                if character:level() >= element.Lvl then
                    message = developer:createMessage("SpellVariantActivationRequestMessage")
                    message.spellId = element.Id
                    developer:sendMessage(message)
                    global:delay(math.random(1000, 2500))
                end
            end
            npc:npc(1404, 3)
            npc:reply(-2)
            npc:reply(-1)
        end
        if map:onMap("64749568") or map:onMap("64750592") or map:onMap("64751616") or map:onMap("64752640") or map:onMap("64753664") then
            map:forceFight()
        end
        if map:onMap("64754688") then
            npc:npc(5817, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
    
            npc:npc(1404, 3)
            done = true
            npc:reply(-1)
            global:leaveDialog()
        end
    else
        if global:thisAccountController():getAlias():find("Combat ") or global:thisAccountController():getAlias():find("Combat2") then
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\PLAndZaaps\\Up_Chasseur.lua")
        else
            global:loadAndStart("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Combat\\Combat+Archi.lua")
        end
    end
end

function phenix()
    return PHENIX
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

local function IsHandToHandEnemy()
	local entities = fightAction:getAllEntities()
	
	for _, entity in ipairs(entities) do
		if entity.Team and entity.CellId and fightAction:isHandToHand(fightCharacter:getCellId(), entity.CellId) then
			return true
		end
	end
	return false
end

local function Contain(list, element)
	for _, x in ipairs(list) do
		if x == element then
			return true
		end
	end
	return false
end


local function Douleur_Cuisante()
	if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightCharacter:getCellId(), 12730, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12730, cellid) == 0 then 
			fightAction:castSpellOnCell(12730, cellid)
		end
	end
	if fightCharacter:getAP() > 2 then
		cellid = BestChoiceForZone(fightCharacter:getCellId(), 12730, WeakerMonsterAdjacent(), 5, false)
		if cellid ~= nil and fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12730, cellid) == 0 then 
			fightAction:castSpellOnCell(12730, cellid)
		end
	end
end

local function Deplacement()
    if map:currentSubArea() == "Bois de Litneg" then
        if fightAction:getCurrentTurn() > 10 and (fightAction:getCurrentTurn() % 2) == 0 then
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

local function MoveInLineOf(cellId, max)
    if not cellId then
        return
    end
	local listCellId = fightAction:getCells_cross(cellId, 1, max)
	local listCellIdWithDistance = {}
    local distance = #fightAction:getShortestPath(fightCharacter:getCellId(), cellId, false)

    if distance <= fightCharacter:getMP() then
        Deplacement()
        return
    end
	if (not Contain(listCellId, fightCharacter:getCellId()) and distance > max) 
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
                global:printSuccess("ok1")
				fightAction:moveTowardCell(element.CellId)
                global:printSuccess("ok2")
				break
			end
		end
	end
end


local function DeplacementSlave()
	if fightAction:isHandToHand(fightSlave:cellId(), fightSlave:getNearestEnemy()) == false and fightSlave:entity().MP > 0 then
		fightSlave:moveToWardCell(fightSlave:getNearestEnemy())
		global:delay(math.random(400, 700))
	end
end

local function MoveInLineOfForSlave(cellId, max) -- uniquement pour Mot Concussifs
    if not cellId then
        return
    end
	local listCellId = fightAction:getCells_cross(cellId, 1, max)
	local listCellIdWithDistance = {}
    local distance = #fightAction:getShortestPath(fightCharacter:getCellId(), cellId, false)

    if distance <= fightCharacter:getMP() then
        DeplacementSlave()
        return
    end
	if (not Contain(listCellId, fightSlave:cellId()) and distance > max) 
	    or not fightAction:inLineOfSight(fightSlave:cellId(), cellId) and (fightSlave:entity().MP > 0) then -- si on est déjà en ligne alors on ne bouge pas
            global:printSuccess("2")
        for _, cell in ipairs(listCellId) do
			if fightAction:isWalkable(cell) and fightAction:isFreeCell(cell) then
				local element = {
					CellId = cell,
					NbPMNeeded = #fightAction:getShortestPath(fightSlave:cellId(), cell, false),
					IsInLineOfSight = fightAction:inLineOfSight(cell, cellId)
				}
				table.insert(listCellIdWithDistance, element)
			end
        end
        global:printSuccess("3")
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

local function BainDeSang()
    if GetMonsterInCellId(fightAction:getNearestEnemy()).Stats.earthElementResistPercent == 100 then
        Douleur_Cuisante()
    else
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
            end	
        end
    end
end

local function BainDeSang2()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12732, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12732, fightCharacter:getCellId())
	end	
end

local function Attirance(cellid)
    if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12735, cellid) == 0 then 
		fightAction:castSpellOnCell(12735, cellid)
	end
end

local function Ravage(cellid)
    if GetMonsterInCellId(cellid).Stats.earthElementResistPercent == 100 then
        Douleur_Cuisante()
    else
        if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
            fightAction:castSpellOnCell(12746, cellid)
        else
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
            if not fightAction:isHandToHand(fightCharacter:getCellId(), cellid) then
                if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12746, cellid) == 0 then 
                    fightAction:castSpellOnCell(12746, cellid)
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
end

local function Decimation(cellid)
    global:printSuccess("okok")
    global:printSuccess(GetMonsterInCellId(cellid).Stats.earthElementResistPercent)
    if map:onMap(64751616) then
        global:printSuccess("douleur cuisante")
        Douleur_Cuisante()
    else
        if map:onMap(64753664) then
            Douleur_Cuisante()
        end
        if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12731, cellid) == 0 then 
            fightAction:castSpellOnCell(12731, cellid)
        end
    end
end

local function Cac(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 0, cellid) == 0 and (fightCharacter:getAP() > 4) then 
		fightAction:castSpellOnCell(0, cellid)
	end
end

local function Afflux()
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
	end	
end

local function Afflux2()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12729, fightCharacter:getCellId()) == 0  then 
		fightAction:castSpellOnCell(12729, fightCharacter:getCellId())
	end	
end

local function Pacte_De_Sang()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12762, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12762, fightCharacter:getCellId())
	end	
end

local function Courrone_Epine()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12761, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12761, fightCharacter:getCellId())
	end	
end

local function Fluctuation()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12763, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12763, fightCharacter:getCellId())
	end	
end


local function Libation()
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12759, fightCharacter:getCellId()) == 0 then 
		fightAction:castSpellOnCell(12759, fightCharacter:getCellId())
	end	
end

local function Epee_Vorace(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12744, cellid) == 0 and fightAction:isWalkable(cellid) and fightAction:isFreeCell(cellid) then 
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

local function Sacrifice(cellid)
	if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12739, cellid) == 0 then 
		fightAction:castSpellOnCell(12739, cellid)
	end
end

local function GetEntitiesInZoneBain_De_Sang()
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


local function NbMontresAdjacents(cellid)
    local entities = fightAction:getAllEntities()
    local CompteurMonstreAdjacents = 0

    for _, element in ipairs(fightAction:getAdjacentCells(cellid)) do
        for _, element2 in ipairs(entities) do
            CompteurMonstreAdjacents = CompteurMonstreAdjacents + (element == nil and 0 or element == element2.CellId and 1 or 0)
        end
    end
    return CompteurMonstreAdjacents
end

local function Abandon()
    global:printSuccess("abandon")
    local message = developer:createMessage("GameContextQuitMessage")
    developer:sendMessage(message)
end

function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local cellIdOmbre = 0
	local CellulesWithDistance = { }

	local i = 1
	for cell1, id1 in pairs(challengers) do
		if not fightAction:isFreeCell(cell1) and (id1 == -1) then
			cellIdOmbre = cell1
		end
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end

		local element = {
			Cellid = cell1,
			DistanceTotale = DistanceEmplacement[i]
		}
		table.insert(CellulesWithDistance, element)
		i = i + 1
	end

	table.sort(CellulesWithDistance, function(a, b) return a.DistanceTotale < b.DistanceTotale end)

	for i = 1, 11 do
		if not fightAction:isFreeCell(CellulesWithDistance[i].Cellid) and (CellulesWithDistance[i].CellId == cellIdOmbre) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
			message.requestedId = -1
			message.cellId = cellIdOmbre
			developer.sendMessage(message)

			break
		end
		if fightAction:isFreeCell(CellulesWithDistance[i].Cellid) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			if cellIdOmbre ~= 0 then
				message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
				message.requestedId = -1
				message.cellId = cellIdOmbre
				developer.sendMessage(message)

				message = developer:createMessage("GameFightPlacementPositionRequestMessage")
				message.cellId = CellulesWithDistance[i].Cellid
				developer.sendMessage(message)
			end
			break
		end
	end
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

function chooseChallenge(challengeId, i)
	global:delay(global:random(500, 1000))
	local ChallengeSelectionMessage = developer:createMessage("ChallengeSelectionMessage")
	ChallengeSelectionMessage.challengeId = challengeId
	developer:sendMessage(ChallengeSelectionMessage)
	global:printMessage("Le challenge ("..fightChallenge:challengeName(challengeId)..") a été choisi pour le slot N°"..tostring(i)..".")
	return challengeId
end
function challengeManagement(challengeCount, isMule)

	-- Choix le type de bonus
	-- 0 = XP
	-- 1 = DROP
	local challengeBonus = 1

	-- Choix du mode des challenges
	-- 0 = Manuel
	-- 1 = Aléatoire
	local challengeMod = 1
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------

	-- Texte variables
	local challengeBonusText = { "XP", "DROP" }
	local challengeModText = { "Manuel", "Aléatoire" }

	-- Choix le type de bonus
	local ChallengeBonusChoiceMessage = developer:createMessage("ChallengeBonusChoiceMessage")
	ChallengeBonusChoiceMessage.challengeBonus = challengeBonus
	developer:sendMessage(ChallengeBonusChoiceMessage)

	-- Choix du mode des challenges
	local ChallengeModSelectMessage = developer:createMessage("ChallengeModSelectMessage")
	ChallengeModSelectMessage.challengeMod = challengeMod
	developer:sendMessage(ChallengeModSelectMessage)

	-- Message
	if not isMule then
		global:printSuccess("Challenges: "..challengeModText[challengeMod + 1].." - Bonus: "..challengeBonusText[challengeBonus + 1])
	else
		global:printSuccess("[MULE] Bonus: "..challengeBonusText[challengeBonus + 1])
		return
	end
end

lancable = 0
incrementation = 0
function fightManagement()
    -- Je vérifie dans un premier temps que c'est bien à moi de jouer :
        
        if fightCharacter:isItMyTurn() == true then
            if fightAction:getCurrentTurn() == 1 then
                passTurnForOmbre = false
                lancable = 0
                incrementation = 0
            elseif fightAction:getCurrentTurn() > (map:currentSubArea() == "Bois de Litneg" and 150 or 100) then
                Abandon()
            end


            			
            local random = math.random()
            if random < 0.05 then
                global:delay(math.random(7000, 9000))
            elseif random < 0.2 then
                global:delay(math.random(2500, 3500))
            else
                global:delay(math.random(500, 1500))
            end
            global:printSuccess("1")
            -- J'avance vers mon ennemi le plus proche
            local enemies = GetAllEnemiesFromTheNearest()

            global:printSuccess("1.5")

            if enemies ~= nil and #enemies > 0 then
                for _, entity in ipairs(enemies) do
                    local PM = fightCharacter:getMP()
                    if PM > 0 and not IsHandToHandEnemy() and entity.CellId then
                        local cellId = fightCharacter:getCellId()
                        MoveInLineOf(entity.CellId, 6)
                        if cellId == fightCharacter:getCellId() then
                            MoveInLineOf(entity.CellId, 9)
                        end
                        if PM ~= fightCharacter:getMP() then
                            break
                        end
                    end
                end
            end
            global:printSuccess("2")

            local Hp = fightCharacter:getLifePoints()

            -- lancement mutilation
            if lancable == 0 then 
                if incrementation == 1 then
                    Hp = fightCharacter:getLifePoints()
                    if NbMontresAdjacents(fightCharacter:getCellId()) < 3 then
                        Decimation(WeakerMonsterAdjacent())
                    end
                    if fightCharacter:getAP() >= 6 and fightCharacter:getLifePoints() >= Hp then
                        BainDeSang()
                        Deplacement()
                    end
                    if fightCharacter:getAP() >= 6 and fightCharacter:getLifePoints() >= Hp then
                        BainDeSang()
                        Deplacement()
                    end
                    if fightCharacter:getAP() >= 4 and fightCharacter:getLifePoints() >= Hp then
                        Afflux()
                    end
                end
                fightAction:castSpellOnCell(12737, fightCharacter:getCellId())
                incrementation = (incrementation == 0) and 1 or 0
                lancable = lancable + incrementation

            else
                lancable = lancable - 1
            end
            global:printSuccess("3")

            Hp = fightCharacter:getLifePoints()


            Decimation(WeakerMonsterAdjacent())

            MoveInLineOf(fightAction:getNearestEnemy(), 6)


            BainDeSang()
            
            MoveInLineOf(fightAction:getNearestEnemy(), 6)

            BainDeSang()
            
            MoveInLineOf(fightAction:getNearestEnemy(), 6)
            Deplacement()
            Ravage(WeakerMonsterAdjacent())
            BainDeSang()

            MoveInLineOf(fightAction:getNearestEnemy(), 6)

            BainDeSang()

            MoveInLineOf(fightAction:getNearestEnemy(), 6)

            Ravage(WeakerMonsterAdjacent())

            Afflux()
            Afflux()
            LaunchEpee_Vorace()
            Douleur_Cuisante()
            Douleur_Cuisante()
            MoveInLineOf(fightAction:getNearestEnemy(), 6)

            fightAction:passTurn()
        else
            local random = math.random()
            if random < 0.05 then
                global:delay(math.random(7000, 9000))
            elseif random < 0.2 then
                global:delay(math.random(2500, 3500))
            else
                global:delay(math.random(500, 1500))
            end
            global:printSuccess("Ombre")

            fightAction:passTurn()

        end
end

