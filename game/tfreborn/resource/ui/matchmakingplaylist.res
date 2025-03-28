"Resource/UI/MatchMakingDashboardCasualCriteria.res"
{
	"EventEntry"
	{
		"ControlName"	"CEventPlayListEntry"
		"fieldName"		"EventEntry"
		"xpos"			"0"
		"ypos"			"3"
		"tall"			"45"
		"wide"			"255"
		"proportionaltoparent"	"1"

		"button_command"	"play_event"
	}
	
	"ServerBrowserEntry"
	{
		"ControlName"	"CPlayListEntry"
		"fieldName"		"ServerBrowserEntry"
		"xpos"			"0"
		"ypos"			"0"
		"tall"			"0"
		"wide"			"0"
		"proportionaltoparent"	"1"
	
		//"image_name"		"main_menu/main_menu_button_community_server"
		//"button_token"		"#MMenu_PlayList_ServerBrowser_Button"
		//"button_command"	"play_community"
		//"desc_token"		"#MMenu_PlayList_ServerBrowser_Desc"
	
		if_event
		{
			"ypos"			"203"
		}
	}
	
	"TrainingEntry"
	{
		"ControlName"	"CPlayListEntry"
		"fieldName"		"TrainingEntry"
		"xpos"			"0"
		"ypos"			"0"
		"tall"			"0"
		"wide"			"0"
		"proportionaltoparent"	"1"
	
		//"image_name"		"main_menu/main_menu_button_training"
		//"button_token"		"#MMenu_PlayList_Training_Button"
		//"button_command"	"play_training"
		//"desc_token"		"#MMenu_PlayList_Training_Desc"
	
		if_event
		{
			"ypos"			"253"
		}
	}
	
	"CreateServerEntry"
	{
		"ControlName"	"CPlayListEntry"
		"fieldName"		"CreateServerEntry"
		"xpos"			"0"
		"ypos"			"0"
		"tall"			"0"
		"wide"			"0"
		"proportionaltoparent"	"1"
	
		//"image_name"		"main_menu/main_menu_button_custom_server"
		//"button_token"		"#MMenu_PlayList_CreateServer_Button"
		//"button_command"	"create_server"
		//"desc_token"		"#MMenu_PlayList_CreateServer_Desc"
	
		if_event
		{
			"ypos"			"303"
		}
	}
	
	"ScrollBar"
	{
		"ControlName"	"ScrollBar"
		"FieldName"		"ScrollBar"
		"xpos"			"rs1-1"
		"ypos"			"0"
		"tall"			"f0"
		"wide"			"5" // This gets slammed from client schme.  GG.
		"zpos"			"1000"
		"nobuttons"		"1"
		"proportionaltoparent"	"1"

		"Slider"
		{
			"fgcolor_override"	"TanDark"
		}
		
		"UpButton"
		{
			"ControlName"	"Button"
			"FieldName"		"UpButton"
			"visible"		"0"
		}
		
		"DownButton"
		{
			"ControlName"	"Button"
			"FieldName"		"DownButton"
			"visible"		"0"
		}
	}
}
