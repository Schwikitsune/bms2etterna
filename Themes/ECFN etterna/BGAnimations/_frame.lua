local t = Def.ActorFrame {}
local topFrameHeight = 35
local bottomFrameHeight = 54
local borderWidth = 4
-- 7k song select: see-through bars over the ECFN background
local ecfn = Var("ecfn") == true
local frameColor = ecfn and color("0,0,0,0.7") or getMainColor("frames")
if ecfn then
	borderWidth = 1
end
local borderColor = ecfn and color("#3f9fff") or getMainColor("highlight")
-- there the ECFN top bar replaces the top frame and the bottom one ends
-- before the wheel, which runs down the whole right side
local bottomWidth = ecfn and ecfnX(1160) or SCREEN_WIDTH

--Frames
if not ecfn then
	t[#t + 1] = UIElements.QuadButton(1, 1) .. {
		InitCommand = function(self)
			self:xy(0, 0):halign(0):valign(0):zoomto(SCREEN_WIDTH, topFrameHeight):diffuse(frameColor)
		end
	}
end

t[#t + 1] = UIElements.QuadButton(1, 1) .. {
	InitCommand = function(self)
		self:xy(0, SCREEN_HEIGHT):halign(0):valign(1):zoomto(bottomWidth, bottomFrameHeight):diffuse(frameColor)
	end
}

--FrameBorders
if not ecfn then
	t[#t + 1] = Def.Quad {
		InitCommand = function(self)
			self:xy(0, topFrameHeight):halign(0):valign(1):zoomto(SCREEN_WIDTH, borderWidth):diffuse(borderColor):diffusealpha(
				0.5
			)
		end
	}
end

t[#t + 1] = Def.Quad {
	InitCommand = function(self)
		self:xy(0, SCREEN_HEIGHT - bottomFrameHeight):halign(0):valign(0):zoomto(bottomWidth, borderWidth):diffuse(borderColor):diffusealpha(0.5)
	end
}

--[[
if themeConfig:get_data().global.TipType == 2 or themeConfig:get_data().global.TipType == 3 then
	t[#t + 1] =
		LoadFont("Common Normal") ..
		{
			InitCommand = function(self)
				self:xy(SCREEN_CENTER_X, SCREEN_BOTTOM - 7):zoom(0.35):settext(
					getRandomQuotes(themeConfig:get_data().global.TipType)
				):diffuse(borderColor):diffusealpha(0):zoomy(0):maxwidth((SCREEN_WIDTH - 350) / 0.35)
			end,
			BeginCommand = function(self)
				self:sleep(2)
				self:smooth(1)
				self:diffusealpha(1)
				self:zoomy(0.35)
			end
		}
end
]]

return t
