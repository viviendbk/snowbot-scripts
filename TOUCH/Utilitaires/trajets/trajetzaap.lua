-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {}

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {}
FORCE_MONSTERS = {}

function hiboux()
	npc:npc(522,3)
	npc:reply(-1)
	exchange:putAllItems()
	global:leaveDialog()
end


function move()
	return {
		{map = "192415750", path = "409"}, --Interieur banque Astrub vers Sortie--
		{map = "54534165", path = "424"}, --Interieur banque Frigost vers Sortie--
		{map = "2885641", path = "424"}, --Interieur banque Bonta vers Sortie--
		{map = "99095051", path = "410"}, --Interieur banque Amakna vers Sortie--
		{map = "8912911", path = "424"}, --Interieur banque Brakmar vers Sortie--
		{map = "91753985", path = "396"}, --Interieur banque Sufokia vers Sortie--
		{map = "86511105", door = "452"}, --Interieur banque Ottomaï vers Sortie--
		{map = "8129542", path = "409"}, --Interieur banque Pandala vers Sortie--
		{map = "84935175", path = "425"}, --Interieur banque Montagne Koalak vers Sortie--
		{map = "1,-14", path = "top"},
		{map = "1,-15", path = "right"},
		{map = "2,-15", path = "right"},
		{map = "3,-15", path = "top"},
		{map = "3,-16", path = "top"},
		{map = "3,-17", path = "top"},
		{map = "3,-18", path = "top"},
		{map = "17,-17", path = "right"},
		{map = "3,-19", path = "right"},
		{map = "4,-19", path = "bottom"},
		{map = "4,-18", path = "bottom"},
		{map = "4,-17", path = "bottom"},
		{map = "4,-16", path = "bottom"},
		{map = "4,-14", path = "bottom"},
		{map = "4,-15", path = "bottom"},
		{map = "4,-13", path = "bottom"},
		{map = "4,-12", path = "bottom"},
		{map = "4,-11", path = "bottom"},
		{map = "4,-10", path = "bottom"},
		{map = "4,-9", path = "left"},
		{map = "3,-9", path = "bottom"},
		{map = "3,-8", path = "left"},
		{map = "2,-8", path = "left"},
		{map = "1,-7", path = "bottom"},
		{map = "1,-6", path = "bottom"},
		{map = "1,-5", path = "bottom"},
		{map = "1,-4", path = "bottom"},
		{map = "1,-3", path = "bottom"},
		{map = "1,-2", path = "bottom"},
		{map = "1,-1", path = "bottom"},
		{map = "1,0", path = "bottom"},
		{map = "0,0", path = "left"},
		{map = "-1,0", path = "left"},
		{map = "-2,0", path = "bottom"},
		{map = "-2,1", path = "right"},
		{map = "-1,1", path = "right"},
		{map = "0,1", path = "right"},
		{map = "1,1", path = "right"},
		{map = "2,1", path = "right"},
		{map = "3,1", path = "right"},
		{map = "4,1", path = "right"},
		{map = "5,1", path = "bottom"},
		{map = "5,2", path = "bottom"},
		{map = "5,3", path = "bottom"},
		{map = "5,4", path = "bottom"},
		{map = "5,5", path = "bottom"},
		{map = "5,6", path = "bottom"},
		{map = "5,7", path = "bottom"},
		{map = "5,8", path = "bottom"},
		{map = "5,9", path = "bottom"},
		{map = "5,10", path = "bottom"},
		{map = "5,11", path = "bottom"},
		{map = "5,12", path = "bottom"},
		{map = "5,13", path = "left"},
		{map = "4,13", path = "left"},
		{map = "3,13", path = "left"},
		{map = "1,13", path = "left"},
		{map = "2,13", path = "left"},
		{map = "0,13", path = "left"},
		{map = "-1,13", path = "bottom"},
		{map = "-1,14", path = "right"},
		{map = "0,14", path = "right"},
		{map = "1,14", path = "right"},
		{map = "2,14", path = "bottom"},
		{map = "2,15", path = "bottom"},
		{map = "2,16", path = "bottom"},
		{map = "2,17", path = "bottom"},
		{map = "2,18", path = "bottom"},
		{map = "2,19", path = "bottom"},
		{map = "2,20", path = "bottom"},
		{map = "2,21", path = "bottom"},
		{map = "2,23", path = "bottom"},
		{map = "2,22", path = "bottom"},
		{map = "2,24", path = "left"},
		{map = "1,24", path = "left"},
		{map = "0,24", path = "left"},
		{map = "-1,-14", path = "right"},
		{map = "0,-14", path = "right"},
	}
end

function bank()
	return {
		{map = "191104002", door = "288"}, --Devant banque Astrub--
		{map = "192415750", path = "409", custom = hiboux}, --Banque Astrub--
		{map = "54172457", door = "358"}, --Devant banque Frigost--
		{map = "54534165", path = "424", npcBank = true}, --Banque Frigost--
		{map = "147254", door = "383"}, --Devant banque Bonta--
		{map = "2885641", path = "424", npcBank = true}, --Banque Bonta--
		{map = "88081177", door = "216"}, --Devant banque Amakna--
		{map = "99095051", path = "410", npcBank = true}, --Banque Amakna--
		{map = "144931", door = "248"}, --Devant banque Brakmar--
		{map = "8912911", path = "424", npcBank = true}, --Banque Brakmar--
		{map = "90703872", door = "302"}, --Devant banque Sufokia --
		{map = "91753985", path = "494", npcBank = true}, --Banque Sufokia--
		{map = "155157", door = "355"}, --Devant banque Ottomaï--
		{map = "86511105", door = "452", npcBank = true}, --Banque Ottomaï--
		{map = "12580", door = "284"}, --Devant banque Pandala--
		{map = "8129542", path = "409", npcBank = true}, --Banque Pandala--
		{map = "73400323", door = "330"}, --Devant banque Montagne Koalak--
		{map = "84935175", path = "425", npcBank = true}, --Banque Montagne Koalak--
	}
end


function phenix()
	return {
	}
end
