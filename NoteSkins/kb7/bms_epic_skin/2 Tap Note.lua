local Reverse = string.find(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"), "Reverse");
return Def.ActorFrame {
	Def.Sprite {
		Texture="mania-note2";
		Frame0000=0;
		Delay0000=1;
		InitCommand=function(self)
			if Reverse then
				self:addx(48):valign(1)
			else
				self:addx(48):valign(0)
			end
		end;
	};
};