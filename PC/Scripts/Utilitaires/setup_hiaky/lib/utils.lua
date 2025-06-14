

--- <Utils>

local insert, remove, sort = table.insert, table.remove, table.sort
Utils = {}

function Utils:mille(value)
	local s = string.format("%d", math.floor(value))
	local pos = string.len(s) % 3
	if pos == 0 then 
        pos = 3
    end
	return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

function Utils:trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

function Utils:isInTable(tab, element)
    global:printSuccess(1)
	for _, value in pairs(tab) do
	    if value == element then
            global:printSuccess(2)
	        return true
	    end
	end
    global:printSuccess(2)
	return false
end

function Utils:indexOf(tab, element)
    for k, v in pairs(tab) do
        if v == element then
            return k
        end
    end
end

function Utils:find(tab, callback)
    if not callback then return end
    
    for k, v in pairs(tab) do
        if callback(v) then
            return v
        end
    end
end

function Utils:filter(tab, callback)
    local result = {}
    if not callback then return end
    
    for k, v in pairs(tab) do
        if callback(v) then
            insert(result, v)
        end
    end

    return result
end

function Utils:map(tab, callback)
    for k, v in pairs(tab) do
        callback(v)
    end
end

function Utils:removeAtIndex(tab, object)
    remove(tab, self:indexOf(tab, object))
end

function Utils:getRdnmIndex(tab)
    return math.random(1, self:getPairsLength(tab))
end

function Utils:firstLetterUpper(str)
    local x, newStr = 0, ""
    for letter in str:gmatch(".") do
        x = x + 1
        if x == 1 then
            newStr = newStr .. letter:upper()
        else
            newStr = newStr .. letter
        end
    end
    return newStr
end

function Utils:intHour(h)
    if not h then
	    h = self:getHour()
    end
	h = h:gsub(":", "")
    if h:find("0") == 1 then
        h = h:gsub("0", "", 1)
    end
    return tonumber(h)
end

function Utils:getToday()
    local d = os.date("%d/%m")
    if d:find('0') == 1 then
        d = d:sub(2, #d)
    end
    return d
end

function Utils:getDayName()
    return os.date("%A"):lower()
end

function Utils:getHour()
    local time = os.date("*t")
    return (os.date("%H:%M"):format(time.hour + 1, time.min, time.sec))
end

function Utils:msInMinutes(time)
    return math.floor(time / 60000)
end

function Utils:secInMinutes(time)
    return math.floor(time / 60)
end

function Utils:timestampDiff(t2)
    return math.abs(os.difftime(os.time(), t2))
end

function Utils:insertOnly1(tab, element)
    if not Utils:isInTable(tab, element) then
        table.insert(tab, element)
    end
end

function Utils:concatIt(tab1, tab2)
	for i = 1, #tab2 do
		tab1[#tab1 + 1] = tab2[i]
	end
	return tab1
end

function Utils:truncate(nbr, size)
    if not nbr then return 0 end
    if not size then size = 2 end
    if size == 0 then size = -1 end
    
    nbr = tostring(nbr) 
    return nbr:sub(1, nbr:find("%p") + size)
end

function Utils:truncKamas(amount)
    amount = tonumber(amount) or character:kamas()
    amount = amount / 1000000

    return self:truncate(amount)
end


function Utils:getPairsLength(tab)
    local c = 0
    for _, element in pairs(tab) do
        c = c + 1
    end
    return c
end

function Utils:normalStr(str)
    local tableAccents = {}
	tableAccents["À"] = "A"
    tableAccents["Á"] = "A"
    tableAccents["Â"] = "A"
    tableAccents["Ã"] = "A"
    tableAccents["Ä"] = "A"
    tableAccents["Å"] = "A"
    tableAccents["Æ"] = "AE"
    tableAccents["Ç"] = "C"
    tableAccents["È"] = "E"
    tableAccents["É"] = "É"
    tableAccents["Ê"] = "E"
    tableAccents["Ë"] = "E"
    tableAccents["Ì"] = "I"
    tableAccents["Í"] = "I"
    tableAccents["Î"] = "I"
    tableAccents["Ï"] = "I"
    tableAccents["Ð"] = "D"
    tableAccents["Ñ"] = "N"
    tableAccents["Ò"] = "O"
    tableAccents["Ó"] = "O"
    tableAccents["Ô"] = "O"
    tableAccents["Õ"] = "O"
    tableAccents["Ö"] = "O"
    tableAccents["Ø"] = "O"
    tableAccents["Ù"] = "U"
    tableAccents["Ú"] = "U"
    tableAccents["Û"] = "U"
    tableAccents["Ü"] = "U"
    tableAccents["Ý"] = "Y"
    tableAccents["Þ"] = "P"
    tableAccents["ß"] = "s"
    tableAccents["à"] = "a"
    tableAccents["á"] = "a"
    tableAccents["â"] = "a"
    tableAccents["ã"] = "a"
    tableAccents["ä"] = "a"
    tableAccents["å"] = "a"
    tableAccents["æ"] = "ae"
    tableAccents["ç"] = "c"
    tableAccents["è"] = "e"
    tableAccents["é"] = "e"
    tableAccents["ê"] = "e"
    tableAccents["ë"] = "e"
    tableAccents["ì"] = "i"
    tableAccents["í"] = "i"
    tableAccents["î"] = "i"
    tableAccents["ï"] = "i"
    tableAccents["ð"] = "eth"
    tableAccents["ñ"] = "n"
    tableAccents["ò"] = "o"
    tableAccents["ó"] = "o"
    tableAccents["ô"] = "o"
    tableAccents["õ"] = "o"
    tableAccents["ö"] = "o"
    tableAccents["ø"] = "o"
    tableAccents["ù"] = "u"
    tableAccents["ú"] = "u"
    tableAccents["û"] = "u"
    tableAccents["ü"] = "u"
    tableAccents["ý"] = "y"
    tableAccents["þ"] = "p"
    tableAccents["ÿ"] = "y"

    local normalizedStr = str:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents)
    return normalizedStr
end

function Utils:reductSpecialStr(str)
    return self:normalStr(str):lower()
end

function Utils:await(messageName, awaitEnd, time)
    print("start await " .. messageName)
    RECONNECT_ON_TIMEOUT = false
    
    time = time and time or 100

    if not _G[messageName] then
        createMessageInstance(messageName)
    end
    
    while not _G[messageName].came do
        print("waiting " .. messageName)
        developer:suspendScriptUntil(messageName, time, false)
    end
    
    if awaitEnd then
        while _G[messageName].came do
            print("await")
            developer:suspendScriptUntil("ClientYouAreDrunkMessage", 20, false)
        end
        RECONNECT_ON_TIMEOUT = false
    else
        RECONNECT_ON_TIMEOUT = false
    end
end

function Utils:try(fn, catch)
    local status, result = pcall(fn)

    if not status then
        return catch and catch(status, result)
    else
        return result
    end
end

function Utils:setNextScript(nextScriptPath)
    File:eraseAndWrite(TEMP_PATH .. "next-script.txt", nextScriptPath, true)
end

function Utils:loadNextScript(limit)
    File:forceFile(TEMP_PATH .. "next-script.txt", limit and limit or 100, true)
end

function plus(var, value)
    var = var or 0
    value = value or 1
    
    return var + 1
end

function less(var, value)
    var = var or 0
    value = value or 1

    return var - 1
end

function hookStr(str, noSpaces)
    return noSpaces and "[" .. str .. "]" or "[ " .. str .. " ]" 
end

function rndm(firstInterval, secondInterval)
    return math.random(firstInterval, secondInterval)
end

function cmd(command, acc)
    if not team then team = Ctrl:getTeamControllers() end
    return acc and acc:executeCmd(command) or myController:executeCmd(command)
end

--"LockableShowCodeDialogMessage"


--- </Utils>
