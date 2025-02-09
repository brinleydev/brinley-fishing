RegisterNetEvent("brinley-fishing:server:updateLeaderboard")
AddEventHandler("brinley-fishing:server:updateLeaderboard", function(fishName, fishLength, playerName, caughtAt)

    local query = [[
        INSERT INTO pyhfish_leaderboard (fish_name, fish_length, player_name, caught_at)
        VALUES (?, ?, ?, ?)
    ]]
    local result = MySQL.query.await(query, {fishName, fishLength, playerName, caughtAt})

end)

RegisterCallback("brinley-fishing:server:getLeaderboard", function(source, cb, fishName)
    local query = [[
        SELECT * FROM pyhfish_leaderboard
        WHERE fish_name = ?
        ORDER BY fish_length DESC
        LIMIT 10
    ]]
    local result = MySQL.query.await(query, {fishName})
    
    if result then
        for _, entry in ipairs(result) do
            entry.caught_at = formatTimestamp(entry.caught_at)
        end
        cb(result)
    else
        cb(nil)
    end
end)

function formatTimestamp(timestamp)

    local timestampUnix
    if type(timestamp) == "string" then
        local year, month, day, hour, min, sec = timestamp:match("(%d+)%-(%d+)%-(%d+) (%d+):(%d+):(%d+)")
        if year and month and day and hour and min and sec then

            local timeTable = {
                year = year,
                month = month,
                day = day,
                hour = hour,
                min = min,
                sec = sec
            }
            timestampUnix = os.time(timeTable)
        else
            return "Invalid timestamp"
        end
    elseif type(timestamp) == "number" then
        timestampUnix = timestamp / 1000

    else
        return "Invalid timestamp"
    end

    local diff = os.time() - timestampUnix

    local days = math.floor(diff / 86400)
    local hours = math.floor((diff % 86400) / 3600)
    local minutes = math.floor((diff % 3600) / 60)

    if days > 0 then
        return days .. " days ago"
    elseif hours > 0 then
        return hours .. " hours ago"
    elseif minutes > 0 then
        return minutes .. " minutes ago"
    else
        return "just now"
    end
end