NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "ShipGunTerrainDamage.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.86055253.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\PROJECTILES\PROJECTILETABLE.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "SHIPGUN",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"BehaviourFlags",		"DestroyTerrain"}		-- Original "None"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "SHIPSHOTGUN",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"BehaviourFlags",		"DestroyTerrain"}		-- Original "None"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "SHIPMINIGUN",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"BehaviourFlags",		"DestroyTerrain"}		-- Original "None"
							}
						},
						{
							["PRECEDING_KEY_WORDS"] = "SHIPPLASMAGUN",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"BehaviourFlags",		"DestroyTerrain"}		-- Original "None"
							}
						}							
					}
				}
			}
		}
	}	
}