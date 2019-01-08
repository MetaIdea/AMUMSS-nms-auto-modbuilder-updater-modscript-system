TerrainEditBeamMaxRange_Multiply = 3
TerrainEditCost_Multiply 		 = 0  --zero cost

NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "TerrainEditSize+RangeIncrease+ZeroCost.pak",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCTERRAINGLOBALS.GLOBAL.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = { "SubtractSizes", "0.8", "1.2" },
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"IGNORE",			"1.8"	} -- Original "1.2"
							}	
						},
						{
							["PRECEDING_KEY_WORDS"] = { "SubtractSizes", "0.8", "1.2", "1.6"},
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"IGNORE",			"4.0"		} -- Original "1.6"
							}	
						},
						{
							["PRECEDING_KEY_WORDS"] = { },
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"TerrainEditBeamMaxRange",			TerrainEditBeamMaxRange_Multiply	}, 		-- Original "40"
								{"TerrainEditsNormalCostFactor",	TerrainEditCost_Multiply			}, 		-- Original "0.4"
								{"TerrainEditsSurvivalCostFactor",	TerrainEditCost_Multiply			}, 		-- Original "2"
							}	
						}
					}
				}
			}
		}
	}	
}