NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "WeatherDisabled.pak",
["MOD_AUTHOR"]				= "Mjjstal",
["NMS_VERSION"]				= "1.72",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= "METADATA\SIMULATION\SOLARSYSTEM\WEATHER\WEATHERLIST.MBIN",
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["REPLACE_AFTER_ENTRY"] = "Dust",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "Humid",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "Snow",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "Toxic",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "Scorched",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "Radioactive",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "RedWeather",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "GreenWeather",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						},
						{
							["REPLACE_AFTER_ENTRY"] = "BlueWeather",
							["VALUE_CHANGE_TABLE"] 	= 
							{
								{"Value",					"METADATA/SIMULATION/SOLARSYSTEM/WEATHER/CLEARWEATHER.MXML"}
							}
						}
					}
				}
			}
		}
	}	
}