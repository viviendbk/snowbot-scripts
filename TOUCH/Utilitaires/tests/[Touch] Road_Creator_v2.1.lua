global:printSuccess("--------------------------------------------------------------------------------------------------------------------------------------------")
global:printSuccess("--------------------------------------------------------------------------------------------------------------------------------------------")
global:printSuccess("------------------------------------------- Road Creator Touch - Version 2.1 --------------------------------------------------")
global:printSuccess("------------------- Created By Pharwell (Discord : https://www.ankabot.dev/pharwell) -------------------------")
global:printSuccess("------------------------ AnkaBot Discord Server: https://www.ankabot.dev/discord -------------------------------")
global:printSuccess("----------------------------------------- Website: https://www.ankabot.dev/ ----------------------------------------------")
global:printSuccess("--------------------------------------------------------------------------------------------------------------------------------------------")
global:printSuccess("--------------------------------------------------------------------------------------------------------------------------------------------")

----------------------------------------------------------------------------------------------
--------------------------------------- Configuration ----------------------------------------
----------------------------------------------------------------------------------------------

RC_INCLUDE_CELLID 	= true 		-- false = Ne pas inclure les cellId après les directions
RC_PREFER_MAPID 	= true 		-- false = Utilisation des coordonnées au lieu du MapId
RC_SAVE_MOVEMENTS 	= false		-- true  = Enregistrer tous les mouvements que vous ayez effectué avant de changer la carte
RC_ASK_FIGHT		= true		-- true  = Demander si vous voulez faire des combats dans la carte
RC_ASK_GATHER		= false	-- true  = Demander si vous voulez faire des récoltes dans la carte

----------------------------------------------------------------------------------------------
---------------------------------------- DON'T TOUCH -----------------------------------------
----------------------------------------------------------------------------------------------
RC_DEBUG			= false		-- Affichage des messages pour le debug
RC_CHANGE_TYPE_ENUM = {
	UNKNOWN = 0,
	NORMAL = 1,
	WALK = 2,
	INTERACTIVE = 3,
	ZAAP = 4,
	ZAAPI = 5
}
RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.UNKNOWN
RC_LAST_CELL_ID = map:currentCell()
RC_LAST_INTERACTIVE_CELLID = 0
RC_LAST_MAP_ID = map:currentMapId()
RC_LAST_MAP_X = map:getX(map:currentMapId())
RC_LAST_MAP_Y = map:getY(map:currentMapId())
RC_FILENAME = "Road_"..os.time(os.date("!*t"))..".lua"
RC_CUSTOM = "function() "
RC_DIRECTION = ""

-- Combats et récoltes
FIGHT_OPTION = ""
GATHER_OPTION = ""
if RC_ASK_FIGHT then
	FIGHT_OPTION = global:rcAskFight()
end
if RC_ASK_GATHER then
	GATHER_OPTION = global:rcAskGather()
end

----------------------------------------------------------------------------------------------
------------------------------- Lire le contenu d'un fichier ---------------------------------
----------------------------------------------------------------------------------------------
function readAll(file)
    local f = assert(io.open(file, "r"))
    local content = f:read("*all")
    f:close()
    return content
end

----------------------------------------------------------------------------------------------
----------------------------------- Création du fichier --------------------------------------
----------------------------------------------------------------------------------------------
PharwellFormat = "global:printSuccess(\"--------------------------------------------------------------------------------------------------------------------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"--------------------------------------------------------------------------------------------------------------------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"--------------------------------- Script made by : Road Creator - Version 2.1 -----------------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"------------------- Created By Pharwell (Discord : https://www.ankabot.dev/pharwell) -------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"------------------------ AnkaBot Discord Server: https://www.ankabot.dev/discord -------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"----------------------------------------- Website: https://www.ankabot.dev/ ----------------------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"--------------------------------------------------------------------------------------------------------------------------------------------\")\n"
PharwellFormat = PharwellFormat.."global:printSuccess(\"--------------------------------------------------------------------------------------------------------------------------------------------\")\n\n"
PharwellFormat = PharwellFormat.."RC_CIRCULAR = false		-- true = recommencer le script depuis le début, necessite que la dernière carte vous mène à la première carte.\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."function move()\n"
PharwellFormat = PharwellFormat.."	if global:afterFight() and mapActions ~= nil and map:onMap(mapActions.map) then\n"
PharwellFormat = PharwellFormat.."		return { mapActions }\n"
PharwellFormat = PharwellFormat.."	end\n"
PharwellFormat = PharwellFormat.."    mapActions = getMapActions()\n"
PharwellFormat = PharwellFormat.."    if mapActions ~= nil then\n"
PharwellFormat = PharwellFormat.."	    return { mapActions }\n"
PharwellFormat = PharwellFormat.."	end\n"
PharwellFormat = PharwellFormat.."end\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."function getMapActions()\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."	-- Retoure la première carte non visitée\n"
PharwellFormat = PharwellFormat.."	for _, mapActions in ipairs(mapActionsTable) do\n"
PharwellFormat = PharwellFormat.."		if map:onMap(mapActions.map) and not mapActions.done then\n"
PharwellFormat = PharwellFormat.."			mapActions.done = true\n"
PharwellFormat = PharwellFormat.."			return mapActions\n"
PharwellFormat = PharwellFormat.."		end\n"
PharwellFormat = PharwellFormat.."		mapActions.done = true\n"
PharwellFormat = PharwellFormat.."	end\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."	-- Toutes les cartes sont visitées ? on réinitialise\n"
PharwellFormat = PharwellFormat.."	for _, mapActions in ipairs(mapActionsTable) do\n"
PharwellFormat = PharwellFormat.."		mapActions.done = false\n"
PharwellFormat = PharwellFormat.."	end\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."	-- Script circulaire ?\n"
PharwellFormat = PharwellFormat.."	if RC_CIRCULAR then\n"
PharwellFormat = PharwellFormat.."		-- Retoure la première carte non visitée\n"
PharwellFormat = PharwellFormat.."		for _, mapActions in ipairs(mapActionsTable) do\n"
PharwellFormat = PharwellFormat.."			if map:onMap(mapActions.map) and not mapActions.done then\n"
PharwellFormat = PharwellFormat.."				mapActions.done = true\n"
PharwellFormat = PharwellFormat.."				return mapActions\n"
PharwellFormat = PharwellFormat.."			end\n"
PharwellFormat = PharwellFormat.."			mapActions.done = true\n"
PharwellFormat = PharwellFormat.."		end\n"
PharwellFormat = PharwellFormat.."	end\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."	-- Aucune carte ?\n"
PharwellFormat = PharwellFormat.."	return nil\n"
PharwellFormat = PharwellFormat.."end\n"
PharwellFormat = PharwellFormat.."\n"
PharwellFormat = PharwellFormat.."mapActionsTable =\n"
PharwellFormat = PharwellFormat.."{\n"
roadFile = io.open(RC_FILENAME, "w")
roadFile:write(PharwellFormat)
roadFile:close()

----------------------------------------------------------------------------------------------
---------------------------- Enregistrement de quelques messages -----------------------------
----------------------------------------------------------------------------------------------
function messagesRegistering()
	developer:registerMessage("MapComplementaryInformationsDataInHouseMessage", newMapAction)
	developer:registerMessage("MapComplementaryInformationsDataMessage", newMapAction)
	developer:registerMessage("MapComplementaryInformationsAnomalyMessage", newMapAction)
	developer:registerMessage("MapComplementaryInformationsBreachMessage", newMapAction)
	developer:registerMessage("MapComplementaryInformationsWithCoordsMessage", newMapAction)
	developer:registerMessage("ChangeMapMessage", _ChangeMapMessage)
end

-- ChangeMapMessage
function _ChangeMapMessage(message)
	RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.NORMAL
	local changeMapId = tonumber(developer:deserializeObject(message, "mapId"))
	if changeMapId == map:neighbourId("top") then
		RC_DIRECTION = "top"
	elseif changeMapId == map:neighbourId("bottom") then
		RC_DIRECTION = "bottom"
	elseif changeMapId == map:neighbourId("left") then
		RC_DIRECTION = "left"
	elseif changeMapId == map:neighbourId("right") then
		RC_DIRECTION = "right"
	else
		RC_DIRECTION = "unknown"
	end
end

-- Dès l'entrée à une nouvelle carte
function newMapAction(message)

	-- Extraire les coordonnées de la carte actuelle
	local CurrentMapID = tonumber(developer:deserializeObject(message, "mapId"))
	local CurrentMapX = map:getX(CurrentMapID)
	local CurrentMapY = map:getY(CurrentMapID)

	-- Set custom
	if RC_SAVE_MOVEMENTS then
		if RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.NORMAL or RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.WALK or RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.INTERACTIVE or RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAP or RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAPI then
			for i = #RC_CUSTOM - 1, 1, -1 do
			    local c = RC_CUSTOM:sub(i,i)
			    if c == " " then
			    	if RC_CUSTOM:sub(i+1,i+14) == "map:moveToCell" then
			    		RC_CUSTOM = RC_CUSTOM:sub(1,i)
			    	end
			    	break
			    end
			end
		end
	end
	if RC_CUSTOM ~= "function() " then
		RC_CUSTOM = ", custom = "..RC_CUSTOM.."end"
	else
		RC_CUSTOM = ""
	end

	-- Comment
	local comment = "--[["..RC_LAST_MAP_X..","..RC_LAST_MAP_Y.."]]"
	for i=1, 15 - #comment do
		comment = comment.." "
	end

	-- Ouverture du fichier
	tmpText = readAll(RC_FILENAME)
	if string.sub(tmpText, -1) == "}" then
		tmpText = tmpText:sub(0, #tmpText - 1)
	end
	roadFile = io.open(RC_FILENAME, "w")
	roadFile:write(tmpText)

	if RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.NORMAL then

		if (RC_LAST_MAP_X + 1) == CurrentMapX then
			RC_DIRECTION = "right"
		elseif (RC_LAST_MAP_X - 1) == CurrentMapX then
			RC_DIRECTION = "left"
		elseif (RC_LAST_MAP_Y + 1) == CurrentMapY then
			RC_DIRECTION = "bottom"
		elseif (RC_LAST_MAP_Y - 1) == CurrentMapY then
			RC_DIRECTION = "top"
		end
		if RC_DEBUG then
			global:printSuccess("Direction du déplacement: "..RC_DIRECTION)
		end

		-- Ecriture dans le fichier
		if RC_INCLUDE_CELLID then
		   	roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \""..RC_DIRECTION.."("..RC_LAST_CELL_ID..")\", done = false },\n}")
		else
		   	roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \""..RC_DIRECTION.."\", done = false },\n}")
		end

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.INTERACTIVE then

		if RC_DEBUG then
			global:printSuccess("Changement de map par l'utilisation d'un objet interactif.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", door = \""..RC_LAST_INTERACTIVE_CELLID.."\", done = false },\n}")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.WALK then

		if RC_DEBUG then
			global:printSuccess("Changement de map par le déplacement sur une cellule.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \""..RC_LAST_CELL_ID.."\", done = false },\n}")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.HAVENBAG then

		if RC_DEBUG then
			global:printSuccess("Changement de map par une téléportation au havre sac.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \"havenbag\", done = false },\n}")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAP then

		if RC_DEBUG then
			global:printSuccess("Changement de map par l'utilisation d'un zaap.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \"zaap("..map:currentMapId()..")\", done = false },\n}")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.ZAAPI then

		if RC_DEBUG then
			global:printSuccess("Changement de map par l'utilisation d'un zaapi.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", path = \"zaapi("..map:currentMapId()..")\", done = false },\n}")

	elseif RC_LAST_CHANGE_TYPE == RC_CHANGE_TYPE_ENUM.UNKNOWN then

		if RC_DEBUG then
			global:printSuccess("Changement de map par une autre méthode.")
		end

		-- Ecriture dans le fichier
	    roadFile:write("	"..comment.."{ map = \""..RC_LAST_MAP_ID.."\""..FIGHT_OPTION..GATHER_OPTION..RC_CUSTOM..", done = false },\n}")

	end

	-- Fermer le fichier
	roadFile:close()

	-- Reset
	RC_LAST_CHANGE_TYPE = RC_CHANGE_TYPE_ENUM.UNKNOWN
	RC_CUSTOM = "function() "

	-- Sauvegarder
	RC_LAST_MAP_X = CurrentMapX
	RC_LAST_MAP_Y = CurrentMapY
	RC_LAST_MAP_ID = CurrentMapID

	-- Cellule d'entrée à une nouvelle map
	RC_LAST_CELL_ID = map:currentCell()
	if RC_DEBUG then
		global:printSuccess("Votre cellule dans la nouvelle map est: "..RC_LAST_CELL_ID)
	end

	-- Combats et récoltes
	FIGHT_OPTION = ""
	GATHER_OPTION = ""
	if RC_ASK_FIGHT then
		FIGHT_OPTION = global:rcAskFight()
	end
	if RC_ASK_GATHER then
		GATHER_OPTION = global:rcAskGather()
	end
end