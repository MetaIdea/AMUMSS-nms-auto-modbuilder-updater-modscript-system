NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "AmbientGameMode.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCDEBUGOPTIONS.GLOBAL.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"GodMode",						"True"}, 	-- Original "False"
								{"AlwaysHaveFocus",				"True"}, 	-- Original "False"
								{"MapWarpCheckIgnoreFuel",		"True"}, 	-- Original "False"
								{"MapWarpCheckIgnoreDrive",		"True"}, 	-- Original "False"
								{"EverythingIsFree",			"True"}, 	-- Original "False"
								{"EverythingIsKnown",			"True"}, 	-- Original "False"
								{"EverythingIsStar",			"True"}, 	-- Original "False"
								{"IgnoreMissionRank",			"True"} 	-- Original "False"
							}
						}
					}
				}
			}
		}
	}	
}

