--[[
	Server
--]]

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

local function NoPropSpawn_Whitelist( ply, model, ent )
	if isadminonline == false then
	if not table.HasValue( whitelisted, ply:SteamID() ) then
		ent:Remove()
	end
	end
end
 
hook.Add( "PlayerSpawnedProp", "NoPropSpawn_Whitelist", NoPropSpawn_Whitelist)


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

end)


hook.Add( "PlayerSay", "OpeningWhitelist", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( text == "!whitelist" ) then
	
		if ply:IsSuperAdmin() then
			net.Start( "WhitelistMenu__" )
			net.Send( ply )
			
			else
			
			ply:ChatPrint( "You ain't superadmin M8y" )
			
		end
		
		return text
	end
end )


hook.Add( "Think", "SpecialWhitelist :D", function()

if isadminonline == false then

	for k, v in pairs( player.GetAll() ) do
		
		if not table.HasValue( whitelisted, v:SteamID() ) then
		
			if not v:IsFrozen() then
			v:Freeze( true )
			print("Freeze")
			end
			
			if antihudpsam == false then
				antihudpsam = true
				v:PrintMessage( HUD_PRINTCENTER, "You are not on the whitelist!" )
			
				timer.Simple( 5, function()
					antihudpsam = false
				end)
			end
			
		else
			
			if v:IsFrozen() then
			v:Freeze( false )
			print("Unfreeze")
			end
		 
		end
	end
	end
	
end )


hook.Add( "PlayerSpawn", "SpecialWhitelist :D", function( ply ) --PlayerInitialSpawn

	if ply:IsAdmin() and not table.HasValue( whitelisted, ply:SteamID() ) then
		table.insert( whitelisted, ply:SteamID() )
		saving_whitelist()
	end
	
	if ply:IsAdmin() and not table.HasValue( connectedadmins, ply:SteamID() ) then
		isadminonline = true
		table.insert( connectedadmins, ply:SteamID() )
	end

end)


hook.Add( "PlayerDisconnected", "SpecialWhitelist :D", function( ply ) 

			for k, v in pairs (connectedadmins) do
			
				if v == ply:SteamID() then
					table.remove(connectedadmins, k)
				end
				
			end
		
		if next(connectedadmins) == nil then
			isadminonline = false
		end

end)


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