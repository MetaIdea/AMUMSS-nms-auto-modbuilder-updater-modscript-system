NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "AlwaysDay.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.72",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCSKYGLOBALS.GLOBALS.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["REPLACE_AFTER_ENTRY"] = "",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"MinNightFade",				"1.0"}, -- Original "0.62"
								{"MaxNightFade",				"1.0"}	-- Original ""0.68"
							}
						} --for multiple EXML changes with REPLACE_AFTER_ENTRY copy this chunk below and add a comma behind this line here
					}
				} --for multiple MBIN sources: copy this chunk below and add a comma behind this line here
			}
		} --for multiple pak sources: copy this chunk below and add a comma behind this line here
	}	
}


