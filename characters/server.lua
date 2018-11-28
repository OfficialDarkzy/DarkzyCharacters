character = {}
---------------------------------------------------------------------------
-- UI Events START
---------------------------------------------------------------------------
RegisterServerEvent("ISRP_Characters:RequestOpenMenu")
AddEventHandler("ISRP_Characters:RequestOpenMenu", function()
	local src = source
	TriggerEvent("ISRP_Admin:GetPlayerData", src, function(results)
		exports["externalsql"]:DBAsyncQuery({
			string = "SELECT * FROM `characters` WHERE `playerid` = :playerid",
			data = {playerid = results.playerid}
		}, function(characters)
			local characters = characters["data"]
			TriggerClientEvent("ISRP_Characters:OpenMenu", src, characters)
		end)
	end)
end)

AddEventHandler("ISRP_Characters:UpdateCharactersInUI", function(player)
	TriggerEvent("ISRP_Admin:GetPlayerData", player, function(results)
		exports["externalsql"]:DBAsyncQuery({
			string = "SELECT * FROM `characters` WHERE `playerid` = :playerid",
			data = {playerid = results.playerid}
		}, function(characters)
			local characters = characters["data"]
			TriggerClientEvent("ISRP_Characters:UpdateMenuCharacters", player, characters)
		end)
	end)
end)
---------------------------------------------------------------------------
-- CREATE CHARACTER EVENT
---------------------------------------------------------------------------
RegisterServerEvent("ISRP_Characters:CreateCharacter")
AddEventHandler("ISRP_Characters:CreateCharacter", function(newCharacterData)
	local src = source
	TriggerEvent("ISRP_Admin:GetPlayerData", src, function(playerData)
		exports["externalsql"]:DBAsyncQuery({
			string = "SELECT * FROM `characters` WHERE `playerid` = :playerid",
			data = {
				playerid = playerData.playerid
			}
		}, function(characters)
			
			local characterCount = #characters["data"]
			if characterCount < ISRPCharactersConfig.MaxCharacters then
				exports["externalsql"]:DBAsyncQuery({
					string = [[
						INSERT INTO characters
						(`name`, `age`, `gender`, `model`, `clothing`, `props`, `tattoos`, `playerid`)
						VALUES
						(:name, :age, :gender, :model, :clothing, :props, :tattoos, :playerid)
					]],
					data = {
						name = newCharacterData.name,
						age = newCharacterData.age,
						gender = newCharacterData.gender,
						model = "",
						clothing = json.encode({}),
						props = json.encode({}),
						tattoos = json.encode({}),
						playerid = playerData.playerid
					}
				}, function(createdResults)
					TriggerEvent("ISRP_Characters:UpdateCharactersInUI", src)
				end)
			else
				print("error max amount of characters")
			end
		end)
	end)
end)
---------------------------------------------------------------------------
-- SELECT CHARACTER EVENT
---------------------------------------------------------------------------
RegisterServerEvent("ISRP_Characters:SelectCharacter")
AddEventHandler("ISRP_Characters:SelectCharacter", function(character_id)
	local src = source
	exports["externalsql"]:DBAsyncQuery({
		string = "SELECT * FROM `characters` WHERE `id` = :character_id",
		data = {
			character_id = character_id
		}
	}, function(characterInfo)

		table.insert(character, {id = src, charid = character_id, playerid = characterInfo.data[1].playerid, gender = characterInfo.data[1].gender, name = characterInfo.data[1].name, age = characterInfo.data[1].age})
		print(json.encode(character))

		local model = #characterInfo["data"][1].model
		if model > 0 then
			math.randomseed(os.time())
			print("Found data, now spawning...")
			local spawn = ISRPCharactersConfig.SpawnLocations[math.random(1, #ISRPCharactersConfig.SpawnLocations)]
			TriggerClientEvent("ISRP_Characters:LoadSelectedCharacter", src, characterInfo.data[1].model, characterInfo.data[1].clothing, spawn)
		else
			print("No data found, opening character modifier!")
			local models = ISRPCharactersConfig.Models[characterInfo.data[1].gender]
			TriggerClientEvent("ISRP_CharactersMenu:OpenCreator", src, models)
		end
	end)
end)

---------------------------------------------------------------------------
-- DELETE CHARACTER EVENT
---------------------------------------------------------------------------
RegisterServerEvent("ISRP_Characters:DeleteCharacter")
AddEventHandler("ISRP_Characters:DeleteCharacter", function(character_id)
	local src = source
	exports["externalsql"]:DBAsyncQuery({
		string = "DELETE FROM `characters` WHERE `id` = :character_id",
		data = {
			character_id = character_id
		}
	}, function(results)
		TriggerEvent("ISRP_Characters:UpdateCharactersInUI", src)
	end)
end)

---------------------------------------------------------------------------
-- CHARACTER CREATOR SAVE EVENTS
---------------------------------------------------------------------------
RegisterServerEvent("ISRP_Characters:SaveCharacter")
AddEventHandler("ISRP_Characters:SaveCharacter", function(characterData)
	local src = source
	TriggerEvent("ISRP_Characters:GetCharacterData", src, function(characterId)
		exports["externalsql"]:DBAsyncQuery({
			string = "UPDATE characters SET `model` = :model, `clothing` = :clothing, `props` = :props, `tattoos` = :tattoos WHERE `id` = :char_id",
			data = {
				model = characterData.model,
				clothing = json.encode(characterData.clothing),
				props = json.encode({}),
				tattoos = json.encode({}),
				char_id = characterId.charid
			}
		}, function(results)

			local spawn = ISRPCharactersConfig.SpawnLocations[math.random(1, #ISRPCharactersConfig.SpawnLocations)]
			TriggerClientEvent("ISRP_Characters:LoadSelectedCharacter", src, characterData.model, json.encode(characterData.clothing), spawn)
		end)
	end)
end)


function GetCharacterData(id)
	for a = 1, #character do
		if character[a].id == id then
			return(character[a])
		end
	end
	return false
end

function GetCharacterName(id)
	for a = 1, #character do
		if character[a].id == id then
			return(character[a].name)
		end
	end
	return false
end

AddEventHandler("ISRP_Characters:GetCharacterData", function(id, callback)
		for a = 1, #character do
			if character[a].id == id then
				callback(character[a])
				return
			end
		end
	callback(false)
end)

AddEventHandler("playerDropped", function()
    for a = 1, #character do
        if character[a].id == id then
            table.remove(character, a)
            break
        end
    end
end)