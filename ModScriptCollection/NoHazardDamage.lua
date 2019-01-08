NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "NoHazardDamage.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 		
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\SIMULATION\ENVIRONMENT\HAZARDTABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	=
					{
						{
							["PRECEDING_KEY_WORDS"] = "DamageRate",				
							["MATH_OPERATION"] 		= "",  			
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 					
							{
								{"x",	"0"},
								{"y",	"0"}
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "WoundRate",				
							["MATH_OPERATION"] 		= "",  			
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["VALUE_CHANGE_TABLE"] 	= 					
							{
								{"x",	"0"},
								{"y",	"0"}
							}
						}
					}
				}		
			}
		}
	}	
}