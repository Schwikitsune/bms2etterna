-- lr2skin: kb7 noteskin built from the LR2beta3 default play skin
-- (LR2files/Theme/LR2/Play, "LR2 default" frame/bomb textures by cyclia).
--
-- Columns follow the LR2 7-key layout: keys 1,3,5,7 are white, 2,4,6 are blue.
-- Every element that is not colour specific lives in a "Fallback <Element>" file.

local ret = ... or {}

ret.ColumnColor = {
	Key1 = "White",
	Key2 = "Blue",
	Key3 = "White",
	Key4 = "Blue",
	Key5 = "White",
	Key6 = "Blue",
	Key7 = "White"
}

-- LR2 has no separate roll graphics, no lift/fake notes and a single LN look
ret.ElementRedir = {
	["Tap Lift"] = "Tap Note",
	["Tap Fake"] = "Tap Note",
	["Hold Head Inactive"] = "Hold Head Active",
	["Hold Tail Inactive"] = "Hold Tail Active",
	["Roll Head Active"] = "Hold Head Active",
	["Roll Head Inactive"] = "Hold Head Active",
	["Roll Tail Active"] = "Hold Tail Active",
	["Roll Tail Inactive"] = "Hold Tail Active",
	["Roll Body Active"] = "Hold Body Active",
	["Roll Body Inactive"] = "Hold Body Inactive"
}

-- the LN is drawn as head + body + tail; caps are not used
ret.Blank = {
	["Hold TopCap Active"] = true,
	["Hold TopCap Inactive"] = true,
	["Hold BottomCap Active"] = true,
	["Hold BottomCap Inactive"] = true,
	["Roll TopCap Active"] = true,
	["Roll TopCap Inactive"] = true,
	["Roll BottomCap Active"] = true,
	["Roll BottomCap Inactive"] = true
}

ret.Redir = function(sButton, sElement)
	return ret.ColumnColor[sButton] or "White", ret.ElementRedir[sElement] or sElement
end

local function func()
	local sButton = Var "Button"
	local sElement = Var "Element"

	if ret.Blank[sElement] then
		local t
		if Var "SpriteOnly" then
			t = LoadActor("_blank")
		else
			t = Def.Actor {}
		end
		return t .. {
			InitCommand = function(self)
				self:visible(false)
			end
		}
	end

	local sButtonToLoad, sElementToLoad = ret.Redir(sButton, sElement)
	return LoadActor(NOTESKIN:GetPath(sButtonToLoad, sElementToLoad))
end

ret.Load = func
ret.CommonLoad = func

return ret
