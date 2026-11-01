local Reverse = string.find(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"), "Reverse");
return Def.ActorFrame {
	Def.Sprite {
		Texture="mania-noteS";
		Frame0000=0;
		Delay0000=1;
		InitCommand=function(self)
			if Reverse then
				self:zoom(1):valign(1)
			else
				self:zoom(1):valign(0)
			end
		end;
	};
};