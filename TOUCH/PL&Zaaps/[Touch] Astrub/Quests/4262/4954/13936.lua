----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 145490434, 145489922, 145489921, 145489920, 145490432, 145490944, 145490945, 145490433 }
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