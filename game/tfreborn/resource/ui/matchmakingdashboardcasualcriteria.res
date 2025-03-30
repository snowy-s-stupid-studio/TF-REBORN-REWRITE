#base "matchmakingdashboardsidepanel.res"

"Resource/UI/MatchMakingDashboardCasualCriteria.res"
{
	"CasualCriteria"
	{
		"fieldName"		"CasualCriteria"
		"xpos"			"r0"
		"ypos"			"0"
		"zpos"			"1002"
		"wide"			"f1"
		"tall"			"f0"
		"visible"		"1"
		"proportionaltoparent"	"1"
	}

	"Title"
	{
		"ControlName"		"Label"
		"fieldName"		"Title"
		"xpos"		"8"
		"ypos"		"20"
		"zpos"		"99"
		"wide"		"f0"
		"tall"		"20"
		"proportionaltoparent"	"1"
		"labeltext"		"#TF_Matchmaking_HeaderQuickplay"
		"textAlignment"	"west"
		"font"			"HudFontMediumBigBold"
		"fgcolor_override"	"TanDark"
		
		"mouseinputenabled"	"0"
	}

	"criteria"
	{
		"ControlName"	"CCasualCriteriaPanel"
		"fieldName"		"criteria"
		"xpos"			"127"
		"ypos"			"83"
		"zpos"			"100"
		"wide"			"267"
		"tall"			"f162"
		"visible"		"1"
		"proportionaltoparent"	"1"
	}
	
	"Panel"
	{
		"ControlName"	"EditablePanel"
		"fieldName"		"Panel"
		"xpos"			"127"
		"ypos"			"75"
		"zpos"			"99"
		"wide"			"267"
		"tall"			"336"
		"visible"		"1"
		"pinCorner"		"0"
		"autoResize"	"0"
		"PaintBackgroundType"	"0"
		"border"		"MainMenuBGBorder"
	}

	"ToolTipButtonHack"
	{
		"ControlName"	"EditablePanel"
		"fieldName"		"ToolTipButtonHack"
		"xpos"			"c156"
		"ypos"			"436"
		"zpos"			"101"
		"wide"			"170"
		"tall"			"30"
		"visible"		"0"
		"enabled"		"0"
		"mouseinputenabled"	"1"
		"eatmouseinput"	"0"	
		"showtooltipswhenmousedisabled"	"1"
		"proportionaltoparent" "1"
	}

	"QueueButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"QueueButton"
		"xpos"			"c156"
		"ypos"			"436"
		"zpos"			"100"
		"wide"			"170"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"find_game"
		"proportionaltoparent"	"1"
		"labeltext"		"#TF_Matchmaking_StartSearch"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"

		"sound_armed"		"UI/buttonrollover.wav"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"

		"border_default"	"MainMenuButtonDefault"
		"border_armed"		"MainMenuButtonArmed"
		"paintbackground"	"0"
	
		"defaultFgColor_override" "46 43 42 255"
		"armedFgColor_override" "235 226 202 255"
		"depressedFgColor_override" "46 43 42 255"
	}
	
	"ExitButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"ExitButton"
		"xpos"			"101"
		"ypos"			"436"
		"zpos"			"201"
		"wide"			"130"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"nav_close"
		"proportionaltoparent"	"1"
		"labeltext"		"Close"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"
		
		"sound_armed"		"UI/buttonrollover.wav"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"

		"border_default"	"MainMenuButtonDefault"
		"border_armed"		"MainMenuButtonArmed"
		"paintbackground"	"0"
	
		"defaultFgColor_override" "46 43 42 255"
		"armedFgColor_override" "235 226 202 255"
		"depressedFgColor_override" "46 43 42 255"
	}
	
	"Background"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"Background"
			"xpos"			"-60"
			"ypos"			"-40"
			"zpos"			"80"
			"wide"			"1120"
			"tall"			"1120" 
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/background"
			"scaleImage"	"1"
			"proportionaltoparent" "1"
		}
		
	"BackgroundFooter"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"BackgroundFooter"
		"xpos"			"0"
		"ypos"			"r58"
		"zpos"			"81"
		"wide"			"f0"
		"tall"			"60"
		"visible"		"1"
		"enabled"		"1"
		"image"			"loadout_bottom_gradient"
		"tileImage"		"1"
	}
	
	"FooterLine"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"FooterLine"
		"xpos"			"0"
		"ypos"			"r60"
		"zpos"			"82"
		"wide"			"f0"
		"tall"			"10"
		"visible"		"1"
		"enabled"		"1"
		"image"			"loadout_solid_line"
		"scaleImage"	"1"
	}
	
	"BackgroundHeader"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"BackgroundHeader"
		"xpos"			"0"
		"ypos"			"0"
		"zpos"			"190"
		"wide"			"f0"
		"tall"			"52"
		"visible"		"1"
		"enabled"		"1"
		"image"			"loadout_header"
		"tileImage"		"1"
	}
	
	"UpperLine"
	{
		"ControlName"	"ImagePanel"
		"fieldName"		"UpperLine"
		"xpos"			"0"
		"ypos"			"50"
		"zpos"			"193"
		"wide"			"f0"
		"tall"			"10"
		"visible"		"1"
		"enabled"		"1"
		"image"			"loadout_solid_line"
		"scaleImage"	"1"
	}
	
		"MOTDBG"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"MOTDBG"
			"xpos"			"c-7"
			"ypos"			"76"
			"zpos"			"185"
			"wide"			"300"
			"tall"			"333"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/something"
			"scaleImage"	"1"
		}
		
		"MOTDBG2"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"MOTDBG2"
			"xpos"			"c-7"
			"ypos"			"76"
			"zpos"			"184"
			"wide"			"300"
			"tall"			"333"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/something"
			"scaleImage"	"1"
		}
		
		"MOTDBG3"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"MOTDBG3"
			"xpos"			"c-7"
			"ypos"			"76"
			"zpos"			"184"
			"wide"			"300"
			"tall"			"333"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/something"
			"scaleImage"	"1"
		}
		
	"ImageMercenaries"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"ImageMercenaries"
			"xpos"			"c43"
			"ypos"			"70"
			"zpos"			"186"
			"wide"			"200"
			"tall"			"200"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/mercs"
			"scaleImage"	"1"
		}
		
	"MOTDTitle"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDTitle"
		"xpos"		"c51"
		"ypos"		"73"
		"zpos"		"190"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"Welcome to Casual!"
		"textAlignment"	"west"
		"font"			"HudFontMediumSmallBold"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-174"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"When you queue up for a casual match, you will"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText1"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-160" //14
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"be matched into a 12v12 game based on the"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText2"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-146"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"game modes you've selected. If empty slots"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText3"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-132"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"are available on a server, players may connect"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText3"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-118"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"into a match in progress."
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText4"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-94" //24
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"Additionally if you lose connection to the server,"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText5"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c10"
		"ypos"		"c-80"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"you may rejoin the Casual match in progress."
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
		
	"LearnMore"
	{
		"ControlName"	"CExButton"
		"fieldName"		"LearnMore"
		"xpos"			"c81"
		"ypos"			"362"
		"zpos"			"190"
		"wide"			"125"
		"tall"			"29"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"command"		"url https://wiki.teamfortress.com/wiki/Casual_Mode"
		"proportionaltoparent"	"1"
		"labelText"		"Learn More"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"
		
		"sound_armed"		"UI/buttonrollover.wav"
		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"

		"border_default"	"MainMenuButtonDefault"
		"border_armed"		"MainMenuButtonArmed"
		"paintbackground"	"0"
	
		"defaultFgColor_override" "46 43 42 255"
		"armedFgColor_override" "235 226 202 255"
		"depressedFgColor_override" "46 43 42 255"
	}
}
