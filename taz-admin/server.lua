-- Configuration
Ace = {
    Warning = "warning",
    Kick = "kick",
    Ban = "ban",
    Report = "report",
    Admin = "admin",
    Blacklist = "blacklist",
    God = "admin"
}


RegisterServerEvent("tadmin:warning")
AddEventHandler("tadmin:warning", function(args) 
    local adminSRC = source
    local victimSRC = args[1]
    local reason = args[2]

    if(allowed(adminSRC, "warning") --[[and not allowed(victimSRC, "warning")]] and online(victimSRC)) then
        local adminSteam = GetSteamId(adminSRC)
        local victimSteam = GetSteamId(victimSRC)

        if(reason == nil or reason == "") then
            reason = "No reason"
        end

        if(adminSteam == nil or victimSteam == nil) then
            return msg(adminSRC, "~r~Steam is not connected")
        end


        total = moderate("warning", victimSteam, adminSteam, reason)

        if(total == nil) then
            return msg(adminSRC, "~r~The database is not connected")
        end

        msg(adminSRC, string.gsub("~g~User has been warned this is there {total} warning in 30 days", "{(.-)}", function(a) return ordinal_numbers(_G[a]) end))
        msg(victimSRC, "~r~You are warned for: " .. reason)
    else
        if(allowed(victimSRC, "warning")) then
            msg(source, "~r~Other user has the same/more permission")
        elseif(not online(victimSRC)) then
            msg(adminSRC, "~r~Other user is not online")
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

    if(allowed(adminSRC, action) and not allowed(victimSRC, action) and online(victimSRC)) then
        local adminSteam = GetSteamId(adminSRC)
        local victimSteam = GetSteamId(victimSRC)

        if(reason == nil or reason == "") then
            reason = "No reason"
        end

        if(adminSteam == nil or victimSteam == nil) then
            return msg(adminSRC, "~r~Something went wrong")
        end

        total = moderate("kick", victimSteam, adminSteam, reason)

        if(total == nil) then
            return msg(adminSRC, "~r~Something went wrong")
        end

        DropPlayer(victimSRC, reason)

        msg(adminSRC, string.gsub("~g~User has been kicked this is there {total} kick in 30 days", "{(.-)}", function(a) return ordinal_numbers(_G[a]) end))
    else
        if(allowed(victimSRC, "warning")) then
            msg(adminSRC, "~r~Other user has the same/more permission")
        elseif(not online(victimSRC)) then
            msg(adminSRC, "~r~Other user is not online")
        else
            msg(adminSRC, "~r~You doesn't have access")
        end
    end

end)

RegisterServerEvent("tadmin:ban")
AddEventHandler("tadmin:ban", function() 

end)

RegisterServerEvent("tadmin:report")
AddEventHandler("tadmin:report", function(args)
    local action = "report"
    reporter = source
    reporterName = GetPlayerName(source)
    victim = args[1]
    victimName = GetPlayerName(victim)
    reason = joinTable(args, " ", 1)

    if(not online(victim)) then
        return msg(reporter, "~r~User is not online")
    end

    if(tonumber(victim) == tonumber(reporter)) then
        return msg(reporter, "~r~You can't report yourself")
    end

    if(allowed(reporter, "blacklist")) then
        return msg(reporter, "~r~You are blacklisted from reporting")
    end

    if(victim == "" or victim == nil) then
        return msg(reporter, "~r~You need to give the user's ID")
    end

    if(reason == "" or reason == nil) then
        return msg(reporter, "~r~You need to give a reason")
    end

    local players = GetPlayers()
    local filtered = {}

    for i,v in pairs(players) do
        if(allowed(v, "admin")) then
            table.insert(filtered, v)
        end
    end

    moderate("warning", GetSteamId(victim), GetSteamId(reporter), reason)

    for i,v in pairs(filtered) do
        notification = string.gsub("Reported: ~r~({victim}) {victimName}~s~   ~n~Reporter: ~b~({reporter}) {reporterName}~s~   ~n~Reason: ~h~{reason}~h~", "{(.-)}", function(a) return _G[a] end)
        chatMSG = string.gsub("^1({victim}) {victimName}^7 - ^*{reason}", "{(.-)}", function(a) return _G[a] end)
        msg(v, notification, Config.ReportTime * 60000)
        TriggerClientEvent('chat:addMessage', v, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Reported", chatMSG}
        })
    end

    msg(reporter, "~g~User is reported")
end)

-- ------------------------- --
--        Functions          --
-- ------------------------- --
function msg(src, message, duration) 
    TriggerClientEvent('Notify', src, message, duration)
end

function allowed(src, action)
    if(IsPlayerAceAllowed(src, "taz." .. Ace[(action:gsub("^%l", string.upper))]) or (action ~= "blacklist" and IsPlayerAceAllowed(src, "taz." .. Ace["God"]))) then
        return true
    else
        return false
    end
end

function online(src)
    if(src == nil) then return false end

    local usr = GetPlayerEndpoint(src)
    if(type(usr) ~= nil) then
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

-- https://stackoverflow.com/a/20694458/9952755
function ordinal_numbers(n)
    local ordinal, digit = {"st", "nd", "rd"}, string.sub(n, -1)
    if tonumber(digit) > 0 and tonumber(digit) <= 3 and string.sub(n,-2) ~= 11 and string.sub(n,-2) ~= 12 and string.sub(n,-2) ~= 13 then
        return n .. ordinal[tonumber(digit)]
    else
        return n .. "th"
    end
end

function moderate(action, victim, admin, reason)

    local res = MySQL.Sync.execute("INSERT INTO `taz-log` (userID, modID, action, reason) VALUES (@warned, @admin, @action, @reason)", {
        ["@warned"] = victim,
        ["@admin"] = admin,
        ['@reason'] = reason,
        ['@action'] = action
    })

    if(res == nil) then
        return nil
    end

    local res = MySQL.Sync.fetchAll("SELECT COUNT(ID) as `amount` FROM `taz-log` WHERE created <= CURRENT_TIMESTAMP -30 AND `action`=@action AND userID=@victim", {['@action'] = action, ['@victim'] = victim})

    local count = res[1].amount + 1

    return count
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
