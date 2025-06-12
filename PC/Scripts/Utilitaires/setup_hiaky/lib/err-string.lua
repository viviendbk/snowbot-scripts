

string.split = function(self, sep, rawSep)
    local insert, result = table.insert, {}
    if not sep then
        sep = "."
        rawSep = true
    end
    if sep == "%s" then
        rawSep = nil
    end
    
    local rawSep = rawSep and sep or "([^" .. sep .. "]+)"
    
    for match in self:gmatch(rawSep) do
        insert(result, match)
    end

    return result
end

string.upFirst = function(self)
    local x, newStr = 0, ""
    for letter in self:gmatch(".") do
        x = x + 1
        if x == 1 then
            newStr = newStr .. letter:upper()
        else
            newStr = newStr .. letter
        end
    end
    self = newStr

    return self
end

string.normalize = function(self, lower)
    local tableAccents, result = {}, self
	tableAccents["À"] = "A"
    tableAccents["Á"] = "A"
    tableAccents["Â"] = "A"
    tableAccents["Ã"] = "A"
    tableAccents["Ä"] = "A"
    tableAccents["Å"] = "A"
    tableAccents["Æ"] = "AE"
    tableAccents["Ç"] = "C"
    tableAccents["È"] = "E"
    tableAccents["É"] = "E"
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

    
    result = result:gsub("[%z\1-\127\194-\244][\128-\191]*", tableAccents)
    if lower then result = result:lower() end

    self = result
    
    return self
end

string.findIP = function(self)
    return self:match("%d+%.%d+%.%d+%.%d+") or ""
end

string.markup = function(self, isEnd)
    local result = "<"
    if isEnd then result = result .. "/" end

    return result .. self .. ">"
end

string.hooks = function(self, spaces)
    local hooks = spaces
        and { "[ ", " ]" }
        or { "[", "]" }

    return hooks[1] .. self .. hooks[2]
end

string.spaces = function(self, nbr)
    local result = self
    
    nbr = (not nbr or (nbr and type(nbr) == "string")) and 1 or nbr
    for i = 1, nbr do result = " " .. result .. " " end

    return result
end

string.around = function(self, params)
    if type(params) == "string" then
        return params .. self:spaces() .. params
    elseif type(params) == "table" then
        return params[1] .. self:spaces() .. params[2]
    end
end

string.rmvLast = function(self)
    local result = self:sub(1, #self - 1)
    return result
end

string.rmvExt = function(self, ext, need)
    ext = ext or ".lua"

    local index = self:find(ext)
    local result = self:sub(1, index - 1)

    return need 
        and { ext = ext, result = result }
        or result
end

