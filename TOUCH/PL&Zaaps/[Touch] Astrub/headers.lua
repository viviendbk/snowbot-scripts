local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end
function choose_quest_objective(questId)
	if quest:questActive(questId) then
		local step = quest:questCurrentStep(questId)
		if step ~= -1 then
			local not_validated = quest:questRemainingObjectives(questId)
			for _, objectiveId in ipairs(not_validated) do
				return objectiveId
			end
		else
			global:printError("Impossible de récupérer l'étape courante de la quête ["..questId.."] ["..quest:name(questId).."]")
			global:disconnect()
		end
	else
		global:loadAndStart(MAIN_SCRIPT_PATH)
		global:finishScript()
	end
end
function check()
	if FIRST_LAUNCH == nil then
		FIRST_LAUNCH = true
		--------------------------------------
		CURRETN_QUEST_ID = quest:path()[3]
		CURRETN_STEP_ID = quest:path()[2]
		CURRETN_OBJECTIVE_ID = quest:path()[1]
		MAIN_SCRIPT_PATH = quest:mainPath()
		--------------------------------------
		local real_objective = choose_quest_objective(CURRETN_QUEST_ID)
		local current_objective = CURRETN_OBJECTIVE_ID
		if real_objective ~= current_objective then
			global:printError("Objective non disponible : ["..current_objective.."] "..quest:objectiveText(current_objective))
			global:printError("Objective disponible : ["..real_objective.."] "..quest:objectiveText(real_objective))
			global:printError("Lancement du script principal ["..MAIN_SCRIPT_PATH.."] ...")
			global:loadAndStart(MAIN_SCRIPT_PATH)
			global:finishScript()
		else
			global:printColor("#80FFFF", "Objective sélectionnée : ["..current_objective.."] "..quest:objectiveText(current_objective))

			-- Vérifier que le bot se trouve dans une bonne carte
			if #OBJECTIVE_MAPS > 0 and not has_value(OBJECTIVE_MAPS, map:currentMapId()) then
			global:printError("Le bot se trouve dans une carte inconnue ["..map:currentMapId().."] !")
				global:disconnect()
			end
		end
	else
		silent_check()
	end
end
function silent_check()
	local real_objective = choose_quest_objective(CURRETN_QUEST_ID)
	local current_objective = CURRETN_OBJECTIVE_ID
	if real_objective ~= current_objective then
		global:printError("Objective non disponible : ["..current_objective.."] "..quest:objectiveText(current_objective))
		global:printError("Objective disponible : ["..real_objective.."] "..quest:objectiveText(real_objective))
		global:printError("Lancement du script principal ["..MAIN_SCRIPT_PATH.."] ...")
		global:loadAndStart(MAIN_SCRIPT_PATH)
		global:finishScript()
	else
		if #OBJECTIVE_MAPS > 0 and not has_value(OBJECTIVE_MAPS, map:currentMapId()) then
			global:printError("Le bot se trouve dans une carte inconnue ["..map:currentMapId().."] !")
			global:loadAndStart(MAIN_SCRIPT_PATH)
			global:finishScript()
		end
	end
end