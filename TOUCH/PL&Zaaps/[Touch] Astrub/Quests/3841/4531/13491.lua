----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 147062786 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
	global:printSuccess("Attente aléatoire avant de commencer le tutoriel ...")
	global:delay(global:random(10000, 20000))
	global:printSuccess("Le tutoriel commence ...")
	map:moveToCell(317)
	global:delay(500)
	if not quest:validateObjective(CURRETN_QUEST_ID, CURRETN_OBJECTIVE_ID) then
		global:disconnect()
	end
	global:loadAndStart(MAIN_SCRIPT_PATH)
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------