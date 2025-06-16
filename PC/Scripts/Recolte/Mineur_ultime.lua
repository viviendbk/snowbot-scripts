---@diagnostic disable: undefined-global, lowercase-global
dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")
Buyer = dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\auto_stuff\\classes\\buyer.lua")


dofile("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\IA\\IA_SacriFeuRecolte.lua")


MIN_MONSTERS = 1

MAX_MONSTERS = 2
AUTO_DELETE = { }
GATHER = {25, 24, 37, 52, 54, 26, 113, 135, 53, 55, 114, 17}

--PLANNING = {3, 8, 13, 18, 23}


OPEN_BAGS = true 
GATHER_NEXT_DELAY_MIN = 0
GATHER_NEXT_DELAY_MAX = 50
GATHER_NEW_DELAY_MIN = 500
GATHER_NEW_DELAY_MAX = 2000

local DebutDuScript = true

local NeedToCraft = false
local NeedToReturnBank = false
local NeedToSell = false
local hdvFull = false

local hdvActualise = false
local cptActualiser = 0
local compteurZone = 0
local MaxCompteurZone = 20

local achatArgent = false
local achatEtain = false
local achatBronze = false

local maxEnergy = 6200
local gid = 1782 

local CompteurChangement = 0

local CraftQuantity = 0

local hdv_door_id = 218

local function RegenEnergie()
    npc:npc(385,6)
    global:delay(1500)
    local tableAchatEnergie = {
        {name = "Pain des champs", id = 1737},
        {name = "Potion axel raide", id = 16722},
        {name = "Potion Raide izdaide", id = 16414},
        {name = "Estouffade de Morue", id = 16481},
        {name = "Filet Mignon", id = 17199},
        {name = "Aileron de Requin", id = 1838},
        {name = "Daube aux Epices", id = 17195},
        {name = "Mantou", id = 527},
        {name = "Andouillette de Gibier", id = 17203},
        {name = "Espadon Poellé", id = 16485},
        {name = "Espadon Poellé", id = 16485},
        {name = "Aile de Raie", id = 1814},
    }
    
    for _, element in ipairs(tableAchatEnergie) do
        npc:npc(385,6)
        global:delay(1500)
        if inventory:itemCount(element.id) <= 20 and character:maxEnergyPoints()-character:energyPoints() > 500 then
            sale:buyItem(element.id, 10, 20000)
        end
        global:leaveDialog()
        while inventory:itemCount(element.id) > 0 and character:maxEnergyPoints()-character:energyPoints() ~=0 do
            inventory:useItem(element.id)
        end
    end
    
    map:changeMap("top")
end

local AreaEnergie = {
    {map = "0,0", path = "zaap(212600323)"},
	{map= "-31,-56", path="bottom"},
	{map= "-31,-55", path="bottom"},
	{map= "-31,-54", path="bottom"},
	{map = "-31,-53", custom = RegenEnergie}, 
}

local Koalak1 = {
		{map = "205259779", gather = true, path = "havenbag"},
		{map ="0,0", path ="zaap(73400320)"},
		{map = "-16,0", path = "top"},
		{map = "-16,1", path = "top"},
		{map = "-16,-1", path = "top"},
		{map = "-16,-2", path = "top"},
		{map = "-16,-3", path = "right"},
		{map = "-15,-3", path = "top(16)"},
		{map = "-15,-4", path = "top"},
		{map = "-15,-5", path = "top"},
		{map = "-15,-6", path = "top"},
		{map = "-14,-7", path = "top"},
		{map = "-14,-8", path = "top"},
		{map = "-15,-7", path = "right"},
		{map ="147849222", path = "414"},
}

local Koalak2 = {
	{map ="130810369", gather = true, door = "332"},
    {map ="147849222", path = "right"},
    {map = "-8,-9", path = "top"},
    {map = "-8,-10", path = "top"},
    {map = "-8,-11", path = "top"},
    {map = "-8,-12", path = "top"},
    {map = "-9,-9", path = "right"},
    {map = "-10,-9", path = "right"},
    {map = "-11,-9", path = "right"},
    {map = "-12,-9", path = "right"},
    {map = "-13,-9", path = "right"},
    {map ="147852290", door = "304"},
}

local Koalak3 = {
    {map ="149949440", gather = true, door = "468"},
}

local BordBwork1 = {
	{map = "173539332", path = "havenbag"},
    {map = "8912911", path = "havenbag"},
    {map = "144931", path = "havenbag"},
    {map = "0,0", path = "zaap(88212746)"},
    {map = "-1,13", path = "top"},
    {map = "-1,12", path = "top"},
    {map = "-1,11", path = "top"},
    {map = "-1,10", path = "top"},
    {map = "-1,9", path = "left"},
    {map = "-2,9", path = "left"},
    {map = "88213774", door = "353"},
    {map = "97259013", gather = true, path = "276"},
    {map = "97256967", gather = true, path = "194"},
    {map = "97260039", gather = true, path = "262"},
    {map = "97257993", gather = true, path = "122"},
    {map = "97261065", gather = true, path = "213"},
    {map = "97255947", gather = true, path = "199"},
    {map = "97256971", gather = true, path = "234"}
}

local BordBwork2 = {
    {map = "97261067", gather = true, path = "521"},
    {map = "97256971", gather = true, path = "503"},
    {map = "97255947", gather = true, path = "500"},
    {map = "97261065", gather = true, path = "479"},
    {map = "97257993", gather = true, path = "537"},
    {map = "97260039", gather = true, path = "241"},
    {map = "97261063", gather = true, path = "331"}
}

local BordBwork3 = {
    {map = "97259017", gather = true, path = "436"},
    {map = "97261063", gather = true, path = "296"},
    {map = "97255945", gather = true, path = "332"}
}

local BordBwork4 = {
    {map = "97260041", gather = true, path = "354"}, 
    {map = "97255945", gather = true, path = "213"}
}

local BordBwork5 = {
    {map = "97256969", gather = true, path = "401"},
    {map = "97255945", gather = true, path = "416"},
    {map = "97261063", gather = true, path = "459"},
    {map = "97260039", gather = true, path = "451"},
    {map = "97256967", gather = true, path = "518"},
    {map = "97259013", gather = true, path = "258"},
    {map = "97260037", gather = true, path = "352"}
}

local BordBwork6 = {
    {map = "97261061", gather = true, path = "458"},
    {map = "97260037", gather = true, path = "430"},
    {map = "97259013", gather = true, path = "403"},
}

local Bwork1 = {
    {map = "88213774", path = "right"},
    {map = "57016837", gather = true, path = "havenbag"},
    {map = "0,0", path = "zaap(88212746)"},
    {map = "-1,13", path = "top"},
    {map = "-1,12", path = "top"},
    {map = "-1,11", path = "top"},
    {map = "-1,10", path = "top"},
    {map = "-2,9", path = "right"},
    {map = "-1,9", path = "top(20)"},
    {map = "-1,8", door = "369"},
    {map = "-2,8", path = "left"},
    {map = "-3,8", path = "left"},
    {map = "-4,8", path = "top"},
    {map = "-4,7", path = "left(308)"},
    {map = "-5,7", path = "left"},
    {map = "104071169", path = "left"},
    {map = "104202753", door = "100"},
    {map = "104859143", gather = true, path = "160"},
    {map = "104860167", gather = true, path = "205"},
    {map = "104861191", gather = true, path = "457"}
}

local Bwork2 = {
    {map = "104861191", gather = true, path = "457"},
    {map = "104860167", gather = true, path = "478"},
    {map = "104859143", gather = true, path = "171"}
}

local Bwork3 = {
    {map = "104862215", gather = true, path = "472"},
    {map = "104859143", gather = true, path = "543"},
    {map = "104202753", path = "right"},
    {map = "104071169", path = "top(8)"},
    {map = "104071168", door = "213"},
    {map = "104860165", gather = true, path = "408"},
    {map = "104858119", path = "255"}
}

local Bwork4 = {
    {map = "104862213", gather = true, path = "376"},	
    {map = "104858119", gather = true, path = "207"},
    {map = "104860165", gather = true, path = "444"},
    {map = "104071168", path = "top"},
    {map = "104071425", door = "199"}
}

local Bwork5 = {
    {map = "104859139", gather = true, path = "444"},
    {map = "104071425", path = "right"},
    {map = "-5,5", path = "right"},
    {map = "-4,5", path = "top(20)"},
    {map = "-4,4", path = "top"},
    {map = "-4,3", path ="top"},
    {map = "104072452", door = "248"},
    {map = "104858121", gather = true, path = "348"},
    {map = "104860169", gather = true, path = "263"},
    {map = "104861193", gather = true, path = "248"}
}

local Bwork6 = {
    {map = "104862217", gather = true, path = "369"}, 
    {map = "104861193", gather = true, path = "254"}
}

local Bwork7 = {
    {map = "104859145", gather = true, path = "457"},
    {map = "104858121", gather = true, path = "507"},
}

local Craqueleur1 = {
    {map = "0,0", path = "zaap(88213271)"},
    {map = "-2,0", path = "right"},
    {map = "104072452", path = "bottom"},
    {map = "104072451", path = "bottom"},
    {map = "104072450", path = "bottom"},
    {map = "104072449", path = "bottom"},
    {map = "104072192", path = "bottom"},
    {map = "104072193", path = "bottom"},
    {map = "104072194", path = "right"},
    {map = "104072706", path = "right"},
    {map = "104073218", door = "246"},
    {map = "88212751", path = "right"},
    {map = "0,8", path = "top"},
    {map = "0,7", path = "top"},
    {map = "0,6", path = "top"},
    {map = "0,5", path = "top"},
    {map = "0,4", path = "left"},
    {map = "-1,4", path = "top"},
    {map = "-1,3", path = "top"},
    {map = "-1,2", path = "top"},
    {map = "-1,1", path = "top"},
    {map = "-1,0", path = "top"},
    {map = "-1,-1", path = "top"},
    {map = "-1,-2", path = "left"},
    {map = "-2,-2", path = "top"},
    {map = "-2,-3", path = "top"},
    {map = "-2,-4", path = "top"},
    {map = "185862148", door = "367"},
    {map = "97255951", gather = true, path = "203"},
    {map = "97256975", gather = true, path = "323"},
    {map = "97257999", gather = true, path = "268"},
    {map = "97260047", gather = true, path = "379"}
}

local Craqueleur2 = {
    {map = "97261071", gather = true, path = "248"},
    {map = "97260047", gather = true, path = "432"},
    {map = "97257999", gather = true, path = "247"}
}

local Craqueleur3 = {
    {map = "97259023", gather = true, path = "451"},
    {map = "97257999", gather = true, path = "403"},
    {map = "97256975", gather = true, path = "497"},
    {map = "97255951", gather = true, path = "361"}
}

local Craqueleur4 = {
    {map = "-2,-5", path = "right"},
    {map = "-1,-5", path = "top"},
    {map = "-1,-6", path = "right"},
    {map = "0,-6", path = "top"},
    {map = "0,-7", path = "right"},
    {map = "1,-7", path = "top"},
    {map = "1,-8", path = "left"},
    {map = "185863169", door = "352"},
    {map = "4460546", gather = true, path = "275"},
}

local Rivage1 = {
    {map = "4460544", gather = true, path = "havenbag"},
	{map = "97255951", gather = true, path = "havenbag"},
    {map = "0,0", path = "zaap(88085249)"},
    {map = "10,22", path = "top"},
    {map = "10,21", path = "left"},
    {map = "9,21", path = "left"},
    {map = "8,21", path = "left"},
    {map = "7,21", path = "left"},
    {map = "6,21", path = "left"},
    {map = "5,21", path = "top"},
    {map = "5,20", path = "top"},
    {map = "88082692", door = "332"},
    {map = "97260033", gather = true, path = "405"},
    {map = "97261057", gather = true, path = "235"},
    {map = "97255939", gather = true, path = "446"},
    {map = "97256963", gather = true, path = "492"},
    {map = "97257987", gather = true, path = "492"}
}

local Rivage2 = {
    {map = "97260035", gather = true, path = "288"},
    {map = "97257987", path = "212"},
    {map = "97261057", path = "227"},
    {map = "97260033", path = "452"},
    {map = "88082692", path = "right"},
    {map = "6,19", path = "right"},
    {map = "7,19", path = "bottom"},
    {map = "7,20", path = "right"},
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
    {map = "88087305", gather = true, door = "403"},
    {map = "117440512", gather = true, door = "222"},
    {map = "117441536", gather = true, door = "167"},
    {map = "117442560", gather = true, door = "488"},
    {map = "117443584", gather = true, door = "221"},
    {map = "117440514", gather = true, door = "293"},
    {map = "117441538", gather = true, door = "251"},
}

local MineMontagne_20_20 = {
    {map = "117442562", gather = true, path = "havenbag"},
    {map = "0,0", path = "zaap(164364304)"},
    {map = "-20,-20", path = "top"},
    {map = "-20,-21", path = "top"},
    {map = "-20,-22", path = "top"},
    {map = "-20,-23", path = "top(7)"},
    {map = "-20,-24", path = "top"},
    {map = "-20,-25", path = "top"},
    {map = "-20,-26", path = "top"},
    {map = "-20,-27", path = "left"},
    {map = "-21,-27", path = "left"},
    {map = "164496393", gather = true, door = "200"},
    {map = "168036352", gather = true, door = "242"},
    {map = "168035328", gather = true, door = "188"},
    {map = "168034304", gather = true, door = "184"},
    {map = "168034306", gather = true, path = "341"},
    {map = "168034308", gather = true, door = "464"},
    {map = "168034310", gather = true, door = "493"},
    {map = "168034312", gather = true, door = "215"},
    {map = "168167424", gather = true, door = "289"}
}

local MineDopeul1 = {
	{map ="147849222", path ="havenbag"},
    {map = "164102664", path = "havenbag"},
    {map = "0,0", path = "zaap(164364304)"},
    {map = "-20,-20", path = "bottom"},
    {map = "-20,-19", path = "bottom"},
    {map = "-20,-18", path = "bottom"},
    {map = "-20,-17", path = "bottom"},
    {map = "-20,-16", path = "left"},
    {map = "-21,-16", path = "bottom"},
    {map = "-21,-15", path = "bottom"},
    {map = "-21,-14", path = "left"},
    {map = "-22,-14", path = "left"},
    {map = "-23,-14", path = "left"},
    {map = "-24,-14", path = "bottom"},
    {map = "-24,-13", path = "bottom"},
    {map = "-24,-12", path = "left"},
    {map = "-25,-12", path = "left"},
    {map = "-26,-12", path = "left"},
    {map = "-27,-12", path = "left"},
    {map = "-28,-12", path = "left"},
    {map = "-29,-12", path = "bottom"},
    {map = "-29,-11", path = "bottom"},
    {map = "100141313", door = "198"},
    {map = "123470337", gather = true, door = "352"}
}

local MineDopeul2 = {
    {map = "123470339", gather = true, door = "376"},
    {map = "123470337", gather = true, door = "163"},
    {map = "123471361", gather = true, door = "404"},
    {map = "123472385", door = "255"},
    {map = "123472387", gather = true, door = "491"}
}

local MineDopeul3 = {
    {map = "123471363", gather = true, door = "173"},
    {map = "123472387", gather = true, door = "516"},
    {map = "123472385", gather = true, door = "552"},
    {map = "123471361", gather = true, door = "535"},
    {map = "123470337", gather = true, door = "473"},
}

local mine26 = { 
    {map = "0,0", path = "zaap(171967506)"},
    {map = "-26,5", path = "right"},
    {map = "-25,5", path = "bottom"},
    {map = "-25,6", path = "bottom"},
    {map = "-25,7", path = "bottom"},
    {map = "-25,8", path = "bottom"},
    {map = "-25,9", path = "bottom"},
    {map = "-25,10", path = "bottom"},
    {map = "-25,11", path = "bottom"},
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
    {map = "-22,20", path = "left"},
    {map = "-23,20", path = "bottom"},
    {map = "173018629", gather = true, door = "82"},
    {map = "178784260", gather = true, door = "421"},
    {map = "178783236", gather = true, door = "309"},
    {map = "178782214", gather = true, door = "507"},
    {map = "178782216", gather = true, door = "422"},
    {map = "178782218", gather = true,door = "476"}
}

local mine27 = {
    {map = "178782220", gather = true, door = "57"},
    {map = "178782218", gather = true, door = "122"},
    {map = "178782216", gather = true, door = "122"},
    {map = "178782214", gather = true, door = "150"},
    {map = "178783236", gather = true, door = "555"},
    {map = "178783232", gather = true, door = "406"}
}

local mine28 = {
    {map = "178782208", gather = true, door = "138"}, 
    {map = "178783232", gather = true, door = "403"}
}

local mine28Fin = { 
    {map = "178783234", gather = true, door = "203"},
    {map = "178783232", gather = true, door = "200"},
    {map = "178783236", gather = true, door = "138"},
    {map = "178784260", gather = true, door = "279"},
}

local LacCania = {
    {map = "178783242", gather = true, path = "havenbag"},
    {map = "0,0", path = "zaap(156240386)"},
    {map = "-3,-42", path = "right"},
    {map = "-2,-42", path = "right"},
    {map = "156241410", gather = true, door = "149"},
    {map = "133431302", gather = true, door = "179"},
    {map = "133431300", gather = true, door = "165"},
    {map = "133431298", gather = true, door = "432"},
    {map = "133432322", gather = true, door = "348"},
    {map = "133433346", gather = true, door = "177"}
}

local Pandala = {
    {map = "178783242", gather = true, path = "havenbag"},
	{map = "-31,-54", path ="havenbag"}, -- map haut de l'atelier consommable
	{map = "212601349", path ="havenbag"}, -- map en haut de hdv ressources
	{map = "192416776", path ="havenbag"},
	{map = "192415750", path ="havenbag"}, -- map banque astrub
	{map = "212600322", path ="havenbag"}, -- sortie banque bonta
	{map = "146742", path = "havenbag"},
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

local Saharach = {
    {map = "171707908", path = "havenbag"},
    {map = "0,0", path = "zaap(173278210)"},
    {map = "15,-59", path = "top"},
    {map = "15,-58", path = "top"},
    {map = "15,-60", path = "right"},
    {map = "173278720", door = "133"},
    {map = "173935364", gather = true, door = "297"},
    {map = "173936388", gather = true, door = "450"},
    {map = "173937412", gather = true, door = "382"},
    {map = "173938436", gather = true, door = "367"},
    {map = "173939460", gather = true, door = "468"}
}

local Frigost1 = {
    {map = "173539332", path = "havenbag"},
    {map = "0,0", path = "zaap(54172969)"},
	{map = "-78,-41", path = "top"}, -- zone frigost
    {map = "-78,-42", path = "top"},
    {map = "-78,-43", path = "top"},
    {map = "-78,-44", path = "top"},
    {map = "-78,-45", path = "right"},
    {map = "-77,-45", path = "right"},
    {map = "-76,-45", path = "top"},
    {map = "-76,-46", path = "top"},
    {map = "-76,-47", path = "right"},
    {map = "-75,-47", path = "right"},
    {map = "-74,-47", path = "right"},
    {map = "-73,-47", path = "right"},
    {map = "-72,-47", path = "right"},
    {map = "-71,-47", path = "right"},
    {map = "-70,-47", path = "right"},
    {map = "-69,-47", path = "right"},
    {map = "-68,-47", path = "right"},
    {map = "-67,-47", path = "top"},
    {map = "-67,-48", path = "top"},
    {map = "-67,-49", path = "top"},
    {map = "-67,-50", path = "right"},
    {map = "-66,-50", path = "right"},
    {map = "-65,-50", path = "right"},
    {map = "-64,-50", path = "right"},
    {map = "-63,-50", path = "top"},
    {map = "-63,-51", path = "top"},
    {map = "-63,-52", path = "right"},
    {map = "-62,-52", path = "right"},
    {map = "-61,-52", path = "top"},
    {map = "-61,-53", path = "top"},
    {map = "-61,-54", path = "right"},
    {map = "-60,-54", path = "top"},
    {map = "-60,-55", path = "right"},
    {map = "-59,-55", path = "top"},
    {map = "-59,-56", path = "right"},
    {map = "-58,-56", path = "top"},
    {map = "-58,-57", path = "top"},
    {map = "-58,-58", path = "right"},
    {map = "-57,-58", path = "right"},
    {map = "-56,-58", path = "top"},
    {map = "-56,-59", path = "top"},
    {map = "-56,-60", path = "top"},
    {map = "-56,-61", path = "top"},
    {map = "-56,-62", path = "top"},
    {map = "-56,-63", path = "right"},
    {map = "-55,-63", path = "top"},
    {map = "54161216", door = "261"},
    {map = "57017859", path = "359", gather = true}
}

local Frigost2 = {
    {map = "57017861", path = "270", gather = true},
    {map = "57017859", path = "206", gather = true},
    {map = "57016835", path = "220", gather = true},
    {map = "56885763", path = "207", gather = true}
}

local Frigost3 = {
    {map = "56886787", path = "396", gather = true},
    {map = "56885763", path = "436", gather = true},
    {map = "57016835", path = "257", gather = true},
}

local Frigost4 = {
    {map = "57016837", gather = true, path = "401"},
    {map = "57016835", gather = true, path = "409"},
}

local Sidimote1 = {
    {map = "0,0", path = "zaap(171967506)"},
    {map = "171967506", path = "bottom"},
    {map = "-25,13", path = "bottom"},
    {map = "-21,14", path = "bottom"},
    {map = "-21,15", path = "bottom"},
    {map = "-21,16", path = "bottom"},
    {map = "-21,17", path = "bottom"},
    {map = "-21,18", path = "bottom"},
    {map = "-21,19", path = "bottom"},
    {map = "-21,20", path = "bottom"},
    {map = "-23,21", path = "right"},
    {map = "-22,21", path = "right"},
    {map = "-21,21", path = "right"},
    {map = "-20,21", path = "right"},
    {map = "-19,21", path = "right"},
    {map = "-18,21", path = "right"},
    {map = "-25,14", path = "right"},
    {map = "-24,14", path = "right"},
    {map = "-23,14", path = "right"},
    {map = "-22,14", path = "right"},
    {map = "172491782", door = "373"},
    {map = "178783240", gather = true, door = "277"},
}
local Sidimote2 = {
    {map = "178783242", gather = true, door = "534"},
}

local Sidimote3 = {
    {map = "0,0", path = "zaap(171967506)"},
    {map = "171967506", path = "top"},
    {map = "-25,11", path = "top"},
    {map = "-25,10", path = "top"},
    {map = "-25,9", path = "top"},
    {map = "-25,8", path = "top"},
    {map = "-25,7", path = "top"},
    {map = "-25,6", path = "top"},
    {map = "-25,5", path = "left"},
    {map = "171966987", door = "397"},
    {map = "178785286", gather = true, door = "99"},
}

local Sidimote4 = {
    {map = "178785288", gather = true, door = "558"},
    {map = "178785286", gather = true, door = "559"},
    {map = "171966987", path = "top"},
    {map = "-26,4", path = "top"},
    {map = "-26,3", path = "top"},
    {map = "-26,2", path = "top"},
    {map = "-26,1", path = "top"},
    {map = "-26,0", path = "top"},
    {map = "-26,-1", path = "top"},
    {map = "-26,-2", path = "top"},
    {map = "-26,-3", path = "top"},
    {map = "-26,-4", path = "top"},
    {map = "-26,-5", path = "top"},
    {map = "-26,-6", path = "top"},
    {map = "-26,-7", path = "right"},
    {map = "-25,-7", path = "right"},
    {map = "-24,-7", path = "right"},
    {map = "-23,-7", path = "right"},
    {map = "-22,-7", path = "right"},
    {map = "171707908", door = "166"},
}

local Sidimote5 = {
    {map = "178784264", gather = true, door = "532"},
}

local function TakeKamas()
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
        customReconnect(60)
    end
end

local GoTakeKamas = {
    {map="0,0",path="zaap(212600323)"},
    {map="-31,-56",path="top"},
    {map="212600322", door = "468"},
    {map = "217059328", custom = TakeKamas},
}

local Aliage = {
    {Name = "Ardonite", Id = 12728, MaxHdv10 = 7, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 27621, Nb = 5}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 7033, Nb = 5}, {Id = 11110, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Pyrute", Id = 7035, MaxHdv10 = 7, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 27621, Nb = 5}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 7033, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Rutile", Id = 7036, MaxHdv10 = 7, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {{Id = 313, Nb = 10}, {Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 446, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kobalite", Id = 6458, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 350, Nb = 10}, {Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kriptonite", Id = 6457, MaxHdv10 = 3, MaxHdv1 = 3, CanCraft = false, ListIdCraft = {{Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Kouartz", Id = 750, MaxHdv10 = 5, MaxHdv1 = 5, CanCraft = false, ListIdCraft = {{Id = 444, Nb = 5}, {Id = 445, Nb = 10}, {Id = 442, Nb = 10}, {Id = 7032, Nb = 5}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Bakélélite", Id = 749, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 441, Nb = 10}, {Id = 442, Nb = 10}, {Id = 443, Nb = 10}, {Id = 445, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Magnésite", Id = 748, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}, {Id = 442, Nb = 10}, {Id = 443, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Ebonite", Id = 746, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}, {Id = 442, Nb = 10}}, lvlMax = 201, CanSell = true},
    {Name = "Alumite", Id = 747, MaxHdv10 = 10, MaxHdv1 = 10, CanCraft = false, ListIdCraft = {{Id = 312, Nb = 10}, {Id = 441, Nb = 10}}, lvlMax = 40, CanSell = true},
}


local tableVente = {
	{Name = "Ardonite", Id = 12728, MaxHdv100 = 10, MaxHdv10 = 10, MaxHdv1 = 15},
	{Name = "Pyrute", Id = 7035, MaxHdv100 = 10, MaxHdv10 = 10, MaxHdv1 = 15},
	{Name = "Rutile", Id = 7036, MaxHdv100 = 10, MaxHdv10 = 10, MaxHdv1 = 15},
}
          
local Minerai = {
    {Name = "Obsidienne", Id = 11110, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Dolomite", Id = 7033, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Or", Id = 313, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Bauxite", Id = 446, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Argent", Id = 350, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Silicate", Id = 7032, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Etain", Id = 444, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 160},
    {Name = "Manganèse", Id = 445, MaxHdv100= 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 140},
    {Name = "Kobalte", Id = 443, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true, LvlMinToSell = 120},
    {Name = "Bronze", Id = 442, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Cuivre", Id = 441, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
    {Name = "Fer", Id = 312, MaxHdv100 = 3, MaxHdv10 = 3, CanSell = true},
}

local TableGather = {
    {Name = "fer", IdRessource = 17, IdObjet = 312, Max = 100, Farmer = true},
    {Name = "cuivre", IdRessource = 53, IdObjet = 441, Max = 300, Farmer = true},
    {Name = "bronze", IdRessource = 55, IdObjet = 442, Max = 300, Farmer = true},
    {Name = "kobalte", IdRessource = 37, IdObjet = 443, Max = 200, Farmer = true},
    {Name = "manganèse", IdRessource = 54, IdObjet = 445, Max = 150, Farmer = true},
    {Name = "etain", IdRessource = 52, IdObjet = 444, Max = 300, Farmer = true},
    {Name = "silicate", IdRessource = 114, IdObjet = 7032, Max = 150, Farmer = true},
    {Name = "argent", IdRessource = 24, IdObjet = 350, Max = 300, Farmer = true},
    {Name = "bauxite", IdRessource = 26, IdObjet = 446, Max = 200, Farmer = true},
    {Name = "or", IdRessource = 25, IdObjet = 313, Max = 313, Farmer = true},
    {Name = "dolimite", IdRessource = 113, IdObjet = 7033, Max = 150, Farmer = true},
    {Name = "obsidienne", IdRessource = 135, IdObjet = 11110, Max = 300, Farmer = true},
}

local TableArea = {
    {Zone = {
        {Pandala, "209456132", false}
    }, Gath = {114, 113}, Farmer = false, LvlMin = 120}, -- pandala
    {Zone = {
        {Saharach, "173539332", false}
    }, Gath = {24, 26, 25}, Farmer = false, LvlMin = 120}, -- saharach [Géchar]
    {Zone = {
        {Koalak1, "130810369", false}, 
        {Koalak2, "149949440", false},
        {Koalak3, "147852290", false}
    }, Gath = {52, 53, 55, 37, 54}, Farmer = false, LvlMin = 120}, -- koalak [Chill]
    {Zone = {
        {Frigost1, "57017861", false}, 
        {Frigost2, "56886787", false}, 
        {Frigost3, "57016837", false},
        {Frigost4, "57017859", false}
    }, Gath = {135, 25, 52, 26}, Farmer = false, LvlMin = 140}, -- frigost [Géchar]
    {Zone = {
        {BordBwork1, "97261067", false},
        {BordBwork2, "97259017", false},
        {BordBwork3, "97260041", false},
        {BordBwork4, "97256969", false}, 
        {BordBwork5, "97261061", false}, 
        {BordBwork6, "88213774", false}
    }, Gath = {17, 53, 55, 37, 54, 24}, Farmer = false, LvlMin = 120},
    {Zone = {
        {Bwork1, "104861191", false}, 
        {Bwork2, "104862215", false}, 
        {Bwork3, "104862213", false}, 
        {Bwork4, "104859139", false}, 
        {Bwork5, "104862217", false}, 
        {Bwork6, "104859145", false}, 
        {Bwork7, "104072452", false}
    }, Gath = {55, 54, 52, 24, 26, 25}, Farmer = false, LvlMin = 120}, -- [Géchar]
    {Zone = {
        {Craqueleur1, "97261071", false}, 
        {Craqueleur2, "97259023", false}, 
        {Craqueleur3, "185862148", false}, 
        {Craqueleur4, "4460544", false}
    }, Gath = {17, 53, 55, 37, 54, 24, 26}, Farmer = false, LvlMin = 120},
    {Zone = {
        {Rivage1, "97260035", false}, 
        {Rivage2, "117442562", false}
    }, Gath = {17, 53, 55, 37, 54, 25}, Farmer = false, LvlMin = 120}, -- mine rivage
    {Zone = {
        {mine26, "178782220", false},
        {mine27, "178782208", false},
        {mine28, "178783234", false},
        {mine28Fin, "173018629", false}
    }, Gath = {54, 37}, Farmer = false, LvlMin = 120},
    {Zone = {
        {Sidimote1, "178783242", false}, 
        {Sidimote2, "178783240", false}
    }, Gath = {24, 26}, Farmer = false, LvlMin = 120},
    {Zone = {
        {Sidimote3, "178785288", false}, 
        {Sidimote4, "178784264", false}, 
        {Sidimote5, "171707908", false}
    }, Gath = {52, 54}, Farmer = false, LvlMin = 120},
    {Zone = {
        {MineMontagne_20_20, "164102664", false},
    }, Gath = {53, 55, 24, 26}, Farmer = false, LvlMin = 120 },
    {Zone = {
        {MineDopeul1, "123470339", false},
        {MineDopeul2, "123471363", false},
        {MineDopeul3, "100141313", false}
    }, Gath = {53, 55, 37, 54}, Farmer = false, LvlMin = 120 },
    {Zone = {
        {LacCania, "133433344", false}
    }, Gath = {17, 53, 55, 37, 54}, Farmer = false, LvlMin = 120},

}

if global:thisAccountController():getAlias():find("Mineur2") or global:thisAccountController():getAlias():find("Mineur4") then
    TableArea = {
        {Zone = {
            {Craqueleur1, "97261071", false}, 
            {Craqueleur2, "97259023", false}, 
            {Craqueleur3, "185862148", false}, 
            {Craqueleur4, "4460544", false}
        }, Gath = {17, 53, 55, 37, 54, 24, 26}, Farmer = false, LvlMin = 120},
        {Zone = {
            {Rivage1, "97260035", false}, 
            {Rivage2, "117442562", false}
        }, Gath = {17, 53, 55, 37, 54, 25}, Farmer = false, LvlMin = 120}, -- mine rivage
        {Zone = {
            {mine26, "178782220", false},
            {mine27, "178782208", false},
            {mine28, "178783234", false},
            {mine28Fin, "173018629", false}
        }, Gath = {54, 37}, Farmer = false, LvlMin = 120},
        {Zone = {
            {Sidimote1, "178783242", false}, 
            {Sidimote2, "178783240", false}
        }, Gath = {24, 26}, Farmer = false, LvlMin = 120},
        {Zone = {
            {Sidimote3, "178785288", false}, 
            {Sidimote4, "178784264", false}, 
            {Sidimote5, "171707908", false}
        }, Gath = {52, 54}, Farmer = false, LvlMin = 120},
        {Zone = {
            {MineMontagne_20_20, "164102664", false},
        }, Gath = {53, 55, 24, 26}, Farmer = false, LvlMin = 120 },
        {Zone = {
            {MineDopeul1, "123470339", false},
            {MineDopeul2, "123471363", false},
            {MineDopeul3, "100141313", false}
        }, Gath = {53, 55, 37, 54}, Farmer = false, LvlMin = 120 },
        {Zone = {
            {LacCania, "133433344", false}
        }, Gath = {17, 53, 55, 37, 54}, Farmer = false, LvlMin = 120},
        {Zone = {
            {Pandala, "209456132", false}
        }, Gath = {114, 113}, Farmer = false, LvlMin = 120}, -- pandala
        {Zone = {
            {Saharach, "173539332", false}
        }, Gath = {24, 26, 25}, Farmer = false, LvlMin = 120}, -- saharach [Géchar]
        {Zone = {
            {Koalak1, "130810369", false}, 
            {Koalak2, "149949440", false},
            {Koalak3, "147852290", false}
        }, Gath = {52, 53, 55, 37, 54}, Farmer = false, LvlMin = 120}, -- koalak [Chill]
        {Zone = {
            {Frigost1, "57017861", false}, 
            {Frigost2, "56886787", false}, 
            {Frigost3, "57016837", false},
            {Frigost4, "57017859", false}
        }, Gath = {135, 25, 52, 26}, Farmer = false, LvlMin = 140}, -- frigost [Géchar]
        {Zone = {
            {BordBwork1, "97261067", false},
            {BordBwork2, "97259017", false},
            {BordBwork3, "97260041", false},
            {BordBwork4, "97256969", false}, 
            {BordBwork5, "97261061", false}, 
            {BordBwork6, "88213774", false}
        }, Gath = {17, 53, 55, 37, 54, 24}, Farmer = false, LvlMin = 120},
        {Zone = {
            {Bwork1, "104861191", false}, 
            {Bwork2, "104862215", false}, 
            {Bwork3, "104862213", false}, 
            {Bwork4, "104859139", false}, 
            {Bwork5, "104862217", false}, 
            {Bwork6, "104859145", false}, 
            {Bwork7, "104072452", false}
        }, Gath = {55, 54, 52, 24, 26, 25}, Farmer = false, LvlMin = 120}, -- [Géchar]
    
    }
end

local function ChoosePath()
    
    for i = 4, 6 do 
        if character:level() > Aliage[i].lvlMax then
            Aliage[i].lvlMax = 201
        end
    end
    

    for _, element in ipairs(TableArea) do
        element.Farmer = false
        for _, element2 in ipairs(element.Zone) do
            element2[3] = false
        end
    end
    local stop = false
    

    for _, element in ipairs(TableArea) do -- si la zone contient un élément que l'on doit récolter alors on la choisi
        if stop then
            break
        end
        for _, element2 in ipairs(GATHER) do
            if stop then
                break
            end
            for _, element3 in ipairs(element.Gath) do
                if element3 == element2 then
                    element.Farmer = true
                    element.Zone[1][3] = true
                    stop = true
                    break
                else
                    element.Farmer = false
                    element.Zone[1][3] = false
                end
            end
        end
    end

    DebutDuScript = false
end

local function achatSacStaca()
    buyBestItem(1704) 

    global:finishScript()
    Buyer:many({1704})
    global:leaveDialog()
    inventory:equipItem(1704, 7)
    ChoosePath()
    map:changeMap("right")
end

local AreaAchatSacStaca = {
    {map = "0,0", path = "zaap(212600323)"},
    {map="212600323", path="bottom"},
    {map="-31,-55", custom = achatSacStaca},
}
--- </init>



local phrase = nil
if global:thisAccountController():getAlias():find("Mineur2") then
    phrase = "Mineur2 " .. character:server()
    -- PLANNING = {17, 18 , 19, 20, 21, 22}
elseif global:thisAccountController():getAlias():find("Mineur3") then
    phrase = "Mineur3 " .. character:server()
    -- PLANNING = {17, 18, 19, 20, 21, 22}
elseif global:thisAccountController():getAlias():find("Mineur4") then
    phrase = "Mineur4 " .. character:server()
    -- PLANNING = {9, 10, 11, 12, 13, 14}
else
    phrase = "Mineur " .. character:server()
    -- PLANNING = {17, 18, 19, 20, 21, 22}
end


-- Montant de kamas que le bot farm devra garder 
local minKamas = nil

-- Montant de kamas qui déclenchera le transfert au bot bank
local givingTriggerValue = 2000000


local function IncrementTable(i, Taille)
    local toReturn = (i + 1) % (Taille + 1)
    return (toReturn > 0) and toReturn or (toReturn == 0) and 1
end


local function CheckEndFight(message)
    if not message.results[1].alive then
        global:printSuccess("On vient de perdre un combat, on recommence le trajet")
        ChoosePath()
    end
end

function messagesRegistering()
	developer:registerMessage("HaapiShopApiKeyMessage", _HaapiShopApiKeyMessage)
	developer:registerMessage("HaapiConfirmationMessage", _HaapiConfirmationMessage)
    developer:registerMessage("GameFightEndMessage", CheckEndFight)
end

local function editAlias(toAdd)
    if global:thisAccountController():getAlias():find("Mineur2") then
        global:editAlias("Mineur2 " .. character:server() .. " " .. toAdd, true)
    elseif global:thisAccountController():getAlias():find("Mineur3") then
        global:editAlias("Mineur3 " .. character:server() .. " " .. toAdd, true)
    elseif global:thisAccountController():getAlias():find("Mineur4") then
        global:editAlias("Mineur4 " .. character:server() .. " " .. toAdd, true)
    elseif global:thisAccountController():getAlias():find("Mineur5") then
        global:editAlias("Mineur5 " .. character:server() .. " " .. toAdd, true)
    else
        global:editAlias("Mineur1 " .. character:server() .. " " .. toAdd, true)
    end
end

local function antiModo()
    -- if global:isModeratorPresent(30) then
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

local function defineGather()
    local insert = table.insert
    local result = {}
    for _, element in pairs(TableGather) do
        if inventory:itemCount(element.IdObjet) < element.Max and element.Farmer then
            insert(result, element.IdRessource)
        end
    end
    GATHER = result
    if result == nil or #result == 0 then
        global:printSuccess("On a plus rien à récolter, on va à la banque")
        return bank()
    end

    if #GATHER <= 3 then
        for _, element in ipairs(TableGather) do
            element.Max = 150
        end
    end

    TableGather[#TableGather].Max = (#GATHER == 1 and GATHER[1] == 135) and 100 or 300

end

local function settOrnament(ornamentID)
    message = developer:createMessage("OrnamentSelectRequestMessage")
    message.ornamentId = ornamentID
    developer:sendMessage(message)
end

local function ProcessBank()
    if character:level() > 160 then
        settOrnament(14)
    end
    NeedToReturnBank = false
    compteurZone = 0
    CompteurChangement = 0
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

    for _, element in ipairs(TableGather) do
        if exchange:storageItemQuantity(element.IdObjet) > 3000 and job:level(24) > 180 then
            element.Farmer = false
        else
            element.Farmer = true
        end
    end

    defineGather()

    ChoosePath()

    for _, element in ipairs(Minerai) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end
    global:printSuccess("------------------------------")
    for _, element in ipairs(Aliage) do
        global:printSuccess("[Banque] : " .. exchange:storageItemQuantity(element.Id) .. " [" .. element.Name .. "]")
    end

	local podsAvailable = inventory:podsMax() - inventory:pods()

	if exchange:storageItemQuantity(Minerai[5].Id) < 50 and not hdvFull and job:level(24) < 160 then achatArgent = true end
	if exchange:storageItemQuantity(Minerai[7].Id) < 50 and not hdvFull and job:level(24) < 160 then achatEtain = true end
	if exchange:storageItemQuantity(Minerai[10].Id) < 50 and not hdvFull and job:level(24) < 160 then achatBronze = true end
    if exchange:storageItemQuantity(27621) < 50 and not hdvFull and job:level(24) > 179 then achatCendrePierre = true end


	podsAvailable = inventory:podsMax() - inventory:pods()

    for _, element in ipairs(Aliage) do
        local QuantiteAPrendre = math.min(math.floor(podsAvailable / inventory:itemWeight(element.Id)), exchange:storageItemQuantity(element.Id), 33)
        if QuantiteAPrendre >= 10 and element.CanSell and not hdvFull then
            exchange:getItem(element.Id, QuantiteAPrendre)
            podsAvailable = inventory:podsMax() - inventory:pods()
            element.CanSell = false
            NeedToSell = true
        end
    end
    
    for _, element in ipairs(Aliage) do
        element.CanCraft = true
        local totalWeight = 0

        for _, element2 in ipairs(element.ListIdCraft) do
            totalWeight = totalWeight + inventory:itemWeight(element2.Id) * element2.Nb
            if not (exchange:storageItemQuantity(element2.Id) >= 50) or NeedToCraft or not element.CanSell or job:level(24) >= element.lvlMax then
                element.CanCraft = false
                break
            end
        end
        if element.Stopper ~= nil and element.CanSell and element.CanCraft and not NeedToCraft and job:level(24) < element.lvlMax then

            CraftQuantity = math.floor(podsAvailable * 0.95 / totalWeight)

            for _, element2 in ipairs(element.ListIdCraft) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(element2.Id) / element2.Nb))
            end   
            
            if CraftQuantity >= 5 then
                NeedToSell = false
                NeedToCraft = true
                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")

                for _, element2 in ipairs(element.ListIdCraft) do
                    exchange:getItem(element2.Id, CraftQuantity * element2.Nb)
                end
            end
        elseif element.Stopper == nil and element.CanCraft and not NeedToCraft and job:level(24) < element.lvlMax then
            CraftQuantity = math.floor(podsAvailable / totalWeight)
            global:printSuccess("pods available : " .. podsAvailable)
            global:printSuccess("total weight : " .. totalWeight)

            for _, element2 in ipairs(element.ListIdCraft) do 
                CraftQuantity = math.min(CraftQuantity, math.floor(exchange:storageItemQuantity(element2.Id) / element2.Nb))
            end   
            
            if CraftQuantity >= 5 then
                NeedToSell = false
                NeedToCraft = true
                global:printSuccess("[Info] Possibilité de création de " .. CraftQuantity .. "x [" .. element.Name .. "]")

                for _, element2 in ipairs(element.ListIdCraft) do
                    exchange:getItem(element2.Id, CraftQuantity * element2.Nb)
                end
            end
        end
    end

    for i = 1, 9 do
        local QuantiteAPrendre = math.min(math.floor(podsAvailable / 5), exchange:storageItemQuantity(Minerai[i].Id), 330)
        if Minerai[i].LvlMinToSell ~= nil and job:level(24) >= Minerai[i].LvlMinToSell and QuantiteAPrendre == 330 and Minerai[i].CanSell and not hdvFull then
            exchange:getItem(Minerai[i].Id, QuantiteAPrendre)
            podsAvailable = inventory:podsMax() - inventory:pods()
			NeedToSell = true
        end
    end

    NeedToSell = NeedToSell or not NeedToSell and FirstBankReturn
    FirstBankReturn = false

    if (#GATHER == 0 and not NeedToSell) then
        customReconnect(120)
    end

    MaxCompteurZone = (#GATHER == 1) and 50 or 20


    hdvFull = false
   	global:leaveDialog()
    global:delay(1000)
    map:door(518)
end

local function ProcessCraft()
    NeedToCraft = false
	NeedToSell = true
	map:useById(521478, -1)
	global:delay(1000)
	
    for index, element in ipairs(Aliage) do
        if element.CanCraft then
            if index == 2 and Aliage[3].CanSell then
                for _, element2 in ipairs(Aliage[2].ListIdCraft) do
                    craft:putItem(element2.Id, element2.Nb)
                end
                craft:changeQuantityToCraft(math.floor(CraftQuantity / 2))
                element.CanCraft = false
                global:delay(1000)
                craft:ready()
                for _, element2 in ipairs(Aliage[3].ListIdCraft) do
                    craft:putItem(element2.Id, element2.Nb)
                end
                craft:changeQuantityToCraft(math.floor(CraftQuantity / 2))
                global:delay(1000)
                craft:ready()
            else
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
    end

    global:leaveDialog() 
	global:delay(1000)
    map:door(437)
end


local function ProcessSell()

    NeedToSell = false
    NeedToReturnBank = true
    if mount:hasMount() and not DDNourrie then
        DDNourrie = true
        buyAndfeedDD()

        if not mount:isRiding() then
            mount:toggleRiding()
        end
    end

    HdvSell()

    for _, element in ipairs(Aliage) do
        local itemSold = false
        cpt = get_quantity(element.Id).quantity["100"]

        local priceItem = GetPricesItem(element.Id)
        priceItem.Price100 = (priceItem.Price100 == nil or priceItem.Price100 == 0 or priceItem.Price100 == 1) and priceItem.AveragePrice * 150 or priceItem.Price100
        priceItem.Price10 = (priceItem.Price10 == nil or priceItem.Price10 == 0 or priceItem.Price10 == 1) and priceItem.AveragePrice * 15 or priceItem.Price10
        priceItem.Price1 = (priceItem.Price1 == nil or priceItem.Price1 == 0 or priceItem.Price1 == 1) and priceItem.AveragePrice * 1.5 or priceItem.Price1

    	while inventory:itemCount(element.Id) >= 100 and sale:availableSpace() > 0 and element.MaxHdv100 ~= nil and cpt < element.MaxHdv100 do 
            sale:SellItem(element.Id, 100, priceItem.Price100 - 1) 
            global:printSuccess("1 lot de " .. 100 .. " x " .. element.Name .. " à " .. priceItem.Price100 - 1 .. "kamas")
            cpt = cpt + 1
            itemSold = true
        end

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

    for _, element in ipairs(Minerai) do
		priceItem = GetPricesItem(element.Id)
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

    prixEtain = GetPricesItem(444).Price100
    prixArgent = GetPricesItem(350).Price100
    prixBronze = GetPricesItem(442).Price100
    prixCendrePierre = GetPricesItem(27621).Price100
    prixPyrute = GetPricesItem(7035).Price1

    global:leaveDialog()

    npc:npc(333,6)
    if prixEtain < 30000 and achatEtain == true then 
        achatEtain = false
        sale:buyItem(444,100,30000)
    end
    if prixArgent < 30000 and achatArgent == true then 
        achatArgent = false
        sale:buyItem(350,100,30000)
    end
    if prixBronze < 30000 and achatBronze == true then 
        achatBronze = false
        sale:buyItem(442,100,30000)
    end
    global:printSuccess("prix cendrePierre : " .. prixCendrePierre * 0.05 .. " prix Pyrute : " .. prixPyrute)
    if prixCendrePierre > 0 and (prixCendrePierre * 0.05) < (prixPyrute / 2) and achatCendrePierre == true then 
        achatCendrePierre = false
        sale:buyItem(27621,100,150000)
    end
    global:leaveDialog()

    HdvSell()

    -- check de l'hdv pour voir si le maximum de cette ressource a été atteinte
    for _, element in ipairs(Aliage) do
        if get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 and get_quantity(element.Id).quantity["1"] >= element.MaxHdv1 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end
    for _, element in ipairs(Minerai) do
        if get_quantity(element.Id).quantity["100"] >= element.MaxHdv100 and get_quantity(element.Id).quantity["10"] >= element.MaxHdv10 then
            element.CanSell = false
        else
            element.CanSell = true
        end
    end

	if cptActualiser >= 3 and not hdvActualise and character:kamas() > 30000 then
		cptActualiser = 0
        hdvActualise = true
		global:printSuccess("Actualisation des prix")
		sale:updateAllItems()
	else
		cptActualiser = cptActualiser + 1
	end
		
    if sale:availableSpace() == 0 then 
        hdvFull = true 
        --global:printError("l'hdv est plein") 
    else
        hdvFull = false
    end

    global:leaveDialog()
    map:changeMap("top")
end


local function WhichArea()
    hdvActualise = false
    for i in ipairs(TableArea) do
        local Zone = TableArea[i].Zone
        for j in ipairs(Zone) do

            if map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) <= #Zone then
                -- si on arrive à la map de changement de sous zone
                Zone[j][3] = false
                Zone[j + 1][3] = true
                return treatMaps(Zone[j + 1][1])

            elseif map:onMap(Zone[j][2]) and Zone[j][3] and TableArea[i].Farmer and (j + 1) > #Zone then
                -- si on arrive à la map de changement de sous zone et à la fin de la table
                CompteurChangement = CompteurChangement + 1
                global:printSuccess(CompteurChangement .. " ème changement de zone")
                Zone[j][3] = false
                TableArea[i].Farmer = false

                for index, element in ipairs(TableArea) do -- on regarde la prochaine qu'on peut farmer

                    for _, element2 in ipairs(GATHER) do -- on regarde si la prochaine contient des éléments à farmer
                        local ZoneSuivante = TableArea[IncrementTable(i + index - 1, #TableArea)]
                        for _, element3 in ipairs(ZoneSuivante.Gath) do

                            if element3 == element2 and job:level(24) >= ZoneSuivante.LvlMin then

                                ZoneSuivante.Farmer = true
                                ZoneSuivante.Zone[1][3] = true
                                return treatMaps(ZoneSuivante.Zone[1][1])

                            end
                        end

                    end

                end
                -- si on a pas trouvé d'autre zone, on refarm la même
                compteurZone = compteurZone + 1
                global:printSuccess(compteurZone .. "ème passage dans cette zone")
                Zone[1][3] = true
                TableArea[i].Farmer = true
                return treatMaps(Zone[1][1])

            elseif Zone[j][3] and TableArea[i].Farmer and job:level(24) >= TableArea[i].LvlMin then

                return treatMaps(Zone[j][1])

            end
        end 
    end
end

function move()

    handleDisconnection()
    mapDelay()
    if global:thisAccountController():getAlias():find("Draconiros") and character:server() ~= "Draconiros" then
        global:thisAccountController():forceServer("Draconiros")
        global:disconnect()
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
            customReconnect(60)
        end
    end
    if character:kamas() < 3000 then
        return treatMaps(GoTakeKamas)
    end
    

    if getRemainingSubscription(true) <= 0 and (character:kamas() > ((character:server() == "Draconiros") and 600000 or 1100000)) then
        Abonnement()
    elseif getRemainingHoursSubscription() < 4 and character:server() == "Draconiros" then
        Abonnement()
    elseif getRemainingSubscription(true) < 0 then
        Abonnement()
    end


    if job:level(24) < 120 and getRemainingSubscription(true) >= 0 then
        global:loadAndStart("C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Recolte\\Mineur_1-150_ULTIME.lua")
    end

    editAlias("[" .. job:level(24) .. "] " .. getRemainingSubscription(true))

    

    if DebutDuScript then ChoosePath() end


    if NeedToCraft then
        return {
            {map = "212600322", path = "zaapi(212602886)"}, -- Map extérieure de la banque de bonta
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
			{map = "212602886", path = "zaapi(212601350)"}, -- map extérieur atelier mineur
			{map = "-29,-55", path = "left"},
			{map = "-30,-55", path = "left"},
            -- {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
            {map = "212600322", path = "zaapi(212601350)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end	

    if compteurZone >= MaxCompteurZone or CompteurChangement >= 25 then return bank() end


    givingTriggerValue = (job:level(24) < 200) and (getRemainingSubscription(true) > 1) and 1000000 or 2000000
    minKamas = (getRemainingSubscription(true) == 0) and 1700000 or 300000

    forwardKamasBotBankIfNeeded(givingTriggerValue, minKamas, 120, 4)

    if job:level(24) == 200 then
        defineGather()
    end
    
    antiModo()

    -- if job:level(24) > 180 and inventory:itemCount(1704) == 0 and character:kamas() >= 150000 then
    --     return treatMaps(AreaAchatSacStaca)
    -- end
    if character:energyPoints() < 5000 then
        return treatMaps(AreaEnergie)
    end

    return WhichArea()
end

function bank()

    mapDelay()

    editAlias("[" .. job:level(24) .. "] " .. getRemainingSubscription(true))

    ChoosePath()

    if NeedToCraft then
        return {
            {map = "212600322", path = "zaapi(212602886)"}, -- Map extérieure de la banque de bonta
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
			{map = "212602886", path = "zaapi(212601350)"}, -- map extérieur atelier mineur
			{map = "-29,-55", path = "left"},
			{map = "-30,-55", path = "left"},
            -- {map = "212600322", path = "bottom(552)"}, -- Map extérieure de la banque de bonta
            {map = "212600322", path = "zaapi(212601350)"}, -- Map extérieure de la banque de bonta
			{map = "-31,-56", path = "bottom"},
			{map = "-31,-55", path = "bottom"},
			{map = "-31,-54", path = "right"},
            {map = "212601350", custom = ProcessSell}, -- Map HDV ressouces bonta
        }
    end	

    for _, element in ipairs(MapSansHavreSac) do
        if not element.Door and map:onMap(tostring(element.Id)) then
            if map:currentCell() == tonumber(element.Path) then
                map:moveToCell(math.random(50, 500))
            end
            global:printSuccess("on est dans le bank()")
            map:moveToCell(tonumber(element.Path))
        elseif map:onMap(tostring(element.Id)) then
            global:printSuccess("on est dans le bank()")
            map:door(tonumber(element.Door))
        end
    end
		
		
	if not map:onMap("0,0") and not map:onMap("-31,-56") and not map:onMap("212600322") and not map:onMap("217059328") then 
        FirstBankReturn = true
        map:changeMap("havenbag")
    end
    
    return { 
			{map="0,0",path="zaap(212600323)"},
			{map="-31,-56",path="top"},
			{map="212600322", door = "468"},
			{map = "217059328", custom = ProcessBank},
    }
end


function stopped()
    local lines = global:consoleLines()
    if lines[#lines - 2]:find("Cette action est impossible car vous êtes occupé.") then
        global:disconnect()
    end
    map:changeMap("havenbag")
end

function banned()
    global:editAlias(phrase .. " [BAN]", true)
end
