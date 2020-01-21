NOTE: this script ONLY showcases how to skip the first pass, it does not do any modding

--===============================================================================
--at the top of the script:
--add thess lines to bypass the first pass evaluation of the script
DoFirstPass = (os.getenv("SkipScriptFirstCheck") ~= nil)
--this line is used to jump over all the lengthy code BEFORE the NMS_MOD_DEFINITION_CONTAINER
if not DoFirstPass then
--===============================================================================

  local function sleep(s)
    if s==nil then s=1 end
    local i=os.clock()+s 
    print("        waiting for " .. s .. " seconds ...") 
    while(os.clock()<i) do 
      --print("wait for " .. i-clock() .. " seconds") 
    end
    print("         finished waiting for " .. s .. " seconds") 
  end
	
	--example of long execution code here
	--this will wait for 30 seconds, simulating a long time to execute
  sleep(30)

	--example of user variables
  ANIM_TEMPLATE_ALL = ""  			  --used in the CONTAINER
	ACTION_TRIGGER_COMPONENT = ""		--used in the CONTAINER
	QUICK_ACTION_BUTTON_ALL = ""		--used in the CONTAINER
  SUPER_USER_VARIABLE = ""    --not used in container, no need to duplicate below
	--end of example of long execution code here
	
--===============================================================================
--Add these lines just before the NMS_MOD_DEFINITION_CONTAINER
else  --if not DoFirstPass then
  print("     Skipping first pass check!")
  
  --here create ALL "empty user variables" used in EXML_CHANGE_TABLE
  --in order for the script to be valid
  ANIM_TEMPLATE_ALL = ""    			--this user variable is used in the CONTAINER
  ACTION_TRIGGER_COMPONENT = ""		--this user variable is used in the CONTAINER
  QUICK_ACTION_BUTTON_ALL = ""		--this user variable is used in the CONTAINER
  --...                           --as many as there are in CONTAINER
end  --if not DoFirstPass then
--===============================================================================
	
	NMS_MOD_DEFINITION_CONTAINER = 
	{
	["MOD_FILENAME"] 			= "SkippingLongFirstPass.pak",
	["MOD_AUTHOR"]				= "Wbertro",
	["MOD_DESCRIPTION"]			= "",
	["NMS_VERSION"]				= "2.0+",
	["MODIFICATIONS"] 			= 
		{
			{
				["MBIN_CHANGE_TABLE"] = 
				{  
					{
						["MBIN_FILE_SOURCE"] 	= "MODELS\COMMON\PLAYER\PLAYERCHARACTER\PLAYERCHARACTER\ENTITIES\PLAYERCHARACTER.ENTITY.MBIN",
						["EXML_CHANGE_TABLE"] = 
						{
							{
								["PRECEDING_KEY_WORDS"] = {"Anims"}, 
								["LINE_OFFSET"] 		= "+0",
								["ADD"] 				= ANIM_TEMPLATE_ALL, --a user variable
							},
							{
								["PRECEDING_KEY_WORDS"] = {"LodDistances"}, 
								["LINE_OFFSET"] 		= "-2",
								["ADD"] 				= ACTION_TRIGGER_COMPONENT, --a user variable
							}
						}
					},
					{
						["MBIN_FILE_SOURCE"] 	= "METADATA\UI\EMOTEMENU.MBIN",
						["EXML_CHANGE_TABLE"] 	= 
						{
							{
								["PRECEDING_KEY_WORDS"] = {"Emotes"}, 
								["LINE_OFFSET"] 		= "+0",
								["ADD"] 				= QUICK_ACTION_BUTTON_ALL, --a user variable
							}
						}
					},
				}
			},
		}
	}
	--NOTE: ANYTHING NOT in table NMS_MOD_DEFINITION_CONTAINER IS IGNORED AFTER THE SCRIPT IS LOADED
	--IT IS BETTER TO ADD THINGS AT THE TOP IF YOU NEED TO
	--DON'T ADD ANYTHING PASS THIS POINT HERE
