-- LR2 judge line plus the key beam ("laser") that lights the lane while the key is down.
-- Drawn additively so the beam's black top blends into the lane.
-- LR2 timings: beam grows over 100 ms on key on, fades over 200 ms on key off.
local colors = {
	Key1 = "White", Key2 = "Blue", Key3 = "White", Key4 = "Blue",
	Key5 = "White", Key6 = "Blue", Key7 = "White"
}
local col = colors[Var "Button"] or "White"

return Def.ActorFrame {
	-- the beam points toward incoming notes: up with Reverse, down without
	Def.ActorFrame {
		ReverseOnCommand = function(self)
			self:rotationz(0)
		end,
		ReverseOffCommand = function(self)
			self:rotationz(180)
		end,
		Def.Sprite {
			Texture = col .. " Key Beam.png",
			InitCommand = function(self)
				self:valign(1):blend("BlendMode_Add"):diffusealpha(0)
			end,
			PressCommand = function(self)
				self:finishtweening():diffusealpha(1):zoomy(0):decelerate(0.1):zoomy(1)
			end,
			LiftCommand = function(self)
				self:finishtweening():zoomy(1):linear(0.2):diffusealpha(0)
			end
		}
	},
	Def.Sprite {
		Texture = "_judgeline.png"
	}
}
