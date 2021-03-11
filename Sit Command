---
-- Sit command made by Rage & Jay.Cubed
---
local command = {};
 
command.help                = "Go to the admin room.";
command.command             = "sit";
command.arguments            = {"player"};
command.permissions            = "Sit";
command.bDisallowConsole    = true;
command.bSingleTarget        = true;
command.immunity             = SERVERGUARD.IMMUNITY.ANY;
command.aliases                = {"adminroom"};
 
function command:OnPlayerExecute(player, target)
    local adminroom = ( Vector( 2681, -4465, -139 ) );
    
    if (serverguard.player:HasPermission(player, "sit")) then
        target:SetPos(adminroom);
    end
end;
 
function command:OnNotify(player)
    return SGPF("command_goto", serverguard.player:GetName(player), util.GetNotifyListForTargets(targets));
end;
 
function command:ContextMenu(player, menu, rankData)
    local option = menu:AddOption("sit", function()
        serverguard.command.Run("sit", false, player:Name());
    end);
 
    option:SetImage("icon16/wand.png");
end;
 
serverguard.command:Add(command);
 
--I haven't tested this with the newest update yet, but if someone wants to use this they can. if there are any errors contact me on discord and we can sort it out. rage#2014 on Discord. Enjoy.
