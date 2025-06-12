

Exch = {}
Exch.whitelist = {}


function Exch:accept()
    developer:sendMessage(developer:createMessage("ExchangeAcceptMessage"))
end

function Exch:refuse()
    developer:sendMessage(developer:createMessage("LeaveDialogRequestMessage"))
end

function Exch:submitKamasOrder(amount)
    Exch.ordersPath = Exch.ordersPath or TEMP_PATH .. Utils:normalServer() .. "\\bank-orders.json"

    local orders = Utils:try(function()
        return File:openJsonFile(self.ordersPath) 
    end)

    local thisOrder = {
        id = character:id(),
        alias = myAlias,
        kAmount = amount
    }

    if not orders then

        File:writeJsonData(self.ordersPath, { thisOrder }, true)
    else
        for i = #orders, 1 , -1 do
            if orders[i].id == character:id() then
                global:printSuccess("On supprime une ancienne demande")
                table.remove(orders, i)
            end
        end
        table.insert(orders, thisOrder)
        File:writeJsonData(self.ordersPath, orders, true)
    end
end

function Exch:deleteKamasOrder(searchFn)
    self.ordersPath = self.ordersPath or TEMP_PATH .. Utils:normalServer() .. "\\bank-orders.json"

    local orders = File:forceFile(self.ordersPath, 200, true)
    
    if not orders then global:delay(10000) return self:deleteBankOrder(param) end
    for _, order in ipairs(orders) do
        if searchFn(order) then Utils:removeAtIndex(orders, order) end
    end
    File:writeJsonData(self.ordersPath, orders, true)
end

function Exch:whitelistOrderers(updateOrders)
    self.ordersPath = self.ordersPath or TEMP_PATH .. Utils:normalServer() .. "\\bank-orders.json"
    self.orders = File:forceFile(self.ordersPath, 200, true)

    if not self.orders or (self.orders and #self.orders == 0) then
        global:delay(10000)
        self.retry = plus(self.retry)

        if self.retry >= 90 then global:reconnect(0.5) end

        return self:whitelistOrderers()
    end
    
    self.orders = updateOrders and File:forceFile(self.ordersPath, true) or self.orders
    
    self.whitelist = {}
    for _, order in ipairs(self.orders) do
        table.insert(self.whitelist, order.id)
    end
end

function Exch:giveKamas()
    local thisOrder = nil

    global:printSuccess("dac1")
    Exch:whitelistOrderers()
    global:printSuccess("dac1")

    local counter = 0
    while not self.inTrade and counter < 30 do
        developer:suspendScriptUntil("ExchangeRequestedTradeMessage", 1000, false)
        counter = counter + 1
    end

    if counter >= 30 then
        return
    end
    
    global:printSuccess("dac2")

    if not self.inTrade then return self:giveKamas() end
    global:printSuccess("dac3")

    for _, order in ipairs(self.orders) do
        if self.inTrade == order.id then thisOrder = order break end
    end
    global:printSuccess(thisOrder.kAmount)

    if character:kamas() < thisOrder.kAmount then

        local orderer = Ctrl:getControllerBy(function(acc)
            return acc.character():id() == thisOrder.id
        end)

        if orderer then orderer:disconnect() end
        global:disconnect()
    end
    global:printSuccess("dac5")

    global:printSuccess("on envoie " .. thisOrder.kAmount .. " kamas")
    exchange:putKamas(thisOrder.kAmount)

    global:delay(math.random(2000, 4000))

    exchange:ready()
end

function Exch:giveKamasJahash()
    local thisOrder = nil
    Exch:whitelistOrderers()

    while not self.inTrade do
        developer:suspendScriptUntil("ExchangeRequestedTradeMessage", 500, false)
    end

    exchange:putKamas(240000)
    global:delay(math.random(2000, 4000))

    exchange:ready()
end

function Exch:giveKamasAndStuff()
    local thisOrder = nil
	
	local listeItemAPrendre = {
	{name = "coiffe aa", id = 8463},
	{name = "amulette aa", id = 8465},
	{name = "ceinture aa", id = 8468},
	{name = "cape aa", id = 8464},
	{name = "bottes aa", id = 8467},
	{name = "ares", id = 250},
	{name = "anneau aa", id = 8466},
	{name = "gelano", id = 2469},
	{name = "bouclier", id = 18690},
	{name = "trophet 1", id = 13748},
	{name = "trophet 4", id = 13793},
	{name = "dofus cawotte", id = 972},
    {name = "dokoko", id = 17078},
    {name = "dofus argenté", id = 19629},
    {name = "dofus kaliptus", id = 8072},


    {name = "gelocoiffe", id = 2447, emplacement = 6, equipe = false},
    {name = "amulette blop griotte", id = 9149, emplacement = 0, equipe = false},
    {name = "ceinture blop griotte", id = 9167, emplacement = 3, equipe = false},
    {name = "cape rebelles", id = 27523, emplacement = 7, equipe = false},
    {name = "bottes rebelles", id = 27522, emplacement = 5, equipe = false},
    {name = "arme sasa", id = 478, emplacement = 1, equipe = false},
    {name = "anneau rebelles", id = 27524, emplacement = 2, equipe = false},

    {name = "signe d'ombre", id = 14966}
	}
	
	npc:npcBank(-1)
	global:delay(500)
	for _, element in ipairs(listeItemAPrendre) do
		exchange:getItem(element.id, 1)
	end
    exchange:getKamas(0)
	global:delay(500)
	global:leaveDialog()
    local extraKamas = 0
    for _, element in ipairs(listeItemAPrendre) do
        extraKamas = extraKamas + ((inventory:itemCount(element.id) == 0 and not element.name:find("trophet")) and 150000 or 0)
    end
    Exch:whitelistOrderers()

    local counter = 0
    while not self.inTrade and counter < 30 do
        developer:suspendScriptUntil("ExchangeRequestedTradeMessage", 1000, false)
        counter = counter + 1
    end

    if counter >= 30 then
        return
    end

    global:printSuccess("ok1")
    if not self.inTrade then return self:giveKamas() end
    global:printSuccess("ok0")

    for _, order in ipairs(self.orders) do
        if self.inTrade == order.id then thisOrder = order break end
    end
    global:printSuccess("ok2")

    if character:kamas() < thisOrder.kAmount then
        local orderer = Ctrl:getControllerBy(function(acc)
            return acc.character():id() == thisOrder.id
        end)

        if orderer then orderer:disconnect() end
        global:disconnect()
    end

    global:printSuccess(thisOrder.kAmount + extraKamas .. " kamas mis dans l'échange")
    exchange:putKamas(thisOrder.kAmount + extraKamas)
	global:printSuccess("je mets les kamas")
	for _, element in ipairs(listeItemAPrendre) do
		exchange:putItem(element.id, 1)
		global:printSuccess("je mets l'item " .. element.name)
	end
    global:delay(math.random(1000, 2000))

    exchange:ready()
end

function Exch:launchExchange(id)
    id = tonumber(id)

    RECONNECT_ON_TIMEOUT = false

    while not exchange:launchExchangeWithPlayer(id) do
        print:errorInfo("La cible de l'échange n'est pas disponible, nouvelle tentative dans 5 secondes.")
        global:delay(5000)
    end

    RECONNECT_ON_TIMEOUT = true

    return true
end