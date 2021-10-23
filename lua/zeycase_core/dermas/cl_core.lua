CASESystem.Core = {}

-- These are the chat notifications, the system used is the most optimised way I could think of
net.Receive( "ncprobmsg", function()
	chat.AddText( CASESystem.Config.StorePrefixColor, CASESystem.Config.RobPrefix..": ", Color( 255, 255, 255 ), net.ReadString() )
end )
net.Receive( "ncpshopmsg", function()
	chat.AddText( CASESystem.Config.RobPrefixColor, CASESystem.Config.StorePrefix..": ", Color( 255, 255, 255 ), net.ReadString() )
end )

-- The function for blur panels
local blur = Material("pp/blurscreen")
CASESystem.Core.BlurFunc = function(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(51, 186, 255)
	surface.SetMaterial(blur)
	for i = 1, 6 do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

-- formatting numbers to look nice
CASESystem.Core.FormatFunc = function(n)
	if not n then return "" end
	if n >= 1e14 then return tostring(n) end
    n = tostring(n)
    local sep = sep or ","
    local dp = string.find(n, "%.") or #n+1
	for i=dp-4, 1, -3 do
		n = n:sub(1, i) .. sep .. n:sub(i+1)
    end
    return n
end