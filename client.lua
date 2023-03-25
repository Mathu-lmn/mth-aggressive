local AGGRESSIVE_GROUP = "AGGRESSIVE"
local amount = 1
local range = 25

AddRelationshipGroup(AGGRESSIVE_GROUP)
local models = {
    "a_m_m_acult_01",
    "a_m_m_beach_01",
    "a_m_m_fatlatin_01",
    "a_m_m_hasjew_01",
    "a_m_m_ktown_01",
    "a_m_m_paparazzi_01",
    "a_m_y_skater_01",
}

local weapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_PISTOL50",
    "WEAPON_SNSPISTOL",
    "WEAPON_HEAVYPISTOL",
    "WEAPON_VINTAGEPISTOL",
    "WEAPON_PISTOL_MK2",
    "WEAPON_SNSPISTOL_MK2",
}

local peds = {}

function spawnAggressivePeds(amount)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for i = 1, amount do
        local model = models[math.random(#models)]
        local x = playerCoords.x + math.random(-range, range)
        local y = playerCoords.y + math.random(-range, range)
        local z = playerCoords.z

        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        local ped = CreatePed(4, model, x, y, z, 0.0, true, false)
        SetPedCombatAttributes(ped, 46, 1)
        SetPedFleeAttributes(ped, 0, 0)
        SetPedCombatRange(ped, 2)
        SetPedRelationshipGroupHash(ped, GetHashKey(AGGRESSIVE_GROUP))
        SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey(AGGRESSIVE_GROUP))
        SetRelationshipBetweenGroups(5, GetHashKey(AGGRESSIVE_GROUP), GetHashKey("PLAYER"))
        TaskCombatPed(ped, playerPed, 0, 16)
        SetPedKeepTask(ped, true)
        SetPedHasAiBlip(ped, true)
        SetPedAiBlipHasCone(ped, false)
        GiveWeaponToPed(ped, GetHashKey(weapons[math.random(#weapons)]), 999, false, true)
        SetModelAsNoLongerNeeded(model)

        table.insert(peds, ped)
    end

    showNotification("Aggressive ped(s) spawned.")
end

function deleteAggressivePeds()
    for i = #peds, 1, -1 do
        local ped = peds[i]
        if DoesEntityExist(ped) then
            DeletePed(ped)
        end
        table.remove(peds, i)
    end

    showNotification("Aggressive ped(s) deleted.")
end

AddEventHandler('playerSpawned', function()
    AddRelationshipGroup(AGGRESSIVE_GROUP)
end)

------------------------
------ Menu Stuff ------
------------------------

local main_menu = RageUI.CreateMenu("Aggressive Peds", "Spawn aggressive peds")
local settings_menu = RageUI.CreateSubMenu(main_menu, "Aggressive Peds", "Spawn aggressive peds")

local visualizer = false
local open = false
main_menu.Closed = function()
    open = false
end

RegisterCommand("aggressive", function(source, args)
    openMenu()
end, false)

function openMenu()
    if open then
        open = false
        RageUI.Visible(main_menu, false)
        return
    else
        open = true
        RageUI.Visible(main_menu, true)
        Citizen.CreateThread(function()
            while open do
                RageUI.IsVisible(main_menu, function()
                    RageUI.Button("Spawn", "Spawns aggressive peds", {RightLabel = "~g~→→"}, true, {
                        onSelected = function()
                            TriggerServerEvent("aggressiveCommand", amount)
                        end
                    })

                    RageUI.Button("Delete", "Deletes all the peds spawned by the /aggressive command", {RightLabel = "~g~→→"}, true, {
                        onSelected = function()
                            deleteAggressivePeds()
                        end
                    })

                    RageUI.Button("Settings", "Change the settings", {RightLabel = "~g~→→"}, true, {}, settings_menu)
                end)

                RageUI.IsVisible(settings_menu, function()
                    RageUI.Button("Amount", "Change the amount of peds to spawn", {RightLabel = amount}, true, {
                        onSelected = function()
                            local temp = KeyboardInput("Enter the amount")
                            if temp then
                                amount = tonumber(temp)
                            end
                        end
                    }, settings_menu)

                    RageUI.Button("Range", "Change the range", {RightLabel = range}, true, {
                        onSelected = function()
                            local temp = KeyboardInput("Enter the range")
                            if temp then
                                range = tonumber(temp)
                            end
                        end
                    }, settings_menu)

                    RageUI.Checkbox("Visualizer", "Toggle the range visualizer", visualizer, {Style = RageUI.CheckboxStyle.Tick}, {
                        onChecked = function()
                            visualizer = true
                        end,
                        onUnChecked = function()
                            visualizer = false
                        end
                    })
                end)
                -- I want the range visualizer to be a circle around the player
                if visualizer then
                    DrawMarker(1, GetEntityCoords(PlayerPedId()) + vector3(0, 0, -1.2), 0.0, 0.0, 0.0, 0, 0.0, 0.0, range + 0.0, range + 0.0, 1000000.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
                end

                Wait(0)
            end
        end)
    end
end


RegisterNetEvent("aggressiveCommand")
AddEventHandler("aggressiveCommand", function(amount)
    spawnAggressivePeds(amount)
end)

RegisterNetEvent("mth-aggressive:showNotification")
AddEventHandler("mth-aggressive:showNotification", function(text)
    showNotification(text)
end)

function showNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function KeyboardInput(text)
	local result = nil
	AddTextEntry("CUSTOM_AMOUNT", text)
	DisplayOnscreenKeyboard(1, "CUSTOM_AMOUNT", '', "", '', '', '', 255)
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Wait(1)
	end
	if UpdateOnscreenKeyboard() ~= 2 then
		result = GetOnscreenKeyboardResult()
		Citizen.Wait(1)
	else
		Citizen.Wait(1)
	end
	return result
end