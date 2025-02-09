local minigameCallback = nil

function StartMinigame(playerInfluence, automaticSpeed, directionChangeInterval)
    SendNUIMessage({
        type = 'startMinigame',
        playerInfluence = playerInfluence,
        automaticSpeed = automaticSpeed,
        directionChangeInterval = directionChangeInterval
    })
    SetNuiFocus(true, true)
end

function StopMinigame()
    SendNUIMessage({ type = 'stopMinigame' })
    SetNuiFocus(false, false)
end

RegisterNUICallback('minigameResult', function(data, cb)
    local success = data.success
    cb({ closeUI = true })
    StopMinigame()
    minigameCallback(success)
    minigameCallback = nil
end)

exports('StartMinigame', function(playerInfluence, automaticSpeed, directionChangeInterval, callback)
    minigameCallback = callback
    StartMinigame(playerInfluence, automaticSpeed, directionChangeInterval)
end)
