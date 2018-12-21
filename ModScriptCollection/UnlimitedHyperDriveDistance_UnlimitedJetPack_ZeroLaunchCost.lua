NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "UnlimitedHyperDriveDistance_UnlimitedJetPack_ZeroLaunchCost.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\REALITY\TABLES\NMS_REALITY_GCTECHNOLOGYTABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "Ship_Hyperdrive_JumpDistance",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Bonus",	"10000000"} 	-- Original "100"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "Suit_Jetpack_Tank",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Bonus",	"10000000"}		-- Original "2.75"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "Ship_Launcher_TakeOffCost",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Bonus",		"0"}		-- Original "50"
							}
						}
					}
				}
			}
		}
	}	
}