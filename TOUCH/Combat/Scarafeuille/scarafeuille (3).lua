AUTO_DELETE = {1974, 1984, 1770, 1773, 398}

MAX_MONSTERS = 4
MIN_MONSTERS = 1

FORBIDDEN_MONSTERS = {654}
FORCE_MONSTERS = {}

local DeconnecterBotBanque = false

function move()

	if DeconnecterBotBanque then
		for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
			if acc:getAlias():find("BanqueDodge") then
				if acc:isAccountConnected() then
					DeconnecterBotBanque = false
					acc:disconnect()
				end
			end
		end
	end
	return {
		{map = "3,22", path = "bottom", fight = true},
		{map = "3,23", path = "bottom", fight = true},
		{map = "3,24", path = "bottom", fight = true},
		{map = "3,25", path = "bottom", fight = true},
		{map = "3,26", path = "bottom|right", fight = true},
		{map = "4,26", path = "bottom", fight = true},
		{map = "4,27", path = "bottom", fight = true},
		{map = "4,28", path = "right", fight = true},
		{map = "5,28", path = "bottom", fight = true},
		{map = "5,29", path = "bottom", fight = true},
		{map = "5,30", path = "bottom", fight = true},
		{map = "5,31", path = "bottom", fight = true},
		{map = "5,32", path = "left", fight = true},
		{map = "4,32", path = "top", fight = true},
		{map = "4,31", path = "top", fight = true},
		{map = "4,30", path = "top", fight = true},
		{map = "4,29", path = "left", fight = true},
		{map = "3,29", path = "bottom", fight = true},
		{map = "3,30", path = "bottom", fight = true},
		{map = "3,31", path = "bottom", fight = true},
		{map = "3,32", path = "left", fight = true},
		{map = "2,32", path = "top", fight = true},
		{map = "2,31", path = "top", fight = true},
		{map = "2,30", path = "left", fight = true},
		{map = "1,30", path = "left", fight = true},
		{map = "0,30", path = "top", fight = true},
		{map = "0,29", path = "top", fight = true},
		{map = "0,28", path = "top", fight = true},
		{map = "0,27", path = "top", fight = true},
		{map = "0,26", path = "top", fight = true},
		{map = "0,25", path = "top", fight = true},
		{map = "0,24", path = "top", fight = true},
		{map = "0,23", path = "right", fight = true},
		{map = "1,23", path = "bottom", fight = true},
		{map = "1,24", path = "bottom", fight = true},
		{map = "1,25", path = "bottom", fight = true},
		{map = "1,26", path = "bottom", fight = true},
		{map = "1,27", path = "bottom", fight = true},
		{map = "1,28", path = "bottom", fight = true},
		{map = "1,29", path = "right", fight = true},
		{map = "2,29", path = "top", fight = true},
		{map = "2,28", path = "top", fight = true},
		{map = "2,27", path = "top", fight = true},
		{map = "2,26", path = "top", fight = true},
		{map = "2,25", path = "top", fight = true},
		{map = "2,24", path = "top", fight = true},
		{map = "2,23", path = "top", fight = true},
		{map = "2,22", path = "top", fight = true},
		{map = "3,27", path = "bottom", fight = true},
		{map = "3,28", path = "bottom", fight = true},
		{map = "4,-19", path = "bottom"},
		{map = "4,-18", path = "bottom"},
		{map = "4,-17", path = "bottom"},
		{map = "4,-16", path = "bottom"},
		{map = "4,-15", path = "bottom(555)"},
		{map = "4,-14", path = "bottom"},
		{map = "4,-13", path = "bottom"},

		{map = "4,-18", path = "bottom"},
		{map = "4,-17", path = "bottom"},


		{map = "4,-10", path = "bottom"},
		{map = "4,-9", path = "left"},
		{map = "3,-9", path = "left"},
		{map = "2,-9", path = "bottom"},
		{map = "2,-8", path = "left"},
		{map = "1,-8", path = "444"},
		{map = "1,-7", path = "bottom"},
		{map = "1,-6", path = "bottom"},
		{map = "1,-5", path = "bottom"},
		{map = "1,-4", path = "bottom"},
		{map = "1,-2", path = "bottom"},
		{map = "1,-1", path = "bottom"},
		{map = "1,-3", path = "bottom"},
		{map = "1,0", path = "bottom"},
		{map = "1,1", path = "bottom"},
		{map = "1,2", path = "bottom"},
		{map = "1,3", path = "bottom"},
		{map = "1,5", path = "bottom"},
		{map = "1,4", path = "bottom"},
		{map = "1,6", path = "bottom"},
		{map = "1,7", path = "bottom"},
		{map = "1,8", path = "bottom"},
		{map = "1,9", path = "bottom"},
		{map = "1,10", path = "bottom"},
		{map = "1,13", path = "bottom"},
		{map = "1,11", path = "bottom"},
		{map = "1,12", path = "bottom"},
		{map = "1,14", path = "bottom"},
		{map = "1,15", path = "bottom"},
		{map = "1,16", path = "bottom"},
		{map = "1,17", path = "bottom"},
		{map = "1,18", path = "bottom"},
		{map = "1,19", path = "bottom"},
		{map = "1,20", path = "bottom"},
		{map = "1,21", path = "bottom"},
		{map = "1,22", path = "right"},
		{map = "2,21", path = "top"},
		{map = "7,11", path = "right"},
		{map = "6,11", path = "right"},
		{map = "5,11", path = "right"},
		{map = "4,11", path = "right"},
		{map = "3,11", path = "right"},
		{map = "2,11", path = "right"},
		{map = "2,12", path = "top"},
		{map = "2,14", path = "top"},
		{map = "2,13", path = "top"},
		{map = "2,15", path = "top"},
		{map = "2,16", path = "top"},
		{map = "2,17", path = "top"},
		{map = "2,18", path = "top"},
		{map = "2,19", path = "top"},
		{map = "2,20", path = "top"},
		{map = "10,9", path = "right", fight = true},
		{map = "9,12", path = "left"},
		{map = "8,12", path = "left"},
		{map = "7,12", path = "left"},
		{map = "6,12", path = "left"},
		{map = "5,12", path = "left"},
		{map = "4,12", path = "left"},
		{map = "3,12", path = "bottom"},
		{map = "3,13", path = "bottom"},
		{map = "3,14", path = "bottom"},
		{map = "3,15", path = "bottom"},
		{map = "3,16", path = "bottom"},
		{map = "3,17", path = "bottom"},
		{map = "3,18", path = "bottom"},
		{map = "3,19", path = "bottom"},
		{map = "3,20", path = "bottom"},
		{map = "3,21", path = "bottom"},
		{map = "8,11", path = "top", fight = true},
		{map = "8,10", path = "right", fight = true},
		{map = "9,10", path = "right", fight = true},
		{map = "10,10", path = "top", fight = true},
		{map = "11,9", path = "bottom", fight = true},
		{map = "11,10", path = "right", fight = true},
		{map = "12,10", path = "bottom", fight = true},
		{map = "12,11", path = "left", fight = true},
		{map = "11,11", path = "left", fight = true},
		{map = "10,11", path = "left", fight = true},
		{map = "9,11", path = "bottom", fight = true},
		
		{map = "4,-12", lockedCustom = nourrirDD, path = "bottom"},
		{map = "4,-11", lockedCustom = nourrirDD, path = "bottom"},
		
	}
end


function bank()

	for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
        if acc:getAlias():find("BanqueDodge") then
            if not acc:isAccountConnected() then
                acc:connect()
            end
        end
    end		


	if map:currentSubArea() ~= "Cité d'Astrub" then 
		return {
			{map = map:currentMapId(), lockedCustom = TPZapAstrub},
		}
	end
	
    return {
	
        {map = "4,-19", path = "bottom"},
        {map = "4,-18", path = "bottom"},
        {map = "4,-17", path = "bottom"},
        {map = "84674566", door = "303"},
		{map = "83887104", lockedCustom = luBank, path = "396"},

        }
end

function luBank() -- Le nom de notre fonction
	chat:sendPrivateMessage("meganecoeurdemavie","Beniix-Mitty")
	
	while not exchange:launchExchangeWithPlayer(2917425) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(2000)
    end
	
  	exchange:putAllItemsExchange() -- La fonction pour déposer tous les objets de l'inventaire
  	exchange:ready() -- La fonction pour valider l'échange

	DeconnecterBotBanque = true
end




function TPZapAstrub()
    npc:npcBuy()
    sale:buyItem(548, 1, 500)
    global:leaveDialog()
    inventory:useItem(548)
end



function nourrirDD()
    npc:npcBuy()
    sale:buyItem(1915, 100, 4000)
    global:leaveDialog()
    global:printSuccess("Cuisse de bouftou achetées")
    mount:feedMount(1915, 100)
    global:leaveDialog()
    global:printSuccess("DD nourrie")
end
