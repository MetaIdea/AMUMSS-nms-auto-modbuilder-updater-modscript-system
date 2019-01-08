WORDS_TO_LEARN = 5

TEXT_TO_ADD =
[[
          <Property value="GcRewardTableItem.xml">
            <Property name="PercentageChance" value="100" />
            <Property name="Reward" value="GcRewardTeachWord.xml">
              <Property name="Race" value="GcAlienRace.xml">
                <Property name="AlienRace" value="None" />
              </Property>
              <Property name="AmountMin" value="1" />
              <Property name="AmountMax" value="1" />
            </Property>
            <Property name="LabelID" value="" />
          </Property>
]]

TEXT_TO_ADD = strrep(TEXT_TO_ADD, WORDS_TO_LEARN-1)

NMS_MOD_DEFINITION_CONTAINER = 
{
["MOD_FILENAME"] 			= "LearnMoreWords.pak",
["MOD_AUTHOR"]				= "ChoseSauvage converted by Mjjstral",
["NMS_VERSION"]				= "1.77",
["MODIFICATIONS"] 			= 
	{
		{
			["PAK_FILE_SOURCE"] 	= "NMSARC.515F1D3.pak",
			["MBIN_CHANGE_TABLE"] 	= 
			{ 
				{
					["MBIN_FILE_SOURCE"] 	= 
					{
						"METADATA\REALITY\TABLES\REWARDTABLE.MBIN"			
					},
					["EXML_CHANGE_TABLE"] 	= 
					{
						{
							["PRECEDING_KEY_WORDS"] = "WORD",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD
						},
						{
							["PRECEDING_KEY_WORDS"] = "TRA_WORD",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD					
						},
						{
							["PRECEDING_KEY_WORDS"] = "EXP_WORD",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD				
						},
						{
							["PRECEDING_KEY_WORDS"] = "WAR_WORD", 
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD			
						},
						{
							["PRECEDING_KEY_WORDS"] = "TEACHWORD_EXP", 
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD
						},
						{
							["PRECEDING_KEY_WORDS"] = "TEACHWORD_TRA",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD
						},
						{
							["PRECEDING_KEY_WORDS"] = "TEACHWORD_WAR",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD
						},
						{
							["PRECEDING_KEY_WORDS"] = "TEACHWORD_ATLAS",
							["LINE_OFFSET"] 		= "+15",
							["VALUE_CHANGE_TABLE"] 	= {{"IGNORE",	"IGNORE"}},
							["ADD"] 				= TEXT_TO_ADD
						}						
					}
				}
			}
		}
	}	
}