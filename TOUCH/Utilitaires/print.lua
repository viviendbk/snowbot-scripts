--- <print>

--[[
	
print(message)          replace global:printMessage(message)
print:error(message)    replace global:printError(message)
print:success(message)  replace global:printSuccess(message)
print:info(message)     print with info tag
print:successInfo(message)  print success with info tag
print:table(tab)        print table (all depths) with values types
	
]]

function getVarName(var)
    if not var then
        return "nil"
    end
    for key, element in pairs(_G) do
        if element == var then
            return key
        end 
    end
end

print = {}
setmetatable(print, print)

print.tags = {
    error = "[Erreur] - ",
    info = "[Info] - ",
    selling = "[Vente] - ",
    dev = "[Dev] - ",
    marge = " - ",
}
	
print.__call = function(self, message, acc)
    local accGlobal = acc and acc.global or global
    accGlobal:printMessage(message)
end

print.success = function(self, message, acc)
    local accGlobal = acc and acc.global or global
    accGlobal:printSuccess(message)
end

print.red = function(self, message, acc)
    local accGlobal = acc and acc.global or global
    accGlobal:printError(message)
end

print.color = function(self, message, color, acc)
    local accGlobal = acc and acc.global or global
    if not color then color = "#4d8fbe" end
    accGlobal:printColor(color, message)
end

print.error = function(self, message, acc)
    self:red(self.tags.error .. message, acc)
end

print.table = function(self, tab, acc, depth)
    if type(tab) ~= "table" then
        return type(tab) == "nil" and self:error("nil value") or self:error("Not a table")
    end
    if Utils:getPairsLength(tab) == 0 and not depth then return self:error("Table length is null") end

    if not depth then
        depth = 0
    end
	
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

print.info = function(self, message, acc)
    self(self.tags.info .. message, acc)
end

print.successInfo = function(self, message, acc)
    self:success(self.tags.info .. message, acc)
end

print.errorInfo = function(self, message, acc)
    self:red(self.tags.info .. message, acc)
end

print.marge = function(self, message, acc)
    self(self.tags.marge .. message, acc)
end

print.infoMarge = function(self, message)
    self(self.tags.info:sub(1, #self.tags.info - 2) .. self.tags.marge .. message)
end

print.dev = function(self, message, acc)
    self:color(self.tags.dev .. message, nil, acc)
end

print.successMarge = function(self, message, acc)
    self:success(self.tags.marge .. message, acc)
end

print.errorMarge = function(self, message, acc)
    self:error(self.tags.marge .. message, acc)
end

print.sep = function(self, acc)
    self("---------", acc)
end

print.greenSep = function(self, acc)
    self:success("---------", acc)
end

print.redSep = function(self, acc)
    self:error("---------", acc)
end

print.space = function(self, acc)
    self(" ", acc)
end

print.doubleSpace = function(self, acc)
    for i = 1, 2 do
        self(" ", acc)
    end
end

print.selling = function(self, message, acc)
    self(self.tags.selling .. message, acc)
end

print.successSelling = function(self, message, acc)
    self:success(self.tags.selling .. message, acc)
end

print.errorSelling = function(self, message, acc)
    self:error(self.tags.selling .. message, acc)
end

print.controllerInfo = function(self, message, acc)
    self("[Controller] - " .. message, acc)
end

print.controllerError = function(self, message, acc)
    self:error("[Controller] - " .. message, acc)
end

print.controllerSuccess = function(self, message, acc)
    self:success("[Controller] - " .. message, acc)
end

print.type = function(self, var)
    local varName = getVarName(var)
    self:dev("[Dev info] - type( " .. varName .. " ) = " .. type(var))
end

print.existing = function(self, var)
    local varName = getVarName(var)
    if varName == "nil" then
        self("[Dev info] - La variable n'existe pas") 
    end
end

print.void = function(self)
    self:color("", "#343434", acc)
end


--- </print>

-- local example = "Hello World !"
-- print(example)
-- print:type(var)
-- print:info(example)
-- print:selling(example)
-- print:marge(example)
-- print:error(example)
-- print:errorTag(example)
-- print:errorMarge(example)
-- print:errorSelling(example)
-- print:successInfo(example)
-- print:successMarge(example)
-- print:successSelling(example)
-- print:sep()
-- print:space()
-- print:greenSep()
-- print:doubleSpace()
-- print:redSep()
