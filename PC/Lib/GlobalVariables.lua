NB_BUCHERON = 5
NB_MINEUR = 5
NB_LVLUP = 5
NB_COMBAT = 5
NB_CRAFT = 2
NB_GROUPE = 3

IP_PROXY = "193.252.210.41"
USERNAME_PROXY = "proxy"
PASSWORD_PROXY = "1937Shield1234Abcd"

TYPE_PROXY = "socks5"

PROXIES = {
    ["1"] = {
        ips = IP_PROXY .. "#SOCKS5_" .. IP_PROXY .. "#",
        port = "5001#5002",
        username = USERNAME_PROXY .. "#" .. USERNAME_PROXY,
        password =  PASSWORD_PROXY .. "#" .. PASSWORD_PROXY
    },
    ["2"] = {
        ips = IP_PROXY .. "#SOCKS5_" .. IP_PROXY .. "#",
        port = "5001#5003",
        username = USERNAME_PROXY .. "#" .. USERNAME_PROXY,
        password =  PASSWORD_PROXY .. "#" .. PASSWORD_PROXY
    },  
    ["3"] = {
        ips = IP_PROXY .. "#SOCKS5_" .. IP_PROXY .. "#",
        port = "5001#5004",
        username = USERNAME_PROXY .. "#" .. USERNAME_PROXY,
        password =  PASSWORD_PROXY .. "#" .. PASSWORD_PROXY
    },
    ["4"] = {
        ips = IP_PROXY,
        port = "5005",
        username = USERNAME_PROXY,
        password =  PASSWORD_PROXY
    }, 
    ["5"] = {
        ips = IP_PROXY,
        port = "5006",
        username = USERNAME_PROXY,
        password =  PASSWORD_PROXY
    },
}

BANK_MAPS = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

retryTimestamp = 0
givingMode = false
cannotConnect = false
botFound = false
connected = false


SERVERS_MULTI = {
    "Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Rafal", "Salar", "Brial"
}

SERVERS_MONO = {
    "Draconiros", "Dakal", "Kourial", "Mikhal"
}

ALL_SERVERS = {
    "Draconiros", "Dakal", "Kourial", "Mikhal", "Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Rafal", "Salar", "Brial"
}

STUFF_200 = {
	{Type = "amulette", Id = 8262, Emplacement = 0, Equipe = false},
	{Type = "ceinture", Id = 8266, Emplacement = 3, Equipe = false},
	{Type = "cape", Id = 8265, Emplacement = 7, Equipe = false},
	{Type = "bottes", Id = 8264, Emplacement = 5, Equipe = false},
	{Type = "coiffe", Id = 8267, Emplacement = 6, Equipe = false},
	{Type = "anneauGauche", Id = 8263, Emplacement = 2, Equipe = false},
	{Type = "anneauDroit", Id = 2469, Emplacement = 4, Equipe = false}, 
    {Type = "arme", Id = 8827, Emplacement = 1, Equipe = false}, 
	{Type = "bouclier", Id = 18688, Equipe = false, Emplacement = 15},
    {Type = "compagnon", Id = 14966, Emplacement = 28, Equipe = false},

    --{Type = "dokoko", Id = 17078, Emplacement = 9, Equipe = false},
    --{Type = "dofus argenté", Id = 19629, Emplacement = 10, Equipe = false},
    --{Type = "forcené", Id = 13758, Emplacement = 10, Equipe = false}, remplacement du dofus argenté

    {Type = "dofus kaliptus", Id = 8072, Emplacement = 11, Equipe = false},
    {Type = "dofus emeraude", Id = 737, Emplacement = 12, Equipe = false},
    {Type = "dofus cawotte", Id = 972, Emplacement = 14, Equipe = false},
    {Type = "voyageur", Id = 13830, Emplacement = 13, Equipe = false},

}

MAPS_SANS_HAVRESAC = {
    {Id = 168035328, Door = "458"},
    {Id = 168034312, Door = "215"},
    {Id = 168034310, Door = "215"},
    {Id = 104859139, Path = "444"},
    {Id = 168167424, Door = "289"},
    {Id = 104861191, Path = "457"},
    {Id = 57017859, Path = "395"},
    {Id = 168036352, Door = "458"},
    {Id = 104860167, Path = "478"},
    {Id = 104862215, Path = "472"},
    {Id = 104859143, Path = "543"},
    {Id = 168034306, Door = "471"},
    {Id = 168034308, Door = "464"},
    {Id = 168034310, Door = "493"},
    {Id = 57017861, Path = "270"},
    {Id = 104860169, Path = "379"},
    {Id = 104858121, Path = "507"},
    {Id = 168034304, Door = "390"},
    {Id = 104862217, Path = "369"},
    {Id = 104861193, Path = "454"},
    {Id = 104859145, Path = "457"},
}

PourcentageJetPerf_ItemToSell = 0
IdToSell = 0
BestPrice = 0
PoidsOver = 0
Pourcentage = 0
ActualPrice = 0

RunesTransVita = {{Id = 20567, Value = 50, ConditionPoids = 61}, {Id = 20568, Value = 75, ConditionPoids = 41}--[[, {Id = 20569, Value = 100, ConditionPoids = 21}]]}

ID_TO_STAT_NAME = openFile("C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Assets\\idToStatName.json")


PoidsByStat = {
    ["Vitalite"] = {PoidsUnite = 0.2, Runes = {{Id = 1523, Poids = 1, Value = 5}, {Id = 1548, Poids = 3, Value = 15}, {Id = 1554, Poids = 10, Value = 50}}},
    ["Force"] = {PoidsUnite = 1, Runes = {{Id = 1519, Poids = 1, Value = 1}, {Id = 1545, Poids = 3, Value = 3}, {Id = 1551, Poids = 10, Value = 10}}},
    ["Chance"] = {PoidsUnite = 1, Runes = {{Id = 1525, Poids = 1, Value = 1}, {Id = 1550, Poids = 3, Value = 3}, {Id = 1556, Poids = 10, Value = 10}}},
    ["Agilité"] = {PoidsUnite = 1, Runes = {{Id = 1524, Poids = 1, Value = 1}, {Id = 1549, Poids = 3, Value = 3}, {Id = 1555, Poids = 10, Value = 10}}},
    ["Intelligence"] = {PoidsUnite = 1, Runes = {{Id = 1522, Poids = 1, Value = 1}, {Id = 1547, Poids = 3, Value = 3}, {Id = 1553, Poids = 10, Value = 10}}},
    ["Initiative"] = {PoidsUnite = 0.1, Runes = {{Id = 7448, Poids = 1, Value = 10}, {Id = 7449, Poids = 3, Value = 30}, {Id = 7450, Poids = 10, Value = 100}}},
    ["Sagesse"] = {PoidsUnite = 3, Runes = {{Id = 1521, Poids = 3, Value = 1}, {Id = 1546, Poids = 9, Value = 3}, {Id = 1552, Poids = 30, Value = 10}}},
    ["Prospection"] = {PoidsUnite = 3, Runes = {{Id = 7451, Poids = 3, Value = 1}, {Id = 10662, Poids = 9, Value = 3}}},
    ["Puissance"] = {PoidsUnite = 2, Runes = {{Id = 7436, Poids = 2, Value = 1}, {Id = 10618, Poids = 6, Value = 3}, {Id = 10619, Poids = 20, Value = 10}}},

    ["Resistance Feu"] = {PoidsUnite = 2, Runes = {{Id = 7452, Poids = 2, Value = 1}}},
    ["Resistance Air"] = {PoidsUnite = 2, Runes = {{Id = 7453, Poids = 2, Value = 1}}},
    ["Resistance Eau"] = {PoidsUnite = 2, Runes = {{Id = 7454, Poids = 2, Value = 1}}},
    ["Resistance Terre"] = {PoidsUnite = 2, Runes = {{Id = 7455, Poids = 2, Value = 1}}},
    ["Resistance Neutre"] = {PoidsUnite = 2, Runes = {{Id = 7456, Poids = 2, Value = 1}}},
    ["% Resistance Feu"] = {PoidsUnite = 6, Runes = {{Id = 7457, Poids = 6, Value = 1}}},
    ["% Resistance Air"] = {PoidsUnite = 6, Runes = {{Id = 7458, Poids = 6, Value = 1}}},
    ["% Resistance Eau"] = {PoidsUnite = 6, Runes = {{Id = 7560, Poids = 6, Value = 1}}},
    ["% Resistance Terre"] = {PoidsUnite = 6, Runes = {{Id = 7459, Poids = 6, Value = 1}}},
    ["% Resistance Neutre"] = {PoidsUnite = 6, Runes = {{Id = 7460, Poids = 6, Value = 1}}},

    ["Resistance Poussee"] = {PoidsUnite = 2, Runes = {{Id = 11651, Poids = 2, Value = 1},{Id = 11652, Poids = 6, Value = 3}}},
    ["Resistance Critiques"] = {PoidsUnite = 2, Runes = {{Id = 11655, Poids = 2, Value = 1}, {Id = 11656, Poids = 6, Value = 3}}},

    ["Esquive PA"] = {PoidsUnite = 7, Runes = {{Id = 11641, Poids = 7, Value = 1}, {Id = 11642, Poids = 21, Value = 3}}},
    ["Esquive PM"] = {PoidsUnite = 7, Runes = {{Id = 11643, Poids = 7, Value = 1}, {Id = 11644, Poids = 21, Value = 3}}},
    ["Retrait PM"] = {PoidsUnite = 7, Runes = {{Id = 11647, Poids = 7, Value = 1}, {Id = 11648, Poids = 21, Value = 3}}},
    ["Retrait PA"] = {PoidsUnite = 7, Runes = {{Id = 11645, Poids = 7, Value = 1}, {Id = 11646, Poids = 21, Value = 3}}},
    ["Pods"] = {PoidsUnite = 0.25, Runes = {{Id = 7443, Poids = 2,5, Value = 10}, {Id = 7444, Poids = 7,5, Value = 30}, {Id = 7445, Poids = 25, Value = 100}}},
    ["Tacle"] = {PoidsUnite = 4, Runes = {{Id = 11639, Poids = 4, Value = 1}, {Id = 11640, Poids = 12, Value = 3}}},
    ["Fuite"] = {PoidsUnite = 4, Runes = {{Id = 11637, Poids = 4, Value = 1}, {Id = 11638, Poids = 12, Value = 3}}},

    ["Dommages"] = {PoidsUnite = 20, Runes = {{Id = 7435, Poids = 20, Value = 1}}},
    ["Dommages Neutre"] = {PoidsUnite = 5, Runes = {{Id = 11665, Poids = 5, Value = 1}, {Id = 11666, Poids = 15, Value = 3}}},
    ["Dommages Feu"] = {PoidsUnite = 5, Runes = {{Id = 11659, Poids = 5, Value = 1}, {Id = 11660, Poids = 15, Value = 3}}},
    ["Dommages Eau"] = {PoidsUnite = 5, Runes = {{Id = 11661, Poids = 5, Value = 1}, {Id = 11662, Poids = 15, Value = 3}}},
    ["Dommages Air"] = {PoidsUnite = 5, Runes = {{Id = 11663, Poids = 5, Value = 1}, {Id = 11664, Poids = 15, Value = 3}}},
    ["Dommages Terre"] = {PoidsUnite = 5, Runes = {{Id = 11657, Poids = 5, Value = 1}, {Id = 11658, Poids = 15, Value = 3}}},

    ["Dommages Critiques"] = {PoidsUnite = 5, Runes = {{Id = 11653, Poids = 5, Value = 1}, {Id = 11654, Poids = 15, Value = 3}}},
    ["Dommages Pieges"] = {PoidsUnite = 5, Runes = {{Id = 7446, Poids = 5, Value = 1}, {Id = 10613, Poids = 15, Value = 3}}},
    ["Dommages Poussee"] = {PoidsUnite = 5, Runes = {{Id = 11649, Poids = 5, Value = 1}, {Id = 11650, Poids = 15, Value = 3}}},

    ["Puissance Pieges"] = {PoidsUnite = 2, Runes = {{Id = 7447, Poids = 2, Value = 1}, {Id = 10615, Poids = 6, Value = 3}, {Id = 10616, Poids = 20, Value = 10}}},
    ["Soins"] = {PoidsUnite = 10, Runes = {{Id = 7434, Poids = 10, Value = 1}, {Id = 19337, Poids = 30, Value = 3}}},
    ["% Critique"] = {PoidsUnite = 10, Runes = {{Id = 7433, Poids = 10, Value = 1}}},
    ["Renvoie dommages"] = {PoidsUnite = 10, Runes = {{Id = 7437, Poids = 10, Value = 1}}},

    ["Invocations"] = {PoidsUnite = 30, Runes = {{Id = 7442, Poids = 30, Value = 1}}},
    ["Portee"] = {PoidsUnite = 51, Runes = {{Id = 7438, Poids = 51, Value = 1}}},
    ["PA"] = {PoidsUnite = 100, Runes = {{Id = 1557, Poids = 100, Value = 1}}},
    ["PM"] = {PoidsUnite = 90, Runes = {{Id = 1558, Poids = 90, Value = 1}}},

    ["% Dommages distance"] = {PoidsUnite = 15, Runes = {{Id = 18720, Poids = 15, Value = 1}}},
    ["% Dommages aux sorts"] = {PoidsUnite = 15, Runes = {{Id = 18722, Poids = 15, Value = 1}}},
    ["% Dommages armes"] = {PoidsUnite = 15, Runes = {{Id = 18721, Poids = 15, Value = 1}}},
    ["% Dommages melee"] = {PoidsUnite = 15, Runes = {{Id = 18719, Poids = 15, Value = 1}}},
    ["% Resistance distance"] = {PoidsUnite = 15, Runes = {{Id = 18724, Poids = 15, Value = 1}}},
    ["% Resistance melee"] = {PoidsUnite = 15, Runes = {{Id = 18723, Poids = 15, Value = 1}}},
}

CoefMiniByCarac = {
    ["Vitalite"] = 0.95,
    ["Chance"] = 0.93,
    ["Intelligence"] = 0.93,
    ["Force"] = 0.93,
    ["Agilité"] = 0.93,
    ["% Resistance Neutre"] = 1,
    ["% Resistance Terre"] = 1,
    ["% Resistance Feu"] = 1,
    ["% Resistance Eau"] = 1,
    ["% Resistance Air"] = 1,
    ["% Critique"] = 1,
    ["Puissance"] = 0.9,
}

STATS_TO_IGNORE = {
    "Resistance Neutre",
    "Resistance Terre",
    "Resistance Feu",
    "Resistance Eau",
    "Resistance Air",
    "Resistance Poussee",
    "Fuite",
    "Tacle",
    "Soins",
    "Prospection",
    "Puissance Pieges",
    "Dommages Pieges",
    "Pods"
}

TABLE_OUTIL_ATELIER = {
    ["Cape"] = {ElementId = 523886, FMElementId = 521411, FMRep = -1},
    ["Sac à dos"] = {ElementId = 523886, FMElementId = 521411, FMRep = -1},
    ["Chapeau"] = {ElementId = 523886, FMElementId = 521411, FMRep = -1},
    ["Amulette"] = {ElementId = 521672, FMElementId = 523832, FMRep = -1},
    ["Anneau"] = {ElementId = 521672, FMElementId = 523832, FMRep = -1},
    ["Bottes"] = {ElementId = 521402, FMElementId = 521412, FMRep = -1},
    ["Ceinture"] = {ElementId = 521402, FMElementId = 521412, FMRep = -1},
    ["Dague"] = {ElementId = 524084, FMElementId = 521410, FMRep = -2},
    ["Marteau"] = {ElementId = 524084, FMElementId = 521410, FMRep = -2},
    ["Épée"] = {ElementId = 524084, FMElementId = 521410, FMRep = -2},
    ["Pelle"] = {ElementId = 524084, FMElementId = 521410, FMRep = -2},
    ["Hache"] = {ElementId = 524084, FMElementId = 521410, FMRep = -2},
    ["Bâton"] = {ElementId = 521432, FMElementId = 521410, FMRep = -1},
    ["Baguette"] = {ElementId = 521432, FMElementId = 521410, FMRep = -1},
    ["Arc"] = {ElementId = 521432, FMElementId = 521410, FMRep = -1},
    ["Potion"] = {ElementId = 455659, Rep = -1},
    ["Bouclier"] = {ElementId = 489581},
    ["Trophet"] = {ElementId = 463613},
    ["Prysmaradite"] = {ElementId = 517999},
}

PrixHdvAllRessources = {}


PHENIX = {
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) map:changeMap("havenbag") end},
		{map = "22,22", custom = function() map:door(387) map:changeMap("havenbag") end},
		{map = "9,16", path = "right"},
		{map = "10,16", path = "right"},
		{map = "11,16", path = "right"},
		{map = "12,16", path = "right"},
		{map = "13,16", path = "top"},
		{map = "13,15", path = "top"},
		{map = "13,14", path = "top"},
		{map = "13,13", path = "top"},
		{map = "13,12", path = "left"},
		{map = "12,12", custom = function() map:door(184) map:changeMap("havenbag") end},
		{map = "-68,-43", path = "right"},
		{map = "-67,-43", path = "top"},
		{map = "-67,-44", custom = function() map:door(219) map:changeMap("havenbag") end},
		{map = "-16,41", path = "top"},
		{map = "-16,40", path = "top"},
		{map = "-16,39", path = "top"},
		{map = "-16,38", path = "top"},
		{map = "-16,37", path = "top"},
		{map = "-13,28", path = "right"},
		{map = "-17,41", path = "right"},
		{map = "-16,36", custom = function() map:door(135) map:changeMap("havenbag") end},
		{map = "-9,-54", path = "left"},
		{map = "-10,-54", custom = function() map:door(342) map:changeMap("havenbag") end},
		{map = "23330816", path = "bottom"},
		{map = "159769", path = "left"},
		{map = "-57,25", path = "left"},
		{map = "-58,24", path = "top"},
		{map = "-58,25", path = "top"},
		{map = "-58,23", path = "top"},
		{map = "-58,22", path = "top"},
		{map = "-58,21", path = "top"},
		{map = "-58,20", path = "top"},
		{map = "-58,19", path = "top"},
		{map = "-58,18", custom = function() map:door(354) map:changeMap("right") end},
		{map = "-43,0", custom = function() map:door(259) map:changeMap("bottom") end},

		{map = "-3,-13", path = "right"},
        {map = "-2,-13", path = "right"},
        {map = "-1,-13", path = "right"},
        {map = "0,-13", path = "right"},
        {map = "1,-13", path = "right"},
        {map = "2,-13", path = "top"},
        {map = "2,-14", custom = function ()
			map:door(313)
			map:changeMap("top")
        end},
                {map = "35,-42", path = "bottom"},
        {map = "35,-41", path = "bottom"},
        {map = "35,-40", custom = function() map:door(306) map:changeMap("havenbag") end},
        {map = "146800640", custom = function() map:door(200) map:door(333) end},
        {map = "34472966", path = "432"},
        {map = "-40,-16", path = "left"},
        {map = "-41,-16", path = "left"},
        {map = "-42,-16", path = "left"},
        {map = "-43,-17", path = "top"},
        {map = "-43,-18", path = "top"},
        {map = "-43,-19", custom = function() map:door(271) map:changeMap("havenbag") end},

	}


TABLE_VENTE_PL = {
	{Name = "Plume de Piou Rouge", Id = 6900, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Jaune", Id = 6902, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Vert", Id = 6899, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Bleu", Id = 6897, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Violet", Id = 6898, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Plume de Piou Rose", Id = 6903, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Œil d'Arakmuté", Id = 2491, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils d'Arakne Malade", Id = 388, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Intestin d'Araknosé", Id = 373, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Bec du Tofu", Id = 366, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Conque Marine", Id = 13726, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Crème à bronzer", Id = 13727, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},


	{Name = "Peau de Larve Bleue", Id = 362, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Orange", Id = 363, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Verte", Id = 364, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Peau de Larve Jaune", Id = 2563, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},

	{Name = "Crocs de Rats", Id = 2322, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},
	{Name = "Cuir de Scélérat Strubien", Id = 304, CanSell = false, MaxHdv100 = 3, MaxHdv10 = 3},

	{Name = "Noisette", Id = 394, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Étoffe d'Écurouille", Id = 653, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils du Milimulou", Id = 1690, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Scalp de Milimulou", Id = 2576, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Pic du Prespic", Id = 407, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Queue de Prespic", Id = 2573, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Poils Darits", Id = 1672, CanSell = false, MaxHdv100 = 1, MaxHdv10 = 2},
	{Name = "Groin de Sanglier", Id = 386, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Défense du Sanglier", Id = 387, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Étoffe du Sanglier", Id = 652, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Viande Intangible", Id = 16663, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande Hachée", Id = 17123, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande faisandée", Id = 17124, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},
	{Name = "Viande Frelatée", Id = 17126, CanSell = false, MaxHdv100 = 5, MaxHdv10 = 3},

	-- {Name = "Eklame Inférieur", Id = 31518, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

	{Name = "Petale de rose demoniaque", Id = 309, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},
	{Name = "Fil de soie", Id = 643, CanSell = false, MaxHdv100 = 2, MaxHdv10 = 2},

}



GO_BANK_ASTRUB = {
    {map = "0,0", path = "zaap(191105026)"},
    {map = "191104002", door = "288"},
    {map = "-5,-27", path = "right"},
    {map = "-5,-26", path = "right"},
    {map = "-5,-25", path = "right"},
    {map = "-5,-24", path = "right"},
    {map = "-5,-23", path = "right"},
    {map = "-5,-22", path = "right"},
    {map = "-5,-21", path = "right"},
    {map = "-5,-20", path = "right"},
    {map = "-5,-19", path = "right"},
    {map = "-5,-18", path = "right"},
    {map = "-5,-17", path = "right"},
    {map = "-5,-16", path = "right"},
    {map = "-4,-16", path = "right"},
    {map = "-4,-17", path = "right"},
    {map = "-4,-18", path = "right"},
    {map = "-4,-19", path = "right"},
    {map = "-4,-20", path = "right"},
    {map = "-4,-21", path = "right"},
    {map = "-4,-22", path = "right"},
    {map = "-4,-23", path = "right"},
    {map = "-4,-24", path = "right"},
    {map = "-4,-25", path = "right"},
    {map = "-4,-26", path = "right"},
    {map = "-4,-27", path = "right"},
    {map = "-3,-27", path = "right"},
    {map = "-3,-26", path = "right"},
    {map = "-3,-25", path = "right"},
    {map = "-3,-24", path = "right"},
    {map = "-3,-23", path = "right"},
    {map = "-3,-22", path = "right"},
    {map = "-3,-21", path = "right"},
    {map = "-3,-20", path = "right"},
    {map = "-3,-19", path = "right"},
    {map = "-3,-18", path = "right"},
    {map = "-3,-16", path = "right"},
    {map = "-3,-17", path = "right"},
    {map = "-2,-16", path = "right"},
    {map = "-2,-17", path = "right"},
    {map = "-2,-18", path = "right"},
    {map = "-2,-19", path = "right"},
    {map = "-2,-20", path = "right"},
    {map = "-2,-21", path = "right"},
    {map = "-2,-22", path = "right"},
    {map = "-2,-23", path = "right"},
    {map = "-2,-24", path = "right"},
    {map = "-2,-25", path = "right"},
    {map = "-2,-26", path = "right"},
    {map = "-2,-27", path = "right"},
    {map = "-1,-27", path = "right"},
    {map = "-1,-26", path = "right"},
    {map = "-1,-25", path = "right"},
    {map = "-1,-23", path = "right"},
    {map = "-1,-24", path = "right"},
    {map = "-1,-22", path = "right"},
    {map = "-1,-21", path = "right"},
    {map = "-1,-20", path = "right"},
    {map = "-1,-19", path = "right"},
    {map = "-1,-18", path = "right"},
    {map = "-1,-17", path = "right"},
    {map = "-1,-16", path = "right"},
    {map = "0,-16", path = "right"},
    {map = "0,-17", path = "right"},
    {map = "0,-18", path = "right"},
    {map = "-3,-15", path = "right"},
    {map = "-2,-15", path = "right"},
    {map = "-1,-15", path = "right"},
    {map = "0,-15", path = "right"},
    {map = "-3,-14", path = "right"},
    {map = "-2,-14", path = "right"},
    {map = "-1,-14", path = "right"},
    {map = "0,-14", path = "right"},
    {map = "0,-19", path = "right"},
    {map = "0,-20", path = "right"},
    {map = "0,-21", path = "right"},
    {map = "0,-22", path = "right"},
    {map = "0,-23", path = "right"},
    {map = "0,-24", path = "right"},
    {map = "0,-25", path = "right"},
    {map = "0,-26", path = "right"},
    {map = "0,-27", path = "right"},
    {map = "1,-27", path = "right"},
    {map = "1,-26", path = "right"},
    {map = "1,-25", path = "right"},
    {map = "1,-24", path = "right"},
    {map = "1,-23", path = "right"},
    {map = "1,-22", path = "right"},
    {map = "1,-14", path = "right"},
    {map = "1,-15", path = "right"},
    {map = "1,-16", path = "right"},
    {map = "1,-17", path = "right"},
    {map = "1,-18", path = "right"},
    {map = "1,-19", path = "right"},
    {map = "1,-20", path = "right"},
    {map = "1,-21", path = "right"},
    {map = "2,-24", path = "right"},
    {map = "2,-23", path = "right"},
    {map = "2,-22", path = "right"},
    {map = "3,-22", path = "right"},
    {map = "3,-23", path = "right"},
    {map = "3,-24", path = "right"},
    {map = "3,-21", path = "right"},
    {map = "3,-20", path = "right"},
    {map = "4,-27", path = "bottom"},
    {map = "4,-26", path = "bottom"},
    {map = "4,-25", path = "bottom"},
    {map = "4,-24", path = "bottom"},
    {map = "4,-23", path = "bottom"},
    {map = "4,-22", path = "bottom"},
    {map = "4,-21", path = "bottom"},
    {map = "4,-20", path = "bottom"},
    {map = "4,-19", path = "bottom"},
    {map = "3,-25", path = "bottom"},
    {map = "3,-26", path = "bottom"},
    {map = "3,-27", path = "bottom"},
    {map = "2,-27", path = "bottom"},
    {map = "2,-26", path = "bottom"},
    {map = "2,-25", path = "bottom"},
    {map = "2,-20", path = "bottom"},
    {map = "2,-21", path = "right"},
    {map = "2,-19", path = "bottom"},
    {map = "2,-14", path = "right"},
    {map = "3,-14", path = "right"},
    {map = "2,-15", path = "right"},
    {map = "3,-15", path = "right"},
    {map = "2,-16", path = "right"},
    {map = "3,-16", path = "right"},
    {map = "2,-18", path = "right"},
    {map = "3,-18", path = "right"},
    {map = "3,-17", path = "right"},
    {map = "3,-19", path = "right"},
    {map = "4,-14", path = "right"},
    {map = "4,-15", path = "right"},
    {map = "4,-16", path = "right"},
    {map = "5,-14", path = "top"},
    {map = "5,-15", path = "top"},
    {map = "5,-16", path = "top"},
    {map = "6,-14", path = "top"},
    {map = "7,-14", path = "top"},
    {map = "7,-15", path = "top"},
    {map = "7,-16", path = "top"},
    {map = "7,-17", path = "top"},
    {map = "5,-27", path = "left"},
    {map = "5,-26", path = "left"},
    {map = "5,-25", path = "left"},
    {map = "5,-24", path = "left"},
    {map = "5,-23", path = "left"},
    {map = "5,-22", path = "left"},
    {map = "6,-22", path = "left"},
    {map = "6,-23", path = "left"},
    {map = "6,-24", path = "left"},
    {map = "6,-26", path = "left"},
    {map = "6,-27", path = "left"},
    {map = "6,-25", path = "left"},
    {map = "7,-27", path = "left"},
    {map = "7,-26", path = "left"},
    {map = "7,-25", path = "left"},
    {map = "7,-24", path = "left"},
    {map = "7,-23", path = "left"},
    {map = "7,-22", path = "left"},
    {map = "7,-21", path = "left"},
    {map = "6,-21", path = "left"},
    {map = "5,-21", path = "left"},
    {map = "7,-20", path = "left"},
    {map = "6,-20", path = "left"},
    {map = "5,-20", path = "left"},
    {map = "7,-18", path = "left"},
    {map = "6,-18", path = "left"},
    {map = "6,-15", path = "left"},
    {map = "6,-16", path = "left"},
    {map = "6,-17", path = "left"},
    {map = "6,-19", path = "left"},
    {map = "5,-18", path = "left"},
    {map = "5,-19", path = "left"},
    {map = "4,-17", path = "top"},
    {map = "7,-19", path = "top"},
}