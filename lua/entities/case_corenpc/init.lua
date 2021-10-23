AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("zeycase_core/config/sh_config.lua")
include("shared.lua")
include("zeycase_core/config/sh_config.lua")

local number1000
function number1000(n)
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

local joballow = false

function ENT:Initialize()
	self:SetModel(CASESystem.Config.NPCModel)
	self:SetHullType(HULL_HUMAN);
	self:SetHullSizeNormal();
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
	self.data = {}
	self.data.canrob = true
	self.data.robber = nil

	local sequence = self:LookupSequence( "cower" )
	self:SetSequence( sequence )

end

function ENT:AcceptInput(name, activator, caller)

	if activator:IsPlayer() == false then return end

	if timer.Exists("npcrobid"..self:EntIndex()) then
		net.Start("ncprobmsg")
			net.WriteString(string.format( CASESystem.Language.CurrentBeingRobbed, math.Round(timer.TimeLeft( "npcrobid"..self:EntIndex() )) ))
		net.Send(activator)
	else
		net.Start("npcstoreui")
		net.Send(activator)
	end

	net.Receive("ncprobdoact", function(name, activator, caller)
		if !(CASESystem.Config.RobberySystem) then return end
		if activator:GetPos():Distance( self:GetPos() ) > 100 then
			net.Start("ncprobmsg")
				net.WriteString(CASESystem.Language.RobTooFar)
			net.Send(activator)
			return
		end

		if !(activator:Alive()) then 
			net.Start("ncprobmsg")
				net.WriteString(CASESystem.Language.RobDead)
			net.Send(activator)
			return
		end

		if CASESystem.Config.ForceWeapon then
			if !table.HasValue(CASESystem.Config.ForceWeaponWeapons, activator:GetActiveWeapon():GetClass()) then 
				net.Start("ncprobmsg")
					net.WriteString(CASESystem.Language.NoActiveWeapon)
				net.Send(activator)
				return
			end
		end

		local joballow = false
		if CASESystem.Config.CanRobSpec then
			for _, job in pairs(CASESystem.Config.CanRobJobs) do
				if activator:Team() == job then
					print("Match")
					joballow = true
					break
				end
			end
		else
			joballow = true
		end

		local cops = 0
		for _, job in pairs(CASESystem.Config.ConsideredCops) do
			cops = cops + #team.GetPlayers(job)
		end
 	
		if self.data.canrob == true then
			if joballow == true then
				if ( #player.GetAll() * CASESystem.Config.RobGovernmentAmount ) > cops then
					net.Start("ncprobmsg")
						net.WriteString(CASESystem.Language.RobNotEnGovern)
					net.Send(activator)
				elseif ( #player.GetAll() * CASESystem.Config.RobGovernmentAmount ) <= cops then
					if (#player.GetAll() >= CASESystem.Config.RobPlayerAmount) then
						self.data.canrob = false
						self.data.robber = activator
						sound.Add( {
							name = "alarmnoise",
							channel = CHAN_STREAM,
							volume = 1.0,
							level = 80,
							pitch = { 95, 110 },
							sound = CASESystem.Config.RobAlarmDir
						} )

						if CASESystem.Config.RobAlarmActive then
							self:EmitSound("alarmnoise")
						end

						net.Start("ncprobdoani")
							net.WriteEntity(self)
						net.Broadcast()

						net.Start( "ncprobmsg" )
							net.WriteString( string.format( CASESystem.Language.RobGlobalNotif, activator:Nick(), number1000(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount), CASESystem.Config.RobTime ) )
						net.Broadcast()

						self:EmitSound("vo/npc/male01/help01.wav") 
						timer.Create("npcscream"..self:EntIndex(), math.random(1,CASESystem.Config.RobShouttime), 0, function()
							local ranscream = math.random(1,2)
							if ranscream == 1 then
								self:EmitSound("vo/npc/male01/help01.wav")
							elseif ranscream == 2 then
								self:EmitSound("ambient/voices/m_scream1.wav")
							end
						end)

						for _, v in pairs(player.GetAll()) do
							for _, n in pairs(CASESystem.Config.ConsideredCops) do
								if v:Team() == n then
									net.Start( "ncprobpolicecall" )
										net.WriteEntity(self)
									net.Send(v)
								end
							end
						end


						timer.Create("npcrobid"..self:EntIndex(), CASESystem.Config.RobTime, 1, function()

							self:StopSound("alarmnoise"	)

							net.Start("ncprobdoanires")
								net.WriteEntity(self)
							net.Broadcast()

							self.data.canrob = false
							for _, v in pairs(player.GetAll()) do
								for _, n in pairs(CASESystem.Config.ConsideredCops) do
									if v:Team() == n then
										net.Start( "ncprobpolicecallend" )
										net.Send(v)
									end
								end
							end		

							timer.Destroy("npcscream"..self:EntIndex())
							self.data.robber = nil
							local cops = nil
						 	if activator:IsValid() then
								net.Start( "ncprobmsg" )
									net.WriteString( string.format( CASESystem.Language.RobGlobalNotifComp, activator:Nick(), number1000(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount) ) )
								net.Broadcast()
							end	
							if CASESystem.Config.RobMoneybagSystem == true then
								local entity = ents.Create( "case_moneybag" )
								if ( !IsValid( entity ) ) then return end 
								entity:SetPos( self:GetPos() + Vector(-20,0,60) )
								entity:Spawn()
							elseif CASESystem.Config.RobMoneybagSystem == false then
								activator:addMoney(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount)
							end
							timer.Create("npccooldown"..self:EntIndex(), CASESystem.Config.RobCoodownTime, 1, function()
								if IsValid(self) then
									self.data.canrob = true
								end
	
							end)
						end)
	
					elseif (#player.GetAll() < CASESystem.Config.RobPlayerAmount) then
						net.Start("ncprobmsg")
							net.WriteString(CASESystem.Language.RobNotEnPly)
						net.Send(activator)
					end
				else
					net.Start("ncprobmsg")
						net.WriteString(CASESystem.Language.RobNotEnGovern)
					net.Send(activator)
				end

			elseif joballow == false then
				net.Start("ncprobmsg")
					net.WriteString(CASESystem.Language.RobNotJob)
				net.Send(activator)
			end
	
		elseif self.data.canrob == false then
			if timer.Exists("npcrobid"..self:EntIndex()) then
				net.Start("ncprobmsg")
					net.WriteString(string.format( CASESystem.Language.CurrentBeingRobbed, math.Round(timer.TimeLeft( "npcrobid"..self:EntIndex() )) ))
				net.Send(activator)
			elseif timer.Exists("npccooldown"..self:EntIndex()) then
				net.Start("ncprobmsg")
					net.WriteString(string.format(CASESystem.Language.RobCoolDown, math.Round(timer.TimeLeft("npccooldown"..self:EntIndex()))) )
				net.Send(activator)
			else 
				self.data.canrob = true
			end
		end

	end)

end


function ENT:RobAbort()
	net.Start("ncprobdoanires")
		net.WriteEntity(self)
	net.Broadcast()
	self:StopSound("alarmnoise"	)
	if !IsValid(self.data.robber) then return end

	timer.Destroy("npcrobid"..self:EntIndex())
	timer.Destroy("npcscream"..self:EntIndex())
	self.data.canrob = false
	for _, v in pairs(player.GetAll()) do
		for _, n in pairs(CASESystem.Config.ConsideredCops) do
			if v:Team() == n then
				net.Start( "ncprobpolicecallend" )
				net.Send(v)
			end
		end
	end	
	timer.Create("npccooldown"..self:EntIndex(), CASESystem.Config.RobCoodownTime, 1, function()
		if IsValid(self) then
			self.data.canrob = true
		end
	end)

	net.Start( "ncprobmsg" )
		net.WriteString( string.format( CASESystem.Language.RobFail, self.data.robber:Nick(), number1000(isfunction(CASESystem.Config.RobAmount) and CASESystem.Config.RobAmount() or CASESystem.Config.RobAmount) ) )
	net.Broadcast()
	self.data.robber = nil
	local cops = nil

end

function ENT:Think()
	if not IsValid( self.data.robber ) then return end

	if self.data.robber:GetPos():Distance( self:GetPos() ) > CASESystem.Config.RobMaxDistance then
		self:RobAbort()
	end
end

function ENT:OnRemove()
	if timer.Exists("npcrobid"..self:EntIndex()) then
		self:RobAbort()
		timer.Destroy("npccooldown"..self:EntIndex())
	end
end


--
-- Hooks
--


hook.Add( "PlayerDeath", "rob_robberkilled", function( victim, inflictor, attacker )
	for _, npctorob in pairs( ents.FindByClass( "zeycase_corenpc" ) ) do
		if npctorob.data then
			if npctorob.data.robber == victim then
				npctorob:RobAbort()
			end
		end
	end

end)

hook.Add( "PlayerDisconnected", "rob_robberkilled", function( ply )
	for _, npctorob in pairs( ents.FindByClass( "zeycase_corenpc" ) ) do
		if npctorob.data then
			if npctorob.data.robber == ply then
				npctorob:RobAbort()
			end
		end
	end

end)

hook.Add("OnPlayerChangedTeam", "rob_robberchangejob", function( ply )
	for _, npctorob in pairs( ents.FindByClass( "zeycase_corenpc" ) ) do
		if npctorob.data then
			if npctorob.data.robber == ply then
				npctorob:RobAbort()
			end
		end
	end
end)

concommand.Add( "savestorerob", function(ply)

	if !CASESystem.Config.SaveComGroup[ply:GetUserGroup()] then
	net.Start("ncprobmsg")
		net.WriteString("You do not have access to that command!")
	net.Send(ply)
	return
	end

	savedStores = {}
	for i, store in pairs( ents.FindByClass( "zeycase_corenpc" ) ) do
		savedStores[ i ] = { pos = store:GetPos(), ang = store:GetAngles() }
		file.Write( "stores/storefile.txt", util.TableToJSON( savedStores ) )
	end

	net.Start("ncprobmsg")
		net.WriteString("NPC's saved")
	net.Send(ply)

end )

