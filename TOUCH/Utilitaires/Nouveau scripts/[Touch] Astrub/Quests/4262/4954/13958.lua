----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 146276352, 145490435, 145490434, 145489922, 145489921, 145489920, 145490432, 145490944, 145490945, 145490433 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
	if not map:onMap(145490435) then
        if map:onMap(146276352) then
            npc:npc(3892, 3)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            npc:reply(-1)
            global:loadAndStart(MAIN_SCRIPT_PATH)
        else
            map:moveToward(145490435)
        end
    else
        map:door(318)
    end
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------