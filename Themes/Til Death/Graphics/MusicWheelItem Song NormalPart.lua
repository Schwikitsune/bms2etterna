local lastclick = GetTimeSinceStart()
local requiredtimegap = 0.1

return Def.ActorFrame {
    -- 7k songs: background behind the title in the color of the best gauge cleared
    Def.Quad {
        InitCommand = function(self)
            self:halign(0):xy(0, -2):zoomto(854, 34)
            self:diffusealpha(0)
        end,
        SetCommand = function(self, params)
            local lamp = params.Song and getBestBMSLampForSong(params.Song)
            if lamp then
                local c = getBMSLampInfo(lamp, 2)
                self:diffuseleftedge({c[1], c[2], c[3], 0.45})
                self:diffuserightedge({c[1], c[2], c[3], 0.08})
            else
                self:diffusealpha(0)
            end
        end,
    },
    UIElements.QuadButton(1, 1) .. {
		InitCommand = function(self)
			self:halign(0)
			self:xy(0,0)
			self:diffusealpha(0)
			self:zoomto(854, 38)
		end,
        SetCommand = function(self, params)
            self.index = params.DrawIndex
        end,
		MouseDownCommand = function(self, params)
            if params.event == "DeviceButton_left mouse button" then
                local now = GetTimeSinceStart()
                if now - lastclick < requiredtimegap then return end
                lastclick = now

                local numwheelitems = 15
                local middle = math.ceil(15 / 2)
                local top = SCREENMAN:GetTopScreen()
                local we = top:GetMusicWheel()
                if we then
                    local dist = self.index - middle
                    if dist == 0 and we:IsSettled() then
                        -- clicked current item
                        top:SelectCurrent()
                    else
                        local itemtype = we:MoveAndCheckType(self.index - middle)
                        we:Move(0)
                        if itemtype == "WheelItemDataType_Section" then
                            -- clicked a group
                            top:SelectCurrent()
                        end
                    end
                end
            elseif params.event == "DeviceButton_right mouse button" then
                -- right click opens playlists
                local tind = getTabIndex()
	    		setTabIndex(7)
    			MESSAGEMAN:Broadcast("TabChanged", {from = tind, to = 7})
            end
		end,
	},
}
