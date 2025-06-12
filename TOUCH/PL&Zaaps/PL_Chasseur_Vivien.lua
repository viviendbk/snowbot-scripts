dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\TOUCH\\IA\\IA_Eni_Groupe.lua")

local ABonta = false
local Vide = false
local CouteauAchete = false

AUTO_DELETE = {792, 519, 385, 1736, 385, 383, 2414, 2416, 2425, 2428, 10967, 1900, 364, 1730, 15479, 1690, 407, 1734}


local pano_moskito = {
--[[
    6918 - Amulette du Moskito
    6915 - Mos Kitano
    6916 - Sac du Petit Moskito
    6917 - Moskitogalurette
    ]]
}

local tableCraft = {
    {Name = "Chair d'Insecte Conservée", Id = 1993, Level = 10, ViandeId = 1915, MaxHdv100 = 3, MaxHdv10 = 10, ListIdCraft = {
        {Id = 1983, Nb = 1},
        {Id = 1986, Nb = 1},
    }, PodsNeededToCraft = 4},
    {Name = "Cuisse de Bouftou Conservée", Id = 1995, Level = 10, ViandeId = 1911, MaxHdv100 = 3, MaxHdv10 = 10, ListIdCraft = {
        {Id = 1983, Nb = 1},
        {Id = 1986, Nb = 1},
    }, PodsNeededToCraft = 4},
    {Name = "Cuisse de Bouftou Conservée **", Id = 1997, Level = 10, ViandeId = 1912, MaxHdv100 = 3, MaxHdv10 = 10, ListIdCraft = {
        {Id = 1983, Nb = 2},
        {Id = 1986, Nb = 1},
    }, PodsNeededToCraft = 5},
    {Name = "Carré de Porc Conservé", Id = 2004, Level = 30, ViandeId = 1917, MaxHdv100 = 3, MaxHdv10 = 10, ListIdCraft = {
        {Id = 1984, Nb = 1},
        {Id = 1983, Nb = 2},
        {Id = 1986, Nb = 1},
    }, PodsNeededToCraft = 7},
    {Name = "Dragoviande Conservée", Id = 2014, Level = 30, ViandeId = 1922, MaxHdv100 = 3, MaxHdv10 = 10, ListIdCraft = {
        {Id = 1986, Nb = 1},
        {Id = 2012, Nb = 2},
        {Id = 1984, Nb = 2},
        {Id = 1985, Nb = 1},
    }, PodsNeededToCraft = 8},
}


local tableVente = {
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Blanc", Id = 881 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Laine de Boufton Noir", Id = 885 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir du chef de guerre bouftou", Id = 887 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},

    {Name = "Racine d'Abraknyde", Id = 435 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Résine végétale", Id = 1985 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Patte dArakne", Id = 365 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Bleue", Id = 362 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Chair de Larve", Id = 1898 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Peau de Larve Orange", Id = 363 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Museau", Id = 1927 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Ailes de Moskito", Id = 307 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Mesure de Poivre", Id = 1978 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Cuir de Sanglier", Id = 486 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    --{Name = "Carré de Porc", Id = 1917 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},

    {Name = "Tatouage de Mauvais Garçon", Id = 13342 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true}, --début des 2 zones (piou et contour astrub)

    {Name = "Poils de souris", Id = 761 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Graine de Sésame", Id = 287 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},

    {Name = "Plume de Piou Bleu", Id = 6897 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Violet", Id = 6898 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Vert", Id = 6899 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rouge", Id = 6900 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Jaune", Id = 6902 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
    {Name = "Plume de Piou Rose", Id = 6903 , MaxHdv100 = 5, MaxHdv10 = 10, MaxHdv1 = 0, CanSell = true},
}

local trajetChasseur = {
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

local TrajetAtelierBonta ={
    { map = "5506048", path = "zaapi(147764)" },
    { map = "147764", door = "318" },
    { map = "4719111", door = "338" },
}

local trajetBouftou = {
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

local function PNJchasseur()
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
        developer:sendMessage("{\"call\":\"sendMessage\",\"data\":{\"type\":\"ExchangeBuyMessage\",\"data\":{\"objectToBuyId\":1934,\"quantity\":1}}}")
        global:printSuccess("couteau acheté")
        global:leaveDialog()
        CouteauAchete = true
        inventory:equipItem(1934, 1)
    end
    map:changeMap("top")
end

local function GoToBonta()
    if map:currentArea() ~= "Bonta" then
        npc:npcBuy()
        global:delay(500)
        sale:buyItem(6965, 1, 1000)
        if inventory:itemCount(6965) == 0 then
            sale:buyItem(6965, 10, 10000)
        end
        global:delay(500)
        global:leaveDialog()
        global:delay(500)
        inventory:useItem(6965)
    end
end

local function PopoRappel()
    npc:npcBuy()
    global:delay(500)
    sale:buyItem(548, 1, 1000)
    if inventory:itemCount(548) == 0 then
        sale:buyItem(548, 10, 10000)
    end
    global:delay(500)
    global:leaveDialog()
    global:delay(500)
    inventory:useItem(548)
end

local function ObjetsCraftables()
    inventory:openBank()
    exchange:putAllItems()
    global:leaveDialog()
    PodsDispo = inventory:podsMax() - inventory:pods()
    return PodsDispo
end

local function Achat(IdItem, qtt)
    npc:npcBuy()

    local Quantite = qtt
    local NbDeBdase = inventory:itemCount(IdItem)

    while qtt > 0 do           
        if qtt >= 100 then
            sale:buyItem(IdItem, 100, 20000)
            qtt = qtt - 100             
        elseif qtt >= 10 and qtt < 100 then
            sale:buyItem(IdItem, 10, 2000)
            qtt = qtt - 10 
        elseif qtt >= 1 and qtt < 10 then
            sale:buyItem(IdItem, 1, 200)
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
                Achat(IdItem, 10)
            end
        elseif difference < 10 then
            return Achat(IdItem, 10)
        end
    end
end

local function VerifBanque(IdItem, qtt, podDispo)
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

local function ProcessSell()
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true)

    global:delay(1000)

    table.sort(tableVente, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

    for _, element in ipairs(tableVente) do
        global:printSuccess(_ .. "ème item à vendre...")
        if inventory:itemCount(element.Id) < 10 then global:printSuccess("on a plus rien à vendre") break end

        cpt = get_quantity(element.Id).quantity["100"]
		local Priceitem = sale:getPriceItem(element.Id, 3)
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
			Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 100, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        local Priceitem = sale:getPriceItem(element.Id, 2)
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 10, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
    end

    global:leaveDialog()
end

local function SellViandesCraft()
    global:printSuccess("test")
    npc:npcSale()
    developer:suspendScriptUntil("ExchangeStartedBidSellerMessage", 5000, true)

    global:delay(1000)

    for _, element in ipairs(tableCraft) do

        if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

        cpt = get_quantity(element.Id).quantity["100"]
		local Priceitem = sale:getPriceItem(element.Id, 3)
    	while inventory:itemCount(element.Id) >= 100 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv100 do 
			Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 100, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        local Priceitem = sale:getPriceItem(element.Id, 2)
        while inventory:itemCount(element.Id) >= 10 and sale:AvailableSpace() > 0 and cpt < element.MaxHdv10 do 
            Priceitem = (Priceitem == nil or Priceitem == 0 or Priceitem == 1) and sale:getAveragePriceItem(element.Id, 2) * 1.5 or Priceitem
            sale:SellItem(element.Id, 10, Priceitem - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem - 1 .. "kamas")
            cpt = cpt + 1
        end
    end
    global:printSuccess("testfin")


    global:leaveDialog()
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
            craft:ready()
            global:delay(500)
            break
        end
    end

    global:leaveDialog()

    BuyMissingResources()
end

function BuyMissingResources()

    for _, element in ipairs(tableCraft) do
        local podsAvailable = inventory:podsMax() - inventory:pods()

        if (inventory:itemCount(element.ViandeId) > 10) and (podsAvailable > (element.PodsNeededToCraft * 10)) then
            GoCraft = true
            CraftQuantity = math.floor(math.min(podsAvailable / element.PodsNeededToCraft, inventory:itemCount(element.ViandeId)))
            global:printSuccess("go Craft " .. CraftQuantity .. " x " ..  element.Name)
            for _, element2 in ipairs(element.ListIdCraft) do

                BuyQuantity = CraftQuantity * element2.Nb - inventory:itemCount(element2.Id)
                
                if BuyQuantity > 0 then
                    global:printSuccess("On achète " .. BuyQuantity .. " item d'id " .. element2.Id)
                    Achat(element2.Id, BuyQuantity)
                end
            end
            break
        end
    end
    if GoCraft then
        GoCraft = false
        ProcessCraft()
    end
    SellViandesCraft()
    PopoRappel()
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

--0 a 10 = 128 crafts 2 cases
function move()

    -- Apprendre Métier Chasseur
    if job:level(41) == -1 and not map:onMap(88080645) then
        return trajetChasseur
    elseif map:onMap(88080645) and job:level(41) == -1 then
        PNJchasseur()
    end
    
    -- Monter chasseur niveau 10
    if job:level(41) < 10 and job:level(41) ~= -1 then
        if not vide then
            global:printSuccess("on vide l'inventaire")
            PodsDisponible = ObjetsCraftables()
            vide = true          
        end

        GoToBonta()
           
        if not map:onMap(4720135) then
            return TrajetAtelierBonta
        else
            if PodsDisponible < 256 then
                global:printError("on a pas asser de pods")
            else
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
                craft:ready()
                global:leaveDialog()

                inventory:deleteItem(1977, inventory:itemCount(1977))
                -- popo rappel
                PopoRappel()
            end
        end
    end 

    if job:level(41) < 30 and job:level(41) ~= -1 then
        return treatMaps(trajetBouftou)
    elseif job:level(41) < 40 then
        return treatMaps(trajetForetAmakna)
    elseif job:level(41) < 80 then
        return treatMaps(trajetDragodindes)
    end
end

--monter chasseur 10 to 30 = 469 recette 3 cases (faire cuisse de bouftou conservée)
--monter chasseur 30 to 40 = 231 recette 4 cases (carré de porc + permet de faire un craft rentzble (jtevu) )
--monter chasseur 40 to 100 = 3633 recette 5 cases (dragoviande + permet de faire un craft pa )

    

function bank()
    GoToBonta()
    if not map:onMap(4720135) then
        return TrajetAtelierBonta
    else
        inventory:openBank()
        global:delay(500) 
        if exchange:storageKamas() > 0 then
            exchange:getKamas(0)
            global:delay(500)
        elseif exchange:storageKamas() == 0 then
            global:delay(500)
        end	
        global:leaveDialog()
        ProcessSell()
        BuyMissingResources()
    end
end