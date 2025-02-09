if Config.Framework == 'QBCore' then
    pyh = exports[Config.FrameworkFolder]:GetCoreObject()
else
    pyh = exports[Config.FrameworkFolder]:getSharedObject()
end

--[[ currentRep = 0

function Rep()
    local p = promise.new()
    if Config.Framework == 'QBCore'then
        pyh.Functions.TriggerCallback('brinley-contacts:getRep', function(result)
            p:resolve(result)    
        end, "Fishing") 
    else
        pyh.TriggerServerCallback('brinley-contacts:getRep', function(result)
            p:resolve(result)    
        end, "Fishing") 
    end
    return Citizen.Await(p)
end ]]

function Notify(msg, typ)
    if Config.Framework == 'QBCore' then
        pyh.Functions.Notify(msg, typ)
    else
        pyh.ShowHelpNotification(msg)
    end
end

function TriggerCallback(name, cb, ...)
    if Config.Framework == 'QBCore' then
        pyh.Functions.TriggerCallback(name, cb, ...)
    else
        pyh.TriggerServerCallback(name, cb, ...)
    end
end

function ProgBar(name, label, duration, disableOptions, animOptions, onFinish, onCancel)
    if Config.Framework == 'QBCore' then
        pyh.Functions.Progressbar(name, label, duration, false, true, disableOptions, animOptions, {}, {}, onFinish, onCancel)
    else
        exports["esx_progressbar"]:Progressbar(name, duration, {
            FreezePlayer = disableOptions.disableMovement,
            animation = {
                type = "anim",
                dict = animOptions.animDict,
                lib = animOptions.anim
            },
            onFinish = onFinish,
            onCancel = onCancel
        })
    end
end
