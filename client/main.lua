local canFish = false
local isFishing = false
local fishingRod

local fishAnimation = function()
    local ped = PlayerPedId()
    RequestAnimDict('mini@tennis')
    while not HasAnimDictLoaded('mini@tennis') do Wait(0) end
    TaskPlayAnim(ped, 'mini@tennis', 'forehand_ts_md_far', 1.0, -1.0, 1.0, 48, 0, 0, 0, 0)
    while IsEntityPlayingAnim(ped, 'mini@tennis', 'forehand_ts_md_far', 3) do Wait(0) end

    -- Fish Animation
    RequestAnimDict('amb@world_human_stand_fishing@idle_a')
    while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do Wait(0) end
    TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 10, 0, 0, 0, 0)
    
    
    ProgBar("wait_bit", "Waiting for a bite...", math.random(10, 20) * 1000, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, function() -- Done
        TaskPlayAnim(ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 1.0, -1.0, 1.0, 10, 0, 0, 0, 0)
        exports['brinley-fishing']:StartMinigame(35, 7000, 5000, function(success)
            if success then
                TriggerServerEvent("brinley-fishing:collectFishingCatch")
            else
                Notify("You failed to catch the fish. Get Better!")
            end
    
            ClearPedTasks(ped)
            DeleteObject(fishingRod)
            isFishing = false
        end) 
    end, function()
        ClearPedTasks(ped)
        DeleteObject(fishingRod)
        isFishing = false
    end) 
end

local startFishing = function()
    if isFishing then return end
    isFishing = true

    local fishingRodHash = `prop_fishing_rod_01`
    if not IsModelValid(fishingRodHash) then return end
    if not HasModelLoaded(fishingRodHash) then RequestModel(fishingRodHash) end
    while not HasModelLoaded do Wait(0) end

    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped)
    local object = CreateObject(fishingRodHash, pedCoords, true, false, false)
    AttachEntityToEntity(object, ped, GetPedBoneIndex(ped, 18905), 0.1, 0.05, 0, 80.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(object)
    fishingRod = object
    fishAnimation()
end

RegisterNetEvent("brinley-fishing:startMami", function()
    local playerPed = PlayerPedId()
	local pos = GetEntityCoords(playerPed) 
	if IsPedSwimming(playerPed) then return Notify("You can't be swimming and fishing at the same time.", "error") end 
	if IsPedInAnyVehicle(playerPed) then return Notify("You need to exit your vehicle to start fishing.", "error") end 
	if GetWaterHeight(pos.x, pos.y, pos.z - 1, pos.z - 3.0)  then
		startFishing()
	else
		Notify('You need to get close to the shore', 'error')
	end
end)


local boat = nil -- Track the boat entity

local function GiveBoatBack()
    while true do
        local ms = 1000
        local ped = PlayerPedId()
        local PedCoord = GetEntityCoords(ped)
        local dist = #(vector3(Config.BoatCoords.x, Config.BoatCoords.y, Config.BoatCoords.z) - PedCoord)
        
        if dist < 10.0 then
            ms = 0
            -- Show the info if the player is near the "give back boat" coordinates
            TriggerEvent('pa-lib:openinfo', 'Fishing', 'Press E to Give back boat')
            
            -- Check if the player presses E
            if IsControlJustPressed(0, 38) then
                -- Close the pa-lib info
                TriggerEvent('pa-lib:closeinfo')
                
                -- Delete the boat and reset the player's position
                SetEntityAsMissionEntity(boat, true, true)
                DeleteVehicle(boat)
                SetEntityCoords(ped, Config.Spawn.x, Config.Spawn.y, Config.Spawn.z)
                boat = nil
                break
            end
        else
            -- Show the info if the player is not near the "give back boat" coordinates
            TriggerEvent('pa-lib:openinfo', 'Fishing', 'Go out with a boat to catch fish and sell them')
        end
        
        Wait(ms)
    end
end

local function Rent()
    -- Load the boat model
    RequestModel(Config.Boat)
    while not HasModelLoaded(Config.Boat) do
        Wait(0)
    end

    -- Spawn the boat
    boat = CreateVehicle(Config.Boat, vector4(Config.BoatCoords.x, Config.BoatCoords.y, Config.BoatCoords.z, Config.BoatCoords.w), true, false)
    SetModelAsNoLongerNeeded(Config.Boat)
    SetVehicleFixed(boat)
    local plate = GetVehicleNumberPlateText(boat)
    SetVehicleHasBeenOwnedByPlayer(boat, true)
    local id = NetworkGetNetworkIdFromEntity(boat)
    SetNetworkIdCanMigrate(id, true)
    Citizen.InvokeNative(0x629BFA74418D6239, Citizen.PointerValueIntInitialized(boat))
    TaskWarpPedIntoVehicle(PlayerPedId(), boat, -1)
    TriggerEvent('vehiclekeys:client:SetOwner', plate)

    -- Show the initial info message
    if Config.NotifyType == 'pa' then
        TriggerEvent('pa-lib:openinfo', 'Fishing', 'Go out with a boat to catch fish and sell them')
    end

    -- Start the proximity check for giving back the boat
    GiveBoatBack()
end

-- Register the event to rent the boat
RegisterNetEvent('mp-fishing:rentboat', Rent)

--[[ 

--[[ 

RegisterCommand('demoFish', function()
    TriggerEvent("brinley-fishing:startMami")
end, false)

RegisterCommand('testFish', function()
    TriggerServerEvent("brinley-fishing:collectFishingCatch")
end, false)

RegisterCommand('sellFish', function()
    TriggerServerEvent("brinley-fishing:sellFishes")
end, false) 

]]
