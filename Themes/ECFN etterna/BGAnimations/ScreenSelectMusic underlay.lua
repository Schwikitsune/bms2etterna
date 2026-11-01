-- 7k gets the ECFN select background behind the wheel, everything else the
-- song background of Til Death
if not hideMSD() then
	local t = LoadActor("_songbg")
	return t
end

local dir = THEME:GetCurrentThemeDirectory()
if dir:sub(1, 1) ~= "/" then
	dir = "/" .. dir
end
dir = dir .. "BGAnimations/ScreenSelectMusic decorations/ecfn/"

return Def.ActorFrame {
	Def.Quad {
		InitCommand = function(self)
			self:halign(0):valign(0):zoomto(SCREEN_WIDTH, SCREEN_HEIGHT):diffuse(color("0,0,0,1"))
		end,
	},
	Def.Sprite {
		Texture = dir .. "background.png",
		InitCommand = function(self)
			self:halign(0):valign(0):zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
		end,
	},
	-- a fullscreen button for right click pausing so your right clicks dont pause accidentally
	UIElements.QuadButton(-1000, 1) .. {
		InitCommand = function(self)
			self:valign(0):halign(0)
			self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
			self:diffusealpha(0)
		end,
		MouseDownCommand = function(self, params)
			if params.event == "DeviceButton_right mouse button" then
				SCREENMAN:GetTopScreen():PauseSampleMusic()
				MESSAGEMAN:Broadcast("MusicPauseToggled")
			end
		end
	},
}
