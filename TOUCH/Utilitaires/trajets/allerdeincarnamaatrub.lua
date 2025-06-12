
GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}



function move()
	return {

		{map = "-5,-1", path = "bottom"},
		{map = "-4,0", path = "right"},
		{map = "-3,1", path = "right"},
		{map = "-2,2", path = "bottom"},
		{map = "0,3", path = "right"},
		{map = "1,3", path = "right"},
		{map = "2,3", path = "right"},
		{map = "3,3", path = "right"},
		{map = "4,3", path = "right"},
		{map = "6,3", path = "right"},
		{map = "5,3", path = "right"},
		{map = "7,3", path = "right"},
		{map = "8,3", path = "right"},
        {map = "9,3", lockedCustom = AllerAstrub},

	}
end

function AllerAstrub()
    npc:npc(888, 3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)

end