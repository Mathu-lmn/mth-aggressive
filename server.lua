local cooldowns = {}

RegisterNetEvent("aggressiveCommand")
AddEventHandler("aggressiveCommand", function(amount)
    if tonumber(amount) > Config.MaxPeds then
        TriggerClientEvent('mth-aggressive:showNotification', source, "You can only spawn up to " .. Config.MaxPeds .. " peds.")
        return
    elseif cooldowns[source] then              -- if the player is on cooldown, notify him
        TriggerClientEvent('mth-aggressive:showNotification', source,
        "You can only spawn peds once every " .. Config.Cooldown .. " seconds. (" .. cooldowns[source] .. " seconds left)")
    else
        TriggerClientEvent('aggressiveCommand', source, amount)
        cooldowns[source] = tonumber(Config.Cooldown) -- set the cooldown
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k, v in pairs(cooldowns) do
            if v > 0 then
                cooldowns[k] = v - 1
            else --remove the player from table if the cooldown is over
                cooldowns[k] = nil
            end
        end
    end
end)