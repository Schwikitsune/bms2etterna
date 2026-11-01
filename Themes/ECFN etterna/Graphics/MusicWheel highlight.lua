-- 7k: the ECFN cursor around the selected bar, with its slow glow
if hideMSD() then
	local s = ecfnScale()
	local dir = THEME:GetCurrentThemeDirectory()
	if dir:sub(1, 1) ~= "/" then
		dir = "/" .. dir
	end
	local cursor = dir .. "BGAnimations/ScreenSelectMusic decorations/ecfn/cursor.png"
	return Def.ActorFrame {
		Def.Sprite {
			Texture = cursor,
			InitCommand = function(self)
				self:halign(0):xy(-50 * s, 0):zoomto(712 * s, 83 * s)
			end,
		},
		Def.Sprite {
			Texture = cursor,
			InitCommand = function(self)
				-- an effect, not tweens: the wheel stops placing its items while
				-- anything in it is tweening
				self:halign(0):xy(-50 * s, 0):zoomto(712 * s, 83 * s):blend("BlendMode_Add")
				self:diffuseshift():effectcolor1(color("1,1,1,0")):effectcolor2(color("1,1,1,0.6")):effectperiod(2.5)
			end,
		},
	}
end

return Def.ActorFrame {
	Def.Quad {
		Name = "Horizontal",
		InitCommand = function(self)
			self:xy(0, -2):zoomto(854, 34):halign(0)
		end,
		SetCommand = function(self)
			self:diffuseramp()
			self:effectcolor1(color("#FFFFFF33"))
			self:effectcolor2(color("#FFFFFF33"))
		end,
		BeginCommand = function(self)
			self:queuecommand("Set")
		end,
		OffCommand = function(self)
			self:visible(false)
		end
	}
}
