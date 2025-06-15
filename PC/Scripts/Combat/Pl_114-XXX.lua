---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")
---- Options ----
MAX_MONSTERS = 8
MIN_MONSTERS = 2
FORBIDDEN_MONSTERS = {5308, 5309, 5311, 5313, 5073} -- Monstres a eviter

AUTO_DELETE = {9379, 9380, 9472, 367, 375, 16828, 13435, 11134, 2549 ,16826, 6926, 6929, 6908, 6928, 792, 16358, 16824, 398, 1672, 16835, 2302, 2303, 464, 16835, 8518, 2583, 463, 437, 1690, 2573, 407, 387, 386, 435, 434, 2576, 16830, 6910, 6909, 652, 6910, 16825, 16825, 2414, 2422, 383 , 2455 , 16819 , 1731 , 6921 , 6920 , 6919 , 6922 , 911 , 2419 ,2428 , 2425 , 2416 , 2411 , 892 ,16832 , 6794 , 6792 , 6796 , 8247,16829,8245,8248,8246,8223,8229,8217,8236,8241, 417, 384, 2858, 679, 16827, 16823, 380, 994, 995, 993, 311, 16833, 2585, 381, 1528, 1529, 1526, 1527, }
-- MAPS ET ACTIONS --

AMOUNT_MONSTERS = {{1070, 0, 2}}
--PLANNING = {3, 4, 8, 9, 13, 14, 18, 19, 23}

-- if global:thisAccountController():getAlias():find("LvlUp ") then
--     PLANNING = {17, 18 , 19, 20, 21, 22, 23}
-- else
--     PLANNING = {9, 10, 11, 12, 13, 14, 15}
-- end

local lancable = 0
local incrementation = 0
local hdv_door_id = 218
local cptActualiser = 1
local stringalias = nil
local levelToReach = 0
local debutDeScript = true

local tableBestSortZone3PA = {
	{
		func = Decimation,
		voie = "terre"
	},
	{
		func = Nervosite,
		voie = "eau"
	},
	{
		func = Condensation,
		voie = "eau"
	},
	{
		func = Stase,
		voie = "eau"
	},
}

local tableBestSortZone4PA = {
	{
		func = Dissolution,
		voie = "eau"
	},
	{
		func = BainDeSang,
		voie = "terre"
	},
}

local function computePriority(entities, voie)

	-- global:printSuccess(voie)
	local toReturn = 0
	if #entities > 0 then
		for _, entity in ipairs(entities) do
			if voie == "terre" then
				toReturn = -(entity.Stats.earthElementResistPercent / 100)
			elseif voie == "eau" then
				toReturn = -(entity.Stats.waterElementResistPercent / 100)
			end
		end
	end
	-- global:printSuccess("fin " .. voie)
	return toReturn
end


local function computeBestSort()
	tableBestSortZone3PA = {
		{
			func = Decimation,
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12731, WeakerMonsterAdjacent(), 1, false),
			voie = "terre",
		},
		{
			func = Nervosite,
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12727, WeakerMonsterAdjacent(), 4, false),
			voie = "eau",
		},
		{
			func = Condensation,
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12745, WeakerMonsterAdjacent(), 4, true),
			voie = "eau",
		},
		{
			func = Stase,
			entitiesInZone = (fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12728, fightAction:getNearestEnemy()) == 0) and {GetMonsterInCellId(fightAction:getNearestEnemy())} or {},
			voie = "eau",
		},
	}	

	tableBestSortZone4PA = {
		{
			func = Dissolution,
			voie = "eau",
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12757, WeakerMonsterAdjacent(), 5, false),
		},
		{
			func = BainDeSang,
			voie = "terre",
			entitiesInZone = getEntitiesInZone(fightCharacter:getCellId(), 12732, fightCharacter:getCellId(), 0, false),
		},
	}

	-- Now compute the priority for each entry
	for _, entry in ipairs(tableBestSortZone3PA) do
		entry.priority = computePriority(entry.entitiesInZone, entry.voie)
	end
	for _, entry in ipairs(tableBestSortZone4PA) do
		entry.priority = computePriority(entry.entitiesInZone, entry.voie)
	end
	-- If Stase needs a different priority adjustment
	tableBestSortZone3PA[3].priority = tableBestSortZone3PA[3].priority - 1

	table.sort(tableBestSortZone3PA, function(a,b) 
		if #a.entitiesInZone ~= #b.entitiesInZone then
			return #a.entitiesInZone > #b.entitiesInZone
		else
			return a.priority > b.priority
		end
	end)
	table.sort(tableBestSortZone4PA, function(a,b) 
		if #a.entitiesInZone ~= #b.entitiesInZone then
			return #a.entitiesInZone > #b.entitiesInZone
		else
			return a.priority > b.priority
		end
	end)
end

local function launchBestSort3pa()
	computeBestSort()

	-- for _, element in ipairs(tableBestSortZone3PA) do
	-- 	global:printSuccess(element.voie .. " " .. #element.entitiesInZone .. " " .. element.priority)
	-- end

	for _, element in ipairs(tableBestSortZone3PA) do
		-- global:printSuccess("test lancement " .. _ .. " " .. element.voie)
		if #element.entitiesInZone > 0 then
			element.func()
			break
		end
	end
end

local function launchBestSort4pa()
	computeBestSort()
	for _, element in ipairs(tableBestSortZone4PA) do
		if #element.entitiesInZone == 1 and fightAction:isHandToHand(fightCharacter:getCellId(), WeakerMonsterAdjacent()) then
			if fightAction:canCastSpellOnCell(fightCharacter:getCellId(), 12741, WeakerMonsterAdjacent()) then
				local PA = fightCharacter:getAP() -- le délais de relance est pas pris en compte
				Punition(WeakerMonsterAdjacent())
                if PA == fightCharacter:getAP() then
                    element.func()
                end
			else
				element.func()
			end
			break
		elseif #element.entitiesInZone > 1 then
			element.func()
			break
		end
	end
end

local tableEquip = {
	{Type = "coiffe", id = 8463, equipe = false, emplacement = 6},
	{Type = "amulette", id = 8465, equipe = false, emplacement = 0},
	{Type = "ceinture", id = 8468, equipe = false, emplacement = 3},
	{Type = "cape", id = 8464, equipe = false, emplacement = 7},
	{Type = "bottes", id = 8467, equipe = false, emplacement = 5},
	{Type = "arme", id = 250, equipe = false, emplacement = 1},
	{Type = "anneau gauche", id = 8466, equipe = false, emplacement = 2},
	{Type = "anneau droit", id = 2469, equipe = false, emplacement = 4},
	{Type = "bouclier", id = 18690, equipe = false, emplacement = 15},
	{Type = "trophet 1", id = 13748, equipe = false, emplacement = 9},
	{Type = "trophet 4", id = 13793, equipe = false, emplacement = 10},
	{name = "dofus cawotte", id = 972, equipe = false, emplacement = 11},
	{name = "dokoko", id = 17078, emplacement = 12, equipe = false},
    {name = "dofus argenté", id = 19629, emplacement = 13, equipe = false},
    {name = "dofus kaliptus", id = 8072, emplacement = 14, equipe = false},
	{name = "compagnon", id = 14966, equipe = false, emplacement = 28}
}

local tableEquipSasa = {
	{name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
	{name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
	{name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
	{name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
	{name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
	{name = "arme sasa", id = 478, emplacement = 1, equipe = false},
	{name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},
	{name = "gelano", id = 2469, emplacement = 4, equipe = false},
}

local list_idole = {
    {name = "dynamo", id_banque = 16864, id_message = 32, equipe = false},
    {name = "kyoub", id_banque = 16964, id_message = 98, equipe = false},
    {name = "leukide", id_banque = 16881, id_message = 46, equipe = false},
}


local tableVente = {
	{Name = "armée de tique", id = 2449, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 10, Total = 15, canSell = true, delete = false},
	{Name = "oeil de boufton", id = 2460, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "laine de boufton noir", id = 885, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "laine de bouftou", id = 384, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "laine du chef de guerre bouftou", id = 882, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "corne de chef de guerre bouftou", id = 2465, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "épine du champ champ", id = 377, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "sporme du champ champ", id = 378, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "pétale de rose démoniaque", id = 309, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "bave de rose démoniaque", id = 2662, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},

	{Name = "Métaria rouge", id = 1526, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria bleu", id = 1527, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria jaune", id = 1528, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria verte", id = 1529, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Rouge", id = 1465, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne de Scarafeuille Vert", id = 1466, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1467, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Fruit de Palme", id = 398, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},

	{Name = "Duvet de Tofoune", id = 8484, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Plume de Tofu", id = 301, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Cocon de Ver à Soie", id = 642, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 6, canSell = true, delete = false},
	{Name = "Patte de Tofukaz", id = 2571, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Estomac de Tofukaz", id = 2572, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œuf Pourri", id = 2673, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œil de Tofu Noir", id = 2579, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Tissu Sombre", id = 2285, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},

	{Name = "Pince de crabe", id = 379, maxHdv100 = 10, maxHdv10 = 15, maxHdv1 = 0, Total = 25, canSell = true, delete = false},
	{Name = "Paupière d'etoile", id = 13728, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Peau de raulmops", id = 8681, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},

	{Name = "Oeil de crabe hijacob", id = 11255, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Sternum de chachachovage", id = 11251, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Patte de rat bougri", id = 11252, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Bec de gélikan", id = 11256, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Plume de gélikan", id = 11257, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "pince de crabe hijacob", id = 11254, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "eau calme", id = 11475, maxHdv100 = 3, maxHdv10 = 5, Total = 8, maxHdv1 = 0, canSell = true, delete = false},	
	{Name = "Etoffe de rat bougri", id = 11253, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Poil de chachachovage", id = 11250, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},

	{Name = "Gelée bleutée", id = 757, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la fraise", id = 368, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la menthe", id = 369, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 0, Total = 7, canSell = true, delete = false},

	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1465, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Antenne du Scarafeuille Rouge", id = 1466, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Antenne du Scarafeuille Vert", id = 1467, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2290, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2291, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},

    {Name = "Pierre de saphir", id = 546, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre d'emeraude", id = 544, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre de rubis", id = 547, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre de cristal", id = 545, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf ardoise", id = 1129, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf ardoise", id = 844, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf argile", id = 842, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf argile", id = 845, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf calcaire", id = 308, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf calcaire", id = 847, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf charbon", id = 843, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf charbon", id = 846, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},

	--[[
	{Name = "Œil de Cocholou", id = 2578, maxHdv100 = 5, maxHdv10 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Testicules de Cocholou", id = 292, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Canine de Mergranlou", id = 439, maxHdv100 = 3, maxHdv10 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Mojo de Mergranlou", id = 8396, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Queue du Mulou", id = 438, maxHdv100 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Étoffe du Mulou", id = 651, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Poils de Mulounoké", id = 291, maxHdv100 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Scalp de Mulounoké", id = 2575, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	]]

	{Name = "Étoffe de Foufayteur", id = 2550, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Oreille de Foufayteur", id = 2551, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Ongle de Kanigrou", id = 2528, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Œil de Kanigrou", id = 2552, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Champignon", id = 290, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Fibre de Lin", id = 424, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Poil de Vétauran", id = 1890, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},

	{Name = "Aile du Bitouf des Plaines", id = 8767, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Coco du Bitouf des Plaines", id = 8769, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Boule polie", id = 8737, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Fragment de cerveau poli", id = 8762, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Cœur de pierre poli", id = 8736, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Plume de fesse du Kido", id = 8766, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Duvet du Kilibriss", id = 8756, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Bâton du Kilibriss", id = 8765, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Moustache du Mufafah", id = 8763, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Crinière fleurie", id = 8753, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
}

local tableValeurVente = {
	{Name = "armée de tique", id = 2449, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 10, Total = 15, canSell = true, delete = false},
	{Name = "oeil de boufton", id = 2460, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "laine de boufton noir", id = 885, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "laine de bouftou", id = 384, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "laine du chef de guerre bouftou", id = 882, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "corne de chef de guerre bouftou", id = 2465, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "épine du champ champ", id = 377, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "sporme du champ champ", id = 378, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},
	{Name = "pétale de rose démoniaque", id = 309, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, Total = 6, canSell = true, delete = false},
	{Name = "bave de rose démoniaque", id = 2662, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, Total = 6, canSell = true, delete = false},

	{Name = "Métaria rouge", id = 1526, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria bleu", id = 1527, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria jaune", id = 1528, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Métaria verte", id = 1529, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 2, Total = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Rouge", id = 1465, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne de Scarafeuille Vert", id = 1466, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1467, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Fruit de Palme", id = 398, maxHdv100 = 1, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 2, Total = 6, canSell = true, delete = false},

	{Name = "Duvet de Tofoune", id = 8484, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Plume de Tofu", id = 301, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Cocon de Ver à Soie", id = 642, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 6, canSell = true, delete = false},
	{Name = "Patte de Tofukaz", id = 2571, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Estomac de Tofukaz", id = 2572, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œuf Pourri", id = 2673, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œil de Tofu Noir", id = 2579, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Tissu Sombre", id = 2285, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},

	{Name = "Pince de crabe", id = 379, maxHdv100 = 10, maxHdv10 = 15, maxHdv1 = 0, Total = 25, canSell = true, delete = false},
	{Name = "Paupière d'etoile", id = 13728, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Peau de raulmops", id = 8681, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},

	{Name = "Oeil de crabe hijacob", id = 11255, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Sternum de chachachovage", id = 11251, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Patte de rat bougri", id = 11252, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Bec de gélikan", id = 11256, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Plume de gélikan", id = 11257, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "pince de crabe hijacob", id = 11254, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "eau calme", id = 11475, maxHdv100 = 3, maxHdv10 = 5, Total = 8, maxHdv1 = 0, canSell = true, delete = false},	
	{Name = "Etoffe de rat bougri", id = 11253, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Poil de chachachovage", id = 11250, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},

	{Name = "Gelée bleutée", id = 757, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la fraise", id = 368, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la menthe", id = 369, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 0, Total = 7, canSell = true, delete = false},

	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1465, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Antenne du Scarafeuille Rouge", id = 1466, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Antenne du Scarafeuille Vert", id = 1467, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2290, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2291, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
    {Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 5, Total = 10, canSell = true, delete = false},

    {Name = "Pierre de saphir", id = 546, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre d'emeraude", id = 544, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre de rubis", id = 547, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Pierre de cristal", id = 545, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf ardoise", id = 1129, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf ardoise", id = 844, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf argile", id = 842, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf argile", id = 845, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf calcaire", id = 308, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf calcaire", id = 847, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Coquille de dragoeuf charbon", id = 843, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
    {Name = "Oeuf de dragoeuf charbon", id = 846, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},

	--[[
	{Name = "Œil de Cocholou", id = 2578, maxHdv100 = 5, maxHdv10 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Testicules de Cocholou", id = 292, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Canine de Mergranlou", id = 439, maxHdv100 = 3, maxHdv10 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Mojo de Mergranlou", id = 8396, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Queue du Mulou", id = 438, maxHdv100 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Étoffe du Mulou", id = 651, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Poils de Mulounoké", id = 291, maxHdv100 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Scalp de Mulounoké", id = 2575, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	]]

	{Name = "Étoffe de Foufayteur", id = 2550, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Oreille de Foufayteur", id = 2551, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Ongle de Kanigrou", id = 2528, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Œil de Kanigrou", id = 2552, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Champignon", id = 290, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Fibre de Lin", id = 424, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, Total = 8, canSell = true, delete = false},
	{Name = "Poil de Vétauran", id = 1890, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},

	{Name = "Aile du Bitouf des Plaines", id = 8767, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Coco du Bitouf des Plaines", id = 8769, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Boule polie", id = 8737, maxHdv100 = 3, maxHdv10 = 5, maxHdv1 = 0, Total = 8, canSell = true, delete = false},
	{Name = "Fragment de cerveau poli", id = 8762, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Cœur de pierre poli", id = 8736, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Plume de fesse du Kido", id = 8766, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Duvet du Kilibriss", id = 8756, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Bâton du Kilibriss", id = 8765, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
	{Name = "Moustache du Mufafah", id = 8763, maxHdv100 = 5, maxHdv10 = 8, maxHdv1 = 0, Total = 13, canSell = true, delete = false},
	{Name = "Crinière fleurie", id = 8753, maxHdv100 = 0, maxHdv10 = 5, maxHdv1 = 8, Total = 13, canSell = true, delete = false},
}

local HautsHurlements = {
	{map = "0,0", path = "zaap(164364304)"},
	{map = "-20,-20", path = "bottom"},
	{map = "-20,-19", path = "bottom"},
	{map = "-20,-18", path = "bottom"},
	{map = "-20,-17", path = "bottom"},
	{map = "-20,-16", path = "bottom"},
	{map = "-20,-15", path = "bottom"},
	{map = "-20,-14", path = "bottom"},
	{map = "-20,-13", path = "bottom"},
	{map = "-20,-12", path = "bottom"},
	{map = "-20,-11", path = "left", fight = true},
	{map = "-21,-11", path = "left", fight = true},
	{map = "-22,-11", path = "left", fight = true},
	{map = "-23,-11", path = "left", fight = true},
	{map = "-24,-11", path = "left", fight = true},
	{map = "-25,-11", path = "left", fight = true},
	{map = "-26,-11", path = "left", fight = true},
	{map = "-27,-11", path = "left", fight = true},
	{map = "-28,-10", path = "right", fight = true},
	{map = "-27,-10", path = "right", fight = true},
	{map = "-26,-10", path = "right", fight = true},
	{map = "-25,-10", path = "right", fight = true},
	{map = "-24,-10", path = "right", fight = true},
	{map = "-23,-10", path = "right", fight = true},
	{map = "-22,-10", path = "bottom", fight = true},
	{map = "-22,-9", path = "left", fight = true},
	{map = "-23,-9", path = "left", fight = true},
	{map = "-24,-9", path = "left", fight = true},
	{map = "-25,-9", path = "left", fight = true},
	{map = "-26,-9", path = "left", fight = true},
	{map = "-27,-9", path = "left", fight = true},
	{map = "-28,-11", path = "bottom", fight = true},
	{map = "-28,-9", path = "bottom", fight = true},
	{map = "-28,-8", path = "left", fight = true},
	{map = "-29,-8", path = "bottom", fight = true},
	{map = "-29,-7", path = "right", fight = true},
	{map = "-28,-7", path = "right", fight = true},
	{map = "-27,-8", path = "right", fight = true},
	{map = "-25,-8", path = "right", fight = true},
	{map = "-26,-8", path = "right", fight = true},
	{map = "-24,-8", path = "right", fight = true},
	{map = "-22,-8", path = "bottom", fight = true},
	{map = "-23,-8", path = "right", fight = true},
	{map = "-22,-7", path = "left", fight = true},
	{map = "-27,-7", path = "top", fight = true},
	{map = "-23,-7", path = "left", fight = true},
	{map = "-24,-7", path = "left", fight = true},
	{map = "-25,-7", path = "left", fight = true},
	{map = "-26,-7", path = "bottom", fight = true},
	{map = "-26,-6", path = "right", fight = true},
	{map = "-25,-6", path = "right", fight = true},
	{map = "-24,-6", path = "right", fight = true},
	{map = "-23,-6", path = "bottom", fight = true},
	{map = "-23,-5", path = "left", fight = true},
	{map = "-25,-5", path = "left", fight = true},
	{map = "-24,-5", path = "left", fight = true},
	{map = "-26,-5", path = "bottom", fight = true},
	{map = "-26,-4", path = "bottom", fight = true},
	{map = "-26,-3", path = "bottom", fight = true},
	{map = "-26,-2", path = "left", fight = true},
	{map = "-27,-2", path = "left", fight = true},
	{map = "-28,-2", path = "bottom", fight = true},
	{map = "-28,-1", path = "left", fight = true},
	{map = "-29,-1", path = "bottom", fight = true},
	{map = "-29,0", path = "right", fight = true},
	{map = "-28,0", path = "right", fight = true},
	{map = "-26,0", path = "right", fight = true},
	{map = "-27,-1", path = "right", fight = true},
	{map = "-27,0", path = "top", fight = true},
	{map = "-26,-1", path = "bottom", fight = true},
	{map = "-25,0", path = "top", fight = true},
	{map = "-25,-1", path = "right", fight = true},
	{map = "-24,-1", path = "right", fight = true},
	{map = "-23,-1", path = "top", fight = true},
	{map = "-23,-2", path = "left", fight = true},
	{map = "-24,-2", path = "left", fight = true},
	{map = "-25,-2", path = "top", fight = true},
	{map = "-25,-3", path = "right", fight = true},
	{map = "-24,-3", path = "top", fight = true},
	{map = "-24,-4", path = "right", fight = true},
	{map = "-23,-4", path = "right", fight = true},
	{map = "-22,-4", path = "top", fight = true},
	{map = "-22,-5", path = "top", fight = true},
	{map = "-22,-6", path = "right", fight = true},
	{map = "-21,-6", path = "top", fight = true},
	{map = "-21,-7", path = "top", fight = true},
	{map = "-21,-8", path = "top", fight = true},
	{map = "-21,-9", path = "top", fight = true},
	{map = "-21,-10", path = "top", fight = true},
}


local PlainesHerbeuses = {
    {map = "0,0", path = "zaap(154642)"},
	{map = "-46,18", path = "bottom"},
	{map = "-46,19", path = "left"},
	{map = "-47,19", path = "left"},
	{map = "-48,19", path = "left", fight = true},
	{map = "-49,19", path = "top", fight = true},
	{map = "-48,18", path = "top", fight = true},
	{map = "-49,17", path = "top", fight = true},
	{map = "-49,16", path = "top", fight = true},
	{map = "-49,18", path = "right", fight = true},
	{map = "-48,17", path = "left", fight = true},
	{map = "-49,15", path = "top", fight = true},
	{map = "-49,14", path = "top", fight = true},
	{map = "-49,13", path = "left", fight = true},
	{map = "-50,13", path = "top", fight = true},
	{map = "-50,12", path = "top", fight = true},
	{map = "-50,11", path = "left", fight = true},
	{map = "-51,9", path = "left", fight = true},
	{map = "-51,11", path = "top", fight = true},
	{map = "-51,10", path = "top", fight = true},
	{map = "-52,9", path = "top", fight = true},
	{map = "-52,8", path = "top", fight = true},
	{map = "-52,7", path = "left", fight = true},
	{map = "-53,8", path = "left", fight = true},
	{map = "-54,8", path = "left"},
	{map = "-55,8", path = "left"},
	{map = "-56,8", path = "bottom"},
	{map = "-53,7", path = "bottom", fight = true},
	{map = "-56,9", path = "bottom", fight = true},
	{map = "-57,10", path = "bottom", fight = true},
	{map = "-56,11", path = "bottom", fight = true},
	{map = "-56,10", path = "left", fight = true},
	{map = "-56,12", path = "left", fight = true},
	{map = "-57,11", path = "right", fight = true},
	{map = "-57,12", path = "bottom", fight = true},
	{map = "-57,13", path = "bottom", fight = true},
	{map = "-57,14", path = "bottom", fight = true},
	{map = "-57,15", path = "bottom", fight = true},
	{map = "-57,16", path = "bottom", fight = true},
	{map = "-57,17", path = "bottom", fight = true},
	{map = "-57,19", path = "bottom", fight = true},
	{map = "-57,18", path = "bottom", fight = true},
	{map = "-57,20", path = "bottom", fight = true},
	{map = "-57,21", path = "bottom", fight = true},
	{map = "-57,22", path = "right", fight = true},
	{map = "-56,23", path = "right", fight = true},
	{map = "-55,22", path = "right", fight = true},
	{map = "-54,23", path = "right", fight = true},
	{map = "-56,22", path = "bottom", fight = true},
	{map = "-54,22", path = "bottom", fight = true},
	{map = "-55,23", path = "top", fight = true},
	{map = "-53,23", path = "top", fight = true},
	{map = "-53,22", path = "right", fight = true},
	{map = "-52,21", path = "right", fight = true},
	{map = "-51,21", path = "right", fight = true},
	{map = "-50,21", path = "top", fight = true},
	{map = "-52,22", path = "top", fight = true},
	{map = "-50,20", path = "top", fight = true},
	{map = "-50,19", path = "right", fight = true},
	{map = "-43,1", path = "bottom"},
	{map = "-43,2", custom = function() npc:npc(925, 3) npc:reply(-1) end},
	{map = "-44,21", path = "left"},
	{map = "-45,20", path = "left"},
	{map = "-46,19", path = "left"},
	{map = "-47,19", path = "left"},
	{map = "-46,20", path = "top"},
	{map = "-45,21", path = "top"},

}

local Bourgade = {
	{ map = "-67,-44", fight = false, path = "havenbag" },
	{ map = "-76,-47", fight = false, path = "bottom" },
	{ map = "-86,-44", fight = false, path = "right" },
	{ map = "-72,-34", fight = false, path = "left" },
	{ map = "-73,-33", fight = false, path = "top" },
	{ map = "-83,-46", fight = true, path = "right"},
	{ map = "-82,-46", fight = true, path = "right"},
	{ map = "-81,-46", fight = true, path = "right"},
	{ map = "-80,-46", fight = true, path = "right"},
	{ map = "-79,-46", fight = true, path = "right"},
	{ map = "-78,-46", fight = true, path = "right"},
	{ map = "-77,-46", fight = true, path = "bottom" },
	{ map = "-76,-46", fight = true, path = "bottom" },
	{ map = "-84,-45", fight = true, path = "right"},
	{ map = "-83,-45", fight = true, path = "top"},
	{ map = "-82,-45", fight = true, path = "left|bottom"},
	{ map = "-81,-45", fight = true, path = "left"},
	{ map = "-80,-45", fight = true, path = "top|left|right"},	
    { map = "-79,-45", fight = true, path = "right"},
    { map = "-78,-45", fight = true, path = "top|right"},
    { map = "-77,-45", fight = true, path = "right|bottom" },
    { map = "-76,-45", fight = true, path = "right", },
    { map = "-75,-45", fight = true, path = "bottom", },
    { map = "-85,-44", fight = true, path = "right"},
    { map = "-84,-44", fight = true, path = "top"},
    { map = "-83,-44", fight = true, path = "bottom"},
    { map = "-82,-44", fight = true, path = "left|right"},
    { map = "-81,-44", fight = true, path = "bottom"},
    { map = "-80,-44", fight = true, path = "top"},
    { map = "-79,-44", fight = true, path = "top"},
    { map = "-78,-44", fight = true, path = "bottom"},
    { map = "-77,-44", fight = true, path = "left" },
    { map = "-76,-44", fight = true, path = "top", },
    { map = "-75,-44", fight = true, path = "right" },
    { map = "-74,-44", fight = true, path = "bottom" },
    { map = "-85,-43", fight = true, path = "right"},
    { map = "-84,-43", fight = true, path = "top"},
    { map = "-83,-43", fight = true, path = "bottom"},
    { map = "-82,-43", fight = true, path = "bottom"},
    { map = "-81,-43", fight = true, path = "left"},
    { map = "-80,-43", fight = true, path = "top"},
    { map = "-79,-43", fight = true, path = "top"},
    { map = "-78,-43", fight = true, path = "right"},
    { map = "-77,-43", fight = true, path = "bottom" },
    { map = "-76,-43", fight = true, path = "top|right", },
    { map = "-75,-43", fight = true, path = "bottom", },
    { map = "-74,-43", fight = true, path = "right", },
    { map = "-73,-43", fight = true, path = "bottom", },
    { map = "-85,-42", fight = true, path = "top"},
    { map = "-84,-42", fight = true, path = "top|left"},
    { map = "-83,-42", fight = true, path = "left"},
    { map = "-82,-42", fight = true, path = "right"},
    { map = "-81,-42", fight = true, path = "bottom"},
    { map = "-80,-42", fight = true, path = "top"},
    { map = "-79,-42", fight = true, path = "top"},
    { map = "-78,-42", fight = true, path = "left"},
    { map = "-77,-42", fight = true, path = "right" },
    { map = "-76,-42", fight = true, path = "top" },
    { map = "-75,-42", fight = true, path = "right" },
    { map = "-74,-42", fight = true, path = "right" },
    { map = "-73,-42", fight = true, path = "bottom" },
    { map = "-85,-41", fight = true, path = "top"},
    { map = "-84,-41", fight = true, path = "left|bottom"},
    { map = "-83,-41", fight = true, path = "left"},
    { map = "-82,-41", fight = true, path = "left"},
    { map = "-81,-41", fight = true, path = "left"},
    { map = "-80,-41", fight = true, path = "top"},
    { map = "-79,-41", fight = true, path = "bottom"},
    { map = "-78,-41", path = "top|left|right|bottom" },
    { map = "-76,-41", fight = true, path = "right" },
    { map = "-75,-41", fight = true, path = "right" },
    { map = "-74,-41", fight = true, path = "right" },
    { map = "-73,-41", fight = true, path = "top|right" },
    { map = "-72,-41", fight = true, path = "bottom" },
    { map = "-84,-40", fight = true, path = "top" },
    { map = "-82,-40", fight = true, path = "top"},
    { map = "-81,-40", fight = true, path = "left"},
    { map = "-80,-40", fight = true, path = "top"},
    { map = "-79,-40", fight = true, path = "left"},
    { map = "-78,-40", fight = true, path = "bottom"},
    { map = "-77,-40", fight = true, path = "right" },
    { map = "-76,-40", fight = true, path = "right" },
    { map = "-75,-40", fight = true, path = "right" },
    { map = "-74,-40", fight = true, path = "right" },
    { map = "-73,-40", fight = true, path = "right|bottom" },
    { map = "-72,-40", fight = true, path = "bottom" },
    { map = "-81,-39", fight = true, path = "top"},
    { map = "-80,-39", fight = true, path = "left"},
    { map = "-79,-39", fight = true, path = "left"},
    { map = "-78,-39", fight = true, path = "left|right|bottom"},
    { map = "-77,-39", fight = true, path = "top" },
    { map = "-76,-39", fight = true, path = "bottom" },
    { map = "-75,-39", fight = true, path = "left" },
    { map = "-74,-39", fight = true, path = "left" },
    { map = "-73,-39", fight = true, path = "left|bottom" },
    { map = "-72,-39", fight = true, path = "bottom" },
    { map = "-80,-38", fight = true, path = "top"},
    { map = "-79,-38", fight = true, path = "left"},
    { map = "-78,-38", fight = true, path = "bottom"},
    { map = "-77,-38", fight = true, path = "left" },
    { map = "-76,-38", fight = true, path = "right|bottom" },
    { map = "-75,-38", fight = true, path = "right" },
    { map = "-74,-38", fight = true, path = "bottom" },
    { map = "-73,-38", fight = true, path = "bottom" },
    { map = "-72,-38", fight = true, path = "left" },
    { map = "-79,-37", fight = true, path = "top" },
    { map = "-78,-37", fight = true, path = "left" },
    { map = "-77,-37", fight = true, path = "top" },
    { map = "-76,-37", fight = true, path = "right|bottom" },
    { map = "-75,-37", fight = true, path = "right" },
    { map = "-74,-37", fight = true, path = "bottom" },
    { map = "-73,-37", fight = true, path = "bottom" },
    { map = "-77,-36", fight = true, path = "top" },
    { map = "-76,-36", fight = true, path = "left" },
    { map = "-75,-36", fight = true, path = "left|bottom" },
    { map = "-74,-36", fight = true, path = "left|bottom" },
    { map = "-73,-36", fight = true, path = "bottom" },
    { map = "-76,-35", fight = true, path = "top" },
    { map = "-75,-35", fight = true, path = "left" },
    { map = "-74,-35", fight = true, path = "bottom" },
    { map = "-73,-35", fight = true, path = "left" },
    { map = "-76,-34", fight = true, path = "right", },
    { map = "-75,-34", fight = true, path = "top" },
    { map = "-74,-34", fight = true, path = "bottom" },
    { map = "-73,-34", fight = true, path = "left" },
    { map = "-76,-33", fight = true, path = "top" },
    { map = "-75,-33", fight = true, path = "left" },
    { map = "-74,-33", fight = true, path = "left" },
    { map = "54172457", fight = true, path = "right" },
    { map = "54534165", path = "424" },
    { map = "0,0", path = "zaap(54172969)" },
}

local RouteRocailleuse = {
	{map = "0,0", path = "zaap(164364304)"},
	{map = "-20,-17", path = "bottom", fight = true},
	{map = "-20,-16", path = "bottom", fight = true},
	{map = "-20,-15", path = "bottom", fight = true},
	{map = "-20,-14", path = "bottom", fight = true},
	{map = "-20,-13", path = "bottom", fight = true},
	{map = "-20,-12", path = "left", fight = true},
	{map = "-21,-12", path = "left", fight = true},
	{map = "-22,-12", path = "left", fight = true},
	{map = "-23,-12", path = "left", fight = true},
	{map = "-24,-12", path = "left", fight = true},
	{map = "-25,-12", path = "left", fight = true},
	{map = "-26,-12", path = "left", fight = true},
	{map = "-27,-12", path = "left", fight = true},
	{map = "-28,-12", path = "top", fight = true},
	{map = "-28,-13", path = "top", fight = true},
	{map = "-28,-14", path = "top", fight = true},
	{map = "-28,-15", path = "top", fight = true},
	{map = "-28,-16", path = "right", fight = true},
	{map = "-27,-16", path = "bottom", fight = true},
	{map = "-27,-15", path = "bottom", fight = true},
	{map = "-27,-14", path = "bottom", fight = true},
	{map = "-25,-16", path = "bottom", fight = true},
	{map = "-25,-15", path = "bottom", fight = true},
	{map = "-25,-14", path = "bottom", fight = true},
	{map = "-23,-16", path = "bottom", fight = true},
	{map = "-23,-15", path = "bottom", fight = true},
	{map = "-23,-14", path = "bottom", fight = true},
	{map = "-27,-13", path = "right", fight = true},
	{map = "-25,-13", path = "right", fight = true},
	{map = "-26,-16", path = "right", fight = true},
	{map = "-24,-16", path = "right", fight = true},
	{map = "-23,-13", path = "right", fight = true},
	{map = "-26,-13", path = "top", fight = true},
	{map = "-26,-14", path = "top", fight = true},
	{map = "-26,-15", path = "top", fight = true},
	{map = "-24,-13", path = "top", fight = true},
	{map = "-24,-14", path = "top", fight = true},
	{map = "-24,-15", path = "top", fight = true},
	{map = "-21,-13", path = "top", fight = true},
	{map = "-22,-14", path = "top", fight = true},
	{map = "-21,-15", path = "top", fight = true},
	{map = "-21,-16", path = "top", fight = true},
	{map = "-21,-17", path = "top", fight = true},
	{map = "-21,-18", path = "right", fight = true},
	{map = "-20,-20", path = "right", fight = true},
	{map = "-19,-20", path = "bottom", fight = true},
	{map = "-19,-19", path = "bottom", fight = true},
	{map = "-19,-18", path = "bottom", fight = true},
	{map = "-19,-17", path = "left", fight = true},
	{map = "-20,-18", path = "top", fight = true},
	{map = "-21,-19", path = "top", fight = true},
	{map = "-21,-20", path = "top", fight = true},
	{map = "-21,-21", path = "top", fight = true},
	{map = "-22,-13", path = "right", fight = true},
	{map = "-21,-14", path = "left", fight = true},
	{map = "-22,-15", path = "right", fight = true},
	{map = "-20,-19", path = "left", fight = true},
	{map = "-21,-22", path = "top", fight = true},
	{map = "-21,-23", path = "top", fight = true},
	{map = "-21,-24", path = "right", fight = true},
	{map = "-20,-24", path = "bottom", fight = true},
	{map = "-20,-23", path = "bottom", fight = true},
	{map = "-20,-22", path = "bottom", fight = true},
	{map = "-20,-21", path = "bottom", fight = true},
}

local PresquIleDragoeuf = {
    {map = "0,0", path = "zaap(88212481)"},
    {map = "-1,24", path = "left"},
    {map = "-2,24", path = "bottom", fight = true},
    {map = "-2,25", path = "right", fight = true},
    {map = "-1,25", path = "bottom", fight = true},
    {map = "-1,26", path = "left", fight = true},
    {map = "-2,26", path = "bottom", fight = true},
    {map = "-2,28", path = "right", fight = true},
    {map = "-1,28", path = "bottom", fight = true},
    {map = "-1,29", path = "bottom", fight = true},
    {map = "-1,30", path = "left", fight = true},
    {map = "-2,30", path = "top", fight = true},
    {map = "-2,29", path = "left", fight = true},
    {map = "-3,29", path = "bottom", fight = true},
    {map = "-3,30", path = "bottom", fight = true},
    {map = "-3,31", path = "bottom", fight = true},
    {map = "-3,32", path = "left", fight = true},
    {map = "-4,30", path = "left", fight = true},
    {map = "-4,32", path = "top", fight = true},
    {map = "-4,31", path = "top", fight = true},
    {map = "-5,30", path = "bottom", fight = true},
    {map = "-5,31", path = "bottom", fight = true},
    {map = "-5,32", path = "left", fight = true},
    {map = "-6,32", path = "left", fight = true},
    {map = "-7,32", path = "top", fight = true},
    {map = "-6,31", path = "top", fight = true},
    {map = "-7,30", path = "top", fight = true},
    {map = "-6,30", path = "left", fight = true},
    {map = "-7,31", path = "right", fight = true},
    {map = "-7,29", path = "right", fight = true},
    {map = "-6,29", path = "right", fight = true},
    {map = "-5,29", path = "right", fight = true},
    {map = "-4,29", path = "top", fight = true},
    {map = "-4,28", path = "left", fight = true},
    {map = "-5,28", path = "left", fight = true},
    {map = "-6,28", path = "left", fight = true},
    {map = "-7,28", path = "top", fight = true},
    {map = "-7,27", path = "right", fight = true},
    {map = "-6,27", path = "top", fight = true},
    {map = "-6,26", path = "top(4)", fight = true},
    {map = "-6,24", path = "right", fight = true},
    {map = "-5,24", path = "right", fight = true},
    {map = "-4,24", path = "right"},
    {map = "-3,24", path = "right", fight = true},
    {map = "-6,25", path = "top", fight = true},
    {map = "-2,27", path = "left", fight = true},
    {map = "-3,27", path = "bottom", fight = true},
    {map = "-3,28", path = "right", fight = true},
}

local Gelee = {
	{map = "0,0", path = "zaap(88085249)"},
	{map = "15,22", path = "zaapi(90703364)"},
	{map = "10,22", path = "right"},
	{map = "11,22", path = "right"},
	{map = "12,22", path = "right"},
	{map = "13,22", path = "right"},
	{map = "14,22", path = "right"},
	{map = "13,29", path = "left"},
	{map = "12,29", path = "left"},
	{map = "11,29", path = "bottom|left", fight = true},
	{map = "10,29", path = "bottom", fight = true},
	{map = "10,30", path = "left", fight = true},
	{map = "9,30", path = "left", fight = true},
	{map = "8,30", path = "bottom|left", fight = true},
	{map = "8,31", path = "left", fight = true},
	{map = "7,31", path = "left", fight = true},
	{map = "6,31", path = "top", fight = true},
	{map = "6,30", path = "top", fight = true},
	{map = "6,29", path = "right", fight = true},
	{map = "7,29", path = "right", fight = true},
	{map = "8,29", path = "right", fight = true},
	{map = "9,29", path = "top", fight = true},
	{map = "9,28", path = "right", fight = true},
	{map = "10,28", path = "right", fight = true},
	{map = "11,28", path = "bottom", fight = true},
	{map = "7,30", path = "bottom", fight = true},
	{map = "11,30", path = "top", fight = true},
}

local Rivage = {
	{ map ="0,0", path = "zaap(88085249)" },
	{ map = "12,12", path = "havenbag" },
	{ map = "6,-19", path = "havenbag" },
	{ map = "22,22", path = "havenbag" },
	{ map = "-30,-55", path = "havenbag" },
	{map = "14,22", path = "left", fight = true},
	{map = "13,22", path = "left", fight = true},
	{map = "12,22", path = "left", fight = true},
	{map = "11,22", path = "left", fight = true},
	{map = "10,22", path = "left", fight = true},
	{map = "9,21", path = "left", fight = true},
	{map = "8,21", path = "left", fight = true},
	{map = "7,22", path = "bottom", fight = true},
	{map = "23,16", path = "bottom", fight = true},
	{map = "7,23", path = "left", fight = true},
	{map = "9,22", path = "top", fight = true},
	{map = "5,23", path = "left", fight = true},
	{map = "4,23", path = "bottom", fight = true},
	{map = "4,24", path = "bottom", fight = true},
	{map = "4,25", path = "bottom", fight = true},
	{map = "5,26", path = "bottom", fight = true},
	{map = "5,27", path = "bottom", fight = true},
	{map = "6,28", path = "right", fight = true},
	{map = "4,26", path = "right"},
	{map = "5,28", path = "right"},
	{map = "8,20", path = "right"},
	{map = "9,20", path = "right"},
	{map = "10,20", path = "right"},
	{map = "11,20", path = "right"},
	{map = "12,20", path = "right"},
	{map = "13,20", path = "right"},
	{map = "14,20", path = "bottom"},
	{map = "14,21", path = "bottom"},
	{map = "7,28", path = "bottom", fight = true},
	{map = "7,29", path = "left"},
	{map = "6,29", path = "left"},
	{map = "5,29", path = "left"},
	{map = "4,29", path = "left"},
	{map = "3,29", path = "top"},
	{map = "3,28", path = "top"},
	{map = "3,27", path = "top"},
	{map = "3,26", path = "top"},
	{map = "3,25", path = "top"},
	{map = "3,24", path = "top"},
	{map = "3,23", path = "top"},
	{map = "3,22", path = "top"},
	{map = "6,22", path = "left", fight = true},
	{map = "4,22", path = "bottom", fight = true},
	{map = "7,21", path = "bottom", fight = true},
	{map = "6,23", path = "top", fight = true},
	{map = "5,22", path = "bottom", fight = true},
	{map = "6,20", path = "right"},
	{map = "7,20", path = "right"},
	{map = "10,24", path = "right"},
	{map = "4,21", path = "right"},
	{map = "3,21", path = "right"},
	{map = "5,20", path = "right"},
	{map = "5,21", path = "top"},
}

local TableAreaRentable = {
	{Area = PlainesHerbeuses, LvlMin = 180, ListeVenteId = {8767, 8769, 8737, 8762, 8736, 8766, 8756, 8765, 8763, 8753}, ForceArea = false, MaxMonster = 6, MinMonster = 1},
	{Area = RouteRocailleuse, LvlMin = 145, ListeVenteId = {2550, 2551, 2528, 2552, 290, 424, 1890}, ForceArea = false, MaxMonster = 8, MinMonster = 4},
	{Area = PresquIleDragoeuf, LvlMin = 136, ListeVenteId = {546, 544, 547, 545, 1129, 844, 842, 845, 308, 847, 843, 846}, ForceArea = false, MaxMonster = 8, MinMonster = 4},
	{Area = Gelee, LvlMin = 125, ListeVenteId = {757, 368, 369}, ForceArea = false, MaxMonster = 8, MinMonster = 4},
	{Area = Rivage, LvlMin = 114, ListeVenteId = {379, 13728, 386, 8681}, ForceArea = false, MaxMonster = 8, MinMonster = 4},
}

local function venteParcho()
	npc:npc(385,5)
	global:delay(1500)
		if inventory:itemCount(678) >= 100 then
		itemname = inventory:itemNameId(678)
		Priceitem = sale:getPriceItem(678, 3) 
		if Priceitem > 400 then -- 
			while (inventory:itemCount(678) >= 100) and (sale:AvailableSpace() > 0) do 
				sale:SellItem(678, 100, Priceitem -1) 
				global:printSuccess("1 lot de " .. 100 .. " x " .. itemname .. " à " .. Priceitem -1 .. "kamas")
			end 
		   end
		end
		if inventory:itemCount(680) >= 10 then
		itemname = inventory:itemNameId(680)
		Priceitem = sale:getPriceItem(680, 2) 
		if Priceitem > 400 then -- 
			while (inventory:itemCount(680) >= 10) and (sale:AvailableSpace() > 0) do 
				sale:SellItem(680, 10, Priceitem -1) 
				global:printSuccess("1 lot de " .. 10 .. " x " .. itemname .. " à " .. Priceitem -1 .. "kamas")
			end 
		   end
		end
		
	global:delay(1500)
	global:leaveDialog()
	map:changeMap("left")
end

local GoSellParcho = {
	{map = "0,0", path = "zaap(212600323)"},
	{map="212600323", path = "bottom"},
	{map="-31,-55", path = "bottom"},
	{map = "-31,-53", custom = venteParcho}, 
	{map="-31,-54", path = "bottom"},
}

--- </init>


-- <parameters>

local receiverAlias = "bank"
-- Montant de kamas que le bot farm devra garder 

-- Montant de kamas qui déclenchera le transfert au bot bank
local givingTriggerValue = 1000000

-- Temps d'attente maximal de la connexion du bot bank (en secondes)
local maxWaitingTime = 120

-- Temps d'attente avant de réessayer de connecter le bot bank (en heures)
local minRetryHours = 4


--- </parameters>


--- <variables>

local toGive = 0
local retryTimestamp = 0
local server = character:server():lower()

local bankMaps = {
    zAstrub = "zaap(191105026)",
    idHavenbag = 162791424,
    mapZAstrub = 191105026,
    bankAstrubExt = 191104002,
    bankAstrubInt = 192415750,
}

--- </variables>


--- </functions>

local function ObjectSetPositionMessage(uid, position)
    local message = developer:createMessage("ObjectSetPositionMessage")
    message.objectUID = uid
    message.position = 63
    message.quantity = 1

    developer:sendMessage(message)
end

local function goAstrubBank(inBankCallback)
    if not movingPrinted then
        global:printMessage("Déplacement jusqu'à la banque d'Astrub")
        movingPrinted = true
    end
    if not getCurrentAreaName():find("Astrub") then
        if map:currentMapId() == tonumber(bankMaps.idHavenbag) then
            return map:changeMap(bankMaps.zAstrub)
        else
            return map:changeMap("havenbag")
        end
    else
        if map:currentMapId() ~= tonumber(bankMaps.bankAstrubInt) then
            return map:moveToward(tonumber(bankMaps.bankAstrubInt))
        else
            if inBankCallback then
                return inBankCallback()
            end
        end
    end
end


local function connectReceiver()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
		if acc:getAlias():find(receiverAlias .. "_" .. server) then
            if not acc:isAccountConnected() then
				setBotBankConnected(character:server(), true)

                acc:connect()

                local safetyCount = 0
                while not acc:isAccountFullyConnected() do
                    safetyCount = safetyCount + 1

                    if safetyCount == 1 then
                        global:printMessage("Attente de la connexion du bot banque (" .. maxWaitingTime .. " secondes max)")
                    end

                    global:delay(1000)

                    if safetyCount >= maxWaitingTime then
                        global:printError("Bot banque non-connecté après " .. maxWaitingTime .. " secondes, reprise du trajet")
                        cannotConnect = true
						setBotBankConnected(character:server(), false)

                        return acc
                    end
                end
				acc:loadConfig("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\configBank.xml")
                acc:loadScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\bot_banque.lua")
				acc:startScript()
                return acc
            else
                return acc
            end
        end
    end
end

local function rerollVar()
    if global:remember("failed") then
        global:deleteMemory("failed")
    end

    toGive, connected, movingPrinted, givingMode = 0, nil, nil, nil
end

local function takeKamas()
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end
	global:leaveDialog()
	if character:kamas() < 1200000 then
		global:printSuccess("Reco dans 2h")
		global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\scripts\\take-kamas.lua")
		customReconnect(math.random(80, 120))
	end
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

function join(tab, sep)
    local result = ''
    for k, v in ipairs(tab) do
        result = sep
            and result .. v .. sep
            or result .. v
    end

    return result
end

local function findMKamas(stringalias)
    local stringKamas = { }
    local tabstring = stringalias:split()

    for index, element in ipairs(tabstring) do
        if tabstring[index] == "[" then
            for i = 1, 3 do
                if tabstring[i + index] ~= "m" then
                    stringKamas[i] = tabstring[i + index]
                end
            end
        end
    end
    stringKamas = join(stringKamas)
    return (tonumber(stringKamas) == nil or tonumber(stringKamas) <= 5) and 0 or tonumber(stringKamas) - 5
end

local function GetServer(account)
    local Servers = {"Imagiro", "Orukam", "Tal Kasha", "Hell Mina", "Tylezia", "Brumen"}
    for _, Server in ipairs(Servers) do
        if account:getAlias():find(Server) or account:getAlias():find(string.lower(Server)) then
            return Server
        end
    end
    return nil
end

local function GetProxy(lineToRead)
    local cpt = 0
    local i = 1
    local f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\proxy.txt", "r")

    local toReturn = {proxy = {}, port = {}, username = {}, password = {}}

    for line in io.lines("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\proxy.txt") do
        if i == lineToRead then
            tabline = line:split()
            for index, element in ipairs(tabline) do
                if element == ":" then
                    cpt = cpt + 1
                end
                if cpt == 0 then
                    toReturn.proxy[index] = element
                elseif cpt == 1 and element ~= ":" then
                    toReturn.port[index - #toReturn.proxy - 1] = element
                elseif cpt == 2 and element ~= ":" then
                    toReturn.username[index - (#toReturn.proxy + #toReturn.port) - 2] = element
                elseif cpt == 3 and element ~= ":" then
                    toReturn.password[index - (#toReturn.proxy + #toReturn.port + #toReturn.username) - 3] = element
                end
            end
        end
        i = i + 1
    end
	f:close()
    toReturn.proxy = join(toReturn.proxy)
    toReturn.port = join(toReturn.port)
    toReturn.username = join(toReturn.username)
    toReturn.password = join(toReturn.password)

    return toReturn
end

local function CreateOtherAccount()
	
	if not (character:server() == "Draconiros") then
		global:printMessage("tentative de connexion du prochain bot...")
		for i, Alias in ipairs(snowbotController:getAliasNotLoadedAccounts()) do
			if Alias:find("*") then
				global:printSuccess("Succès!")
				for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
					if i == j then
						snowbotController:createCharacter(Username, character:server(), 11, false, 0, {"#f2c07d", "#000000", "#000000", "#ffffff", "#400000"})
						if stringalias:find("LvlUp ") or stringalias:find("LvlUp2") then
							snowbotController:assignProxyToAnAccount(Username, GetProxy(6).proxy, tonumber(GetProxy(6).port), GetProxy(6).username, GetProxy(6).password, false, true)
						else
							snowbotController:assignProxyToAnAccount(Username, GetProxy(10).proxy, tonumber(GetProxy(10).port), GetProxy(10).username, GetProxy(10).password, false, true)
						end
						acc = snowbotController:loadAnAccount(Username, true)
						acc.global():editAlias(stringalias .. " " .. character:server(), true)
						break
					end
				end
				break
			end
		end
	elseif character:server() == "Draconiros" then
		global:printMessage("tentative de connexion du prochain bot...")
		for i, Alias in ipairs(snowbotController:getAliasNotLoadedAccounts()) do
			if Alias:find("Next") then
				for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
					if findMKamas(acc:getAlias()) > 2 and not acc:getAlias():find("Draconiros") and not acc:getAlias():find("Controller") then
						global:printSuccess("on tente de connecter : " .. acc:getAlias())
						acc:connect()
						local cannotConnect = false
						local safetyCount = 0
						while not acc:isAccountFullyConnected() and not cannotConnect do
							safetyCount = safetyCount + 1
		
							if safetyCount == 1 then
								global:printMessage("Attente de la connexion du bot banque (" .. 120 .. " secondes max)")
							end
		
							global:delay(1000)
		
							if safetyCount >= 120 then
								global:printError("Bot banque non-connecté après " .. 120 .. " secondes, on tente le suivant")
								cannotConnect = true
							end
						end
						if cannotConnect then
							acc:disconnect()
						else
							acc:disconnect()
							server = GetServer(acc)
							break
						end
					end
				end

				global:printSuccess("Succès!")

				for j, Username in ipairs(snowbotController:getUsernameNotLoadedAccounts()) do
					if i == j then
						snowbotController:createCharacter(Username, server, 11, false)
						if stringalias:find("LvlUp ") or stringalias:find("LvlUp2") then
							snowbotController:assignProxyToAnAccount(Username, GetProxy(6).proxy, tonumber(GetProxy(6).port), GetProxy(6).username, GetProxy(6).password, false, true)
						else
							snowbotController:assignProxyToAnAccount(Username, GetProxy(10).proxy, tonumber(GetProxy(10).port), GetProxy(10).username, GetProxy(10).password, false, true)
						end
						acc = snowbotController:loadAnAccount(Username, true)
						acc.global():editAlias(stringalias .. " " .. character:server(), true)
						break
					end
				end
				break
			end
		end
	end
end

local function launchExchangeAndGive()
	global:printSuccess("check de la banque")
	npc:npcBank(-1)
	global:delay(500) 

	if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	


	
	
	if (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155)) then 	
		exchange:putAllItemsExcept({2469, 27524, 478, 27522, 27523, 9167, 9149, 2447, 8466, 478, 8467, 8464, 8468, 8465, 8463, 8072, 19629, 17078, 972, 16864, 16964, 16881, 2447, 2390, 1487, 6927, 1665, 469, 732, 8463, 8465, 8468, 8464, 8467, 250, 8466, 2469, 18690, 13748, 13749, 13794, 13793, 12725, 14966})
	end

	global:leaveDialog()

    local id = receiver.character():id()
	receiver:exchangeListen(false)
    receiver:exchangeListen(true)
	
    if (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155)) then
        local inv = inventory:inventoryContent()
        for k, v in ipairs(inv) do
            if v.position ~= 63 then
                global:printSuccess(v.objectGID)
                ObjectSetPositionMessage(v.objectUID, v.position)
            end
        end
    end

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

	local safetyCount = 0

    while not exchange:launchExchangeWithPlayer(id) and safetyCount < 120 do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
		safetyCount = safetyCount + 5
    end
	if safetyCount >= 120 then
		global:printError("Bot banque ne répond pas après " .. maxWaitingTime .. " secondes, reprise du trajet")
		rerollVar()
		global:editInMemory("retryTimestamp", os.time())
		global:addInMemory("failed", true)
		receiver:disconnect()
		setBotBankConnected(character:server(), false)
		return
	end


    KamasToKeep = ((character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155))) and 10000 or (getRemainingSubscription(true) == 0) and 1000000 or 300000

	local tableEquipAncien = {
		{name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
		{name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
		{name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
		{name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
		{name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
		{name = "arme sasa", id = 478, emplacement = 1, equipe = false},
		{name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},
	}
	for _, element in ipairs(tableEquipAncien) do
		if inventory:itemCount(element.id) > 0 then
			exchange:putItem(element.id, inventory:itemCount(element.id))
		end
	end

    toGive = character:kamas() - KamasToKeep

    exchange:putKamas(toGive)

    if (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155)) then
        for _, element in ipairs(tableEquip) do
            exchange:putItem(element.id, 1)
        end
        for _, element in ipairs(tableEquipSasa) do
            exchange:putItem(element.id, 1)
        end
    end
	
    exchange:ready()

    global:delay(3000)

    global:printSuccess("Kamas transférés. Reprise du trajet")
	global:delay(5000)
	receiver:reloadScript()
	receiver:startScript()

    if (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155)) then
			--
		-- Edit the string
		--

		local TriParServeur = {"", "", "", "", "", ""}

		for line in io.lines("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesAVendre.txt") do
			if line ~= "" then
				local tabline = line:split(":")
				if tabline[3]:find("Imagiro") then TriParServeur[1] = TriParServeur[1] .. line .. "\r"
				elseif tabline[3]:find("Orukam") then TriParServeur[2] = TriParServeur[2] .. line .. "\r"
				elseif tabline[3]:find("Tal Kasha") then TriParServeur[3] = TriParServeur[3] .. line .. "\r"
				elseif tabline[3]:find("Tylezia") then TriParServeur[4] = TriParServeur[4] .. line .. "\r"
				elseif tabline[3]:find("Hell Mina") then TriParServeur[5] = TriParServeur[5] .. line .. "\r"
				elseif tabline[3]:find("Draconiros") then TriParServeur[6] = TriParServeur[6] .. line .. "\r"
				end
			end
		end

    	local content = ""

    	for _, element in ipairs(TriParServeur) do
        	content = content .. element .. "\r"
    	end

		content = content .. "\r" .. global:thisAccountController():getUsername() .. ":" ..  snowbotController:getPassword(global:thisAccountController():getUsername()) .. ":" .. global:thisAccountController().character():server() .. " " .. global:thisAccountController().character():level()

		--
		-- Write it out
		--
		local f = io.open("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesAVendre.txt", "w")
		f:write(content)
		f:close()

		local nbAccountInSameServ = 0

		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find(character:server()) and acc:getAlias():find(stringalias) then
				nbAccountInSameServ = nbAccountInSameServ + 1
			end
		end

		if nbAccountInSameServ < 2 then
			CreateOtherAccount()
		end
	end

	global:delay(10000)
    rerollVar()
    receiver:disconnect()
	setBotBankConnected(character:server(), false)

	if (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155)) then 
		local deleteAccount = true
		for _, element in ipairs(tableEquip) do
            if inventory:itemCount(element.id) > 0 then
				deleteAccount = false
			end
        end
		if deleteAccount and character:kamas() <= 10000 then
			global:disconnect() 
			-- snowbotController:deleteAccount(global:thisAccountController():getUsername())
		else
			global:disconnect() 
		end
	end
	global:restartScript(true)

end



function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
end


local function send_equip(ID_idole)
        monMessage = developer:createMessage(6587)
        monMessage.idolId = ID_idole
        monMessage.activate = true
		monMessage.party = false
        developer:sendMessage(monMessage)
end

local function antiModo()
    if global:isModeratorPresent(30) then
		timerdisconnect = math.random(30000, 36000) 
        if not map:onMap("0,0") then
            map:changeMap("havenbag")
        end
        global:printError("Modérateur présent. On attend " .. timerdisconnect / 1000 .. "secondes")

		if global:thisAccountController():getAlias():find("LvlUp ") then
			global:editAlias("LvlUp " .. character:server() .. " [" .. character:level() .. "]  [MODO]", true)
		elseif global:thisAccountController():getAlias():find("LvlUp2") then
			global:editAlias("LvlUp2 " .. character:server() .. " [" .. character:level() .. "]  [MODO]", true)
		elseif global:thisAccountController():getAlias():find("LvlUp3") then
			global:editAlias("LvlUp3 " .. character:server() .. " [" .. character:level() .. "]  [MODO]", true)
		elseif global:thisAccountController():getAlias():find("LvlUp4") then
			global:editAlias("LvlUp4 " .. character:server() .. " [" .. character:level() .. "]  [MODO]", true)
		end

        global:delay(timerdisconnect)
		customReconnect(timerdisconnect / 1000)
        map:changeMap("havenbag")
	end
end

local function equiper()
	for _, element in ipairs(tableEquip) do
		if not element.equipe and inventory:itemCount(element.id) >= 1 then
			inventory:equipItem(element.id, element.emplacement)
			element.equipe = true
		end
	end
end

local function treatMaps(maps, errorFn)
    local msg = "[Erreur] - Aucune action à réaliser sur la map"

    for _, element in ipairs(maps) do
        local condition = element.map == map:currentMap() 
            or tostring(element.map) == tostring(map:currentMapId())
            
        if condition then
            return maps
        end
    end

    return errorFn
        and errorFn()
        or global:printError(msg)
end

local function ProcessBank()
	NeedToReturnBank = false
    map:door(468) 
	npc:npcBank(-1)
    global:delay(500) 

	if exchange:storageKamas() > 0 then
        exchange:getKamas(0)
		global:delay(500)
	elseif exchange:storageKamas() == 0 then
		global:delay(500)
	end	

	for _, element in ipairs(tableVente) do
		if inventory:itemCount(element.id) > 0 then
			exchange:putItem(element.id, inventory:itemCount(element.id))
		end
	end
	if not hdvFull then
		local cpt = 0
		for _, element in ipairs(tableVente) do
			local podsAvailable = inventory:podsMax() - inventory:pods()
			if element.maxHdv100 ~= nil and element.maxHdv10 ~= nil and element.maxHdv1 ~= nil and element.canSell then
				local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), math.floor(podsAvailable / inventory:itemWeight(element.id)), element.maxHdv100 * 100 + element.maxHdv10 * 10 + element.maxHdv1, podsAvailable)
				if QuantiteAPrendre >= 100 then
					exchange:getItem(element.id, QuantiteAPrendre)
					cpt = cpt + 1
				end
			elseif element.maxHdv100 ~= nil and element.maxHdv10 ~= nil and element.maxHdv1 == nil and element.canSell then
				local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), math.floor(podsAvailable / inventory:itemWeight(element.id)), element.maxHdv100 * 100 + element.maxHdv10 * 10, podsAvailable)
				if QuantiteAPrendre >= 100 then
					exchange:getItem(element.id, QuantiteAPrendre)
					cpt = cpt + 1
				end
			elseif element.maxHdv100 == nil and element.maxHdv10 ~= nil and element.maxHdv1 ~= nil and element.canSell then
				local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), math.floor(podsAvailable / inventory:itemWeight(element.id)), element.maxHdv10 * 10 + element.maxHdv1, podsAvailable)
				if QuantiteAPrendre >= 10 then
					exchange:getItem(element.id, QuantiteAPrendre)
					cpt = cpt + 1
				end
			end
		end
		global:printSuccess("Nb d'items différents à vendre : " .. cpt)
		NeedToSell = (cpt > 5) or (inventory:podsP() > 50)
	end

	hdvFull = false

	global:leaveDialog()

	return map:door(518)
end

local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID

    developer:sendMessage(message)
end

local function ProcessSell()
	NeedToSell = false
	NeedToReturnBank = true

	table.sort(tableVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)
	table.sort(tableValeurVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)

	HdvSell()
	-- vente par 100, 10 des récoles alchimiste
	for i, element in ipairs(tableVente) do
		if inventory:itemCount(element.id) == 0 then global:printSuccess("on a plus rien à vendre") break end

		cpt = get_quantity(element.id).quantity["100"]
		local itemSold = false

		local Priceitem1 = sale:getPriceItem(element.id, 3)
		Priceitem1 = (Priceitem1 == nil or Priceitem1 == 0 or Priceitem1 == 1) and sale:getAveragePriceItem(element.id, 3) * 1.5 or Priceitem1
    	while inventory:itemCount(element.id) >= 100 and sale:AvailableSpace() > 0 and Priceitem1 > 2000 and cpt < element.maxHdv100 and (sale:AvailableSpace() > 50 or Priceitem1 > 10000) do 
            sale:SellItem(element.id, 100, Priceitem1 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. Priceitem1 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end
		element.maxHdv100 = (sale:AvailableSpace() > 50 or Priceitem1 > 10000) and tableValeurVente[i].maxHdv100 or 0

		cpt = get_quantity(element.id).quantity["10"]
		local Priceitem2 = sale:getPriceItem(element.id, 2)
		Priceitem2 = (Priceitem2 == nil or Priceitem2 == 0 or Priceitem2 == 1) and sale:getAveragePriceItem(element.id, 2) * 1.5 or Priceitem2
        while inventory:itemCount(element.id) >= 10 and sale:AvailableSpace() > 0 and Priceitem2 > 500 and cpt < element.maxHdv10 and (sale:AvailableSpace() > 50 or Priceitem2 > 4000) do 
            sale:SellItem(element.id, 10, Priceitem2 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. Priceitem2 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
		end
		element.maxHdv10 = (sale:AvailableSpace() > 50 or Priceitem2 > 4000) and tableValeurVente[i].maxHdv10 or 0

        cpt = get_quantity(element.id).quantity["1"]
		local Priceitem3 = sale:getPriceItem(element.id, 1)
		Priceitem3 = (Priceitem3 == nil or Priceitem3 == 0 or Priceitem3 == 1) and sale:getAveragePriceItem(element.id, 1) * 1.5 or Priceitem3
        while inventory:itemCount(element.id) >= 1 and sale:AvailableSpace() > 0 and Priceitem3 > 100 and cpt < element.maxHdv1 and (sale:AvailableSpace() > 50 or Priceitem3 > 500) do 
            sale:SellItem(element.id, 1, Priceitem3 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. Priceitem3 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end
		element.maxHdv1 = (sale:AvailableSpace() > 50 or Priceitem3 > 500) and tableValeurVente[i].maxHdv1 or 0

		element.delete = ((element.maxHdv1 == 0)) and ((element.maxHdv10 == 0)) and ((element.maxHdv100 == 0))
		or (Priceitem1 <= 2000 and inventory:itemCount(element.id) >= 100)
		or (Priceitem2 <= 500 and inventory:itemCount(element.id) >= 10)
		or (Priceitem3 <= 100 and inventory:itemCount(element.id) >= 1)

		if itemSold then
			randomDelay()
		end
    end

	if cptActualiser == 2 then
		global:printSuccess("Actualisation des prix")
		cptActualiser = 0
		sale:updateAllItems()
	else
		cptActualiser = cptActualiser + 1
	end

	if sale:AvailableSpace() == 0 then 
		hdvFull = true 
		global:printError("l'hdv est plein") 
	else
		hdvFull = false
	end

	global:leaveDialog()
	global:delay(500)
	
	HdvSell()
	-- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
	for _, element in ipairs(tableVente) do
		if element.maxHdv100 ~= nil and get_quantity(element.id).quantity["100"] >= element.maxHdv100 and get_quantity(element.id).quantity["10"] >= element.maxHdv10 then
			element.canSell = false
		elseif element.maxHdv100 == nil and get_quantity(element.id).quantity["10"] >= element.maxHdv10 and get_quantity(element.id).quantity["1"] >= element.maxHdv1 then
			element.canSell = false
		else
			element.canSell = true
		end
		if element.delete then
			inventory:deleteItem(element.id, inventory:itemCount(element.id))
		end
	end
    
    local tablePourcentage = {}
	local insert = table.insert

    for i, element in ipairs(TableAreaRentable) do
        local compteur = 0
        insert(tablePourcentage, 0)
        for _, element2 in ipairs(element.ListeVenteId) do
            for _, element3 in ipairs(tableVente) do -- trouve l'id dans la tableVente
                if element2 == element3.id then
                    tablePourcentage[i] = tablePourcentage[i] + (get_quantity(element2).total_lots / element3.Total)
                    compteur = compteur + 1
                end
            end
        end
        tablePourcentage[i] = math.floor(tablePourcentage[i] * 100 / compteur)
		global:printSuccess(tablePourcentage[i])
        element.ForceArea = tablePourcentage[i] < 25 and character:level() >= element.LvlMin and character:level() < levelToReach
    end
	global:leaveDialog()

	global:delay(500)
	if character:level() >= 130 then
		settOrnament(33)
	end
	global:delay(500)

	map:changeMap("top")
end

function stopped()
	map:changeMap("havenbag")
end

local function whichArea()

    if inventory:itemCount(678) >= 200 or inventory:itemCount(680) >= 20 then
		MAX_MONSTERS = character:level() >= 160 and 8 or 6
		MIN_MONSTERS = character:level() >= 160 and 3 or 1 
		return treatMaps(GoSellParcho, function() map:changeMap("havenbag") end)
    end

	if (character:level() + 5 > levelToReach) or (levelToReach == 160 and  getRemainingSubscription(true) < 3 and character:level() > 144) then
		MAX_MONSTERS = character:level() < 165 and 7 or 8
		MIN_MONSTERS = character:level() < 165 and 2 or 3
		return treatMaps(Bourgade, function() map:changeMap("havenbag") end)
	end

	if levelToReach ~= 160 then
		for _, element in ipairs(TableAreaRentable) do
			if element.ForceArea and inventory:podsP() < 40 then
				MAX_MONSTERS = element.MaxMonster
				MIN_MONSTERS = element.MinMonster
				return treatMaps(element.Area, function() map:changeMap("havenbag") end)
			elseif element.ForceArea and inventory:podsP() >= 40 then
				return bank()
			end
		end
	end

	if levelToReach == 160 then
		if character:level() >= 136 and character:level() < 140 then
			AMOUNT_MONSTERS = {{88, 0, 2}}
			MAX_MONSTERS = 8
			MIN_MONSTERS = 3
			return treatMaps(PresquIleDragoeuf, function() map:changeMap("havenbag") end)
		elseif character:level() >= 130 then
			MAX_MONSTERS = character:level() < 165 and 7 or 8
			MIN_MONSTERS = character:level() < 165 and 2 or 3
			return treatMaps(Bourgade, function() map:changeMap("havenbag") end)
		else
			MAX_MONSTERS = 8
			MIN_MONSTERS = 4
			return treatMaps(Gelee, function() map:changeMap("havenbag") end)
		end
	end
	if character:level() >= 180 and character:level() <= 187 then
		MAX_MONSTERS = 5
		MIN_MONSTERS = 1
		return treatMaps(PlainesHerbeuses, function() map:changeMap("havenbag") end)
	elseif character:level() >= 155 then
		MAX_MONSTERS = character:level() < 165 and 7 or 8
		MIN_MONSTERS = character:level() < 165 and 2 or 3
		return treatMaps(Bourgade, function() map:changeMap("havenbag") end)
	elseif character:level() >= 145 then
		MAX_MONSTERS = 8
		MIN_MONSTERS = 4
		return treatMaps(RouteRocailleuse, function() map:changeMap("havenbag") end)
	elseif character:level() >= 136 then
		AMOUNT_MONSTERS = {{88, 0, 2}}
		MAX_MONSTERS = 8
		MIN_MONSTERS = 3
		return treatMaps(PresquIleDragoeuf, function() map:changeMap("havenbag") end)
	elseif character:level() >= 120 then
		MAX_MONSTERS = 8
		MIN_MONSTERS = 4
		return treatMaps(Gelee, function() map:changeMap("havenbag") end)
	else
		MAX_MONSTERS = 8
		MIN_MONSTERS = 4
		return treatMaps(Rivage, function() map:changeMap("havenbag") end)
	end
end

function move()
	handleDisconnection()
	
	if character:level() > 113 and not varianteDone then
		local tableIdSorts = {{Id = 12728, Lvl = 100}, {Id = 12731, Lvl = 100}, {Id = 12727, Lvl = 100}}
        for _, element in ipairs(tableIdSorts) do
            if character:level() >= element.Lvl then
                message = developer:createMessage("SpellVariantActivationRequestMessage")
                message.spellId = element.Id
                developer:sendMessage(message)
                global:delay(math.random(1000, 2500))
            end
        end
		varianteDone = true
		global:delay(1555)
	end

	if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        Abonnement()
    elseif getRemainingHoursSubscription() < 4 and character:server() == "Draconiros" then
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end
	mapDelay()
    if debutDeScript then
        debutDeScript = falses
        local ComptesPrets = {}
        local nbComptesPrets = 0
        for line in io.lines("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\ComptesAVendre.txt") do
            if line ~= "" then
                if line:find(character:server()) then 
                    local level = line:split(" ")[#line:split(" ")]
                    nbComptesPrets = nbComptesPrets + 1
                    ComptesPrets[level] = not ComptesPrets[level] and 1 or ComptesPrets[level] + 1
                end
            end
        end
		if nbComptesPrets < 4 then
			global:printSuccess("on arrete le pl à la fin de l'abonnement")
            levelToReach = 155
		elseif nbComptesPrets < 12 then
            global:printSuccess("on arrete le pl à la fin de l'abonnement")
            levelToReach = 160
        elseif not ComptesPrets["199"] then
            global:printSuccess("on veut atteindre le niveau 199")
            levelToReach = 200 -- normalement 199
        elseif not ComptesPrets["200"] then
            global:printSuccess("on veut atteindre le niveau 200")
            levelToReach = 200
        elseif ComptesPrets["200"] >= ComptesPrets["199"] then
            global:printSuccess("on veut atteindre le niveau 199")
            levelToReach = 200 -- normalement 199
        elseif ComptesPrets["200"] < ComptesPrets["199"] then
            global:printSuccess("on veut atteindre le niveau 200")
            levelToReach = 200
        end
    end

    if (levelToReach ~= 160 or character:level() < 155) and getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 700000 or 1100000)) then
        Abonnement()
    elseif (levelToReach ~= 160 or character:level() < 155) and getRemainingSubscription(true) < 0 then
        Abonnement()
    end

	if getRemainingSubscription(true) < 0 and (levelToReach ~= 160 or character:level() < 155) then
		return {
			{map = "6,-19", path = "left"},
			{map = "5,-19", path = "bottom"},
			{map = "5,-18", path = "left"},
			{map = "191104002", door = "288"},
			{map = "192415750", custom = takeKamas},
		}
	end

	if character:kamas() < 5000 then global:disconnect() end

	if global:thisAccountController():getAlias():find("LvlUp2") then
		stringalias = "LvlUp2 "
	elseif global:thisAccountController():getAlias():find("LvlUp3") then
		stringalias = "LvlUp3 "
	elseif global:thisAccountController():getAlias():find("LvlUp4") then
		stringalias = "LvlUp4 "
	elseif global:thisAccountController():getAlias():find("LvlUp") then
		stringalias = "LvlUp "
	end
	
	global:editAlias(stringalias .. " " .. character:server() .. "  / lvl " .. character:level(), true)

	if (character:level() == (levelToReach - 5)) or (levelToReach <= 160) and (character:level() >= 140) then
		local nbAccountInSameServ = 0

		for _, acc in ipairs(snowbotController:getLoadedAccounts()) do
			if acc:getAlias():find(character:server()) and acc:getAlias():find(stringalias) then
				nbAccountInSameServ = nbAccountInSameServ + 1
			end
		end

		if nbAccountInSameServ < 2 and not global:thisAccountController():getAlias():find("Draconiros") then
			CreateOtherAccount()
		end
	end

	if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end


    if (getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155) and getCurrentAreaName() ~= "Astrub" then
        global:disconnect()
    end

	if global:remember("failed") then
		if not global:remember("retryTimestamp") then global:addInMemory("retryTimestamp", os.time()) end

		if secondsToHours(os.time() - global:remember("retryTimestamp")) >= minRetryHours then
			rerollVar()
			global:editInMemory("retryTimestamp", 0)
		end
	end

	if not global:remember("failed") and ((character:kamas() > givingTriggerValue) or (character:level() >= levelToReach) or ((getRemainingSubscription(true) < 0) and (levelToReach == 160) and (character:level() >= 155))) then
		givingMode = true
	end

	if givingMode then
		if not connected then
			while not isBotBankAvailable() do
                global:printError("Le bot bank est connecté sur une autre instance, on attend 10 secondes")
                global:delay(10000)
            end
			receiver = connectReceiver()

			if cannotConnect then
				rerollVar()
				receiver:disconnect()
				global:editInMemory("retryTimestamp", os.time())
				global:addInMemory("failed", true)
				cannotConnect = false
			else
				connected = true
			end
		end

		if not global:remember("failed") then
			return goAstrubBank(launchExchangeAndGive)
		end
	end

	antiModo()

	if not equipFait then
		equiper()
		equipFait = true
	end

	return whichArea() 
end

function bank()
	mapDelay()
	if NeedToSell then
		return {
			{map ="0,0", path = "zaap(212600323)"},				
			{map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
			{map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
		}
	end

    if NeedToReturnBank then
        return {
            {map = "-30,-55", path = "top"},
			{map = "-30,-56", door = "437"},
			{map = "-31,-56", path = "top"},
            {map = "212600322", door = "512"}, -- Map extérieure de la banque de bonta
            {map = "217060352", custom = ProcessBank}, -- Dépôt de l'inventaire et sortie de la banque
        }
    end
	if map:currentMap()~= "0,0" and map:currentMap()~="-31,-54" and map:currentMap()~="-31,-55" and map:currentMap()~="-31,-56" and map:currentMapId()~=212601350 then 
		map:changeMap("havenbag")
	end
	for _, element in ipairs(AUTO_DELETE) do
		local nb = inventory:itemCount(element)
		if nb > 0 then
			inventory:deleteItem(element, nb)
		end
	end
	return {
		{map = "-31,-56", path = "bottom"},
		{map = "-31,-55", path = "bottom"},
		{map = "-31,-54", path = "right"},
		{map = "0,0", path = "zaap(212600323)"},
		{map = "212601350", custom = ProcessSell}, -- Map HDV ressources bonta
	}
		--{map = "147254", door="383"},	
end

function phenix()
	return {
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
	}
end

function prefightManagement(challengers, defenders)
	local DistanceEmplacement = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
	local cellIdOmbre = 0
	local CellulesWithDistance = { }

	local i = 1
	for cell1, id1 in pairs(challengers) do
		if not fightAction:isFreeCell(cell1) and (id1 == -1) then
			cellIdOmbre = cell1
		end
		for cell2, id2 in pairs(defenders) do
			if id2 ~= -1 then
				DistanceEmplacement[i] = DistanceEmplacement[i] + map:cellDistance(cell1, cell2)
			end
		end

		local element = {
			Cellid = cell1,
			DistanceTotale = DistanceEmplacement[i]
		}
		table.insert(CellulesWithDistance, element)
		i = i + 1
	end

	table.sort(CellulesWithDistance, function(a, b) return a.DistanceTotale < b.DistanceTotale end)

	for i = 1, 11 do
		if not fightAction:isFreeCell(CellulesWithDistance[i].Cellid) and (CellulesWithDistance[i].CellId == cellIdOmbre) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
			message.requestedId = -1
			message.cellId = cellIdOmbre
			developer.sendMessage(message)

			break
		end
		if fightAction:isFreeCell(CellulesWithDistance[i].Cellid) then
			local message = developer:createMessage("GameFightPlacementPositionRequestMessage")
			message.cellId = CellulesWithDistance[i + 1].Cellid
			developer.sendMessage(message)

			if cellIdOmbre ~= 0 then
				message = developer:createMessage("GameFightPlacementSwapPositionsRequestMessage")
				message.requestedId = -1
				message.cellId = cellIdOmbre
				developer.sendMessage(message)

				message = developer:createMessage("GameFightPlacementPositionRequestMessage")
				message.cellId = CellulesWithDistance[i].Cellid
				developer.sendMessage(message)
			end
			break
		end
	end
end

function chooseChallenge(challengeId, i)
	global:delay(global:random(500, 1000))
	local ChallengeSelectionMessage = developer:createMessage("ChallengeSelectionMessage")
	ChallengeSelectionMessage.challengeId = challengeId
	developer:sendMessage(ChallengeSelectionMessage)
	global:printMessage("Le challenge ("..fightChallenge:challengeName(challengeId)..") a été choisi pour le slot N°"..tostring(i)..".")
	return challengeId
end
	
function challengeManagement(challengeCount, isMule)

	-- Choix le type de bonus
	-- 0 = XP
	-- 1 = DROP
	local challengeBonus = 0

	-- Choix du mode des challenges
	-- 0 = Manuéatoire
	local challengeMod = 1
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------
	-------------------------------------------------------------------------------------------

	-- Texte variables
	local challengeBonusText = { "XP", "DROP" }
	local challengeModText = { "Manuel", "Aléatoire" }

	-- Choix le type de bonus
	local ChallengeBonusChoiceMessage = developer:createMessage("ChallengeBonusChoiceMessage")
	ChallengeBonusChoiceMessage.challengeBonus = challengeBonus
	developer:sendMessage(ChallengeBonusChoiceMessage)

	-- Choix du mode des challenges
	local ChallengeModSelectMessage = developer:createMessage("ChallengeModSelectMessage")
	ChallengeModSelectMessage.challengeMod = challengeMod
	developer:sendMessage(ChallengeModSelectMessage)

	-- Message
	if not isMule then
		global:printSuccess("Challenges: "..challengeModText[challengeMod + 1].." - Bonus: "..challengeBonusText[challengeBonus + 1])
	else
		global:printSuccess("[MULE] Bonus: "..challengeBonusText[challengeBonus + 1])
		return
	end
end

function fightManagement()
	-- Je vérifie dans un premier temps que c'est bien à moi de jouer :
		
		if fightCharacter:isItMyTurn() == true then
			if fightAction:getCurrentTurn() == 1 then
				lancable = 0
				incrementation = 0
			end
			
			delayFightStartTurn()

			-- J'avance vers mon ennemi le plus proche

			Deplacement()

			-- lancement mutilation
			if lancable == 0 then 
				if incrementation == 1 then
					if fightAction:getCurrentTurn() < 5 then
						Berserk()
					elseif map:currentSubArea() ~= "Pics de Cania" then
                        Libation()
                    end
					if fightCharacter:getAP() >= 6 then
						launchBestSort4pa()
					end
					if fightCharacter:getAP() >= 6 then
						launchBestSort4pa()
					end
					if fightCharacter:getAP() >= 5 then
						launchBestSort3pa()
					end
				end
				fightAction:castSpellOnCell(12737, fightCharacter:getCellId())
				incrementation = (incrementation == 0) and 1 or 0
				lancable = lancable + incrementation
			else
				lancable = lancable - 1
			end

			LaunchEpee_Vorace()

			Deplacement()
			if fightCharacter:getAP() % 4 ~= 0 then
				launchBestSort3pa()
				Deplacement()
			end

			launchBestSort4pa()
			Deplacement()
			launchBestSort4pa()
			Deplacement()

			launchBestSort3pa()
			DeplacementProche()
			Ravage(WeakerMonsterAdjacent())
			Deplacement()

			launchBestSort4pa()
			Deplacement()
			launchBestSort4pa()
			Deplacement()

			
			DeplacementProche()
			
			if NbMontresAdjacents(fightCharacter:getCellId()) == 0 then
				Attirance(fightAction:getNearestEnemy())
			end			
			launchBestSort4pa()
			Deplacement()
			launchBestSort4pa()
			Deplacement()

			launchBestSort3pa()

			Courrone_Epine()
			fightAction:passTurn()
		else

			delayFightStartTurn()
			
			MoveInLineOfForSlave(fightSlave:getNearestEnemy(), 6)

			Colere_Noire()

			Vengeance_Nocturne()

			DeplacementProcheSlave()

            local nearestEnnemi = fightSlave:getNearestEnemy()
            Diabolo_Chiste(nearestEnnemi)

            local entities = fightAction:getAllEntities()
            local AdjCases = fightAction:getAdjacentCells(fightSlave:cellId())
            local newEnnemi = nil

            for _, cellId in ipairs(AdjCases) do
                for _, entity in ipairs(entities) do
                    if (entity.CellId == cellId) and entity.Team and (entity.CellId ~= nearestEnnemi) then
                        newEnnemi = entity.CellId
                    end
                end
            end
            if newEnnemi == nil then
                newEnnemi = fightSlave:getNearestEnemy()
            end
            if newEnnemi ~= nearestEnnemi then
                Diabolo_Chiste(newEnnemi)
            end

			DeplacementSlave()

			Cartilage(fightSlave:getNearestEnemy())
			DeplacementSlave()
			Vengeance_Nocturne()
			DeplacementSlave()
			Ombrolingo(fightSlave:getNearestEnemy())
			DeplacementSlave()
			Ombrolingo(fightSlave:getNearestEnemy())
			
			Crepuscule(fightSlave:getNearestEnemy())
			DeplacementSlave()
			Crepuscule(fightSlave:getNearestEnemy())

			Vengeance_Nocturne2()
	
			if fightSlave:entity().MP > 0 then
				local entities = fightAction:getAllEntities()
				for _, element in ipairs(entities) do
					-- on cherche le sacrieur
					if not element.Team and not element.Companion then
						local zone = fightAction:getCells_square(element.CellId, 1, 1)
						for _, cellId in ipairs(zone) do
							-- on regarde si on se trouve dans sa zone bain de sang
							if fightSlave:cellId() == cellId then
								-- si c'est le cas on regarde pour finir son tour dans sa case adjacente la plus éloignée du sacrieur
								local cellWhereMove = fightAction:getCells_lozenge(fightSlave:cellId(), 1, 2)
								table.sort(cellWhereMove, function(a, b) return fightAction:getDistance(a, element.CellId) > fightAction:getDistance(b, element.CellId) end)
								fightSlave:moveTowardCell(cellWhereMove[1])
								break
							end
						end
						break
					end
				end
			end

			fightAction:passTurn()

		end
end
