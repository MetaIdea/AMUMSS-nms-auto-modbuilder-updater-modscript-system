NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "UnlimitedPhotoMode+NoClip+Speed3x.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.72",   --game version on first mod release
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.59B126E2",  --globals
			["MBIN_CHANGE_TABLE"] 	= --ENTRY_CHANGE, ADD or REMOVE
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "GCCAMERAGLOBALS.GLOBAL.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["REPLACE_AFTER_ENTRY"] = "",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"PhotoModeMoveSpeed",			"30"}, 			-- Original "10"
								{"PhotoModeMaxDistance",		"10000000"},	-- Original "100"
								{"PhotoModeMaxDistanceSpace",	"10000000"},	-- Original "200"
								{"PhotoModeCollisionRadius",	"0.0"} 			-- Original "0.5"
							}
						}
					}
				}
			}
		}
	}	
}