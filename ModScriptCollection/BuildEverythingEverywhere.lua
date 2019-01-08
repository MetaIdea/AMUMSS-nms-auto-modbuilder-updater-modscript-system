NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "BuildEverythingEverywhere.pak", 
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\REALITY\TABLES\BASEBUILDINGTABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "",
							["MATH_OPERATION"] 		= "",
							["REPLACE_TYPE"] 		= "ALL",
							["VALUE_MATCH"] 		= "",
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{ "BuildableOnBase", "True"},
								{ "BuildableOnFreighter", "True"},
								{ "BuildableOnPlanet", "True"},
								{ "BuildableUnderwater", "True"},
								{ "BuildableAboveWater", "True"}
							}
						}
					}
				}	
			}
		}
	}	
}