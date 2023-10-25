Config = {}

Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

exports('eklentiData', function()
    return Config.WeaponAttachments
end)

Config.WeaponAttachments = {
    ["WEAPON_PISTOL"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_PISTOL_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
    },
    ["WEAPON_COMBATPISTOL"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_COMBATPISTOL_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
    },
    ["WEAPON_HEAVYPISTOL"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_HEAVYPISTOL_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
    },
    ["WEAPON_PISTOL50"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_PISTOL50_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
    },
    ["WEAPON_PISTOL_MK2"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_PI_FLSH_02",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_PISTOL_MK2_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_PI_RAIL",
            label = "Dürbün",
            item = "scope",
        },
    },

    -- SMG
    ["WEAPON_SMG"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_SMG_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO_02",
            label = "Dürbün",
            item = "scope",
        },
    },
    ["WEAPON_SMG_MK2"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["clip"] = {
            component = "COMPONENT_SMG_MK2_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },
        ["scope"] = {
            component = "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2",
            label = "Dürbün",
            item = "scope",
        },
    },

    -- Rifle
    ["WEAPON_ASSAULTRIFLE_MK2"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Tutamaç",
            item = "grip",
        },
        ["clip"] = {
            component = "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },

        ["scope"] = {
            component = "COMPONENT_AT_SIGHTS",
            label = "Dürbün",
            item = "scope",
        },
        ["scope2"] = {
            component = "COMPONENT_AT_SCOPE_MACRO_MK2",
            label = "Dürbün",
            item = "scope2",
        },
        ["scope3"] = {
            component = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
            label = "Dürbün",
            item = "scope3",
        },
        ["muzzle"] = {
            component = "COMPONENT_AT_MUZZLE_01",
            label = "Muzzle",
            item = "muzzle",
        },
        ["muzzle2"] = {
            component = "COMPONENT_AT_MUZZLE_02",
            label = "Muzzle",
            item = "muzzle2",
        },
        ["muzzle3"] = {
            component = "COMPONENT_AT_MUZZLE_03",
            label = "Muzzle",
            item = "muzzle3",
        },
        ["muzzle4"] = {
            component = "COMPONENT_AT_MUZZLE_04",
            label = "Muzzle",
            item = "muzzle4",
        },
        ["muzzle5"] = {
            component = "COMPONENT_AT_MUZZLE_05",
            label = "Muzzle",
            item = "muzzle5",
        },
        ["muzzle6"] = {
            component = "COMPONENT_AT_MUZZLE_06",
            label = "Muzzle",
            item = "muzzle6",
        },
        ["muzzle7"] = {
            component = "COMPONENT_AT_MUZZLE_07",
            label = "Muzzle",
            item = "muzzle7",
        },
    },
    ["WEAPON_CARBINERIFLE_MK2"] = { 
        ["flashlight"] = {
            component = "COMPONENT_AT_AR_FLSH",
            label = "Fener",
            item = "flashlight",
        },
        ["grip"] = {
            component = "COMPONENT_AT_AR_AFGRIP_02",
            label = "Tutamaç",
            item = "grip",
        },
        ["clip"] = {
            component = "COMPONENT_CARBINERIFLE_MK2_CLIP_02",
            label = "Sarjör",
            item = "clip",
        },

        ["scope"] = {
            component = "COMPONENT_AT_SIGHTS",
            label = "Dürbün",
            item = "scope",
        },
        ["scope2"] = {
            component = "COMPONENT_AT_SCOPE_MACRO_MK2",
            label = "Dürbün",
            item = "scope2",
        },
        ["scope3"] = {
            component = "COMPONENT_AT_SCOPE_MEDIUM_MK2",
            label = "Dürbün",
            item = "scope3",
        },

        ["muzzle"] = {
            component = "COMPONENT_AT_MUZZLE_01",
            label = "Muzzle",
            item = "muzzle",
        },
        ["muzzle2"] = {
            component = "COMPONENT_AT_MUZZLE_02",
            label = "Muzzle",
            item = "muzzle2",
        },
        ["muzzle3"] = {
            component = "COMPONENT_AT_MUZZLE_03",
            label = "Muzzle",
            item = "muzzle3",
        },
        ["muzzle4"] = {
            component = "COMPONENT_AT_MUZZLE_04",
            label = "Muzzle",
            item = "muzzle4",
        },
        ["muzzle5"] = {
            component = "COMPONENT_AT_MUZZLE_05",
            label = "Muzzle",
            item = "muzzle5",
        },
        ["muzzle6"] = {
            component = "COMPONENT_AT_MUZZLE_06",
            label = "Muzzle",
            item = "muzzle6",
        },
        ["muzzle7"] = {
            component = "COMPONENT_AT_MUZZLE_07",
            label = "Muzzle",
            item = "muzzle7",
        },

    },
}