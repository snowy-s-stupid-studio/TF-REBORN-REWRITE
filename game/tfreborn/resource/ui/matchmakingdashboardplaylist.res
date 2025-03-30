#base "MatchMakingDashboardSidePanel.res"

"Resource/UI/MatchMakingDashboardPlayList.res"
{
	"ExpandableList"
	{
		"fieldName"		"ExpandableList"
		"xpos"			"r0"
		"ypos"			"c-241"
		"zpos"			"1001"
		"wide"			"f0+10"
		"tall"			"421"
		"visible"		"1"
		"proportionaltoparent"	"1"
    }
	
	"Background"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"Background"
			"xpos"			"-60"
			"ypos"			"-40"
			"zpos"			"52"
			"wide"			"1120"
			"tall"			"1120" 
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/colour"
			"scaleImage"	"1"
			"proportionaltoparent" "1"
		}
	
	"Title"
	{
		"ControlName"		"Label"
		"fieldName"		"Title"
		"xpos"		"26"
		"ypos"		"26"
		"zpos"		"99"
		"wide"		"f0"
		"tall"		"20"
		"proportionaltoparent"	"1"
		"labeltext"		"Select Mode"
		"textAlignment"	"west"
		"font"			"HudFontMediumBold"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}

	"playlist"
	{
		"ControlName"	"CTFPlaylistPanel"
		"fieldName"		"playlist"
		"xpos"			"8"
		"ypos"			"50"
		"zpos"			"152"
		"wide"			"f0+10"
		"tall"			"421"
		"visible"		"1"
		"proportionaltoparent"	"1"
	}
	
	"BackToMenuButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"BackToMenuButton"
		"xpos"			"c228"
		"labelText"		"Back to Main Menu >>"
		"ypos"			"c180"
		"zpos"			"153"
		"wide"			"180"
		"tall"			"23"
		"visible"		"1"
		"enabled"       "1"
		"proportionaltoparent"	"1"
		"command"		"nav_close"
		"textinsetx"    "20"

		"textAlignment"	"west"
		"font"			"HudFontSmallBold"
		
		"sound_armed"		"UI/buttonrollover.wav"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"

		"border_default"	"MainMenuButtonElder"
		"border_armed"		"MainMenuButtonElderArmed"
		"paintbackground"	"0"
		
		"defaultFgColor_override" "46 43 42 255"
		"armedFgColor_override" "235 226 202 255"
		"depressedFgColor_override" "46 43 42 255"
	}
	
	"CasualCriteria1"
	{
		"ControlName"		"Label"
		"fieldName"		"CasualCriteria1"
		"xpos"		"c-314"
		"ypos"		"c+133"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"Play a match of Team Fortress 2 with"
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"CasualCriteria2"
	{
		"ControlName"		"Label"
		"fieldName"		"CasualCriteria2"
		"xpos"		"c-314"
		"ypos"		"c+143"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"other players in a game mode of your liking."
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"		//"142 137 122 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MvMCriteria1"
	{
		"ControlName"		"Label"
		"fieldName"		"MvMCriteria1"
		"xpos"		"c+110"
		"ypos"		"c+133"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"Cooperate on a team of 6 players to"
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MvMCriteria2"
	{
		"ControlName"		"Label"
		"fieldName"		"MvMCriteria2"
		"xpos"		"c+110"
		"ypos"		"c+143"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"defeat waves of murderous robots."
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"		//"142 137 122 255"
		
		"mouseinputenabled"	"0"
	}
	
	"QPCriteria1"
	{
		"ControlName"		"Label"
		"fieldName"		"QPCriteria1"
		"xpos"		"c-102"
		"ypos"		"c+133"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"Automatically find a community server in"
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"QPCriteria2"
	{
		"ControlName"		"Label"
		"fieldName"		"QPCriteria2"
		"xpos"		"c-102"
		"ypos"		"c+143"
		"zpos"		"99"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"a game mode of your choosing."
		"textAlignment"	"west"
		"font"			"HudFontSmallest"
		"fgcolor_override"	"235 226 202 255"		//"142 137 122 255"
		
		"mouseinputenabled"	"0"
	}
}
