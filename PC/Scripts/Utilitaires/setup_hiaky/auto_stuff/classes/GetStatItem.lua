--
-- json.lua
--
-- Copyright (c) 2020 rxi
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--

local json = { _version = "0.1.2" }

-------------------------------------------------------------------------------
-- Encode
-------------------------------------------------------------------------------

local encode

local escape_char_map = {
  [ "\\" ] = "\\",
  [ "\"" ] = "\"",
  [ "\b" ] = "b",
  [ "\f" ] = "f",
  [ "\n" ] = "n",
  [ "\r" ] = "r",
  [ "\t" ] = "t",
}

local escape_char_map_inv = { [ "/" ] = "/" }
for k, v in pairs(escape_char_map) do
  escape_char_map_inv[v] = k
end


local function escape_char(c)
  return "\\" .. (escape_char_map[c] or string.format("u%04x", c:byte()))
end


local function encode_nil(val)
  return "null"
end


local function encode_table(val, stack)
  local res = {}
  stack = stack or {}

  -- Circular reference?
  if stack[val] then error("circular reference") end

  stack[val] = true

  if rawget(val, 1) ~= nil or next(val) == nil then
    -- Treat as array -- check keys are valid and it is not sparse
    local n = 0
    for k in pairs(val) do
      if type(k) ~= "number" then
        error("invalid table: mixed or invalid key types")
      end
      n = n + 1
    end
    if n ~= #val then
      error("invalid table: sparse array")
    end
    -- Encode
    for i, v in ipairs(val) do
      table.insert(res, encode(v, stack))
    end
    stack[val] = nil
    return "[" .. table.concat(res, ",") .. "]"

  else
    -- Treat as an object
    for k, v in pairs(val) do
      if type(k) ~= "string" then
        error("invalid table: mixed or invalid key types")
      end
      table.insert(res, encode(k, stack) .. ":" .. encode(v, stack))
    end
    stack[val] = nil
    return "{" .. table.concat(res, ",") .. "}"
  end
end


local function encode_string(val)
  return '"' .. val:gsub('[%z\1-\31\\"]', escape_char) .. '"'
end


local function encode_number(val)
  -- Check for NaN, -inf and inf
  if val ~= val or val <= -math.huge or val >= math.huge then
    error("unexpected number value '" .. tostring(val) .. "'")
  end
  return string.format("%.14g", val)
end


local type_func_map = {
  [ "nil"     ] = encode_nil,
  [ "table"   ] = encode_table,
  [ "string"  ] = encode_string,
  [ "number"  ] = encode_number,
  [ "boolean" ] = tostring,
}


encode = function(val, stack)
  local t = type(val)
  local f = type_func_map[t]
  if f then
    return f(val, stack)
  end
  error("unexpected type '" .. t .. "'")
end


function json.encode(val)
  return ( encode(val) )
end


-------------------------------------------------------------------------------
-- Decode
-------------------------------------------------------------------------------

local parse

local function create_set(...)
  local res = {}
  for i = 1, select("#", ...) do
    res[ select(i, ...) ] = true
  end
  return res
end

local space_chars   = create_set(" ", "\t", "\r", "\n")
local delim_chars   = create_set(" ", "\t", "\r", "\n", "]", "}", ",")
local escape_chars  = create_set("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local literals      = create_set("true", "false", "null")

local literal_map = {
  [ "true"  ] = true,
  [ "false" ] = false,
  [ "null"  ] = nil,
}


local function next_char(str, idx, set, negate)
  for i = idx, #str do
    if set[str:sub(i, i)] ~= negate then
      return i
    end
  end
  return #str + 1
end


local function decode_error(str, idx, msg)
  local line_count = 1
  local col_count = 1
  for i = 1, idx - 1 do
    col_count = col_count + 1
    if str:sub(i, i) == "\n" then
      line_count = line_count + 1
      col_count = 1
    end
  end
  error( string.format("%s at line %d col %d", msg, line_count, col_count) )
end


local function codepoint_to_utf8(n)
  -- http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&id=iws-appendixa
  local f = math.floor
  if n <= 0x7f then
    return string.char(n)
  elseif n <= 0x7ff then
    return string.char(f(n / 64) + 192, n % 64 + 128)
  elseif n <= 0xffff then
    return string.char(f(n / 4096) + 224, f(n % 4096 / 64) + 128, n % 64 + 128)
  elseif n <= 0x10ffff then
    return string.char(f(n / 262144) + 240, f(n % 262144 / 4096) + 128,
                       f(n % 4096 / 64) + 128, n % 64 + 128)
  end
  error( string.format("invalid unicode codepoint '%x'", n) )
end


local function parse_unicode_escape(s)
  local n1 = tonumber( s:sub(1, 4),  16 )
  local n2 = tonumber( s:sub(7, 10), 16 )
   -- Surrogate pair?
  if n2 then
    return codepoint_to_utf8((n1 - 0xd800) * 0x400 + (n2 - 0xdc00) + 0x10000)
  else
    return codepoint_to_utf8(n1)
  end
end


local function parse_string(str, i)
  local res = ""
  local j = i + 1
  local k = j

  while j <= #str do
    local x = str:byte(j)

    if x < 32 then
      decode_error(str, j, "control character in string")

    elseif x == 92 then -- `\`: Escape
      res = res .. str:sub(k, j - 1)
      j = j + 1
      local c = str:sub(j, j)
      if c == "u" then
        local hex = str:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", j + 1)
                 or str:match("^%x%x%x%x", j + 1)
                 or decode_error(str, j - 1, "invalid unicode escape in string")
        res = res .. parse_unicode_escape(hex)
        j = j + #hex
      else
        if not escape_chars[c] then
          decode_error(str, j - 1, "invalid escape char '" .. c .. "' in string")
        end
        res = res .. escape_char_map_inv[c]
      end
      k = j + 1

    elseif x == 34 then -- `"`: End of string
      res = res .. str:sub(k, j - 1)
      return res, j + 1
    end

    j = j + 1
  end

  decode_error(str, i, "expected closing quote for string")
end


local function parse_number(str, i)
  local x = next_char(str, i, delim_chars)
  local s = str:sub(i, x - 1)
  local n = tonumber(s)
  if not n then
    decode_error(str, i, "invalid number '" .. s .. "'")
  end
  return n, x
end


local function parse_literal(str, i)
  local x = next_char(str, i, delim_chars)
  local word = str:sub(i, x - 1)
  if not literals[word] then
    decode_error(str, i, "invalid literal '" .. word .. "'")
  end
  return literal_map[word], x
end


local function parse_array(str, i)
  local res = {}
  local n = 1
  i = i + 1
  while 1 do
    local x
    i = next_char(str, i, space_chars, true)
    -- Empty / end of array?
    if str:sub(i, i) == "]" then
      i = i + 1
      break
    end
    -- Read token
    x, i = parse(str, i)
    res[n] = x
    n = n + 1
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "]" then break end
    if chr ~= "," then decode_error(str, i, "expected ']' or ','") end
  end
  return res, i
end


local function parse_object(str, i)
  local res = {}
  i = i + 1
  while 1 do
    local key, val
    i = next_char(str, i, space_chars, true)
    -- Empty / end of object?
    if str:sub(i, i) == "}" then
      i = i + 1
      break
    end
    -- Read key
    if str:sub(i, i) ~= '"' then
      decode_error(str, i, "expected string for key")
    end
    key, i = parse(str, i)
    -- Read ':' delimiter
    i = next_char(str, i, space_chars, true)
    if str:sub(i, i) ~= ":" then
      decode_error(str, i, "expected ':' after key")
    end
    i = next_char(str, i + 1, space_chars, true)
    -- Read value
    val, i = parse(str, i)
    -- Set
    res[key] = val
    -- Next token
    i = next_char(str, i, space_chars, true)
    local chr = str:sub(i, i)
    i = i + 1
    if chr == "}" then break end
    if chr ~= "," then decode_error(str, i, "expected '}' or ','") end
  end
  return res, i
end


local char_func_map = {
  [ '"' ] = parse_string,
  [ "0" ] = parse_number,
  [ "1" ] = parse_number,
  [ "2" ] = parse_number,
  [ "3" ] = parse_number,
  [ "4" ] = parse_number,
  [ "5" ] = parse_number,
  [ "6" ] = parse_number,
  [ "7" ] = parse_number,
  [ "8" ] = parse_number,
  [ "9" ] = parse_number,
  [ "-" ] = parse_number,
  [ "t" ] = parse_literal,
  [ "f" ] = parse_literal,
  [ "n" ] = parse_literal,
  [ "[" ] = parse_array,
  [ "{" ] = parse_object,
}


parse = function(str, idx)
  local chr = str:sub(idx, idx)
  local f = char_func_map[chr]
  if f then
    return f(str, idx)
  end
  decode_error(str, idx, "unexpected character '" .. chr .. "'")
end


function json.decode(str)
  if type(str) ~= "string" then
    error("expected argument of type string, got " .. type(str))
  end
  local res, idx = parse(str, next_char(str, 1, space_chars, true))
  idx = next_char(str, idx, space_chars, true)
  if idx <= #str then
    decode_error(str, idx, "trailing garbage")
  end
  return res
end



---------------------------------------------------
---------------------- Utils ----------------------
---------------------------------------------------



local insert, remove, sort = table.insert, table.remove, table.sort
local rndm, print = math.random, {}



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



local function getEffect(data)
  debug("a")
    local search = switch(type(data), {
        ["number"] = { id = data, name = "" },
        ["string"] = { id = 0, name = data },
        ["table"] = data,
    })

    return find(ID_WITH_CARAC_NAME, function(effect)
        return effect.Id == search.id
            or effect.Name == search.name
    end)
end



local ShopItem = {}




function GetDices(Id)
  debug("oui")
    local dices = {}
    local itemData = d2data:objectFromD2O("Items", Id)

    if not itemData then
        global:printError("erreur")

        return {}
    end
  debug("oui")

    itemData = itemData.Fields

    printVar(itemData.possibleEffects)

    for k, v in ipairs(itemData.possibleEffects) do
        debug(k)
        local data = v.Fields
        printVar(data)
                debug(k)
        local effect = getEffect(data.effectId)
        debug(k)

        if effect then
            effect = clone(effect)

            if not effect.name:find("Degats") and not effect.name:find("-") and not effect.name:find("chasse") then
                local diceSide = data.diceSide == 0
                    and data.diceNum
                    or data.diceSide

                effect.dice = {
                    min = data.diceNum,
                    max = diceSide 
                }

                table.insert(dices, effect)
            end
        end
    end

    return dices
end


function printVar(variable, name, indent)
  name = name or "Variable"
  indent = indent or ""
  if type(variable) == "table" then
      global:printSuccess(indent .. name .. " = {")
      for k, v in pairs(variable) do
          printVar(v, k, indent .. "  ")
      end
      global:printSuccess(indent .. "}")
  else
      global:printSuccess(indent .. name .. " = " .. tostring(variable))
  end
end

function IsItem(TypeId)
  if not TypeId then
      return false
  end
  local Ids = { 16, 17, 11, 10, 1, 9, 82, 151, 7, 19, 8, 6, 5, 2, 3, 4}
  for _, Id in ipairs(Ids) do
      if Id == TypeId then
          return true
      end
  end
  return false
end

function move()
    local stats = GetDices(8265)

    for _, element in ipairs(stats) do
        global:printSuccess(element.name .. " : " .. element.dice.max)
    end

    print:table(stats)

    local content = inventory:inventoryContent()
    for _, element in ipairs(content) do
      global:printSuccess(_)

        if element.objectGID == 12410 and IsItem(inventory:itemTypeId(element.objectGID)) then
          global:printSuccess(element.effects[1])
          print:table(element.effects)
          for _, x in ipairs(element.effects) do
              print:table(x)
          end
        end
    end

end


