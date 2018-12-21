NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "DenserForests.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\SIMULATION\SOLARSYSTEM\BIOMES\PLACEMENTVALUES\SPAWNDENSITYLIST.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "FOREST",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"PatchSize",				"320"}, 	-- Original "64"
								{"RegionScale",				"6"}		-- Original "6"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "GRASS",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"PatchSize",				"100"}, 	-- Original "100"
								{"RegionScale",				"5"}		-- Original "5"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "BIOMEPLANT",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"PatchSize",				"550"}, 	-- Original "550"
								{"RegionScale",				"0.1"}		-- Original "0.1"
							}
						}
					}
				}
			}
		}
	}	
}