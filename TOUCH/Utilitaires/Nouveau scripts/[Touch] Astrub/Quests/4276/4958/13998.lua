----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
dofile(string.gsub(quest:mainPath(), "main.lua", "headers.lua"))
OBJECTIVE_MAPS = { 145752833, 146538496, 146539520, 146540544 }
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
function move()

	-- Vérifier si tout est bon
	check()

	-- Mes actions
    return {
        { map = "145752833", custom = func },
        { map = "146538496", forcefight = true },
        { map = "146539520", forcefight = true },
        { map = "146540544", forcefight = true },
    }
end
function func()
    npc:npc(3908, 3)
    npc:reply(-1)
end
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------