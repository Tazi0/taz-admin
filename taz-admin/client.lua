RegisterCommand('warning', function(source, args)
    TriggerServerEvent('tadmin:warning', args)
end)

RegisterCommand('kick', function(source, args)
    TriggerServerEvent('tadmin:kick', args)
end)



RegisterNetEvent('Notify')
AddEventHandler('Notify', function(msg)
	ShowAboveRadarMessage(msg)
end)


TriggerEvent('chat:addSuggestion', '/warning', 'Give a warning to a user',{
    {name="userID", help="Give the users ID"},
    {name="reason", help="Give the reason why he should be warned"}
})

TriggerEvent('chat:addSuggestion', '/kick', 'Give a kick to a user',{
    {name="userID", help="Give the users ID"},
    {name="reason", help="Give the reason why he should be warned"}
})

function ShowAboveRadarMessage(message)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(message)
	DrawNotification(0,1)
end