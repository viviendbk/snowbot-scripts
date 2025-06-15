

local PATH = "C:\\Users\\Administrator\\Documents\\snowbot-scripts\\PC\\Scripts\\Utilitaires\\setup_hiaky\\auto_stuff"

---------------------------------------------------
---------------------- Utils ----------------------
---------------------------------------------------


local json = dofile(PATH .. "\\lib\\json.lua")

local insert, remove, sort = table.insert, table.remove, table.sort
local rndm, print = math.random, {}

local charController = global:thisAccountController()

local function try(fn, catch)
    local status, result = pcall(fn)

    if not status then
        return catch and catch(status, result)
    else
        return result
    end
end

setmetatable(print, print)

local function getPrint(message, info)
    if info then message = "[Info] - " .. message end

    return message
end

print.__call = function(self, message, info)
    global:printMessage(getPrint(message, info))
end

print.success = function(self, message, info)
    global:printSuccess(getPrint(message, info))
end

print.error = function(self, message)
    global:printError(getPrint(message, info))
end

print.color = function(self, message, color)
    if not color then color = "#4d8fbe" end

    global:printColor(color, message)
end

print.void = function(self)
    self:color("", "#343434")
end

print.sep = function(self, color)
    if color == nil then
        self("--------------------------")
    else
        if color == true then
            self:success("--------------------------")
        else
            self:error("--------------------------")
        end
    end
end

print.table = function(self, tab, acc, depth)
    if type(tab) ~= "table" then
        return type(tab) == "nil" and self:error("nil value") or self:error("Not a table")
    end

    depth = depth or 0
    
    for key, value in pairs(tab) do
        local margin = ""

        for _ = 1, depth do
            margin = margin .. "  "
        end

        self(margin .. tostring(key) .. " = " .. tostring(value) .. " (" .. type(value) .. ")", acc)

        if type(value) == "table" then
            self:table(value, acc, depth + 1)
        end
    end
end

local function tabType(tab)
    local result = "dict"

    for k, v in ipairs(tab) do
        result = "array"
        break
    end

    return result
end

local function find(tab, callback)
    local value = callback
    
    callback = type(callback) == "function"
        and callback
        or function(element)
            return element == value 
        end

    for k, v in pairs(tab) do
        if callback(v) then
            return v
        end
    end
end

local function switch(value, cases)
    local rawValue = type(value) == "function"
        and value()
        or value

    local field = nil

    local isBool = function()
        local bools = { "true", "false", "nil" }
        
        local found = find(bools, function(elem)
            return elem == tostring(rawValue)
        end)

        return found
    end

    field = isBool() and tostring(rawValue) or rawValue

    if not field or not cases[field] then
        return cases.default
    end

    local result = type(cases[field]) == "function"
        and cases[field](rawValue)
        or cases[field]

    return result
end

local function isIn(tab, element)
    for k, v in pairs(tab) do
        if v == element then
            return v
        end
    end
end

local function rmv(tab, element)
    local index = 0

    for k, v in pairs(tab) do
        if v == element then
            index = k
            break
        end
    end

    if index ~= 0 then remove(tab, k) end
end

local function filter(tab, callback)
    local result, value = {}, callback
    
    callback = type(callback) == "function"
        and callback
        or function(element)
            return element == value 
        end

    for k, v in pairs(tab) do
        if callback(v) then
            insert(result, v)
        end
    end

    return result
end

local function concat(first, second)
    for i = 1, #second do
        first[#first + 1] = second[i]
    end

    return first
end

local function clone(tab)
    local result = {}
    for k, v in pairs(tab) do
        local value = v
        if type(v) == "table" then
            value = clone(v)
        end

        result[k] = value
    end

    return result
end

local function merge(first, second)
    first = first or {}

    for k, v in pairs(second) do
        first[k] = v
    end

    return first
end

local function concat(first, second)
    for i = 1, #second do
		first[#first + 1] = second[i]
	end

	return first
end

local function split(str, sep, rawSep)
    local result = {}

    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end
    
    local rawSep = rawSep
        and sep
        or "([^" .. sep .. "]+)"
    
    for match in str:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

local function join(self, sep)
    local result = ''
    for k, v in ipairs(self) do
        result = sep 
            and result .. v .. sep 
            or result .. v
    end

    return result or ''
end

local function thsd(value)
    local s = string.format("%d", math.floor(value))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end

    return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

local function hooks(str)
    if type(str) ~= "string" then
        str = tostring(str or "nil")
    end

    return "[ " .. str .. " ]"
end

local function openFile(path, del)
    local fileResult = io.open(path, "r")

    if fileResult then
        local content = fileResult:read("*a")
        fileResult:close()

        if del then os.remove(path) end

        return path:find(".json")
            and json.decode(content)
            or content 
    end
end

local function writeFile(path, data)
    local file = io.open(path, "w")

    file:write(path:find(".json") and json.encode(data) or data)
    file:close()
end

local function stop()
    global:finishScript()
end

local effectsEnum = openFile(PATH .. "\\data\\effects_enum.json")

local function getEffect(data)
    local search = nil

    local search = switch(type(data), {
        ["number"] = { id = data, name = "" },
        ["string"] = { id = 0, name = data },
        ["table"] = data,
    })

    return find(effectsEnum, function(effect)
        return effect.id == search.id
            or effect.name == search.name
    end)
end

local function NpcGenericActionRequestMessage(npcId, actionId, npcMapId)
    local message = developer:createMessage("NpcGenericActionRequestMessage")

    message.npcId = npcId
    message.npcActionId = actionId
    message.npcMapId = npcMapId

    developer:sendMessage(message)
end

local Buyer, Error, BidHouse, ShopItem = {}, {}, {}, {}
local IGNORE = {}

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


---------------------------------------------------
---------------------- Error ----------------------
---------------------------------------------------


function Error:new(id, msgs, fatal)
    local new = {
        id = id or -1,
        msgs = msgs or {},
        fatal = fatal
    }
    
    setmetatable(new, self)
    self.__index = self

    return new:init()
end

function Error:init()

    if self.fatal then
        local id = tostring(self.id) or "-1"

        self.fatal = switch(id, {
            ["0"] = "Configuration invalide.",

            default = "Inconnue."
        })
    end

    return self
end

function Error:set(data)
    self.id = data.id

    for _, msg in ipairs(data.msgs) do
        insert(self.msgs, msg)
    end
end

function Error:print()
    local fatal = self.fatal and "fatale" or ""
    local basic = "Erreur " .. fatal .. " "
        .. self.id .. " : "

    if self.fatal then
        print:void()
        print:sep(false)
    end

    print:sep(false)
    print:error(basic())

    if self.fatal then print:error(self.fatal) end

    for _, msg in ipairs(self.msgs) do
        print:error(msg)
    end

    print:sep(false)

    if self.fatal then
        print:sep(false)
        print:void()
    end
end

function Error:on(shutdown)
    if self.id >= 0 then
        --self:print()

        if self.fatal then
            if shutdown then stop() end
            
            return true
        end
    end
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


---------------------------------------------------
-------------------- Bid House --------------------
---------------------------------------------------


function BidHouse:new(mode)
    local new = {
        packets = {
            price = "ExchangeTypesItemsExchangerDescriptionForUserMessage"
        }
    }

    setmetatable(new, self)
    self.__index = self

    return new:init(mode)
end

function BidHouse:init(mode)
    self.stall = {}
    self:open(mode)

    return self
end

function BidHouse:search(id)
    local items, dices = {}, nil
    local await = "ExchangeTypesItemsExchangerDescriptionForUserMessage"
    local message = developer:createMessage("ExchangeBidHouseSearchMessage")

    message.objectGID = id
    message.follow = true

    developer:registerMessage(self.packets.price, function(msg)
        for _, itd in ipairs(msg.itemTypeDescriptions) do
            local shopItem = ShopItem:new(itd)

            dices = dices or shopItem.dices

            if dices then shopItem.dices = nil end

            insert(items, shopItem)
        end

        sort(items, function(x, y)
            return x.price < y.price
        end)
    end)

    developer:sendMessage(message)
    developer:suspendScriptUntil(await, 100, false)

    self.stall = {
        id = id,
        items = items,
        dices = dices
    }

    --writeFile(PATH .. "\\stall.json", self.stall)


    developer:unRegisterMessage(self.packets.price)
end

function BidHouse:buy(item)
    if self.mode ~= 6 then
        global:leaveDialog()

        self:open("buy")
    end

    local message = developer:createMessage("ExchangeBidHouseBuyMessage")
    
    message.uid = item.uid
    message.qty = item.qty
    message.price = item.price

    local count = inventory:itemCount(item.id)

    developer:sendMessage(message)
    developer:suspendScriptUntil("ClientYouAreDrunkMessage", 500, false, nil, 50)

    if inventory:itemCount(item.id) > count then
        return true
    end
end

function BidHouse:open(mode)
    self.mode = switch(mode, {
        sell = 5,    
        buy = 6    
    })
    
    if self.mode then
        local await = "ExchangeStartedBidBuyerMessage"
        NpcGenericActionRequestMessage(-1, self.mode, map:currentMapId())
        
        developer:suspendScriptUntil(await, 500, false, nil, 50)
    end
end

function BidHouse:close()
    self.mode = nil

    global:leaveDialog()
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


---------------------------------------------------
-------------------- Shop item --------------------
---------------------------------------------------


function ShopItem:new(itd)
    local new = { itd = itd }

    setmetatable(new, self)
    self.__index = self

    new:deserialize()

    return new:init()
end

function ShopItem:init()
    self.ignore = find(IGNORE, function(item)
        return item.id == self.id
    end)

    self:getDices()
    self:getCoefs()
    self:getSpecials()

    self.itd = nil
    self.id = nil
    self.ignore = nil

    return self
end

function ShopItem:deserialize()
    local itd, result = self.itd, {}
    local model = { 
        "objectGID",
        "objectUID",
        "effects"
    }

    if not itd then return end

    for _, field in ipairs(model) do
        if itd[field] then
            if field == "effects" then
                result[field] = {}
                
                for _, effect in ipairs(itd.effects) do
                    if developer:typeOf(effect) == "ObjectEffectInteger" then
                        if effect.actionId ~= 2825 then
                            insert(result[field], {
                                id = effect.actionId,
                                value = effect.value
                            })
                        end
                    end
                end
            else
                result[field] = itd[field]
            end
        end
    end

    self.id = result.objectGID
    self.uid = result.objectUID
    self.effects = result.effects
    
    self.price = itd.prices[1] or 0
end

function ShopItem:getDices()
    local dices = {}
    local itemData = d2data:objectFromD2O("Items", self.id)

    if not itemData then
        print:error("ShopItem error.", true)
        print:error("no item found for provided id - ", true)
        print:error(" Id : " .. self.id or 0, true)
        print:sep(false)

        return {}
    end

    itemData = itemData.Fields

    for k, v in ipairs(itemData.possibleEffects) do
        local data = v.Fields
        local effect = getEffect(data.effectId)

        if effect then
            effect = clone(effect)

            if not effect.name:find("Degats") then
                local diceSide = data.diceSide == 0
                    and data.diceNum
                    or data.diceSide

                effect.dice = {
                    min = data.diceNum,
                    max = diceSide 
                }

                insert(dices, effect)
            end
        end
    end

    self.dices = dices
end

function ShopItem:getSpecials()
    if not self.effects then return end

    for _, effect in ipairs(self.effects) do
        local category = 0

        local diceData = find(self.dices, function(eff)
            return eff.id == effect.id
        end)

        if not diceData then
            local style = find({ 1151, 1152 }, effect.id)

            if not style then
                category = 2
            end
        else
            if effect.value > diceData.dice.max then
                category = 1
            end
        end

        if category > 0 then
            effect.special = category
        end
    end
end

function ShopItem:getEffectCoef(effect, dices)
    local result = 1

    local shouldIgnore = find(self.ignore.effects, function(eff)
        return eff.id == effect.id
    end)

    if shouldIgnore then return result end

    local found = find(dices, function(eff)
        return eff.id == effect.id
    end)

    if found then
        local dice, jet = found.dice, effect.value
        local error = not dice or not dice.min
            or not dice.max

        if error then return 0 end
        
        if dice.min == dice.max then
            if jet == dice.min then result = 1
            else result = jet / dice.min end 
        else
            local gap = dice.max - dice.min

            result = (jet - dice.min) / gap
        end
    end

    return result
end

function ShopItem:getCoefs()
    local coefAvrg = 0

    for _, eff in ipairs(self.effects) do
        coefAvrg = coefAvrg + self:getEffectCoef(eff, self.dices)
    end

    self.quality = (coefAvrg / #self.effects) * 100
    self.kpq = self.price / self.quality
end

function ShopItem:getExo()
    local result = filter(self.effects, function(eff)
        return eff.special and eff.special == 2
    end)

    return #result > 0 and result
end

function ShopItem:getOver()
    local result = filter(self.effects, function(eff)
        return eff.special and eff.special == 2
    end)

    return #result > 0 and result
end

function ShopItem:hasJets(effArr)
    local result = {}

    effArr = tabType(effArr) == "dict"
        and { effArr }
        or effArr

    local function has(effect)
        if effect.id == -1 then return true end

        local result = clone(effect)

        result.value = result.value or 0

        for _, eff in ipairs(self.effects) do
            local condition = (eff.id == result.id
                and eff.value >= result.value)

            if condition then
                merge(result, eff)

                return result
            end
        end
    end

    for _, effect in ipairs(effArr) do
        local effResult = has(effect)

        if effResult then
            insert(result, effResult)
        end
    end

    return #result == #effArr
end

function ShopItem:compare(shopItem)
    local result = {}

    local qualityDiff = math.floor(shopItem.quality - self.quality)
    local percentDiff = (qualityDiff / shopItem.quality) * 100

    result.quality = {
        amount = qualityDiff,
        percent = math.floor(percentDiff)
    }
    
    local priceDiff = shopItem.price - self.price
    percentDiff = (priceDiff / shopItem.price) * 100

    result.price = {
        amount = priceDiff,
        percent = math.floor(percentDiff)
    }

    return result
end


---------------------------------------------------
---------------------- Buyer ----------------------
---------------------------------------------------


function Buyer:new(id)
    IGNORE = {}
    local new = {}

    if type(id) == "table" then
        new.id = id.id
        new.config = id
    else
        new.id = id
    end

    new.count = inventory:itemCount(new.id)

    new.name = hooks(inventory:itemNameId(new.id))
    new.error = Error:new()

    setmetatable(new, self)
    self.__index = self

    new = new:init()    

    new.error:on()

    return new
end

function Buyer:init()
    print("Achat d'équipement - " .. self.name, true)

    return self:initConf()
end

function Buyer:initConf()
    local tables = { "jets", "ignore", "wanted", "price" }
    local numbers = { "max", "diff" }

    if not self.config then self:setConfig() end

    self.error:on(true)

    local conf = find(self.config, function(item)
        return item.id == self.id
    end)

    if not conf then
        self.error:set({
            id = 0,
            msgs = { 
                "Pas de configuration trouvé pour"
                    .. " l'item " .. self.name
            }
        })
    else
        local config = {}

        for _, field in ipairs(tables) do
            config[field] = conf[field] or {}
        end

        for _, field in ipairs(numbers) do
            conf.price = conf.price or {}

            config.price[field] = conf.price[field] or 10^10
        end
    
        config.minQuality = conf.minQuality or -(10^4)

        local target = config.wanted

        if target.name and target.force then
            self.force = target
        end

        config.wanted = { config.wanted }

        local treated = self:setEffectsIds(config)

        merge(self, treated)
    end

    self.config = nil

    return self
end

function Buyer:setEffectsIds(conf)
    local results = {}
    local types = { "wanted", "ignore", "jets" }

    local function setter(object, type)
        if object.name then
            local effect = getEffect(object.name)

            if effect then
                object.id = effect.id

                insert(results[type], object)
            else
                self.error:set({
                    id = 0,
                    msgs = {
                        "Aucun id trouvé pour l'effet : ",
                        " Champ " .. hooks(type),
                        " Nom : " .. hooks(object.name),
                    }
                })
            end
        else
            insert(results[type], { id = -1 })
        end
    end

    for _, dataType in ipairs(types) do
        results[dataType] = results[dataType] or {}

        local confData = conf[dataType]

        if confData then
            for _, effect in ipairs(confData) do
                setter(effect, dataType)
            end
        end
    end

    insert(results.ignore, { id = 2825 })
    insert(IGNORE, {
        id = self.id,
        effects = results.ignore
    })

    results.ignore = nil
    results.wanted = results.wanted[1]

    merge(conf, results)

    return conf
end

function Buyer:setConfig(path)
    path = path or PATH .. "\\items_config.json"

    self.config = openFile(path)

    if not self.config then
        self.error:set({
            id = 0,
            msgs = {
                "Aucun fichier de configuration trouvé.",
                " Chemin : " .. path
            },
            fatal = true
        })
    end
end

function Buyer:printItem(item)
    item = item or self.worthest

    if item then

        print:void()

        print:success(hooks(inventory:itemNameId(self.id)), true)


        local overed = find(item.effects, function(eff)
            return eff.special
        end)

        if overed then
            local effData = getEffect(overed)

            overed = effData.name
        else
            overed = "Aucun"
        end

        print(" prix : " .. hooks(thsd(item.price) .. " kamas"), true)
        print(" qualité : " .. hooks(math.floor(item.quality) .. "%"), true)
        print(" kqp : " .. hooks(math.floor(item.kpq) .. " k/q"), true)
        print(" over : " .. hooks(overed), true)
        print(" jets : ", true)

        for _, eff in ipairs(item.effects) do

            local bl = find({ 1151, 1152, 2825 }, eff.id)

            if not bl and eff.value < 10000 then
                local effData = getEffect(eff)

                print("  " .. hooks(eff.value) .. " - " .. effData.name, true)
            end
        end

        print:sep(true)
        print:void()
    else
        global:printError("bug")
    end

end

function Buyer:getWorthest()
    local bh = self.bidHouse

    local basicCond = function(item)
        return item.price <= self.price.max
            and item.quality >= self.minQuality
    end

    local filtering = function(item)
        local has = item:hasJets(self.jets)
        
        if self.force then
            has = item:hasJets(self.force)
        end

        return basicCond(item) and has
    end

    local filtered = filter(bh.stall.items, filtering)
    self.worthest = filtered[1]

    self:printItem()

    if self.worthest then
        for _, item in ipairs(bh.stall.items) do
            if item ~= self.worthest then
                if item:hasJets(concat(self.jets, { self.wanted })) then
                    local diff = self.worthest:compare(item)
                    local cond = (diff.quality.amount >= 0
                        and diff.price.percent <= 100
                        and diff.price.amount <= self.price.diff)
    
                    if cond and basicCond(item) then
                        self.worthest = item
    
                        print:sep(true)
    
                        print:success("Meilleur objet trouvé : ")
                        self:printItem()
    
                        break
                    end
                end
            end
        end
    end
end

function Buyer:process()
    if self.error:on() then return self.error end

    self.bidHouse = BidHouse:new("buy")

    global:printSuccess(self.id)

    self.bidHouse:search(self.id)

    self:getWorthest()

    local item = self.worthest

    if item then
        local data = {
            id = self.id,
            uid = item.uid,
            price = item.price,
            qty = 1
        }

        print:table(data)
        local result = self.bidHouse:buy(data)

        if not result then
            print:sep(false)
            print:error("L'objet n'a pas pu être acheté.", true)
            print:sep(false)

            print:void()
        else
            print:sep(true)
            print:success("Objet acheté avec succcès.")
            print:sep(true)
            print:void()

            return true
        end
    else
        print:sep(false)
        print:error("Objet non-trouvé pour les conditions fournies.", true)
        print:sep(false)
        print:void()
    end
end

-- static
function Buyer:many(...)
    local results = {}
    local items = type(...) == "table"
        and ...
        or { ... }

    print:success("Achat des items.", true)
    print:void()

    for _, item in ipairs(items) do
        local item = self:new(item)

        if item then
            insert(results, {
                id = item,
                success = item:process()
            })
        end 
    end

    return results
end


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------


return Buyer