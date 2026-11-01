local Reverse = string.find(GAMESTATE:GetPlayerState(pn):GetPlayerOptionsString("ModsLevel_Preferred"), "Reverse");

local t = Def.ActorFrame{

--Stage background
	Def.Quad {
		InitCommand=function(self)
			if Reverse then
				self:halign(0)
				self:valign(1)
				self:zoomto(280,2048)
				self:diffuse(color("#000000"))
				self:addx(72 - 20)
				self:addy(76)
			else
				self:halign(1)
				self:valign(1)
				self:zoomto(280,2048)
				self:diffuse(color("#000000"))
				self:addx(72 - 20)
				self:addy(-76)
				self:addrotationz(180)
			end
		end
	};


--Judgeline
	Def.Sprite {
		Texture="judgeline";
		Frame0000=0;
		Delay0000=1;
		InitCommand=function(self)
			self:addx(72)
		end,
		NoneCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand');
		PressCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand');
	};

};

return t;