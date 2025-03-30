#base "MatchMakingDashboardSidePanel.res"

"Resource/UI/MatchMakingDashboardMvMCriteria.res"
{
	"MVMCriteria"
	{
		"fieldName"		"MVMCriteria"
		"xpos"			"0"
		"ypos"			"0"
		"zpos"			"1002"
		"wide"			"f1"
		"tall"			"f0"
		"visible"		"0"
		"proportionaltoparent"	"1"
	}
	
	"Background"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"Background"
			"xpos"			"-60"
			"ypos"			"-40"
			"zpos"			"50"
			"wide"			"1120"
			"tall"			"1120" 
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/colour"
			"scaleImage"	"1"
			"proportionaltoparent" "1"
		}

	"criteria"
	{
		"ControlName"	"CMVMCriteriaPanel"
		"fieldName"		"criteria"
		"xpos"			"93"
		"ypos"			"50"
		"zpos"			"100"
		"wide"			"f0"
		"tall"			"f120"
		"visible"		"1"
		"proportionaltoparent"	"1"

		"pinCorner"		"2"
	}

	"BackButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"BackButton"
		"xpos"			"93"
		"ypos"			"436"
		"zpos"			"120"
		"wide"			"170"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontMediumSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"back"
		"proportionaltoparent"	"1"
		"labeltext"		"#TF_Matchmaking_Back"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		//"actionsignallevel"	"1"

		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}

	"MannUpToolTipButtonHack"
	{
		"ControlName"	"EditablePanel"
		"fieldName"		"MannUpToolTipButtonHack"
		"xpos"			"559"
		"ypos"			"436"
		"zpos"			"101"
		"wide"			"200"
		"tall"			"30"
		"visible"		"0"
		"enabled"		"1"
		"mouseinputenabled"	"1"
		"eatmouseinput"	"0"	
		"showtooltipswhenmousedisabled"	"1"
		"proportionaltoparent" "1"
	}

	"MannUpQueueButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"MannUpQueueButton"
		"xpos"			"559"
		"ypos"			"436"
		"zpos"			"100"
		"wide"			"200"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontMediumSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"start_search"
		"proportionaltoparent"	"1"
		"labeltext"		"Start Search >>"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"

		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}
	
	"MvMGuideBook2"
	{
		"ControlName"	"CExButton"
		"fieldName"		"MvMGuideBook2"
		"xpos"			"296"
		"ypos"			"436"
		"zpos"			"100"
		"wide"			"230"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontMediumSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"url https://steamcommunity.com/sharedfiles/filedetails/?id=461752155"
		"proportionaltoparent"	"1"
		"labeltext"		"MvM Guide Book"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"

		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}

	"BootCampToolTipButtonHack"
	{
		"ControlName"	"EditablePanel"
		"fieldName"		"BootCampToolTipButtonHack"
		"xpos"			"559"
		"ypos"			"436"
		"zpos"			"101"
		"wide"			"200"
		"tall"			"30"
		"visible"		"0"
		"enabled"		"1"
		"mouseinputenabled"	"1"
		"eatmouseinput"	"0"	
		"showtooltipswhenmousedisabled"	"1"
		"proportionaltoparent" "1"
	}

	"BootCampQueueButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"BootCampQueueButton"
		"xpos"			"559"
		"ypos"			"436"
		"zpos"			"100"
		"wide"			"200"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontMediumSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"start_search"
		"proportionaltoparent"	"1"
		"labeltext"		"Start Search >>"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		"actionsignallevel"	"1"

		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}

	"NextButton"
	{
		"ControlName"	"CExButton"
		"fieldName"		"NextButton"
		"xpos"			"93"
		"ypos"			"436"
		"zpos"			"120"
		"wide"			"170"
		"tall"			"30"
		"autoResize"	"0"
		"pinCorner"		"3"
		"visible"		"1"
		"enabled"		"1"
		"tabPosition"	"0"
		"font"			"HudFontMediumSmallBold"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"Command"		"select_tour"
		"proportionaltoparent"	"1"
		"labeltext"		"#TF_MvM_SelectChallenge"
		"mouseinputenabled"	"1"
		"keyboardinputenabled"	"0"
		//"actionsignallevel"	"1"

		"sound_depressed"	"UI/buttonclick.wav"
		"sound_released"	"UI/buttonclickrelease.wav"
	}

	"JoinLateCheckButton"
	{
		"ControlName"		"CheckButton"
		"fieldName"		"JoinLateCheckButton"
		"xpos"		"c72"
		"ypos"		"387"
		"zpos"		"101"
		"wide"		"140"
		"tall"		"20"
		"font"			"HudFontSmallest"
		"labelText"		""
		"proportionaltoparent"	"1"
	}

	"JoinLateLabel"
	{
		"ControlName"		"Label"
		"fieldName"		"JoinLateLabel"
		"xpos"		"c97"
		"ypos"		"387"
		"zpos"		"101"
		"wide"		"135"
		"tall"		"20"
		"font"			"HudFontSmall"
		"labelText"		"#TF_Matchmaking_JoinInProgress"
		"proportionaltoparent"	"1"
	}
	
	"MOTDBG"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"MOTDBG"
			"xpos"			"c+72"
			"ypos"			"62"
			"zpos"			"185"
			"wide"			"260"
			"tall"			"320"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/something"
			"scaleImage"	"1"
		}
		
		"MOTDBG1"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"MOTDBG1"
			"xpos"			"c+72"
			"ypos"			"62"
			"zpos"			"185"
			"wide"			"260"
			"tall"			"320"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/something"
			"scaleImage"	"1"
		}
		
		"MOTDTitle"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDTitle"
		"xpos"		"c99"
		"ypos"		"60"
		"zpos"		"190"
		"wide"		"300"
		"tall"		"50"
		"proportionaltoparent"	"1"
		"labeltext"		"Introducing TF2 Co-op"
		"textAlignment"	"west"
		"font"			"HudFontMediumSmallBold"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"Mannworks"
		{
			"ControlName"	"ImagePanel"
			"fieldName"		"Mannworks"
			"xpos"			"c130"
			"ypos"			"80"
			"zpos"			"186"
			"wide"			"145"
			"tall"			"145"
			"visible"		"1"
			"enabled"		"1"
			"image"			"/replay/thumbnails/mm/mvm/poster"
			"scaleImage"	"1"
		}
		
	"MOTDText"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"46"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"Mann vs. Machine is a new co-operative"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText2"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"60"
		"zpos"		"190"
		"wide"		"312"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"game for Team Fortress 2 that lets you"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText3"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"74"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"and five friends wage a desperate battle"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText4"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"88"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"to stop a lethal horde of robots from"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText5"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"102"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"deploying a bomb in one of Mann Co.’s"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText6"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"116"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"many strongholds. Take advantage of"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText7"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"130"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"breaks between waves to upgrade"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText8"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"144"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"your abilities and weapons."
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText9"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"168"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"Survive all the waves in any of a"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
	}
	
	"MOTDText10"
	{
		"ControlName"		"Label"
		"fieldName"		"MOTDText"
		"xpos"		"c83"
		"ypos"		"182"
		"zpos"		"190"
		"wide"		"302"
		"tall"		"350"
		"proportionaltoparent"	"1"
		"labeltext"		"variety of missions to earn incredible loot!"
		"textAlignment"	"west"
		"font"			"HudFontSmall"
		"fgcolor_override"	"235 226 202 255"
		
		"mouseinputenabled"	"0"
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
}
