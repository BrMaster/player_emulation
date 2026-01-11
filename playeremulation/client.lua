local emulatedPed = nil
local isInvincible = true
local modelHash = GetHashKey('a_m_m_skater_01')
local showHp = false
local currentTask = "None"
local canRagdoll = false
local MAX_HEALTH = 200

-- Function to draw 3D text
function DrawText3D(x, y, z, text, r, g, b)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(r or 255, g or 255, b or 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Thread to display HP
Citizen.CreateThread(function()
    while true do
        if showHp and emulatedPed and DoesEntityExist(emulatedPed) then
            local coords = GetEntityCoords(emulatedPed)
            local health = GetEntityHealth(emulatedPed)
            local healthRatio = math.max(0, math.min(1, health / MAX_HEALTH))
            local r = math.floor(255 * (1 - healthRatio))
            local g = math.floor(255 * healthRatio)
            DrawText3D(coords.x, coords.y, coords.z + 1.0, tostring(health), r, g, 0)
            DrawText3D(coords.x, coords.y, coords.z + 1.2, currentTask, 255, 255, 255)
        end
        Citizen.Wait(100)
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() and emulatedPed and DoesEntityExist(emulatedPed) then
        DeletePed(emulatedPed)
        emulatedPed = nil
    end
end)

-- Command to spawn the emulated player
RegisterCommand('emuspawn', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        DeletePed(emulatedPed)
    end
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(10)
    end
    emulatedPed = CreatePed(4, modelHash, coords.x + 2.0, coords.y, coords.z, 0.0, true, false)
    SetModelAsNoLongerNeeded(modelHash)
    GiveWeaponToPed(emulatedPed, GetHashKey('weapon_pistol'), 100, false, true)
    SetEntityInvincible(emulatedPed, isInvincible)
    SetBlockingOfNonTemporaryEvents(emulatedPed, true)
    SetPedCanRagdoll(emulatedPed, canRagdoll) -- Prevent ragdoll initially
    ClearPedTasks(emulatedPed)
    TaskStandStill(emulatedPed, -1)
    currentTask = "Standing still"
end, false)

-- Command to make the emulated player walk to you
RegisterCommand('emuwalktome', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        local playerPed = PlayerPedId()
        TaskGoToEntity(emulatedPed, playerPed, -1, 1.0, 1.0, 0, 0)
        currentTask = "Walking to you"
    end
end, false)

-- Command to make the emulated player shoot at you
RegisterCommand('emushootatme', function(source, args, raw)
    if emulatedPed and DoesEntityExist(emulatedPed) then
        local weaponName = args[1] or 'WEAPON_PISTOL'
        local weaponHash = GetHashKey(weaponName)
        GiveWeaponToPed(emulatedPed, weaponHash, 1000, false, true)
        SetCurrentPedWeapon(emulatedPed, weaponHash, true)
        local playerPed = PlayerPedId()
        TaskShootAtEntity(emulatedPed, playerPed, -1, 'FIRING_PATTERN_FULL_AUTO')
        currentTask = "Shooting at you"
    end
end, false)

-- Command to make the emulated player get in your car
RegisterCommand('emugetincar', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle and IsVehicleSeatFree(vehicle, 0) then
            TaskEnterVehicle(emulatedPed, vehicle, -1, 0, 1.0, 1, 0)
            currentTask = "Entering vehicle"
        end
    end
end, false)

-- Command to teleport the emulated player to you
RegisterCommand('emutphere', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        SetEntityCoords(emulatedPed, coords.x, coords.y, coords.z, false, false, false, false)
        currentTask = "Teleporting"
    end
end, false)

-- Command to stop the emulated player
RegisterCommand('emustop', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        ClearPedTasks(emulatedPed)
        TaskStandStill(emulatedPed, -1)
        currentTask = "Standing still"
    end
end, false)

-- Command to toggle invincibility of the emulated player
RegisterCommand('emuinvicible', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        isInvincible = not isInvincible
        SetEntityInvincible(emulatedPed, isInvincible)
        TriggerEvent('chat:addMessage', {
            args = {'^2Emulated player invincibility: ' .. (isInvincible and 'ON' or 'OFF')}
        })
    end
end, false)

-- Command to make the emulated player leave the car
RegisterCommand('emuleavecar', function()
    if emulatedPed and DoesEntityExist(emulatedPed) and IsPedInAnyVehicle(emulatedPed, false) then
        TaskLeaveVehicle(emulatedPed, GetVehiclePedIsIn(emulatedPed, false), 0)
        currentTask = "Exiting vehicle"
    end
end, false)

-- Command to make the emulated player follow you
RegisterCommand('emufollowme', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        local playerPed = PlayerPedId()
        TaskFollowToOffsetOfEntity(emulatedPed, playerPed, 0.0, 0.0, 0.0, 1.0, -1, 1.0, true)
        currentTask = "Following you"
    end
end, false)

-- Command to delete the emulated player
RegisterCommand('emudelete', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        DeletePed(emulatedPed)
        emulatedPed = nil
        currentTask = "None"
    end
end, false)

-- Command to make the emulated player attack you with melee
RegisterCommand('emumeleeme', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        RemoveAllPedWeapons(emulatedPed, true)
        local playerPed = PlayerPedId()
        TaskCombatPed(emulatedPed, playerPed, 0, 16)
        currentTask = "Attacking you (melee)"
    end
end, false)

-- Command to set the emulated player's health
RegisterCommand('emusethealth', function(source, args, raw)
    if emulatedPed and DoesEntityExist(emulatedPed) and args[1] then
        local health = tonumber(args[1])
        if health then
            SetEntityHealth(emulatedPed, health)
        end
    end
end, false)

-- Command to heal the emulated player
RegisterCommand('emuheal', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        SetEntityHealth(emulatedPed, 200)
    end
end, false)

-- Command to toggle HP display above the emulated player
RegisterCommand('emuinfoshow', function()
    showHp = not showHp
    TriggerEvent('chat:addMessage', {
        args = {'^2HP display: ' .. (showHp and 'ON' or 'OFF')}
    })
end, false)

-- Command to toggle ragdoll for the emulated player
RegisterCommand('emuragdoll', function()
    if emulatedPed and DoesEntityExist(emulatedPed) then
        canRagdoll = not canRagdoll
        SetPedCanRagdoll(emulatedPed, canRagdoll)
        TriggerEvent('chat:addMessage', {
            args = {'^2Ragdoll allowed: ' .. (canRagdoll and 'ON' or 'OFF')}
        })
    end
end, false)

-- Print commands to console on script start
Citizen.CreateThread(function()
    Citizen.Wait(1000) -- Wait 1 second after load
    print("^2=====================================")
    print("^3   Player Emulation Commands Loaded")
    print("^2=====================================")
    print("^6/emuspawn^7 - Spawn the emulated player near you")
    print("^6/emuwalktome^7 - Make the ped walk to your location")
    print("^6/emushootatme [weapon]^7 - Make the ped shoot at you (optional weapon)")
    print("^6/emugetincar^7 - Make the ped enter your vehicle")
    print("^6/emutphere^7 - Teleport the ped to your location")
    print("^6/emustop^7 - Stop current task and make ped stand still")
    print("^6/emuinvicible^7 - Toggle ped's invincibility")
    print("^6/emuleavecar^7 - Make the ped exit the vehicle")
    print("^6/emufollowme^7 - Make the ped follow you continuously")
    print("^6/emudelete^7 - Permanently delete the emulated ped")
    print("^6/emumeleeme^7 - Make the ped attack you with melee")
    print("^6/emusethealth <amount>^7 - Set the ped's health to a specific value")
    print("^6/emuheal^7 - Restore the ped's health to full (200)")
    print("^6/emuinfoshow^7 - Toggle HP and task display above the ped")
    print("^6/emuragdoll^7 - Toggle whether the ped can ragdoll")
    print("^2=====================================")
    print("^5Use these commands to control the emulated player for testing!")
    print("^2=====================================")
end)