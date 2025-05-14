print('^2'..GetCurrentResourceName() .. ' started')

local wasDriver = false

CreateThread(function()
    while true do
        Wait(Config.CheckIntervall * 1000) 
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            local seat = GetPedInVehicleSeat(vehicle, -1)
            if seat == ped and not wasDriver then
                wasDriver = true
                SetCanPedEquipAllWeapons(ped, false)
            elseif seat ~= ped and wasDriver then
                wasDriver = false
                SetCanPedEquipAllWeapons(ped, true)
            end
        elseif wasDriver then
            wasDriver = false
            SetCanPedEquipAllWeapons(ped, true)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        local ped = PlayerPedId()
        SetCanPedEquipAllWeapons(ped, true)
    end
end)