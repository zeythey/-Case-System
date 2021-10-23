CASESystem.Config = {}

CASESystem.Config.NPCModel = "models/props_junk/wood_crate001a.mdl"

CASESystem.Config.NPCText = "Weapon Case"

CASESystem.Config.SaveComGroup = {
    ["superadmin"] = true,
    ["admin"] = true
}

CASESystem.Config.StorePrefix = "[Case]"

CASESystem.Config.StorePrefixColor = Color( 210, 195, 20 )

CASESystem.Config.RobPrefix = "[Case]"

CASESystem.Config.RobPrefixColor = Color( 20, 195, 210 )

CASESystem.Config.Font = "Calibri"

CASESystem.Config.RobberySystem = true
 
CASESystem.Config.RobAmount = 2000

CASESystem.Config.RobTime = 20

CASESystem.Config.RobCoodownTime = 90

CASESystem.Config.RobGovernmentAmount = 0.2

CASESystem.Config.RobPlayerAmount = 5

CASESystem.Config.RobMaxDistance = 500

CASESystem.Config.RobShouttime = 45

CASESystem.Config.RobActiveAni = "cower_Idle"

CASESystem.Config.RobAlarmActive = true

CASESystem.Config.RobAlarmDir = "ambient/alarms/alarm1.wav"

CASESystem.Config.RobMoneybagSystem = true

CASESystem.Config.RobMoneybagModel = "models/props_junk/cardboard_box003b.mdl"

CASESystem.Config.CanRobSpec = true

CASESystem.Config.CanRobJobs = {
    TEAM_MOB,
    TEAM_GANG,
    TEAM_THIEF
}

CASESystem.Config.ConsideredCops = {
    TEAM_MAYOR,
    TEAM_CHIEF,
    TEAM_POLICE
}

CASESystem.Config.ForceWeapon = false

CASESystem.Config.ForceWeaponWeapons = {
    "weapon_pistol",
    "weapon_shotgun",
    "weapon_357"
}

CASESystem.Config.ShopBuyColor = Color(51, 255, 63)

CASESystem.Config.ShopBuyDenyColor = Color(255, 51, 51)

CASESystem.Config.AnimateUISlide = true

CASESystem.Config.KeepUIOpen = false

CASESystem.Config.ShowUnpurchasable = true

CASESystem.Config.ShopModelRotate = true

CASESystem.Config.ShopTabs = {
    [1] = { display = "Weapons",            tabcolor = Color(51, 186, 255 ) },
    [2] = { display = "VIP",            tabcolor = Color(51, 186, 255 ) },


}

-- name, this is the display name for the item
-- desc, this is the short description for the item
-- ent, this is the actual entity that will be spawned
-- price, this is the price for the item
-- model, this is the display model for the item

CASESystem.Config.ShopContent = {
    [1] = { name = "Crowbar",               desc = "Weapons but not really",                ent = "weapon_crowbar",     price = 10,       model = "models/weapons/w_crowbar.mdl",     tab = "Weapons",    isWep = true	},
    [2] = { name = "Ball",         desc = "A ball",               ent = "sent_ball",          price = 20,    model = "models/dav0r/hoverball.mdl",       tab = "VIP",        isWep = false,	customCheck = function(ply) return table.HasValue({"vip", "vip+", "superadmin"}, ply:GetUserGroup()) end },

}   