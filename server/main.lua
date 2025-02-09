

local function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function roundToInteger(num)
    return math.floor(num + 0.5)
end



RegisterNetEvent("brinley-fishing:collectFishingCatch", function()
    local src = source
    local Player = GetPlayer(src)

    local bait = Config.baitItem
    local info = {}

    -- Define fish list
    math.randomseed(os.time())

    local fishList = Config.fishLists

    local fishWeights = {}
    local totalWeight = 0

    local function calculateWeight(price, lengthRange)
        local priceExponent = 1.5
        local baseWeight = lengthRange * math.pow(price, -priceExponent)
        return math.max(baseWeight, 0.1)
    end
    
    local function weightedRandomSelection(weights)
        local rand = math.random() * totalWeight
        local sum = 0
        for _, w in ipairs(weights) do
            sum = sum + w.weight
            if rand <= sum then
                return w.fish
            end
        end
    end

    for _, fish in ipairs(fishList) do
        local lengthRange = fish.maxLength - fish.minLength
        lengthRange = math.max(lengthRange, 0)

        local priceAverage = (fish.minPrice + fish.maxPrice) / 2

        local weight = calculateWeight(priceAverage, lengthRange)
        weight = weight * (1 + math.random() * 0.2) 

        table.insert(fishWeights, { fish = fish, weight = weight })
        totalWeight = totalWeight + weight
    end 

    local selectedFish = weightedRandomSelection(fishWeights)
    
    if selectedFish then
        local lengthRange = selectedFish.maxLength - selectedFish.minLength
        local randomFactor = math.random()
        local skewedFactor = (randomFactor ^ 2) 
        local length = selectedFish.minLength + (lengthRange * skewedFactor)

        local priceRange = selectedFish.maxPrice - selectedFish.minPrice
        local lengthRatio = (length - selectedFish.minLength) / lengthRange
        local price = selectedFish.minPrice + (priceRange * lengthRatio)

        length = round(length, 2)
        price = round(price, 2) 

        --print(selectedFish.name .. " - Price: $" .. tostring(price) .. " - Length: ".. tostring(length))

        local info = {
            length = length,
            price = price 
        }

        -- Remove bait with a 60% chance
        local result = GetItembyName(bait, Player)
        if result then
            local chance = math.random()
            if chance <= 0.60 then
                ItemManager(bait, 1, "remove", Player)
            end
            ItemManager(selectedFish.name, 1, "add", Player, info)
        
            local playerName = GetPlayerCharName(src)
            local caughtAt = os.date("%Y-%m-%d %H:%M:%S")
            TriggerEvent("brinley-fishing:server:updateLeaderboard", selectedFish.name, length, playerName, caughtAt)
            Notify(src, "You catched a "..selectedFish.name.."!", "success")
        else
            Notify(src, "Fish escaped since you had no bait...", "error")
        end
    end
end)

RegisterNetEvent("brinley-fishing:sellFishes")
AddEventHandler("brinley-fishing:sellFishes", function()
    local src = source
    local Player = GetPlayer(src)
    local totalValue = 0

    local inventory
    if Config.Framework == 'QBCore' then
        inventory = Player.PlayerData.items
    elseif Config.Framework == 'ESX' then
        inventory = Player.inventory
    end

    for slot, itemData in pairs(inventory) do
        if itemData and itemData.name then
            local itemName = itemData.name:lower()
            for _, fish in ipairs(Config.fishLists) do
                if itemName == fish.name then
                    
                    local price = itemData.info.price or 0
                    local length = itemData.info.length or 1

                    local roundedPrice = round(price, 2)
                    
                    --print(itemName .. " - Price: $" .. tostring(roundedPrice) .. " - Length: ".. tostring(length))
                    
                    local value = roundedPrice * itemData.amount
                    totalValue = totalValue + value

                    ItemManager(itemName, itemData.amount, "remove", Player)
                    break
                end
            end
        end
    end

    totalValue = roundToInteger(totalValue)
    
    if totalValue > 0 then
        if Config.Framework == 'QBCore' then
            Player.Functions.AddMoney("cash", totalValue)
        elseif Config.Framework == 'ESX' then
            Player.addMoney(totalValue)
        end
    end
end)