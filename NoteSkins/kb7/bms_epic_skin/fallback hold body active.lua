if Var "Button" == "Key1" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","1 Hold Body" )    
	};
end
if Var "Button" == "Key3" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","3 Hold Body" )    
	};
end
if Var "Button" == "Key7" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","7 Hold Body" )    
	};
end
if Var "Button" == "Key5" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","5 Hold Body" )    
	};
end
if Var "Button" == "Key2" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","2 Hold Body" )    
	};
end
if Var "Button" == "Key6" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","6 Hold Body" )   
	};
end

if Var "Button" == "Key4" then 
	local File = ...
	return
		Def.Sprite {
		Texture=NOTESKIN:GetPath("","4 Hold Body" ) 
		InitCommand=function(self)
			self:addx(50)
		end 
	};
end
