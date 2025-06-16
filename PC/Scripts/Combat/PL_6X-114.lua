---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")

-- Generated On Dofus-Map with Drigtime's SwiftPath Script Maker --
-- Nom : 
-- Zone : 
-- Type : 
-- Version : 1.0
-- Auteur : 

GATHER = {}
OPEN_BAGS = true
AUTO_DELETE = {9379, 9380, 9472, 367, 375, 16828, 13435, 11134, 2549 ,16826, 6926, 6929, 6908, 6928, 792, 16358, 16824, 398, 1672, 16835, 2302, 2303, 464, 16835, 8518, 2583, 463, 437, 1690, 2573, 407, 387, 386, 435, 434, 2576, 16830, 6910, 6909, 652, 6910, 16825, 16825, 2414, 2422, 383 , 2455 , 16819 , 1731 , 6921 , 6920 , 6919 , 6922 , 911 , 2419 ,2428 , 2425 , 2416 , 2411 , 892 ,16832 , 6794 , 6792 , 6796 , 8247,16829,8245,8248,8246,8223,8229,8217,8236,8241, 417, 384, 2858, 679, 16827, 16823, 380, 994, 995, 993, 311, 16833, 2585, 381, 1528, 1529, 1526, 1527, }

MAX_MONSTERS = 8
MIN_MONSTERS = 1

FORCE_MONSTERS = {}
FORBIDDEN_MONSTERS = {3313, 3314, 3315, 3316, 3529, 171, 200}


local lancable = 0
local incrementation = 0
local hdv_door_id = 218
local cptActualiser = 0

-- if global:thisAccountController():getAlias():find("LvlUp ") then
--     PLANNING = {17, 18 , 19, 20, 21, 22, 23}
-- else
--     PLANNING = {9, 10, 11, 12, 13, 14, 15}
-- end

local tableEquip = {
	{name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
	{name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
	{name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
	{name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
	{name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
	{name = "arme sasa", id = 478, emplacement = 1, equipe = false},
	{name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},
	{name = "gelano", id = 2469, emplacement = 4, equipe = false},
	{name = "trophet 1", id = 13748, equipe = false, emplacement = 9},
	{name = "dofus cawotte", id = 972, equipe = false, emplacement = 10},
	{name = "trophet 4", id = 13793, equipe = false, emplacement = 11},
    {name = "dofus argenté", id = 19629, emplacement = 12, equipe = false},
	--{Type = "compagnon", id = 14966, equipe = false, emplacement = 28}
}

local tableVente = {
	{Name = "armée de tique", id = 2449, maxHdv100 = 0, maxHdv10 = 10, maxHdv1 = 15, canSell = true, delete = false},
	{Name = "oeil de boufton", id = 2460, maxHdv100 = 0, maxHdv10 = 10, maxHdv1 = 15, canSell = true, delete = false},
	{Name = "laine de boufton noir", id = 885, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "laine de bouftou", id = 384, maxHdv100 = 4, maxHdv10 = 8, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "laine du chef de guerre bouftou", id = 882, maxHdv100 = 5, maxHdv10 = 15, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "corne de chef de guerre bouftou", id = 2465, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},
	{Name = "épine du champ champ", id = 377, maxHdv100 = 4, maxHdv10 = 8, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "sporme du champ champ", id = 378, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},
	{Name = "pétale de rose démoniaque", id = 309, maxHdv100 = 5, maxHdv10 = 15, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "bave de rose démoniaque", id = 2662, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},

	{Name = "Métaria rouge", id = 1526, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria bleu", id = 1527, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria jaune", id = 1528, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria verte", id = 1529, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Rouge", id = 1465, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne de Scarafeuille Vert", id = 1466, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1467, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Fruit de Palme", id = 398, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, canSell = true, delete = false},

	{Name = "Gelée bleutée", id = 757, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la fraise", id = 368, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Gelée à la menthe", id = 369, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 0, Total = 7, canSell = true, delete = false},

	{Name = "Pince de crabe", id = 379, maxHdv100 = 10, maxHdv10 = 15, maxHdv1 = 0, Total = 25, canSell = true, delete = false},
	{Name = "Paupière d'etoile", id = 13728, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},
	{Name = "Peau de raulmops", id = 8681, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, Total = 15, canSell = true, delete = false},

	{Name = "Duvet de Tofoune", id = 8484, maxHdv100 = 1, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Plume de Tofu", id = 301, maxHdv100 = 3, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Cocon de Ver à Soie", id = 642, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 6, canSell = true, delete = false},
	{Name = "Patte de Tofukaz", id = 2571, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Estomac de Tofukaz", id = 2572, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œuf Pourri", id = 2673, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Œil de Tofu Noir", id = 2579, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Tissu Sombre", id = 2285, maxHdv100 = 0, maxHdv10 = 2, maxHdv1 = 4, canSell = true, delete = false},


	{Name = "Plume de Piou Rouge", id = 6900, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Jaune", id = 6902, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Vert", id = 6899, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Bleu", id = 6897, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Violet", id = 6898, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Rose", id = 6903, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Œil d'Arakmuté", id = 2491, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils d'Arakne Malade", id = 388, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Intestin d'Araknosé", id = 373, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Bec du Tofu", id = 366, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Conque Marine", id = 13726, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Crème à bronzer", id = 13727, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},


	{Name = "Peau de Larve Bleue", id = 362, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Orange", id = 363, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Verte", id = 364, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Jaune", id = 2563, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},

	{Name = "Crocs de Rats", id = 2322, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Cuir de Scélérat Strubien", id = 304, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},

	{Name = "Noisette", id = 394, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Étoffe d'Écurouille", id = 653, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils du Milimulou", id = 1690, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Scalp de Milimulou", id = 2576, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Pic du Prespic", id = 407, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Queue de Prespic", id = 2573, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils Darits", id = 1672, canSell = true, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Groin de Sanglier", id = 386, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Défense du Sanglier", id = 387, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Étoffe du Sanglier", id = 652, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Viande Intangible", id = 16663, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande Hachée", id = 17123, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande faisandée", id = 17124, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande Frelatée", id = 17126, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
}

local tableValeurVente = {
	{Name = "armée de tique", id = 2449, maxHdv100 = 0, maxHdv10 = 10, maxHdv1 = 15, canSell = true, delete = false},
	{Name = "oeil de boufton", id = 2460, maxHdv100 = 0, maxHdv10 = 10, maxHdv1 = 15, canSell = true, delete = false},
	{Name = "laine de boufton noir", id = 885, maxHdv100 = 5, maxHdv10 = 10, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "laine de bouftou", id = 384, maxHdv100 = 4, maxHdv10 = 8, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "laine du chef de guerre bouftou", id = 882, maxHdv100 = 5, maxHdv10 = 15, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "corne de chef de guerre bouftou", id = 2465, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},
	{Name = "épine du champ champ", id = 377, maxHdv100 = 4, maxHdv10 = 8, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "sporme du champ champ", id = 378, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},
	{Name = "pétale de rose démoniaque", id = 309, maxHdv100 = 5, maxHdv10 = 15, maxHdv1 = 0, canSell = true, delete = false},
	{Name = "bave de rose démoniaque", id = 2662, maxHdv100 = 0, maxHdv10 = 4, maxHdv1 = 8, canSell = true, delete = false},

	{Name = "Métaria rouge", id = 1526, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria bleu", id = 1527, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria jaune", id = 1528, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Métaria verte", id = 1529, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Bleu", id = 1455, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Blanc", id = 1456, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Rouge", id = 1457, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Ailes de Scarafeuille Vert", id = 1458, maxHdv100 = 2, maxHdv10 = 7, maxHdv1 = 5, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Bleu", id = 1464, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Rouge", id = 1465, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne de Scarafeuille Vert", id = 1466, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Antenne du Scarafeuille Blanc", id = 1467, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Blanc", id = 2290, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Bleu", id = 2291, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Rouge", id = 2292, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Carapace de Scarafeuille Vert", id = 2293, maxHdv100 = 2, maxHdv10 = 5, maxHdv1 = 4, canSell = true, delete = false},
	{Name = "Fruit de Palme", id = 398, maxHdv100 = 2, maxHdv10 = 4, maxHdv1 = 3, canSell = true, delete = false},
	{Name = "Viscères de Scarafeuille", id = 2294, maxHdv100 = 0, maxHdv10 = 3, maxHdv1 = 3, canSell = true, delete = false},

	{Name = "Plume de Piou Rouge", id = 6900, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Jaune", id = 6902, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Vert", id = 6899, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Bleu", id = 6897, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Violet", id = 6898, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Plume de Piou Rose", id = 6903, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Œil d'Arakmuté", id = 2491, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils d'Arakne Malade", id = 388, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Intestin d'Araknosé", id = 373, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Bec du Tofu", id = 366, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Conque Marine", id = 13726, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Crème à bronzer", id = 13727, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},


	{Name = "Peau de Larve Bleue", id = 362, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Orange", id = 363, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Verte", id = 364, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Peau de Larve Jaune", id = 2563, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},

	{Name = "Crocs de Rats", id = 2322, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Cuir de Scélérat Strubien", id = 304, canSell = true, maxHdv100 = 3, maxHdv10 = 3, maxHdv1 = 0, delete = false},

	{Name = "Noisette", id = 394, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Étoffe d'Écurouille", id = 653, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils du Milimulou", id = 1690, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Scalp de Milimulou", id = 2576, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Pic du Prespic", id = 407, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Queue de Prespic", id = 2573, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Poils Darits", id = 1672, canSell = true, maxHdv100 = 1, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Groin de Sanglier", id = 386, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Défense du Sanglier", id = 387, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},
	{Name = "Étoffe du Sanglier", id = 652, canSell = true, maxHdv100 = 2, maxHdv10 = 2, maxHdv1 = 0, delete = false},

	{Name = "Viande Intangible", id = 16663, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande Hachée", id = 17123, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande faisandée", id = 17124, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
	{Name = "Viande Frelatée", id = 17126, canSell = true, maxHdv100 = 5, maxHdv10 = 3, maxHdv1 = 0, delete = false},
}

local boo = {
		{map = "12,12", path = "havenbag"},
		{map = "162791424", path = "zaap(88082704)"},
		{map = "88082704", path = "right"},
		{map = "5,7", path = "right"},
		{map = "6,7", path = "right"},
		{map = "8,7", path = "right"},
		{map = "7,7", path = "right"},
		{map = "9,7", path = "right"},
		{map = "10,7", path = "right"},
		{map = "11,7", path = "right"},
		{map = "1,-16", path = "right"},
		{map = "1,-15", path = "right"},
		{map = "2,-15", path = "right"},
		{map = "3,-15", path = "right"},
		{map = "4,-15", path = "right"},
		{map = "1,-18", path = "right"},
		{map = "2,-18", path = "right"},
		{map = "3,-18", path = "right"},
		{map = "3,-19", path = "right"},
		{map = "4,-19", path = "right"},
		{map = "3,-17", path = "right"},
		{map = "4,-17", path = "right"},
		{map = "3,-20", path = "right"},
		{map = "3,-21", path = "right"},
		{map = "1,-20", path = "right"},
		{map = "2,-20", path = "right"},
		{map = "1,-17", path = "right"},
		{map = "1,-19", path = "right"},
		{map = "3,-16", path = "right"},
		{map = "4,-16", path = "right"},
		{map = "2,-16", path = "right"},
		{map = "6,-15", path = "left"},
		{map = "6,-16", path = "left"},
		{map = "7,-15", path = "left"},
		{map = "7,-16", path = "left"},
		{map = "7,-18", path = "left"},
		{map = "7,-20", path = "left"},
		{map = "7,-21", path = "left"},
		{map = "6,-21", path = "left"},
		{map = "6,-20", path = "left"},
		{map = "6,-19", path = "left"},
		{map = "5,-19", path = "left"},
		{map = "5,-21", path = "left"},
		{map = "5,-20", path = "left"},
		{map = "5,-19", path = "bottom"},
		{map = "5,-18", path = "zaap(88082704)"},
		{map = "5,-17", path = "bottom"},
		{map = "5,-16", path = "bottom"},
		{map = "5,-15", path = "bottom"},
		{map = "4,-20", path = "bottom"},
		{map = "4,-21", path = "bottom"},
		{map = "2,-19", path = "bottom"},
		{map = "7,-17", path = "bottom"},
		{map = "7,-19", path = "bottom"},
		{map = "6,-18", path = "left"},
		{map = "2,-17", path = "top"},
		{map = "5,-14", path = "bottom"},
		{map = "5,-13", path = "bottom"},
		{map = "5,-12", path = "bottom"},
		{map = "5,-11", path = "bottom"},
		{map = "5,-10", path = "bottom"},
		{map = "5,-9", path = "left"},
		{map = "4,-9", path = "left"},
		{map = "3,-9", path = "left"},
		{map = "2,-9", path = "bottom"},
		{map = "2,-8", path = "left"},
		{map = "1,-8", path = "445"},
		{map = "1,-7", path = "left"},
		{map = "1,-6", path = "left"},
		{map = "0,-6", path = "bottom"},
		{map = "0,-7", path = "bottom"},
		{map = "0,-5", path = "bottom"},
		{map = "0,-4", path = "bottom"},
		{map = "0,-3", path = "bottom"},
		{map = "0,-2", path = "bottom"},
		{map = "0,-1", path = "bottom"},
		{map = "88212247", path = "bottom"},
		{map = "0,1", path = "right"},
		{map = "1,1", path = "right"},
		{map = "2,1", path = "right"},
		{map = "3,1", path = "right"},
		{map = "4,1", path = "right"},
		{map = "5,1", path = "right"},
		{map = "6,1", path = "right"},
		{map = "7,1", path = "right"},
		{map = "8,1", path = "bottom"},
		{map = "8,2", path = "bottom"},
		{map = "8,3", path = "bottom"},
		{map = "8,4", path = "right"},
		{map = "9,4", path = "right"},
		{map = "10,4", path = "right"},
		{map = "11,4", path = "right"},
		{map = "12,4", path = "bottom"},
		{map = "12,5", path = "bottom", fight = true},
		{map = "12,6", path = "bottom", fight = true},
		{map = "12,7", path = "bottom", fight = true},
		{map = "12,8", path = "bottom|right", fight = true},
		{map = "12,9", path = "top", fight = true},
		{map = "13,8", path = "top", fight = true},
		{map = "13,7", path = "top", fight = true},
		{map = "13,6", path = "top", fight = true},
		{map = "13,5", path = "left", fight = true},
}

local bouftou = {
	{map = "162791424", path = "zaap(88082704)"},
	{map = "5,7", path = "bottom"},
	{map = "5,8", path = "right", fight = true},
	{map = "6,8", path = "bottom", fight = true},
	{map = "6,9", path = "bottom", fight = true},
	{map = "6,10", path = "right", fight = true},
	{map = "7,10", path = "bottom", fight = true},
	{map = "7,11", path = "left", fight = true},
	{map = "6,11", path = "left", fight = true},
	{map = "5,11", path = "top", fight = true},
	{map = "3,11", path = "top", fight = true},
	{map = "5,10", path = "left", fight = true},
	{map = "4,11", path = "left", fight = true},
	{map = "3,10", path = "left", fight = true},
	{map = "2,10", path = "bottom", fight = true},
	{map = "2,11", path = "bottom", fight = true},
	{map = "2,12", path = "left", fight = true},
	{map = "1,12", path = "left", fight = true},
	{map = "0,12", path = "top", fight = true},
	{map = "1,11", path = "top", fight = true},
	{map = "0,10", path = "top", fight = true},
	{map = "0,11", path = "right", fight = true},
	{map = "1,10", path = "left", fight = true},
	{map = "1,9", path = "top", fight = true},
	{map = "0,8", path = "top", fight = true},
	{map = "0,7", path = "right", fight = true},
	{map = "1,7", path = "bottom", fight = true},
	{map = "1,8", path = "left|right", fight = true},
	{map = "0,9", path = "right", fight = true},
	{map = "2,8", path = "bottom", fight = true},
	{map = "2,9", path = "right", fight = true},
	{map = "3,8", path = "right", fight = true},
	{map = "4,9", path = "right", fight = true},
	{map = "3,9", path = "top", fight = true},
	{map = "4,8", path = "bottom", fight = true},
	{map = "5,9", path = "top", fight = true},
	{map = "4,10", path = "bottom", fight = true},
}

local scarafeuille = {
	{map = "0,0", path = "zaap(88212481)"},
	{map = "-1,24", path = "right"},
	{map = "0,24", path = "bottom", fight = true},
	{map = "0,25", path = "bottom", fight = true},
	{map = "0,26", path = "bottom", fight = true},
	{map = "0,27", path = "bottom", fight = true},
	{map = "0,28", path = "bottom", fight = true},
	{map = "0,29", path = "bottom", fight = true},
	{map = "1,30", path = "bottom", fight = true},
	{map = "0,30", path = "right", fight = true},
	{map = "1,31", path = "right"},
	{map = "2,31", path = "bottom", fight = true},
	{map = "2,32", path = "right", fight = true},
	{map = "3,32", path = "right", fight = true},
	{map = "4,32", path = "right", fight = true},
	{map = "5,32", path = "top", fight = true},
	{map = "5,31", path = "top", fight = true},
	{map = "5,30", path = "top", fight = true},
	{map = "5,29", path = "top", fight = true},
	{map = "5,28", path = "left", fight = true},
	{map = "4,28", path = "bottom", fight = true},
	{map = "4,29", path = "bottom", fight = true},
	{map = "4,30", path = "bottom", fight = true},
	{map = "4,31", path = "left", fight = true},
	{map = "3,31", path = "top", fight = true},
	{map = "3,30", path = "top", fight = true},
	{map = "3,29", path = "top", fight = true},
	{map = "3,28", path = "top", fight = true},
	{map = "3,27", path = "right", fight = true},
	{map = "4,27", path = "top", fight = true},
	{map = "4,26", path = "left", fight = true},
	{map = "3,26", path = "top", fight = true},
	{map = "3,25", path = "top", fight = true},
	{map = "3,24", path = "top", fight = true},
	{map = "3,23", path = "left", fight = true},
	{map = "2,23", path = "bottom", fight = true},
	{map = "2,24", path = "bottom", fight = true},
	{map = "2,25", path = "bottom", fight = true},
	{map = "2,26", path = "bottom", fight = true},
	{map = "2,27", path = "bottom", fight = true},
	{map = "2,28", path = "bottom", fight = true},
	{map = "2,29", path = "left", fight = true},
	{map = "1,29", path = "top", fight = true},
	{map = "1,28", path = "top", fight = true},
	{map = "1,27", path = "top", fight = true},
	{map = "1,26", path = "top", fight = true},
	{map = "1,25", path = "top", fight = true},
	{map = "1,24", path = "left", fight = true},
}

local champsIngalsse = {
	{map = "0,0", path = "zaap(88082704)"},
	{map = "5,6", path = "top", fight = true},
	{map = "5,7", path = "top"},
	{map = "5,5", path = "right", fight = true},
	{map = "6,5", path = "right", fight = true},
	{map = "7,5", path = "top", fight = true},
	{map = "7,4", path = "top", fight = true},
	{map = "7,3", path = "right", fight = true},
	{map = "8,3", path = "right", fight = true},
	{map = "9,3", path = "right", fight = true},
	{map = "10,3", path = "bottom", fight = true},
	{map = "10,4", path = "left", fight = true},
	{map = "9,4", path = "left", fight = true},
	{map = "8,4", path = "bottom", fight = true},
	{map = "8,5", path = "right", fight = true},
	{map = "9,5", path = "right", fight = true},
	{map = "10,5", path = "right", fight = true},
	{map = "11,5", path = "bottom", fight = true},
	{map = "11,6", path = "left", fight = true},
	{map = "10,6", path = "left", fight = true},
	{map = "9,6", path = "left", fight = true},
	{map = "8,6", path = "left", fight = true},
	{map = "7,6", path = "bottom", fight = true},
	{map = "7,7", path = "right", fight = true},
	{map = "9,7", path = "right", fight = true},
	{map = "8,7", path = "right", fight = true},
	{map = "10,7", path = "right", fight = true},
	{map = "11,7", path = "bottom", fight = true},
	{map = "11,8", path = "left", fight = true},
	{map = "10,8", path = "left", fight = true},
	{map = "9,8", path = "bottom", fight = true},
	{map = "9,9", path = "left", fight = true},
	{map = "8,9", path = "left", fight = true},
	{map = "7,9", path = "top", fight = true},
	{map = "7,8", path = "left", fight = true},
	{map = "6,8", path = "top"},
	{map = "6,7", path = "top", fight = true},
	{map = "6,6", path = "left", fight = true},
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
	{map = "9,21", path = "left"},
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

local function ProcessSell()
	NeedToSell = false
	NeedToReturnBank = true

	table.sort(tableVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)
	table.sort(tableValeurVente, function(a, b) return inventory:itemCount(a.id) > inventory:itemCount(b.id) end)

	HdvSell()
	-- vente par 100, 10 des récoles alchimiste
	for i, element in ipairs(tableVente) do
		if inventory:itemCount(element.id) == 0 then global:printSuccess("on a plus rien à vendre") break end

		local itemSold = false

		cpt = get_quantity(element.id).quantity["100"]
		local priceItem = GetPricesItem(element.id)
		priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100

		while (inventory:itemCount(element.id) >= 100) and (sale:AvailableSpace() > 0) and (priceItem.Price100 > 2000) and (cpt < element.maxHdv100) and (sale:AvailableSpace() > 50 or (priceItem.Price100 > 10000)) do 
            sale:SellItem(element.id, 100, priceItem.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. priceItem.Price100 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end

		element.maxHdv100 = ((sale:AvailableSpace() > 50) or (priceItem.Price100 > 10000)) and tableValeurVente[i].maxHdv100 or 0

		cpt = get_quantity(element.id).quantity["10"]
		priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10

		while (inventory:itemCount(element.id) >= 10) and (sale:AvailableSpace() > 0) and (priceItem.Price10 > 500) and (cpt < element.maxHdv10) and (sale:AvailableSpace() > 50 or (priceItem.Price10 > 4000)) do 
			sale:SellItem(element.id, 10, priceItem.Price10 - 1) 
			global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
			cpt = cpt + 1
			itemSold = true
		end

		element.maxHdv10 = ((sale:AvailableSpace() > 50) or (Priceitem2 > 4000)) and tableValeurVente[i].maxHdv10 or 0

        cpt = get_quantity(element.id).quantity["1"]
		priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price1 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1

        while (inventory:itemCount(element.id) >= 1) and (sale:AvailableSpace() > 0) and (priceItem.Price1 > 100) and (cpt < element.maxHdv1) and (sale:AvailableSpace() > 50 or (priceItem.Price1 > 500)) do 
            sale:SellItem(element.id, 1, priceItem.Price1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. priceItem.Price1 - 1 .. "kamas")
            cpt = cpt + 1
			itemSold = true
        end

		element.maxHdv1 = ((sale:AvailableSpace() > 50) or (Priceitem3 > 500)) and tableValeurVente[i].maxHdv1 or 0

		element.delete = ((element.maxHdv1 == 0)) and ((element.maxHdv10 == 0)) and ((element.maxHdv100 == 0))
                        or (Priceitem1 <= 2000 and inventory:itemCount(element.id) >= 100)
						or (Priceitem2 <= 500 and inventory:itemCount(element.id) >= 10)
						or (Priceitem3 <= 100 and inventory:itemCount(element.id) >= 1)

		if itemSold then
			randomDelay()
		end
    end

	global:printSuccess("fini")

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
		if (get_quantity(element.id).quantity["100"] >= element.maxHdv100) and (get_quantity(element.id).quantity["10"] >= element.maxHdv10) and (get_quantity(element.id).quantity["1"] >= element.maxHdv1) then
			element.canSell = false
		else
			element.canSell = true
		end
		if element.delete then
			inventory:deleteItem(element.id, inventory:itemCount(element.id))
		end
	end
	

	global:leaveDialog()

	map:changeMap("top")
end

local function equiper()
	for _, element in ipairs(tableEquip) do
		if not element.equipe and inventory:itemCount(element.id) >= 1 then
			inventory:equipItem(element.id, element.emplacement)
			element.equipe = true
		end
	end
 -- Amulette 0 Arme 1 Anneau (gauche) 2 Ceinture 3 Anneau (droite) 4 Bottes 5 Chapeau 6 cape 7
end

local function restat(acc)
    local accDeveloper = acc and acc.developer or developer

    accDeveloper:sendMessage(developer:createMessage("ResetCharacterStatsRequestMessage"))
    developer:suspendScriptUntil("CharacterStatsListMessage", 500, false)
end


local function whichArea()
	if character:level() >= 105 then
		MIN_MONSTERS = 3
		MAX_MONSTERS = 7
		return treatMaps(Gelee, function() map:changeMap("havenbag") end)
	elseif character:level() >= 100 then
		MIN_MONSTERS = 2
		MAX_MONSTERS = 6
		return treatMaps(Rivage, function() map:changeMap("havenbag") end)
	elseif character:level() >= 82 then
		MIN_MONSTERS = 3
		MAX_MONSTERS = 7
		return treatMaps(Gelee, function() map:changeMap("havenbag") end)
	elseif character:level() >= 75 then
		MIN_MONSTERS = 2
		MAX_MONSTERS = 6
		return treatMaps(Gelee, function() map:changeMap("havenbag") end)
	elseif character:level() >= 60 then
		MIN_MONSTERS = 4
		return treatMaps(scarafeuille, function() map:changeMap("havenbag") end)
    -- elseif character:level() >= 70 then
	-- 	MIN_MONSTERS = 4
	-- 	return treatMaps(bouftou, function() map:changeMap("havenbag") end)
	else
		return treatMaps(boo, function() map:changeMap("havenbag") end)
	end
end

local function ProcessBank()
	NeedToReturnBank = false
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
            local TotalMax = element.maxHdv100 * 100 + element.maxHdv10 * 10 + element.maxHdv1
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.id)))
            if ((element.maxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.maxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.canSell then
                exchange:getItem(element.id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
		NeedToSell = (cpt > 5) or (inventory:podsP() > 50)
	end

	hdvFull = false

	global:leaveDialog()

	return map:door(518)
end


function move()
	handleDisconnection()
	mapDelay()

	if character:level() >= 105 and not done then
		done = true
		local message = developer:createMessage("SpellVariantActivationRequestMessage")
		message.spellId = 12731
		developer:sendMessage(message)
		global:delay(1555)
	end

	for i = 1, NB_LVLUP do
        if global:thisAccountController():getAlias():find("LvlUP" .. i) then
            global:editAlias("LvlUp" .. i .. " " .. character:server() .. " level : [" .. character:level() .. "]" .. " " .. getRemainingSubscription(true), true)
            break
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
    if character:level() >= 60 and not compagnonEquipe then
		compagnonEquipe = true
		inventory:equipItem(14966, 28) -- compagnon
		inventory:equipItem(18690, 15)
		inventory:equipItem(17078, 14)
	end
	if not equipFait then
		equiper()
		equipFait = true
	end

	if not equipAAFait and (character:level() >= 110) then
		global:printSuccess("On équipe des items aa")
		inventory:equipItem(8465, 0)
		inventory:equipItem(8467, 5)
		equipAAFait = character:level() >= 110
	end

	forwardKamasBotBankIfNeeded(750000, 200000, 120, 6)



 	if character:level() >= 114 then
		global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_199.xml")
		restat()
		upgradeCharacteristics(0, 200, 170, 0, 200)
		global:loadConfigurationWithoutScript("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Configs\\Config_PL_1-6X.xml")
		global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Combat\\PL_114-XXX.lua")
	end
	if map:onMap("0,0") then
		if actualMap == "12,12" then
			map:changeMap("zaap(191105026)")
		end
	else
		actualMap = map:currentMap()
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
	if map:currentMap()~= "0,0" and map:currentMap()~="-31,-56" and map:currentMap()~="-31,-54" and map:currentMap()~="-31,-55" and map:currentMapId()~=212601350 then 
		map:changeMap("havenbag")
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


function PHENIX()
	return PHENIX
end

function BestChoiceForZone2(cellIdLauncher, spellId, nearestEnnemi, poMax, canHurtAllies)
	local entities = fightAction:getAllEntities()
	local spellZone = fightAction:getSpellZone(spellId, nearestEnnemi)
	local nbMonsterInZone = { }
	for i = 1, #spellZone do
		table.insert(nbMonsterInZone, 0)
	end

	-- calcul du nombre d'ennemi dans la zone
	for i, cellId in ipairs(spellZone) do
		newAdjCases = ((fightAction:getDistance(cellId, cellIdLauncher) < (poMax + 1)) 
						and (fightAction:getDistance(cellId, cellIdLauncher) > 1)
						and fightAction:inLineOfSight(cellIdLauncher, cellId)
						and fightAction:isWalkable(cellId))
						and fightAction:getSpellZone(spellId, cellId) or { }

		for _, element2 in ipairs(newAdjCases) do
			for _, element3 in ipairs(entities) do
				if (element2 == element3.CellId) and element3.Team and not iStop then
					nbMonsterInZone[i] = nbMonsterInZone[i] + 1
				end
				if not canHurtAllies and (element2 == element3.CellId) and not element3.Team then
					nbMonsterInZone[i] = 0
					iStop = true
				end
			end
		end
		iStop = false
	end

	local i = 1
	local nbMinMonter = 0
	for j = 1, #nbMonsterInZone do
		if nbMonsterInZone[j] > nbMinMonter then
			nbMinMonter = nbMonsterInZone[j]
			i = j
		end
	end


	if (nbMonsterInZone[i] == 1) and (fightAction:canCastSpellOnCell(cellIdLauncher, spellId, nearestEnnemi) == 0) then
        cellid = nearestEnnemi
	elseif i ~= 1 then
		cellid = spellZone[i]
	elseif (i == 1) and (nbMonsterInZone[i] ~= 0) then
		cellid = nil
	end

	return {cellid, nbMinMonter}
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

				if fightAction:getCurrentTurn()==1 then
					lancable = 0
					incrementation = 0
				end

				delayFightStartTurn()
				
				Deplacement()

				-- lancement mutilation
				if lancable == 0 then 
					if incrementation == 2 then
						if fightCharacter:getLevel() > 84 and fightAction:getCurrentTurn() < 5 then
							Berserk()
						end
						if fightCharacter:getLifePointsP() < 20 and fightCharacter:getLevel() > 79 then
							Libation()
						end
						if fightCharacter:getAP() > 5 and fightCharacter:getLevel() > 109 then
							BainDeSang()
						elseif fightCharacter:getAP() > 5 and fightCharacter:getLevel() <= 109 then
							Hecatombe()
						end

						if fightCharacter:getLevel() > 79 and fightCharacter:getAP() >= 4 then
							Libation()
						end
						if fightCharacter:getAP() > 4 and fightCharacter:getLevel() <= 109 then
							Absorption(WeakerMonsterAdjacent())
						end
						if fightCharacter:getAP() > 3 then
							Hostilite(WeakerMonsterAdjacent())
						end
					end
                    
					fightAction:castSpellOnCell(12737, fightCharacter:getCellId())
					incrementation = (incrementation == 0) and 2 or 0
					lancable = lancable + incrementation
				else
					lancable = lancable - 1
				end

				LaunchEpee_Vorace()
				-- lancement bain de sang

				if fightCharacter:getLevel() > 109 then
					BainDeSang()		
				else
					Hecatombe()	
					Deplacement()
					Hecatombe()
				end

				if fightCharacter:getLevel() > 99 then
					Punition(WeakerMonsterAdjacent())
				end		
				-- J'avance vers mon ennemi le plus proche
				Deplacement()


				if (fightCharacter:getLifePointsP() < 40) and (GetEntitiesAdjacents() > 0) then
					Courrone_Epine()
				end

				if fightCharacter:getLevel() <= 109 then
					Absorption(WeakerMonsterAdjacent())
				end		


				Deplacement()

				if fightCharacter:getLevel() <= 109 then
					Absorption(WeakerMonsterAdjacent())
				end	

				Condensation()	

				if fightCharacter:getLevel() <= 109  then
					Absorption(WeakerMonsterAdjacent())
				end	

				if not fightAction:isHandToHand(fightCharacter:getCellId(), fightAction:getNearestEnemy()) then
					Attirance(fightAction:getNearestEnemy())
				end

				Deplacement()
				if fightCharacter:getLevel() > 109 then
					BainDeSang()		
				else
					Hecatombe()	
					Deplacement()
					Hecatombe()
				end
				if fightCharacter:getLevel() > 99 then
					Punition(WeakerMonsterAdjacent())
				end		

				Condensation()	

				-- lancement douleur cuisante

				if fightCharacter:getLevel() <= 109 then
					Absorption(WeakerMonsterAdjacent())
				end	
				Deplacement()
				if fightCharacter:getLevel() <= 109 then
					Absorption(WeakerMonsterAdjacent())
				end	

				Hostilite(WeakerMonsterAdjacent())
				
				Deplacement()
				if fightCharacter:getLevel() > 109 then
					BainDeSang2()			
				end
				fightAction:passTurn()
			else
				delayFightStartTurn()

				DeplacementSlave()
	
				Colere_Noire()
	
				Vengeance_Nocturne()
	
				DeplacementSlave()
	
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
				-- faire en sorte ue s'il se trouve dans une zone bain de sang, il se décale
		
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