---@diagnostic disable: undefined-global, lowercase-global

local function GoToAstrub()
    npc:npc(888, 3)
    npc:reply(-1)
    npc:reply(-1)
    npc:reply(-1)
end

local function getRemainingSubscription(inDay, acc)
    local accDeveloper = acc and acc.developer or developer

    local endDate = developer:deserializeObject(developer:historicalMessage("IdentificationSuccessMessage")[1], "subscriptionEndDate")

    local now = os.time(os.date("!*t")) * 1000

    endDate = math.floor((endDate - now) / 3600000)

    return inDay and math.floor(endDate / 24) or endDate
end

local function BonusPack()
    -- ouverture interface
    global:printMessage("ouverture interface")
    developer:sendMessage('{"call":"shopOpenRequest"}')
    developer:suspendScriptUntil("shopOpenSuccess", 10000)

    -- va dans le bon onglet
    global:printMessage("on va dans le bon onglet")

    developer:sendMessage('{"call":"shopOpenCategoryRequest","data":{"categoryId":"557","page":1,"size":10}}')
    developer:suspendScriptUntil("shopOpenCategorySuccess", 10000)
    
    -- achat bonus pack
    global:printMessage("tentative d'achat")

    developer:sendMessage('{"call":"shopBuyRequest","data":{"currency":"KMS","amountHard":800,"amountSoft":112341,"purchase":[{"quantity":1,"id":7537}],"isMysteryBox":false}}')
    developer:suspendScriptUntil("shopBuySuccess", 10000)
    global:printSuccess("achat du bonus pack réussi")
    
end

local function connectBotBanque()
    global:printSuccess("Connexion du bot banque")

    for _, acc in ipairs(ankabotController:getLoadedAccounts()) do
		if acc:getAlias():find("Bank_" .. character:serveur()) then
            if not acc:isAccountConnected() then
                acc:connect()

                global:printMessage("attente de la connexion du bot banque")

                while not acc:isAccountFullyConnected() do
                    global:delay(2000)
                end

				acc:loadConfig(configPath)
				acc:startScript()
                return acc
            else
                global:printSuccess("bot déjà connecté, on attend 2 minutes")
                global:delay(120000)
                return connectBotBanque()
            end
        end
    end
end

local function launchExchangeAndTakeKamas()

    global:printSuccess("Lancement de l'échange avec le bot d'ID " .. id)

    while not exchange:launchExchangeWithPlayer(AccountBank.character:id()) do
        global:printMessage("Attente de l'acceptation de l'échange (5 secondes)")
        global:delay(5000)
    end

    	-- Validation
    chat:sendPrivateMessage(AccountBank.character:name(), AccountBank.character:name())

	-- Confirmation
	if developer:suspendScriptUntil("ExchangeIsReadyMessage", 10000, true) then
		global:printSuccess("Confirmation ...")
		exchange:ready()
		global:printSuccess("Le dernier échange s'est terminé avec succès !")
	else
		global:printError("Le dernier échange a échoué !")
	end

    AccountBank:startScript()
    global:delay(2000)
    AccountBank:disconnect()

    BonusPack()
end


function move()    
    return {
        {map = "-5,-1", path = "bottom"},
		{map = "-4,0", path = "right"},
		{map = "-3,1", path = "right"},
		{map = "-2,2", path = "bottom"},
		{map = "0,3", path = "right"},
		{map = "1,3", path = "right"},
		{map = "2,3", path = "right"},
		{map = "3,3", path = "right"},
		{map = "4,3", path = "right"},
		{map = "6,3", path = "right"},
		{map = "5,3", path = "right"},
		{map = "7,3", path = "right"},
		{map = "8,3", path = "right"},
        {map = "9,3", Custom = GoToAstrub},
        {map = "4,-19", path = "bottom"},
		{map = "4,-18", path = "bottom"},
		{map = "4,-17", path = "bottom"},
        {map = "84674566", Custom = function() AccountBank = connectBotBanque() end, door = "303"},
        {map = "83887104", Custom = launchExchangeAndTakeKamas},

    }
end

function bank()
    return move()
end