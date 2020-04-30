RegisterCommand('warning', function(source, args)
    TriggerServerEvent('tadmin:warning', args)
end)

RegisterCommand('kick', function(source, args)
    TriggerServerEvent('tadmin:kick', args)
end)

RegisterCommand('report', function(source, args)
    TriggerServerEvent('tadmin:report', args)
end)



RegisterNetEvent('Notify')
AddEventHandler('Notify', function(msg, duration)
	ShowAboveRadarMessage(msg, duration)
end)


TriggerEvent('chat:addSuggestion', '/warning', 'Give a warning to a user',{
    {name="userID", help="Give the users ID"},
    {name="reason", help="Give the reason why he is warned"}
})

TriggerEvent('chat:addSuggestion', '/kick', 'Give a kick to a user',{
    {name="userID", help="Give the users ID"},
    {name="reason", help="Give the reason why he is kicked"}
})

TriggerEvent('chat:addSuggestion', '/report', 'Report a user',{
    {name="userID", help="Give the users ID"},
    {name="reason", help="Explain what he did"}
})

-- https://forum.cfx.re/t/delete-notification-message/48440/2?u=tazio
function ShowAboveRadarMessage(message, duration)
    Citizen.CreateThread(function()
        SetNotificationTextEntry("STRING")
        AddTextComponentSubstringPlayerName(message)
        if duration then 
            local Notification = DrawNotification(true, true)
            Citizen.Wait(duration)
            RemoveNotification(Notification)
        else 
            DrawNotification(false, true) 
        end
    end)
end