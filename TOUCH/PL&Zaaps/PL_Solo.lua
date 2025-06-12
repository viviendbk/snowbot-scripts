dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")
dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

local ABonta = false
local Vide = false
local CouteauAchete = false

AUTO_DELETE = {792, 519, 385, 1736, 385, 383, 2414, 2416, 2425, 2428, 10967, 1900, 364, 1730, 15479, 1690, 407, 1734, 1975, 2422, 2419, 679}
AMOUNT_MONSTERS = {{47, 0, 2}}


local tableVente = {
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Blanc", Id = 881 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Noir", Id = 885 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Racine d'Abraknyde", Id = 435 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Résine végétale", Id = 1985 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Patte dArakne", Id = 365 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Bleue", Id = 362 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve", Id = 1898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Orange", Id = 363 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau", Id = 1927 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Ailes de Moskito", Id = 307 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Mesure de Poivre", Id = 1978 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir de Sanglier", Id = 486 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    --{Name = "Carré de Porc", Id = 1917 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Tatouage de Mauvais Garçon", Id = 13342 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true}, --début des 2 zones (piou et contour astrub)

    {Name = "Poils de souris", Id = 761 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Graine de Sésame", Id = 287 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Plume de Piou Bleu", Id = 6897 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Violet", Id = 6898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Vert", Id = 6899 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rouge", Id = 6900 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Jaune", Id = 6902 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rose", Id = 6903 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    
}

TrajetKanigrou ={
    { map = "-16,1", path = "zaap(147768)" },
    { map = "147768", path = "zaapi(146226)" },
    { map = "-29,-50", path = "bottom" },
    { map = "-29,-49", path = "bottom" },
    { map = "-29,-48", path = "bottom" },
    { map = "-29,-47", path = "bottom" },
    { map = "-29,-46", path = "bottom" },
    { map = "-29,-45", path = "left|right|bottom", fight = true },
    { map = "-30,-45", path = "left|right|bottom", fight = true },
    { map = "-31,-45", path = "left|right|bottom", fight = true },
    { map = "-32,-45", path = "right|bottom", fight = true },
    { map = "-32,-44", path = "top|right|bottom", fight = true },
    { map = "-32,-43", path = "top|right|bottom", fight = true },
    { map = "-32,-42", path = "top|right|bottom", fight = true },
    { map = "-32,-41", path = "top|right|bottom", fight = true },
    { map = "-32,-40", path = "top|right|bottom", fight = true },
    { map = "-32,-39", path = "top|right|bottom", fight = true },
   { map = "-32,-38", path = "top|right", fight = true },
   { map = "-31,-38", path = "top|left|right|bottom", fight = true },
   { map = "-31,-37", path = "top|right", fight = true },
   { map = "-30,-37", path = "top|left|right|bottom", fight = true },
   { map = "-30,-36", path = "top|right|bottom", fight = true },
   { map = "-30,-35", path = "top|right", fight = true },
   { map = "-29,-35", path = "top|left|right", fight = true },
   { map = "-28,-35", path = "top|left|right", fight = true },
   { map = "-27,-35", path = "top|left|right", fight = true },
   { map = "-26,-35", path = "top|left|right", fight = true },
   { map = "-25,-35", path = "top|left|right", fight = true },
   { map = "-24,-35", path = "top|left", fight = true },
   { map = "-24,-36", path = "top|left|right", fight = true },
   { map = "-23,-36", path = "top|left|right", fight = true },
   { map = "-22,-36", path = "top|left|right", fight = true },
   { map = "-21,-36", path = "top|left", fight = true },
   { map = "-21,-37", path = "left|bottom", fight = true },
   { map = "-22,-37", path = "top|left|right|bottom", fight = true },
   { map = "-22,-38", path = "top|left|bottom", fight = true },
   { map = "-22,-39", path = "top|left|bottom", fight = true },
   { map = "-22,-40", path = "left|bottom", fight = true },
   { map = "-23,-40", path = "left|right|bottom", fight = true },
   { map = "-24,-40", path = "top|left|right|bottom", fight = true },
   { map = "-24,-41", path = "left|bottom", fight = true },
   { map = "-25,-41", path = "top|left|right|bottom", fight = true },
   { map = "-25,-42", path = "left|bottom", fight = true },
   { map = "-26,-42", path = "top|left|right|bottom", fight = true },
   { map = "-26,-43", path = "top|left|bottom", fight = true },
   { map = "-26,-44", path = "top|left|bottom", fight = true },
   { map = "-26,-45", path = "left|bottom", fight = true },
   { map = "-28,-45", path = "left|right|bottom", fight = true },
   { map = "-27,-45", path = "left|right|bottom", fight = true },
   { map = "-31,-44", path = "top|left|right|bottom", fight = true },
   { map = "-30,-44", path = "top|left|right|bottom", fight = true },
   { map = "-29,-44", path = "top|left|right|bottom", fight = true },
   { map = "-28,-44", path = "top|left|right|bottom", fight = true },
   { map = "-27,-44", path = "top|left|right|bottom", fight = true },
   { map = "-27,-43", path = "top|left|right|bottom", fight = true },
   { map = "-28,-43", path = "top|left|right|bottom", fight = true },
   { map = "-29,-43", path = "top|left|right|bottom", fight = true },
   { map = "-31,-43", path = "top|left|right|bottom", fight = true },
   { map = "-30,-43", path = "top|left|right|bottom", fight = true },
   { map = "-31,-42", path = "top|left|right|bottom", fight = true },
   { map = "-30,-42", path = "top|left|right|bottom", fight = true },
   { map = "-29,-42", path = "top|left|right|bottom", fight = true },
   { map = "-28,-42", path = "top|left|right|bottom", fight = true },
   { map = "-27,-42", path = "top|left|right|bottom", fight = true },
   { map = "-27,-41", path = "top|left|right|bottom", fight = true },
   { map = "-26,-41", path = "top|left|right|bottom", fight = true },
   { map = "-29,-41", path = "top|left|right|bottom", fight = true },
   { map = "-28,-41", path = "top|left|right|bottom", fight = true },
   { map = "-30,-41", path = "top|left|right|bottom", fight = true },
   { map = "-31,-41", path = "top|left|right|bottom", fight = true },
   { map = "-31,-40", path = "top|left|right|bottom", fight = true },
   { map = "-30,-40", path = "top|left|right|bottom", fight = true },
   { map = "-29,-40", path = "top|left|right|bottom", fight = true },
   { map = "-27,-40", path = "top|left|right|bottom", fight = true },
   { map = "-28,-40", path = "top|left|right|bottom", fight = true },
   { map = "-26,-40", path = "top|left|right|bottom", fight = true },
   { map = "-25,-40", path = "top|left|right|bottom", fight = true },
   { map = "-24,-39", path = "top|left|right|bottom", fight = true },
   { map = "-23,-39", path = "top|left|right|bottom", fight = true },
   { map = "-23,-37", path = "top|left|right|bottom", fight = true },
   { map = "-23,-38", path = "top|left|right|bottom", fight = true },
   { map = "-24,-38", path = "top|left|right|bottom", fight = true },
   { map = "-24,-37", path = "top|left|right|bottom", fight = true },
   { map = "-26,-37", path = "top|left|right|bottom", fight = true },
   { map = "-25,-37", path = "top|left|right|bottom", fight = true },
   { map = "-25,-36", path = "top|left|right|bottom", fight = true },
   { map = "-26,-36", path = "top|left|right|bottom", fight = true },
   { map = "-28,-36", path = "top|left|right|bottom", fight = true },
   { map = "-27,-36", path = "top|left|right|bottom", fight = true },
   { map = "-29,-36", path = "top|left|right|bottom", fight = true },
   { map = "-29,-37", path = "top|left|right|bottom", fight = true },
   { map = "-28,-37", path = "top|left|right|bottom", fight = true },
   { map = "-27,-37", path = "top|left|right|bottom", fight = true },
   { map = "-27,-38", path = "top|left|right|bottom", fight = true },
   { map = "-28,-38", path = "top|left|right|bottom", fight = true },
   { map = "-30,-38", path = "top|left|right|bottom", fight = true },
   { map = "-31,-39", path = "top|left|right|bottom", fight = true },
   { map = "-30,-39", path = "top|left|right|bottom", fight = true },
   { map = "-29,-39", path = "top|left|right|bottom", fight = true },
   { map = "-29,-38", path = "top|left|right|bottom", fight = true },
   { map = "-28,-39", path = "top|left|right|bottom", fight = true },
   { map = "-27,-39", path = "top|left|right|bottom", fight = true },
   { map = "-26,-39", path = "top|left|right|bottom", fight = true },
   { map = "-26,-38", path = "top|left|right|bottom", fight = true },
   { map = "-25,-38", path = "top|left|right|bottom", fight = true },
   { map = "-25,-39", path = "top|left|right|bottom", fight = true },
    
}

local trajetBouftou = {
    { map = "10,22", path = "zaap(88082704)" },
    { map = "4,-19", path = "zaap(88082704)" },
    {map = "5,7", custom = function() map:useById(472656, -2) map:changeMap("bottom") end},
    {map = "5,8", path = "bottom|left", fight = true},
    {map = "4,8", path = "bottom|left", fight = true},
    {map = "3,8", path = "bottom|left", fight = true},
    {map = "2,8", path = "bottom|left", fight = true},
    {map = "7,10", path = "left", fight = true},
    {map = "6,10", path = "top|bottom|left|right", fight = true},
    {map = "4,10", path = "top|bottom|left|right", fight = true},
    {map = "5,10", path = "top|bottom|left|right", fight = true},
    {map = "3,10", path = "top|bottom|left|right", fight = true},
    {map = "2,10", path = "top|bottom|left|right", fight = true},
    {map = "2,12", path = "left", fight = true},
    {map = "1,12", path = "left", fight = true},
    {map = "0,12", path = "top|right", fight = true},
    {map = "0,11", path = "top|right", fight = true},
    {map = "0,10", path = "top|right", fight = true},
    {map = "0,9", path = "top|right", fight = true},
    {map = "0,8", path = "top|right", fight = true},
    {map = "0,7", path = "right", fight = true},
    {map = "1,7", path = "bottom"},
    {map = "1,8", path = "bottom", fight = true},
    {map = "1,10", path = "top|bottom|left|right", fight = true},
    {map = "1,11", path = "top|bottom|left|right", fight = true},
    {map = "2,9", path = "top|bottom|left|right", fight = true},
    {map = "3,9", path = "top|bottom|left|right", fight = true},
    {map = "4,9", path = "top|bottom|left|right", fight = true},
    {map = "5,9", path = "top|bottom|left|right", fight = true},
    {map = "6,9", path = "top|bottom|left|right", fight = true},
    {map = "7,9", path = "bottom"},
    {map = "2,11", path = "top|bottom|left|right", fight = true},
    {map = "3,11", path = "top|bottom|left|right", fight = true},
    {map = "4,11", path = "top|bottom|left|right", fight = true},
    {map = "5,11", path = "top|bottom|left|right", fight = true},
    {map = "6,11", path = "top|bottom|left|right", fight = true},
    {map = "7,11", path = "bottom", fight = true},
    {map = "7,12", path = "left"},
    {map = "6,12", path = "left"},
    {map = "5,12", path = "left"},
    {map = "4,12", path = "left"},
    {map = "3,12", path = "left"},
    {map = "6,8", path = "bottom|left", fight = true},
    {map = "1,9", path = "top|bottom|left|right", fight = true},
}

local trajetForetAmakna = {

    { map = "4,-19", path = "zaap(88085249)" },
    { map = "5,7", path = "zaap(88085249)" },
    { map = "10,22", custom = function() map:useById(472658, -2) map:changeMap("top") end},
	{ map = "10,21", path = "top|left", fight = true },
	{ map = "9,21", path = "top|right", fight = true },
	{ map = "10,20", path = "left|bottom", fight = true },
	{ map = "9,20", path = "top|left|right|bottom", fight = true },
	{ map = "9,19", path = "top|left|right|bottom", fight = true },
	{ map = "9,18", path = "bottom", fight = true },
	{ map = "8,19", path = "top|left|right|bottom", fight = true },
	{ map = "8,18", path = "left|bottom", fight = true },
	{ map = "7,18", path = "top|left|right|bottom", fight = true },
	{ map = "7,17", path = "top|left|bottom", fight = true },
	{ map = "7,16", path = "top|left|bottom", fight = true },
	{ map = "7,15", path = "top|left|bottom", fight = true },
	{ map = "7,14", path = "top|left|right|bottom", fight = true },
	{ map = "8,14", path = "top|left", fight = true },
	{ map = "8,13", path = "top|left|right|bottom", fight = true },
	{ map = "9,13", path = "top|left", fight = true },
	{ map = "9,12", path = "left|right|bottom", fight = true },
	{ map = "10,12", path = "left|right", fight = true },
	{ map = "11,12", path = "left|right|bottom", fight = true },
	{ map = "11,13", path = "top", fight = true },
	{ map = "12,12", path = "left", fight = true },
	{ map = "3,12", path = "right|bottom", fight = true },
	{ map = "8,12", path = "left|right|bottom", fight = true },
	{ map = "7,12", path = "left|right|bottom", fight = true },
	{ map = "6,12", path = "left|right|bottom", fight = true },
	{ map = "4,12", path = "left|right|bottom", fight = true },
	{ map = "5,12", path = "left|right|bottom", fight = true },
	{ map = "3,13", path = "top|right|bottom", fight = true },
	{ map = "4,13", path = "top|left|right|bottom", fight = true },
	{ map = "5,13", path = "top|left|right|bottom", fight = true },
	{ map = "6,13", path = "top|left|right|bottom", fight = true },
	{ map = "7,13", path = "top|left|right|bottom", fight = true },
	{ map = "6,14", path = "top|left|right|bottom", fight = true },
	{ map = "5,14", path = "top|left|right|bottom", fight = true },
	{ map = "4,14", path = "top|left|right|bottom", fight = true },
	{ map = "3,14", path = "top|right|bottom", fight = true },
	{ map = "3,15", path = "top|right|bottom", fight = true },
	{ map = "4,15", path = "top|left|right", fight = true },
	{ map = "5,15", path = "top|left|right|bottom", fight = true },
	{ map = "6,15", path = "top|left|right|bottom", fight = true },
	{ map = "6,16", path = "top|left|right|bottom", fight = true },
	{ map = "5,16", path = "top|right|bottom", fight = true },
	{ map = "5,17", path = "top|left|right|bottom", fight = true },
	{ map = "6,17", path = "top|left|right|bottom", fight = true },
	{ map = "6,18", path = "top|left|right|bottom", fight = true },
	{ map = "5,18", path = "top|left|right|bottom", fight = true },
	{ map = "4,18", path = "top|left|right|bottom", fight = true },
	{ map = "4,17", path = "top|left|right|bottom", fight = true },
	{ map = "4,16", path = "bottom", fight = true },
	{ map = "3,17", path = "top|right|bottom", fight = true },
	{ map = "3,16", path = "top|bottom", fight = true },
	{ map = "3,18", path = "top|right|bottom", fight = true },
	{ map = "3,19", path = "top|right|bottom", fight = true },
	{ map = "3,21", path = "top|right", fight = true },
	{ map = "3,20", path = "top|bottom", fight = true },
	{ map = "4,21", path = "top|left|right", fight = true },
	{ map = "5,21", path = "top|left|right", fight = true },
	{ map = "6,21", path = "top|left|right", fight = true },
	{ map = "7,21", path = "top|left", fight = true },
	{ map = "7,20", path = "top|left|right|bottom", fight = true },
	{ map = "8,20", path = "top|left|right", fight = true },
	{ map = "7,19", path = "top|left|right|bottom", fight = true },
	{ map = "6,19", path = "top|left|right|bottom", fight = true },
	{ map = "5,19", path = "top|left|right|bottom", fight = true },
	{ map = "4,19", path = "top|left|right|bottom", fight = true },
	{ map = "4,20", path = "top|right", fight = true },
	{ map = "5,20", path = "top|left|right|bottom", fight = true },
	{ map = "6,20", path = "top|left|right|bottom", fight = true },

}

local trajetDragodindes = {

    { map = "4,-19", path = "zaap(73400320)" },
    { map = "10,22", path = "zaap(73400320)" },

    { map = "-16,1", custom = function() map:useById(461166, -2) map:changeMap("top") end},
    { map = "-16,0", path = "top" },
    { map = "-16,-1", path = "top" },
    { map = "-16,-2", path = "left|right", fight = true },
    { map = "-15,-2", path = "left|right", fight = true },
    { map = "-14,-2", path = "left|right", fight = true },
    { map = "-13,-2", path = "left|right", fight = true },
    { map = "-12,-2", path = "left|right|bottom", fight = true },
    { map = "-11,-2", path = "left|bottom", fight = true },
    { map = "-11,-1", path = "top|left|bottom", fight = true },
    { map = "-12,-1", path = "top|bottom", fight = true },
    { map = "-11,0", path = "top|bottom", fight = true },
    { map = "-12,0", path = "top|bottom", fight = true },
    { map = "-12,1", path = "top|right|bottom", fight = true },
    { map = "-11,1", path = "top|left", fight = true },
    { map = "-12,2", path = "top|bottom", fight = true },
    { map = "-12,3", path = "top|bottom", fight = true },
    { map = "-12,4", path = "top|bottom", fight = true },
    { map = "-12,5", path = "top|bottom", fight = true },
    { map = "-12,6", path = "top|left|bottom", fight = true },
    { map = "-12,8", path = "top", fight = true },
    { map = "-14,6", path = "left|right|bottom", fight = true },
    { map = "-14,7", path = "top|left|right", fight = true },
    { map = "-15,7", path = "top|left|right", fight = true },
    { map = "-15,6", path = "left|right|bottom", fight = true },
    { map = "-16,6", path = "left|right|bottom", fight = true },
    { map = "-16,7", path = "top|left|right", fight = true },
    { map = "-17,7", path = "top|left|right", fight = true },
    { map = "-17,6", path = "left|right|bottom", fight = true },
    { map = "-18,6", path = "left|right|bottom", fight = true },
    { map = "-18,7", path = "top|left|right", fight = true },
    { map = "-19,6", path = "top|right|bottom", fight = true },
    { map = "-19,7", path = "top|right|bottom", fight = true },
    { map = "-19,8", path = "top|left|right", fight = true },
    { map = "-18,8", path = "left", fight = true },
    { map = "-20,8", path = "top|left|right|bottom", fight = true },
    { map = "-20,9", path = "top|left", fight = true },
    { map = "-21,9", path = "top|right", fight = true },
    { map = "-21,8", path = "top|right|bottom", fight = true },
    { map = "-21,7", path = "top|left|right|bottom", fight = true },
    { map = "-22,7", path = "top|right", fight = true },
    { map = "-22,6", path = "top|right|bottom", fight = true },
    { map = "-22,5", path = "top|right|bottom", fight = true },
    { map = "-22,4", path = "top|right|bottom", fight = true },
    { map = "-22,3", path = "top|left|right|bottom", fight = true },
    { map = "-23,3", path = "top|right", fight = true },
    { map = "-23,2", path = "top|right|bottom", fight = true },
    { map = "-23,1", path = "right|bottom", fight = true },
    { map = "-22,1", path = "top|left|right|bottom", fight = true },
    { map = "-22,0", path = "top|right|bottom", fight = true },
    { map = "-22,-1", path = "top|right|bottom", fight = true },
    { map = "-22,-2", path = "right|bottom", fight = true },
    { map = "-21,-2", path = "left|right|bottom", fight = true },
    { map = "-20,-2", path = "left|right|bottom", fight = true },
    { map = "-19,-2", path = "left|right|bottom", fight = true },
    { map = "-19,-1", path = "top|left|bottom", fight = true },
    { map = "-18,-2", path = "left|right", fight = true },
    { map = "-17,-2", path = "left|right", fight = true },
    { map = "-19,1", path = "top|left|bottom", fight = true },
    { map = "-19,0", path = "top|bottom", fight = true },
    { map = "-19,3", path = "top|left|bottom", fight = true },
    { map = "-19,2", path = "top|left|bottom", fight = true },
    { map = "-19,4", path = "top|left|bottom", fight = true },
    { map = "-19,5", path = "top|left|bottom", fight = true },
    { map = "-20,5", path = "top|left|right|bottom", fight = true },
    { map = "-20,6", path = "top|left|bottom", fight = true },
    { map = "-20,7", path = "top|left|bottom", fight = true },
    { map = "-21,6", path = "top|left|right|bottom", fight = true },
    { map = "-21,5", path = "top|left|right|bottom", fight = true },
    { map = "-21,4", path = "top|left|right|bottom", fight = true },
    { map = "-20,4", path = "top|left|right|bottom", fight = true },
    { map = "-20,3", path = "top|left|right|bottom", fight = true },
    { map = "-21,3", path = "top|left|right|bottom", fight = true },
    { map = "-21,2", path = "top|left|right|bottom", fight = true },
    { map = "-20,2", path = "top|left|right|bottom", fight = true },
    { map = "-20,1", path = "top|left|right|bottom", fight = true },
    { map = "-20,0", path = "top|left|bottom", fight = true },
    { map = "-20,-1", path = "top|right|bottom", fight = true },
    { map = "-21,-1", path = "top|bottom", fight = true },
    { map = "-21,0", path = "top|left|right|bottom", fight = true },
    { map = "-21,1", path = "top|left|right|bottom", fight = true },
    { map = "-22,2", path = "top|left|right|bottom", fight = true },
    { map = "-13,6", path = "left|right|bottom", fight = true },
    { map = "-13,7", path = "top|left|right", fight = true },
    { map = "-12,7", path = "top|left|bottom", fight = true },

}

---Fonction qui permet de recuperer les nombres de lots d'un item en HDV.
local function get_quantity(id)
    if object_in_hdv then
        local informations = {
            id = id,
            quantity = {
                ["1"] = 0,
                ["10"] = 0,
                ["100"] = 0
            },
            total_quantity = 0,
            total_lots = 0,
        }

        for _, info in ipairs(object_in_hdv) do
            if info.id == id then
                informations.quantity["1"] = info.quantity["1"]
                informations.quantity["10"] = info.quantity["10"]
                informations.quantity["100"] = info.quantity["100"]
                informations.total_quantity = info.quantity["1"] * 1 + info.quantity["10"] * 10 + info.quantity["100"] * 100
                informations.total_lots = info.quantity["1"] + info.quantity["10"] + info.quantity["100"]
            end
        end

        return informations
    else
        global:printError("[INFO] - l'HDV n'a pas été scanné je ne peux donc pas resortir les quantités demandées.")
    end
end

---Fonction qui permet de scanner l'hotel de vente.
local function stack_items_informations(message)
    message = developer:toObject(message)
    object_in_hdv = {}
    may_add_id = true

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                may_add_id = false

                break
            end
        end

        if may_add_id then
            table.insert(object_in_hdv,{ id = item.objectGID, quantity = {["1"] = 0, ["10"] = 0, ["100"] = 0}})
        end

        may_add_id = true
    end

    for _, item in pairs(message.objectsInfos) do
        for _, info in ipairs(object_in_hdv) do
            if info.id == item.objectGID then
                info.quantity[tostring(item.quantity)] = info.quantity[tostring(item.quantity)] + 1
            end
        end
    end
end


function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
end

function ProcessSell()
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

    global:delay(1000)

    table.sort(tableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(tableVente) do
        global:printSuccess(_ .. "ème item à vendre...")
        if inventory:itemCount(element.Id) < 10 then global:printSuccess("on a plus rien à vendre") break end

        local Prices = GetPricesItem(element.Id)

        AveragePrice = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and (Prices.Price10 / 10)
                        or (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and (Prices.Price100 / 100)


        cpt = get_quantity(element.Id).quantity["100"]
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
			Prices.Price100 = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and (AveragePrice * 100) or Prices.Price100
            if character:kamas() < Prices.Price100 * 0.04 then
                global:editAlias(global:thisAccountController():getAlias() .. "[PLUS DE KAMAS]", true)
                global:reconnect(3)
            end
            sale:SellItem(element.Id, 100, Prices.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Prices.Price100 - 1 .. "kamas")
            cpt = cpt + 1
        end
        
        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Prices.Price10 = (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and (AveragePrice * 10) or Prices.Price10
            if character:kamas() < Prices.Price10 * 0.04 then
                global:editAlias(global:thisAccountController():getAlias() .. "[PLUS DE KAMAS]", true)
                global:reconnect(3)
            end
            sale:SellItem(element.Id, 10, Prices.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Prices.Price10 - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    global:leaveDialog()
end


local function treatMaps(maps)

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end

    PopoRappel()
end

string.split = function(self, sep, rawSep)
    local insert, result = table.insert, {}
    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end

    local rawSep = rawSep and sep or "([^" .. sep .. "]+)"

    for match in self:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

function antiModo()
    if global:isModeratorPresent(30) then
        timerdisconnect = math.random(30000, 36000) 

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

        local Alias = global:thisAccountController():getAlias():split(" ")

        if not global:thisAccountController():getAlias():find("bank") then
            if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
                global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level() .. " [MODO]", true)
            else
                global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level() .. " [MODO]", true)
            end
        end

        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global:reconnectBis((timerdisconnect + 10) / 1000)
            end
            global:reconnectBis(timerdisconnect / 1000)
        elseif not global:thisAccountController():isItATeam() then
            global:reconnectBis(timerdisconnect / 1000)
        end
    end
end

function EditAlias()
    local Alias = global:thisAccountController():getAlias():split(" ")
    if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
        global:editAlias("Team 1 " .. character:serverName() .. ", lvl " .. character:level(), true)
    else
        global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", lvl " .. character:level(), true)
    end
end

--0 a 10 = 128 crafts 2 cases
function move()
    antiModo()
    if global:maximumNumberFightsOfDay() then
        global:reconnect(math.random(2, 3)) -- Je me deconnecte
    end
    if not global:thisAccountController():getAlias():find("bank") then
        EditAlias()
    end
    if character:bonusPackExpiration() <= 0 then
        character:getBonusPack(1)
        global:reconnect(0)
    end

    if not global:thisAccountController():isItATeam() and not mount:hasMount() and character:level() > 69 and character:kamas() > 30000 and not global:thisAccountController():getAlias():find("bank") then
        inventory:openBank()
        global:delay(500) 
        if exchange:storageKamas() > 0 then
            global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:printError("Il n'y a pas de kamas en banque")
            global:delay(500)
        end
        ProcessSell()
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Achat_DD.lua")
    end

    if global:thisAccountController():isItATeam() and global:isBoss() then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Team.lua")
    end

    if global:thisAccountController():getAlias():find("bank") and character:level() > 80 or not global:thisAccountController():getAlias():find("bank") and character:level() > 69 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PL&Zaaps\\PL_Team.lua")
    end

    if (global:thisAccountController():getAlias():find("bank") and character:level() < 81) or character:level() < 70 then
        MAX_MONSTERS = character:level() < 55 and 3 or 4
        MIN_MONSTERS = character:level() < 48 and 1 or 2
        return treatMaps(trajetBouftou)
    end
end
    

function bank()
    if not global:thisAccountController():getAlias():find("bank") then
        EditAlias()
    end
    inventory:openBank()
    global:delay(500) 
    if exchange:storageKamas() > 0 then
        global:printSuccess("Il y a " .. exchange:storageKamas() .. " kamas en banque, on les prend")
        exchange:getKamas(0)
        global:delay(500)
    elseif exchange:storageKamas() == 0 then
        global:printError("Il n'y a pas de kamas en banque")
        global:delay(500)
    end
    ProcessSell()
    return move()
end


function phenix()
    return {
        {map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() map:door(184) PopoRappel() end},
    }
end

function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end