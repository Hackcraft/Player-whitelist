--[[
	Server
	
	
	local function stuff( ply )
	local info = {
		name = ply:Nick(),
		steamid = ply:SteamID(),
		time = os.time()
	}

	table.insert( players, info )
end

hook.Add( "PlayerDisconnected", "wat", stuff )


https://facepunch.com/showthread.php?t=1349916


--]]

-- mytable["wow"] = "Tutorial" -- steamid nick
-- print( mytable["wow"] ) = Tutorial
-- table.insert( whitelisted, SteamAddWhite = SteamAddNick )

if (SERVER) then

util.AddNetworkString( "AddToWhiteList__" )
util.AddNetworkString( "TakeFromWhiteList__" )
util.AddNetworkString( "WhitelistMenu__" )

local whitelisted = {}
local loading_whitelist_var = "special_whitelist/whitelist.txt"
local isadminonline
local connectedadmins = {}
local antihudpsam = false

local function saving_whitelist()
	
	file.Write( loading_whitelist_var, util.TableToJSON( whitelisted ) ) 
	print("Wrote SteamIDs")

end

--[[
	Stop player from doing shit, hooks!
]]--

--------------- No Props
local function NoPropSpawn_Whitelist( ply, model, ent )
	if not table.HasValue( whitelisted, ply:SteamID() ) then
		ent:Remove()
		ply:SendLua( 'notification.AddLegacy( "You are not allowed to spawn props!", NOTIFY_ERROR, 2 ) surface.PlaySound( "common/warning.wav" )' )
	end
end
hook.Add( "PlayerSpawnedProp", "NoPropSpawn_Whitelist", NoPropSpawn_Whitelist)
---------------

--------------- No NPCs
local function PlayerSpawnedNPC ( ply, ent )
	if not table.HasValue( whitelisted, ply:SteamID() ) then
		ent:Remove()
		ply:SendLua( 'notification.AddLegacy( "You are not allowed to spawn npcs!", NOTIFY_ERROR, 2 ) surface.PlaySound( "common/warning.wav" )' ) -- Resource/warning.wav buttons/combine_button7.wav
	end
end 
hook.Add( "PlayerSpawnedNPC", "PlayerSpawnedNPC", PlayerSpawnedNPC)
---------------

-- Don't even ask why I did them differently :P

-------------- No Chat
hook.Add( "PlayerSay", "No_Chat__", function( ply, text, team )
	if string.lower( text ) == "!whitelist" then 

	if ply:IsSuperAdmin() then
			net.Start( "WhitelistMenu__" )
			net.Send( ply )	
			return
	else
			ply:SendLua( 'notification.AddLegacy( "You are not the required rank!", NOTIFY_ERROR, 2 ) surface.PlaySound( "common/warning.wav" )' ) 	
			return
	end 
	
	elseif not table.HasValue( whitelisted, ply:SteamID() ) then return ""
		ply:SendLua( 'notification.AddLegacy( "You are not allowed to talk!", NOTIFY_ERROR, 2 ) surface.PlaySound( "common/warning.wav" )' ) 
	end
	
end )
---------------

-------------- No Tools
hook.Add( "CanTool", "No_Tool__", function( ply, tr, tool )
	if not table.HasValue( whitelisted, ply:SteamID() ) then
		return "", 
		ply:SendLua( 'notification.AddLegacy( "You are not allowed to use tools!", NOTIFY_ERROR, 2 ) surface.PlaySound( "common/warning.wav" )' ) 
	end
end )
---------------

hook.Add( "Initialize", "SpecialWhitelist :D", function()

	if not file.IsDir( "special_whitelist", "DATA" ) then
		file.CreateDir( "special_whitelist", "DATA" )
	end
	
	if file.Exists( loading_whitelist_var, "DATA" ) then
			whitelisted = util.JSONToTable( file.Read(loading_whitelist_var) ) or {}
			print("Read SteamIDs")
			
		else
			
		saving_whitelist()
			
	end
	
	fuckwiththemgood()

end)

hook.Add( "PlayerDisconnected", "SpecialWhitelist :D", function( ply ) 

			for k, v in pairs (connectedadmins) do
			
				if v == ply:SteamID() then
					table.remove(connectedadmins, k)
				end
				
			end
		
		--if next(connectedadmins) == nil then
			--isadminonline = false
		--end

end)


--[[
	Network messages
]]--

net.Receive( "AddToWhiteList__", function( len, ply )

	if ply:IsSuperAdmin() then

	local SteamAddWhite = net.ReadString( 1 ) --18

	if not table.HasValue( whitelisted, SteamAddWhite ) then
		
	table.insert( whitelisted, SteamAddWhite )
	saving_whitelist()
	
	ply:ChatPrint( "Add " .. SteamAddWhite .. " to whitelist" )
	
	else
	
	ply:ChatPrint( "Already on the whitelist!" )
	
	end
	
	end
	
end )

net.Receive( "TakeFromWhiteList__", function( len, ply )

	if ply:IsSuperAdmin() then

	local SteamRemoveWhite = net.ReadString( 1 ) --18

	if table.HasValue( whitelisted, SteamRemoveWhite ) then
	
	for k, v in pairs (whitelisted) do
		if v == SteamRemoveWhite then
			table.remove(whitelisted, k)
		
	saving_whitelist()
	
	end
	end
	
	ply:ChatPrint( "Removed " .. SteamRemoveWhite .. " from the whitelist" )
	
	else
	
	ply:ChatPrint( "Wasn't on the whitelist!" )
	
	end
	
	end
	
end )


end
