----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 147063810 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
	return {
		{ map = "147063810", forcefight = true },
	}
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
ATTACK_SPELLS = {
	["1"] = 3, -- Féca
	["2"] = 4714, -- Osamodas
	["3"] = 43, -- Enutrof
	["4"] = 61, -- Sram
	["5"] = 83, -- Xélor
	["6"] = 6883, -- Ecaflip
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
function fightManagementPosition(challengers, defenders)
	if map:onMap("147063810") then
		global:delay(1000)
		for cell, id in pairs(challengers) do
			if id == -1 then
				global:printSuccess("Je me place sur la cellule : "..cell)
				fightAction:chooseCell(cell)
				break
			end
		end
	end
end
function fightManagement()
	if map:onMap("147063810") then
		if fightCharacter:isItMyTurn() == true then
			local cellId = fightAction:getNearestEnemy()
			local spellId = ATTACK_SPELLS[tostring(character:breed())]
			if fightAction:getDistance(fightCharacter:getCellId(), cellId) > 1 then
				fightAction:moveToWardCell(cellId)
			end
			if spellId ~= 0 then
				if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), spellId, cellId) == 0 then 
					fightAction:castSpellOnCell(spellId, cellId)
				end
			else
				if fightAction:getDistance(fightCharacter:getCellId(), cellId) == 1 then
					developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"GameActionFightCastRequestMessage\",\"data\":{\"spellId\":0,\"cellId\":"..cellId.."}}}")
					developer:suspendScriptUntil("SequenceEndMessage", 10000, true)
				end
			end
		end
	end
end