
--- <init>

PATH =  "C:\\Users\\Vivien\\Documents\\Snowbot-Scripts-3\\PC\\Scripts\\Utilitaires\\setup_hiaky\\"
scriptName = "give-kamas.lua"
dofile(PATH .. "template.lua")
local insert = table.insert

function truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    return nbr:sub(1, nbr:find("%p") + size)
end

function truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return truncate(amount, 0)
end

function messagesRegistering()
    for _, message in ipairs(developerMessages) do
        developer:registerMessage(message, messageHandler)
    end
end

--- </init>

createMessageInstance("ExchangeRequestedTradeMessage")
function ExchangeRequestedTradeMessage:receive(message)
    if Utils:isInTable(Exch.whitelist, message.source) then
        global:delay(100, 250)
        Exch:accept()

        Exch.inTrade = message.source
    else Exch:refuse() end
end


--- </init>

local function mapDelay()
	local random = math.random()
	if random < 0.05 then
		global:delay(math.random(10000, 15000))
	elseif random < 0.25 then
		global:delay(math.random(4500, 7000))
	elseif random < 0.5 then
		global:delay(math.random(2000, 4000))
	else
		global:delay(math.random(1000, 2500))
	end
end

function move()
    mapDelay()
    global:editAlias("bank_" .. character:server():lower() .. " : [" .. truncKamas() .. "m]", true)
    return Moving:goAstrubBank(function() 
        Exch:giveKamasJahash()
        global:disconnect()
    end)
end