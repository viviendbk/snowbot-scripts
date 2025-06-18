dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")
dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\All_Fonctions.lua")

DEVELOPER_MULTI_THREADING = true
ABonta = false
Vide = false
CouteauAchete = false

AUTO_DELETE = {792, 519, 385, 1736, 385, 383, 2414, 2416, 2425, 2428, 10967, 1900, 364, 15479, 1690, 407, 1734, 2551, 2598, 2599, 426, 398, 679, 2419, 2422, 1975, 1771, 1977, 9472}
AMOUNT_MONSTERS = {{47, 0, 2}}


if not global:remember("JOB_LEVEL_MINI") then
    global:addInMemory("JOB_LEVEL_MINI", false)
end

if not global:remember("bank()") then
    global:addInMemory("bank()", false)
end

function PNJFrigost ()
    npc:npc(1236, 3)
    npc:reply(-1)
end

function PNJFrigost2 ()
    npc:npc(1236, 3)
    npc:npc(1264, 3)
    npc:reply(-1)
    map:changeMap("right")
end

local function savezaap ()
    map:useById(456126, -2)
    map:changeMap("top|left|right|bottom")
end

tableCraft = {
    {Name = "Chair d'Insecte Conservée", Id = 1993, Level = 10, ViandeId = 1915, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1983, Nb = 1},
        {Id = 1986, Nb = 1},
    }},
    {Name = "Cuisse de Bouftou Conservée", Id = 1995, Level = 10, ViandeId = 1911, MaxHdv100 = 3, MaxHdv10 = 20, ListIdCraft = {
        {Id = 1983, Nb = 1},
        {Id = 1986, Nb = 1},
    }},
    {Name = "Cuisse de Bouftou Conservée **", Id = 1997, Level = 10, ViandeId = 1912, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1983, Nb = 2},
        {Id = 1986, Nb = 1},
    }},
    {Name = "Carré de Porc Conservé", Id = 2004, Level = 30, ViandeId = 1917, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1984, Nb = 1},
        {Id = 1983, Nb = 2},
        {Id = 1986, Nb = 1},
    }},
    {Name = "Dragoviande Conservée", Id = 2014, Level = 30, ViandeId = 1922, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1986, Nb = 1},
        {Id = 2012, Nb = 2},
        {Id = 1984, Nb = 2},
        {Id = 1985, Nb = 1},
    }},

    {Name = "Viande de Kanigrou Conservée", Id = 8501, Level = 30, ViandeId = 8498, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1983, Nb = 2},
        {Id = 1984, Nb = 1},
        {Id = 1985, Nb = 1},
        {Id = 1986 , Nb = 1},
        {Id = 1730 , Nb = 1},
    }},

    {Name = "Dragoviande Conservée **", Id = 2015, Level = 30, ViandeId = 1923, MaxHdv100 = 3, MaxHdv10 = 15, ListIdCraft = {
        {Id = 1986, Nb = 1},
        {Id = 2012, Nb = 2},
        {Id = 1984, Nb = 2},
        {Id = 1985, Nb = 1},
    }},
}

TableVente = {
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Blanc", Id = 881 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Noir", Id = 885 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Racine d'Abraknyde", Id = 435 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Gland", Id = 393 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},

    {Name = "Résine végétale", Id = 1985 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Patte dArakne", Id = 365 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Bleue", Id = 362 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve", Id = 1898 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve**", Id = 1899 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
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

    {Name = "Fibre de Lin", Id = 424 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Duvet de Bourdard", Id = 1891 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair d'Insecte **", Id = 1916 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Grand Parchemin de Force", Id = 18328 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 15, CanSell = true},
    

    {Name = "Dent de Dragodinde", Id = 2179 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "Aile de Dragodinde Dorée", Id = 13488 , MaxHdv100 = 5, MaxHdv10 = 15, MaxHdv1 = 0, CanSell = true},
    {Name = "DragoViande", Id = 1922 , MaxHdv100 = 0, MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},
    {Name = "DragoViande **", Id = 1923 , MaxHdv100 = 0 , MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau **", Id = 1929 , MaxHdv100 = 3, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Viande de Kanigrou", Id = 8498 , MaxHdv100 = 0, MaxHdv10 = 5, MaxHdv1 = 0, CanSell = true},

}

trajetChasseur = {
    { map = "1,-21", path = "right" },
    { map = "2,-21", path = "right" },
    { map = "3,-21", path = "right" },
    { map = "4,-21", path = "bottom" },
    { map = "4,-20", path = "bottom" },
    { map = "4,-19", path = "bottom" },
    { map = "4,-18", path = "bottom" },
    { map = "4,-17", path = "bottom" },
    { map = "4,-16", path = "bottom" },
    { map = "4,-15", path = "bottom(555)" },
    { map = "4,-14", path = "bottom" },
    { map = "4,-13", path = "bottom" },
    { map = "4,-12", path = "bottom" },
    { map = "4,-11", path = "bottom" },
    { map = "4,-10", path = "left" },
    { map = "3,-10", path = "left" },
    { map = "2,-10", path = "bottom" },
    { map = "2,-9", path = "bottom" },
    { map = "2,-8", path = "left" },
    { map = "1,-8", path = "bottom(444)" },
    { map = "1,-7", path = "bottom" },
    { map = "1,-6", path = "bottom" },
    { map = "1,-5", path = "bottom" },
    { map = "1,-4", path = "bottom" },
    { map = "1,-3", path = "bottom" },
    { map = "1,-2", path = "left" },
    { map = "0,-2", path = "left" },
    { map = "-1,-2", path = "left" },
    { map = "-2,-2", path = "bottom" },
    { map = "-2,-1", path = "bottom" },
    { map = "-2,0", path = "right" },
    { map = "-1,0", path = "bottom" },
    { map = "-1,1", path = "bottom" },
    { map = "-1,2", path = "bottom" },
    { map = "-1,3", path = "bottom" },
    { map = "1,17", path = "bottom" },
    { map = "1,16", path = "bottom" },
    { map = "1,15", path = "bottom" },
    { map = "1,14", path = "bottom" },
    { map = "1,13", path = "bottom" },
    { map = "1,12", path = "bottom" },
    { map = "1,11", path = "bottom" },
    { map = "1,10", path = "bottom" },
    { map = "1,9", path = "bottom" },
    { map = "1,8", path = "bottom" },
    { map = "1,7", path = "bottom" },
    { map = "1,6", path = "bottom" },
    { map = "1,5", path = "bottom" },
    { map = "-1,4", path = "right" },
    { map = "0,4", path = "right" },
    { map = "1,4", path = "bottom" },


}

TrajetAtelierBonta ={
    { map = "150328", path = "right" },
    { map = "-32,-56", path = "zaapi(147764)" },
    { map = "149816", path = "zaapi(147764)" },
    { map = "5506048", path = "zaapi(147764)" },
    { map = "147764", door = "318" },
    { map = "4719111", door = "338" },
}

TrajetKanigrou ={
    { map = "4,-19", path = "zaap(147768)" },
    { map = "-16,1", path = "zaap(147768)" },
    { map = "-1,24", path = "zaap(147768)"}, --scarafeuille
    { map = "-1,13", path = "zaap(147768)"}, --marecage
    { map = "35,12", path = "zaap(147768)"}, -- moon
    { map = "-5,-23", path = "zaap(147768)"}, -- champa
    { map = "-23,-19", path = "zaap(147768)"}, --mont neselite 
    { map = "147768", lockedCustom = function() map:useById(260872, -2) map:changeMap("zaapi(146226)") end },    
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

TrajetBouftou = {
    { map = "4,-19", path = "zaap(88082704)" },
    { map = "-1,24", path = "zaap(88082704)"}, --scarafeuille
    { map = "-1,13", path = "zaap(88082704)"}, --marecage
    { map = "35,12", path = "zaap(88082704)"}, -- moon
    { map = "-5,-23", path = "zaap(88082704)"}, -- champa
    { map = "-23,-19", path = "zaap(88082704)"}, --mont neselite 
    {map = "-32,-56", path = "zaap(88082704)"}, --bonta
    {map = "5,7", lockedCustom = function() map:useById(472656, -2) map:changeMap("bottom") end},
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

TrajetForetAmakna = {

    { map = "4,-19", path = "zaap(88085249)" },
    { map = "5,7", path = "zaap(88085249)" },
    {map = "-16,1", path = "zaap(88085249)"}, -- montagne des koalaks
    { map = "-1,24", path = "zaap(88085249)"}, --scarafeuille
    { map = "-1,13", path = "zaap(88085249)"}, --marecage
    { map = "35,12", path = "zaap(88085249)"}, -- moon
    { map = "-5,-23", path = "zaap(88085249)"}, -- champa
    { map = "-23,-19", path = "zaap(88085249)"}, --mont neselite 
    {map = "-32,-56", path = "zaap(88085249)"}, --bonta

    { map = "10,22", lockedCustom = function() map:useById(472658, -2) map:changeMap("top") end},
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

TrajetDragodindes = {

    { map = "4,-19", path = "zaap(73400320)" },
    { map = "10,22", path = "zaap(73400320)" },
    { map = "-1,24", path = "zaap(73400320)"}, --scarafeuille
    { map = "-1,13", path = "zaap(73400320)"}, --marecage
    { map = "35,12", path = "zaap(73400320)"}, -- moon
    { map = "-5,-23", path = "zaap(73400320)"}, -- champa
    { map = "-23,-19", path = "zaap(73400320)"}, --mont neselite 
    {map = "-32,-56", path = "zaap(73400320)"}, --bonta

    { map = "-16,1", lockedCustom = function() map:useById(461166, -2) map:changeMap("top") end},
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

trajetFrigost = {
    
    { map = "-32,-56", path = "zaap(141588)" },
    { map = "-20,-20", path = "bottom" },
    { map = "-20,-19", path = "bottom" },
    { map = "-20,-18", path = "bottom" },
    { map = "-20,-17", path = "bottom" },
    { map = "-20,-16", path = "bottom" },
    { map = "-20,-15", path = "bottom" },
    { map = "-29,-14", path = "left" },
    { map = "-28,-14", path = "left" },
    { map = "-27,-14", path = "left" },
    { map = "-26,-14", path = "left" },
    { map = "-25,-14", path = "left" },
    { map = "-24,-14", path = "left" },
    { map = "-23,-14", path = "left" },
    { map = "-22,-14", path = "left" },
    { map = "-20,-14", path = "left" },
    { map = "-21,-14", path = "left" },
    { map = "-30,-14", path = "left" },
    { map = "-31,-14", path = "left" },
    { map = "-32,-14", path = "left" },
    { map = "-33,-14", path = "top" },
    { map = "-33,-15", path = "left" },

    { map = "148752", custom = PNJFrigost },
    { map = "56623104", custom = PNJFrigost },
    { map = "56624128", custom = PNJFrigost },
    { map = "56625152", custom = PNJFrigost },
    { map = "54175012", custom = PNJFrigost2 },--si ca bug ajouter cette ligne avec l'id de map sur laquel ca a bug
    { map = "-80,-38", path = "top" },
    { map = "-80,-39", path = "right" },
    { map = "-79,-39", path = "top" },
    { map = "-79,-40", path = "top" },
    { map = "-79,-41", path = "right" },
    { map = "54172969", custom = savezaap },
    { map = "-78,-40", path = "top|right", fight = true },
    { map = "-77,-40", path = "top|left|right|bottom", fight = true },
    { map = "-77,-39", path = "top|right", fight = true },
    { map = "-76,-39", path = "top|left|right|bottom", fight = true },
    { map = "-76,-38", path = "top|right", fight = true },
    { map = "-75,-38", path = "top|left|right|bottom", fight = true },
    { map = "-75,-37", path = "top|right|bottom", fight = true },
    { map = "-75,-36", path = "top|right", fight = true },
    { map = "-74,-36", path = "top|left|right|bottom", fight = true },
    { map = "-74,-35", path = "top|right|bottom", fight = true },
    { map = "-74,-34", path = "top|right|bottom", fight = true },
    { map = "-74,-33", path = "top|bottom", fight = true },
    { map = "-74,-32", path = "top", fight = true },
    { map = "-73,-34", path = "top|left", fight = true },
    { map = "-73,-35", path = "top|left|bottom", fight = true },
    { map = "-73,-36", path = "top|left|bottom", fight = true },
    { map = "-73,-37", path = "top|left|bottom", fight = true },
    { map = "-73,-38", path = "top|left|right|bottom", fight = true },
    { map = "-72,-38", path = "top|left", fight = true },
    { map = "-72,-39", path = "top|left|bottom", fight = true },
    { map = "-72,-40", path = "top|left|bottom", fight = true },
    { map = "-72,-41", path = "left|bottom", fight = true },
    { map = "-73,-41", path = "top|left|right|bottom", fight = true },
    { map = "-73,-42", path = "top|left|bottom", fight = true },
    { map = "-73,-43", path = "left|bottom", fight = true },
    { map = "-74,-43", path = "top|left|right|bottom", fight = true },
    { map = "-74,-44", path = "left|bottom", fight = true },
    { map = "-75,-44", path = "top|left|right|bottom", fight = true },
    { map = "-75,-45", path = "left|bottom", fight = true },
    { map = "-76,-45", path = "top|left|right|bottom", fight = true },
    { map = "-76,-46", path = "left|bottom", fight = true },
    { map = "-77,-46", path = "left|right|bottom", fight = true },
    { map = "-78,-46", path = "left|right|bottom", fight = true },
    { map = "-79,-46", path = "left|right|bottom", fight = true },
    { map = "-80,-46", path = "left|right|bottom", fight = true },
    { map = "-81,-46", path = "left|right|bottom", fight = true },
    { map = "-82,-46", path = "left|right|bottom", fight = true },
    { map = "-83,-46", path = "right|bottom", fight = true },
    { map = "-83,-45", path = "top|left|right|bottom", fight = true },
    { map = "-84,-45", path = "right|bottom", fight = true },
    { map = "-84,-44", path = "top|left|right|bottom", fight = true },
    { map = "-85,-44", path = "right|bottom", fight = true },
    { map = "-85,-43", path = "top|right", fight = true },
    { map = "-84,-43", path = "top|left|right", fight = true },
    { map = "-83,-43", path = "top|left|right", fight = true },
    { map = "-82,-43", path = "top|left|right|bottom", fight = true },
    { map = "-82,-42", path = "top|right", fight = true },
    { map = "-81,-42", path = "top|left|right", fight = true },
    { map = "-80,-42", path = "top|left|right|bottom", fight = true },
    { map = "-80,-41", path = "top|left|right", fight = true },
    { map = "-79,-41", path = "top|left|right", fight = true },
    { map = "-78,-42", path = "top|left|right|bottom", fight = true },
    { map = "-79,-42", path = "top|left|right|bottom", fight = true },
    { map = "-79,-43", path = "top|left|right|bottom", fight = true },
    { map = "-80,-43", path = "top|left|right|bottom", fight = true },
    { map = "-81,-43", path = "top|left|right|bottom", fight = true },
    { map = "-81,-44", path = "top|left|right|bottom", fight = true },
    { map = "-82,-44", path = "top|left|right|bottom", fight = true },
    { map = "-83,-44", path = "top|left|right|bottom", fight = true },
    { map = "-82,-45", path = "top|left|right|bottom", fight = true },
    { map = "-81,-45", path = "top|left|right|bottom", fight = true },
    { map = "-80,-45", path = "top|left|right|bottom", fight = true },
    { map = "-80,-44", path = "top|left|right|bottom", fight = true },
    { map = "-79,-44", path = "top|left|right|bottom", fight = true },
    { map = "-79,-45", path = "top|left|right|bottom", fight = true },
    { map = "-78,-45", path = "top|left|right|bottom", fight = true },
    { map = "-78,-44", path = "top|left|right|bottom", fight = true },
    { map = "-78,-43", path = "top|left|right|bottom", fight = true },
    { map = "-77,-43", path = "top|left|right|bottom", fight = true },
    { map = "-77,-44", path = "top|left|right|bottom", fight = true },
    { map = "-77,-45", path = "top|left|right|bottom", fight = true },
    { map = "-76,-44", path = "top|left|right|bottom", fight = true },
    { map = "-76,-43", path = "top|left|right|bottom", fight = true },
    { map = "-75,-43", path = "top|left|right|bottom", fight = true },
    { map = "-75,-42", path = "top|left|right|bottom", fight = true },
    { map = "-76,-42", path = "top|left|right|bottom", fight = true },
    { map = "-77,-42", path = "top|left|right|bottom", fight = true },
    { map = "-77,-41", path = "top|left|right|bottom", fight = true },
    { map = "-76,-41", path = "top|left|right|bottom", fight = true },
    { map = "-74,-41", path = "top|left|right|bottom", fight = true },
    { map = "-75,-41", path = "top|left|right|bottom", fight = true },
    { map = "-74,-42", path = "top|left|right|bottom", fight = true },
    { map = "-76,-40", path = "top|left|right|bottom", fight = true },
    { map = "-75,-40", path = "top|left|right|bottom", fight = true },
    { map = "-74,-40", path = "top|left|right|bottom", fight = true },
    { map = "-73,-40", path = "top|left|right|bottom", fight = true },
    { map = "-73,-39", path = "top|left|right|bottom", fight = true },
    { map = "-74,-39", path = "top|left|right|bottom", fight = true },
    { map = "-75,-39", path = "top|left|right|bottom", fight = true },
    { map = "-74,-38", path = "top|left|right|bottom", fight = true },
    { map = "-74,-37", path = "top|left|right|bottom", fight = true },
}

function PNJchasseur()
    if job:level(41) == -1 then
        npc:npc(239,3)
        global:delay(500)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        npc:reply(-1)
        global:leaveDialog()
    else
        global:printSuccess("on a deja le metier de chasseur")
    end

    if job:level(41) ~= -1 and not CouteauAchete then
        global:printSuccess("on a pas de couteau")
        npc:npc(239,1) 
        global:delay(500)
        developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeBuyMessage\",\"data\":{\"objectToBuyId\":1934,\"quantity\":1}}}")
        global:printSuccess("couteau acheté")
        global:delay(500)
        global:leaveDialog()
        CouteauAchete = true
        inventory:equipItem(1934, 1)
    end
    map:changeMap("top")
end

function ObjetsCraftables()
    inventory:openBank()
    exchange:putAllItems()
    global:leaveDialog()
    PodsDispo = inventory:podsMax() - inventory:pods()
    return PodsDispo
end


function VerifBanque(IdItem, qtt, podDispo)
    PodsDisponible = podDispo
    inventory:openBank()
    global:printError("on verifie si on a des ressources en banque")
    if exchange:storageItemQuantity(IdItem) > qtt then
        exchange:getItem(IdItem, qtt) 
    elseif exchange:storageItemQuantity(IdItem) == 0 then
        global:leaveDialog()
        global:printError("on a pas la ressource")
    else
        exchange:getItem(IdItem, exchange:storageItemQuantity(IdItem))
    end
    global:leaveDialog()
end


function _ExchangeRequestedTradeMessage(message)
    if not global:isBoss() and not global:thisAccountController():getAlias():find("CanGiveToBotBank") then
        global:printSuccess("Échange reçu de la part d'un joueur connu, on accepte !")
        developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeAcceptMessage\"}}")
        global:delay(1000)
    
        local toGive = character:kamas() - 75000
        -- Put kamas
        if toGive > 0 then
            global:printSuccess("Je mets dans l'échange ".. toGive .." kamas.")
            exchange:putKamas(toGive)
        end

        global:delay(2000)

        global:printSuccess("on valide l'échange")
    
        exchange:ready()
        -- Wait
        global:printMessage("Attente de confirmation ...")
    end
    -- if global:isBoss() and ((global:remember("JOB_LEVEL_MINI") < 40) and job:level(41) > 45) then
    --     for _, item in ipairs(tableCraft) do
    --         if inventory:itemCount(item.ViandeId) > 0 then
    --             exchange:putItem(item.ViandeId, inventory:itemCount(item.ViandeId))
    --         end
    --     end
    -- end
    global:printSuccess("bug")
	-- Check
	--[[if not isWhitelisted(message.source) then
		global:printError("Échange reçu de la part d'un joueur inconnu, on refuse !")
		global:leaveDialog()
		return
	end]]
	-- Accept
end

function FreeTheDD()
    global:printSuccess("on va libérer la dd")
    --developer:sendMessage('{"call":"sendMessage","data":{"type":"MountReleaseRequestMessage"}}')
end

function messagesRegistering()
    developer:registerMessage("ExchangeStartedBidSellerMessage", stack_items_informations)
    developer:registerMessage("ExchangeRequestedTradeMessage", _ExchangeRequestedTradeMessage)
    developer:registerMessage("MountEquipedErrorMessage", FreeTheDD)
end

function Achat(IdItem, qtt)
    npc:npcSale()
    global:delay(500)

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    local Prices = GetPricesItem(IdItem)

    global:printSuccess("Prix par 100 : " .. Prices.Price100)
    global:printSuccess("Prix par 10 : " .. Prices.Price10)
    global:printSuccess("Prix par 1 : " .. Prices.Price1)

    global:leaveDialog()

    if (Prices.Price100 == 0) and (Prices.Price10 == 0) and (Prices.Price1 == 0) then
        global:printSuccess("L'item n'est plus disponible en hdv, on retente dans 2h")
        global:reconnect(2)
    elseif (Prices.Price10 == 0) and (Prices.Price1 == 0) then
        qtt = 100
    elseif (Prices.Price100 ~= 0) and (Prices.Price10 ~= 0) then
        qtt = ((((qtt < 100) and (qtt > 10)) and (Prices.Price100 * 1.3 < Prices.Price10 * 10)) and (inventory:itemWeight(IdItem) * 100) < (inventory:podsMax() - inventory:pods())) and 100
        or ((qtt < 10) and (Prices.Price10 * 1.3 < Prices.Price1 * 10)) and 10
        or qtt
    end

    npc:npcBuy()

    while qtt > 0 do           
        if qtt >= 100 then
            if character:kamas() < Prices.Price100 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                VenteViandeSimple()
                global:reconnect(2)
            end
            if ((Prices.Price10 * 1.2 < Prices.Price100 / 10) and Prices.Price10 ~= 0) or Prices.Price100 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 10, 1000000)
                end
                local difference = NbDeBdase + Quantite - inventory:itemCount(IdItem)
                if difference > 0 then
                    return Achat(IdItem, difference)
                end
            else
                sale:buyItem(IdItem, 100, 10000000)
            end
            qtt = qtt - 100             
        elseif qtt >= 10 and qtt < 100 then
            if character:kamas() < Prices.Price10 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                VenteViandeSimple()
                global:reconnect(2)
            end
            if ((Prices.Price1 * 1.2 < Prices.Price10 / 10) and Prices.Price1 ~= 0) or Prices.Price10 == 0 then
                for i = 1, 10 do
                    sale:buyItem(IdItem, 1, 100000)
                end
                local difference = NbDeBdase + Quantite - inventory:itemCount(IdItem)
                if difference > 0 then
                    return Achat(IdItem, difference)
                end
            else
                sale:buyItem(IdItem, 10, 1000000)
            end
            qtt = qtt - 10 
        elseif qtt >= 1 and qtt < 10 then
            if character:kamas() < Prices.Price1 then
                global:printSuccess("Plus assez de kamas, on retente dans 2h")
                VenteViandeSimple()
                global:reconnect(2)
            end
            sale:buyItem(IdItem, 1, 100000)
            qtt = qtt - 1 
        end
    end

    global:leaveDialog()

    if inventory:itemCount(IdItem) < NbDeBdase + Quantite then
        local difference = NbDeBdase + Quantite - inventory:itemCount(IdItem)
        if difference >= 10 and difference < 100 then
            return Achat(IdItem, 100)
        elseif difference > 99 then
            for i = 1, math.floor(difference / 10) do
                if inventory:itemCount(IdItem) < NbDeBdase + Quantite then
                    Achat(IdItem, 10)
                end
            end
        elseif difference < 10 then
            return Achat(IdItem, 10)
        end
    end
end

function ProcessSell()
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

    global:delay(1000)

    table.sort(TableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(TableVente) do
        if inventory:itemCount(element.Id) < 10 then global:printSuccess("on a plus rien à vendre") break end

        local Prices = GetPricesItem(element.Id)

        cpt = get_quantity(element.Id).quantity["100"]
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
			Prices.Price100 = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and (Prices.AveragePrice * 100) or Prices.Price100
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
            Prices.Price10 = (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and (Prices.AveragePrice * 10) or Prices.Price10
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

    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)
    
    inventory:openBank()

    for _, element in ipairs(TableVente) do
        if inventory:itemCount(element.Id) > 0 then
            exchange:putItem(element.Id, inventory:itemCount(element.Id))
        end
    end
    for _, element in ipairs(TableVente) do
        local podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.8
        local TotalMax = element.MaxHdv100 * 100 + element.MaxHdv10 * 10 - get_quantity(element.Id).quantity["100"] * 100 - get_quantity(element.Id).quantity["10"] * 10
        local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.Id)))
        if ((element.MaxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.MaxHdv100 == 0 and QuantiteAPrendre >= 10)) then
            exchange:getItem(element.Id, QuantiteAPrendre)
            reloadFunction = true
        end
    end
    for _, element in ipairs(tableCraft) do
        if exchange:storageItemQuantity(element.ViandeId) > 0 then
            local Quantity = math.min(exchange:storageItemQuantity(element.ViandeId), (inventory:podsMax() - inventory:pods()) * 0.8 / inventory:itemWeight(element.ViandeId))
            if Quantity > 0 then
                exchange:getItem(element.ViandeId, Quantity)
            end
        end
    end

    if reloadFunction then
        reloadFunction = false
        ProcessSell()
    end
end

function VenteViandeSimple()
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)


    table.sort(tableCraft, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(tableCraft) do

        if inventory:itemCount(element.Id) < 10 then global:printSuccess("on a plus rien à vendre") break end

        Prices = GetPricesItem(element.Id)

        local cpt = get_quantity(element.Id).quantity["100"]
        global:printSuccess("nombre de lot de 100 " .. inventory:itemNameId(element.Id) .. " : " .. cpt .. ", j'en ai " .. inventory:itemCount(element.Id) .. " en inventaire")
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv100 do 
			Priceitem = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and 100000 or Prices.Price100
            sale:SellItem(element.Id, 100, Prices.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Prices.Price100 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Prices.Price10 = (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and 10000 or Prices.Price10
            sale:SellItem(element.Id, 10, Prices.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Prices.Price10 - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    global:delay(500)
    global:leaveDialog()
end

function SellViandesCraft()
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
    for _, element in ipairs(tableCraft) do
        for _, data in ipairs(element.ListIdCraft) do
            if inventory:itemCount(data.Id) > 0 then
                exchange:putItem(data.Id, inventory:itemCount(data.Id))
            end
        end
        if exchange:storageItemQuantity(element.Id) > 0 then
            local Quantity = math.min(element.MaxHdv10 * 10 + element.MaxHdv100 * 100, exchange:storageItemQuantity(element.Id), (inventory:podsMax() - inventory:pods()) / inventory:itemWeight(element.Id))
            if Quantity > 0 then
                exchange:getItem(element.Id, Quantity)
            end
        end
        if exchange:storageItemQuantity(element.ViandeId) > 0 then
            local Quantity = math.min(exchange:storageItemQuantity(element.ViandeId), (inventory:podsMax() - inventory:pods()) * 0.8 / inventory:itemWeight(element.ViandeId))
            if Quantity > 0 then
                exchange:getItem(element.ViandeId, Quantity)
            end
        end
    end
    global:leaveDialog()

    global:printSuccess("Vente des Viandes Conservées")
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)


    table.sort(tableCraft, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(tableCraft) do

        if inventory:itemCount(element.Id) < 10 then global:printSuccess("on a plus rien à vendre") break end

        Prices = GetPricesItem(element.Id)

        local cpt = get_quantity(element.Id).quantity["100"]
        global:printSuccess("nombre de lot de 100 " .. inventory:itemNameId(element.Id) .. " : " .. cpt .. ", j'en ai " .. inventory:itemCount(element.Id) .. " en inventaire")
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv100 do 
			Priceitem = (Prices.Price100 == nil or Prices.Price100 == 0 or Prices.Price100 == 1) and 100000 or Prices.Price100
            sale:SellItem(element.Id, 100, Prices.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Prices.Price100 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Prices.Price10 = (Prices.Price10 == nil or Prices.Price10 == 0 or Prices.Price10 == 1) and 10000 or Prices.Price10
            sale:SellItem(element.Id, 10, Prices.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Prices.Price10 - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    global:delay(500)
    global:leaveDialog()

    for _, element in ipairs(tableCraft) do
        if inventory:itemCount(element.ViandeId) >= 10 then
            global:printSuccess("On peut craft à l'aide de la viande d'id " .. element.ViandeId .. "on y retourne")
            return BuyMissingResources()
        end
    end

    inventory:openBank()

    for _, element in ipairs(tableCraft) do
        for _, data in ipairs(element.ListIdCraft) do
            if inventory:itemCount(data.Id) > 0 then
                exchange:putItem(data.Id, inventory:itemCount(data.Id))
            end
        end
        if inventory:itemCount(element.Id) > 0 then
            exchange:putItem(element.Id, inventory:itemCount(element.Id))
        end
        if inventory:itemCount(element.ViandeId) > 0 then
            exchange:putItem(element.ViandeId, inventory:itemCount(element.ViandeId))
        end
    end
    global:leaveDialog()

    global:editInMemory("bank()", false)
end

local function ProcessCraft()
    map:useById(461650, -1)
	global:delay(500)
	
    for _, element in ipairs(tableCraft) do
        if inventory:itemCount(element.ViandeId) >= 10 then
            craft:putItem(element.ViandeId, 1)
            CraftQuantity = inventory:itemCount(element.ViandeId)
            for _, data in ipairs(element.ListIdCraft) do
                CraftQuantity = math.min(CraftQuantity, inventory:itemCount(data.Id) / data.Nb)
                craft:putItem(data.Id, data.Nb)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            global:delay(500)
            CraftReady()
            global:printSuccess("Craft effectué !")
            global:delay(500)
            break
        end
    end

    global:leaveDialog()

    global:delay(500)

    BuyMissingResources()
end

function BuyMissingResources()

    for _, element in ipairs(tableCraft) do
        podsAvailable = (inventory:podsMax() - inventory:pods()) * 0.8

        local PodsNeededToCraft = inventory:itemWeight(element.ViandeId)
        for _, element2 in ipairs(element.ListIdCraft) do
            PodsNeededToCraft = PodsNeededToCraft + inventory:itemWeight(element2.Id) * element2.Nb
        end

        if (inventory:itemCount(element.ViandeId) >= 10) and (podsAvailable > (PodsNeededToCraft * 10)) then
            GoCraft = true
            CraftQuantity = math.floor(math.min(podsAvailable / PodsNeededToCraft, inventory:itemCount(element.ViandeId)))
            global:printSuccess("go Craft " .. CraftQuantity .. " x " ..  element.Name)
            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " x " .. inventory:itemNameId(element2.Id))
                    Achat(element2.Id, BuyQuantity)
                    global:delay(500)
                end
            end
            break
        end
    end
    if GoCraft then
        GoCraft = false
        global:leaveDialog()
        ProcessCraft()
    end
    global:delay(500)
    SellViandesCraft()
    global:delay(500)
    for _, element in ipairs(tableCraft) do
        if inventory:itemCount(element.ViandeId) >= 10 then
            global:printSuccess("On peut craft à l'aide de la viande d'id " .. element.ViandeId .. ", on y retourne")
            return BuyMissingResources()
        end
    end
    global:printSuccess("Plus rien à craft")

    npc:npcSale()
    global:delay(500)
    local random = math.random(1, 3)

    if random == 1 then
        global:printSuccess("On actualse tous les prix")
        sale:updateAllItems()
    end

    global:delay(500)
    global:leaveDialog()

    if character:kamas() > 150000 and global:thisAccountController():getAlias():find("CanGiveToBotBank") then
        GiveKamasBank = true
        PopoRappel()
    end

    if not global:thisAccountController():isItATeam() and not mount:hasMount() and character:level() > 59 and character:kamas() > 50000 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Achat_DD.lua")
    end

    if not global:thisAccountController():isItATeam() and inventory:itemCount(2531) == 0 and job:level(41) > 39 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Take_Stuff_70.lua")
    end

    if not global:thisAccountController():isItATeam() and character:level() > 50 and character:kamas() > 50000 and inventory:itemCount(347) == 0 and inventory:itemCount(742) == 0 then

        npc:npcBuy()
        developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true, nil, 20)

        sale:buyItem(347, 1, 20000)
        global:leaveDialog()
        if inventory:itemCount(347) == 0 then
            global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\MetierCraft\\LearnSculpteurAndCraftBaton.lua")
        else
            inventory:equipItem(347, 1)
        end
    end

    local Need = (job:level(41) < 40 or character:level() < 68) and 2 or (job:level(41) >= 40) and 4 
    EditAlias()
    global:editAlias(global:thisAccountController():getAlias() .. " Need" .. Need, true)
    global:disconnect()
end


function launchExchangeAndGiveItems()
    developer:unRegisterMessage("ExchangeRequestedTradeMessage")
    global:setPrivate(false)
    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. AccountBank.character:id())

    AccountBank.global:setPrivate(false)
    AccountBank:exchangeListen(false)

    global:delay(500)

    while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
        if ConsoleRead(AccountBank, "Le serveur a coupé la connexion inopinément") then
            AccountBank.global:clearConsole()
            AccountBank:unloadAccount()
            AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Bot_Bank.lua")
        end
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
    end

    while AccountBank:isScriptPlaying() do
        global:delay(2000)
    end

    local toGive = character:kamas() - 100000
    if toGive > 0 then
        global:printSuccess("on transfère " .. toGive .. "kamas")
        exchange:putKamas(toGive)
    end
    global:delay(500)
    global:printSuccess("On valide l'échange")
    exchange:ready()

    global:delay(2000)
    GiveKamasBank = false
    AccountBank:startScript()
    PopoRappel()
end

function treatMaps(maps)

    for _, element in ipairs(maps) do
        condition = map:onMap(element.map)

        if condition then
            return maps
        end
    end

    if global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc:callScriptFunction("PopoRappel")
        end
        PopoRappel()
    end
end

function ProcessToUpChasseur10()
    PodsDisponible = inventory:podsMax() - inventory:pods()
    VerifBanque(1734, 128, PodsDisponible)
    VerifBanque(1978, 128, PodsDisponible)          
    Qttycerise = 128 - inventory:itemCount(1734)
    Qttypoivre = 128 - inventory:itemCount(1978)
    global:printError("On achete les ressources manquantes")
    Achat(1734, Qttycerise)
    Achat(1978, Qttypoivre)

    map:useById(461650, -1)
    craft:putItem(1734, 1)
    craft:putItem(1978, 1)
    craft:changeQuantityToCraft(128)
    CraftReady()
    global:leaveDialog()

    inventory:deleteItem(1977, inventory:itemCount(1977))
end

function antiModo()
    if global:isModeratorPresent(30) then
        timerdisconnect = math.random(30000, 36000) 

        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. " secondes")

        local Alias = global:thisAccountController():getAlias():split(" ")

        if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
            global:editAlias("Team 1 " .. character:serverName() .. ", Chasseur lvl " .. job:level(41) .. " [MODO]", true)
        else
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", Chasseur lvl " .. job:level(41) .. " [MODO]", true)
        end

        global:delay(timerdisconnect)

        if global:isBoss() then
            TeamAcount = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(TeamAcount) do
                acc.global:reconnectBis(timerdisconnect / 1000)
            end
            global:reconnectBis((timerdisconnect + 10) / 1000)
        elseif not global:thisAccountController():isItATeam() then
            global:reconnectBis(timerdisconnect / 1000)
        end
    end
end

function EditAlias()
    local Alias = global:thisAccountController():getAlias():split(" ")
    if global:thisAccountController():isItATeam() then
        if Alias ~= nil and #Alias > 1 and Alias[2]:find(character:serverName()) then
            global:editAlias("Team 1 " .. character:serverName() .. ", Chasseur lvl " .. job:level(41), true)
        else
            global:editAlias("Team " .. Alias[2] .. " " .. character:serverName() .. ", Chasseur lvl " .. job:level(41), true)
        end
    end
end


--0 a 10 = 128 crafts 2 cases
function move()

    if not global:thisAccountController():isItATeam() and inventory:itemCount(2531) == 0 and job:level(41) > 39 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Take_Stuff_70.lua")
    end
    if not global:thisAccountController():isItATeam() and not mount:hasMount() and character:level() > 59 and character:kamas() > 50000 then
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Achat_DD.lua")
    end
    EditAlias()  
    
    TakeBonusPackForTeam()

    if not global:thisAccountController():isItATeam() then
        return bank()
    end
    if global:remember("bank()") then
        return bank()
    end
    if global:afterFight() and global:isBoss() then
        local team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc:callScriptFunction("ManageMount")
        end
        ManageMount()
    end

    if global:isBoss() then
        local lvlMiniChasseur = job:level(41)
        team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            if acc.job:level(41) < lvlMiniChasseur then
                lvlMiniChasseur = acc.job:level(41)
            end
        end
        for _, acc in ipairs(team) do
            acc.global:editInMemory("JOB_LEVEL_MINI", lvlMiniChasseur)
        end
        global:editInMemory("JOB_LEVEL_MINI", lvlMiniChasseur)
    end

    -- Apprendre Métier Chasseur
    if global:remember("JOB_LEVEL_MINI") == -1 and not map:onMap(88080645) then
        return trajetChasseur
    elseif map:onMap(88080645) and job:level(41) == -1 then
        if global:isBoss() then
            team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                acc:callScriptFunction("PNJchasseur")
            end
            PNJchasseur()
        end
    end
    
    -- Monter chasseur niveau 10
    if global:remember("JOB_LEVEL_MINI") < 10 and global:remember("JOB_LEVEL_MINI") ~= -1 then
        if not vide then
            global:printSuccess("on vide l'inventaire")
            PodsDisponible = ObjetsCraftables()
            vide = true          
        end

        if global:isBoss() then
            team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                acc:callScriptFunction("GoToBonta")
            end
            GoToBonta()
        end
           
        if not map:onMap(4720135) then
            return TrajetAtelierBonta
        else
            if PodsDisponible < 256 then
                global:printError("on a pas asser de pods")
            else
                if global:isBoss() then
                    team = global:thisAccountController():getTeamAccounts()
                    for _, acc in ipairs(team) do
                        acc:callScriptFunction("ProcessToUpChasseur10")
                    end
                    ProcessToUpChasseur10()
                end
                -- popo rappel
                if global:isBoss() then
                    team = global:thisAccountController():getTeamAccounts()
                    for _, acc in ipairs(team) do
                        acc:callScriptFunction("PopoRappel")
                    end
                    PopoRappel()
                end
            end
        end
    end 

    antiModo()


    if global:remember("JOB_LEVEL_MINI") < 30 then
        MIN_MONSTERS = 2
        return treatMaps(TrajetBouftou)
    elseif global:remember("JOB_LEVEL_MINI") < 40 then
        MIN_MONSTERS = 2
        return treatMaps(TrajetForetAmakna)   
    elseif global:remember("JOB_LEVEL_MINI") >= 40 and (global:thisAccountController():getAlias():split(" ")[2]:find("1") or global:thisAccountController():getAlias():split(" ")[2]:find("2")) then
        local Team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(Team) do
            acc.global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_CombatGroupe.xml")
        end
        global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_CombatGroupe.xml")
        global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Combat\\Combat_Team_BL.lua")
    elseif global:remember("JOB_LEVEL_MINI") < 60 and #global:thisAccountController():getTeamAccounts() == 1 then
        if global:thisAccountController():isItATeam() and global:isBoss() then
            team = global:thisAccountController():getTeamAccounts()
            for _, acc in ipairs(team) do
                acc.global:editAlias(acc:getAlias() .. " Need4", true)
                acc:loadScriptNextConnection("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua", true)
                acc.global:disconnect()
            end
            global:editAlias(global:thisAccountController():getAlias() .. " Need4 CanGiveToBotBank", true)
            global:thisAccountController():loadScriptNextConnection("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua", true)
            global:disconnect()
        end
    elseif global:remember("JOB_LEVEL_MINI") < 60 then
        --PLANNING = {11, 12, 19, 20, 21, 22, 23}
        MIN_MONSTERS = 2
        MAX_MONSTERS = 3
        return treatMaps(TrajetDragodindes)
    elseif global:remember("JOB_LEVEL_MINI") < 80 then
        --PLANNING = {11, 12, 19, 20, 21, 22, 23}
        MIN_MONSTERS = 3
        return treatMaps(TrajetKanigrou)
    end
    local Team = global:thisAccountController():getTeamAccounts()
    for _, acc in ipairs(Team) do
        acc.global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_CombatGroupe.xml")
    end
    global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Configs\\Config_CombatGroupe.xml")
    global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Combat\\Combat_Team_BL.lua")
end

    
function bank()
    if global:isBoss() then
        local lvlMiniChasseur = job:level(41)
        team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            if acc.job:level(41) < lvlMiniChasseur then
                lvlMiniChasseur = acc.job:level(41)
            end
        end
        for _, acc in ipairs(team) do
            acc.global:editInMemory("JOB_LEVEL_MINI", lvlMiniChasseur)
        end
        global:editInMemory("JOB_LEVEL_MINI", lvlMiniChasseur)
    end
    EditAlias()

    if GiveKamasBank and not global:remember("PasDeBotBank") then
        return {
            {map = "-32,-56", path = "zaap(84674563)"},
            {map = "-16,1", path = "zaap(84674563)"},
            {map = "5,7", path = "zaap(84674563)"},
            {map = "10,22", path = "zaap(84674563)"},
            {map = "4,-19", path = "bottom"},
            {map = "4,-18", path = "bottom"},
            {map = "4,-17", path = "bottom"},
            {map = "84674566", door = "303"},
            {map = "83887104", custom = function ()
                AccountBank = LoadAndConnectBotBanque("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\Utilitaires\\Bot_Bank.lua")
                if AccountBank ~= nil then
                    launchExchangeAndGiveItems()
                else
                    global:deleteMemory("PasDeBotBank")
                    global:addInMemory("PasDeBotBank", true)
                    PopoRappel()
                end
            end}
        }
    end

    if not tradeDone and global:thisAccountController():isItATeam() and global:isBoss() and global:remember("JOB_LEVEL_MINI") > 39 then   

        local TeamAcount = global:thisAccountController():getTeamAccounts()

        for _, acc in ipairs(TeamAcount) do
            acc.global:setPrivate(false)
            acc.inventory:openBank()
            if acc.exchange:storageKamas() > 0 then
                acc.global:printSuccess("Il y a " .. acc.exchange:storageKamas() .. " kamas en banque, on les prend")
                acc.exchange:getKamas(0)
                global:delay(500)
            elseif exchange:storageKamas() == 0 then
                acc.global:printError("Il n'y a pas de kamas en banque")
                global:delay(500)
            end
    
            acc.global:leaveDialog()
            global:delay(500)
            local counter = 0
            while not exchange:launchExchangeWithPlayer(acc.character:id()) do
                if counter >= 60 then
                    global:restartScript(true)
                end
                global:printMessage("Attente de l'acceptation de l'échange (2 secondes)")
                global:delay(2000)
                counter = counter + 1
            end

            -- for _, item in ipairs(tableCraft) do
            --     if inventory:itemCount(item.ViandeId) > 0 then
            --         exchange:putItem(item.ViandeId, inventory:itemCount(item.ViandeId))
            --     end
            -- end
            
            developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
            exchange:ready()

            acc.global:setPrivate(true)
        end

        -- for _, acc in ipairs(TeamAcount) do
        --     if acc.job:level(41) > 79 then
        --         for _, acc2 in ipairs(TeamAcount) do
        --             if acc2.job:level(41) == global:remember("JOB_LEVEL_MINI") then
        --                 acc.global:setPrivate(false)
        --                 acc2.global:setPrivate(false)
        --                 while not acc.exchange:launchExchangeWithPlayer(acc2.character:id()) do
        --                     acc.global:printMessage("Attente de l'acceptation de l'échange (2 secondes)")
        --                     global:delay(2000)
        --                 end
        --                 developer:suspendScriptUntil("ExchangeIsReadyMessage", 30000)
        --                 acc.exchange:ready()
            
        --                 acc.global:setPrivate(true)
        --                 acc2.global:setPrivate(true)

        --             end
        --         end
        --     end
        -- end
        tradeDone = true
    end

    if global:thisAccountController():isItATeam() and global:isBoss() then
        team = global:thisAccountController():getTeamAccounts()
        for _, acc in ipairs(team) do
            acc.global:editAlias(acc:getAlias() .. " Need1", true)
            acc:loadScriptNextConnection("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua", true)
            acc.global:disconnect()
        end
        global:editAlias(global:thisAccountController():getAlias() .. " Need1 CanGiveToBotBank", true)
        global:thisAccountController():loadScriptNextConnection("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\PLAndZaaps\\PL_Chasseur_Team.lua", true)
        global:disconnect()
    end

    global:editInMemory("bank()", true)
    PopoBonta()
    if not map:onMap(4720135) then
        return TrajetAtelierBonta
    else
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
        for _, element in ipairs(tableCraft) do
            for _, data in ipairs(element.ListIdCraft) do
                if exchange:storageItemQuantity(data.Id) > 0 and inventory:itemCount(element.ViandeId) > 9 then
                    local Quantity = math.min(exchange:storageItemQuantity(data.Id), (inventory:podsMax() - inventory:pods()) * 0.8 / inventory:itemWeight(data.Id) * #element.ListIdCraft, inventory:itemCount(element.ViandeId) * data.Nb)
                    if Quantity > 0 then
                        exchange:getItem(data.Id, Quantity)
                    end
                end
            end
        end
        global:leaveDialog()
        ProcessSell()
        BuyMissingResources()
    end
end


function phenix()
    return {
        { map = "-18,-57", custom = function (acc)
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(172)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(172)
                PopoRappel()
            end
        end},

        { map = "8,16", path = "right" },
        { map = "9,16", path = "right" },

        { map = "32,11", path = "top" },
        { map = "32,10", path = "top" },
        { map = "32,9", path = "top" },
        { map = "32,8", path = "top" },
        { map = "33,7", path = "top" },
        { map = "34,6", path = "top" },
        { map = "32,7", path = "right" },
        { map = "33,6", path = "right" },
        { map = "34,5", path = "right" },
        { map = "34,6", path = "right" },
        { map = "35,5", path = "right" },
        {map = "36,5", custom = function (acc)
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(327)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(327)
                PopoRappel()
            end
        end},

        {map = "-14,30", path = "bottom"},
        {map = "-13,30", path = "left"},
        {map = "-13,31", path = "left"},

        {map = "-15,32", path = "right"},
        {map = "-13,32", path = "left"},
        {map = "-14,32", path = "top"},
        {map = "-14,31", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(243)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(243)
                PopoRappel()
            end
        end},

        {map = "-18,-57", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(172)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(172)
                PopoRappel()
            end
        end},
        {map = "-11,16", path = "top"},
        {map = "-11,15", path = "top"},
        {map = "-11,14", path = "top"},
        {map = "-11,13", path = "right"},
        {map = "-13,13", path = "right"},

        {map = "64489222", custom = function ()
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(354)
                    acc.mount:toggleRiding()
                    acc.map:door(218)
                end
                map:door(354)
                mount:toggleRiding()
                map:door(218)
            end
        end},
        {map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() 
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(184)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(184)
                PopoRappel()
            end
        end},
        {map = "-10,-6", custom = function() 
            if global:isBoss() then
                local team = global:thisAccountController():getTeamAccounts()
                for _, acc in ipairs(team) do
                    acc.map:door(185)
                    acc:callScriptFunction("PopoRappel")
                end
                map:door(185)
                PopoRappel()
            end
        end},
    }
end


function banned()
    global:editAlias(global:thisAccountController():getAlias() .. " [BAN]", true)
end