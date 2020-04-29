-- Configuration
Ace = {
    Warning = "warning",
    Kick = "kick",
    Ban = "ban",
    Report = "report",
    God = "admin"
}


RegisterServerEvent("tadmin:warning")
AddEventHandler("tadmin:warning", function(args) 
    local adminSRC = source
    local victimSRC = args[1]
    local reason = args[2]

    if(allowed(adminSRC, "warning") and not allowed(victimSRC, "warning")) then
        local adminSteam = GetSteamId(adminSRC)
        local victimSteam = GetSteamId(victimSRC)

        if(reason == nil or reason == "") then
            reason = "No reason"
        end

        if(adminSteam == nil or victimSteam == nil) then
            print("Steam is not connected so couldn't do a warning")
        end

        MySQL.Sync.execute("INSERT INTO `taz-log` (userID, modID, action, reason) VALUES (@warned, @admin, 'warning', @reason)", {
            ["@warned"] = victimSteam,
            ["@admin"] = adminSteam,
            ['@reason'] = reason
        })

        msg(adminSRC, "~g~User has been warned")
        msg(victimSRC, "~r~You are warned for: " .. reason)
    else
        if(allowed(victimSRC, "warning")) then
            msg(source, "~r~Other user has the same/more permission")
        else
            msg(source, "~r~User doesn't have access")
        end
    end
end)

RegisterServerEvent("tadmin:kick")
AddEventHandler("tadmin:kick", function(args) 
    local action = "kick"
    local adminSRC = source
    local victimSRC = args[1]
    local reason = joinTable(args, " ", 1)

    if(allowed(adminSRC, action) and not allowed(victimSRC, action)) then
        local adminSteam = GetSteamId(adminSRC)
        local victimSteam = GetSteamId(victimSRC)

        if(reason == nil or reason == "") then
            reason = "No reason"
        end

        if(adminSteam == nil or victimSteam == nil) then
            print("Steam is not connected so couldn't do a warning")
        end

        MySQL.Sync.execute("INSERT INTO `taz-log` (userID, modID, action, reason) VALUES (@warned, @admin, 'kick', @reason)", {
            ["@warned"] = victimSteam,
            ["@admin"] = adminSteam,
            ['@reason'] = reason
        })

        DropPlayer(victimSRC, reason)

        msg(adminSRC, "~g~User has been kicked")
    else
        if(allowed(victimSRC, "warning")) then
            msg(source, "~r~Other user has the same/more permission")
        else
            msg(source, "~r~You doesn't have access")
        end
    end

end)

RegisterServerEvent("tadmin:ban")
AddEventHandler("tadmin:ban", function() 

end)

RegisterServerEvent("tadmin:report")
AddEventHandler("tadmin:report", function() 

end)

function msg(src, message) 
    TriggerClientEvent('Notify', src, message)
end

function allowed(src, action)
    if(IsPlayerAceAllowed(src, "taz." .. Ace[(action:gsub("^%l", string.upper))]) or IsPlayerAceAllowed(src, "taz." .. Ace["God"])) then
        return true
    else
        return false
    end
end

function joinTable(tbl, join, start)
    if(start == nil) then start = 0 end
    if(join == nil) then join = " " end

    for i=1, start do
        table.remove(tbl, i)
    end

    local str = ""

    for k,v in ipairs(tbl) do
        str = str .. tostring(v) .. join
    end

    return str
end

-- https://forum.cfx.re/t/converting-steam-identifier-to-retrieve-profile/240602/2?u=tazio
function GetSteamId(source)
    local steamHex = nil
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in next, identifiers do
        if string.find(identifier, "steam:") then
            steamHex = identifier
            break
        end
    end
    if not steamHex then
        return nil
    end
    if not string.find(steamHex, "steam:") then
        return nil
    end
    local steamId = tonumber(string.gsub(steamHex,"steam:", ""),16)
    if not steamId then
        return nil
    end
    return steamId
end
