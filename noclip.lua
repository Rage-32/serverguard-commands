----
-- This command was put together super fast and somewhat poorly, and it requires some additional effort to use. You CANNOT use "bind v noclip" for this command, you will just start noclipping
-- normally. Instead, you need to do "bind <key> "sg admin"". Replace admin with what you put for lind 9.
----

local command = {}

command.help 				= "Admin Mode."
command.command 			= "admin" -- Can change to whatever you want. Replace with noclip to 
command.permissions			= "AdminMode";
command.arguments 			= {"player"};
command.immunity 			= SERVERGUARD.IMMUNITY.LESSOREQUAL;
command.bDisallowConsole 	= true;

function command:OnPlayerExecute(player, target, arguments)
	if (target:GetMoveType() != MOVETYPE_NOCLIP) then
		target:SetMoveType(MOVETYPE_NOCLIP);
	else
		target:SetMoveType(MOVETYPE_WALK);
	end;
	
		if (target.sg_invisible) then
		target:SetNoDraw(false);
		target:SetNotSolid(false);
		target:GodDisable();
		target:DrawWorldModel(true);
		target.sg_invisible = false;
		target:SendLua( "LocalPlayer().sg_invisible = false;" )
		self:CloakHooks()
	else
		target:SetNoDraw(true);
		target:SetNotSolid(true);
		target:GodEnable();
		target:DrawWorldModel(true);		
		target.sg_invisible = true;
		target:SendLua( "LocalPlayer().sg_invisible = true;" )
		self:CloakHooks()
	end;

	return true;
end;
if CLIENT then surface.CreateFont( "InvisibleFont", {
	font = "Arial",
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
end
if CLIENT then surface.CreateFont( "EspFont", {
	font = "Arial",
	extended = false,
	size = 16,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
end
if CLIENT then hook.Add("HUDPaint", "adminesp", function()
	if LocalPlayer().sg_invisible == true then 
		for k,v in pairs(player.GetAll()) do
			if v != LocalPlayer() then
				local shouldDraw = true
				cam.Start3D()
				v:DrawModel()
				local zOffset = 85
				local x = v:GetPos().x		
				local y = v:GetPos().y		
				local z = v:GetPos().z		
				local pos = Vector(x,y,z+zOffset)	
				if Vector(x,y,z):Distance(LocalPlayer():GetPos()) > 2500 then shouldDraw = false end
				local pos2d = pos:ToScreen()	
				cam.End3D()
				if shouldDraw == true then
					draw.DrawText(v:SteamName()..'['..v:Health()..'%]',"EspFont",pos2d.x,pos2d.y,serverguard.ranks:GetRank(serverguard.player:GetRank(v)).color,TEXT_ALIGN_CENTER)
					draw.DrawText(v:Nick(), "EspFont",pos2d.x,pos2d.y+15,team.GetColor(v:Team()),TEXT_ALIGN_CENTER)
				end
			end
		end

		draw.DrawText("INVISIBLE", "InvisibleFont", ScrW()/2, ScrH()/1.1, Color(255,255,255,255), TEXT_ALIGN_CENTER);
	end
end); end

function command:ContextMenu(player, menu, rankData)
	local option = menu:AddOption("Toggle Invisibility", function()
		serverguard.command.Run("invisible", false, player:Name());
	end);

	option:SetImage("icon16/user_edit.png");
end;

local function OnVehicleEnterdHook(player, vehicle, role)
	if (player.sg_invisible) then
		serverguard.command.stored.invisible:OnPlayerExecute(nil, player)
		serverguard.command.stored.invisible:CloakHooks()
	end
end

local function OnPlayerDeathHook(player, inflictor, attacker)
	if (player.sg_invisible) then
		serverguard.command.stored.invisible:OnPlayerExecute(nil, player)
		serverguard.command.stored.invisible:CloakHooks()
	end
end

local sg_invisibleHookActive = false

function command:CloakHooks()
	local playerCloakedCount = 0
	for k, user in pairs(player.GetAll()) do
		if (user.sg_invisible) then
			playerCloakedCount = playerCloakedCount + 1
		end
	end
	if (not (0 == playerCloakedCount) and not sg_invisibleHookActive) then
		sg_invisibleHookActive = true
		hook.Add("PlayerEnteredVehicle", "serverguard_cloak_PlayerEnteredVehicle", OnVehicleEnterdHook)
		hook.Add("PlayerDeath", "serverguard_cloak_PlayerDeath", OnPlayerDeathHook)
	elseif ((0 == playerCloakedCount) and sg_invisibleHookActive) then
		sg_invisibleHookActive = false
		hook.Remove("PlayerEnteredVehicle", "serverguard_cloak_PlayerEnteredVehicle")
		hook.Remove("PlayerDeath", "serverguard_cloak_PlayerDeath")
	end
end

serverguard.command:Add(command);
