NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "Always-SClass-MaxStats.pak",
["MOD_DESCRIPTION"]			= "",
["MOD_AUTHOR"]				= "dvkkha converted by Mjjstral",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\REALITY\TABLES\INVENTORYTABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "",				
							["MATH_OPERATION"] 		= "*F:MaxSlots",  	--multiply MaxSlot value that comes after MinSlot value with "1", one means just replace -> MinSlots become MaxSlots		
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 	
							{
								{"MinSlots",		"1"}							
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "",				
							["MATH_OPERATION"] 		= "*F:MaxExtraTech",  			
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 	
							{
								{"MinExtraTech",	"1"} 							
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "ClassMultiplier",				
							["MATH_OPERATION"] 		= "",  			
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 	
							{
								{"C",	"0"}, 
								{"B",	"0"},
								{"A",	"0"}, 
								{"S",	"100"} 							
							}
						}						
					}
				}
			}
		}
	}	
}