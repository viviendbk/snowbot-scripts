dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\IA\\Functions_IA.lua")



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

function challengeManagement(challengeCount, isMule)

	-- Choix le type de bonus
	-- 0 = XP
	-- 1 = DROP
	local challengeBonus = 0

	-- Choix du mode des challenges
	-- 0 = Manuéatoire
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

function fightManagement()
    -- Je vérifie dans un premier temps que c'est bien à moi de jouer :

    if fightCharacter:isItMyTurn() == true then
        
        if fightAction:getCurrentTurn()==1 then
            lancable = 0
            incrementation = 0
        end
		local random = math.random()
		if random < 0.05 then
			global:delay(math.random(7000, 9000))
		elseif random < 0.2 then
			global:delay(math.random(2500, 3500))
		else
			global:delay(math.random(500, 1500))
		end

        Deplacement()
        -- lancement mutilation
        if lancable == 0 then 
            if incrementation == 1 then
                Absorption(fightAction:getNearestEnemy())    
                if fightCharacter:getAP() > 4 then
                    Absorption(fightAction:getNearestEnemy())    
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


        Absorption(fightAction:getNearestEnemy())    
        LaunchEpee_Vorace()

        Absorption(fightAction:getNearestEnemy())    

            -- lancement douleur cuisante

		if character:level() > 74 then
			Hecatombe()
			Hecatombe()
		else
			Stase()
			Stase()
		end

        Hostilite(WeakerMonsterAdjacent())

        Courrone_Epine()
        
        Deplacement()
        
    else
		if fightSlave:name() == "Ombre" then
			global:printSuccess("Ombre")
            local random = math.random()
            if random < 0.05 then
                global:delay(math.random(7000, 9000))
            elseif random < 0.2 then
                global:delay(math.random(2500, 3500))
            else
                global:delay(math.random(500, 1500))
            end
            MoveInLineOfForSlave(fightSlave:getNearestEnemy(), 6)

            Colere_Noire()

            Vengeance_Nocturne()

            DeplacementProcheSlave()

            local nearestEnnemi = WeakerMonsterAdjacentSlave()
            Diabolo_Chiste(nearestEnnemi)

            local entities = fightAction:getAllEntities()
            local AdjCases = fightAction:getAdjacentCells(fightSlave:cellId())
            local newEnnemi = nil

            for _, cellId in ipairs(AdjCases) do
                for _, entity in ipairs(entities) do
                    if (entity.CellId == cellId) and entity.Team and (entity.CellId ~= nearestEnnemi) then
                        newEnnemi = entity.CellId
                    end
                end
            end
            if newEnnemi == nil then
                newEnnemi = fightSlave:getNearestEnemy()
            end
            if newEnnemi ~= nearestEnnemi then
                Diabolo_Chiste(newEnnemi)
            end

            DeplacementSlave()

            Cartilage(WeakerMonsterAdjacentSlave())
            DeplacementSlave()
            Diabolo_Chiste(WeakerMonsterAdjacentSlave())
            DeplacementSlave()
            Vengeance_Nocturne()
            DeplacementSlave()
			Ombrolingo(WeakerMonsterAdjacentSlave())
			DeplacementSlave()
			Ombrolingo(WeakerMonsterAdjacentSlave())
			
			Crepuscule(WeakerMonsterAdjacentSlave())
			DeplacementSlave()
			Crepuscule(fightSlave:getNearestEnemy())

            Vengeance_Nocturne2()
            global:printSuccess("Fin Ombre")
		else
			-- local random = math.random()
            -- if random < 0.05 then
            --     global:delay(math.random(7000, 9000))
            -- elseif random < 0.2 then
            --     global:delay(math.random(2500, 3500))
            -- else
            --     global:delay(math.random(500, 1500))
            -- end
			-- global:printSuccess(fightSlave:name())
	
			-- local entities = fightAction:getAllEntities()
			-- local ennemyTouchable = {}
			-- for _, entity in ipairs(entities) do
			-- 	if fightAction:getDistance(fightSlave:cellId(), entity.CellId) > 3 and entity.Team then
			-- 		table.insert(ennemyTouchable, entity.CellId)
			-- 	end
			-- end
			-- table.sort(ennemyTouchable, function (a, b) return fightAction:getDistance(fightSlave:cellId(), a) < fightAction:getDistance(fightSlave:cellId(), b) end)
	
			-- for _, cellid in ipairs(ennemyTouchable) do
			-- 	Tranchantement(cellid)
			-- end
	
			-- DeplacementSlave()  
	
			-- Estocard()
			
			-- Estocard()
	
			
	
			-- local entities = fightAction:getAllEntities()
			-- local ennemyTouchable = {}
			-- for _, entity in ipairs(entities) do
			-- 	if fightAction:getDistance(fightSlave:cellId(), entity.CellId) > 3 and entity.Team then
			-- 		table.insert(ennemyTouchable, entity.CellId)
			-- 	end
			-- end
			-- table.sort(ennemyTouchable, function (a, b) return fightAction:getDistance(fightSlave:cellId(), a) < fightAction:getDistance(fightSlave:cellId(), b) end)
	
			-- for _, cellid in ipairs(ennemyTouchable) do
			-- 	Tranchantement(cellid)
			-- end
	
			-- Balestra()
			-- Estocard()
	
			-- DeplacementSlave()
	
			-- Balestra()
	
			-- DeplacementSlave()
	
			-- Octavarice()
			-- DeplacementSlave()
			-- Octavarice()
	
	
			-- DeplacementSlave()
	
			-- Honsemotiv()
			-- global:printSuccess("Fin Chevalier")
		end

    end	
end