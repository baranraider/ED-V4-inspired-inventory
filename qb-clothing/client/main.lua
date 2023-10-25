local firstConnect = false
local PlayerData = {}

QBCore = nil
Citizen.CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Citizen.Wait(200)
    end
end)

local creatingCharacter = false
local cam = -1
local berberMenu = false

RegisterCommand("yenile", function()
    if not IsPedSwimming(PlayerPedId()) and not IsEntityPlayingAnim(PlayerPedId(), "re@construction", "out_of_breath", 1) and not IsEntityInWater(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not exports["ox-bennys"]:inMechanicMenu() and not IsPedRagdoll(PlayerPedId()) then
        TriggerEvent("ox-hud:save")
        Citizen.Wait(500)
        TriggerEvent("qb-clothing:refresh")
        ClearPedScubaGearVariation(PlayerPedId())
    end
end)

local defaultHairMale = 0
local defaultHairFemale = 0
local oldHair = { item = -1, texture = -1 }
RegisterCommand("toka", function()
    local playerPed = PlayerPedId()
    oldHair.texture = GetPedHairColor(playerPed) 
    local defaultHair = defaultHairFemale
    if GetEntityModel(playerPed) == 1885233650 then defaultHair = defaultHairMale end -- Erkek Model
    if oldHair.item == -1 then oldHair.item = defaultHair end
    if oldHair.item == defaultHair then
        SetPedComponentVariation(playerPed, 2, defaultHair, 0, 0)
        oldHair.item = skinData["hair"].item
    else
        SetPedComponentVariation(playerPed, 2, oldHair.item, 0, 0)
        oldHair.item = defaultHair
    end
    SetPedHairColor(playerPed, oldHair.texture, oldHair.texture)
end)

RegisterNetEvent('qb-clothing:refresh')
AddEventHandler('qb-clothing:refresh', function()
    local playerPed = PlayerPedId()
    local health = GetEntityHealth(playerPed)
    local armour = GetPedArmour(playerPed)
    TriggerServerEvent("qb-clothes:loadPlayerSkin", health, armour)
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent("qb-clothes:loadPlayerSkin")
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

local blip = false
local aktifblipler = {}
RegisterNetEvent("esx_eden_clotheshop:blipAcKapa")
AddEventHandler("esx_eden_clotheshop:blipAcKapa", function()
	if blip then
		pasifblip()
		blip = false
	else
		aktifblip()
		blip = true
	end
end)

function aktifblip()
    for k=1, #Config.Stores do
        if Config.Stores[k].shopType == "clothing" and Config.Stores[k].blip then
            local clothingShop = AddBlipForCoord(Config.Stores[k].blipCoords.x, Config.Stores[k].blipCoords.y, 0.0)
            SetBlipSprite(clothingShop, 73)
            SetBlipColour(clothingShop, 46)
            SetBlipScale(clothingShop, 0.5)
            SetBlipAsShortRange(clothingShop, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Kıyafet Dükkanı")
            EndTextCommandSetBlipName(clothingShop)
            table.insert(aktifblipler, clothingShop)
        end
    end
end

function pasifblip()
	for i = 1, #aktifblipler do
		RemoveBlip(aktifblipler[i])
	end
    aktifblipler = {}
end

local blipBerber = false
local aktifbliplerBerber = {}
RegisterNetEvent("esx_barbershop:blipAcKapa")
AddEventHandler("esx_barbershop:blipAcKapa", function()
	if blipBerber then
		pasifblipBerber()
		blipBerber = false
	else
		aktifblipBerber()
		blipBerber = true
	end
end)

function aktifblipBerber()
    for k=1, #Config.Stores do
        if Config.Stores[k].shopType == "barber" and Config.Stores[k].blip then
            local barberShop = AddBlipForCoord(Config.Stores[k].blipCoords.x, Config.Stores[k].blipCoords.y, 0.0)
            SetBlipSprite(barberShop, 71)
            SetBlipColour(barberShop, 51)
            SetBlipScale  (barberShop, 0.5)
            SetBlipAsShortRange(barberShop, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Kuaför / Berber")
            EndTextCommandSetBlipName(barberShop)
            table.insert(aktifbliplerBerber, barberShop)
        end
	end
end

function pasifblipBerber()
	for i = 1, #aktifbliplerBerber do
		RemoveBlip(aktifbliplerBerber[i])
	end
    aktifbliplerBerber = {}
end

RegisterNetEvent("qb-clothing:client:ped")
AddEventHandler("qb-clothing:client:ped", function(ped)
    local model = (type(tonumber(ped))=="number" and ped or GetHashKey(ped))
	local playerPed = PlayerPedId()
	if IsModelValid(model) then
		local player = PlayerId()
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)
        SetPedRandomProps(playerPed)
        SetPedRandomComponentVariation(playerPed, false)
        SetEntityMaxHealth(playerPed, 200)
        SetEntityHealth(playerPed, 200)
        SetModelAsNoLongerNeeded(model)
        TriggerServerEvent("qb-clothing:saveSkin", GetEntityModel(PlayerPedId()), json.encode(skinData))
	end
end)

local jobClothing = false
local room = {}
exports('checkclothe', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    for i=1, #Config.Stores do
        if Config.Stores[i].zone:isPointInside(pos) then
            room = Config.Stores[i]
            jobClothing = false
            if room.shopType == "barber" then
                return {false, true}
            else
                return {true, false}
            end
        end
    end

    for i=1, #Config.ClothingRooms do
        if Config.ClothingRooms[i].zone:isPointInside(pos) then
            if PlayerData.job.name == Config.ClothingRooms[i].requiredJob then
                room = Config.ClothingRooms[i]
                jobClothing = true
                return {true, false}
            end
        end
    end

    return {false, false} 
end)

RegisterNetEvent("qb-clothing:open")
AddEventHandler("qb-clothing:open", function(ped)
    if jobClothing then
        local gender = "male"
        openMenu({
            {menu = "character", label = "Kıyafet", selected = true},
            {menu = "accessoires", label = "Aksesuar", selected = false},
        })
    else
        if room.shopType == "clothing" then
            TriggerServerEvent("ra1derBase:KullanciPara", QBCore.Key, "sil", "banka", 10) -- farklı bir base kullanıyorsanız editlemeniz gerekir
            openMenu({
                {menu = "character", label = "Kıyafet", selected = true},
                {menu = "accessoires", label = "Aksesuar", selected = false},
            })
        elseif room.shopType == "barber" then
            berberMenu = true
            TriggerServerEvent("ra1derBase:KullanciPara", QBCore.Key, "sil", "banka", 10) --farklı bir base kullanıyorsanız editlemeniz gerekir
            openMenu({
                {menu = "clothing", label = "Saç / Makyaj", selected = true},
            })
        end
    end
end)

RegisterCommand("menuac", function()
    openMenu({
        {menu = "character", label = "Kıyafet", selected = true},
        {menu = "accessoires", label = "Aksesuar", selected = false},
    })
end)

RegisterNUICallback('rotateRight', function()
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    SetEntityHeading(ped, heading + 10)
end)

RegisterNUICallback('rotateLeft', function()
    local ped = PlayerPedId()
    local heading = GetEntityHeading(ped)
    SetEntityHeading(ped, heading - 10)
end)

RegisterNUICallback('handsUp', function()
    TriggerEvent("ox-thieff:hands-up")
end)

RegisterNetEvent('qb-clothing:client:openMenu')
AddEventHandler('qb-clothing:client:openMenu', function()
    openMenu({
        {menu = "facefeature", label = "Yüz"       , selected = true  },
        {menu = "character"  , label = "Kıyafet"   , selected = false },
        {menu = "clothing"   , label = "Saç/Makyaj", selected = false },
        {menu = "accessoires", label = "Aksesuar"  , selected = false },
    })
end)

function GetMaxValues()
    maxModelValues         ={
        ["arms"]           ={type = "character"  , item = 0, texture = 0 },
        ["t-shirt"]        ={type = "character"  , item = 0, texture = 0 },
        ["torso2"]         ={type = "character"  , item = 0, texture = 0 },
        ["pants"]          ={type = "character"  , item = 0, texture = 0 },
        ["shoes"]          ={type = "character"  , item = 0, texture = 0 },
        ["vest"]           ={type = "character"  , item = 0, texture = 0 },
        ["accessory"]      ={type = "character"  , item = 0, texture = 0 },
        ["decals"]         ={type = "character"  , item = 0, texture = 0 },
        ["bag"]            ={type = "character"  , item = 0, texture = 0 },
        ["hair"]           ={type = "hair"       , item = 0, texture = 0 },
        ["eyebrows"]       ={type = "hair"       , item = 0, texture = 0 },
        ["beard"]          ={type = "hair"       , item = 0, texture = 0 },
        ["blush"]          ={type = "hair"       , item = 0, texture = 0 },
        ["lipstick"]       ={type = "hair"       , item = 0, texture = 0 },
        ["makeup"]         ={type = "hair"       , item = 0, texture = 0 },
        ["mask"]           ={type = "accessoires", item = 0, texture = 0 },
        ["hat"]            ={type = "accessoires", item = 0, texture = 0 },
        ["glass"]          ={type = "accessoires", item = 0, texture = 0 },
        ["ear"]            ={type = "accessoires", item = 0, texture = 0 },
        ["watch"]          ={type = "accessoires", item = 0, texture = 0 },
        ["bracelet"]       ={type = "accessoires", item = 0, texture = 0 },
        ["ageing"]         ={type = "facefeature", item = 0, texture = 0 },
        ["Mother"]         ={type = "facefeature", item = 21 },
        ["Father"]         ={type = "facefeature", item = 23 },
        ["shapeMix"]       ={type = "facefeature", item = 10 },
        ["skinColor"]      ={type = "facefeature", item = 12 },
        ["FaceFeature0"]   ={type = "facefeature", item = 20 },
        ["FaceFeature1"]   ={type = "facefeature", item = 20 },
        ["FaceFeature2"]   ={type = "facefeature", item = 20 },
        ["FaceFeature3"]   ={type = "facefeature", item = 20 },
        ["FaceFeature4"]   ={type = "facefeature", item = 20 },
        --["FaceFeature5"] ={type = "facefeature", item = 20 },
        ["FaceFeature6"]   ={type = "facefeature", item = 20 },
        ["FaceFeature7"]   ={type = "facefeature", item = 20 },
        ["FaceFeature8"]   ={type = "facefeature", item = 20 },
        ["FaceFeature9"]   ={type = "facefeature", item = 20 },
        ["FaceFeature10"]  ={type = "facefeature", item = 20 },
        ["EyeColor"]       ={type = "facefeature", item = 32 },
        ["FaceFeature12"]  ={type = "facefeature", item = 20 },
        ["FaceFeature13"]  ={type = "facefeature", item = 20 },
        ["FaceFeature14"]  ={type = "facefeature", item = 20 },
        ["FaceFeature15"]  ={type = "facefeature", item = 20 },
        ["FaceFeature16"]  ={type = "facefeature", item = 20 },
        ["FaceFeature17"]  ={type = "facefeature", item = 20 },
        ["FaceFeature18"]  ={type = "facefeature", item = 20 },
        ["FaceFeature19"]  ={type = "facefeature", item = 20 },
    }
    local ped = PlayerPedId()
    for k, v in pairs(clothingCategorys) do
        if v.type == "variation" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id) - 1
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) -1
        end
        
        if v.type == "hair" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id) - 1
            maxModelValues[k].texture = 45
        end

        if v.type == "mask" then
            maxModelValues[k].item = GetNumberOfPedDrawableVariations(ped, v.id) - 1
            maxModelValues[k].texture = GetNumberOfPedTextureVariations(ped, v.id, GetPedDrawableVariation(ped, v.id)) - 1
        end

        --[[ if v.type == "face" then
            maxModelValues[k].item = 44
            maxModelValues[k].texture = 15
        end ]]

        if v.type == "ageing" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id) - 1
            maxModelValues[k].texture = 0
        end

        if v.type == "overlay" then
            maxModelValues[k].item = GetNumHeadOverlayValues(v.id) - 1
            maxModelValues[k].texture = 45
        end

        if v.type == "prop" then
            maxModelValues[k].item = GetNumberOfPedPropDrawableVariations(ped, v.id) - 1
            maxModelValues[k].texture = GetNumberOfPedPropTextureVariations(ped, v.id, GetPedPropIndex(ped, v.id)) - 1
        end
    end

    SendNUIMessage({
        action = "updateMax",
        maxValues = maxModelValues
    })
end

function openMenu(allowedMenus)
    if not exports["ra1derBase"]:soygun() then  --farklı bir base kullanıyorsanız editlemeniz gerekir
        previousSkinData = json.encode(skinData)
        creatingCharacter = true

        local PlayerData = QBCore.Functions.GetPlayerData()
        local trackerMeta = false --PlayerData.metadata["tracker"]
        GetMaxValues()
        SendNUIMessage({
            action = "open",
            firstConnect = firstConnect,
            menus = allowedMenus,
            currentClothing = skinData,
            hasTracker = trackerMeta,
            berberMenu = berberMenu
        })
        SetNuiFocus(true, true)
        SetCursorLocation(0.9, 0.25)

        QBCore.Shared.RequestAnimDict('anim@amb@clubhouse@mini@darts@', function() -- animasyon oynatma
            TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@mini@darts@" , "wait_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
        end)

        FreezeEntityPosition(PlayerPedId(), true)

        enableCam()
    else
        QBCore.Functions.Notify("Bir soygun olayına karıştığın için şuan kıyafet satın alamazsın veya üstünü değiştiremezsin", "error", 15000)
    end
end

RegisterNUICallback('TrackerError', function()
    TriggerEvent('chatMessage', "SYSTEM", "error", "Je kan je enkelband niet weghalen..")
end)

RegisterNetEvent('qb-clothing:client:reloadOutfits')
AddEventHandler('qb-clothing:client:reloadOutfits', function(myOutfits)
    SendNUIMessage({
        action = "reloadMyOutfits",
        outfits = myOutfits
    })
end)

RegisterNUICallback("PlaySound", function(data, cb)
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

function enableCam()
    RenderScriptCams(false, false, 0, 1, 0)
    DestroyCam(cam, false)
    if(not DoesCamExist(cam)) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 0, true, true)
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + -0.1)
    end
end

RegisterNUICallback('rotateCam', function(data)
    local ped = PlayerPedId()
    local rotType = data.type
    local value = data.camValue
    if rotType == "left" then
        SetEntityHeading(ped, GetEntityHeading(ped) - 10)
        if value == 1 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z + 0.65)
        elseif value == 2 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        elseif value == 3 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z + -0.5)
        else
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z -0.1)
        end
    else
        SetEntityHeading(ped, GetEntityHeading(ped) + 10)
        if value == 1 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z + 0.65)
        elseif value == 2 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
        elseif value == 3 then
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z -0.5)
        else
            local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
            SetCamCoord(cam, coords.x, coords.y, coords.z -0.1)
        end
    end
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(ped) + 180)
end)

RegisterNUICallback('setupCam', function(data)
    local value = data.value
    if value == 1 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 0.75, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.65)
    elseif value == 2 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z + 0.2)
    elseif value == 3 then
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 1.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z -0.5)
    else
        local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0, 2.0, 0)
        SetCamCoord(cam, coords.x, coords.y, coords.z -0.1)
    end
    SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()) + 180)
end)

Citizen.CreateThread(function() 
	while true do
		InvalidateIdleCam()
		N_0x9e4cfff989258472() --Disable the vehicle idle camera
		Wait(1000) --The idle camera activates after 30 second so we don't need to call this per frame
	end 
end)

function disableCam()
    RenderScriptCams(false, true, 250, 1, 0)
    DestroyCam(cam, false)

    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())
end

function closeMenu()
    SendNUIMessage({action = "close"})
    disableCam()
end

function resetClothing(data)
    local ped = PlayerPedId()

    -- Pants
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)

    -- Hair
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)

    -- Eyebrows
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)

    -- Beard
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)

    -- Blush
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)

    -- Lipstick
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].item, 0)

    -- Makeup
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)

    -- Ageing
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)

    -- Arms
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)

    -- T-Shirt
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)

    -- Vest
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)

    -- Torso 2
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)

    -- Shoes
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)

    -- Mask
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)

    -- Badge
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)

    -- Accessory
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)

    -- Bag
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    -- Hat
    if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
        SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
    else
        ClearPedProp(ped, 0)
    end

    -- Glass
    if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
        SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
    else
        ClearPedProp(ped, 1)
    end

    -- Ear
    if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
        SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
    else
        ClearPedProp(ped, 2)
    end

    -- Watch
    if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
        SetPedPropIndex(ped, 6, data["watch"].item, data["watch"].texture, true)
    else
        ClearPedProp(ped, 6)
    end

    -- Bracelet
    if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
        SetPedPropIndex(ped, 7, data["bracelet"].item, data["bracelet"].texture, true)
    else
        ClearPedProp(ped, 7)
    end
end

RegisterNUICallback('close', function()
    if firstConnect then 
        buyyAllClothes()
        firstConnect = false 
    else
        skinData = json.decode(previousSkinData)
        resetClothing(skinData)
        previousSkinData = {}
    end
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
    FreezeEntityPosition(PlayerPedId(), false)
end)

RegisterNUICallback('getCatergoryItems', function(data, cb)
    cb(Config.Menus[data.category])
end)

RegisterNUICallback('updateSkin', function(data)
    ChangeVariation(data)
end)

RegisterNUICallback('updateSkinOnInput', function(data)
    ChangeVariation(data)
end)

function f(n)
	n = n + 0.00000
	return n
end

function ChangeVariation(data)
    local ped = PlayerPedId()
    local clothingCategory = data.clothingType
    local type = data.type
    local item = data.articleNumber

    if clothingCategory == "EyeColor" then
        if type == "item" then
            SetPedEyeColor(ped, item)
            skinData[clothingCategory].item = item
        end

    elseif clothingCategory == "Mother" then
        if type == "item" then
            item = item + 21
            if item == 42 then
                item = 45
            end
            SetPedHeadBlendData(ped, skinData["Father"].item, item, 0, skinData["skinColor"].item, 0, 0, f(skinData["shapeMix"].item/10), 0.0, 0.0, false)
            skinData[clothingCategory].item = item
        end 
    elseif clothingCategory == "Father" then
        if type == "item" then
            item = item
            if item == 21 then
                item = 42
            elseif item == 22 then
                item = 43
            elseif item == 23 then
                item = 44
            end
            SetPedHeadBlendData(ped, item, skinData["Mother"].item, 0, skinData["skinColor"].item, 0, 0, f(skinData["shapeMix"].item/10), 0.0, 0.0, false)
            skinData[clothingCategory].item = item
        end 
    elseif clothingCategory == "shapeMix" then
        if type == "item" then
            SetPedHeadBlendData(ped, skinData["Father"].item, skinData["Mother"].item, 0, skinData["skinColor"].item, 0, 0, f((item)/10), 0.0, 0.0, false)
            skinData[clothingCategory].item = item
        end 
    elseif clothingCategory == "skinColor" then
        if type == "item" then
            SetPedHeadBlendData(ped, skinData["Father"].item, skinData["Mother"].item, 0, item, 0, 0, f(skinData["shapeMix"].item/10), 0.0, 0.0, false)
            skinData[clothingCategory].item = item
        end 

    elseif clothingCategory == "FaceFeature0" then
        if type == "item" then
            SetPedFaceFeature(ped, 0, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature1" then
        if type == "item" then
            SetPedFaceFeature(ped, 1, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature2" then
        if type == "item" then
            SetPedFaceFeature(ped, 2, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature3" then
        if type == "item" then
            SetPedFaceFeature(ped, 3, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature4" then
        if type == "item" then
            SetPedFaceFeature(ped, 4, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature5" then
        if type == "item" then
            SetPedFaceFeature(ped, 5, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature6" then
        if type == "item" then
            SetPedFaceFeature(ped, 6, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature7" then
        if type == "item" then
            SetPedFaceFeature(ped, 7, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature8" then
        if type == "item" then
            SetPedFaceFeature(ped, 8, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature9" then
        if type == "item" then
            SetPedFaceFeature(ped, 9, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature10" then
        if type == "item" then
            SetPedFaceFeature(ped, 10, (item - 10)/10)
            skinData[clothingCategory].item = item
        end

    elseif clothingCategory == "FaceFeature12" then
        if type == "item" then
            SetPedFaceFeature(ped, 12, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature13" then
        if type == "item" then
            SetPedFaceFeature(ped, 13, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature14" then
        if type == "item" then
            SetPedFaceFeature(ped, 14, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature15" then
        if type == "item" then
            SetPedFaceFeature(ped, 15, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature16" then
        if type == "item" then
            SetPedFaceFeature(ped, 16, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature17" then
        if type == "item" then
            SetPedFaceFeature(ped, 17, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature18" then
        if type == "item" then
            SetPedFaceFeature(ped, 18, (item - 10)/10)
            skinData[clothingCategory].item = item
        end
    elseif clothingCategory == "FaceFeature19" then
        if type == "item" then
            SetPedFaceFeature(ped, 19, (item - 10)/10)
            skinData[clothingCategory].item = item
        end

        -- Eski
    elseif clothingCategory == "pants" then
        if type == "item" then
            SetPedComponentVariation(ped, 4, item, 0, 0)
            skinData["pants"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 4)
            SetPedComponentVariation(ped, 4, curItem, item, 0)
            skinData["pants"].texture = item
        end
    elseif clothingCategory == "hair" then
        SetPedHeadBlendData(ped, skinData["Father"].item, skinData["Mother"].item, 0, skinData["skinColor"].item, 0, 0, f(skinData["shapeMix"].item/10), 0.0, 0.0, false)
        if type == "item" then
            SetPedComponentVariation(ped, 2, item, 0, 0)
            skinData["hair"].item = item
        elseif type == "texture" then
            SetPedHairColor(PlayerPedId(), item, item)
            skinData["hair"].texture = item
        end
    elseif clothingCategory == "eyebrows" then
        if type == "item" then
            SetPedHeadOverlay(ped, 2, item, 1.0)
            skinData["eyebrows"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 2, 1, item, 0)
            skinData["eyebrows"].texture = item
        end
    elseif clothingCategory == "beard" then
        if type == "item" then
            SetPedHeadOverlay(ped, 1, item, 1.0)
            skinData["beard"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 1, 1, item, 0)
            skinData["beard"].texture = item
        end
    elseif clothingCategory == "blush" then
        if type == "item" then
            SetPedHeadOverlay(ped, 5, item, 1.0)
            skinData["blush"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 5, 1, item, 0)
            skinData["blush"].texture = item
        end
    elseif clothingCategory == "lipstick" then
        if type == "item" then
            SetPedHeadOverlay(ped, 8, item, 1.0)
            skinData["lipstick"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 8, 1, item, 0)
            skinData["lipstick"].texture = item
        end
    elseif clothingCategory == "makeup" then
        if type == "item" then
            SetPedHeadOverlay(ped, 4, item, 1.0)
            skinData["makeup"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 4, 1, item, 0)
            skinData["makeup"].texture = item
        end
    elseif clothingCategory == "ageing" then
        if type == "item" then
            SetPedHeadOverlay(ped, 3, item, 1.0)
            skinData["ageing"].item = item
        elseif type == "texture" then
            SetPedHeadOverlayColor(ped, 3, 1, item, 0)
            skinData["ageing"].texture = item
        end
    elseif clothingCategory == "arms" then
        if type == "item" then
            SetPedComponentVariation(ped, 3, item, 0, 2)
            skinData["arms"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 3)
            SetPedComponentVariation(ped, 3, curItem, item, 0)
            skinData["arms"].texture = item
        end
    elseif clothingCategory == "t-shirt" then
        if type == "item" then
            SetPedComponentVariation(ped, 8, item, 0, 2)
            skinData["t-shirt"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 8)
            SetPedComponentVariation(ped, 8, curItem, item, 0)
            skinData["t-shirt"].texture = item
        end
    elseif clothingCategory == "vest" then
        if type == "item" then
            SetPedComponentVariation(ped, 9, item, 0, 2)
            skinData["vest"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 9, skinData["vest"].item, item, 0)
            skinData["vest"].texture = item
        end
    elseif clothingCategory == "bag" then
        if type == "item" then
            SetPedComponentVariation(ped, 5, item, 0, 2)
            skinData["bag"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 5, skinData["bag"].item, item, 0)
            skinData["bag"].texture = item
        end
    elseif clothingCategory == "decals" then
        if type == "item" then
            SetPedComponentVariation(ped, 10, item, 0, 2)
            skinData["decals"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 10, skinData["decals"].item, item, 0)
            skinData["decals"].texture = item
        end
    elseif clothingCategory == "accessory" then
        if type == "item" then
            SetPedComponentVariation(ped, 7, item, 0, 2)
            skinData["accessory"].item = item
        elseif type == "texture" then
            SetPedComponentVariation(ped, 7, skinData["accessory"].item, item, 0)
            skinData["accessory"].texture = item
        end
    elseif clothingCategory == "torso2" then
        if type == "item" then
            SetPedComponentVariation(ped, 11, item, 0, 2)
            skinData["torso2"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 11)
            SetPedComponentVariation(ped, 11, curItem, item, 0)
            skinData["torso2"].texture = item
        end
    elseif clothingCategory == "shoes" then
        if type == "item" then
            SetPedComponentVariation(ped, 6, item, 0, 2)
            skinData["shoes"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 6)
            SetPedComponentVariation(ped, 6, curItem, item, 0)
            skinData["shoes"].texture = item
        end
    elseif clothingCategory == "mask" then
        if type == "item" then
            SetPedComponentVariation(ped, 1, item, 0, 2)
            skinData["mask"].item = item
        elseif type == "texture" then
            local curItem = GetPedDrawableVariation(ped, 1)
            SetPedComponentVariation(ped, 1, curItem, item, 0)
            skinData["mask"].texture = item
        end
    elseif clothingCategory == "hat" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 0, item, skinData["hat"].texture, true)
            else
                ClearPedProp(ped, 0)
            end
            skinData["hat"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 0, skinData["hat"].item, item, true)
            skinData["hat"].texture = item
        end
    elseif clothingCategory == "glass" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 1, item, skinData["glass"].texture, true)
                skinData["glass"].item = item
            else
                ClearPedProp(ped, 1)
            end
        elseif type == "texture" then
            SetPedPropIndex(ped, 1, skinData["glass"].item, item, true)
            skinData["glass"].texture = item
        end
    elseif clothingCategory == "ear" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 2, item, skinData["ear"].texture, true)
            else
                ClearPedProp(ped, 2)
            end
            skinData["ear"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 2, skinData["ear"].item, item, true)
            skinData["ear"].texture = item
        end
    elseif clothingCategory == "watch" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 6, item, skinData["watch"].texture, true)
            else
                ClearPedProp(ped, 6)
            end
            skinData["watch"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 6, skinData["watch"].item, item, true)
            skinData["watch"].texture = item
        end
    elseif clothingCategory == "bracelet" then
        if type == "item" then
            if item ~= -1 then
                SetPedPropIndex(ped, 7, item, skinData["bracelet"].texture, true)
            else
                ClearPedProp(ped, 7)
            end
            skinData["bracelet"].item = item
        elseif type == "texture" then
            SetPedPropIndex(ped, 7, skinData["bracelet"].item, item, true)
            skinData["bracelet"].texture = item
        end
    end

    GetMaxValues()
end

function LoadPlayerModel(skin)
    RequestModel(skin)
    while not HasModelLoaded(skin) do
        Citizen.Wait(0)
    end
end

local blockedPeds = {
    "mp_m_freemode_01",
    "mp_f_freemode_01",
}

function isPedAllowedRandom(skin)
    local retval = false
    for k, v in pairs(blockedPeds) do
        if v ~= skin then
            retval = true
        end
    end
    return retval
end

function ChangeToSkinNoUpdate(skin)
    local ped = PlayerPedId()
    local model = GetHashKey(skin)
    SetEntityInvincible(ped, true)
    if IsModelInCdimage(model) and IsModelValid(model) then
        LoadPlayerModel(model)
        SetPlayerModel(PlayerId(), model)

        if isPedAllowedRandom() then
            SetPedRandomComponentVariation(ped, true)
        end
        
        SendNUIMessage({action = "toggleChange", allow = true})
		SetModelAsNoLongerNeeded(model)
	end
    SetEntityInvincible(ped, false)
    TriggerEvent('qb-clothing:client:loadPlayerClothing', skinData, PlayerPedId())
    GetMaxValues()
end

RegisterNUICallback('setCurrentPed', function(data, cb)
    local playerData = QBCore.Functions.GetPlayerData()

    if playerData.charinfo.gender == 0 then
        cb(Config.ManPlayerModels[data.ped])
        ChangeToSkinNoUpdate(Config.ManPlayerModels[data.ped])
    else
        cb(Config.WomanPlayerModels[data.ped])
        ChangeToSkinNoUpdate(Config.WomanPlayerModels[data.ped])
    end
end)

RegisterNUICallback('buy', function(data)
    if firstConnect then 
        buyyAllClothes()
        firstConnect = false 
    else
        if berberMenu then
            berberMenu = false
        else
            TriggerServerEvent("qb-cloting:removeMoney", data.price)
            for type,active in pairs(data.data) do
                if active then
                    TriggerEvent("qb-clothing:client:adjustfacewear", false, type, true)
                end
            end
            skinData = json.decode(previousSkinData)
            resetClothing(skinData)
        end
    end
    SetNuiFocus(false, false)
    creatingCharacter = false
    disableCam()
    FreezeEntityPosition(PlayerPedId(), false)
    TriggerServerEvent("qb-clothing:saveSkin", GetEntityModel(PlayerPedId()), json.encode(skinData))
end)

RegisterNetEvent('qb-clothes:client:CreateFirstCharacter')
AddEventHandler('qb-clothes:client:CreateFirstCharacter', function()
    local ped = PlayerPedId()
    local pos = vector3(-795.57, 331.79, 200.42)
    FreezeEntityPosition(ped, true)
    SetEntityCoords(ped, pos.x, pos.y, pos.z)
    SetEntityHeading(ped, 87.0)
    TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
    TriggerEvent('QBCore:Client:OnPlayerLoaded')
    TriggerEvent("ra1derBase:afk-control", false) --farklı bir base kullanıyorsanız editlemeniz gerekir
    
    RenderScriptCams(false, true, 500, true, true)
    SetEntityVisible(PlayerPedId(), true)
    Citizen.Wait(500)
    DoScreenFadeIn(250)
    firstConnect = true
    Citizen.CreateThread(function()
        while firstConnect do
            Citizen.Wait(1)
            if not IsEntityPlayingAnim(PlayerPedId(), "anim@amb@clubhouse@mini@darts@", "wait_idle", 3) then
                QBCore.Shared.RequestAnimDict('anim@amb@clubhouse@mini@darts@', function() -- animasyon oynatma
                    TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@mini@darts@" , "wait_idle", 8.0, 1.0, -1, 1, 0, 0, 0, 0 )
                end)
            end

            for _, player in ipairs(GetActivePlayers()) do
                if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                    NetworkFadeInEntity(GetPlayerPed(player),true)
               end
            end
        end
        for _, player in ipairs(GetActivePlayers()) do
            if player ~= PlayerId() and NetworkIsPlayerActive(player) then
                NetworkFadeOutEntity(GetPlayerPed(player),false)
            end
        end
        local playerPed = PlayerPedId()
        DoScreenFadeOut(1000)
        while not IsScreenFadedOut() do Citizen.Wait(100) end
        SetEntityCoords(playerPed, 435.99, -644.68, 27.74)
        SetEntityHeading(playerPed, 86.23)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearPedTasksImmediately(playerPed)
        FreezeEntityPosition(playerPed, false)
        TriggerEvent("ra1derBase:afk-control", true) --farklı bir base kullanıyorsanız editlemeniz gerekir
    end)

    QBCore.Functions.GetPlayerData(function(PlayerData)
        local skin = "mp_m_freemode_01"
        openMenu({
            {menu = "facefeature", label = "Yüz"       , selected = true  },
            {menu = "character"  , label = "Kıyafet"   , selected = false },
            {menu = "clothing"   , label = "Saç/Makyaj", selected = false },
            {menu = "accessoires", label = "Aksesuar"  , selected = false },
        })

        if PlayerData.charinfo.gender == 1 then 
            skin = "mp_f_freemode_01" 
        end
        
        ChangeToSkinNoUpdate(skin)
        --SendNUIMessage({action = "ResetValues"})
    end)
end)

RegisterNetEvent("qb-clothes:loadSkin")
AddEventHandler("qb-clothes:loadSkin", function(new, model, data, health, amour)
    model = model ~= nil and tonumber(model) or false
	SetEntityInvincible(PlayerPedId(),true)
    if IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
            Citizen.Wait(0)
		end
        SetPlayerModel(PlayerId(), model)

        SetModelAsNoLongerNeeded(model)

        SetEntityInvincible(PlayerPedId(),false)
    
        data = json.decode(data)
        
        TriggerEvent('qb-clothing:client:loadPlayerClothing', data, PlayerPedId(), health, amour)
	end
end)

RegisterNetEvent('qb-clothing:client:loadPlayerClothing')
AddEventHandler('qb-clothing:client:loadPlayerClothing', function(data, ped, health, armour, fristLogin)
    if ped == nil then ped = PlayerPedId() end
    for i = 0, 11 do
        SetPedComponentVariation(ped, i, 0, 0, 0)
    end

    for i = 0, 7 do
        ClearPedProp(ped, i)
    end

    -- Face
    SetPedHeadBlendData(ped, data["Father"].item, data["Mother"].item, 0, data["skinColor"].item, 0, 0, f(data["shapeMix"].item/10), 0.0, 0.0, false)

    -- Pants
    SetPedComponentVariation(ped, 4, data["pants"].item, 0, 0)
    SetPedComponentVariation(ped, 4, data["pants"].item, data["pants"].texture, 0)

    -- Hair
    SetPedComponentVariation(ped, 2, data["hair"].item, 0, 0)
    SetPedHairColor(ped, data["hair"].texture, data["hair"].texture)

    -- Eyebrows
    SetPedHeadOverlay(ped, 2, data["eyebrows"].item, 1.0)
    SetPedHeadOverlayColor(ped, 2, 1, data["eyebrows"].texture, 0)

    -- Beard
    SetPedHeadOverlay(ped, 1, data["beard"].item, 1.0)
    SetPedHeadOverlayColor(ped, 1, 1, data["beard"].texture, 0)

    -- Blush
    SetPedHeadOverlay(ped, 5, data["blush"].item, 1.0)
    SetPedHeadOverlayColor(ped, 5, 1, data["blush"].texture, 0)

    -- Lipstick
    SetPedHeadOverlay(ped, 8, data["lipstick"].item, 1.0)
    SetPedHeadOverlayColor(ped, 8, 1, data["lipstick"].texture, 0)

    -- Makeup
    SetPedHeadOverlay(ped, 4, data["makeup"].item, 1.0)
    SetPedHeadOverlayColor(ped, 4, 1, data["makeup"].texture, 0)

    -- Ageing
    SetPedHeadOverlay(ped, 3, data["ageing"].item, 1.0)
    SetPedHeadOverlayColor(ped, 3, 1, data["ageing"].texture, 0)

    -- Arms
    SetPedComponentVariation(ped, 3, data["arms"].item, 0, 2)
    SetPedComponentVariation(ped, 3, data["arms"].item, data["arms"].texture, 0)

    -- T-Shirt
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, 0, 2)
    SetPedComponentVariation(ped, 8, data["t-shirt"].item, data["t-shirt"].texture, 0)

    -- Vest
    SetPedComponentVariation(ped, 9, data["vest"].item, 0, 2)
    SetPedComponentVariation(ped, 9, data["vest"].item, data["vest"].texture, 0)

    -- Torso 2
    SetPedComponentVariation(ped, 11, data["torso2"].item, 0, 2)
    SetPedComponentVariation(ped, 11, data["torso2"].item, data["torso2"].texture, 0)

    -- Shoes
    SetPedComponentVariation(ped, 6, data["shoes"].item, 0, 2)
    SetPedComponentVariation(ped, 6, data["shoes"].item, data["shoes"].texture, 0)

    -- Mask
    SetPedComponentVariation(ped, 1, data["mask"].item, 0, 2)
    SetPedComponentVariation(ped, 1, data["mask"].item, data["mask"].texture, 0)

    -- Badge
    SetPedComponentVariation(ped, 10, data["decals"].item, 0, 2)
    SetPedComponentVariation(ped, 10, data["decals"].item, data["decals"].texture, 0)

    -- Accessory
    SetPedComponentVariation(ped, 7, data["accessory"].item, 0, 2)
    SetPedComponentVariation(ped, 7, data["accessory"].item, data["accessory"].texture, 0)

    -- Bag
    SetPedComponentVariation(ped, 5, data["bag"].item, 0, 2)
    SetPedComponentVariation(ped, 5, data["bag"].item, data["bag"].texture, 0)

    -- Hat
    if data["hat"].item ~= -1 and data["hat"].item ~= 0 then
        SetPedPropIndex(ped, 0, data["hat"].item, data["hat"].texture, true)
    else
        ClearPedProp(ped, 0)
    end

    -- Glass
    if data["glass"].item ~= -1 and data["glass"].item ~= 0 then
        SetPedPropIndex(ped, 1, data["glass"].item, data["glass"].texture, true)
    else
        ClearPedProp(ped, 1)
    end

    -- Ear
    if data["ear"].item ~= -1 and data["ear"].item ~= 0 then
        SetPedPropIndex(ped, 2, data["ear"].item, data["ear"].texture, true)
    else
        ClearPedProp(ped, 2)
    end

    -- Watch
    if data["watch"].item ~= -1 and data["watch"].item ~= 0 then
        SetPedPropIndex(ped, 6, data["watch"].item, data["watch"].texture, true)
    else
        ClearPedProp(ped, 6)
    end

    -- Bracelet
    if data["bracelet"].item ~= -1 and data["bracelet"].item ~= 0 then
        SetPedPropIndex(ped, 7, data["bracelet"].item, data["bracelet"].texture, true)
    else
        ClearPedProp(ped, 7)
    end
    
    SetPedEyeColor(ped, data["EyeColor"].item)
    SetPedFaceFeature(ped, 0, (data["FaceFeature0"].item - 10)/10)
    SetPedFaceFeature(ped, 1, (data["FaceFeature1"].item - 10)/10)
    SetPedFaceFeature(ped, 2, (data["FaceFeature2"].item - 10)/10)
    SetPedFaceFeature(ped, 3, (data["FaceFeature3"].item - 10)/10)
    SetPedFaceFeature(ped, 4, (data["FaceFeature4"].item - 10)/10)
    --SetPedFaceFeature(ped, 5, (data["FaceFeature5"].item - 10)/10)
    SetPedFaceFeature(ped, 6, (data["FaceFeature6"].item - 10)/10)
    SetPedFaceFeature(ped, 7, (data["FaceFeature7"].item - 10)/10)
    SetPedFaceFeature(ped, 8, (data["FaceFeature8"].item - 10)/10)
    SetPedFaceFeature(ped, 9, (data["FaceFeature9"].item - 10)/10)
    SetPedFaceFeature(ped, 10, (data["FaceFeature10"].item - 10)/10)
    SetPedFaceFeature(ped, 12, (data["FaceFeature12"].item - 10)/10)
    SetPedFaceFeature(ped, 13, (data["FaceFeature12"].item - 10)/10)
    SetPedFaceFeature(ped, 14, (data["FaceFeature14"].item - 10)/10)
    SetPedFaceFeature(ped, 15, (data["FaceFeature15"].item - 10)/10)
    SetPedFaceFeature(ped, 16, (data["FaceFeature16"].item - 10)/10)
    SetPedFaceFeature(ped, 17, (data["FaceFeature17"].item - 10)/10)
    SetPedFaceFeature(ped, 18, (data["FaceFeature18"].item - 10)/10)
    SetPedFaceFeature(ped, 19, (data["FaceFeature19"].item - 10)/10)

    if not fristLogin then
        skinData = data
        TriggerEvent("ox-hud:load-data", health, armour)
        TriggerEvent("esx_tatoo:loadTattoo")
        ClearPedScubaGearVariation(PlayerPedId())
    end
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Citizen.Wait(100)
    end
end 

local renk = math.random(0,11)
local renk2 = math.random(0,13)
RegisterNetEvent("qb-clothing:client:adjustfacewear")
AddEventHandler("qb-clothing:client:adjustfacewear",function(slot, type, giveItem, remove, data)
    local playerPed = PlayerPedId()
    local time = 0
    if not giveItem then
        if type == "eldiven" or type == "csaat" or type == "cbilezik" then 
            AnimSet = "nmt_3_rcm-10"
            AnimationOn = "cs_nigel_dual-10"
            AnimationOff = "cs_nigel_dual-10"
            time = 1200
        elseif type == "maske" then -- maske
            AnimSet = "mp_masks@standard_car@ds@"
            AnimationOn = "put_on_mask"
            AnimationOff = "put_on_mask"
            time = 800
        elseif type == "sapka" then -- Şapka
            if not remove then
                AnimSet = "mp_masks@standard_car@ds@"
                AnimationOn = "put_on_mask"
                time = 600
            else
                AnimSet = "missheist_agency2ahelmet"
                AnimationOff = "take_off_helmet_stand"
                time = 1200
            end
        elseif type == "gozluk" then -- Gözlük
            AnimSet = "clothingspecs"
            AnimationOn = "take_off"
            AnimationOff = "take_off"
            time = 1400
        elseif type == "govde" or type == "czirh" or type == "cikartma" or type == "ckolye" then -- Tişört
            AnimSet = "clothingtie"
            AnimationOn = "try_tie_negative_a"
            AnimationOff = "try_tie_negative_a"
            time = 1200
        elseif type == "canta" then -- Çanta
            if not remove then
                AnimSet = "clothingtie"
                AnimationOn = "try_tie_negative_a"
                time = 1200
            else
                AnimSet = "anim@heists@ornate_bank@grab_cash"
                AnimationOff = "intro"
                time = 1600
            end
        elseif type == "pantolon" then -- Pantolon
            AnimSet = "re@construction"
            AnimationOn = "out_of_breath"
            AnimationOff = "out_of_breath"
            time = 1300
        elseif type == "ayakkabi" then -- Ayakkabı
            AnimSet = "random@domestic"
            AnimationOn = "pickup_low"
            AnimationOff = "pickup_low"
            time = 1200
        end
        
        loadAnimDict(AnimSet)
        if remove then
            TaskPlayAnim(playerPed, AnimSet, AnimationOff, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        else
            TaskPlayAnim(playerPed, AnimSet, AnimationOn, 4.0, 3.0, -1, 49, 1.0, 0, 0, 0 )
        end
        Citizen.Wait(time/2)
    end

    if not remove and not giveItem then 
        setCloth(data) 
    else
        if type == "eldiven" then -- eliven
            if giveItem then 
                local data = getCloth({"3"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "eldiven", false, slot) 
                end
            end
            if remove then
                local model = GetEntityModel(playerPed)
           
                if model == 1885233650 then -- Erkek Model
                    local item = Gloves.Male[GetPedDrawableVariation(playerPed, 3)]
                    local texture = Gloves.Male[GetPedTextureVariation(playerPed, 3)]
                    SetPedComponentVariation(playerPed, 3, item, texture, 2)
                    skinData["arms"].item = item
                    skinData["arms"].texture = texture
                else
                    SetPedComponentVariation(playerPed, 3, item ,texture, 2)
                    skinData["arms"].item = item
                    skinData["arms"].texture = texture
                end
            end
        end

        if type == "maske" then -- Maske
            if giveItem then 
                local data = getCloth({"1"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "maske", false, slot) 
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 1, 0 ,0 ,2)
                skinData["mask"].item = 0
                skinData["mask"].texture = 0
            end
        end

        if type == "sapka" then -- Şapka
            if giveItem then 
                local data = getCloth({"0"}, true)
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "sapka", true, slot) 
                end
            end
            if remove then
                ClearPedProp(playerPed, 0)
                skinData["hat"].item = 0 
                skinData["hat"].texture = 0
            end
        end

        if type == "gozluk" then -- Gözlük
            if giveItem then 
                local data = getCloth({"1"}, true)
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "gozluk", true, slot) 
                end
            end
            if remove then
                ClearPedProp(playerPed, 1)
                skinData["glass"].item = 0 
                skinData["glass"].texture = 0
            end
        end

        if type == "csaat" then 
            if giveItem then 
                local data = getCloth({"6"}, true)
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "csaat", true, slot) 
                end
            end
            if remove then
                ClearPedProp(playerPed, 6)
                skinData["watch"].item = 0
                skinData["watch"].texture = 0
            end
        end

        if type == "cbilezik" then 
            if giveItem then 
                local data = getCloth({"7"}, true)
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "cbilezik", true, slot) 
                end
            end
            if remove then
                ClearPedProp(playerPed, 7)
                skinData["bracelet"].item = 0
                skinData["bracelet"].texture = 0
            end
        end

        if type == "czirh" then -- Zırh
            if giveItem then 
                local data = getCloth({"9"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "czirh", false, slot) 
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 9, 0, 0, 2) --bproof
                skinData["vest"].item = 0
                skinData["vest"].texture = 0
            end
        end

        if type == "ckolye" then -- Kolye
            if giveItem then 
                local data = getCloth({"7"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "ckolye", false, slot) 
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 7, 0, 0, 2) --chain  
                skinData["accessory"].item = 0
                skinData["accessory"].texture = 0
            end
        end

        if type == "govde" then -- Tişört
            if giveItem then 
                local data = getCloth({"3","8","11","3"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "govde", false, slot) 
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 8, 15, 0, 2) --Tshirt
                SetPedComponentVariation(playerPed, 11, 15, 0, 2) --Torso
                SetPedComponentVariation(playerPed, 3, 15, 0, 2) --arms
                --8
                skinData["t-shirt"].item = 15 
                skinData["t-shirt"].texture = 0
                --11
                skinData["torso2"].item = 15
                skinData["torso2"].texture = 0
                -- 3
                skinData["arms"].item = 15
                skinData["arms"].texture = 0
            end
        end

        if type == "canta" then -- Çanta
            if giveItem then 
                local data = getCloth({"5"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "canta", false, slot)
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 5, 0, 0, 2) --bags
                skinData["bag"].item = 0
                skinData["bag"].texture = 0
            end
        end

        if type == "pantolon" then -- Pantolon
            if giveItem then 
                local data = getCloth({"4"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "pantolon", false, slot) 
                end
            end
            if remove then
                local model = GetEntityModel(playerPed)
                if model == 1885233650 then -- Erkek Model
                    SetPedComponentVariation(playerPed, 4, 61, renk2, 2) --pants
                    skinData["pants"].item = 61
                    skinData["pants"].texture = renk2
                else
                    SetPedComponentVariation(playerPed, 4, 62, renk, 2) --pants
                    skinData["pants"].item = 62
                    skinData["pants"].texture = renk2
                end
            end
        end

        if type == "ayakkabi" then -- Ayakkabı
            if giveItem then 
                local data = getCloth({"6"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "ayakkabi", false, slot) 
                end
            end
            if remove then
                local model = GetEntityModel(playerPed)
                if model == 1885233650 then -- Erkek Model
                    SetPedComponentVariation(playerPed, 6, 34, 0, 2) --shoes
                    skinData["shoes"].item = 34
                    skinData["shoes"].texture = 0
                else
                    SetPedComponentVariation(playerPed, 6, 35, 0, 2) --shoes
                    skinData["shoes"].item = 35
                    skinData["shoes"].texture = 0
                end
            end
        end

        if type == "cikartma" then -- Maske
            if giveItem then 
                local data = getCloth({"10"})
                if data then
                    TriggerServerEvent("qb-clothing:giveItem", data, "cikartma", false, slot) 
                end
            end
            if remove then
                SetPedComponentVariation(playerPed, 10, 0 ,0 ,2)
                skinData["decals"].item = 0
                skinData["decals"].texture = 0
            end
        end

    end
    TriggerServerEvent("qb-clothing:saveSkin", GetEntityModel(PlayerPedId()), json.encode(skinData))
    Citizen.Wait(time/2)
    ClearPedTasks(playerPed)
end)

function getCloth(data, prop)
    local playerPed = PlayerPedId()
    local buyClothe = false
    local faceProps = {}
    for i=1, #data do
        local number = tostring(data[i])
        faceProps[number] = {}
        if prop then
            faceProps[number]["Prop"] = GetPedPropIndex(playerPed, tonumber(number))
            faceProps[number]["Texture"] = GetPedPropTextureIndex(playerPed, tonumber(number))
        else
            faceProps[number]["Prop"] = GetPedDrawableVariation(playerPed, tonumber(number))
            faceProps[number]["Texture"] = GetPedTextureVariation(playerPed, tonumber(number))
        end
	
        local clotVal = checkClotheVal(faceProps[number]["Prop"], prop, number)
        if not buyClothe and clotVal then buyClothe = true end
    end
    if buyClothe then
        return faceProps
    else
        return false
    end
end

function checkClotheVal(val, prop, number)
    if prop and (number == "6" or number == "7" or number == "0") then
        if vall == -1 then
            return false
        else
            return true
        end
    else
        if val ~= 0 and val ~= -1 then
            return true
        else
            return false
        end
    end
end

function setCloth(clotheData)
    local playerPed = PlayerPedId()
    for number, data in pairs(clotheData.data) do
        if clotheData.prop then
            SetPedPropIndex(playerPed, tonumber(number), data["Prop"], data["Texture"], true)
            if number == "7" then -- sol cbilezik
                skinData["bracelet"].item = data["Prop"]
                skinData["bracelet"].texture = data["Texture"]
            elseif number == "0" then -- şapka
                skinData["hat"].item = data["Prop"]
                skinData["hat"].texture = data["Texture"]
            elseif number == "1" then -- gözlük
                skinData["glass"].item = data["Prop"]
                skinData["glass"].texture = data["Texture"]
            elseif number == "6" then -- saat
                skinData["watch"].item = data["Prop"]
                skinData["watch"].texture = data["Texture"]
            end
        else
            SetPedComponentVariation(playerPed, tonumber(number), data["Prop"], data["Texture"], 2)
            if number == "1" then -- maske
                skinData["mask"].item = data["Prop"]
                skinData["mask"].texture = data["Texture"]
            elseif number == "3" then --eldiven
                skinData["arms"].item = data["Prop"]
                skinData["arms"].texture = data["Texture"]
            elseif number == "4" then --Pantolon
                skinData["pants"].item = data["Prop"]
                skinData["pants"].texture = data["Texture"]
            elseif number == "5" then -- çanta
                skinData["bag"].item = data["Prop"]
                skinData["bag"].texture = data["Texture"]
            elseif number == "6" then -- ayakkabı
                skinData["shoes"].item = data["Prop"]
                skinData["shoes"].texture = data["Texture"]
            elseif number == "7" then --chain  
                skinData["accessory"].item = data["Prop"]
                skinData["accessory"].texture = data["Texture"]
            elseif number == "8" then --Tshirt
                skinData["t-shirt"].item = data["Prop"]
                skinData["t-shirt"].texture = data["Texture"]
            elseif number == "9" then --bproof
                skinData["vest"].item = data["Prop"]
                skinData["vest"].texture = data["Texture"]
            elseif number == "10" then --cikartma
                skinData["decals"].item = data["Prop"]
                skinData["decals"].texture = data["Texture"]
            elseif number == "11" then --Torso
                skinData["torso2"].item = data["Prop"]
                skinData["torso2"].texture = data["Texture"]
            end
        end
    end
end

function buyyAllClothes()
    TriggerEvent("qb-clothing:client:adjustfacewear", 31, "cikartma", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 32, "maske", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 33, "sapka", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 34, "gozluk", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 35, "govde", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 36, "canta", true) 
    TriggerEvent("qb-clothing:client:adjustfacewear", 37, "pantolon", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 38, "ayakkabi", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 39, "cbilezik", true)
    TriggerEvent("qb-clothing:client:adjustfacewear", 40, "csaat", true) 
    TriggerEvent("qb-clothing:client:adjustfacewear", 41, "czirh", true) 
    TriggerEvent("qb-clothing:client:adjustfacewear", 42, "ckolye", true) 
end

RegisterNetEvent('qb-clothing:client:openOutfitMenu')
AddEventHandler('qb-clothing:client:openOutfitMenu', function(name)
    TriggerEvent("inventory:client:SetCurrentStash", "dolap_"..name.."_"..QBCore.Functions.GetPlayerData().citizenid, QBCore.Key)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "dolap_"..name.."_"..QBCore.Functions.GetPlayerData().citizenid, {
        maxweight = 1,
        slots = 500,
    })
end)