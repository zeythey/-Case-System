AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("zeycase_core/config/sh_config.lua")
include("shared.lua")
include("zeycase_core/config/sh_config.lua")

local canrob = true
local joballow = false

function ENT:Initialize()
	self:SetModel(CASESystem.Config.RobMoneybagModel)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()

end

function ENT:AcceptInput(name, activator, caller)
	activator:addMoney(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount)
	net.Start( "ncprobmsg" )
		net.WriteString( string.format( "You collected $"..(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount).." from the moneybag!" ) )
	net.Send(activator)

	self:Remove()
end


function ENT:Think()
end
