QBCore = nil
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Commands.Add("skin", "Ooohja toch", {}, false, function(source, args)
	TriggerClientEvent("qb-clothing:client:openMenu", source)
end, "admin")

QBCore.Commands.Add("ped", "Oyuncuya Ped Ver", {{name="id", help="Oyuncunun İD'si"}, {name="hash", help="Ped Hashi"}}, false, function(source, args)
	TriggerClientEvent("qb-clothing:client:ped", args[1], args[2])
end, "user")

RegisterServerEvent("qb-clothing:saveSkin")
AddEventHandler('qb-clothing:saveSkin', function(model, skin)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if model ~= nil and skin ~= nil then 
        QBCore.Functions.ExecuteSql(false, "DELETE FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."'", function()
            QBCore.Functions.ExecuteSql(false, "INSERT INTO `playerskins` (`citizenid`, `model`, `skin`, `active`) VALUES ('"..Player.PlayerData.citizenid.."', '"..model.."', '"..skin.."', 1)")
        end)
    end
end)

RegisterServerEvent("qb-clothes:loadPlayerSkin")
AddEventHandler('qb-clothes:loadPlayerSkin', function(health, armour)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    QBCore.Functions.ExecuteSql(false, "SELECT * FROM `playerskins` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `active` = 1", function(result)
        if result[1] ~= nil then
            TriggerClientEvent("qb-clothes:loadSkin", src, false, result[1].model, result[1].skin, health, armour)
        else
            TriggerClientEvent("qb-clothes:loadSkin", src, true)
        end
    end)
end)

RegisterServerEvent('qb-clothing:print')
AddEventHandler('qb-clothing:print', function(data)
    print(data)
end)

RegisterServerEvent('qb-clothing:giveItem')
AddEventHandler('qb-clothing:giveItem', function(data, type, prop, slot)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local info = {
        type = "clothe",
        data = data,
        clotheType = type,
        prop = prop
    }
    xPlayer.Functions.AddItem(type, 1, slot, info)
end)

RegisterServerEvent('qb-cloting:removeMoney')
AddEventHandler('qb-cloting:removeMoney', function(price)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    xPlayer.Functions.RemoveMoney('bank', price)
    TriggerClientEvent("QBCore:Notify", src, "Sepettekiler "..price.."$ Karşılığında Satın Alındı!")
end)
