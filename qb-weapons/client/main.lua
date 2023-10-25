QBCore = nil
local isLoggedIn = false
local busy = false
local WeaponAmmo = {}
local CurrentWeaponData = nil
local PlayerData = {}
local charModelLoaded = false

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

RegisterNetEvent('QBCore:Player:SetPlayerData')
AddEventHandler('QBCore:Player:SetPlayerData', function(data)
	PlayerData = data
end)

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local time = 250

        if IsPedArmed(ped, 7) then 
            time = 1
            local selectedWeapon = GetSelectedPedWeapon(ped)
            local ammo = GetAmmoInPedWeapon(ped, selectedWeapon)
            if selectedWeapon == `weapon_marksmanpistol` then
                SetPedAmmo(ped, selectedWeapon, 10)
            end

            if IsPedShooting(ped) then
                if ammo - 1 < 1 then
                    SetAmmoInClip(ped, selectedWeapon, 1)
                end
            end

            if ammo == 1 and selectedWeapon ~= `weapon_molotov` and selectedWeapon ~= `weapon_flare` and selectedWeapon ~= `weapon_snowball` then
                DisableControlAction(0, 24, true) -- Attack
                DisableControlAction(0, 257, true) -- Attack 2
                if IsPedInAnyVehicle(ped, true) then
                    SetPlayerCanDoDriveBy(PlayerId(), false)
                end
            end
        end
        Citizen.Wait(time)
    end
end)

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(((1000 * 60) * 5))
        if isLoggedIn then
            TriggerServerEvent("weapons:server:SaveWeaponAmmo", WeaponAmmo)
        end
    end
end)

RegisterNetEvent("weapons:server:UpdateWeaponAmmo")
AddEventHandler('weapons:server:UpdateWeaponAmmo', function(type, amount, key)
    local type = tostring(type):upper()
    local amount = amount
    WeaponAmmo[type] = amount
end)

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local time = 250
        if IsPedArmed(playerPed, 7) then 
            time = 10
            if IsPedShooting(playerPed) then
                local weapon = GetSelectedPedWeapon(playerPed)
                if weapon ~= -1569615261 and weapon ~= `WEAPON_SNOWBALL` then
                    local hastToName = QBCore.Shared.WeaponsHashtoName[weapon]
                    if (CurrentWeaponData and CurrentWeaponData.name == hastToName) then
                        local ammo = GetAmmoInPedWeapon(playerPed, weapon)
                        if QBCore.Shared.Items[hastToName]["name"] == "weapon_snowball" then
                            TriggerServerEvent('QBCore:Server:RemoveItem', "snowball", 1)
                        else
                            TriggerEvent("weapons:server:UpdateWeaponAmmo", QBCore.Shared.Items[hastToName]["ammotype"], tonumber(ammo))
                        end
                    else
                        if hastToName == nil then hastToName = "NULL" end
                        if CurrentWeaponData and CurrentWeaponData.name then
                            TriggerEvent("tgiann-hackkoruma:client:kick", "Seri Numarası Olmayan Silah Kullanımı data:" .. CurrentWeaponData.name .." kullandığı:" ..hastToName)
                        else
                            TriggerEvent("tgiann-hackkoruma:client:kick", "Seri Numarası Olmayan Silah Kullanımı data: NULL kullandığı:" ..hastToName)
                        end
                    end
                end
            end
        end
        Citizen.Wait(time)
    end 
end)

RegisterNetEvent('weapon:client:AddAmmo')
AddEventHandler('weapon:client:AddAmmo', function(type, amount, key)
    if QBCore.Key == key then
        if not busy then
            local playerPed = PlayerPedId()
            local weapon = GetSelectedPedWeapon(playerPed)

            local hastToName = QBCore.Shared.WeaponsHashtoName[weapon]
            if QBCore.Shared.Items[hastToName] ~= nil and QBCore.Shared.Items[hastToName]["ammotype"] == type:upper() then
                local total = (GetAmmoInPedWeapon(playerPed, weapon) + amount)
                local found, maxAmmo = GetMaxAmmo(playerPed, weapon)
                if total < maxAmmo then
                    busy = true
                    TaskReloadWeapon(playerPed)
                    QBCore.Functions.Progressbar("ammo_load", "Mermi Dolduruluyor", 2000, false, true, { -- p1: menu name, p2: yazı, p3: ölü iken kullan, p4:iptal edilebilir
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function() -- Done
                        SetPedAmmo(playerPed, weapon, total)
                        TriggerEvent("weapons:server:UpdateWeaponAmmo", type, total)
                        TriggerServerEvent("weapons:server:SaveWeaponAmmo", WeaponAmmo)
                        TriggerServerEvent("weapons:server:remove-ammo-item", type)
                        busy = false
                    end, function() -- Cancel
                        busy = false
                    end)
                else
                    QBCore.Functions.Notify("Silahın Mermisi Zaten Dolu", "error") 
                end
            end
        end
    else
        TriggerEvent("tgiann-hackkoruma:client:kick", "İzinsiz Mermi Doldurma Eventi, Gönderilen Key: "..key)
    end
end)

RegisterNetEvent('weapon:add-ammo')
AddEventHandler('weapon:add-ammo', function(type, amount, key)
    if QBCore.Key == key then
        TriggerEvent("weapons:server:UpdateWeaponAmmo", type, amount)
        TriggerServerEvent("weapons:server:SaveWeaponAmmo", WeaponAmmo)
    else
        TriggerEvent("tgiann-hackkoruma:client:kick", "İzinsiz Mermi Doldurma Eventi, Gönderilen Key: "..key)
    end
end)

RegisterNetEvent("weapon:server:GetWeaponAmmo")
AddEventHandler('weapon:server:GetWeaponAmmo', function(cb, type)
    cb(WeaponAmmo[type])
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data then
        CurrentWeaponData = data
        QBCore.Functions.Notify("Silahı Eline Aldın; ".. CurrentWeaponData.label, "success", 1500)
    else
        QBCore.Functions.Notify("Silahı Elinden Bıraktın; ".. CurrentWeaponData.label, "error", 1500)
        CurrentWeaponData = nil
    end
    CanShoot = bool
end)

RegisterNetEvent("weapons:client:EquipAttachment")
AddEventHandler("weapons:client:EquipAttachment", function(ItemData, attachment)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    local weaponName = QBCore.Shared.WeaponsHashtoName[weapon]
    local WeaponData = QBCore.Shared.Items[weaponName]
    if weapon ~= `WEAPON_UNARMED` then
        WeaponData.name = WeaponData.name:upper()
        if Config.WeaponAttachments[WeaponData.name] ~= nil then
            if Config.WeaponAttachments[WeaponData.name][attachment] ~= nil then
                TriggerServerEvent("weapons:server:EquipAttachment", ItemData, CurrentWeaponData, Config.WeaponAttachments[WeaponData.name][attachment])
            else
                QBCore.Functions.Notify("Bu Silaha Bu Eklentiyi Takamazsın!", "error")
            end
        end
    else
        QBCore.Functions.Notify("Elinde Bu Eklentiyi Takabilecek Bir Silah Yok!", "error")
    end
end)

RegisterNetEvent("addAttachment")
AddEventHandler("addAttachment", function(component)
    local ped = PlayerPedId()
    local weapon = GetSelectedPedWeapon(ped)
    GiveWeaponComponentToPed(ped, weapon, GetHashKey(component))
end)

local sirtSilah = {}
local nameToPropHash = {
    [`weapon_smg`] = `w_sb_smg`,
    [`weapon_carbinerifle_mk2`] = `w_ar_carbineriflemk2`,
    [`weapon_smg_mk2`] = `w_sb_smgmk2`, 
    [`weapon_assaultrifle_mk2`] = `w_ar_assaultriflemk2`,
    [`weapon_sniperrifle`] = `w_sr_sniperrifle`,
}

Citizen.CreateThread(function()
    while true do
        if isLoggedIn and charModelLoaded then
            for x,itemName in pairs(PlayerData.items) do
                if itemName and itemName.name then
                    if itemName.name == "weapon_smg" or itemName.name == "weapon_sniperrifle" or itemName.name == "weapon_carbinerifle_mk2" or  itemName.name == "weapon_smg_mk2" or itemName.name == "weapon_assaultrifle_mk2" then
                        local weaponHash = GetHashKey(itemName.name)
                        local hashToStrig = tostring(weaponHash)
                        if not sirtSilah[hashToStrig] then
                            AttachWeapon(hashToStrig, nameToPropHash[weaponHash])
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)
  
function AttachWeapon(hashToStrig, model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    sirtSilah[hashToStrig] = {
        hash = model,
        handle = CreateObject(model, 1.0, 1.0, 1.0, true, true, false)
    }
    AttachEntityToEntity(sirtSilah[hashToStrig].handle, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 24816), 0.175, -0.15, -0.02, 0.0, 165.0, 0.0, 1, 1, 0, 0, 2, 1)
    SetEntityAsNoLongerNeeded(model)
end

local lastStringHash = nil
local armed = false
Citizen.CreateThread(function()
    while true do
        if isLoggedIn then
            local playerPed = PlayerPedId()
            if IsPedArmed(playerPed, 7) then
                if not armed then
                    lastStringHash = tostring(GetSelectedPedWeapon(playerPed))
                    if sirtSilah[lastStringHash] then
                        QBCore.Functions.DeleteObject(sirtSilah[lastStringHash].handle)
                    end
                    armed = true
                end
            else
                if armed and lastStringHash then
                    if sirtSilah[lastStringHash] then
                        AttachWeapon(lastStringHash, sirtSilah[lastStringHash].hash)
                    end
                    lastStringHash = nil
                    armed = false
                end
            end
        end
        Citizen.Wait(0)
    end
end)

RegisterNetEvent("inventory:client:remove-item")
AddEventHandler("inventory:client:remove-item", function(itemName)
    if string.match(itemName, "weapon") == "weapon" then
        local hash = tostring(GetHashKey(itemName))
        if sirtSilah[hash] then
            QBCore.Functions.DeleteObject(sirtSilah[hash].handle)
            sirtSilah[hash] = nil
            lastStringHash = nil
            armed = false
        end
    end
end)

RegisterNetEvent('tgian-hud:load-data')
AddEventHandler('tgian-hud:load-data', function()
    QBCore.Functions.TriggerCallback("weapons:server:LoadWeaponAmmo", function(data)
        WeaponAmmo = data
        PlayerData = QBCore.Functions.GetPlayerData()
        
        lastStringHash = nil
        armed = false
        Citizen.Wait(1000)
        for x, y in pairs(sirtSilah) do
            QBCore.Functions.DeleteObject(y.handle)
        end
        sirtSilah = {}
        charModelLoaded = true
        isLoggedIn = true
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        for x, y in pairs(sirtSilah) do
            QBCore.Functions.DeleteObject(y.handle)
        end
    end
end)