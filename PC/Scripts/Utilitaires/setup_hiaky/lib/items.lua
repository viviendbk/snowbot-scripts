

Items = {}

local insert, remove, sort = table.insert, table.remove, table.sort

--- <messages>


function ObjectUseMultipleMessage(uid, qty)
    local message = developer:createMessage("ObjectUseMultipleMessage")
    message.quantity = qty
    message.objectUID = uid

    developer:sendMessage(message)
end

function ObjectSetPositionMessage(uid, position)
    local message = developer:createMessage("ObjectSetPositionMessage")
    message.objectUID = uid
    message.position = position
    message.quantity = 1

    developer:sendMessage(message)
end

function Items:setSkinID(skinID, hat)
    local message = developer:createMessage("LivingObjectChangeSkinRequestMessage")
    local pos = hat and 6 or 7

    for _, item in ipairs(inventory:inventoryContent()) do
        if item.position == pos then
            message.livingUID = item.objectUID
            message.livingPosition = item.position
            break
        end
    end
    message.skinId = skinID

    developer:sendMessage(message)
end

--- </messages>


--- <obj>


function Items:name(itemId)
    if inventory:itemNameId(itemId) then
        return inventory:itemNameId(itemId)
    end
end

function Items:findUID(itemID)
    for _, item in ipairs(inventory:inventoryContent()) do 
        if item.objectGID == itemID then
            return item.objectUID
        end
    end
end

function Items:getUIDsList(...)
	if type(...) == "number" then
		data = {...}
	elseif type(...) == "table" then
		data = ... 
	end

	local uids = {}
    for _, item in ipairs(inventory:inventoryContent()) do 
        if Utils:isInTable(data, item.objectUID) then
			insert(uids, item.objectUID)
        end
    end
	
	return uids
end

function Items:useAllofThisItem(itemID)
	local itemNbr = inventory:itemCount(itemID)
	if inventory:itemCount(itemID) > 0 then
        ObjectUseMultipleMessage(self:findUID(itemID), itemNbr)
    end
end

function Items:useMultipleItems(itemID, qty)
	if inventory:itemCount(itemID) > 0 then
        ObjectUseMultipleMessage(self:findUID(itemID), qty)
    end
end

function Items:openInvContainers()
    for _, item in ipairs(inventory:inventoryContent()) do
        if item.position == 63 and inventory:itemTypeId(item.objectGID) == 184 then
            self:useAllofThisItem(item.objectGID)
        end
    end
end

function Items:getAvlbPods()
    return inventory:podsMax() - inventory:pods()
end

function Items:isEquipment(itemID)
    local equipmentsTypeIds = {
        1,2,3,4,5,6,7,8,9,10,11,16,17,18,19,20,21,22,
        23,77,81,82,83,90,97,99,102,113,114,121,123,
        124,151,169,177,190,192,196,199,207,217,240
    }
    
    if Utils:isInTable(equipmentsTypeIds, inventory:itemTypeId(itemID)) then
        return true
    end
end

function Items:isWeapon(itemID)
    local weap = {2, 3, 4, 5, 22, 19, 7, 20, 8, 83, 21}

    if Utils:isInTable(weap, inventory:itemTypeId(itemID)) then
        return true
    end
end

function Items:deleteAllEquipments()
    for index, item in ipairs(inventory:inventoryContent()) do
        if self:isEquipment(item.objectGID) and item.position == 63 then
            inventory:deleteItem(item.objectGID, item.quantity)
        end
    end
end

function Items:equipItem(itemID, acc)
    local stuffPosEnum = {
        [1] = 0,   -- amulette
        [9] = 2,   -- anneau (4 == right) 
        [17] = 7,  -- cape
        [16] = 6,  -- coiffe
        [10] = 3,  -- ceinture
        [11] = 5,  -- bottes
        [18] = 8,  -- familier
        [121] = 8, -- montilier
    }

    if not self:isEquipment(itemID) then
        print:error("Impossible d'équiper " .. inventory:itemNameId(itemID) .. ", ce n'est pas un équipement")
        return
    end

    local accInventory = acc and acc.inventory or inventory
    local pos = self:isWeapon(itemID) and 1 or stuffPosEnum[inventory:itemTypeId(itemID)]
    local result = accInventory:equipItem(itemID, pos)

    if verbose then
        if result then
            global:printuccess("[SUCCESS] : Equipement de " .. inventory:itemNameId(itemID) .. " réussi")
        else
            print:errorInfo("Impossible d'équiper " .. inventory:itemNameId(itemID))
        end
    end

    return result
end

function Items:getStorageElement(search, stor)
    stor = stor or self.bank
    search = type(search) == "table" or { objectGID = search  }

    local found = Utils:find(stor, function(element)
        for key, value in pairs(search) do
            if element[key] == value then
                return true
            end
        end
    end)

    return found
end

function Items:printNameWithOrnament(itemID)
    local lettersCount = 0
    local ornamentedName = inventory:itemNameId(itemID)
    local ornament = ""

    for i = 1, #ornamentedName + 4 do
        ornament = ornament .. "--"
    end

    local spaceNbr = #ornament - #ornamentedName
    
    local space = ""
    for i = 1, math.floor(spaceNbr / 3) do
        space = space .. " "
    end
    ornamentedName = space .. ornamentedName .. space

    print:success(ornament)
    print:success(ornamentedName)
    print:success(ornament)
    print:void(" ")
end

function Items:getEmptyStorageElement(itemID)
    return itemID and {
        objectGID = itemID,
        objectUID = 0,
        quantity = 0
    } or nil
end


-- function name(itemID)
--     return inventory:itemNameId(itemID) or "unknown"
-- end

--- </obj>
