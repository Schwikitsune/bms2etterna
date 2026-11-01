local t = Def.ActorFrame{
--Judgeline
	Def.Sprite {
		Texture="judgeline";
		Frame0000=0;
		Delay0000=1;
		InitCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'InitCommand');
		NoneCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand');
		PressCommand=NOTESKIN:GetMetricA('ReceptorArrow', 'NoneCommand');
	};

};

return t;