local Reverse = string.find(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"), "Reverse");
return Def.ActorFrame {
	Def.Sprite {
		Texture="mania-note1";
		Frame0000=0;
		Delay0000=1;
		InitCommand=function(self)
			if Reverse then
				self:addx(24):valign(1)
			else
				self:addx(24):valign(0)
			end
		end;
	};
};