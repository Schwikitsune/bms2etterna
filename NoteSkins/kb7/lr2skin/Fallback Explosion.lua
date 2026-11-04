-- lr2skin hit effects, drawn here directly instead of through common's explosion stack.
--  * LR2 bomb: 9 frames over 150 ms, additive, on PGREAT/GREAT/GOOD (W1-W3)
--    and on a cleanly released LN. BAD/POOR get no bomb, as in LR2.
--  * LR2 LN flame: 4 frames looping every 100 ms while an LN is held,
--    standing on the judge line and pointing toward incoming notes.
local BOMB_ZOOM = 2 -- 1 = LR2 size (106 px)
local HOLD_ZOOM = 2 -- 1 = LR2 size (43x84 px)
local BOMB_TIME = 0.15

local function reverse()
	local ok, rev = pcall(function()
		return GAMESTATE:GetPlayerState():GetCurrentPlayerOptions():UsingReverse()
	end)
	return ok and rev
end

local function bomb(self)
	self:finishtweening():visible(true):diffuse(1, 1, 1, 1):setstate(0):animate(true)
	self:sleep(BOMB_TIME):queuecommand("Hide")
end

local function flameOn(self)
	self:rotationz(reverse() and 0 or 180):visible(true):animate(true)
end

local function flameOff(self)
	self:visible(false):animate(false)
end

return Def.ActorFrame {
	-- LN flame
	Def.Sprite {
		Texture = "_hold bomb 4x1.png",
		Frames = Sprite.LinearFrames(4, 0.1),
		InitCommand = function(self)
			self:blend("BlendMode_Add"):valign(1):zoom(HOLD_ZOOM)
			flameOff(self)
		end,
		HoldingOnCommand = flameOn,
		RollOnCommand = flameOn,
		HoldingOffCommand = flameOff,
		RollOffCommand = flameOff
	},
	-- bomb
	Def.Sprite {
		Texture = "_bomb 4x4.png",
		Frames = Sprite.LinearFrames(9, BOMB_TIME),
		InitCommand = function(self)
			self:blend("BlendMode_Add"):zoom(BOMB_ZOOM):visible(false):animate(false)
		end,
		W1Command = bomb,
		W2Command = bomb,
		W3Command = bomb,
		HeldCommand = bomb,
		HideCommand = function(self)
			self:visible(false):animate(false)
		end
	}
}
