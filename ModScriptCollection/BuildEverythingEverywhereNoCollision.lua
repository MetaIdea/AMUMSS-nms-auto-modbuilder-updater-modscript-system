NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "BuildEverythingEverywhereNoCollision.pak", 
["MOD_AUTHOR"]				= "snarkhunter mod of Mjjstral",
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
								{ "EnableCollision", "False"},              --380 replacements
                { "BuildableOnPlanetBase", "True"},        --380 replacements
                { "BuildableOnSpaceBase", "True"},         --380 replacements
								{ "BuildableOnFreighter", "True"},         --380 replacements
								{ "BuildableOnPlanet", "True"},            --380 replacements
								{ "BuildableOnPlanetWithProduct", "True"}, --380 replacements
								{ "BuildableUnderwater", "True"},          --380 replacements
								{ "BuildableAboveWater", "True"}           --380 replacements
							}
						} --3048 global replacements
					}
				}	
			}
		}
	}	
}
--NOTE: ANYTHING NOT in table NMS_MOD_DEFINITION_CONTAINER IS IGNORED AFTER THE SCRIPT IS LOADED
--IT IS BETTER TO ADD THINGS AT THE TOP IF YOU NEED TO
--DON'T ADD ANYTHING PASS THIS POINT HERE