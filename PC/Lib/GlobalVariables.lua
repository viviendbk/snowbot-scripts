NB_BUCHERON = 5
NB_MINEUR = 5
NB_LVLUP = 5
NB_COMBAT = 5
NB_CRAFT = 2
NB_GROUPE = 3

bankMaps = {
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

ipproxy = "193.252.210.41"

ServersMulti = {
    "Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Rafal", "Salar", "Brial"
}

ServersMono = {
    "Draconiros", "Dakal", "Kourial", "Mikhal"
}

AllServers = merge(ServersMulti, ServersMono)

MapSansHavreSac = {
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


IdWithCaracName = {
    {
        Id = 111,
        Name = "PA"
    },
    {
        Id = 168,
        Name = "-PA"
    },
    {
        Id = 128,
        Name = "PM"
    },
    {
        Id = 169,
        Name = "-PM"
    },
    {
        Id = 117,
        Name = "Portee"
    },
    {
        Id = 116,
        Name = "-Portee"
    },
    {
        Id = 182,
        Name = "Invocations"
    },
    {
        Id = 112,
        Name = "Dommages"
    },
    {
        Id = 145,
        Name = "-Dommages"
    },
    {
        Id = 2804,
        Name = "% Dommages distance"
    },
    {
        Id = 2805,
        Name = "-% Dommages distance"
    },
    {
        Id = 2807,
        Name = "% Resistance distance"
    },
    {
        Id = 2806,
        Name = "-% Resistance distance"
    },
    {
        Id = 2812,
        Name = "% Dommages aux sorts"
    },
    {
        Id = 2813,
        Name = "-% Dommages aux sorts"
    },
    {
        Id = 2808,
        Name = "% Dommages armes"
    },
    {
        Id = 2809,
        Name = "-% Dommages armes"
    },
    {
        Id = 2800,
        Name = "% Dommages melee"
    },
    {
        Id = 2801,
        Name = "-% Dommages melee"
    },
    {
        Id = 2803,
        Name = "% Resistance melee"
    },
    {
        Id = 2802,
        Name = "-% Resistance melee"
    },
    {
        Id = 115,
        Name = "% Critique"
    },
    {
        Id = 171,
        Name = "-% Critique"
    },
    {
        Id = 178,
        Name = "Soins"
    },
    {
        Id = 179,
        Name = "-Soins"
    },
    {
        Id = 220,
        Name = "Renvoie dommages"
    },
    {
        Id = 410,
        Name = "Retrait PA"
    },
    {
        Id = 411,
        Name = "-Retrait PA"
    },
    {
        Id = 412,
        Name = "Retrait PM"
    },
    {
        Id = 413,
        Name = "-Retrait PM"
    },
    {
        Id = 160,
        Name = "Esquive PA"
    },
    {
        Id = 162,
        Name = "-Esquive PA"
    },
    {
        Id = 161,
        Name = "Esquive PM"
    },
    {
        Id = 163,
        Name = "-Esquive PM"
    },
    {
        Id = 214,
        Name = "% Resistance Neutre"
    },
    {
        Id = 219,
        Name = "-% Resistance Neutre"
    },
    {
        Id = 210,
        Name = "% Resistance Terre"
    },
    {
        Id = 215,
        Name = "-% Resistance Terre"
    },
    {
        Id = 211,
        Name = "% Resistance Eau"
    },
    {
        Id = 216,
        Name = "-% Resistance Eau"
    },
    {
        Id = 212,
        Name = "% Resistance Air"
    },
    {
        Id = 217,
        Name = "-% Resistance Air"
    },
    {
        Id = 213,
        Name = "% Resistance Feu"
    },
    {
        Id = 218,
        Name = "-% Resistance Feu"
    },
    {
        Id = 424,
        Name = "Dommages Feu"
    },
    {
        Id = 425,
        Name = "-Dommages Feu"
    },
    {
        Id = 428,
        Name = "Dommages Air"
    },
    {
        Id = 429,
        Name = "-Dommages Air"
    },
    {
        Id = 426,
        Name = "Dommages Eau"
    },
    {
        Id = 427,
        Name = "-Dommages Eau"
    },
    {
        Id = 430,
        Name = "Dommages Neutre"
    },
    {
        Id = 431,
        Name = "-Dommages Neutre"
    },
    {
        Id = 422,
        Name = "Dommages Terre"
    },
    {
        Id = 423,
        Name = "-Dommages Terre"
    },
    {
        Id = 418,
        Name = "Dommages Critiques"
    },
    {
        Id = 419,
        Name = "-Dommages Critiques"
    },
    {
        Id = 225,
        Name = "Dommages Pieges"
    },
    {
        Id = 414,
        Name = "Dommages Poussee"
    },
    {
        Id = 415,
        Name = "-Dommages Poussee"
    },
    {
        Id = 752,
        Name = "Fuite"
    },
    {
        Id = 754,
        Name = "-Fuite"
    },
    {
        Id = 753,
        Name = "Tacle"
    },
    {
        Id = 755,
        Name = "-Tacle"
    },
    {
        Id = 124,
        Name = "Sagesse"
    },
    {
        Id = 156,
        Name = "-Sagesse"
    },
    {
        Id = 176,
        Name = "Prospection"
    },
    {
        Id = 177,
        Name = "-Prospection"
    },
    {
        Id = 158,
        Name = "Pods"
    },
    {
        Id = 159,
        Name = "-Pods"
    },
    {
        Id = 242,
        Name = "Resistance Air"
    },
    {
        Id = 247,
        Name = "-Resistance Air"
    },
    {
        Id = 243,
        Name = "Resistance Feu"
    },
    {
        Id = 248,
        Name = "-Resistance Feu"
    },
    {
        Id = 244,
        Name = "Resistance Neutre"
    },
    {
        Id = 249,
        Name = "-Resistance Neutre"
    },
    {
        Id = 241,
        Name = "Resistance Eau"
    },
    {
        Id = 246,
        Name = "-Resistance Eau"
    },
    {
        Id = 240,
        Name = "Resistance Terre"
    },
    {
        Id = 245,
        Name = "-Resistance Terre"
    },
    {
        Id = 226,
        Name = "Puissance Pieges"
    },
    {
        Id = 420,
        Name = "Resistance Critiques"
    },
    {
        Id = 421,
        Name = "-Resistance Critiques"
    },
    {
        Id = 416,
        Name = "Resistance Poussee"
    },
    {
        Id = 417,
        Name = "-Resistance Poussee"
    },
    {
        Id = 138,
        Name = "Puissance"
    },
    {
        Id = 186,
        Name = "-Puissance"
    },
    {
        Id = 118,
        Name = "Force"
    },
    {
        Id = 157,
        Name = "-Force"
    },
    {
        Id = 119,
        Name = "Agilité"
    },
    {
        Id = 154,
        Name = "-Agilité"
    },
    {
        Id = 123,
        Name = "Chance"
    },
    {
        Id = 152,
        Name = "-Chance"
    },
    {
        Id = 125,
        Name = "Vitalite"
    },
    {
        Id = 153,
        Name = "-Vitalite"
    },
    {
        Id = 126,
        Name = "Intelligence"
    },
    {
        Id = 155,
        Name = "-Intelligence"
    },
    {
        Id = 174,
        Name = "Initiative"
    },
    {
        Id = 175,
        Name = "-Initiative"
    },
    {
        Id = 100,
        Name = "Degats Neutre"
    },
    {
        Id = 98,
        Name = "Degats Air"
    },
    {
        Id = 96,
        Name = "Degats Eau"
    },
    {
        Id = 99,
        Name = "Degats Feu"
    },
    {
        Id = 97,
        Name = "Degats Terre"
    },
    {
        Id = 2862,
        Name = "Legendaire" -- a verifier le nom en jeu
    }
}

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

StatsToIgnore = {
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

TableOutilAtelier = {
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
    ["Idole"] = {ElementId = 490231},
    ["Bouclier"] = {ElementId = 489581},
    ["Trophet"] = {ElementId = 463613},
    ["Prysmaradite"] = {ElementId = 517999},
}

PrixHdvAllRessources = {}


Phenix = {
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
			map:changeMap("havenbag")
        end},
                {map = "35,-42", path = "bottom"},
        {map = "35,-41", path = "bottom"},
        {map = "35,-40", custom = function() map:door(306) map:changeMap("havenbag") end},
        {map = "146800640", custom = function() map:door(200) map:door(333) end}

	}