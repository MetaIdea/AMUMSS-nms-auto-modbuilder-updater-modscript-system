NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= ".pak",
["MOD_DESCRIPTION"]			= "",
["MOD_AUTHOR"]				= "",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= { "\.MBIN" }
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "",				
							["MATH_OPERATION"] 		= "",  			
							["REPLACE_TYPE"] 		= "",			
							["VALUE_MATCH"] 		= "",    
							["VALUE_MATCH_TYPE"] 	= "",
							["LINE_OFFSET"] 		= "",				
							["VALUE_CHANGE_TABLE"] 	= 	
							{
								{"",	""} 		-- Original
							},	
							["ADD"] 				= [[NEW TEXT TO ADD HERE]]
						}
					}
				}
			}
		}
	},	
["ADD_FILES"] 			= 
	{
		{
			["FILE_DESTINATION"] 		= "\.EXML",
			["EXTERNAL_FILE_SOURCE"] 	= "",
			["FILE_CONTENT"] 	= 
[[
NEW TEXT TO ADD HERE	
]]
		}		
	}
}