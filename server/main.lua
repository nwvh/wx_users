ESX = exports["es_extended"]:getSharedObject()

RegisterCommand(Config.Command, function(source,args)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        local isAllowed = false
        for _,group in pairs(Config.AllowedGroups) do
            if group == xPlayer.getGroup() then
                isAllowed = true
                break
            end
        end

        if isAllowed then
            TriggerClientEvent('wx_users:showPlayers',source)
        end
    end
end)
