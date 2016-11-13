--[[
	Client
]]--
local xScreenRes = 1920
local yScreenRes = 1080
local wMod = ScrW() / xScreenRes     
local hMod = ScrH() / yScreenRes

surface.CreateFont( "WhiteList_34", { 
font = "Trebuchet18", 
size = wMod*34, 
weight = 700, 
antialias = true 
}) 

net.Receive( "WhitelistMenu__", function( len, pl )

local addwhitelist 
local removewhitelist 

local Frame = vgui.Create( "DFrame" )
Frame:SetPos( 5, 5 )
Frame:SetSize( 500, 500 )
Frame:SetTitle( "Whitelist - Admins are automatically on it :D   Menu is for superadmins only btw" )
Frame:SetVisible( true )
Frame:SetDraggable( true )
Frame:ShowCloseButton( true )
Frame:MakePopup()


local TextEntry = vgui.Create( "DTextEntry", Frame )	-- create the form as a child of frame
TextEntry:SetPos( 25, 50 )
TextEntry:SetSize( 350, 50 )
TextEntry:SetText( "Whitelist SteamID (no spaces or commas)" )
TextEntry.OnTextChanged = function( self )
	addwhitelist = self:GetValue()
end

local Button = vgui.Create( "DButton", Frame )
Button:SetText( "Add" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( 400, 50 )
Button:SetSize( 50, 50 )
Button.DoClick = function()
	if addwhitelist == nil then
	chat.AddText( "Please add a SteamID()" )
	else
	
	net.Start( "AddToWhiteList__" )
	net.WriteString( addwhitelist )
	net.SendToServer()

	end
end




local TextEntry = vgui.Create( "DTextEntry", Frame )	-- create the form as a child of frame
TextEntry:SetPos( 25, 100 )
TextEntry:SetSize( 350, 50 )
TextEntry:SetText( "Remove SteamID from whitelist (no spaces or commas)" )
TextEntry.OnTextChanged = function( self )
	removewhitelist = self:GetValue()
end

local Button = vgui.Create( "DButton", Frame )
Button:SetText( "Remove" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( 400, 100 )
Button:SetSize( 50, 50 )
Button.DoClick = function()
	if removewhitelist == nil then
	chat.AddText( "Please add a SteamID()" )
	else
	
	net.Start( "TakeFromWhiteList__" )
	net.WriteString( removewhitelist )
	net.SendToServer()
	
	end
end


local Button = vgui.Create( "DButton", Frame )
Button:SetText( "Print SteamIDs" )
Button:SetTextColor( Color( 255, 255, 255 ) )
Button:SetPos( 25, 150 )
Button:SetSize( 100, 50 )
Button.DoClick = function()
	for k, v in pairs( player.GetAll() ) do
		print( v:Nick() .. ", " .. v:SteamID() )
	end
	chat.AddText( "SteamIDs have been printed to console!" )
end

end)

concommand.Add( "new_menu", function()

-- Whitelisted -- Online -- 
	--whitelisted -- not whitelisted
	-- add -- remove
	--Custom id
	
	--  name -- id
	
	--draw.RoundedBox(0 , wMod*10 , hMod*950 , wMod*250 , hMod*120 , Color(0,0,0,180 ))
	
	local Frame = vgui.Create( "DFrame" )
Frame:SetSize( wMod*600, hMod*600 )
Frame:Center()
Frame:SetTitle( "" )
Frame:SetVisible( true )
Frame:SetDraggable( true )
Frame:ShowCloseButton( false )
Frame:MakePopup()
Frame.Paint = function()
	draw.RoundedBox( 0, 0, 0, Frame:GetWide(), Frame:GetTall(), Color( 255, 255, 255, 200 ) )
end

local Button = vgui.Create( "DButton", Frame )
Button:SetText( "X" )
Button:SetTextColor( Color( 0, 0, 0 ) )
Button:SetPos( wMod*570, hMod*0 )
Button:SetSize( wMod*30, hMod*30 )
Button.DoClick = function()
	Frame:Close()
end
Button.Paint = function()
	draw.RoundedBox( 0, 0, 0, Frame:GetWide(), Frame:GetTall(), Color( 255, 255, 255, 255 ) )
end

end)