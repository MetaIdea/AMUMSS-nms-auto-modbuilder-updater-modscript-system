STACK_MULTIPLIER = "5"

NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "StackMultiplierX5.pak",   -- for adaptive modname use: "StackMultiplierX" .. STACK_MULTIPLIER .. ".pak", 
["MOD_AUTHOR"]				= "Mjjstal",				 -- mod author, only mentioned for documentaion
["NMS_VERSION"]				= "1.77",					 -- NMS version on first mod release, only mentioned for documentaion
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\REALITY\TABLES\NMS_REALITY_GCSUBSTANCETABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "",				-- what key words must occur in lines prior your desired value you want to change
							["MATH_OPERATION"] 		= "*", 				-- "*", "+", "-", "/" or leave empty for normal replacement
							["REPLACE_TYPE"] 		= "ALL",			-- "ALL" to change every matching values or leave empty for single replacement
							["VALUE_MATCH"] 		= "", 				-- only change value(s) that match this value
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"StackMultiplier",	STACK_MULTIPLIER} 	-- Original 1
							}
						}
					}
				},			
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\REALITY\TABLES\NMS_REALITY_GCPRODUCTTABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	=
					{
						{
							["PRECEDING_KEY_WORDS"] = "",				
							["MATH_OPERATION"] 		= "*",  			
							["REPLACE_TYPE"] 		= "ALL",			
							["VALUE_MATCH"] 		= "",        		
							["VALUE_CHANGE_TABLE"] 	= 					
							{
								{"StackMultiplier",	STACK_MULTIPLIER} 	-- Original 1
							}
						}
					}
				}		
			}
		}
	}	
}