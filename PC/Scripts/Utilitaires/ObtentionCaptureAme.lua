

local trajet = {
    {map = "185861122", custom = function ()
        npc:npc(1404, 3)
        npc:reply(-2)
        npc:reply(-1)
    end},
    {map = "64749568", forceFight = true},
    {map = "64750592", forceFight = true},
    {map = "64751616", forceFight = true},
    {map = "64752640", forceFight = true},
    {map = "64753664", forceFight = true},
    {map = "64754688", custom = function ()
        npc:npc(5817, 3)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)

        npc:npc(1404, 3)
        npc:reply(-1)
    end}
}

function move()
    return treatMaps(trajet)

end
