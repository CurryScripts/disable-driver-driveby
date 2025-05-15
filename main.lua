print('^2'..GetCurrentResourceName() .. ' started')

local wasDriver = false
local lastWeapon = nil

CreateThread(function()
    while true do
        Wait(Config.CheckIntervall * 1000) 

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            local seat = GetPedInVehicleSeat(vehicle, -1)

            if seat == ped then
                if not wasDriver then
                    wasDriver = true
                    --print("Fahrer erkannt")
                end

                local currentWeapon = GetSelectedPedWeapon(ped)
                
                if not IsWeaponAllowed(currentWeapon) then
                    if currentWeapon ~= `WEAPON_UNARMED` then
                        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
                        --print("Verbotene Waffe erkannt – wechsle zu unbewaffnet")
                    end
                end
            else
                CollectGarbage()
                if wasDriver then
                    wasDriver = false
                end
            end
        else
            if wasDriver then
                wasDriver = false
            end
        end
    end
end)

function IsWeaponAllowed(weaponHash)
    for _, allowedWeapon in ipairs(Config.WeaponList) do
        if weaponHash == GetHashKey(allowedWeapon) then
            return true
        end
    end
    return false
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        print("Resource gestoppt – Waffenverhalten zurückgesetzt")
    end
end)
