----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 147064834 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
	if not quest:validateObjective(CURRETN_QUEST_ID, CURRETN_OBJECTIVE_ID) then
		global:disconnect()
	end
    developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"StatsUpgradeRequestMessage\",\"data\":{\"statId\":11,\"boostPoint\":10,\"useAdditionnal\":false}}}")
	global:loadAndStart(MAIN_SCRIPT_PATH)
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------