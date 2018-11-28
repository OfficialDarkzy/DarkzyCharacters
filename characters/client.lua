local firstSpawn = true
---------------------------------------------------------------------------
-- Spawning player into server.. Setup char menu etc..
---------------------------------------------------------------------------
AddEventHandler('playerSpawned', function()
    if firstSpawn then
    Citizen.Wait(555)
        TriggerServerEvent("ISRP_Characters:RequestOpenMenu")
        firstSpawn = false
    end
end)

---------------------------------------------------------------------------
-- NUI EVENTS
---------------------------------------------------------------------------
RegisterNetEvent("ISRP_Characters:OpenMenu")
AddEventHandler("ISRP_Characters:OpenMenu", function(characters)
	SetNuiFocus(true, true)
	TriggerEvent("ISRP_CharactersMenu:StartSkyCamera")
	Citizen.Wait(2200)
	SendNUIMessage({
		type = "open_character_menu",
		characters = characters
	})
end)

RegisterNetEvent("ISRP_Characters:UpdateMenuCharacters")
AddEventHandler("ISRP_Characters:UpdateMenuCharacters", function(characters)
	SendNUIMessage({
		type = "update_character_menu",
		characters = characters
	})
end)

---------------------------------------------------------------------------
-- NUI CALLBACKS
---------------------------------------------------------------------------
RegisterNUICallback("CloseMenu", function(data, callback)
	SetNuiFocus(false, false)
	callback("ok")
end)

RegisterNUICallback("SelectYourCharacter", function(data, callback)
	SetNuiFocus(false, false)
	TriggerServerEvent("ISRP_Characters:SelectCharacter", data.character_selected)
	callback("ok")
end)

RegisterNUICallback("CreateCharacter", function(data, callback)
	TriggerServerEvent("ISRP_Characters:CreateCharacter", {name = data.name, age = data.age, gender = data.gender})
	callback("ok")
end)

RegisterNUICallback("DeleteCharacter", function(data, callback)
	print(tostring("You Just Deleted Character ID: "..data.character_id))
	TriggerServerEvent("ISRP_Characters:DeleteCharacter", data.character_id)
	callback("ok")
end)

---------------------------------------------------------------------------
-- LOAD CHARACTER FROM SELECTER
---------------------------------------------------------------------------
RegisterNetEvent("ISRP_Characters:LoadSelectedCharacter")
AddEventHandler("ISRP_Characters:LoadSelectedCharacter", function(ped, clothData, spawn)
	exports["spawnmanager"]:spawnPlayer({x = spawn.x, y = spawn.y, z = spawn.z, heading = spawn.h, model = ped})
	Citizen.Wait(4000)
	TriggerEvent("ISRP_CharactersMenu:StopSkyCamera")
	TriggerEvent("ISRP_CharactersMenu:StopCreatorCamera")
	Citizen.Wait(1000)
	local ped = GetPlayerPed(PlayerId())
	local clothing = json.decode(clothData)

	SetPedDefaultComponentVariation(ped)

	-- -- Set Drawables and Textures
	SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["FACE"], clothing["FACE"].draw, clothing["FACE"].text, 0)
	SetPedHeadBlendData(ped, clothing["FACE"].draw, clothing["FACE"].draw, 0, clothing["FACE"].draw, clothing["FACE"].draw, 0.0, 0.0, 0.0, 0)

	SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["HEAD"], clothing["HEAD"].draw, clothing["HEAD"].text, 0)
	
	SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["HAIR"], clothing["HAIR"].draw, clothing["HAIR"].text, 0)
	SetPedHairColor(ped, clothing["HAIR"].draw, clothing["HAIR"].draw)

    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["ARMS"], clothing["ARMS"].draw, clothing["ARMS"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["LEGS"], clothing["LEGS"].draw, clothing["LEGS"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["BAGS"], clothing["BAGS"].draw, clothing["BAGS"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["SHOES"], clothing["SHOES"].draw, clothing["SHOES"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["NECK"], clothing["NECK"].draw, clothing["NECK"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["ACCESSORIES"], clothing["ACCESSORIES"].draw, clothing["ACCESSORIES"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["VESTS"], clothing["VESTS"].draw, clothing["VESTS"].text, 0)
    SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["OVERLAYS"], clothing["OVERLAYS"].draw, clothing["OVERLAYS"].text, 0)
	SetPedComponentVariation(ped, ISRPCharactersConfig.PedComponents["JACKETS"], clothing["JACKETS"].draw, clothing["JACKETS"].text, 0)
	
    SetPlayerInvisibleLocally(PlayerId(), false)
    SetEntityVisible(ped, true)
	SetPlayerInvincible(PlayerId(), false)
end)


---------------------------------------------------------------------------
-- LOAD CHARACTER AFTER, DEATH, RELOAD CLOTHES FROM A JOB ETC.
---------------------------------------------------------------------------
