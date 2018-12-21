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
							["PRECEDING_KEY_WORDS"] = "NewSaveGameMode",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"PresetGameMode",  "6152"}
							}
						}
					}
				}
			}
		}
	}	
}