QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


QBCore.Functions.CreateCallback("weapons:server:LoadWeaponAmmo", function(source, cb)
	local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function(result)
        if result[1] ~= nil then
            local ammo = json.decode(result[1].ammo)
            cb(ammo)
        end
	end)
end)

RegisterServerEvent("weapons:server:SaveWeaponAmmo")
AddEventHandler('weapons:server:SaveWeaponAmmo', function(WeaponAmmo)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player ~= nil then
        QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerammo` WHERE `citizenid` = '".. Player.PlayerData.citizenid.."'", function(result)
            if result[1] == nil then
                QBCore.Functions.ExecuteSql(false, "INSERT INTO `playerammo` (`citizenid`, `ammo`) VALUES ('"..Player.PlayerData.citizenid.."', '"..json.encode(WeaponAmmo).."')")
            else
                QBCore.Functions.ExecuteSql(false, "UPDATE `playerammo` SET ammo='"..json.encode(WeaponAmmo).."' WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end)
    end
end)

RegisterServerEvent("weapons:server:remove-ammo-item")
AddEventHandler("weapons:server:remove-ammo-item", function(type)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if type == "AMMO_RIFLE" then
        xPlayer.Functions.RemoveItem("rifle_ammo", 1, xPlayer.Functions.GetItemByName("rifle_ammo").slot)
    elseif type == "AMMO_PISTOL" then
        xPlayer.Functions.RemoveItem("pistol_ammo", 1, xPlayer.Functions.GetItemByName("pistol_ammo").slot)
    elseif type == "AMMO_PISTOLRG" then
        xPlayer.Functions.RemoveItem("pistol_ammolrg", 1, xPlayer.Functions.GetItemByName("pistol_ammolrg").slot)
    elseif type == "AMMO_SMG" then
        xPlayer.Functions.RemoveItem("smg_ammo", 1, xPlayer.Functions.GetItemByName("smg_ammo").slot)
    elseif type == "AMMO_SHOTGUN" then
        xPlayer.Functions.RemoveItem("shotgun_ammo", 1, xPlayer.Functions.GetItemByName("shotgun_ammo").slot)
    elseif type == "AMMO_MG" then
        xPlayer.Functions.RemoveItem("mg_ammo", 1, xPlayer.Functions.GetItemByName("mg_ammo").slot)
    elseif type == "AMMO_SNIPER" then
        xPlayer.Functions.RemoveItem("snp_ammo", 1, xPlayer.Functions.GetItemByName("snp_ammo").slot)
    end
end)


RegisterServerEvent("weapons:server:remove-ammo-item-trow")
AddEventHandler("weapons:server:remove-ammo-item-trow", function(item)
    xPlayer.Functions.RemoveItem(item, 1, xPlayer.Functions.GetItemByName(item).slot)
end)

QBCore.Functions.CreateUseableItem("pistol_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOL", 15, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("pistol_ammolrg", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_PISTOLRG", 15, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("rifle_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_RIFLE", 30, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("smg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SMG", 20, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("shotgun_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SHOTGUN", 5, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("mg_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_MG", 50, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem("snp_ammo", function(source, item)
    TriggerClientEvent("weapon:client:AddAmmo", source, "AMMO_SNIPER", 7, QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('flashlight', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item, 'flashlight', QBCore.Key)
end)
 
QBCore.Functions.CreateUseableItem('grip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'grip', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('scope', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source,  item, 'scope', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('scope2', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source,  item, 'scope2', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('scope3', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source,  item, 'scope3', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('clip', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'clip', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle2', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle2', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle3', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle3', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle4', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle4', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle5', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle5', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle6', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle6', QBCore.Key)
end)

QBCore.Functions.CreateUseableItem('muzzle7', function(source, item)
    TriggerClientEvent('weapons:client:EquipAttachment', source, item,  'muzzle7', QBCore.Key)
end)

function HasAttachment(component, attachments)
    local retval = false
    local key = nil
    for k, v in pairs(attachments) do
        if v.label == component then
            key = k
            retval = true
        end
    end
    return retval, key
end

function GetAttachmentItem(weapon, component)
    local retval = nil
    for k, v in pairs(Config.WeaponAttachments[weapon]) do
        if v.component == component then
            retval = v.item
        end
    end
    return retval
end

RegisterServerEvent("weapons:server:EquipAttachment")
AddEventHandler("weapons:server:EquipAttachment", function(ItemData, CurrentWeaponData, AttachmentData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local GiveBackItem = nil
    if Inventory[CurrentWeaponData.slot] ~= nil then
        if Inventory[CurrentWeaponData.slot].info.attachments ~= nil and next(Inventory[CurrentWeaponData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentData.label, Inventory[CurrentWeaponData.slot].info.attachments)
            if not HasAttach then
                table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                    component = AttachmentData.component,
                    label = AttachmentData.label,
                })
                TriggerClientEvent("addAttachment", src, AttachmentData.component)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.RemoveItem(ItemData.name, 1)
                SetTimeout(1000, function()
                    TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
                end)
            else
                TriggerClientEvent("QBCore:Notify", src, "Silahıda Zaten "..AttachmentData.label:lower().." Eklentisi Takılı", "error", 3500)
            end
        else
            Inventory[CurrentWeaponData.slot].info.attachments = {}
            table.insert(Inventory[CurrentWeaponData.slot].info.attachments, {
                component = AttachmentData.component,
                label = AttachmentData.label,
            })
            TriggerClientEvent("addAttachment", src, AttachmentData.component)
            Player.Functions.SetInventory(Player.PlayerData.items)
            Player.Functions.RemoveItem(ItemData.name, 1)
            SetTimeout(1000, function()
                TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "remove")
            end)
        end
    end

    if GiveBackItem ~= nil then
        Player.Functions.AddItem(GiveBackItem, 1, false)
        GiveBackItem = nil
    end
end)

QBCore.Functions.CreateCallback('weapons:server:RemoveAttachment', function(source, cb, AttachmentData, ItemData)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Inventory = Player.PlayerData.items
    local AttachmentComponent = Config.WeaponAttachments[ItemData.name:upper()][AttachmentData.attachment]

    if Inventory[ItemData.slot] ~= nil then
        if Inventory[ItemData.slot].info.attachments ~= nil and next(Inventory[ItemData.slot].info.attachments) ~= nil then
            local HasAttach, key = HasAttachment(AttachmentComponent.label, Inventory[ItemData.slot].info.attachments)
            if HasAttach then
                table.remove(Inventory[ItemData.slot].info.attachments, key)
                Player.Functions.SetInventory(Player.PlayerData.items)
                Player.Functions.AddItem(AttachmentComponent.item, 1)
                print(json.encode(AttachmentComponent))
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[AttachmentComponent.item], "add")
                TriggerClientEvent("QBCore:Notify", src, "Sihından "..AttachmentComponent.label.." Eklentisi Çıkarıldı", "error")
                cb(Inventory[ItemData.slot].info.attachments)
            else
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end)