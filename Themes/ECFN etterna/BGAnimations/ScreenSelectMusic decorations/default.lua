local t = Def.ActorFrame {}

-- 7k: panels of the beatoraja ECFN skin, under the Til Death tabs
if hideMSD() then
	-- with the extension, "ecfn" alone loads the ecfn/ image folder
	t[#t + 1] = LoadActor("ecfn.lua")
end
t[#t + 1] = LoadActor("tabs")
t[#t + 1] = LoadActor("wifetwirl")
t[#t + 1] = LoadActor("msd")
t[#t + 1] = LoadActor("songsearch")
t[#t + 1] = LoadActor("score")
t[#t + 1] = LoadActor("profile")
t[#t + 1] = LoadActor("filter")
t[#t + 1] = LoadActor("goaltracker")
t[#t + 1] = LoadActor("playlists")
t[#t + 1] = LoadActor("downloads")
t[#t + 1] = LoadActor("tags")
t[#t + 1] = LoadActor("stepsdisplay")

t[#t + 1] = LoadActor("../_mousewheelscroll")
collectgarbage()
return t
