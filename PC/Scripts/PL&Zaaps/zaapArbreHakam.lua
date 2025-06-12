dofile("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Utilitaires\\IMPORT_LIBRARIES.lua")


local switchScript = false

local trajet = {
	{map = "0,0", path = "zaap(154642)"},
	{map = "-46,18", path = "bottom"},
	{map = "-46,19", path = "left"},
	{map = "-47,19", path = "left"},
	{map = "-48,19", path = "left"},
	{map = "-49,19", path = "left"},
	{map = "-50,19", path = "bottom"},
	{map = "-50,20", path = "bottom"},
	{map = "-50,21", path = "left"},
	{map = "-51,21", path = "top"},
	{map = "-52,20", path = "top"},
	{map = "-51,20", path = "left"},
	{map = "-52,19", path = "top"},
	{map = "-52,18", path = "left"},
	{map = "-53,18", path = "top"},

	{map = "63964931", door = "469"},
	{map = "25694213", path = "271"},
	{map = "24118275", path = "top"},
	{map = "24118274", path = "left"},
	{map = "24117762", path = "top"},
	{map = "24117761", door = "105"},
	{map = "25690112", path = "right"},
	{map = "25690624", path = "345"},
	{map = "24118802", path = "right"},
	{map = "24119314", path = "539"},
	{map = "24118789", path = "left"},
	{map = "24118277", path = "left"},
	{map = "24117765", door = "120"},
	{map = "25691650", path = "bottom"},
	{map = "25691652", path = "bottom"},
	{map = "25691654", path = "388"},
	{map = "24117767", path = "top"},
	{map = "24117766", path = "right"},
	{map = "24118278", path = "bottom"},
	{map = "24118279", path = "right"},
	{map = "24118791", path = "433"},
	{map = "25691144", path = "bottom"},
	{map = "25691146", path = "240"},
	{map = "25692680", path = "146"},
	{map = "20973569", path = "left"},
	{map = "20973057", path = "top"},
	{map = "20973056", path = "top"},
	{map = "20973313", lockedCustom = function() map:saveZaap() switchScript = true end, path = "havenbag"},
}


local function treatMaps(maps)

    for _, element in ipairs(maps) do
        local condition = map:onMap(element.map) 

        if condition then
            return maps
        end
    end

    return {{map = map:currentMap(), path = "havenbag"}}
end


function move()
	mapDelay()
	if switchScript then global:loadAndStart("C:\\Users\\Administrator\\Downloads\\Script_Bot_Dofus\\PC\\Scripts\\Combat\\buyStuff.lua") end
    return treatMaps(trajet)
end

function bank()
	return move()
end