#base "HudObjectivePlayerDestruction.res"
"Resource/UI/DominationHUD.res"
{
	"ObjectiveStatusRobotDestruction"
	{
		"ControlName"		"EditablePanel"
		"fieldName"			"ObjectiveStatusRobotDestruction"
		"xpos"				"0"
		"ypos"				"0"
		"zpos"				"1"
		"wide"				"f0"
		"tall"				"480"
		"visible"			"1"
		"enabled"			"1"

		"left_steal_edge_offset"	"97"
		"right_steal_edge_offset"	"97"
		"robot_x_offset"		"78"
		"robot_y_offset"		"47"
		"robot_x_step"			"23"
		"robot_y_step"			"0"
		

		"color_blue"			"84 111 127 255"
		"color_red"				"171 59 59 255"

		"if_hybrid"
		{
			"zpos"			"-1"
		}

		"robot_kv"
		{
			"ControlName"	"CTFHudRobotDestruction_RobotIndicator"
			"xpos"			"0"
			"ypos"			"0"
			"wide"			"20"
			"tall"			"20"
			"visible"		"1"
			"bgcolor_override"		"0 0 0 0"
			"PaintBackgroundType"	"0"
			"paintborder"	"0"
			"AutoResize" "0"
			"skip_autoresize" "1"
		}
	}

	//Playing to
	"PlayingTo"
	{
		"ControlName"	"CExLabel"
		"fieldName"		"PlayingTo"
		"xpos"			"c-70"	[$WIN32]
		"xpos"			"c-60"	[$X360]
		"ypos"			"r28"	[$WIN32]
		"ypos"			"r48"	[$X360]
		"zpos"			"4"
		"wide"			"140"	[$WIN32]
		"wide"			"120"	[$X360]
		"tall"			"30"
		"visible"		"1"
		"enabled"		"1"
		"labelText"		"#TF_PlayingTo"
		"textAlignment"	"center"
		"dulltext"		"0"
		"brighttext"	"0"
		"font"			"HudFontSmall"
		"fgcolor"		"TanLight"
		
		"if_hybrid"
		{
			"visible"	"0"
		}
		
		"if_mvm"
		{
			"visible"	"0"
		}
		
		"if_specialdelivery"
		{
			"visible"	"0"
		}
	}		
	"PlayingToBG"
	{
		"ControlName"	"CTFImagePanel"
		"fieldName"		"PlayingToBG"
		"xpos"			"c-75"	[$WIN32]
		"xpos"			"c-70"	[$X360]
		"ypos"			"r31"	[$WIN32]
		"ypos"			"r51"	[$X360]
		"zpos"			"3"
		"wide"			"150"	[$WIN32]
		"wide"			"140"	[$X360]
		"tall"			"38"	[$WIN32]
		"tall"			"35"	[$X360]
		"visible"		"1"
		"enabled"		"1"
		"image"			"../hud/objectives_flagpanel_bg_playingto"
		"image_hidef"	"../hud/objectives_flagpanel_bg_playingto_hidef"
		"scaleImage"	"1"	
		
		"if_hybrid"
		{
			"visible"	"0"
		}
		
		"if_mvm"
		{
			"visible"	"0"
		}
		
		"if_specialdelivery"
		{
			"visible"	"0"
		}
	}

	"ScoreContainer"
	{
		"fieldName"				"ScoreContainer"
		"ControlName"			"EditablePanel"
		"xpos"					"c-200"
		"ypos"					"r128"
		"zpos"					"0"
		"wide"					"400"
		"tall"					"120"
		"scaleimage"			"0"
		"visible"				"1"
		"enabled"				"1"
		"BlueStolenContainer"
		{
			"visible"			"0"
		}
		"RedStolenContainer"
		{
			"visible"			"0"
		}
		"BlueScoreValueContainer"
		{
			"xpos"				"80"
			"ypos"				"r47"
		}
		"RedScoreValueContainer"
		{
			"xpos"				"r140"
			"ypos"				"r47"
		}

		"ProgressBarContainer"
		{
			"FlagImageBlue"
			{
				"visible"		"0"
			}
			"FlagImageRed"
			{
				"visible"		"0"
			}
			"EscrowBlue"
			{
				"visible"		"0"
			}
			"EscrowBlueShadow"
			{
				"visible"		"0"
			}
			"EscrowRed"
			{
				"visible"		"0"
			}
			"EscrowRedShadow"
			{
				"visible"		"0"
			}

			"ScoreOutline"
			{
				"fieldName"				"ScoreOutline"
				"ControlName"			"ImagePanel"
				"xpos"					"0"
				"ypos"					"0"
				"zpos"					"10"
				"wide"					"f0"
				"tall"					"f0"
				"scaleimage"			"1"
				"visible"				"1"
				"enabled"				"1"
				"Image"					"../hud/dom_corepanel_bg"
				"proportionalToParent"	"1"
			}
			"BlueProgressBarFill"
			{
				"fieldName"				"BlueProgressBarFill"
				"ControlName"			"ImagePanel"
				"xpos"					"0"
				"ypos"					"0"
				"zpos"					"2"
				"wide"					"150"
				"tall"					"f0"
				"scaleimage"			"0"
				"visible"				"1"
				"proportionalToParent"	"1"
				"positionImage"			"0"
				"drawcolor"				"88 121 156 255"
				"Image"					"../hud/dom_corepanel_meter_fill"

				"left_offset"			"10"
				"right_offset"			"0"
				"drawcolor"				"88 121 156 255"
				"left_to_right"			"0"
				"blink_threshold"		"1.0"
				"blink_rate"			"10"
			}
			"RedProgressBarFill"
			{
				"fieldName"				"RedProgressBarFill"
				"ControlName"			"ImagePanel"
				"xpos"					"150"
				"ypos"					"0"
				"zpos"					"2"
				"wide"					"150"
				"tall"					"f0"
				"scaleimage"			"0"
				"positionImage"			"0"
				"visible"				"1"
				"proportionalToParent"	"1"
				"drawcolor"				"195 59 59 255"
				"Image"					"../hud/dom_corepanel_meter_fill"

				"left_offset"			"0"
				"right_offset"			"9"
				"standard_color"		"195 59 59 255"
				"left_to_right"			"1"
				"blink_threshold"		"1.0"
				"blink_rate"			"10"
			}
			"BlueProgressBarEscrow"
			{
				"visible"				"0"
			}
			"RedProgressBarEscrow"
			{
				"visible"				"0"
			}
		}
	}
}