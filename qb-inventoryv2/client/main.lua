

QBCore = nil

inInventory = false
hotbarOpen = false

local currentOtherPlayer = nil 
local currentTrunk = nil
local currentGlove = nil
local currentMarket = nil 

local freezePlayer = false

local inventoryTest = {}
local currentWeapon = nil
local CurrentWeaponData = {}
local currentOtherInventory = nil

local Drops = {}
local CurrentDrop = 0
local CurrentDrop = nil
local DropsNear = {}
local tolerans = 0
local CurrentVehicle = nil
local CurrentGlovebox = nil
local CurrentStash = nil
local isCrafting = false

local otherPlayerId = nil

local isDead = false
local HasNuiFocus = false
local phoneOpen = false

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

AddEventHandler('ra1derBase:playerdead', function(dead)
    isDead = dead
end)

RegisterNetEvent('phone:open')
AddEventHandler('phone:open', function(bool)
    phoneOpen = bool
    SendNUIMessage({type = 'phone', phoneOpen = phoneOpen})
end)

RegisterNetEvent('inventory:client:CheckOpenState', function(type, id, label)
    local name = QBCore.Shared.SplitStr(label, "-")[2]
    if type == "stash" then
        if name ~= CurrentStash or CurrentStash == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "trunk" then
        if name ~= CurrentVehicle or CurrentVehicle == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "glovebox" then
        if name ~= CurrentGlovebox or CurrentGlovebox == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    elseif type == "drop" then
        if name ~= CurrentDrop or CurrentDrop == nil then
            TriggerServerEvent('inventory:server:SetIsOpenState', false, type, id)
        end
    end
end)

RegisterNetEvent('inventory:openInventoryAnim')
AddEventHandler('inventory:openInventoryAnim', function(sI)
    local playerPed = PlayerPedId()
    if not IsEntityPlayingAnim(playerPed, 'pickup_object', 'putdown_low', 3) then
        QBCore.Shared.RequestAnimDict('pickup_object', function()
            TaskPlayAnim(playerPed, 'pickup_object', 'putdown_low', 5.0, 1.5, 1.0, 48, 0.0, 0, 0, 0)
            Wait(1000)
            ClearPedSecondaryTask(playerPed)
        end)
    end
end)

RegisterNetEvent('weapons:client:SetCurrentWeapon')
AddEventHandler('weapons:client:SetCurrentWeapon', function(data, bool)
    if data ~= false then
        CurrentWeaponData = data
    else
        CurrentWeaponData = {}
    end
end)



RegisterNetEvent('env:kapat')
AddEventHandler('env:kapat', function()
    SendNUIMessage({
        action = "close",
    })
end)

function GetClosestVending()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local object = nil
    for _, machine in pairs(Config.VendingObjects) do
        local ClosestObject = GetClosestObjectOfType(pos.x, pos.y, pos.z, 50.0, GetHashKey(machine), 0, 0, 0)
        if ClosestObject ~= 0 and ClosestObject ~= nil then
            if object == nil then
                object = ClosestObject
            end
        end
    end
    return object
end

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    RegisterKeyMapping('+inv', 'Envanter', 'keyboard', 'F2')
    RegisterKeyMapping('+inv1', 'Envanter [1]', 'keyboard', '1')
    RegisterKeyMapping('+inv2', 'Envanter [2]', 'keyboard', '2')
    RegisterKeyMapping('+inv3', 'Envanter [3]', 'keyboard', '3')
    RegisterKeyMapping('+inv4', 'Envanter [4]', 'keyboard', '4')
    RegisterKeyMapping('+inv5', 'Envanter [5]', 'keyboard', '5')
end)


RegisterCommand("+inv", function()
    if not exports["high_phone"]:phoneIsOpen()  then --kullandığınız telefon exportuna göre düzenleyiniz.
        if not isCrafting and not HasNuiFocus and not IsEntityPlayingAnim(PlayerPedId(), "re@construction", "out_of_breath", 1) then
            PlayerData = QBCore.Functions.GetPlayerData() 
                if not isDead and not PlayerData.metadata["kelepce"] and not PlayerData.metadata["pkelepce"] then
                    local curVeh = nil
                    local ped = PlayerPedId()
                    if IsPedInAnyVehicle(ped) then
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        CurrentGlovebox = GetVehicleNumberPlateText(vehicle)
                        curVeh = vehicle
                        CurrentVehicle = nil
                    else
                        local vehicle = QBCore.Functions.GetClosestVehicle()
                        if vehicle ~= 0 and vehicle ~= nil then
                            local pos = GetEntityCoords(ped)
                            local trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, -2.5, 0)
                            if (IsBackEngine(GetEntityModel(vehicle))) then
                                trunkpos = GetOffsetFromEntityInWorldCoords(vehicle, 0, 2.5, 0)
                            end
                            if #(pos - trunkpos) < 2.0 and not IsPedInAnyVehicle(ped) then
                                if GetVehicleDoorLockStatus(vehicle) < 2 then
                                    CurrentVehicle = GetVehicleNumberPlateText(vehicle)
                                    curVeh = vehicle
                                    CurrentGlovebox = nil
                                else
                                    QBCore.Functions.Notify("Araç Kilitli", "error")
                                    return
                                end
                            else
                                CurrentVehicle = nil
                            end
                        else
                            CurrentVehicle = nil
                        end
                    end

                    if CurrentVehicle ~= nil then
                        local maxweight = 0
                        local slots = 0
                        if GetEntityModel(curVeh) == `polnspeedo` then
                            maxweight = 300000
                            slots = 50
                        elseif GetEntityModel(curVeh) == `bcat` then
                            maxweight = 3000000
                            slots = 50
                        elseif GetVehicleClass(curVeh) == 0 then -- Compacts  
                            maxweight = 50000 -- 50Kg
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 1 then -- Sedans  
                            maxweight = 50000 -- 125Kg
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 2 then -- SUVs
                            maxweight = 175000 --175Kg
                            slots = 15
                        elseif GetVehicleClass(curVeh) == 9 then --Off-road
                            maxweight = 100000 --100kg
                            slots = 20
                        elseif GetVehicleClass(curVeh) == 12 then -- Vans  
                            maxweight = 200000 --300kg
                            slots = 10
                        elseif GetVehicleClass(curVeh) == 3 then -- Coupes,
                            maxweight = 75000 --75Kg
                            slots = 5
                        elseif  GetVehicleClass(curVeh) == 4 then --Muscle  
                            maxweight = 50000 --100kg
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 13 then -- Cycles  
                            maxweight = 5000 -- 5kg
                            slots = 1
                        elseif GetVehicleClass(curVeh) == 5 then -- Sports Classics
                            maxweight = 100000 --100kg
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 6 then -- Sports  
                            maxweight = 40000 --40kg
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 7 then -- Super  
                            maxweight = 20000 --20kg
                            slots = 5
                        elseif GetVehicleClass(curVeh) == 8 then -- Motorcycles  
                            maxweight = 10000 --10kg
                            slots = 1
                        else
                            maxweight = 150000
                            slots = 10
                        end
                        if QBCore.Shared.Trim(GetVehicleNumberPlateText(curVeh)) == nil then
                            maxweight = 50000
                            slots = 5
                        end

                        local other = {
                            maxweight = maxweight,
                            slots = slots,
                        }
                        TriggerServerEvent("inventory:server:OpenInventory", "trunk", CurrentVehicle, other)
                        OpenTrunk()
                    elseif CurrentGlovebox ~= nil then
                        if GetVehicleClass(curVeh) == 18 then
                            local driverSeat = GetPedInVehicleSeat(curVeh, -1) == PlayerPedId()
                            local passengerSeat = GetPedInVehicleSeat(curVeh, 0) == PlayerPedId()
                            if driverSeat or passengerSeat then
                                TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                            else
                                QBCore.Functions.Notify("Arka Koltuktan Torpidoyu Açamazsın!", "error")
                                TriggerServerEvent("inventory:server:OpenInventory", "drop", 0)
                            end
                        else
                            TriggerServerEvent("inventory:server:OpenInventory", "glovebox", CurrentGlovebox)
                        end
                    elseif CurrentDrop ~= 0 then
                    TriggerServerEvent("inventory:server:OpenInventory", "drop", CurrentDrop)
                    else
                        TriggerServerEvent("inventory:server:OpenInventory")
                    end
                    TriggerEvent("inventory:openInventoryAnim")
                end
        end
    else
        QBCore.Functions.Notify("İşlem yaparken envanteri açamazsın.", "error")
    end
end, false)

RegisterCommand("+inv1", function()
    if not freezePlayer then 
        useSlot(1)
    end
end, false)

RegisterCommand("+inv2", function()
    if not freezePlayer then 
        useSlot(2)
    end
end, false)

RegisterCommand("+inv3", function()
    if not freezePlayer then 
        useSlot(3)
    end
end, false)

RegisterCommand("+inv4", function()
    if not freezePlayer then 
        useSlot(4)
    end
end, false)

RegisterCommand("+inv5", function()
    if not freezePlayer then 
        useSlot(5)
    end
end, false)


RegisterNetEvent('inventoryHotBar')
AddEventHandler('inventoryHotBar', function(bool)
    ToggleHotbar(bool)
end)

RegisterCommand('+generalTab', function()
    TriggerEvent("inventoryHotBar", true)
    TriggerEvent("oxHudMoney", true)
 end, false)

 
 function useSlot(slot)
     if not HasNuiFocus and not IsEntityPlayingAnim(PlayerPedId(), "re@construction", "out_of_breath", 1) then
         QBCore.Functions.GetPlayerData(function(PlayerData)
             if not isDead and not PlayerData.metadata["kelepce"] and not PlayerData.metadata["pkelepce"] and not exports["high_phone"]:phoneIsOpen()   then --kullandığınız telefon exportuna göre düzenleyiniz.
                 TriggerServerEvent("inventory:server:UseItemSlot", slot)
             end
         end)
     end
 end
RegisterNetEvent('inventory:client:ItemBox')
AddEventHandler('inventory:client:ItemBox', function(itemData, type)
    SendNUIMessage({
        action = "itemBox",
        item = itemData,
        type = type
    })
end)

RegisterNetEvent('inventory:client:requiredItems')
AddEventHandler('inventory:client:requiredItems', function(items, bool)
    local itemTable = {}
    if bool then
        for k, v in pairs(items) do
            table.insert(itemTable, {
                item = QBCore.Shared.Items[items[k]],
                label = QBCore.Shared.Items[items[k]]["label"],
                image = QBCore.Shared.Items[items[k]]["name"]..".png",
            })
        end
    end
    
    SendNUIMessage({
        action = "requiredItem",
        items = itemTable,
        toggle = bool
    })
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        for k, v in pairs(Drops) do
            if Drops[k] ~= nil then 
                local distance = #(GetEntityCoords(PlayerPedId(), true) - vector3(v.coords.x, v.coords.y, v.coords.z))
                if distance < 20 then
                    time = 1
                    DrawMarker(2, v.coords.x, v.coords.y, v.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.15, 120, 10, 20, 155, false, false, false, 1, false, false, false)
                end
            end
        end
        Citizen.Wait(time)
    end
end)

Citizen.CreateThread(function()
    while true do
        checkDrop()
        Citizen.Wait(1)
    end
end)

function checkDrop()
    local time = 1000
    for k, v in pairs(Drops) do
        if Drops[k] ~= nil then 
            local distance = #(GetEntityCoords(PlayerPedId(), true) - vector3(v.coords.x, v.coords.y, v.coords.z))
            if distance < 7.5 then
                time = 500
                if distance <= 1.5 then
                    time = 25
                    CurrentDrop = k
                    return
                end
            end
        end
    end
    CurrentDrop = nil
    Citizen.Wait(time)
end

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    TriggerServerEvent("inventory:server:LoadDrops")
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent("inventory:client:LoadDrops")
AddEventHandler("inventory:client:LoadDrops", function(allDrops)
    Drops = allDrops
end)

RegisterNetEvent('inventory:server:RobPlayer')
AddEventHandler('inventory:server:RobPlayer', function(TargetId)
    SendNUIMessage({
        action = "RobMoney",
        TargetId = TargetId,
    })
end)

RegisterNUICallback('RobMoney', function(data, cb)
    TriggerServerEvent("police:server:RobPlayer", data.TargetId)
end)

RegisterNUICallback('Notify', function(data, cb)
    QBCore.Functions.Notify(data.message, data.type)
end)


RegisterNetEvent("inventory:client:OpenInventory")
AddEventHandler("inventory:client:OpenInventory", function(PlayerAmmo, inventory, other, oyuncuismi)
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not IsEntityDead(PlayerPedId()) then
        tolerans = GetGameTimer() + 200
        ToggleHotbar(false)
        SetCustomNuiFocus(true, true)
        if other ~= nil then
            currentOtherInventory = other.name
        end
        SendNUIMessage({
            action = "open",
            firstname = PlayerData.charinfo.firstname,
            lastname = PlayerData.charinfo.lastname,
            para = PlayerData.money["cash"],
            inventory = inventory,
            slots = MaxInventorySlots,
            other = other,
            maxweight = QBCore.Config.Player.MaxWeight,
            Ammo = PlayerAmmo,
            id = GetPlayerServerId(PlayerId()),
            maxammo = Config.MaximumAmmoValues,
        })
        TriggerScreenblurFadeIn(150)
        inInventory = true 
    end
end)




RegisterNetEvent("inventory:client:UpdatePlayerInventory", function(isError)
    SendNUIMessage({
        action = "update",
        inventory = QBCore.Functions.GetPlayerData().items,
        maxweight = QBCore.Config.Player.MaxWeight,
        slots = MaxInventorySlots,
        error = isError,
    })
end)

RegisterNetEvent("inventory:client:CraftItems")
AddEventHandler("inventory:client:CraftItems", function(itemName, itemCosts, amount, toSlot, points)
    SendNUIMessage({
        action = "close",
    })
    isCrafting = true
    QBCore.Functions.Progressbar("env", "Eşya Üretiliyor..", (math.random(10000, 20000) * amount), false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_player",
		flags = 16,
    }, {}, {}, function() -- Done
        ClearPedTasksImmediately(PlayerPedId())
        QBCore.Functions.TriggerCallback("inventory:server:CraftItems", function(result)
            if result then
                TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[itemName], 'add')
            end
        end, itemName, itemCosts, amount, toSlot, points, QBCore.Key)
        isCrafting = false
	end, function() -- Cancel
        QBCore.Functions.Notify("Başarısız!", "error")
        isCrafting = false
	end)
end)

function GetThresholdItems(table)
	local items = {}
	local number = 1
	local CraftingItems = ItemsToItemInfo(table)
	local oldConfig = CraftingItems
	for k, item in pairs(oldConfig) do
		items[number] = oldConfig[k]
		number = number + 1
	end
	return items
end

function ItemsToItemInfo(table)
	local items = {}
	local slot = 0
	for k, item in pairs(table) do
		slot = slot + 1
		table[k].slot = slot
		local itemInfo = QBCore.Shared.Items[item.name:lower()]
		local itemCostLabel = ""
		local first = true
		for itemName, itemAmount in pairs(item.costs) do
            if QBCore.Shared.Items[itemName] ~= nil then 
			    if first then
                    first = false 
                    itemCostLabel = "Gerekenler: " ..itemAmount.. "x " ..QBCore.Shared.Items[itemName]["label"] ..""
                else
                    itemCostLabel =  itemCostLabel ..", "..QBCore.Shared.Items[itemName]["label"] .. ": "..itemAmount.."x"
                end
            else
                QBCore.Functions.Notify(itemName.. " İsimli Eşya Bulunamadı, Yetkililer İle İletişime Geçin", 'error', 7500)
                return {}
            end
		end

		items[item.slot] = {
			name = itemInfo["name"],
			amount = tonumber(item.amount),
			info = {costs = itemCostLabel},
			label = itemInfo["label"],
			description = itemInfo["description"] ~= nil and itemInfo["description"] or "",
			weight = itemInfo["weight"], 
			type = itemInfo["type"], 
			unique = itemInfo["unique"], 
			useable = itemInfo["useable"], 
			image = itemInfo["name"]..".png",
			slot = item.slot,
			costs = item.costs,
			job = item.job,
			allcost = item.costs,
		}
		end
	return items
end
-- Burada ki kullanım mantığı basit. Her eklenecek craft'ın bir tablosu var. Örnek olarak "sivil" olarak bir tablo var. Onun altında ise  "polis" adı altında bir tablo var. Siz polislerin görebileceği craft;
-- Ekranında diğer hangi craftları da görebilmesini istiyorsanız alt satırda yazacağım işlemi yapmalısınız.
-- Örnek olarak polis tablosuna sivil ve hacker eklemek istiyorsunuz. O zaman ise; Polis tablonun hemen altına         ek = {"sivil"}, ekleyerek sivil tablosunu veya ek = {"sivil", "hacker"}, olarak iki tablo ekleyebilirsiniz.

-- 
local uretilebilir = {
	["sivil"] = {
        items = {
            {
                name = "weapon_bottle",
                amount = 1,
                costs = {
                    ["sise"] = 2,

                },
            },
            {
                name = "lockpick2",
                amount = 1,
                costs = {
                ["crudemetal"] = 5,
                ["pkonserve"] = 10,

                },
            },
            {
                name = "lockpick3",
                amount = 1,
                costs = {
                    ["lockpick2"] = 2,
                    ["crudemetal"] = 5,
                    ["pkonserve"] = 10,
                },
            },
            {
                name = "sarma_ot",
                amount = 1,
                costs = {
                    ["kagit"] = 5,
                    ["ot"] = 10,
                },
            },
            {
                name = "matkap",
                amount = 1,
                costs = {
                    ["matkapucu"] = 1,
                    ["yarimmatkap"] = 1,
                },
            },
        }
    },
    ["polis"] = {
        -- label = 'Polis Üretim',
        ek = {"sivil"},
        items = {
            {
                name = "armor",
                amount = 1,
                costs = {
                    ["finishediron"] = 5,
                },
                type = "item",
            },
            {
                name = "pistol_ammo",
                amount = 1,
                costs = {
                    ["finishediron"] = 5,
                },
                type = "item",
            },
            {
                name = "weapon_combatpistol",
                amount = 1,
                costs = {
                    ["finishediron"] = 5,
                },
                type = "item",
            },
        }
    },
    ["hacker"] = {
        ek = {"sivil"},
        items = {
            {
                name = "hackv1",
                amount = 1,
                costs = {
                    ["white_phone"] = 5,
                },
                type = "item",
            },
            {
                name = "hackv2",
                amount = 1,
                costs = {
                    ["white_phone"] = 5,
                },
                type = "item",
            },
            {
                name = "hackv3",
                amount = 1,
                costs = {
                    ["white_phone"] = 5,
                },
                type = "item",
            },

        }
    },
    ["mekanik"] = {
        ek = {"sivil"},
        items = {
            {
                name = "nos",
                amount = 10,
                costs = {
                    ["white_phone"] = 10,
                },
                type = "item",
            },
            {
                name = "fixkit",
                amount = 1,
                costs = {
                    ["white_phone"] = 15,
                },
                type = "item",
            },
            {
                name = "tamirkiti",
                amount = 1,
                costs = {
                    ["white_phone"] = 15,
                },
                type = "item",
            },
            {
                name = "lockpick2",
                amount = 1,
                costs = {
                    ["white_phone"] = 10,
                },
                type = "item",
            },
        }
    },
}
-- Burada yukarı da hangi tabloyu oluşturmuşsanız buraya eklemelisiniz. Else değerinde ki default sivil craftıdır.
RegisterNUICallback("OpenCraft", function(data, cb)
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == 'mechanic' then
        kullanKanka(uretilebilir["mekanik"])
    elseif PlayerData.job.name == 'police' then
        kullanKanka(uretilebilir["polis"])
    elseif PlayerData.job.name == 'hacker' then
        kullanKanka(uretilebilir["hacker"])
    else
        kullanKanka(uretilebilir["sivil"])
    end
end)

function kullanKanka(data)
    local crafting = {label = data.label or "Üretim Masası"}
    crafting.items = {}
    if data.ek then
        for k,v in ipairs(data.ek) do
            for l,u in pairs(uretilebilir[v].items) do
                table.insert(crafting.items,u)
            end
        end
    end
    for k,v in ipairs(data.items) do
        table.insert(crafting.items,v)
    end
    crafting.items = GetThresholdItems(crafting.items)
	TriggerServerEvent("inventory:server:OpenInventory", "crafting", math.random(1, 99), crafting)
end

RegisterNetEvent("inventory:client:PickupSnowballs")
AddEventHandler("inventory:client:PickupSnowballs", function()
    local PlayerPedId = PlayerPedId()
    if not IsPedInAnyVehicle(PlayerPedId) then
        LoadAnimDict('anim@mp_snowball')
        TaskPlayAnim(PlayerPedId, 'anim@mp_snowball', 'pickup_snowball', 3.0, 3.0, -1, 0, 1, 0, 0, 0)
        QBCore.Functions.Progressbar("pickupsnowball", "Toplanıyor..", 1500, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            ClearPedTasks(PlayerPedId)
            GiveWeaponToPed(PlayerPedId, `weapon_snowball`, 1, false, false)
            SetPedAmmo(PlayerPedId, `weapon_snowball`, 1)
            SetCurrentPedWeapon(PlayerPedId, `weapon_snowball`, true)
        end, function() -- Cancel
            ClearPedTasks(PlayerPedId)
            QBCore.Functions.Notify("Canceled..", "error")
        end)
    else
        QBCore.Functions.Notify("Araçta Bu Komutu Kullanamazsın!", "error")
    end
end)

local allowedWeapons = {
    ["weapon_machete"] = true,
    ["weapon_sawnoffshotgun"] = true,
    ['weapon_bat'] = true,
    ['weapon_knife'] = true,
    ['weapon_pistol'] = true,
    ['weapon_pistol_mk2'] = true,
    ['weapon_switchblade'] = true,
    ['weapon_hatchet'] = true,
    ['weapon_battleaxe'] = true,
    ['weapon_carbinerifle'] = false,
    ['weapon_gusenberg'] = false,
    ['weapon_microsmg'] = false,
    ['weapon_heavypistol'] = true,
    ['weapon_combatpistol'] = false,
    ['weapon_smg_mk2'] = true,
    ['weapon_assaultrifle_mk2'] = false,
    ['weapon_appistol'] = true,
    ['weapon_pistol50'] = true,
    ['weapon_machinepistol'] = true,
    ['weapon_fireextinguisher'] = true,
    ['weapon_militaryrifle'] = true,
    ['weapon_snspistol'] = true,
    ['weapon_minismg'] = true,
    ['weapon_microsmg'] = true,
    ['weapon_smg'] = false,
    ['weapon_macrosmg'] = true,
    ['weapon_sniperrifle'] = true,
    ['weapon_shiv'] = true,
    -- ['weapon_katana'] = true,
    ['weapon_brick'] = true,
    -- ['weapon_katanas'] = true,
    ['weapon_sledgehammer'] = true,
    ['weapon_ceramicpistol'] = false,
    ['weapon_doubleaction'] = false,
    ['weapon_flashlight'] = true,
}

RegisterNetEvent("inventory:client:UseWeapon")
AddEventHandler("inventory:client:UseWeapon", function(weaponData, time)
    local ped = PlayerPedId()
    local weaponName = tostring(weaponData.name)
    --     local playerPed = PlayerPedId()
    local durubality = 1
    if weaponData.info.durubality then
        local date = weaponData.info.durubality + 604800
        local durubality_frist = (date - time) / (60 * 60 * 24)
        durubality = 100 - ((7 - durubality_frist)*20)
    end
    if durubality > 0 then
    if currentWeapon == weaponName then
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(ped, true)
        TriggerEvent('weapons:client:SetCurrentWeapon', nil, shootbool)
        TriggerEvent('inventory:client:WeaponHolster', weaponData, "weapon_unarmed")
        currentWeapon = nil
    elseif weaponName == "weapon_stickybomb" or weaponName == "weapon_pipebomb" or weaponName == "weapon_smokegrenade" or weaponName == "weapon_flare" or weaponName == "weapon_proxmine" or weaponName == "weapon_ball"  or weaponName == "weapon_molotov" or weaponName == "weapon_grenade" or weaponName == "weapon_bzgas" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 1, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 1)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    elseif weaponName == "weapon_snowball" then
        GiveWeaponToPed(ped, GetHashKey(weaponName), 10, false, false)
        SetPedAmmo(ped, GetHashKey(weaponName), 10)
        SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
--                 TriggerServerEvent('QBCore:Server:RemoveItem', weaponName, 1)
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        currentWeapon = weaponName
    else
        TriggerEvent('weapons:client:SetCurrentWeapon', weaponData, shootbool)
        QBCore.Functions.TriggerCallback("weapon:server:GetWeaponAmmo", function(result)
            TriggerEvent('inventory:client:WeaponHolster', weaponData, currentWeapon)
            local ammo = tonumber(result)
            if weaponName == "weapon_petrolcan" or weaponName == "weapon_fireextinguisher" then
                ammo = 4000
            end
            GiveWeaponToPed(ped, GetHashKey(weaponName), 0, false, false)
            SetPedAmmo(ped, GetHashKey(weaponName), ammo)
            SetCurrentPedWeapon(ped, GetHashKey(weaponName), true)
            if weaponData.info.attachments ~= nil then
                for _, attachment in pairs(weaponData.info.attachments) do
                    GiveWeaponComponentToPed(ped, GetHashKey(weaponName), GetHashKey(attachment.component))
                end
            end
            currentWeapon = weaponName
        end, CurrentWeaponData)
    end
        else
        QBCore.Functions.Notify("Bu Silah Kullanılamayacak Kadar Kötü Durumda", "error")
        end
end)

WeaponAttachments = exports["qb-weapons"]:eklentiData()

function FormatWeaponAttachments(itemdata)
    local attachments = {}
    itemdata.name = itemdata.name:upper()
    if itemdata.info.attachments ~= nil and next(itemdata.info.attachments) ~= nil then
        for k, v in pairs(itemdata.info.attachments) do
            if WeaponAttachments[itemdata.name] ~= nil then
                for key, value in pairs(WeaponAttachments[itemdata.name]) do
                    if value.component == v.component then
                        table.insert(attachments, {
                            attachment = key,
                            label = value.label
                        })
                    end
                end
            end
        end
    end
    return attachments
end

RegisterNUICallback('GetWeaponData', function(data, cb)
    local data = {
        WeaponData = QBCore.Shared.Items[data.weapon],
        AttachmentData = FormatWeaponAttachments(data.ItemData)
    }
    cb(data)
end)

RegisterNUICallback('RemoveAttachment', function(data, cb)
    local WeaponData = QBCore.Shared.Items[data.WeaponData.name]
    local Attachment = WeaponAttachments[WeaponData.name:upper()][data.AttachmentData.attachment]
    
    QBCore.Functions.TriggerCallback('weapons:server:RemoveAttachment', function(NewAttachments)
        if NewAttachments ~= false then
            local Attachies = {}
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            for k, v in pairs(NewAttachments) do
                for wep, pew in pairs(WeaponAttachments[WeaponData.name:upper()]) do
                    if v.component == pew.component then
                        table.insert(Attachies, {
                            attachment = pew.item,
                            label = pew.label,
                        })
                    end
                end
            end
            local DJATA = {
                Attachments = Attachies,
                WeaponData = WeaponData,
            }
            cb(DJATA)
        else
            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(data.WeaponData.name), GetHashKey(Attachment.component))
            cb({})
        end
    end, data.AttachmentData, data.WeaponData)
end)

RegisterNetEvent("inventory:client:remove-item")
AddEventHandler("inventory:client:remove-item", function(item)
    if item == "gps" then
        TriggerServerEvent("ra1derEmergencyBlips:acikgps-kapat", false)
    elseif item == "walkie_lspd" then
        TriggerEvent("qb-radio:onRadioDrop")
    elseif string.match(item, "weapon") == "weapon" then
        TriggerEvent("inventory:drop-weapon", item)
    end
end)

RegisterNetEvent("inventory:client:AddDropItem")
AddEventHandler("inventory:client:AddDropItem", function(drop, dropId)
    Drops[dropId] = {
        id = dropId,
        coords = {
            x = drop.coords.x,
            y = drop.coords.y,
            z = drop.coords.z - 0.3,
        },
    }
end)

RegisterNetEvent("inventory:client:RemoveDropItem")
AddEventHandler("inventory:client:RemoveDropItem", function(dropId)
    Drops[dropId] = nil
end)

RegisterNetEvent("inventory:client:DropItemAnim")
AddEventHandler("inventory:client:DropItemAnim", function()
    SendNUIMessage({
        action = "close",
    })
    RequestAnimDict("pickup_object")
    while not HasAnimDictLoaded("pickup_object") do
        Citizen.Wait(7)
    end
    TaskPlayAnim(PlayerPedId(), "pickup_object" ,"pickup_low" ,8.0, -8.0, -1, 1, 0, false, false, false )
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
end)


RegisterNetEvent('inventory:client:SetCurrentStash', function(stash)
    CurrentStash = stash
end)

RegisterNUICallback('getCombineItem', function(data, cb)
    cb(QBCore.Shared.Items[data.item])
end)

RegisterNetEvent("qb-inventory:marketData")
AddEventHandler("qb-inventory:marketData", function(data)
    if data then 
        currentMarket = data
    end
end)


RegisterNetEvent("lynx-dataSifirla")
AddEventHandler("lynx-dataSifirla", function()
    CurrentDrop = nil
    CurrentVehicle = nil
    CurrentGlovebox = nil
    otherPlayerId = nil
    CurrentStash = nil
end)

local bugFix = 0
RegisterNUICallback("CloseInventory", function(data, cb)
    if bugFix == 0 or GetGameTimer() > bugFix then 
        tolerans = GetGameTimer() + 200
        bugFix = GetGameTimer() + 170
        if CurrentVehicle ~= nil then
            CloseTrunk()
            TriggerServerEvent("inventory:server:SaveInventory", "trunk", CurrentVehicle)
            CurrentVehicle = nil
        elseif CurrentGlovebox ~= nil then
            TriggerServerEvent("inventory:server:SaveInventory", "glovebox", CurrentGlovebox)
            CurrentGlovebox = nil
        elseif CurrentStash ~= nil then
            TriggerServerEvent("inventory:server:SaveInventory", "stash", CurrentStash)
            CurrentStash = nil
        elseif otherPlayerId then
            TriggerServerEvent("inventory:server:SaveInventory", "otherPlayer", otherPlayerId)
            otherPlayerId = nil
        elseif currentMarket then 
            currentMarket = nil
        else
            if data.label == "Yer" then
                TriggerServerEvent("inventory:server:SaveInventory", "drop", CurrentDrop)
            else
                local CurrentDropNew = string.sub(data.label, 9)
                TriggerServerEvent("inventory:server:SaveInventory", "drop", tonumber(CurrentDropNew))
            end
            CurrentDrop = nil
        end
        SetCustomNuiFocus(false, false)
        inInventory = false
        TriggerScreenblurFadeOut(150)
    end
end)

RegisterNUICallback("UseItem", function(data, cb)
    TriggerServerEvent("inventory:server:UseItem", data.inventory, data.item)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'success', 0.2)
    TriggerEvent('env:kapat')
end)

RegisterNUICallback("combineItem", function(data)
    Citizen.Wait(150)
    TriggerServerEvent('inventory:server:combineItem', data.reward, data.fromItem, data.toItem)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[data.reward], 'add')
end)

RegisterNUICallback('combineWithAnim', function(data)
    local combineData = data.combineData
    local aDict = combineData.anim.dict
    local aLib = combineData.anim.lib
    local animText = combineData.anim.text
    local animTimeout = combineData.anim.timeOut

    QBCore.Functions.Progressbar("combine_anim", animText, animTimeout, false, true, {
        disableMovement = false,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = aDict,
        anim = aLib,
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
        TriggerServerEvent('inventory:server:combineItem', combineData.reward, data.requiredItem, data.usedItem)
        TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items[combineData.reward], 'add')
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), aDict, aLib, 1.0)
        QBCore.Functions.Notify("Canceled!", "error")
    end)
end)

RegisterNUICallback("SetInventoryData", function(data, cb)
    Citizen.Wait(0,50)
    TriggerServerEvent("inventory:server:SetInventoryData", data.fromInventory, data.toInventory, data.fromSlot, data.toSlot, data.fromAmount, data.toAmount)
    if data.sound then
        --PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
        TriggerEvent('InteractSound_CL:PlayOnOne', 'success', 0.2)
    end
end)

RegisterNUICallback("SetInventoryClotheData", function(data, cb)
    local remove = false
    if tonumber(data.toSlot) <= 30 then remove = true end
    if QBCore.Shared.SplitStr(data.toInventory, "-")[1] ~= "otherplayer" and QBCore.Shared.SplitStr(data.toInventory, "-")[1] ~= "player" then remove = true end
    if data.toInventory == data.fromInventory then
        local id = QBCore.Shared.SplitStr(data.fromInventory, "-")[1] == "player" and GetPlayerServerId(PlayerId()) or QBCore.Shared.SplitStr(data.fromInventory, "-")[2]
        TriggerServerEvent("qb-clothing:server:adjustfacewear", nil, data.data.info.clotheType, false, remove, data.data.info, id)
    elseif data.toInventory == "player" and QBCore.Shared.SplitStr(data.fromInventory, "-")[1] == "otherplayer" then
        TriggerServerEvent("qb-clothing:server:adjustfacewear", nil, data.data.info.clotheType, false, remove, data.data.info, QBCore.Shared.SplitStr(data.fromInventory, "-")[2])
    elseif data.fromInventory == "player" and QBCore.Shared.SplitStr(data.toInventory, "-")[1] == "otherplayer" then
        TriggerServerEvent("qb-clothing:server:adjustfacewear", nil, data.data.info.clotheType, false, remove, data.data.info, QBCore.Shared.SplitStr(data.toInventory, "-")[2])
    elseif QBCore.Shared.SplitStr(data.toInventory, "-")[1] ~= "player" and QBCore.Shared.SplitStr(data.fromInventory, "-")[1] == "player" and tonumber(data.fromSlot) > 30 then
        TriggerServerEvent("qb-clothing:server:adjustfacewear", nil, data.data.info.clotheType, false, remove, data.data.info, GetPlayerServerId(PlayerId()))
    elseif QBCore.Shared.SplitStr(data.toInventory, "-")[1] == "player" and tonumber(data.toSlot) > 30 then
        TriggerServerEvent("qb-clothing:server:adjustfacewear", nil, data.data.info.clotheType, false, remove, data.data.info, GetPlayerServerId(PlayerId()))
    end
    if data.sound then
        PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
    end
end)



RegisterNUICallback("PlayDropFail", function(data, cb)
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'fail', 0.2)
end)

function OpenTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "idle_d", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorOpen(vehicle, 4, false, false)
    else
        SetVehicleDoorOpen(vehicle, 5, false, false)
    end
end

function CloseTrunk()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "amb@prop_human_bum_bin@idle_b", "exit", 4.0, 4.0, -1, 50, 0, false, false, false)
    if (IsBackEngine(GetEntityModel(vehicle))) then
        SetVehicleDoorShut(vehicle, 4, false)
    else
        SetVehicleDoorShut(vehicle, 5, false)
    end
end

function IsBackEngine(vehModel)
    for _, model in pairs(BackEngineVehicles) do
        if GetHashKey(model) == vehModel then
            return true
        end
    end
    return false
end

local hotbar = false
local hotBarClosedByProgresBar = false
function ToggleHotbar(toggle)
    local playerData = QBCore.Functions.GetPlayerData()
    if playerData.items then
        if not hotbar then
            local HotbarItems = {
                [1] = playerData.items[1],
                [2] = playerData.items[2],
                [3] = playerData.items[3],
                [4] = playerData.items[4],
                [5] = playerData.items[5],
                [6] = playerData.items[6],
            } 

            if toggle then
                SendNUIMessage({
                    action = "toggleHotbar",
                    open = true,
                    items = HotbarItems
                })
            else
                SendNUIMessage({
                    action = "toggleHotbar",
                    open = false,
                })
            end
        end
    end
end

RegisterNetEvent("qb-inventory:progres-bar-ative")
AddEventHandler("qb-inventory:progres-bar-ative", function()
    if hotBarClosedByProgresBar then
        hotbar = true
        hotBarClosedByProgresBar = false
    elseif hotbar then
        hotbar = false
        hotBarClosedByProgresBar = true
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
end)

RegisterCommand("hotbar", function()
    if hotbar then
        SendNUIMessage({
            action = "toggleHotbar",
            open = false,
        })
    end
    hotbar = not hotbar
end)

RegisterCommand('envanterkapat', function()
    QBCore.Functions.Notify("Envanter Kapatılıyor", "info", 3000)
    Wait(2500)
    SetCustomNuiFocus(false, false)
    SendNUIMessage({
        action = "close"
    })
    QBCore.Functions.Notify("Envanter Kapatıldı", "success")
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if hotbar then
            local HotbarItems = {
                [1] = QBCore.Functions.GetPlayerData().items[1],
                [2] = QBCore.Functions.GetPlayerData().items[2],
                [3] = QBCore.Functions.GetPlayerData().items[3],
                [4] = QBCore.Functions.GetPlayerData().items[4],
                [5] = QBCore.Functions.GetPlayerData().items[5],
                [6] = QBCore.Functions.GetPlayerData().items[6],
            } 
        
            SendNUIMessage({
                action = "toggleHotbar",
                open = true,
                items = HotbarItems
            })
        end
    end
end)

function LoadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end


RegisterNetEvent("inventory:drop-weapon")
AddEventHandler("inventory:drop-weapon", function(item)
    if item then
        local weaponHash = GetHashKey(item)
        local _,wep = GetCurrentPedWeapon(PlayerPedId())

        if wep == weaponHash then
            SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
            RemoveAllPedWeapons(PlayerPedId(), true)
        end
    elseif IsPedArmed(PlayerPedId(), 7) then
        SetCurrentPedWeapon(PlayerPedId(), `WEAPON_UNARMED`, true)
        RemoveAllPedWeapons(PlayerPedId(), true)
    end
end)

RegisterNetEvent("qb-inventory:freeze-player")
AddEventHandler("qb-inventory:freeze-player", function()
    freezePlayer = not freezePlayer
end)

RegisterNetEvent("qb-inventory:set-other-player")
AddEventHandler("qb-inventory:set-other-player", function(playerId)
    otherPlayerId = playerId
end)

Citizen.CreateThread(function()
    while true do
        time = 500
        if freezePlayer then
            time = 1
            local playerPed = PlayerPedId()
            DisablePlayerFiring(playerPed, true)
            SetPedCanPlayGestureAnims(playerPed, false)
            
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 56, true) -- F9
    
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 22, true) -- Jump
            DisableControlAction(0, 44, true) -- Cover
            DisableControlAction(0, 37, true) -- Select Weapon
    
            DisableControlAction(0, 288,  true) --F1
            DisableControlAction(0, 289, true) -- F2
            DisableControlAction(0, 170, true) -- F3
            DisableControlAction(0, 167, true) -- F6

            DisableControlAction(0, 31, true) -- S
            DisableControlAction(0, 32, true) -- W
            DisableControlAction(0, 34, true) -- A
            DisableControlAction(0, 30, true) -- D
    
            DisableControlAction(0, 0, true) -- Disable changing view
            DisableControlAction(0, 26, true) -- Disable looking behind
            DisableControlAction(0, 73, true) -- Disable clearing animation
            DisableControlAction(2, 199, true) -- Disable pause screen
    
            DisableControlAction(0, 59, true) -- Disable steering in vehicle
            DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
            DisableControlAction(0, 72, true) -- Disable reversing in vehicle
    
            DisableControlAction(0, 47, true)  -- Disable weapon
            DisableControlAction(0, 264, true) -- Disable melee
            DisableControlAction(0, 257, true) -- Disable melee
            DisableControlAction(0, 140, true) -- Disable melee
            DisableControlAction(0, 141, true) -- Disable melee
            DisableControlAction(0, 142, true) -- Disable melee
            DisableControlAction(0, 143, true) -- Disable melee
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(0, 301, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
        end
        Citizen.Wait(time)
    end
end)  

function SetCustomNuiFocus(hasKeyboard, hasMouse)
    HasNuiFocus = hasKeyboard or hasMouse
    SetNuiFocus(hasKeyboard, hasMouse)
    TriggerEvent("tgiann-menuv3:nui-focus", HasNuiFocus, hasKeyboard, hasMouse)
end



RegisterNetEvent('qb-inventory:client:giveAnim', function()
    LoadAnimDict('mp_common')
    TaskPlayAnim(PlayerPedId(), 'mp_common', 'givetake1_b', 8.0, 1.0, -1, 16, 0, 0, 0, 0)
end)

RegisterNUICallback("GiveItem0", function(data, cb)
    local closestPlayer, closestDistance = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 3)
    local Players = {}

    local serverIds = {}
    for k, v in pairs(closestPlayer) do
        if GetPlayerPed(v) ~= PlayerPedId() then 
        table.insert(serverIds, GetPlayerServerId(v))
        end
    end

    QBCore.Functions.TriggerCallback('lj-inventory:server:GetClosePlayersName', function(players)
        for k, v in pairs(players) do
            local mask = GetPedDrawableVariation(GetPlayerPed(GetPlayerFromServerId(v.serverId)), 1)
            local isMask = false
            if mask > 0 then
                v.name = "Anonim"
                isMask = true
            end


            table.insert(Players, {props = v.name, id = v.serverId, isMask = isMask})
        end
        cb({Players = Players, Item = data.item})
        SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
    end, serverIds)
end)

RegisterNUICallback("GiveItem1", function(data, cb)
    local closestPlayer, closestDistance = QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), 3)
    for sayi, esc in pairs(closestPlayer) do
        if GetPlayerServerId(esc) == data.player then
            SetCurrentPedWeapon(PlayerPedId(),'WEAPON_UNARMED',true)
            TriggerServerEvent("inventory:server:GiveItem0", data.player, data.item, data.amount, data.item.slot, data.isMask)
            TriggerServerEvent('3dme:display', "" ..data.amount.. " Adet " ..data.item.label.. " Uzatır", QBCore.Key, "me", "self")
            break
        else
            QBCore.Functions.Notify("Yakınında kimse yok!", "error", 2500)
        end
    end
end)

