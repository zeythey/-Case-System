CASESystem = {}

print("Z e y's Case loaded !")
if SERVER then

	resource.AddWorkshop("915891086")

	include("zeycase_core/config/sh_config.lua")
	include("zeycase_core/config/sh_language.lua")
	include("zeycase_core/core/sv_netmsg.lua")
	include("zeycase_core/core/sv_buyitem.lua")

	AddCSLuaFile("zeycase_core/config/sh_config.lua")
	AddCSLuaFile("zeycase_core/config/sh_language.lua")
	AddCSLuaFile("zeycase_core/dermas/cl_core.lua")
	AddCSLuaFile("zeycase_core/dermas/cl_fonts.lua")
	AddCSLuaFile("zeycase_core/dermas/cl_robui.lua")
	AddCSLuaFile("zeycase_core/dermas/cl_storeui.lua")

	local savedStores = false
	hook.Add( "InitPostEntity", "savedstore_spawning", function()
		file.CreateDir( "stores" )
		if not file.Exists( "stores/storefile.txt", "DATA" ) then
			file.Write( "stores/storefile.txt", util.TableToJSON( {} ) )
		else
			savedStores = util.JSONToTable( file.Read( "stores/storefile.txt", "DATA" ) )
		end
	
		if savedStores then
			for _, data in pairs( savedStores ) do
				print("Store spawned")
				local store = ents.Create( "zeycase_corenpc" )
				store:SetPos( data.pos )
				store:SetAngles( data.ang )
				store:Spawn()
			end
		end
	end )

end

if CLIENT then

	include("zeycase_core/config/sh_config.lua")
	include("zeycase_core/config/sh_language.lua")
	include("zeycase_core/dermas/cl_core.lua") 
	include("zeycase_core/dermas/cl_fonts.lua")
	include("zeycase_core/dermas/cl_robui.lua")
	include("zeycase_core/dermas/cl_storeui.lua")

end
print("Z e y's Case loaded !")