
local insert, remove, sort = table.insert, table.remove, table.sort

--- <Misc>

Misc = {}


function ExchangeHandleMountsMessage(actType, mountId)
    local message = developer:createMessage("ExchangeHandleMountsMessage")
    message.actionType = actType
    message.ridesId = mountId
    developer:sendMessage(message)
end

function Misc:equipMountFromInv(mountUID)
	ExchangeHandleMountsMessage(15, {mountUID})
end

--- </Misc>