---@diagnostic disable: undefined-global, lowercase-global

dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Lib\\IMPORT_LIBRARIES.lua")
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\IA\\IA_SacriFeuRecolte.lua")


GATHER = {17, 53, 55, 37, 54, 52, 114, 24, 26, 25, 135}
OPEN_BAGS = true
GATHER_NEXT_DELAY_MIN = 0
GATHER_NEXT_DELAY_MAX = 50
GATHER_NEW_DELAY_MIN = 500
GATHER_NEW_DELAY_MAX = 2000
--PLANNING = {3, 8, 13, 18, 23}

local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local achat = false
local DebutDuScript = true
local actualiser = true
local CraftQuantity = 0
local hdv_door_id = 218

local MAPS_SANS_HAVRESAC = {
    {Id = 168034306, Door = "471"},
    {Id = 168034308, Door = "464"},
    {Id = 168035328, Door = "458"},
    {Id = 168034312, Door = "213"},
    {Id = 168034310, Door = "493"},
    {Id = 104859139, Path = "444"},
    {Id = 168167424, Door = "289"},
    {Id = 168167424, Door = "289"},
    {Id = 104861191, Path = "457"},
    {Id = 57017859, Path = "395"},
    {Id = 168036352, Door = "458"},
    {Id = 104860167, Path = "478"},
    {Id = 104862215, Path = "472"},
    {Id = 104859143, Path = "543"},
    {Id = 104860169, Path = "379"},
    {Id = 104858121, Path = "507"},
    {Id = 168034304, Door = "390"},
    {Id = 104862217, Path = "369"},
    {Id = 104861193, Path = "454"},
    {Id = 104859145, Path = "457"},
}

local path1 = {
    {map = "2883593", door = "409"},
    {map = "-31,-54", path ="havenbag"}, -- map haut de l'atelier consommable
    {map = "192416776", path ="havenbag"},
    {map = "212600322", path ="havenbag"},
    {map = "97260035", path = "havenbag"},
    {map = "171966475", path = "havenbag"},
    {map = "57016837", path = "havenbag"},
    {map = "97257989", path = "havenbag"},
    {map = "162791424", path = "zaap(88213271)"},
    {map = "-2,0", path = "right"},
    {map = "-1,0", path = "top"},
    {map = "-1,-1", path = "right"},
    {map = "0,-1", path = "top"},
    {map = "0,-2", path = "top"},
    {map = "88212250", door = "248"},
    {map = "97255955", path = "512", gather = true},
    {map = "97256979", path = "248", gather = true},
    {map = "97258003", path = "228", gather = true},
    {map = "97259027", path = "267", gather = true},
}

local path2 = {
    {map = "97261075", path = "498", gather = true}, 
    {map = "97259027", path = "194", gather = true}
}

local path3 = {
    {map = "97260051", path = "423", gather = true},
    {map = "97259027", path = "havenbag"},
    {map = "205259779", path = "havenbag"},
    { map = "209456132", path = "havenbag", gather = true, fight = false },     
    {map = "162791424", path = "zaap(88082704)"},
    {map = "5,7", path = "left"},
    {map = "4,7", path = "left"},
    {map = "3,7", path = "left"},
    {map = "2,7", path = "left"},
    {map = "1,7", path = "left"},
    {map = "0,7", path = "top"},
    {map = "0,6", path = "top"},
    {map = "0,5", path = "top"},
    {map = "0,4", path = "left"},
    {map = "-1,4", path = "left"},
    {map = "88213267", door = "236"},
    {map = "97255949", path = "376", gather = true},
    {map = "97256973", path = "122", gather = true},
    {map = "97257997", path = "235", gather = true},
}

local path3Bis = {
    {map = "212600322", path ="havenbag"},
    {map = "192416776", path ="havenbag"},
    {map = "147254", path ="havenbag"},
    {map = "146742", path = "havenbag"},
    {map = "97259027", path = "havenbag"},
    {map = "97260051", path = "423", gather = true},
    {map = "133433344", gather = true, door = "515"},
    {map = "133433346", gather = true, door = "338"},
    {map = "133432322", gather = true, door = "116"},
    {map = "133432320", gather = true, door = "134"},
    {map = "133432578", gather = true, path = "havenbag"},
    {map = "0,0", path = "zaap(207619076)"},
	{map = "207619076", path ="436"},
	{map = "206307842",path = "bottom" },
   { map = "20,-28", path = "bottom", gather = true, fight = false },  
   { map = "20,-27", path = "right", gather = true, fight = false },  
   { map = "21,-27", path = "right", gather = true, fight = false },  
   { map = "22,-27", path = "right", gather = true, fight = false },  
   { map = "23,-27", path = "right", gather = true, fight = false },  
   { map = "24,-27", path = "right", gather = true, fight = false },  
   { map = "25,-27", path = "right", gather = true, fight = false },  
   { map = "26,-27", path = "right", gather = true, fight = false },  
   { map = "27,-27", path = "bottom", gather = true, fight = false },  
   { map = "27,-28", path = "bottom", gather = true, fight = false },  
   { map = "27,-26", path = "left", gather = true, fight = false },  
   { map = "26,-26", path = "left", gather = true, fight = false },  
   { map = "25,-26", path = "left", gather = true, fight = false },  
   { map = "24,-26", path = "left", gather = true, fight = false },  
   { map = "23,-26", path = "left", gather = true, fight = false },  
   { map = "22,-26", path = "bottom", gather = true, fight = false },  
   { map = "22,-25", path = "right", gather = true, fight = false },  
   { map = "23,-25", path = "bottom", gather = true, fight = false },  
   { map = "23,-24", path = "right", gather = true, fight = false },  
   { map = "24,-25", path = "right", gather = true, fight = false },  
   { map = "25,-25", path = "right", gather = true, fight = false },  
   { map = "24,-24", path = "top", gather = true, fight = false },  
   { map = "26,-25", path = "bottom", gather = true, fight = false },  
   { map = "26,-24", path = "left", gather = true, fight = false },  
   { map = "25,-24", path = "bottom", gather = true, fight = false },  

   { map = "25,-23", path = "left", gather = true, fight = false },  
   { map = "24,-23", path = "bottom", gather = true, fight = false },  
   { map = "24,-22", path = "right", gather = true, fight = false },  
   { map = "205260292", door = "303", gather = true, fight = false },  -- -25, -22
   { map = "207619084", door = "220", gather = true, fight = false },  
   { map = "207620108", door = "130", gather = true, fight = false },  
   { map = "209456132", path = "havenbag", gather = true, fight = false },     
}

local path4 = {
    {map = "97259021", path = "323", gather = true},
    {map = "97257997", path = "451", gather = true},
    {map = "97256973", path = "537", gather = true},
    {map = "97260045", path = "254", gather = true}
}

local path5 = {
    {map = "97261069", path = "348", gather = true},
    {map = "97260045", path = "291", gather = true},
    {map = "97256973", path = "157", gather = true},
    {map = "97255949", path = "422", gather = true},
    { map = "209456132", path = "havenbag", gather = true, fight = false },     
    {map = "162791424", path = "zaap(88082704)"},
    {map = "5,7", path = "bottom"},
    {map = "5,8", path = "bottom"},
    {map = "5,9", path = "left"},
    {map = "4,9", path = "left"},
    {map = "3,9", path = "left"},
    {map = "2,9", path = "left"},
    {map = "1,9", path = "left"},
    {map = "0,8", path = "bottom(539)"},
    {map = "0,7", path = "bottom"},
    {map = "88213267", path = "bottom"},
    {map = "-2,5", path = "bottom"},
    {map = "-2,6", path = "bottom"},
    {map = "-2,7", path = "right"},
    {map = "-1,7", path = "right"},
    {map = "0,9", path = "left"},
    {map = "-1,9", path = "left"},
    {map = "-2,9", path = "left"},
    {map = "88213774", door = "353"},
    {map = "97259013", path = "276", gather = true},
    {map = "97256967", path = "194", gather = true},
    {map = "97260039", path = "262", gather = true},
    {map = "97257993", path = "122", gather = true},
    {map = "97261065", path = "236", gather = true},
    {map = "97259019", path = "276", gather = true},
}

local path6 = {
    {map = "97260043", path = "451", gather = true},
    {map = "97259019", path = "438", gather = true},
    {map = "97261065", path = "213", gather = true},
    {map = "97255947", path = "199", gather = true},
    {map = "97256971", path = "234", gather = true},
}

local path7 = {
    {map = "97261067", path = "521", gather = true}, 
    {map = "97256971", path = "239", gather = true}
}

local path8 = {
    {map = "97257995", path = "374", gather = true},
    {map = "97256971", path = "503", gather = true},
    {map = "97255947", path = "500", gather = true},
    {map = "97261065", path = "479", gather = true},
    {map = "97257993", path = "537", gather = true},
    {map = "97260039", path = "241", gather = true},
    {map = "97261063", path = "331", gather = true},
}

local path9 = {
    {map = "97259017", path = "436", gather = true},
    {map = "97261063", path = "296", gather = true},
    {map = "97255945", path = "332", gather = true},
}

local path10 = {
    {map = "97260041", path = "354", gather = true}, 
    {map = "97255945", path = "213", gather = true}
}

local path11 = {
    {map = "97256969", path = "401", gather = true},
    {map = "97255945", path = "416", gather = true},
    {map = "97261063", path = "459", gather = true},
    {map = "97260039", path = "451", gather = true},
    {map = "97256967", path = "518", gather = true},
    {map = "97259013", path = "258", gather = true},
    {map = "97260037", path = "303", gather = true},
}

local path12 = {
    {map = "97257991", path = "464", gather = true},
    {map = "97260037", path = "352", gather = true},
    {map = "97261061", path = "290", gather = true},
}

local path13 = {
    {map = "97259015", path = "451", gather = true}, 
    {map = "97261061", path = "284", gather = true}
}

local path14 = {
    {map = "97255943", path = "403", gather = true},
    {map = "97261061", path = "458", gather = true},
    {map = "97260037", path = "430", gather = true},
    {map = "97259013", path = "494", gather = true},
}

local path15 = {
    {map = "97257989", path = "havenbag"},
    {map = "162791424", path = "zaap(88082704)"},
    {map = "5,7", path = "bottom"},
    {map = "5,8", path = "bottom"},
    {map = "5,9", path = "bottom"},
    {map = "5,10", path = "bottom"},
    {map = "5,11", path = "bottom"},
    {map = "5,12", path = "bottom"},
    {map = "5,13", path = "bottom"},
    {map = "5,14", path = "bottom"},
    {map = "5,15", path = "bottom"},
    {map = "5,16", path = "bottom"},
    {map = "5,17", path = "bottom"},
    {map = "5,18", path = "bottom"},
    {map = "88082692", door = "332"},
    {map = "97260033", path = "183", gather = true},
}

local path16 = {
    {map = "97261059", path = "417", gather = true},
    {map = "97260033", path = "405", gather = true},
    {map = "97261057", path = "421", gather = true},
}

local path17 = {
    {map = "97259011", path = "276", gather = true},
    {map = "97261057", path = "235", gather = true},
    {map = "97255939", path = "446"},
    {map = "97256963", path = "492", gather = true},
    {map = "97257987", path = "492", gather = true},
}

local path18 = {
    {map = "97260035", path = "havenbag"},
    {map = "97260033", path = "452", gather = true},
    {map = "88082692", path = "right"},
    {map = "162791424", path = "zaap(88082704)"},
    {map = "5,7", path = "bottom"},
    {map = "5,8", path = "bottom"},
    {map = "5,9", path = "bottom"},
    {map = "5,10", path = "bottom"},
    {map = "5,11", path = "bottom"},
    {map = "5,12", path = "bottom"},
    {map = "5,13", path = "bottom"},
    {map = "5,14", path = "bottom"},
    {map = "5,15", path = "bottom"},
    {map = "5,16", path = "bottom"},
    {map = "5,17", path = "bottom"},
    {map = "5,18", path = "bottom"},
    {map = "6,19", path = "right"},
    {map = "7,19", path = "right"},
    {map = "8,19", path = "bottom"},
    {map = "8,20", path = "right"},
    {map = "9,20", path = "right"},
    {map = "10,20", path = "right"},
    {map = "11,20", path = "right"},
    {map = "12,20", path = "right"},
    {map = "13,20", path = "right"},
    {map = "14,20", path = "top"},
    {map = "14,19", path = "top"},
    {map = "14,18", path = "top"},
    {map = "14,17", path = "top"},
    {map = "14,16", path = "top"},
    {map = "14,15", path = "top"},
    {map = "88087305", door = "403"},
    {map = "117440512", door = "222", gather = true},
    {map = "117441536", door = "167", gather = true},
    {map = "117442560", door = "488", gather = true},
    {map = "117443584", door = "221", gather = true},
    {map = "117440514", door = "293", gather = true},
    {map = "117441538", door = "251", gather = true},
}

local path19 = {
    {map = "117442562", path = "havenbag"},
    {map = "162791424", path = "zaap(171967506)"},
    {map = "-25,12", path = "bottom"},
    {map = "-25,13", path = "bottom"},
    {map = "-25,14", path = "right"},
    {map = "-24,14", path = "right"},
    {map = "-23,14", path = "bottom"},
    {map = "-23,15", path = "bottom"},
    {map = "-23,16", path = "bottom"},
    {map = "-23,17", path = "right"},
    {map = "-22,17", path = "bottom"},
    {map = "-22,18", path = "bottom"},
    {map = "-22,19", path = "bottom"},
    {map = "-22,20", path = "bottom"},
    {map = "-22,21", path = "left"},
    {map = "173018629", door = "82"},
    {map = "178784260", door = "421"},
    {map = "178783236", door = "555", gather = true},
    {map = "178783232", door = "204", gather = true},
}

local path20 = {
    {map = "178784256", door = "505", gather = true},
    {map = "178783232", door = "403", gather = true},
    {map = "178783234", door = "281", gather = true},
    {map = "178782210", door = "185", gather = true},
    {map = "178782208", door = "421", gather = true},
}

local path22 = {
    {map = "173017606", path = "havenbag"},
    {map = "162791424", path = "zaap(171967506)"},
    {map = "-25,12", path = "top"},
    {map = "-25,11", path = "top"},
    {map = "-25,10", path = "top"},
    {map = "-25,9", path = "top"},
    {map = "-25,8", path = "top"},
    {map = "-25,7", path = "left"},
    {map = "-26,7", path = "top"},
    {map = "-26,6", path = "top"},
    {map = "171966987", door = "397"},
    {map = "178785286", door = "99", gather = true},
}

local path23 = {
    {map = "178785288", door = "558", gather = true},
    {map = "178785286", door = "559", gather = true},
    {map = "171966987", path = "left", gather = true},
}

local TableWhichArea = {
    {Path = path1, MapIdSwitch = 97261075, LvlMin = nil, Farmer = true},
    {Path = path2, MapIdSwitch = 97260051, LvlMin = nil, Farmer = false},
    {Path = path3Bis, MapIdSwitch = 209456132, LvlMin = 100, Farmer = false}, 
    {Path = path3, MapIdSwitch = 97259021, LvlMin = nil, Farmer = false},
    {Path = path4, MapIdSwitch = 97261069, LvlMin = nil, Farmer = false},
    {Path = path5, MapIdSwitch = 97260043, LvlMin = nil, Farmer = false},
    {Path = path6, MapIdSwitch = 97261067, LvlMin = nil, Farmer = false},
    {Path = path7, MapIdSwitch = 97257995, LvlMin = nil, Farmer = false},
    {Path = path8, MapIdSwitch = 97259017, LvlMin = nil, Farmer = false},
    {Path = path9, MapIdSwitch = 97260041, LvlMin = nil, Farmer = false},
    {Path = path10, MapIdSwitch = 97256969, LvlMin = nil, Farmer = false},
    {Path = path11, MapIdSwitch = 97257991, LvlMin = nil, Farmer = false},
    {Path = path12, MapIdSwitch = 97259015, LvlMin = nil, Farmer = false},
    {Path = path13, MapIdSwitch = 97255943, LvlMin = nil, Farmer = false},
    {Path = path14, MapIdSwitch = 97257989, LvlMin = nil, Farmer = false},
    {Path = path15, MapIdSwitch = 97261059, LvlMin = 40, Farmer = false},
    {Path = path16, MapIdSwitch = 97259011, LvlMin = 40, Farmer = false},
    {Path = path17, MapIdSwitch = 97260035, LvlMin = 40, Farmer = false},
    {Path = path18, MapIdSwitch = 117442562, LvlMin = 60, Farmer = false},
    {Path = path19, MapIdSwitch = 178784256, LvlMin = 60, Farmer = false},
    {Path = path20, MapIdSwitch = 173017606, LvlMin = 60, Farmer = false},
    {Path = path22, MapIdSwitch = 178785288, LvlMin = 60, Farmer = false},
    {Path = path23, MapIdSwitch = 171966475, LvlMin = 60, Farmer = false},
}

local Aliage = {
    {Name = "Ardonite", Id = 12728, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 27621, Nb = 5}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 7033, Nb = 5}, {Id = 11110, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Pyrute", Id = 7035, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 27621, Nb = 5}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 7033, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Rutile", Id = 7036, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kobalite", Id = 6458, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kriptonite", Id = 6457, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kouartz", Id = 750, MaxHdv10 = 5, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {{Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Bakélélite", Id = 749, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 441, Nb = 10}, {Id = 442, Nb = 10}, {Id = 443, Nb = 10}, {Id = 445, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Magnésite", Id = 748, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}, {Id = 442, Nb = 10}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Ebonite", Id = 746, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}, {Id = 442, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Alumite", Id = 747, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}}, lvlMax = 40, CanSell = true},
}

          
local Minerai = {
    {Name = "Obsidienne", Id = 11110, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Dolomite", Id = 7033, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Or", Id = 313, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Bauxite", Id = 446, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Argent", Id = 350, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Silicate", Id = 7032, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Etain", Id = 444, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Manganèse", Id = 445, MaxHdv100= 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 140},
    {Name = "Kobalte", Id = 443, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Bronze", Id = 442, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Cuivre", Id = 441, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 100},
    {Name = "Fer", Id = 312, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 80},
}

for _, element in ipairs(TABLE_VENTE_PL) do
	element.MaxHdv100 = 1
	element.MaxHdv10 = 1
end


scriptPath = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Mineur_ultime.lua"
local phrase = nil

for i = 1, NB_MINEUR do
    if global:thisAccountController():getAlias():find("Mineur" .. i) then
        phrase = "Mineur" .. i .. " " .. character:server()
        break
    end
end

local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end


local function CheckEndFight(message)
    if not message.results[1].alive then
        global:printSuccess("On vient de perdre un combat, on recommence le trajet")
        for _, element in ipairs(TableWhichArea) do
            element.Farmer = false
        end
        TableWhichArea[1].Farmer = true
        DebutDuScript = false    
    end
end

function messagesRegistering()
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
end


local function antiModo()
    -- if global:isModeratorPresent(30) and job:level(24) > 5 then
	-- 	timerdisconnect = math.random(30000, 36000) 
    --     if not map:onMap("0,0") then
    --         map:changeMap("havenbag")
    --     end
    --     global:printError("Modérateur présent. On attend " .. timerdisconnect)
    --     if global:thisAccountController():getAlias():find("Mineur2") then
    --         global:editAlias("Mineur2 " .. character:server() .. " [" .. job:level(24) .. "]  [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Mineur3") then
    --         global:editAlias("Mineur3 " .. character:server() .. " [" .. job:level(24) .. "]  [MODO]", true)
    --     elseif global:thisAccountController():getAlias():find("Mineur4") then
    --         global:editAlias("Mineur4 " .. character:server() .. " [" .. job:level(24) .. "]  [MODO]", true)
    --     else
    --         global:editAlias("Mineur " .. character:server() .. " [" .. job:level(24) .. "]  [MODO]", true)
    --     end        
    --     global:delay(timerdisconnect)
    --     customReconnect(timerdisconnect / 1000)
    --     map:changeMap("havenbag")
	-- end
end

local function ProcessBank()
    NeedToReturnBank = false
	npc:npcBank(-1)
	global:delay(500)
	if exchange:storageKamas() > 0 then
		exchange:putAllItems()
		global:delay(500)
		exchange:getKamas(0)
		global:delay(500)
		global:printSuccess("j'ai récupérer les kamas, je vais vendre")
	elseif exchange:storageKamas() == 0 then
		exchange:putAllItems()
		global:delay(500)
		global:printError("il n'y a pas de kamas dans la banque")
	end	
        -- on prends les poissons en banque
    if not DDNourrie and mount:hasMount() then
        local tablePoisson = {
            {Name = "Poisson Pané", Id = 1750},
            {Name = "Crabe Sourimi", Id = 1757},
            {Name = "Goujon", Id = 1782},
            {Name = "Brochet", Id = 1847},
            {Name = "Sardine Brillante", Id = 1805},
            {Name = "Cuisse de Boufton", Id = 1911},
            {Name = "Cuisse de Bouftou **", Id = 1912},
            {Name = "Poisson-Chaton", Id = 603},
            {Name = "Bar Rikain", Id = 1779},
        }
        for _, element in ipairs(tablePoisson) do
            if exchange:storageItemQuantity(element.Id) > 0 then
                exchange:getItem(element.Id, math.min(exchange:storageItemQuantity(element.Id), 200))
                break
            end
        end
    end
    
    for _, element in ipairs(Minerai) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end

	local podsAvailable = inventory:podsMax() - inventory:pods()

		
    if exchange:storageItemQuantity(Minerai[9].Id) < 20 and job:level(24)>=100 then achat = true end

    for index, element in ipairs(Aliage) do
        if index ~= 5 and index ~= 6 then
            element.CanCraft = true
            local totalWeight = 0
            for _, element2 in ipairs(element.ListIdCraft) do
                totalWeight = totalWeight + inventory:itemWeight(element2.Id) * element2.Nb
                if not (exchange:storageItemQuantity(element2.Id) >= 50) or NeedToCraft then
                    element.CanCraft = false
                    break
                end
            end
            if element.CanCraft and not NeedToCraft and job:level(24) < element.lvlMax then
                NeedToSell = false
                NeedToCraft = true
                CraftQuantity = math.floor(podsAvailable / totalWeight)
                for _, element2 in ipairs(element.ListIdCraft) do 
                    CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(element2.Id) / element2.Nb))
                end
    
                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")
    
                for _, element2 in ipairs(element.ListIdCraft) do
                    exchange:getItem(element2.Id, CraftQuantity * element2.Nb)
                end
            end
        end
    end
    if not NeedToCraft and not NeedToSell then
        for _, element in ipairs(Aliage) do
			local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id), 33)
            if QuantiteAPrendre >= 10 and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
				podsAvailable = inventory:podsMax() - inventory:pods()
			    NeedToSell = true
            end
        end
        local cpt = 0
        for _, element in ipairs(TABLE_VENTE_PL) do
            local podsAvailable = inventory:podsMax() - inventory:pods()
            local TotalMax = element.MaxHdv100 * 100 + element.MaxHdv10 * 10
            local QuantiteAPrendre = math.min(exchange:storageItemQuantity(element.Id), TotalMax, math.floor(podsAvailable / inventory:itemWeight(element.Id)))
            if ((element.MaxHdv100 > 0 and QuantiteAPrendre >= 100) or (element.MaxHdv100 == 0 and QuantiteAPrendre >= 10)) and element.CanSell then
                exchange:getItem(element.Id, QuantiteAPrendre)
                cpt = cpt + 1
            end
        end
		if not NeedToSell then
        	NeedToSell = (cpt > 5) or (inventory:podsP() > 30)
		end    
    end

	NeedToReturnBank = false	
   	global:leaveDialog()
	global:delay(500)
    map:door(518)
end

local function ProcessCraft()
    NeedToCraft = false
	NeedToSell = true
    map:useById(521478, -1)
	global:delay(1000)
	
    for _, element in ipairs(Aliage) do
        if element.CanCraft then
            for _, element2 in ipairs(element.ListIdCraft) do
                craft:putItem(element2.Id, element2.Nb)
            end
            craft:changeQuantityToCraft(CraftQuantity)
            element.CanCraft = false
            global:delay(1000)
            craft:ready()
            global:delay(1000)
        end
    end

    global:leaveDialog() 
	global:delay(1000)
    map:door(437)
end

local function ProcessSell()

    if mount:hasMount() and not DDNourrie then
        DDNourrie = true
        buyAndfeedDD()

        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end

    NeedToSell = false
	HdvSell()

	for _, element in ipairs(Aliage) do
        local itemSold = false

		local priceItem = GetPricesItem(element.Id)
        priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10
		priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price1 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
            sale:SellItem(element.Id, 10, priceItem.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

        cpt = get_quantity(element.Id).quantity["1"]
        while inventory:itemCount(element.Id) >= 1 and sale:availableSpace() > 0 and cpt < element.MaxHdv1 do 
            sale:SellItem(element.Id, 1, priceItem.Price1 - 1) 
            global:printSuccess("1 lot de " .. 1 .. " x " .. element.Name .. " à " .. priceItem.Price1 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

        if itemSold then
            randomDelay()
        end
    end

	global:leaveDialog()

    table.sort(TABLE_VENTE_PL, function(a, b) return inventory:itemCount(a.Id) > inventory:itemCount(b.Id) end)

	HdvSell()
	-- vente par 100, 10 des récoles alchimiste
	for i, element in ipairs(TABLE_VENTE_PL) do
		if inventory:itemCount(element.Id) == 0 then global:printSuccess("on a plus rien à vendre") break end

        local priceItem = GetPricesItem(element.Id)
		priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100
		priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10

        cpt = get_quantity(element.Id).quantity["100"]
    	while inventory:itemCount(element.Id) >= 100 and sale:availableSpace() > 0 and cpt < element.MaxHdv100 do 
            sale:SellItem(element.Id, 100, priceItem.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. priceItem.Price100 - 1 .. "kamas")
            cpt = cpt + 1
        end

        cpt = get_quantity(element.Id).quantity["10"]
        while inventory:itemCount(element.Id) >= 10 and sale:availableSpace() > 0 and cpt < element.MaxHdv10 do 
            sale:SellItem(element.Id, 10, priceItem.Price10 - 1) 
            global:printSuccess("1 lot de " .. 10 .. " x " .. element.Name .. " à " .. priceItem.Price10 - 1 .. "kamas")
            cpt = cpt + 1
        end

    end

	global:leaveDialog()


    if achat == true then 
        npc:npc(333, 6) 
        global:delay(500)
        sale:buyItem(443 ,100,30000)
        global:delay(500)
        achat = false
        global:leaveDialog()
    end
    HdvSell()

    -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
    for _, element in ipairs(Aliage) do
        if get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 and get_quantity(element.Id).quantity["1"] >= element.MaxHdv1 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end

    for _, element in ipairs(TABLE_VENTE_PL) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end

	if actualiser then
		global:printSuccess("on actualise")
		actualiser = false
		sale:updateAllItems()
	else
		actualiser = true
	end
		
	if sale:AvailableSpace() == 0 then
	    global:printError(" il n'y a plus de place dans l'hdv")
	elseif sale:AvailableSpace() > 0 then
	    NeedToReturnBank = true
	end

    global:leaveDialog()

	map:changeMap("top")
end

local function havresac()
    for _, element in ipairs(MAPS_SANS_HAVRESAC) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            map:door(tonumber(element.Door))
        end
    end

    DebutDuScript = false
	map:changeMap("havenbag")
end

local function whichArea()
    for i = 1, #TableWhichArea do
        if map:onMap(TableWhichArea[i].MapIdSwitch) and TableWhichArea[i].Farmer then
            TableWhichArea[i].Farmer = false
            local NextPath = TableWhichArea[IncrementTable(i, #TableWhichArea)]
            if NextPath.LvlMin ~= nil and job:level(24) < NextPath.LvlMin then
                for index, value in ipairs(TableWhichArea) do
                    local PathToReturn = TableWhichArea[IncrementTable(index + i - 1, #TableWhichArea)]
                    if PathToReturn.LvlMin ~= nil and job:level(24) > PathToReturn.LvlMin then
                        PathToReturn.Farmer = true
                        return PathToReturn.Path
                    elseif PathToReturn.LvlMin == nil then
                        PathToReturn.Farmer = true
                        return PathToReturn.Path 
                    end
                end
            else
                NextPath.Farmer = true
                return NextPath.Path
            end
        elseif TableWhichArea[i].Farmer then
            return TableWhichArea[i].Path
        end
    end
end

if not global:remember("increm") then
	global:addInMemory("increm", 0)
end


function move()
    handleDisconnection()
    if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        global:loadAndStart(scriptPath)
    elseif getRemainingHoursSubscription() < 4 and character:server() == "Draconiros" then
        global:loadAndStart(scriptPath)
    elseif getRemainingSubscription(true) < 0 then
        global:loadAndStart(scriptPath)
    end
    mapDelay()
    if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
    end

    for i = 1, NB_MINEUR do
        if global:thisAccountController():getAlias():find("Mineur" .. i) then
            global:editAlias("Mineur" .. i .. " " .. character:server() .. " [" .. job:level(24) .. "]" .. " " .. getRemainingSubscription(true), true)
            break
        end
    end

    while character:kamas() == 0 and map:onMap("4,-18") do
        npc:npcBank(-1)
        global:delay(500)
        if exchange:storageKamas() > 0 then
            exchange:getKamas(0)
            global:delay(500)
            global:printSuccess("j'ai récupérer les kamas, je retourne farmer")
            global:leaveDialog()
        elseif exchange:storageKamas() == 0 then
            global:printError("il n'y a pas de kamas dans la banque on attend un peu")
            global:leaveDialog()
            global:delay(1200000)
        end
    end
	if job:level(24) >= 120 then
		global:printSuccess("on change de script")
		global:loadAndStart(scriptPath)
	end


	--[[if job:level(24) < 50 and global:getCountGather() > 0 and (global:getCountGather() + global:remember("increm")) % (global:remember("increm") == 0 and 50 or 400) == 0 then
		global:editInMemory("increm", global:remember("increm") + 1)
        customReconnect(math.random(80, 120))
	end]]



    if NeedToCraft then
        return {
            {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "right"},
			{map = "-30,-56", path = "right"},
			{map = "-29,-56", path = "bottom"},
			{map = "-29,-55", path = "right"},
            {map = "212602886", door = "345"}, -- Map extérieure Atelier mineur bonta
            {map = "217060356", custom = ProcessCraft}, -- Map intérieur Atelier mineur bonta
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

    if NeedToSell then
        return {
			{map = "212602886", path = "left"}, -- map extérieur atelier mineur
			{map = "-29,-55", path = "left"},
			{map = "-30,-55", path = "left"},
            {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end	
    
    forwardKamasBotBankIfNeeded(750000, 250000, 120, 4)

    if DebutDuScript then havresac() end

    antiModo()
    return whichArea()
end


function bank()
    mapDelay()

    for i = 1, NB_MINEUR do
        if global:thisAccountController():getAlias():find("Mineur" .. i) then
            global:editAlias("Mineur" .. i .. " " .. character:server() .. " [" .. job:level(24) .. "]" .. " " .. getRemainingSubscription(true), true)
            break
        end
    end
    
    for _, element in ipairs(TableWhichArea) do
		element.Farmer = false
	end
	TableWhichArea[1].Farmer = true
    DebutDuScript = false
	
    if job:level(24) >= 120 then
		global:printSuccess("on change de script")
		global:loadAndStart(scriptPath)
	end

    if NeedToCraft then
        return {
            {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "right"},
			{map = "-30,-56", path = "right"},
			{map = "-29,-56", path = "bottom"},
			{map = "-29,-55", path = "right"},
            {map = "212602886", door = "345"}, -- Map extérieure Atelier mineur bonta
            {map = "217060356", custom = ProcessCraft}, -- Map intérieur Atelier mineur bonta
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

    if NeedToSell then
        return {
			{map = "212602886", path = "left"}, -- map extérieur atelier mineur
			{map = "-29,-55", path = "left"},
			{map = "-30,-55", path = "left"},
            {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end
				
    for _, element in ipairs(MAPS_SANS_HAVRESAC) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            map:door(tonumber(element.Door))
        end
    end
		
	if map:currentMapId()~=217059328 and map:currentMap()~= "-31,-57" and map:currentMap()~= "-31,-56" and map:currentMap()~=104861191 and map:currentMap()~=104862215 and map:currentMap()~=104859143  and map:currentMap()~=104859145 and map:currentMap()~=104860169 and map:currentMap()~=104861193   and map:currentMap()~=104862217 and map:currentMap()~=2885641 and map:currentMap()~=145209 and map:currentMap()~=2884113 and map:currentMapId()~=2885641 and map:currentMapId()~=147768 and map:currentMapId()~=162791424 and map:currentMapId()~=191104004 and map:currentMapId()~=7340551 and map:currentMapId()~="-32,-56" and map:currentMap()~="-4,2" and map:currentMapId()~=191104004  then 
		return{
			{map=tostring(map:currentMap()),path="havenbag"}}
		end
	
    return {
			{map ="104072452", custom = easy },
			{map ="104072451", path ="havenbag"},
			{map="0,0",path="zaap(212600323)"},
			{map="-31,-56",path="top"},
			{map="212600322", door = "468"},
			{map = "217059328", custom = ProcessBank},
    }
end

function PHENIX()
    return PHENIX
end


function banned()
    global:editAlias(phrase .. " [BAN]", true)
end
