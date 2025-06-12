----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 145490435, 145490434, 145489922, 145489921, 145489920, 145490432, 145490944, 145490945, 145490433 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
	if global:afterFight() and mapActions ~= nil and map:onMap(mapActions.map) then
		return { mapActions }
	end
    mapActions = getMapActions()
    if mapActions ~= nil then
	    return { mapActions }
	end
end
function getMapActions()

	-- Retoure la première carte non visitée
	for _, mapActions in ipairs(mapActionsTable) do
		if map:onMap(mapActions.map) and not mapActions.done then
			mapActions.done = true
			return mapActions
		end
		mapActions.done = true
	end

	-- Toutes les cartes sont visitées ? on réinitialise
	for _, mapActions in ipairs(mapActionsTable) do
		mapActions.done = false
	end

	-- Script circulaire ?
	if true then
		-- Retoure la première carte non visitée
		for _, mapActions in ipairs(mapActionsTable) do
			if map:onMap(mapActions.map) and not mapActions.done then
				mapActions.done = true
				return mapActions
			end
			mapActions.done = true
		end
	end

	-- Aucune carte ?
	return nil
end
mapActionsTable =
{
	{ map = "145490435", path = "top", done = false },
	{ map = "145490434", fight = true, path = "left", done = false },
	{ map = "145489922", fight = true, path = "top", done = false },
	{ map = "145489921", fight = true, path = "top", done = false },
	{ map = "145489920", fight = true, path = "right", done = false },
	{ map = "145490432", fight = true, path = "right", done = false },
	{ map = "145490944", fight = true, path = "bottom", done = false },
	{ map = "145490945", fight = true, path = "left", done = false },
	{ map = "145490433", fight = true, path = "bottom", done = false },
}
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
ATTACK_SPELLS = {
	["1"] = 3, -- Féca
	["2"] = 4714, -- Osamodas
	["3"] = 43, -- Enutrof
	["4"] = 61, -- Sram
	["5"] = 83, -- Xélor
	["6"] = 7467, -- Ecaflip
	["7"] = 4947, -- Eniripsa
	["8"] = 141, -- Iop
	["9"] = 5799, -- Crâ
	["10"] = 183, -- Sadida
	["11"] = 5885, -- Sacrieur
	["12"] = 0, -- Pandawa
	["13"] = 2794, -- Roublard
	["14"] = 6131, -- Zobal
	["15"] = 3210, -- Steamer
}
function fightManagement()
	if fightCharacter:isItMyTurn() == true then
		if fightAction:getCurrentTurn() == 1 then
			quest:validateObjective(CURRETN_QUEST_ID, CURRETN_OBJECTIVE_ID)
		end
		local cellId = fightAction:getNearestEnemy()
		if fightAction:getDistance(fightCharacter:getCellId(), cellId) > 1 then
			fightAction:moveToWardCell(cellId)
		end
		for i = 1, 3 do
			local cellId = fightAction:getNearestEnemy()
			local spellId = ATTACK_SPELLS[tostring(character:breed())]
			if spellId ~= 0 then
				if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), spellId, cellId) == 0 then 
					fightAction:castSpellOnCell(spellId, cellId)
				end
			else
				if fightAction:getDistance(fightCharacter:getCellId(), cellId) == 1 then
					developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"GameActionFightCastRequestMessage\",\"data\":{\"spellId\":0,\"cellId\":"..cellId.."}}}")
					developer:suspendScriptUntil("SequenceEndMessage", 10000, true)
					break
				end
			end
		end
	end
end