local creatorActive = false

---------------------------------------------------------------------------
-- Events
---------------------------------------------------------------------------
RegisterNetEvent("ISRP_CharactersMenu:OpenCreator")
AddEventHandler("ISRP_CharactersMenu:OpenCreator", function(models)
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "enable_character_creator_menu",
            models = models
        })
        TriggerEvent("ISRP_CharactersMenu:StopSkyCamera")
        TriggerEvent("ISRP_CharactersMenu:StartCreatorCamera")
        Citizen.Trace("opened character creator")
        creatorActive = true
end)

---------------------------------------------------------------------------
-- Callbacks
---------------------------------------------------------------------------
RegisterNUICallback("creatorchangemodel", function(data, callback)
    SetModel(data.model)
    callback("ok")
end)

RegisterNUICallback("creatorchangedrawable", function(data, callback)
    SetComponentDraw(data.component, data.drawable)
    callback("ok")
end)

RegisterNUICallback("creatorchangetexture", function(data, callback)
    SetCompText(data.component, data.texture)
    callback("ok")
end)

RegisterNUICallback("finishcharactercreator", function(data, callback)
    SaveCharacterData(data.model)
    callback("ok")
end)

RegisterNUICallback("rotatecharacter", function(data, callback)
    RotatePed(data.amount)
    callback("ok")
end)

---------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------
function RotatePed(amount)
    local ped = GetPlayerPed(PlayerId())
    SetEntityHeading(ped, GetEntityHeading(ped) + amount)
end

function SetModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end
    SetPlayerModel(PlayerId(), model)
    SetPedDefaultComponentVariation(GetPlayerPed(PlayerId()))
    UpdateCreatorMenu()
end

function SetComponentDraw(comp, draw)
    local ped = GetPlayerPed(PlayerId())
    local component = ISRPCharactersConfig.PedComponents[comp]
    SetPedComponentVariation(ped, component, draw, 0, 0)

    if comp == "FACE" then
        SetPedHeadBlendData(ped, draw, draw, draw, draw, draw, draw, 0.0, 0.0, 0.0, 0)
    end

    UpdateDrawableMenuTextures(comp)
end

function GetComponentDraw(comp)
    local ped = GetPlayerPed(PlayerId())
    local component = ISRPCharactersConfig.PedComponents[comp]
    return GetPedDrawableVariation(ped, component)
end

function SetCompText(comp, text)
    local ped = GetPlayerPed(PlayerId())
    local component = ISRPCharactersConfig.PedComponents[comp]
    local current_component = GetPedDrawableVariation(ped, component)
    SetPedComponentVariation(ped, component, current_component, text, 0)
end

function GetCompText(comp)
    local ped = GetPlayerPed(PlayerId())
    local component = ISRPCharactersConfig.PedComponents[comp]
    return GetPedTextureVariation(ped, component)
end

function UpdateCreatorMenu()
    local ped = GetPlayerPed(PlayerId())
    SendNUIMessage({
        type = "update_character_model_components",
        components = {
            ["FACE"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["FACE"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["FACE"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["FACE"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["FACE"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["FACE"]))}
            },
            ["HEAD"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["HEAD"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["HEAD"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"]))}
            },
            ["HAIR"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["HAIR"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["HAIR"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"]))}
            },
            ["ARMS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["ARMS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["ARMS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"]))}
            },
            ["LEGS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["LEGS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["LEGS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"]))}
            },
            ["BAGS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["BAGS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["BAGS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"]))}
            },
            ["SHOES"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["SHOES"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["SHOES"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"]))}
            },
            ["NECK"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["NECK"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["NECK"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["NECK"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["NECK"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["NECK"]))}
            },
            ["ACCESSORIES"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"]))}
            },
            ["VESTS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["VESTS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["VESTS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"]))}
            },
            ["OVERLAYS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"]))}
            },
            ["JACKETS"] = {
                draw = {min = 0, current = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"]), max = GetNumberOfPedDrawableVariations(ped, ISRPCharactersConfig.PedComponents["JACKETS"])},
                text = {min = 0, current = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"]), max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents["JACKETS"], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"]))}
            }
        }
    })
    creatorActive = false
    SetPlayerVisibleLocally(PlayerId(), false)
    SetEntityVisible(ped, true)
    SetPlayerInvincible(PlayerId(), false)
end

function UpdateDrawableMenuTextures(component)
    local ped = GetPlayerPed(PlayerId())
    SendNUIMessage({
        type = "update_character_model_draw_textures",
        component = component,
        textures = {min = 0, current = 0, max = GetNumberOfPedTextureVariations(ped, ISRPCharactersConfig.PedComponents[component], GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents[component]))}
    })
end

function SaveCharacterData(model)
    local ped = GetPlayerPed(PlayerId())
    SetNuiFocus(false, false)
    TriggerServerEvent("ISRP_Characters:SaveCharacter", {
        model = model,
        clothing = {
            ["FACE"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["FACE"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["FACE"])
            },
            ["HEAD"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"])
            },
            ["HAIR"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"])
            },
            ["ARMS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"])
            },
            ["LEGS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"])
            },
            ["BAGS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"])
            },
            ["SHOES"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"])
            },
            ["NECK"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["NECK"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["NECK"])
            },
            ["ACCESSORIES"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"])
            },
            ["VESTS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"])
            },
            ["OVERLAYS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"])
            },
            ["JACKETS"] = {
                draw = GetPedDrawableVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"]),
                text = GetPedTextureVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"])
            }
        }
    })
    creatorActive = false
end


Citizen.CreateThread(function()
    while true do
        if creatorActive then
            local ped = GetPlayerPed(PlayerId())
            SetPlayerInvisibleLocally(PlayerId(), false)
            SetEntityVisible(ped, false)
            SetPlayerInvincible(PlayerId(), true)
        end
        Citizen.Wait(250)
    end
end)