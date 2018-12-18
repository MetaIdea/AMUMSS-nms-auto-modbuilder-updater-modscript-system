NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "Reverse+Hover+Underwater+10xPulseSpeed.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.72",   --game version on first mod release
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCSPACESHIPGLOBALS.GLOBAL.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{						
						{
						["REPLACE_AFTER_ENTRY"] = "",
						["VALUE_CHANGE_TABLE"] 	= 
							{
								{"HoverTakeoffHeight",		"45"}, 		-- Original "90"
								{"HoverMinSpeed",			"-1"},		-- Original "1"
								{"GroundHeightSmoothTime",	"10000000"},-- Original "0"  --underwater					
								{"MiniWarpSpeed",			"20000"},	-- Original "200000"
								{"MiniWarpChargeTime",		"0"}		-- Original "2"
							}
						},
						{
						["REPLACE_AFTER_ENTRY"] = "Control",
						["VALUE_CHANGE_TABLE"] 	= 
							{
								{"MinSpeed",				"-5"} 		-- Original "0"
							}
						},
						{
						["REPLACE_AFTER_ENTRY"] = "ControlLight",
						["VALUE_CHANGE_TABLE"] 	= 
							{
								{"MinSpeed",				"-5"} 		-- Original "0"
							}
						},
						{
						["REPLACE_AFTER_ENTRY"] = "ControlHeavy",
						["VALUE_CHANGE_TABLE"] 	= 
							{
								{"MinSpeed",				"-5"} 		-- Original "0"
							}
						}						
					}
				}
			}
		}
	}	
}