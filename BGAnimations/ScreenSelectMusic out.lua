local SwitchSpeedModType = function(player, type)
	local mods = SL[ToEnumShortString(player)].ActiveModifiers
	local playeroptions = GAMESTATE:GetPlayerState(player):GetPlayerOptions("ModsLevel_Preferred")
	playeroptions[type.."Mod"](playeroptions, mods.SpeedMod or 1.00)
	mods.SpeedModType = type
end

return Def.ActorFrame{
	InitCommand=function(self) self:draworder(200) end,
	Def.Quad{
		InitCommand=function(self) self:diffuse(0,0,0,0):FullScreen():cropbottom(1):fadebottom(0.5) end,
		OffCommand=function(self)
			-- If the song is a "no cmod", switch the speed mod type to MMod if on a Cmod when
			-- a song is selected but before player options to allow
			-- switching back to a CMod
			-- Also switch back to CMod if playing a cmoddable song.
			-- in b4 someone makes a song with "no cmod" in the title
			for pn in ivalues(GAMESTATE:GetHumanPlayers()) do
				SL[ToEnumShortString(pn)].ActiveModifiers.MissBecauseHeld = true
				local existingType = SL[ToEnumShortString(pn)].ActiveModifiers.SpeedModType
				if string.find(string.lower(GAMESTATE:GetCurrentSong():GetDisplayFullTitle()), "no cmod") then
					if existingType == "C" then
						SwitchSpeedModType(pn, "M")
					end
				end
			end
			self:linear(0.3):cropbottom(-0.5):diffusealpha(1) 
		end
	},

	LoadFont("Common Bold")..{
		Text=THEME:GetString("ScreenSelectMusic", "Press Start for Options"),
		InitCommand=function(self) self:visible(false):Center():zoom(0.75) end,
		ShowPressStartForOptionsCommand=function(self) self:visible(true) end,
		ShowEnteringOptionsCommand=function(self) self:linear(0.125):diffusealpha(0):queuecommand("NewText") end,
		NewTextCommand=function(self) self:hibernate(0.1):settext(THEME:GetString("ScreenSelectMusic", "Entering Options...")):linear(0.125):diffusealpha(1):sleep(1) end
	}
}