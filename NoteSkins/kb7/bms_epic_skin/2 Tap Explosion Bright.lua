local button = Var "Button"

--Define buttons as column numbers(left to right)
local mapping_seven = {
	Key1 = 1,
	Key2 = 2,
	Key3 = 3,
	Key4 = 4,
	Key5 = 5,
	Key6 = 6,
	Key7 = 7
}

--Count columns(used below to isolate JudgmentMessageCommand to specific columns)
local function shouldBomb(column, count)
	if count == 7 then
		return mapping_seven[button] == column
	else
		return false
	end
end


local t = Def.ActorFrame{
	--This chaotic line makes sure the original aspect ratio for explosions are kept even when you scale the notefield with customize gameplay
	--Without this, the explosions would get squished or stretched when scaling the notefield
	--It scales the entire actorframe instead of the explosions themselves to make sure it doesn't interfere with the explosion tweens
	InitCommand=function(self)
		local keymode = getCurrentKeyMode()
			self:zoomx(1/playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).GameplaySizes[keymode].NotefieldWidth)
			self:zoomy(1/playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).GameplaySizes[keymode].NotefieldHeight)
			self:addx(48)
	end,

--The following mess is supposed to hide hold explosions when the holds are 16ths or shorter,
--but it ends up hiding the effect on longer holds sometimes as well
	Def.Sprite {
		--This texture is invisible. Code kept so you can swap with your own texture
		Texture="bomb tap off";
		Frames=Sprite.LinearFrames(2,0.128);
		W5Command=NOTESKIN:GetMetricA("Bom", "W5Command");
		W4Command=NOTESKIN:GetMetricA("Bom", "W4Command");
		W3Command=NOTESKIN:GetMetricA("Bom", "W3Command");
		W2Command=NOTESKIN:GetMetricA("Bom", "W2Command");
		W1Command=NOTESKIN:GetMetricA("Bom", "W1Command");
		JudgmentMessageCommand=function(self, params)
			if params.Type ~= "Hold" then return end
			if params.Judgment ~= "HoldNoteScore_Held" then return end
			if shouldBomb(params.FirstTrack, params.NumTracks) then
				local tn = params.TapNote
				local length = tn:GetHoldDuration()
				if length <= 0.25 then
					self:setstate(0):blend("BlendMode_Add"):zoom(.1):diffusealpha(0):linear(.032):zoom(.6):diffusealpha(1):linear(.064):diffusealpha(1):zoom(.6):linear(.032):zoom(.2):diffusealpha(0)
				elseif length > 0.25 then
					self:diffusealpha(0)
				end
			end
		end
	};

	Def.Sprite {
		--This texture is invisible. Code kept so you can swap with your own texture
		Texture="bomb tap2 off";
		Frame0000=0;
		Delay0000=1;
		W5Command=NOTESKIN:GetMetricA("Boom", "W5Command");
		W4Command=NOTESKIN:GetMetricA("Boom", "W4Command");
		W3Command=NOTESKIN:GetMetricA("Boom", "W3Command");
		W2Command=NOTESKIN:GetMetricA("Boom", "W2Command");
		W1Command=NOTESKIN:GetMetricA("Boom", "W1Command");
		HeldCommand=NOTESKIN:GetMetricA("Boom", "HeldCommand");
	};

};

return t;