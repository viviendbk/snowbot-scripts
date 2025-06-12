function move()

	-- Attente
	global:delay(500)

	-- Initialiser
	if not quest:initialize() then
		global:printError("Impossible d'initialiser !")
		global:disconnect()
	end

	-- Vérification des quête
	choose_quest_objective(3841)
	choose_quest_objective(4262)
	choose_quest_objective(4264)
	choose_quest_objective(4276)
	choose_quest_objective(4282)

	-- Lancement automatique d'un script
	local config_path = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_Eni.xml"
	local script_path = "C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Take_Stuff_Akwadala.lua"
	if config_path == "" or script_path == "" then
		global:printError("Vous pouvez définir la configuration et le script à lancer dans le fichier main.lua dans les variables [config_path] et [script_path].")
	else
		if not global:fileExists(config_path) then
			global:printError("Le fichier ["..config_path.."] n'existe pas !")
		elseif not global:fileExists(script_path) then
			global:printError("Le fichier ["..script_path.."] n'existe pas !")
		else
			global:loadConfigurationWithoutScript(config_path)
			global:delay(500)
			if global:thisAccountController():getAlias():find("Next") then
				global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_24-43.lua")
			end
			global:loadAndStart(script_path)
		end
	end
end
function choose_quest_objective(questId)

	-- Variable
	local choosed_step = nil
	local choosed_objective = nil

	-- Séparateur
	global:printColor("#00FF00", "---------------------------------------------------------------------------------------------------------------------------------------")

	-- Print
	global:printColor("#B0FFB0", "Vérification de la quête ["..questId.."] ["..quest:name(questId).."] ...")

	-- Vérifier d'abord si la quête est active
	if quest:questActive(questId) then
		global:printColor("#B0FFB0", "La quête ["..questId.."] ["..quest:name(questId).."] est active")
		local step = quest:questCurrentStep(questId)
		if step == -1 then
			global:printColor("#B0FFB0", "Impossible de récupérer l'étape courante de la quête ["..questId.."] ["..quest:name(questId).."]")
			global:disconnect()
		else
			global:printColor("#B0FFB0", "        - Étape courante : ["..step.."] ["..quest:stepName(step).."]")
			global:printColor("#B0FFB0", "        - Description : "..quest:stepDescription(step))
			global:printColor("#B0FFB0", "        - Objectives de l'étape :")
			local validated = quest:questDoneObjectives(questId)
			local not_validated = quest:questRemainingObjectives(questId)
			for _, objectiveId in ipairs(validated) do
				global:printColor("#B0FFB0", "                [Validée] ["..objectiveId.."] "..quest:objectiveText(objectiveId))
			end
			for _, objectiveId in ipairs(not_validated) do
				if choosed_objective == nil then
					choosed_step = step
					choosed_objective = objectiveId
				end
				global:printColor("#B0FFB0", "                [En cours] ["..objectiveId.."] "..quest:objectiveText(objectiveId))
			end
			global:printColor("#B0FFB0", "")
		end
	else
		global:printColor("#B0FFB0", "La quête ["..questId.."] ["..quest:name(questId).."] n'est pas active")
	end

	-- Choose
	if choosed_objective ~= nil then
		local script = global:getCurrentScriptDirectory().."\\Quests\\"..questId.."\\"..choosed_step.."\\"..choosed_objective..".lua"
		global:printColor("#80FFFF", "Objective sélectionnée : ["..choosed_objective.."] "..quest:objectiveText(choosed_objective))
		global:printColor("#80FFFF", "Chargement du script ["..script.."] en cours ...")
		if not global:fileExists(script) then
			global:printError("Le script ["..script.."] n'existe pas !")
			global:disconnect()
		end
		global:loadAndStart(script)
		global:finishScript()
	end 
end
