--Port of R Skin v2.1 (7k)
-- 26/07/2020

local Noteskin = ... or {};
local button = Var "Button"

--Column redirs. Controls file sets for each column
Noteskin.ButtonRedirs = {

--Since this skin uses tricks to reposition columns
--you should NOT touch this. Swapping columns will
--seriously mess things up
	
	--kb7(7k)
	Key1		= "1";
	Key2		= "2";
	Key3		= "3";
	Key4		= "4";
	Key5		= "5";
	Key6		= "6";
	Key7		= "7";
};

--Element redirects
Noteskin.ElementRedirs = {

	--Make dim and bright explosion the same
	["Tap Explosion Dim"] = "Tap Explosion Bright";

	--Blank out hold heads and tails
	["Hold Head Active"] 			= "Zblank";
	["Hold Head Inactive"] 			= "Zblank";
	["Roll Head Active"] 			= "Zblank";
	["Roll Head Inactive"] 			= "Zblank";
	["Hold TopCap Active"]			= "Zblank";
	["Hold TopCap Inactive"]		= "Zblank";
	["Roll TopCap Active"]			= "Zblank";
	["Roll TopCap Inactive"]		= "Zblank";
	["Roll BottomCap Active"]		= "Zblank";
	["Roll BottomCap Inactive"]		= "Zblank";
	["Roll Body Inactive"]			= "Zblank";
	["Roll Body Active"]			= "Zblank";
	["Hold Tail Active"] 			= "Zblank";
	["Hold Tail Inactive"] 			= "Zblank";
	["Roll Tail Active"] 			= "Zblank";
	["Roll Tail Inactive"] 			= "Zblank";
	["Tap Mine"]					= "Zblank";

	--Redirect hold bodies
	["Hold Body Active"]		= "Hold Body";
	["Hold Body Inactive"]		= "Hold Body";
	["Roll Body Active"]		= "Roll Body";
	["Roll Body Inactive"]		= "Roll Body";

	--Make rolls and holds share explosions
	["Roll Explosion"]			= "Hold Explosion";
};

--Invisible elements
Noteskin.Hide = {
	["Tap Fake"] 				= true;
	["Tap Lift"] 				= true;
};

--Rotations
Noteskin.BaseRotX = {
	Left	= 0;
	UpLeft	= 0;
	Up		= 0;
	Down	= 0;
	UpRight	= 0;
	Right	= 0;
};
Noteskin.BaseRotY = {
	Left	= 0;
	UpLeft	= 0;
	Up		= 0;
	Down	= 0;
	UpRight	= 0;
	Right	= 0;
};

--This part loads elements but I honestly have no clue how it works
local function NoteskinLoader()
	local Button = Var "Button"
	local Element = Var "Element"

	if Noteskin.Hide[Element] then
		--Return a blank element. If SpriteOnly is set, we need to return a
		--sprite; otherwise just return a dummy actor.
		local t;
		if Var "SpriteOnly" then
			t = LoadActor( "_blank" );
		else
			t = Def.Actor {};
		end
		return t .. {
			InitCommand = function(self)
    			self:visible(false)
  			end
		};
	end;


	--Load element and button, using redirs
	local LoadElement = Noteskin.ElementRedirs[Element]
	if not LoadElement then
		LoadElement = Element;
	end;

	local LoadButton = Noteskin.ButtonRedirs[Button]
	if not LoadButton then
		LoadButton = Button;
	end;

	--Get path to thing
	local sPath = NOTESKIN:GetPath( LoadButton, LoadElement );

	--Make actor
	local t = LoadActor( sPath );

	--Apply rotation
	t.BaseRotationX=Noteskin.BaseRotX[sButton]
	t.BaseRotationY=Noteskin.BaseRotY[sButton]
	
	return t;
end

Noteskin.Load = NoteskinLoader;
Noteskin.CommonLoad = NoteskinLoader;
return Noteskin;