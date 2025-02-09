RegisterNetEvent("brinley-fishing:showLeaderboard", function(data, cb)

    local fishNames = {}
    for _, fish in ipairs(Config.fishLists) do
        table.insert(fishNames, fish.name)
    end

    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "showLeaderboard",
        fishList = fishNames
    })
    --[[ cb("ok") ]]
end)


RegisterNUICallback("hideMenu", function(data, cb)

    SetNuiFocus(false, false)

end)

RegisterNUICallback("fetchLeaderboard", function(data, cb)
    local fishName = data.fishName

    TriggerCallback("brinley-fishing:server:getLeaderboard", function(result)
        if result then
            SendNUIMessage({
                type = "updateLeaderboard",
                leaderboard = result
            })
        else
            SendNUIMessage({
                type = "updateLeaderboard",
                leaderboard = {}
            })
        end
    end, fishName)
end)

--[[ RegisterCommand("openLeaderboard", function()
    TriggerEvent("brinley-fishing:showLeaderboard")
end) ]]
