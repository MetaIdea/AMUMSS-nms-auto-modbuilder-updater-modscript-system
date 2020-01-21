-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function HandleModScript(MOD_DEF)
  pv(THIS.."From HandleModScript()")
  local file = ""
  local FullPathFile = ""
  local NoEXML_CHANGE_TABLE = false
  
  --***************************************************************************************************  
  local function ExecuteREGEX(From,Command)
    -- print("")
    local spacer = "      "
    if os.getenv("_bOS_bitness") == "64" then
      print(spacer..From..": Using 64bit version")
      Report("","  "..From.."  : Using 64bit version")
      os.execute([[sed-4.7-x64.exe ]]..Command)
    else
      print(spacer..From..": Using 32bit version")
      Report("","  "..From.."  : Using 32bit version")
      os.execute([[sed-4.7.exe ]]..Command)
    end
    print(spacer..From..": "..Command)
    Report("","  "..From.."  : "..Command)
  end
  --***************************************************************************************************  

  local say = LoadFileData("CurrentModScript.txt")
  -- because string.gsub pattern does not work with all folder names (ex.: ".")
  if string.find(say,MASTER_FOLDER_PATH..[[ModScript\]],1,true) ~= nil then
    local start = string.find(say,MASTER_FOLDER_PATH..[[ModScript\]],1,true)
    say = string.sub(say,1,start - 1)..string.sub(say,string.len(MASTER_FOLDER_PATH..[[ModScript\]]) + start)
  end
  Report(say,">>>>>>> Loaded script")
  if MOD_DEF["MODIFICATIONS"]~=nil then
    for n=1,#MOD_DEF["MODIFICATIONS"] do
      for m=1,#MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"] do
      
        local NEW_FILEPATH_AND_NAME = {}
        local mbin_file_source = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"]
        
        if type(mbin_file_source) ~= "table" then
          pv("Not a table.  Make it a table, we want a table!")
          mbin_file_source = {}
          mbin_file_source[1] = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"]
          NEW_FILEPATH_AND_NAME[1] = ""
        else
          local tempTable = {}
          for i=1,#mbin_file_source do
            if type(mbin_file_source[i]) == "table" then
              --handle MBIN_FILE_SOURCE as a table of tables
              pv("convert mbin_file_source to a simple table")
              tempTable[#tempTable+1] = mbin_file_source[i][1]
              
              --and save info for NEW_FILEPATH_AND_NAME
              NEW_FILEPATH_AND_NAME[#NEW_FILEPATH_AND_NAME+1] = mbin_file_source[i][2]
            else
              pv("handle MBIN_FILE_SOURCE as a table only")
              tempTable[#tempTable+1] = mbin_file_source[i]
              NEW_FILEPATH_AND_NAME[#NEW_FILEPATH_AND_NAME+1] = ""
            end  
          end
          mbin_file_source = tempTable
        end
        
        for u=1,#mbin_file_source do		
          file = string.gsub(string.gsub(mbin_file_source[u],".MBIN",".EXML"),[[/]],[[\]])
          file = string.gsub(file,[[\\]],[[\]])
          FullPathFile = MASTER_FOLDER_PATH..LocalFolder..file
          print("--------------------------------------------------------------------------------------")
          print("\n>>> " .. file)
          Report("",">>> " .. file)
          
          if #NEW_FILEPATH_AND_NAME > 0 and NEW_FILEPATH_AND_NAME[u] ~= nil and NEW_FILEPATH_AND_NAME[u] ~= "" then
            --user asked to create a new file
            --try to change all / to \
            NEW_FILEPATH_AND_NAME[u] = string.gsub(NEW_FILEPATH_AND_NAME[u],[[/]],[[\]])
            NEW_FILEPATH_AND_NAME[u] = string.gsub(NEW_FILEPATH_AND_NAME[u],[[\\]],[[\]])
            -- print()
            print("    Copying/renaming this file to ["..NEW_FILEPATH_AND_NAME[u].."]")
            --try to change MBIN to EXML
            NEW_FILEPATH_AND_NAME[u] = string.gsub(NEW_FILEPATH_AND_NAME[u],[[.MBIN.PC]],[[.MBIN]])
            NEW_FILEPATH_AND_NAME[u] = string.gsub(NEW_FILEPATH_AND_NAME[u],[[.MBIN]],[[.EXML]])
            --xcopy original file to its new folder in MOD with new name
            local FilePathSource = [[MOD\]]..file
            local FilePathDestination = [[MOD\]]..NEW_FILEPATH_AND_NAME[u]..[[*]]
            -- print("["..FilePathSource.."]")
            -- print("["..FilePathDestination.."]")
            os.execute([[START /wait "" /B /MIN cmd /c xcopy /y /h /v /i "]]..FilePathSource..[[" "]]..FilePathDestination..[[" 1>NUL 2>NUL]])	
            
            -- --delete original file from its folder
            -- os.remove(FilePathSource)
            -- --remove original empty folder(s), if any
            -- local FolderPath = [[MOD\]]..GetFolderPathFromFilePath(file)
            -- -- print("["..FolderPath.."]")
            -- repeat
              -- --to remove all empty folders in the path
              -- os.execute([[START /wait "" /B /MIN cmd /c rd /q "]]..FolderPath..[[" 1>NUL 2>NUL]])	
              -- -- os.execute([[START /wait "" /B /MIN cmd /c rd /q "]]..FolderPath..[["]])
              -- FolderPath = GetFolderPathFromFilePath(FolderPath)
              -- -- print("["..FolderPath.."]")
            -- until FolderPath == ""
          end
          
          --=================== REGEXBEFORE ========================
          do
          if MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["REGEXBEFORE"] ~= nil then
            local regexbefore = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["REGEXBEFORE"]
            if type(regexbefore) ~= "table" then
              print("")
              print("ERROR: REGEXBEFORE is not a table, please correct your script")
              Report("","REGEXBEFORE is not a table, please correct your script","ERROR")
            end
            for i=1,#regexbefore do
              local ToFindRegex = regexbefore[i][1]
              local ToReplaceRegex = string.gsub(regexbefore[i][2],[[\\]],[[\]])
              if ToFindRegex == nil or ToReplaceRegex == nil then
                print("")
                print("ERROR: missing REGEXBEFORE member, please correct your script")
                Report("","missing REGEXBEFORE member, please correct your script","ERROR")
              else
                if ToFindRegex ~= "" then
                  local From = "REGEXBEFORE"
                  local Command = [[-i -r "s/]]..ToFindRegex..[[/]]..ToReplaceRegex..[[/" "]]..FullPathFile..[["]]
                  --for debug purposes
                  -- Command = string.sub(Command,4)..[[ > "]]..From..[[_output.txt"]]
                  ExecuteREGEX(From,Command)
                end
              end
            end
          end
          end
          --=================== end REGEXBEFORE ========================
          
          local TextFileTable, TextFileTableLineCount = ParseTextFileIntoTable(FullPathFile) --the EXML file in MOD
          
          if TextFileTableLineCount == 0 then
            --this file does not exist, skip it
            print("ERROR: file does not exist!")
            Report("","file does not exist! See above for source...","ERROR")
          else
            
            --create MapFileTrees of the original EXML only...
            if os.getenv("_bRecreateMapFileTrees") ~= nil then
              DisplayMapFileTreeEXT(ParseTextFileIntoTable([[.\_TEMP\DECOMPILED\]]..file),file)
            else
              print("    Skipping MapFileTree creation/update")
              Report("","    Skipping MapFileTree creation/update")
            end
            
            -- print(  "      file is "..TextFileTableLineCount.." lines long")
            -- Report(file..", "..TextFileTableLineCount.." lines long","  Starting processing of")
            local ReplaceNumber = 0
            local ADDNumber = 0
            local REMOVENumber = 0
            
            if MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"] ~= nil then
              for i=1,#MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"] do
                  local ReplNumber,ADDcount,REMOVEcount = ExchangePropertyValue(
                      FullPathFile,
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["SPECIAL_KEY_WORDS"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["WHERE_KEY_WORDS"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["MATH_OPERATION"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["INTEGER_TO_FLOAT"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_TYPE"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_TYPE"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_OPTIONS"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["LINE_OFFSET"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["ADD"],
                      MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REMOVE"]
                    )					
                  ReplaceNumber = ReplaceNumber + ReplNumber
                  ADDNumber = ADDNumber + ADDcount
                  REMOVENumber = REMOVENumber + REMOVEcount
              end
              print("")
              if ADDNumber > 0 then
                Report(ADDNumber.." ADD(s) made","  Ended processing with")
                print("    >>>>> "..ADDNumber.." ADD(s) made <<<<<")
              end
              if REMOVENumber > 0 then
                Report(REMOVENumber.." REMOVE(s) made","  Ended processing with")
                print("    >>>>> "..REMOVENumber.." REMOVE(s) made <<<<<")
              end
              -- if ReplaceNumber > 0 then
                Report(file.." with a total of "..(ReplaceNumber + ADDNumber + REMOVENumber).." action(s) made","  Ended processing of")
                print("    >>>>> Ended with a total of "..(ReplaceNumber + ADDNumber + REMOVENumber).." action(s) made <<<<<")
              -- end
              NumReplacements = NumReplacements + ReplaceNumber + ADDNumber + REMOVENumber
              if THIS == "In TestReCreatedScript: " then CheckReCreatedEXMLAgainstOrg(file) end
            else
              NoEXML_CHANGE_TABLE = true
              -- print("[INFO] [\"MODIFICATIONS\"] has no [\"EXML_CHANGE_TABLE\"]")
              -- Report("","[\"MODIFICATIONS\"] has no [\"EXML_CHANGE_TABLE\"]")
            end
            -- print("   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
          end

          --=================== REGEXAFTER ========================
          do
          if MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["REGEXAFTER"] ~= nil then
            local regexafter = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["REGEXAFTER"]
            if type(regexafter) ~= "table" then
              print("")
              print("ERROR: REGEXAFTER is not a table, please correct your script")
              Report("","REGEXAFTER is not a table, please correct your script","ERROR")
            end
            for i=1,#regexafter do
              local ToFindRegex = regexafter[i][1]
              local ToReplaceRegex = string.gsub(regexafter[i][2],[[\\]],[[\]])
              if ToFindRegex == nil or ToReplaceRegex == nil then
                print("")
                print("ERROR: missing REGEXBEFORE member, please correct your script")
                Report("","missing REGEXBEFORE member, please correct your script","ERROR")
              else
                if ToFindRegex ~= "" then
                  print("")
                  local From = "REGEXAFTER"
                  local Command = [[-i -r "s/]]..ToFindRegex..[[/]]..ToReplaceRegex..[[/" "]]..FullPathFile..[["]]
                  --for debug purposes
                  -- Command = string.sub(Command,4)..[[ > "]]..From..[[_output.txt"]]
                  ExecuteREGEX(From,Command)
                end
              end
            end
          end
          end
          --=================== end REGEXAFTER ========================
        end
      end
    end
  end

	--Add new files
	if MOD_DEF["ADD_FILES"]~=nil then
    print("")
    print(">>> Adding files:")
    Report("")
    Report("",">>> Adding files:")
		for i=1,#MOD_DEF["ADD_FILES"] do
      local ShortFilenamePath = string.gsub(MOD_DEF["ADD_FILES"][i]["FILE_DESTINATION"],[[/]],[[\]])
			local FolderPath = MASTER_FOLDER_PATH .. LocalFolder .. GetFolderPathFromFilePath(ShortFilenamePath)..[[\]]
			local FilePath = MASTER_FOLDER_PATH .. LocalFolder .. ShortFilenamePath
			local _,count = string.gsub(ShortFilenamePath,[[\]],"")	
			if count > 0 then
        if not FolderExists(string.gsub(FolderPath,[[\]],[[\\]])) then
          print("      create folder: " .. FolderPath)
          Report("","      create folder: " .. FolderPath)
          FolderPath = string.gsub(FolderPath,[[\]],[[\\]])
          os.execute([[START /wait "" /B /MIN cmd /c mkdir ]]..[["]]..FolderPath..[["]])	
          -- sleep(0.2)
        end
			end 
			print("        create file: "..FilePath)
			Report("","        create file: "..[["]]..FilePath..[["]])
			if MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]==nil or MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]=="" then
        FilePath = string.gsub(FilePath,[[\]],[[\\]])
				local FileData = MOD_DEF["ADD_FILES"][i]["FILE_CONTENT"]
				WriteToFile(string.gsub(FileData,"\n","",1), FilePath)
			else
				local FilePathSource = GetFolderPathFromFilePath(LoadFileData("CurrentModScript.txt")) .. [[\]] .. MOD_DEF["ADD_FILES"][i]["EXTERNAL_FILE_SOURCE"]
				--local FileData = LoadFileData(FilePathSource)
				--WriteToFile(FileData, FilePath)
				os.execute([[START /wait "" /B /MIN cmd /c xcopy /y /h /v /i "]]..FilePathSource..[[" "]]..FolderPath..[["]])	
			end
			NumFilesAdded=NumFilesAdded+1
		end
    print("\n    >>>>> Ended with "..NumFilesAdded .. " files added <<<<<\n")
    Report("","\n    >>>>> Ended with "..NumFilesAdded .. " files added <<<<<\n")
	end
  
  if not NoEXML_CHANGE_TABLE and MOD_DEF["MODIFICATIONS"]~=nil and NumReplacements == 0 then
    Report(say," No replacement done. Please verify your script","WARNING")
    --Report("")
  end
  if MOD_DEF["ADD_FILES"]~=nil and NumFilesAdded == 0 then
    Report(say," No file added. Please verify your script","WARNING")
    --Report("")
  end
  if not NoEXML_CHANGE_TABLE then
    Report(NumReplacements.." action(s), "..NumFilesAdded .. " files added","Ended script processing with")
    -- Report("")
    
    print("\n*************************************************************************")
    print("    >>>>> Ended all with "..NumReplacements.." action(s) made and "..NumFilesAdded .. " files added <<<<<")
    print("*************************************************************************\n")
  end
  pv(THIS.."From end of HandleModScript()")
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function CheckReCreatedEXMLAgainstOrg(file)
  -- now we can compare the ORIG_MOD with this ReCreated_MOD
  --if the SAME then SUCCESS
  --else report FAILURE
  pv(THIS.."From CheckReCreatedEXMLAgainstOrg()")
  print("")
  -- Report("")
  -- *file (ORG EXML)        MASTER_FOLDER_PATH..[[\SCRIPTBUILDER\MOD\]]..string.gsub(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"],".MBIN",".EXML"),
  local temp = MASTER_FOLDER_PATH..LocalFolder..file
  -- temp = string.gsub(temp,[[\]],[[\\]]) --no need to do this replacement
  
  local say = temp
  -- because string.gsub pattern does not work with all folder names (ex.: ".")
  if string.find(say,MASTER_FOLDER_PATH,1,true) ~= nil then
    local start = string.find(say,MASTER_FOLDER_PATH,1,true)
    say = string.sub(say,1,start - 1)..string.sub(say,string.len(MASTER_FOLDER_PATH) + start)
  end
  print("           "..say)
  -- Report("","           "..say,"")
  
  local ORIG_MOD = LoadFileData(temp)
  print("  Original MOD is "..string.len(ORIG_MOD).." long")
  Report("","  Original MOD is "..string.len(ORIG_MOD).." long")
  
  temp = string.gsub(temp,LocalFolder,[[\Modified_PAK\DECOMPILED\]])

  local say = temp
  -- because string.gsub pattern does not work with all folder names (ex.: ".")
  if string.find(say,MASTER_FOLDER_PATH,1,true) ~= nil then
    local start = string.find(say,MASTER_FOLDER_PATH,1,true)
    say = string.sub(say,1,start - 1)..string.sub(say,string.len(MASTER_FOLDER_PATH) + start)
  end
  print("     "..say)
  -- Report("","     "..say,"")
  
  local ReCreated_MOD = LoadFileData(temp)
  print("Re-Created MOD is "..string.len(ReCreated_MOD).." long")
  Report("","Re-Created MOD is "..string.len(ReCreated_MOD).." long")
  
  ResultsCreatingScript[#ResultsCreatingScript + 1] = {}
  ResultsCreatingScript[#ResultsCreatingScript][1] = file

  if ReCreated_MOD == ORIG_MOD then
    ResultsCreatingScript[#ResultsCreatingScript][2] = "Success"
    print("\n      ********************************************************************************")
    print("\n      >>>>>>>>>>>>  Script MOD creation SUCCEEDED, BOTH FILES IDENTICAL!  <<<<<<<<<<<<")
    print("\n      ********************************************************************************")
    Report("",">>>>>>>>>>>>  Script MOD creation SUCCEEDED, BOTH FILES IDENTICAL!  <<<<<<<<<<<<","SUCCESS")
  else
    ResultsCreatingScript[#ResultsCreatingScript][2] = "Failure"
    print("\n      --------------------------------------------------------")
    print("\n      XXXXXXXXXXXX  Script MOD creation FAILURE!  XXXXXXXXXXXX")
    print("\n      --------------------------------------------------------")
    Report("","XXXXXXXXXXXX  Script MOD creation FAILURE!  XXXXXXXXXXXX","ERROR")
  end
  print()
  Report("")
  pv(THIS.."From end of CheckReCreatedEXMLAgainstOrg()")
end

--[=[
ExchangePropertyValue(
*file (ORG EXML)        MASTER_FOLDER_PATH..LocalFolder..string.gsub(MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"],".MBIN",".EXML")
*value_change_table     ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_CHANGE_TABLE"]
*special_key_words      ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["SPECIAL_KEY_WORDS"]
*preceding_key_words    ,PRECEDING_KEY_WORDS_SUB [==]PRECEDING_KEY_WORDS_SUB = MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["PRECEDING_KEY_WORDS"][==]
where_key_words         ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["WHERE_KEY_WORDS"]
math_operation          ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["MATH_OPERATION"]
integer_to_float        ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["INTEGER_TO_FLOAT"]
value_match             ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH"]
replace_type            ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REPLACE_TYPE"]
value_match_type        ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_TYPE"]
value_match_options     ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["VALUE_MATCH_OPTIONS"]
line_offset             ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["LINE_OFFSET"]
text_to_add             ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["ADD"]
to_remove               ,MOD_DEF["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["EXML_CHANGE_TABLE"][i]["REMOVE"]
)
* = needed for SCRIPTBUILDER script.lua					
--]=]

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--called each time with all property/value combo in value_change_table
function ExchangePropertyValue(file,value_change_table,special_key_words,preceding_key_words,where_key_words
          ,math_operation,integer_to_float,value_match,replace_type,value_match_type,value_match_options,line_offset,text_to_add,to_remove)

  print("")
  print("   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -")
          
          -- *****************   value_change_table section   ********************
  local val_change_table = {{"",""}}
  local IsChangeTable = false
  
  if value_change_table == nil then
    val_change_table[1][1] = "IGNORE"
    val_change_table[1][2] = "IGNORE"
  else 
    if type(value_change_table) ~= "table" then
      --not a table, just one word
      if value_change_table == "" then
        val_change_table[1][1] = "IGNORE"
        val_change_table[1][2] = "IGNORE"
      else
        --Make it a table, we want a table!
        val_change_table[1][1] = value_change_table
        val_change_table[1][2] = value_change_table
      end
    else
      --already a table, use it
      val_change_table = value_change_table
    end
  end
  
  if (#val_change_table > 0) and (val_change_table[1] ~= "" or val_change_table[2] ~= "") then
    IsChangeTable = true
  end

  for i=1,#val_change_table do
    if val_change_table[i][1] == nil then
      --we have a problem, should not be nil
      print([[>>> ERROR: A VALUE_CHANGE_TABLE "Property name/value" is nil, please correct your script!]])
      Report("",[[>>> A VALUE_CHANGE_TABLE "Property name/value" is nil, please correct your script!]],"ERROR")
      val_change_table[i][1] = "" --to prevent a crash
    end
    if val_change_table[i][2] == nil then
      --we have a problem, should not be nil
      print([[>>> ERROR: A VALUE_CHANGE_TABLE "newvalue" is nil, please correct your script!]])
      Report("",[[>>> A VALUE_CHANGE_TABLE "newvalue" is nil, please correct your script!]],"ERROR")
      val_change_table[i][2] = "" --to prevent a crash
    end
    val_change_table[i][1] = string.gsub(val_change_table[i][1],[[\\]],[[\]])
    val_change_table[i][2] = string.gsub(val_change_table[i][2],[[\\]],[[\]])
  end
  
  --  *******************************************************
  -- FROM HERE ON [value_change_table] is know as [val_change_table] (a table)
  --  *******************************************************
  
  -- *****************   integer_to_float section   ********************
  if integer_to_float == nil or integer_to_float == "" then
    integer_to_float = "PRESERVE" 
  end
  integer_to_float = string.upper(integer_to_float)
  
  local Isinteger_to_float = (integer_to_float ~= "")
  local Isinteger_to_floatPRESERVE = (integer_to_float == "PRESERVE")
  local Isinteger_to_floatFORCE = (integer_to_float == "FORCE")
  if Isinteger_to_float and not (Isinteger_to_floatPRESERVE or Isinteger_to_floatFORCE) then
    print([[>>> WARNING: INTEGER_TO_FLOAT value is incorrect, should be "", "FORCE" or "PRESERVE"]])
    Report(to_remove,[[>>> INTEGER_TO_FLOAT value is incorrect, should be "", "FORCE" or "PRESERVE"]],"WARNING")
  end
    
  -- *****************   text_to_add section   ********************
  if text_to_add == nil then
    text_to_add = "" 
  end
  text_to_add = string.gsub(text_to_add,[[\\]],[[\]])
  local IsTextToAdd = (text_to_add ~= "")
  
  -- *****************   to_remove section   ********************
  if to_remove == nil then
    to_remove = "" 
  end
  to_remove = string.upper(to_remove)
  
  local IsToRemove = (to_remove ~= "")
  local IsToRemoveLINE = (to_remove == "LINE")
  local IsToRemoveSECTION = (to_remove == "SECTION")
  if IsToRemove and not (IsToRemoveLINE or IsToRemoveSECTION) then
    print([[>>> WARNING: REMOVE value is incorrect, should be "", "LINE" or "SECTION"]])
    Report(to_remove,[[>>> REMOVE value is incorrect, should be "", "LINE" or "SECTION"]],"WARNING")
  elseif IsTextToAdd and IsToRemove then
    print([[>>> WARNING: BOTH ADD and REMOVE are used in this EXML_CHANGE_TABLE section]])
    Report("",[[>>> BOTH ADD and REMOVE are used in this EXML_CHANGE_TABLE section]],"WARNING")
  end
    
  -- *****************   replace_type section   ********************
  if replace_type == nil then
    replace_type = "" 
  end
  replace_type = string.upper(replace_type)
  
  local IsReplaceALL = (replace_type == "ALL")
  local IsReplaceALLFOLLOWING = (replace_type == "ALLFOLLOWING")
  local IsReplaceRAW = (replace_type == "RAW")
  local IsReplaceADDAFTERSECTION = (replace_type == "ADDAFTERSECTION") and IsTextToAdd
  
  local IsReplace = (replace_type ~= "")
  if IsReplace then
    if not IsTextToAdd and not (IsReplaceALL or IsReplaceALLFOLLOWING or IsReplaceRAW) then
      print([[>>> WARNING: REPLACE_TYPE value is incorrect, should only be "", "ALL", "ALLFOLLOWING" or "RAW"]])
      Report(replace_type,[[>>> REPLACE_TYPE value is incorrect, should only be "", "ALL", "ALLFOLLOWING" or "RAW"]],"WARNING")
    end
    if IsTextToAdd and not IsReplaceADDAFTERSECTION then
      print([[>>> WARNING: REPLACE_TYPE value is incorrect, should only be "" or "ADDAFTERSECTION"]])
      Report(replace_type,[[>>> REPLACE_TYPE value is incorrect, should only be "" or "ADDAFTERSECTION"]],"WARNING")
    end
    IsReplace = false
  end
  
  -- *****************   value_match section   ********************
  if value_match == nil then
    value_match = "" 
  end
  value_match = string.gsub(value_match,[[\\]],[[\]])
  local IsValueMatch = (value_match ~= "")
  
  local IsNumberValue_Match, IsIntegerValue_Match = CheckValueType(value_match,Isinteger_to_floatFORCE)
  
  -- *****************   value_match_type section   ********************
  if value_match_type == nil then
    value_match_type = "" 
  end
  value_match_type = string.upper(value_match_type)
  
  local IsValueMatchType = (value_match_type ~= "")
  local IsValueMatchTypeNumber = (value_match_type == "NUMBER")
  local IsValueMatchTypeString = (value_match_type == "STRING")

  if IsValueMatch and IsValueMatchType and not (IsValueMatchTypeNumber or IsValueMatchTypeString) then
    print([[>>> WARNING: VALUE_MATCH_TYPE value is incorrect, should be "", "NUMBER" or "STRING"]])
    Report(value_match_type,[[>>> VALUE_MATCH_TYPE value is incorrect, should be "", "NUMBER" or "STRING"]],"WARNING")
    IsValueMatchType = false
  end
  
  -- *****************   value_match_options section   ********************
  if value_match_options == nil or value_match_options == "" then
    value_match_options = "=" 
  end
  value_match_options = string.upper(value_match_options)
  
  local IsValueMatchOptions = (value_match_options ~= "")
  local IsValueMatchOptionsMatch = (value_match_options == "=")
  local IsValueMatchOptionsNoMatch = (value_match_options == "~=")
  local IsValueMatchOptionsLSS = (value_match_options == "<")
  local IsValueMatchOptionsLEQ = (value_match_options == "<=")
  local IsValueMatchOptionsGTR = (value_match_options == ">")
  local IsValueMatchOptionsGEQ = (value_match_options == ">=")

  if IsValueMatch and IsValueMatchOptions 
      and not (IsValueMatchOptionsMatch 
            or IsValueMatchOptionsNoMatch
            or IsValueMatchOptionsLSS
            or IsValueMatchOptionsLEQ
            or IsValueMatchOptionsGTR
            or IsValueMatchOptionsGEQ) then
    print([[>>> WARNING: VALUE_MATCH_OPTIONS value is incorrect, should be "", "=", "~=", "<", "<=", ">" or ">="]])
    Report(IsValueMatchOptions,[[>>> VALUE_MATCH_OPTIONS value is incorrect, should be "", "=", "~=", "<", "<=", ">" or ">="]],"WARNING")
    IsValueMatchOptions = false
  end
  if not IsNumberValue_Match and (
               IsValueMatchOptionsLSS
            or IsValueMatchOptionsLEQ
            or IsValueMatchOptionsGTR
            or IsValueMatchOptionsGEQ) then
    print([[>>> WARNING: Incorrect value of VALUE_MATCH_OPTIONS used with VALUE_MATCH, should be "", "=" or "~="]])
    Report(IsValueMatchOptions,[[>>> Incorrect value of VALUE_MATCH_OPTIONS used with VALUE_MATCH, should be "", "=" or "~="]],"WARNING")
    IsValueMatchOptions = false
  end
  
  --***************************************************************************************************  
  local function CheckValueMatchOptions(value_match,value)
    local result = false
    local valueIsNumber, valueIsInteger = CheckValueType(value,false)
    local value_matchIsNumber, value_matchIsInteger = CheckValueType(value_match,false)
    
    local IsNumber = false
    local IsString = false
    if valueIsNumber and value_matchIsNumber then
      --ok to compare as NUMBER
      IsNumber = true
      if not valueIsInteger then
        value = string.round(value)
        value_match = string.round(value_match)        
      end
    elseif not valueIsNumber and not value_matchIsNumber then
      --ok to compare as STRING
      IsString = true
    end
    
    if IsString then
      if IsValueMatchOptionsMatch then
        result = (value == value_match)
      elseif IsValueMatchOptionsNoMatch then
        result = (value ~= value_match)
      end
    elseif IsNumber then
      if IsValueMatchOptionsMatch then
        result = (tonumber(value) == tonumber(value_match))
      elseif IsValueMatchOptionsNoMatch then
        result = (tonumber(value) ~= tonumber(value_match))
      elseif IsValueMatchOptionsLSS then
        result = (tonumber(value) < tonumber(value_match))
      elseif IsValueMatchOptionsLEQ then
        result = (tonumber(value) <= tonumber(value_match))
      elseif IsValueMatchOptionsGTR then
        result = (tonumber(value) > tonumber(value_match))
      elseif IsValueMatchOptionsGEQ then
        result = (tonumber(value) >= tonumber(value_match))
      end
    end
    return result
  end
  --***************************************************************************************************  

  -- *****************   IsLineOffset section   ********************
  local IsLineOffset = (line_offset ~= nil and line_offset ~= "")
  local line_offsetNumber = (tonumber(line_offset) or math.huge)
  if IsLineOffset and line_offsetNumber == math.huge then
    print([[>>> WARNING: LINE_OFFSET value type is incorrect, should be "" or "+/- a number"]])
    Report(line_offset,[[>>> LINE_OFFSET value type is incorrect, should be "" or "+/- a number"]],"WARNING")
  end
  
  local offset = 0
  local offset_sign = "+"
  if IsLineOffset then
    if line_offsetNumber < 0 then
      offset_sign = "-"
    end
    offset = math.abs(math.tointeger(line_offsetNumber))
  end
  
  -- *****************   special_key_words section   ********************
 local IsWholeFileSearch = false
  local IsSomeKeyWords = false
  local IsOneWordOnly = false
  local FirstNotEmptyWord = 0

  local spec_key_words = {}
  local IsSpecialKeyWords = false
  
  if special_key_words == nil then
    spec_key_words[1] = ""
    spec_key_words[2] = ""
  else 
    if type(special_key_words) ~= "table" then
      --not a table, just one word
      if special_key_words == "" then
        --nothing to do
      else
        --Not a table AND only one value: problem
        spec_key_words[1] = special_key_words
      end
    else
      --already a table, use it
      spec_key_words = special_key_words
    end
  end
  
  -- --to remove empty words
  -- local tempTable = {}
  -- for i=1,#spec_key_words do
    -- if spec_key_words[i] ~= "" then
      -- tempTable[i] = string.gsub(spec_key_words[i],[[\\]],[[\]])
    -- end
  -- end
  -- spec_key_words = tempTable
  
  -- print(spec_key_words[1],spec_key_words[2])
  if #spec_key_words > 0 then
    if (#spec_key_words >= 2) and spec_key_words[1] ~= "" and spec_key_words[2] ~= "" then
      IsSpecialKeyWords = true
    end
    if #spec_key_words == 1 then
      --only one spec_key_words: problem
      print()
      print(">>> WARNING: SPECIAL_KEY_WORDS will be IGNORED: ONLY ONE (name or value).  Please correct your script!")
      Report("","SPECIAL_KEY_WORDS will be IGNORED: ONLY ONE (name or value).  Please correct your script!","WARNING")
    end
    if #spec_key_words%2 ~= 0 then
      --odd number of spec_key_words: problem
      print()
      print(">>> WARNING: SPECIAL_KEY_WORDS will be IGNORED: ODD number of (name or value).  Please correct your script!")
      Report("","SPECIAL_KEY_WORDS will be IGNORED: ODD number of (name or value).  Please correct your script!","WARNING")
    end
    
    if IsSpecialKeyWords and (spec_key_words[1] == "" or spec_key_words[2] == "") then
      --one or both keywords are empty
      print()
      print(">>> WARNING: SPECIAL_KEY_WORDS will be IGNORED: empty string found.  Please correct your script!")
      Report("","SPECIAL_KEY_WORDS will be IGNORED: empty string found.  Please correct your script!","WARNING")
    end

    local Empty
    for i=1,#spec_key_words do
      if spec_key_words[i] == "" then
        Empty = true
        break
      end
    end
    
    if IsSpecialKeyWords and Empty then
      --at least one keyword is empty
      print()
      print(">>> WARNING: SPECIAL_KEY_WORDS may be IGNORED: at least one empty string found.  Please correct your script!")
      Report("","SPECIAL_KEY_WORDS may be IGNORED: at least one empty string found.  Please correct your script!","WARNING")
    end
  end
  -- print(tostring(IsSpecialKeyWords))
  
  pv("# spec_key_words = "..#spec_key_words)
  for i=1,#spec_key_words do
    pv(spec_key_words[i])
  end
  
  --  *******************************************************
  -- FROM HERE ON [special_key_words] is know as [spec_key_words] (a table)
  --  *******************************************************
  
  -- *****************   preceding_key_words section   ********************
  if preceding_key_words == nil then preceding_key_words = "" end
  local prec_key_words = {}
  if type(preceding_key_words) ~= "table" then
    --not a table, just one word
    --Make it a table, we want a table!
    prec_key_words[1] = preceding_key_words
    IsOneWordOnly = true

    if prec_key_words[1] == "" then 
      IsOneWordOnly = false
      IsSomeKeyWords = false
    else
      IsSomeKeyWords = true
      FirstNotEmptyWord = 1
    end

  else
    --already a table, use it
    prec_key_words = preceding_key_words

    --to remove empty words
    local tempTable = {}
    for i=1,#prec_key_words do
      if prec_key_words[i] ~= "" then
        tempTable[i] = string.gsub(prec_key_words[i],[[\\]],[[\]])
      end
    end
    prec_key_words = tempTable
    
    --one or many words
    --maybe empty or not
    if #prec_key_words > 1 then
      IsOneWordOnly = false
      FirstNotEmptyWord = 1
      IsSomeKeyWords = true
    elseif #prec_key_words == 1 then
      --only one word
      IsOneWordOnly = true
      IsSomeKeyWords = true
      FirstNotEmptyWord = 1
    else
      IsSomeKeyWords = false
      prec_key_words[1] = ""
    end
  end
  
  pv("# prec_key_words = "..#prec_key_words)
  for i=1,#prec_key_words do
    pv(prec_key_words[i])
  end
  
  --  *******************************************************
  -- FROM HERE ON [preceding_key_words] is know as [prec_key_words] (a table)
  --  *******************************************************
  
  -- *****************   where_key_words section   ********************
  local WhereKeyWords = {{"",""}}
  local IsWhereTable = false
  
  if where_key_words == nil then
    WhereKeyWords[1][1] = "IGNORE"
    WhereKeyWords[1][2] = "IGNORE"
  else 
    if type(where_key_words) ~= "table" then
      --not a table, make it a table
      if where_key_words == "" then
        WhereKeyWords[1][1] = "IGNORE"
        WhereKeyWords[1][2] = "IGNORE"
      else
        print(">>> WARNING: WHERE is not a table, please correct your script!")
        Report("",">>> WHERE is not a table, please correct your script!","WARNING")
      end
    else
      --already a table, use it
      WhereKeyWords = where_key_words
    end
  end
  
  if (#WhereKeyWords > 0) and (WhereKeyWords[1] ~= "" or WhereKeyWords[2] ~= "") then
    IsWhereTable = true
  end

  for i=1,#WhereKeyWords do
    if WhereKeyWords[i][1] == nil then
      --we have a problem, should not be nil
      print([[>>> ERROR: A WHERE "Property name/value" is nil, please correct your script!]])
      Report("",[[>>> A WHERE "Property name/value" is nil, please correct your script!]],"ERROR")
      WhereKeyWords[i][1] = "" --to prevent a crash
    end
    if WhereKeyWords[i][2] == nil then
      --we have a problem, should not be nil
      print([[>>> ERROR: A WHERE "newvalue" is nil, please correct your script!]])
      Report("",[[>>> A WHERE "newvalue" is nil, please correct your script!]],"ERROR")
      WhereKeyWords[i][2] = "" --to prevent a crash
    end
    WhereKeyWords[i][1] = string.gsub(WhereKeyWords[i][1],[[\\]],[[\]])
    WhereKeyWords[i][2] = string.gsub(WhereKeyWords[i][2],[[\\]],[[\]])
  end
  
  --  *******************************************************
  -- FROM HERE ON [where_key_words] is know as [WhereKeyWords] (a table)
  --  *******************************************************

  -- *****************   ISxxx section   ********************
  local IsReplaceAllInGroup = ((IsReplaceRAW or IsReplaceALL) and ((IsSomeKeyWords and (not IsOneWordOnly)) or IsSpecialKeyWords))
  IsWholeFileSearch = (not IsSomeKeyWords and not IsSpecialKeyWords) or ((IsReplaceRAW or IsReplaceALL) and not IsReplaceAllInGroup)

  -- if IsReplaceRAW or (IsReplaceALL and not IsReplaceAllInGroup) then
    -- IsWholeFileSearch = true
  -- end
  
  if (io.open("..\\ISxxx.txt") ~= nil) then
    print("")
    print(" + [Key_words Info]".."                              IsReplaceRAW: "..tostring(IsReplaceRAW))
    print(" +           IsSomeKeyWords: "..tostring(IsSomeKeyWords).."           IsSpecialKeyWords: "..tostring(IsSpecialKeyWords))
    print(" +            IsOneWordOnly: "..tostring(IsOneWordOnly).."           IsWholeFileSearch: "..tostring(IsWholeFileSearch))
    print(" +        FirstNotEmptyWord: "..FirstNotEmptyWord.."           IsReplaceALLFOLLOWING: "..tostring(IsReplaceALLFOLLOWING))
    print(" +              IsTextToAdd: "..tostring(IsTextToAdd).."    IsReplaceADDAFTERSECTION: "..tostring(IsReplaceADDAFTERSECTION))
    print(" +      IsReplaceAllInGroup: "..tostring(IsReplaceAllInGroup).."               IsReplaceALL: "..tostring(IsReplaceALL))
    print(" +      IsValueMatchOptions: "..tostring(IsValueMatchOptions).."         value_match_options: ["..value_match_options.."]")
  end
  
  -- *****************   SCRIPTBUILDERscript section   ********************
  local ScriptType = "User"
  if SCRIPTBUILDERscript then
    --treat this script as a SCRIPTBUILDER script
    ScriptType = "SCRIPTBUILDER"
  end

  -- *****************   main section   ********************
  local TextFileTable, TextFileTableLineCount = ParseTextFileIntoTable(file) --the EXML file
  
  local size = GetFileSize(file)
  pv("size of "..file.." is "..size)
  -- if size < 1e+6 then
    WholeTextFile = LoadFileData(file) --the EXML file as one text, for speed searching for uniqueness
  -- else
    -- WholeTextFile = ""
  -- end
  
  local GroupStartLine = {}
  local GroupEndLine = {}
  local Group_Found = false
  local SpecialKeyWordLine = 0
  
  local FoundNum = 0
  local LastResort = false
  
  local k = 1 --to iterate thru GroupStartLine/GroupEndLine values
    
  -- if gVerbose then Report(prec_key_words,"from user lua script","INFO") end
  
  --Note: all property/value combo in val_change_table use the Same_KEY_WORDS
  
  --find group(s) where key_words lead
  local FileName = string.sub(file,#MASTER_FOLDER_PATH + #LocalFolder + 1)
  Group_Found,GroupStartLine,GroupEndLine,FoundNum,SpecialKeyWordLine,LastResort 
          = FindGroup(FileName,TextFileTable,WholeTextFile,prec_key_words,IsSpecialKeyWords,spec_key_words,IsReplaceALL,WhereKeyWords)
  pv("Searching in lines "..GroupStartLine[1].."-"..GroupEndLine[1]..", found "..FoundNum.." group(s), SpecialKeyWordLine is "..tostring(SpecialKeyWordLine))
  
  if not Group_Found then
    print()
    print(">>> WARNING: PRECEDING_KEY_WORDS not found, skipping this change!, see REPORT.txt")
    local info = ""
    for i=1,#prec_key_words do
      info = info..[["]]..prec_key_words[i]..[[",]]
    end
    info = string.sub(info,1,-2) --remove last ,
    print("      PRECEDING_KEY_WORDS: "..info)
    Report(info,"PRECEDING_KEY_WORDS not found, skipping this change!","WARNING") --Wbertro: info was prec_key_words
  else
    pv("Found "..#GroupStartLine.." group(s)")  
  end
  
  if IsSpecialKeyWords and SpecialKeyWordLine == 0 then
    local ThreeDots = ""
    if #spec_key_words > 2 then ThreeDots = "... " end
    print()
    print(">>> WARNING: SPECIAL_KEY_WORDS: "..ThreeDots.."["..spec_key_words[#spec_key_words-1].."] and ["..spec_key_words[#spec_key_words].."] not found, skipping this change!, see REPORT.txt")
    Report(ThreeDots..[["]]..spec_key_words[#spec_key_words-1]..[[", "]]..spec_key_words[#spec_key_words]..[["]],"SPECIAL_KEY_WORDS not found, skipping this change!","WARNING")
    Group_Found = false
    
    -- print(tostring(Group_Found),FoundNum,#GroupStartLine,tostring(LastResort))
    -- for i=1,#GroupStartLine do
      -- print(GroupStartLine[i],GroupEndLine[i])
    -- end
  end

  local ReplNumber = 0
  local ADDcount = 0
  local REMOVEcount = 0
  
  if Group_Found then
    pv("Entering Group_Found...")
    
    --used by ALLFOLLOWING
    local LastReplacementLine = GroupStartLine[1] - 1
    
    local AtLeastOneReplacementDone = false
    
    --we have val_change_table that has all {property, value} to be changed with these prec_key_words
    local j = 0 --to iterate the val_change_table
    
    while j <= (#val_change_table - 1) do
      --point to next property/value combo
      j = j + 1
      local property = val_change_table[j][1]
      local value = val_change_table[j][2]
      
--Wbertro: RETHINK this IGNORE handling

      --***************************************************************************************************
      local function GetSpecialKeyWordsInfo(spec_key_words)
        local Info = ""
        for i=1,#spec_key_words,2 do
          Info = Info.."(["..spec_key_words[i].."],["..spec_key_words[i+1].."]), "
        end
        Info = string.sub(Info,1,-3)
        Report("","-- Based on SPECIAL_KEY_WORDS pairs: >>> "..Info.." <<< ")
        print("\nBased on SPECIAL_KEY_WORDS pairs: >>> "..Info.." <<< ")
      end
      --***************************************************************************************************
      
      --***************************************************************************************************
      local function GetPrecKeyWordsInfo(prec_key_words)
        local Info = ""
        for i=1,#prec_key_words do
          Info = Info.."["..prec_key_words[i].."], "
        end
        return string.sub(Info,1,#Info - 2)
      end
      --***************************************************************************************************

      if string.upper(property) == "IGNORE" and string.upper(value) == "IGNORE" then
        pv([[In property="IGNORE" and value="IGNORE"]])
        if IsSpecialKeyWords then
          pv("   with SPECIAL_KEY_WORDS")

          if #prec_key_words == 1 and IsSomeKeyWords then
            pv("      and one PRECEDING_KEY_WORDS")
            property = prec_key_words[1]
          else  
            property = spec_key_words[#spec_key_words-1]
          end
          -- value = spec_key_words[#spec_key_words]
          
          GetSpecialKeyWordsInfo(spec_key_words)

          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","            and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("         and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end

       elseif #prec_key_words >= 2 then
          --TODO: works with text_to_add, we could check
          pv("   with PRECEDING_KEY_WORDS >= 2")
          property = prec_key_words[#prec_key_words - 1]
          value = prec_key_words[#prec_key_words]
        
          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","-- Based on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("\nBased on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end

        elseif #prec_key_words >= 1 then                --bertro change 2019-05-23
          pv("   with PRECEDING_KEY_WORDS >= 1")
          property = prec_key_words[#prec_key_words]    --bertro change 2019-05-23
          --value = prec_key_words[#prec_key_words]

          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","-- Based on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("\nBased on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end

        end
        
      elseif string.upper(property) == "IGNORE" then
        pv([[In property="IGNORE"]])
        if IsSpecialKeyWords then
          pv("   with SPECIAL_KEY_WORDS")
          property = spec_key_words[#spec_key_words-1]
        
          GetSpecialKeyWordsInfo(spec_key_words)
          
          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","            and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("         and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end
          
        elseif #prec_key_words >= 1 and prec_key_words[1] ~= "" then
           --TODO: probably using a math_operation, we could check
          pv("   with PRECEDING_KEY_WORDS >= 1")
          property = prec_key_words[#prec_key_words] --use the last PRECEDING_KEY_WORDS

          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","-- Based on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("\nBased on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end

        end
        
      elseif j == 1 and not LastResort then --only the first time
      -- elseif j == 1 then --only the first time
        pv("First time and not LastResort")
        if IsSpecialKeyWords then
          pv("   with SPECIAL_KEY_WORDS")
          -- local ThreeDots = ""
          -- if #spec_key_words > 2 then ThreeDots = "... " end
          -- local Info = ThreeDots.."["..spec_key_words[#spec_key_words-1].."], ["..spec_key_words[#spec_key_words].."]"

          GetSpecialKeyWordsInfo(spec_key_words)

          if #spec_key_words%2 ~= 0 then
            --not an even number of spec_key_words: problem
            -- print()
            print(">>> WARNING: SPECIAL_KEY_WORDS: NOT an even number of (name/value).  LAST entry will be IGNORED.  Please correct your script!")
            Report("","SPECIAL_KEY_WORDS: NOT an even number of (name/value).  LAST entry will be IGNORED.  Please correct your script!","WARNING")
          end
          
          if IsSomeKeyWords then
            local Info = GetPrecKeyWordsInfo(prec_key_words)
            Report("","            and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
            print("         and PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          end
          
        elseif IsSomeKeyWords then
          pv("   with SomeKeyWords")

          local Info = GetPrecKeyWordsInfo(prec_key_words)
          Report("","-- Based on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
          print("\nBased on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")

        else --no key_words
          pv("   without KeyWords")
          Report("","-- No key_word specified...")
          print("\nNo key_word specified...")
        end
        
        -- for i=1,FoundNum do
          -- Report("","    -- Points to "..GroupStartLine[i].." to "..GroupEndLine[i])
          -- print("    -- Points to "..GroupStartLine[i].." to "..GroupEndLine[i])
        -- end
      end
      
      pv("property="..property.." ".."value="..value)
      local newIsValueMatchType = IsValueMatchType
      if not IsValueMatchType then
        --none specified by the user
        --let us force it to be of the same type as the value
        local ValueTypeIsNumber, ValueIsInteger = CheckValueType(value,false)
        if ValueTypeIsNumber then
          value_match_type = "NUMBER"
        else
          value_match_type = "STRING"
        end
        newIsValueMatchType = true
      end
            
      do --prepare info to inform user
        local spacer = 0
        local msg0 = ""
        local msg1 = ""
        local msg2 = ""
        local msg3 = ""
        local msg4 = ""
        local msg5 = ""
        
        if math_operation ~= nil and string.len(math_operation) > 0 then
          msg1 = "Math_operation "
          msg2 = "("..math_operation..")"
        end
        
        if IsValueMatch then
          if IsValueMatchOptionsMatch then
            msg3 = " matching ["..value_match.."]"
          else
            msg3 = " not matching ["..value_match.."]"
          end
        end
        
        if newIsValueMatchType then
          msg3 = msg3.." of type ["..value_match_type.."]"
        end
        
        if IsLineOffset then
          if IsSpecialKeyWords then
            local ThreeDots = ""
            if #spec_key_words > 2 then ThreeDots = "... " end
            msg5 = " after "..ThreeDots.."["..spec_key_words[#spec_key_words-1].."] and ["..spec_key_words[#spec_key_words].."]"
          else
            msg5 = " after ["..prec_key_words[#prec_key_words].."]"
          end
          msg4 = " with a line offset of "..line_offset
        end
        
        if IsTextToAdd then
          if IsReplaceADDAFTERSECTION then
            Report("","    Looking to >>> add some text <<< after SECTION with Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
            print("\n    Looking to >>> add some text <<< after SECTION with Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
            spacer = 11
          else
            Report("","    Looking to >>> add some text <<< after Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
            print("\n    Looking to >>> add some text <<< after Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
            spacer = 11
          end
        elseif IsToRemove then
          Report("","    Looking to >>> remove some text <<< at Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
          print("\n    Looking to >>> remove some text <<< at Property name ["..property.."] and value ["..value.."]"..msg3..msg4)
          spacer = 11
        else
          Report("","    Looking for >>> ["..property.."]: New value will be >>> "..msg1.."["..msg2..value.."]"..msg3..msg4..msg5)
          print("\n    Looking for >>> ["..property.."]: New value will be >>> "..msg1.."["..msg2..value.."]"..msg3..msg4..msg5)
          spacer = 12
        end
        
        if IsReplace then
          -- if IsReplaceADDAFTERSECTION then
            -- msg0 = string.rep(" ",spacer).."    >>> Replace operation is ["..replace_type.."]"
            -- if IsSomeKeyWords then
              -- msg0 = msg0.." based on ".."["..prec_key_words[#prec_key_words].."]"
            -- end
          -- else
            msg0 = string.rep(" ",spacer).."    >>> Replace operation is ["..replace_type.."]"
            if IsSomeKeyWords then
              local Info = ""
              for i = 1,#prec_key_words do
                Info = Info.."["..prec_key_words[i].."], "
              end
              Info = string.sub(Info,1,#Info - 2)
              msg0 = msg0.." based on key_words: "..Info
            end
          -- end
          Report("",msg0)
          print(msg0)
        end      
      end
      
      if tonumber(value) ~= nil and tonumber(value) >= 10000000 then
        --MBINCompiler may produce a problematic MBIN that once decompiled will have a value of "1.0E+7"
        print([[WARNING: MBINCompiler may generate a MBIN that once decompiled will have a value like "1E+07"]])
        print([[         xxxxx Your script contains a value over "9999999" xxxxx]])
        print([[         Any value over "9999999" like "10000123" will become "1.000012E+07"]])
        print([[         That could prevent NMS from using the mod]])
        Report("",[[MBINCompiler may generate a MBIN that once decompiled will have a value like "1E+07"]],"WARNING")
        Report("",[[       xxxxx Your script contains a value over "9999999" xxxxx]],"")
        Report("",[[       Any value over "9999999" like "10000123" will become "1.000012E+07"]],"")
        Report("",[[       That could prevent NMS from using the mod]],"")
      end
      
      if FoundNum > 0 then
        All_Words_Found = true
        if FoundNum > 1 then
          Report("","    --                    >>>>> Found "..FoundNum.." candidate instances.")
          print("        >>>>> Found "..FoundNum.." candidate instances.")
          if IsReplaceALL then
            Report("","    --                    >>>>> ALL instances where requested to be processed <<<<<")
            print("\n    --                    >>>>> ALL instances where requested to be processed <<<<<")
          else
            Report("","    --                    >>>>> Only FIRST instance will be processed <<<<<")
            print("\n    --                    >>>>> Only FIRST instance will be processed <<<<<")
          end
          -- Report("","You may want to check your [\"PRECEDING_KEY_WORDS\" and/or \"SPECIAL_KEY_WORDS\"] if the replacements are faulty!","WARNING")
          -- print("    -- >>> WARNING: You may want to check your [\"PRECEDING_KEY_WORDS\" and/or \"SPECIAL_KEY_WORDS\"] if the replacements are faulty!")
        end
      end

      k = 0 --to iterate thru GroupStartLine/GroupEndLine values
      
      if #GroupStartLine > 1 and (IsTextToAdd or IsToRemove) then
        --we need to reverse the order of the Groups
        --so that we add or remove from the bottom up
        local Gs = {}
        local Ge = {}
        for i=#GroupStartLine,1,-1 do
          Gs[#Gs+1] = GroupStartLine[i]
          Ge[#Ge+1] = GroupEndLine[i]
        end
        GroupStartLine = Gs
        GroupEndLine = Ge
      end
      
      while k <= #GroupStartLine - 1 do
        --go explore next group for the current property/value combo
        k = k + 1

        local i = GroupStartLine[k] - 1
        
        if IsSpecialKeyWords and IsLineOffset then
          i = SpecialKeyWordLine - 1 --this is the line to offset from
        elseif IsReplaceALLFOLLOWING then
          pv("LastReplacementLine: "..LastReplacementLine)
          i = LastReplacementLine
        end
        
        local CurrentLine = i --used with text_to_add and to_remove
        local InWhile = false

        --using while because we can change the value of i and GroupEndLine
        --that is useful with line_offset, text_to_add and maybe other manipulations

        if IsTextToAdd or IsToRemove then
          --respect end of section
          pv("IsTextToAdd or IsToRemove: respecting end of section")
        elseif (not IsReplaceAllInGroup) and IsReplaceAll then
          --we need to replace more than in that group
          pv("(not IsReplaceAllInGroup) and IsReplaceAll: continuing to eof")
          GroupEndLine[k] = #TextFileTable
        elseif IsReplaceALLFOLLOWING then
          --we need to replace ALL that follow, even outside the bottom of the section
          pv("IsReplaceALLFOLLOWING: continuing to eof")
          GroupEndLine[k] = #TextFileTable
        end
        
        local EndLine = GroupEndLine[k] --to remember the section end

        local SearchGroupRange = tostring(i + 1).." to "..tostring(GroupEndLine[k])
        pv("SearchGroupRange = "..SearchGroupRange)
        if not IsTextToAdd and not IsToRemove then
          print("                >>> Searching in lines "..SearchGroupRange..[[...]])
          Report("","                >>> Searching in lines "..SearchGroupRange..[[...]])
        end

        -- print("Just before the BIG INNER WHILE: ["..property.."] ["..value.."], about to process line "..i + 1)
        while i <= (GroupEndLine[k] - 1) do
          if not InWhile then
            -- pv("Entering inner while...")
            InWhile = true
          end
          
          local repl_done = false
          i = i + 1 --next line
          CurrentLine = i
          
          local line = TextFileTable[i]
          -- print(line)
          if line == nil then
            print("WARNING: Problem with [current line] being nil")            
            Report("","Problem with [current line] being nil","WARNING")
            break
          end
          
          -- if IsOneWordOnly and IsWholeFileSearch then
            -- --only one prec_key_words is supplied
            -- if StripInfo(line,[[<Property name="]],[["]]) == prec_key_words[1] then
              -- --found a SoS 
            -- end
          -- end
          
          if IsReplaceRAW then
            if string.find(line,property,1,true) ~= nil then 
              -- print("Found a line at "..i..": "..property)
              --we found A line containing the property string
              --it is "anything goes here", free for all!
              --if we searched [[oper]], it will find [[Property]] ==> all lines
              pv("RAW replacement of: [" .. property .. "] with: [" .. value.."]")
              TextFileTable[i] = string.gsub(line,property,value) 
              repl_done = true
            end
          else --replace_type ~= "RAW"
            --(i == 2) is a special case where the whole EXMl content was removed
            if (i == 2) 
                  or StripInfo(line,[[<Property name="]],[["]]) == property 
                  or StripInfo(line,[[<Property value="]],[["]]) == property 
                  or (property == "IGNORE" and (IsTextToAdd or IsToRemove)) then
              
              pv("Found THE line at "..i..": "..property)
              
              local exstring = StripInfo(line,[[value="]],[["]])
              
              --why do this, value CAN be ""
              -- if exstring == nil or exstring == "" then
                -- --retrieve the name= instead of the value=
                -- --TODO: is it ok to do this? In what circumstances?
                -- pv("   >>>  INFO: Using StripInfo(line,[[name=\"]],[[\"]]) to get in...")
                -- exstring = StripInfo(line,[[name="]],[["]])
              -- end
              pv("(Before value_match)                  Line "..i..": value=["..exstring.."] ["..line.."], Property=\""..property.."\", Value=\""..value.."\"")
              
              if not IsTextToAdd and not IsToRemove then
                --process line_offset stuff
                if IsLineOffset then
                  if offset_sign == "+" then 
                    if #TextFileTable >= i+offset then
                      line=TextFileTable[i+offset] 
                      i=i+offset --we go forward in the file
                    else
                      Report("","Problem with [current line + offset] being after end of file","WARNING")
                    end
                  elseif offset_sign == "-" then 
                    line=TextFileTable[i-offset]
                    if i-offset >= 1 then
                      line=TextFileTable[i-offset]
                      --i=i-offset --we do not backtrack in the file
                    else
                      Report("","Problem with [current line - offset] being before the beginning of file","WARNING")                      
                    end
                  end
                  --we get the new value from offset line
                  exstring = StripInfo(line,[[value="]],[["]])
                  
                  if exstring == nil or exstring == "" then
                    --TODO: is it ok to do this? In what circumstances?
                    pv("   >>>  INFO: Using StripInfo(line,[[name=\"]],[[\"]]) after applying offset...")
                    exstring = StripInfo(line,[[name="]],[["]])
                  end
                  pv("(After offset)                        Line "..i..": value=["..exstring.."] ["..line.."], Property=\""..property.."\", Value=\""..value.."\"")
                end
              end
              
              local OrgValueTypeIsNumber, OrgValueIsInteger = CheckValueType(exstring,Isinteger_to_floatFORCE)
              -- pv(i..": ["..exstring.."] ["..tostring(OrgValueTypeIsNumber).."] ["..tostring(OrgValueIsInteger).."]")

              if not IsValueMatch or (IsValueMatchOptions and CheckValueMatchOptions(value_match,exstring)) then
                    -- or (IsValueMatchOptionsMatch and exstring == value_match) 
                    -- or (IsValueMatchOptionsNoMatch and exstring ~= value_match) then
                if not newIsValueMatchType 
                      or (value_match_type == "NUMBER" and type(tonumber(exstring)) == string.lower(value_match_type)) 
                      or (value_match_type == "STRING" and type(exstring) == string.lower(value_match_type)) then 
                  
                  if not IsTextToAdd and not IsToRemove then
                    pv("(After value_match, value_match_type) Line "..i..": value=["..exstring.."] ["..line.."], Property=\""..property.."\", Value=\""..value.."\"")
                    local newvalue = nil --could be a number OR a string
                    
                    if math_operation == nil or math_operation == "" then
                      --no math_operation, keep original value
                      pv("no math_operation")
                      newvalue = value
                    elseif string.len(math_operation) == 1 then -- {+, -, *, /} only
                      newvalue =  IntegerIntegrity(
                                    ExecuteMathOperation(
                                      math_operation,
                                      tonumber(exstring),
                                      tonumber(value)
                                    ),
                                    OrgValueIsInteger
                                  )
                    elseif string.find(string.sub(math_operation, 2, 3),"F:") then --"*F:endString"
                      newvalue =  IntegerIntegrity(
                                    ExecuteMathOperation(
                                      string.sub(math_operation, 1, 1),
                                      tonumber(
                                        TranslateMathOperatorCommandAndGetValue(
                                          TextFileTable,
                                          string.sub(math_operation, 4), --value to look for
                                          i, --from this line
                                          "forward"
                                        )
                                      ),
                                      tonumber(value)
                                    ),
                                    OrgValueIsInteger
                                  )
                    elseif string.find(string.sub(math_operation, 2, 4),"FB:") then
                      newvalue =  IntegerIntegrity(ExecuteMathOperation(string.sub(math_operation, 1, 1)
                          ,tonumber(TranslateMathOperatorCommandAndGetValue(TextFileTable, string.sub(math_operation, 5), i, "backward"))
                          ,tonumber(value)),OrgValueIsInteger)	
                    elseif string.find(string.sub(math_operation, 2, 3),"L:") then 
                      newvalue =  IntegerIntegrity(
                                    ExecuteMathOperation(
                                      string.sub(math_operation, 1, 1),
                                      tonumber(
                                        StripInfo(TextFileTable[i+tonumber(string.sub(math_operation, 4))],[[value="]],[["]])
                                      ),
                                      tonumber(value)
                                    ),
                                    OrgValueIsInteger
                                  )							
                    elseif string.find(string.sub(math_operation, 2, 4),"LB:") then 
                      newvalue =  IntegerIntegrity(ExecuteMathOperation(string.sub(math_operation, 1, 1)
                          ,tonumber(StripInfo(TextFileTable[i-tonumber(string.sub(math_operation, 5))],[[value="]],[["]]))
                          ,tonumber(value)),OrgValueIsInteger)
                    else
                      --not a valid math_operation, keep original value
                      newvalue = value
                    end
                    
                    pv("(After math_operation) Line "..i..": value=["..newvalue.."] ["..line.."], Property=\""..property.."\", Value=\""..value.."\"")                    
                    if value ~= "IGNORE" then
                      local Ending = [[" />]]
                      if string.sub(line,-2) == [[">]] then
                        Ending = [[">]]
                      end
                      -- we CANNOT use gsub here because it could replace at wrong places like:
                      -- <Property name="_3rdPersonAngleSpeedRangePitch" value="3" />
                      -- when replacing such a value (3 with 8) it becomes:
                      -- <Property name="_8rdPersonAngleSpeedRangePitch" value="8" />
                      
                      if string.find(line,[[<Property name=]],1,true) ~= nil and string.find(line,[[value=]],1,true) ~= nil then
                        --standard value replacement on a line with the property
                        --a line with BOTH name AND value, value could be EMPTY
                        --like: <Property name="Filename" value="MODELS/PLANETS/BIOMES/BARREN/HQ/TREES/DRACAENA.SCENE.MBIN" />
                        --like: <Property name="ProceduralTexture" value="TkProceduralTextureChosenOptionList.xml">
                        
                        TextFileTable[i] = string.sub(line,1,string.find(line,[[value="]],1,true)-1)..[[value="]]..newvalue..Ending
                        repl_done = true
                      elseif string.find(line,[[Property value=]],1,true) ~= nil then
                        -- lines with value only, CANNOT BE EMPTY
                        -- like: <Property value="TkProceduralTextureChosenOptionSampler.xml">
                        -- could be a SIGNIFICANT KEY_WORD
                        TextFileTable[i] = string.sub(line,1,string.find(line,[[value="]],1,true)-1)..[[value="]]..newvalue..Ending
                        repl_done = true
                      elseif string.find(line,[[Property name=]],1,true) ~= nil then
                        -- lines with name only, CANNOT BE EMPTY
                        -- like: <Property name="GenericTable">
                        -- like: <Property name="List" />
                        -- could be a SIGNIFICANT KEY_WORD
                        TextFileTable[i] = string.sub(line,1,string.find(line,[[name="]],1,true)-1)..[[name="]]..newvalue..Ending
                        repl_done = true
                      else
                        print("XXX Un-handled line type, Please report! ["..line.."]")
                        Report(line,"XXX Un-handled line type, Please report!","ERROR")
                      end
                      pv("(After replacement) Line "..i..": TextFileTable[i] = ["..TextFileTable[i].."]")
                    else
                      pv("(value is IGNORE) Line "..i..": TextFileTable[i] = ["..TextFileTable[i].."]")
                    end
                  else --text_to_add and/or to_remove has a value
                    if IsLineOffset then
                      if offset_sign == "+" then
                        i = i + offset
                        if i > #TextFileTable then
                          i = #TextFileTable - 1
                        end
                      elseif offset_sign == "-" then
                        i = i - offset
                        if i < 3 then
                          i = 3 --it must be after the header at least
                        end
                      end
                    end	

                    if IsTextToAdd then
                      pv("Preparing to ADD some text...")
                      if IsReplaceADDAFTERSECTION then
                        
                        local bottom = GroupEndLine[k]

                        -- local bottom = GoDownToOwnerEnd(TextFileTable,CurrentLine)

                        -- print(bottom)
                        i = bottom
                      end
                      local _,linecount = string.gsub(text_to_add,"\n","")
                      pv("text_to_add:linecount = "..linecount)
                      pv("    -- Adding text after line: " .. i)
                      CurrentLine = i --so we remember
                      local textmod = table.concat(TextFileTable,"\n",1,i)
                      textmod = textmod.."\n"..text_to_add.."\n"
                      textmod = textmod..table.concat(TextFileTable,"\n",i+1,#TextFileTable)
                      WriteToFile(string.gsub(textmod,"\n\n","\n"), file)
                      TextFileTable, TextFileTableLineCount = ParseTextFileIntoTable(file) --reload the EXML file
                      --in case we have to replace ALL
                      i = i + linecount - 1 --point to the last line inserted
                      GroupEndLine[k] = #TextFileTable --make sure we get to the new last line of the file
                      print("    -- Lines "..(CurrentLine + 1).." - "..(i+1).." added using text in [\"ADD\"]")
                      Report("","    -- Lines "..(CurrentLine + 1).." - "..(i+1).." added using text in [\"ADD\"]")
                      ADDcount = ADDcount + 1
                      repl_done = true
                    end --if IsTextToAdd then

                    if IsToRemove then
                      pv("    -- Removing text at line: " .. i)
                      CurrentLine = i --so we remember
                      if IsToRemoveSECTION then
                        -- print(TextFileTable[CurrentLine])

                        local top = GroupStartLine[k]
                        local bottom = GroupEndLine[k]
                        
                        -- local top = GoUPToOwnerStart(TextFileTable,CurrentLine)
                        -- local bottom = GoDownToOwnerEnd(TextFileTable,CurrentLine)

                        -- print(top.."-"..bottom)
                        --delete section from exml
                        for m=bottom,top,-1 do
                          table.remove(TextFileTable,m)
                        end
                        -- local linecount = bottom - top
                        print("    -- Lines "..top.." - "..bottom.." removed using info in [\"REMOVE\"]")
                        Report("","    -- Lines "..top.." - "..bottom.." removed using info in [\"REMOVE\"]")
                      
                      elseif IsToRemoveLINE then
                        --delete line i from exml
                        table.remove(TextFileTable,i)
                        print("    -- Line "..i.." removed using info in [\"REMOVE\"]")
                        Report("","    -- Line "..i.." removed using info in [\"REMOVE\"]")
                      end
                      
                      i = CurrentLine --point to the next line to process
                      
                      
                      --Wbertro: is this always ok? >>> NO.........
                      --or should we do it bottom up!
                      
                      GroupEndLine[k] = #TextFileTable --make sure we get to the new last line of the file
                      REMOVEcount = REMOVEcount + 1
                      repl_done = true
                    end --if IsToRemove then
                  end --if not IsTextToAdd and not IsToRemove then
                  
                else
                  --no match_type
                  --REMARKED to reduce clutter in output
                  -- Report("","Line "..i..", ["..property.."] with a value of ["..exstring.."] does not match a ["..value_match_type..
                            -- "] like ["..value.."], XXXXX this value not replaced XXXXX","WARNING")
                  -- print("    -- Line "..i..", ["..exstring.."] type does not match a ["..value_match_type
                      -- .."],                           XXXXX this value not replaced >>> WARNING:")
                end --value_match_type == type(value) or empty
              end --value_match == value or empty
            end --we found THE line in the EXML file
          end --if IsReplaceRAW then
          
          if repl_done then
            AtLeastOneReplacementDone = true
            if not (IsTextToAdd or IsToRemove) then
              if value == "IGNORE" then
                local spacer = "    "
                local part1 = "-- On line "..i..", SKIPPED this value"
                Report("",spacer..part1)
                print(spacer..part1)              
              else
                local spacer = "    "
                local spacer1 = "    "
                local spacer2 = spacer1
                local part1 = "-- On line "..i..", exchanged:" .. spacer1 .. "[" .. trim(line) .. "]"
                if string.len(part1) < 86 then spacer1 = string.rep(" ",86 - string.len(part1) + string.len(spacer1)) end
                Report("",spacer..part1 .. spacer1 .. "with: " .. spacer2 .. "[" .. trim(TextFileTable[i]) .. "]")
                print(spacer..part1 .. spacer1 .. "with: " .. spacer2 .. "[" .. trim(TextFileTable[i]) .. "]")
                
                if i > EndLine then
                  --a replacement outside/after the end of the current group
                  print("-???- This replacement is outside of the search group: "..SearchGroupRange..".  Could be Ok, you decide... -???-")
                  Report("","Replacement on line "..i.." is outside of the search group: "..SearchGroupRange..".  Could be Ok, you decide...","WARNING")
                end
                
                ReplNumber = ReplNumber + 1
              end
            
              --here we decide if we continue down the file or break for a new val_change_table combo
              -- if (not IsSomeKeyWords and IsReplaceALL) or IsReplaceAllInGroup or IsReplaceRAW then
              if IsReplaceALL or IsReplaceAllInGroup or IsReplaceRAW then
                --because we want to continue replacing values down the file until GroupEndLine[k]
                --Note: if ADD was used, we already point to the last line inserted
                pv("Looping to continue replacing values down the file until GroupEndLine[k]")
              elseif IsReplaceALLFOLLOWING then
                LastReplacementLine = i + 1 --the line following the last replacement
                pv("break on IsReplaceALLFOLLOWING")
                break
              elseif not IsReplaceALL then
                --our replacement is done, we exit this group
                pv("break on not IsReplaceALL")
                break
              else
                --not an approved word for replace_type maybe
                --or no more property/value combo to process
                --ANYWAY, we are done for this bunch
                pv("break on not an approved word")
                break
              end
            else --IsTextToAdd or IsToRemove
              --get to next section
              break
            end

          else --not repl_done 
            if IsSpecialKeyWords and IsOneWordOnly then
              --lets go down until we find VALUE_CHANGE_TABLE, even outside the bottom of the section
              pv("No repl_done, but IsSpecialKeyWords and IsOneWordOnly, so continuing down...")
              GroupEndLine[k] = #TextFileTable        
            end
          end --if repl_done then     
        end --while i <= (GroupEndLine[k] - 1) do
        
        pv("Exiting inner while...")
        pv("")
      end --while k <= #GroupStartLine - 1 do
    end --while j <= (#val_change_table - 1) do
    
    if not AtLeastOneReplacementDone then
      --replacement NOT done
      print("")
      print(">>> WARNING: No action done!")
      Report("","No action done!","WARNING")
    else 
      -- if ReplNumber > 0 or ADDcount > 0 or REMOVEcount > 0 then
      pv("Saving changes to "..file)
      WriteToFile(ConvertLineTableToText(TextFileTable), file)	
    end
    
  else
    Report(property,"Could not find PRECEDING_KEY_WORDS or SPECIAL_KEY_WORDS!","WARNING")
  end
  
  return ReplNumber, ADDcount, REMOVEcount
end

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
function FindGroup(FileName,TextFileTable,WholeTextFile,prec_key_words,IsSpecialKeyWords,spec_key_words,IsReplaceALL,WhereKeyWords)
  pv(THIS.."Starting FindGroup()")
  
  --***************************************************************************************************
  local function GoUPToOwnerStart(lineInSection)
    local level = 0
    local OwnerStartLine = 0
    for i=lineInSection,1,-1 do
      local Orgline = TextFileTable[i]
      if string.find(Orgline,[[/>]],1,true) ~= nil then
        --skip this line, never an owner
      elseif string.find(Orgline,[[">]],1,true) ~= nil then
        level = level - 1
      elseif string.find(Orgline,[[/Property>]],1,true) ~= nil then
        --always the end of a group
        level = level + 1
      end
      if level == -1 then
        --owner start line found
        OwnerStartLine = i
        break
      end
    end
    return OwnerStartLine
  end
  --***************************************************************************************************
  --***************************************************************************************************
  local function GoDownToOwnerEnd(lineInSection)
    local level = 0
    local OwnerEndLine = 0
    pv("GoDownToOwnerEnd:lineInSection = "..lineInSection)
    for i=lineInSection,#TextFileTable do
      local Orgline = TextFileTable[i]
      if string.find(Orgline,[[/>]],1,true) ~= nil then
        --skip this line, never an owner
      elseif string.find(Orgline,[[/Property>]],1,true) ~= nil then
        --always the end of a group
        level = level - 1
      elseif string.find(Orgline,[[">]],1,true) ~= nil then
        level = level + 1
      end
      if level == -1 then
        --owner end line found
        OwnerEndLine = i
        break
      end
    end
    pv("GoDownToOwnerEnd:OwnerEndLine = "..OwnerEndLine)
    assert(OwnerEndLine ~= nil,"FindGroup:GoDownToOwnerEnd:OwnerEndLine == nil")
    if OwnerEndLine == 0 then OwnerEndLine = #TextFileTable end
    return OwnerEndLine
  end
  --***************************************************************************************************
  --***************************************************************************************************
  local function CheckUniqueness(WholeTextFile,spec_key_words)
    --count = 0 >>> not found, problem
    --count = 1 >>> unique, good
    --count > 1 >>> not unique, maybe good or not
    local s = [[<Property name="]]..spec_key_words[1]..[[" value="]]..spec_key_words[2]..[[" />]]
    local _,count = string.gsub(WholeTextFile,s,s)
    if count == 1 then
      pv("CheckUniqueness: Unique")
    elseif count == 0 then
      pv("CheckUniqueness: Not found")
    else
      pv("CheckUniqueness: More than one")
    end
    return count
  end
  --***************************************************************************************************
  --***************************************************************************************************
  local function GetLevel(ExmlLineText)
    if ExmlLineText == nil or ExmlLineText == "" then
      return -1
    end    
    local level = string.find(ExmlLineText,[[<]],1,true)
    level = (level - 1) / 2
    return level
  end
  --***************************************************************************************************
  --***************************************************************************************************
  local function GetPrecKeywordsWithTreeMap(StartLine)
    pv("Trying to locate key_words using the file tree map info...StartLine = "..StartLine)
    --returns ALL the Tree without SpecialKeyWords
    local FILE_LINE,TREE_LEVEL,KEY_WORDS = MapFileTree(TextFileTable)
    local TopLine = 1
    local BottomLine = FILE_LINE[#FILE_LINE]
    
    local Strict = true
    
    local j = 1 --to iterate prec_key_words
    local level = 1
    
    local All_Words_Found = false
    local done_All_Words = false
    local pointer = 0
    
    for i=1,#FILE_LINE do
      if FILE_LINE[i] >= StartLine then
        pointer = i - 1
        break
      end
    end
    if pointer == 0 then pointer = 1 end
    
    for i=pointer,#FILE_LINE do
      -- print("["..FILE_LINE[i].."]\t ["..TREE_LEVEL[i].."]"..string.rep("  ",TREE_LEVEL[i]*2).."["..KEY_WORDS[i].."]")
      local text = KEY_WORDS[i]
      
      -- local DoIt = false
      if not (All_Words_Found or done_All_Words) then
        if TREE_LEVEL[i] >= level and string.find(text,[["]]..prec_key_words[j]..[["]],1,true) ~= nil then
          --could be at/or in the next level
          
          --we are at the right level AND we have found one of the key_word(s)
          pv("Line "..FILE_LINE[i].." "..text.." - "..prec_key_words[j].." j = "..j)
          level = TREE_LEVEL[i]
          
          if j == #prec_key_words then
            --this is the last key_word
            --it is a section head NOT a value in this section
            All_Words_Found = true
            -- FoundNum = 1
            TopLine = GoUPToOwnerStart(FILE_LINE[i])
            BottomLine = GoDownToOwnerEnd(FILE_LINE[i] + 1) --maybe we will change it later
            pv("Tree level = "..level..", Lines = "..TopLine.."-"..BottomLine)
          else
            --let us look for the next one
            j = j + 1
          end        
        else
          --pv("Line "..i.." skipped")
        end
        
        if j > #prec_key_words then
          --we may have or NOT found all the key_words but there are no more prec_key_words
          done_All_Words = true
        end
      else
        --All_Words_Found or done_All_Words
        --now we need to find the end of this group
        --pv("Looking for Tree level "..(level - 1).." (Tree Map shows "..TREE_LEVEL[i].." at line "..i..")")
        -- if (level - 1) == TREE_LEVEL[i] then
          -- BottomLine = GoDownToOwnerEnd(FILE_LINE[i])
          -- pv("New BottomLine = "..BottomLine)
          break
        -- end
      end
    end --for i=StartLine,#FILE_LINE do
    -- pv("pointer = "..pointer)
    return All_Words_Found,TopLine,BottomLine
  end
  --***************************************************************************************************
    
  -- Start of main code
  
  local LastResort = false
  local FoundNum = 0
  local GroupStartLine = {3}
  local GroupEndLine = {#TextFileTable}
  
  local All_Words_Found = false
  local All_SpecialWords_Found = false
  -- local done_All_Words = false
  local ReturnInfo = false

  local SpecialKeyWordLine = 0
  -- if IsSpecialKeyWords and (#spec_key_words >= 1) then --Wbertro: was > 
  if IsSpecialKeyWords then
    pv([[Trying to locate Group Start/End lines based on SPECIAL_KEY_WORDS ... "]]..spec_key_words[#spec_key_words-1]..[[" and "]]..spec_key_words[#spec_key_words]..[["]])
    local count = CheckUniqueness(WholeTextFile,spec_key_words)
    if count == 1 then
      --count = 1 >>> unique, good (SCRIPTBUILDER guaranties uniqueness, user do not)
      --    record range info
      pv("count = 1, Looking for SPECIAL_KEY_WORDS between lines "..GroupStartLine[1].." and "..GroupEndLine[1])
      local j = 1
      while spec_key_words[j] ~= nil and spec_key_words[j+1] ~= nil do
        if spec_key_words[j] ~= "" and spec_key_words[j+1] ~= "" then
          for n = GroupStartLine[1],GroupEndLine[1] do
            local line = TextFileTable[n]
            if string.find(line,[["]]..spec_key_words[j]..[["]],1,true) ~= nil
                  and (string.find(line,[["]]..spec_key_words[j+1]..[["]],1,true) ~= nil or spec_key_words[j+1] == "IGNORE") then
              --found the line, replace the Group Start/End lines
              SpecialKeyWordLine = n
              GroupStartLine[1] = GoUPToOwnerStart(n)
              GroupEndLine[1]   = GoDownToOwnerEnd(n)
              break
            end
          end          
        else
          break
        end
        j = j + 2
      end
      if SpecialKeyWordLine > 0 then        
        FoundNum = FoundNum + 1
        -- All_Words_Found = true
        All_SpecialWords_Found = true
        pv("count = 1, Found SPECIAL_KEY_WORDS between lines "..GroupStartLine[1].." and "..GroupEndLine[1])
      end
      if All_SpecialWords_Found then
        if prec_key_words[#prec_key_words] ~= "" then
          --    look for the last prec_key_words line in that range
          for n = GroupStartLine[1], GroupEndLine[1] do
            local line = TextFileTable[n]
            if string.find(line,[["]]..prec_key_words[#prec_key_words]..[["]],1,true) then
              --found the line, replace the Group Start/End lines
              SpecialKeyWordLine = n --Wbertro: was remarked
              GroupStartLine[1] = n
              GroupEndLine[1]   = GoDownToOwnerEnd(n)
              -- FoundNum = FoundNum + 1 --no need to add one more count
              All_Words_Found = true
              pv("count = 1, Found last PRECEDING_KEY_WORDS "..[["]]..prec_key_words[#prec_key_words]..[["]].." at line "..GroupStartLine[1])
              break
            end
          end
          if All_Words_Found then
            --ok
          else
            --let us just do as if prec_key_words was not there
            print("")
            print("WARNING: PRECEDING_KEY_WORDS ".."["..prec_key_words[#prec_key_words].."] NOT found in the current section, IGNORING IT")
            Report("","PRECEDING_KEY_WORDS ".."["..prec_key_words[#prec_key_words].."] NOT found in the current section, IGNORING IT","WARNING")
            
            --we should check if this PrecedingKeyWord points to a range that includes our SpecialKeyWords
            --if yes we can ignore it
            --if not we should report it to the user as a WARNING
            All_Words_Found = true
          end
        else
          All_Words_Found = true
        end
        ReturnInfo = true
        --    return range info
      else
        Report("",[[should have found those SPECIAL_KEY_WORDS: "]]..spec_key_words[1]..[[" and "]]..spec_key_words[2]..[["]],"ERROR")
        print("\n"..[[ERROR: should have found those SPECIAL_KEY_WORDS: "]]..spec_key_words[1]..[[" and "]]..spec_key_words[2]..[["]])
        ReturnInfo = true
      end

    elseif count > 1 then
      --count > 1 >>> not unique, maybe good or bad (not a SCRIPTBUILDER script)
      pv("count > 1, \nSPECIAL_KEY_WORDS ["..spec_key_words[1].."] and ["..spec_key_words[2].."] are not unique in file!")

      --***************************************************************************************************
      local function LocateSpecialKeywordsSection(TextFileTable,index,spec_key_words,StartLine,EndLine)
        local All_Words_Found = true
        local SpecialKeyWordLine = {}
        local Section = 0
        local SectionLevel = {}
        local SectionStartLine = {}
        local SectionEndLine = {}
        pv("index = "..index..", ["..spec_key_words[index].."],["..spec_key_words[index+1].."]")
        -- if spec_key_words[index] ~= nil and spec_key_words[index+1] ~= nil then
          -- if spec_key_words[index] ~= "" and spec_key_words[index+1] ~= "" then
            for n = StartLine,EndLine do
              local line = TextFileTable[n]
              if string.find(line,[["]]..spec_key_words[index]..[["]],1,true) ~= nil
                    and string.find(line,[["]]..spec_key_words[index+1]..[["]],1,true) ~= nil then
                --found a line, record Section Start/End lines and level
                Section = Section + 1
                SpecialKeyWordLine[Section] = n
                SectionStartLine[Section] = GoUPToOwnerStart(n)
                SectionEndLine[Section]   = GoDownToOwnerEnd(n)
                local ExmlLineText = TextFileTable[SectionStartLine[Section]]
                SectionLevel[Section] = GetLevel(ExmlLineText)
              end
            end          
          -- end
        -- end
        
        local FirstLowestLevelSection = 0
        if Section > 0 then
          --find first lowest level section
          local LowestLevel = 999999
          for i=1,#SectionLevel do
            if SectionLevel[i] < LowestLevel then
              LowestLevel = SectionLevel[i]
              FirstLowestLevelSection = i
            end
          end
        else
          --problem: no Section found for pair
          All_Words_Found = false
          SectionStartLine[1] = StartLine
          SectionEndLine[1] = EndLine
          SpecialKeyWordLine[1] = 0
        end
        
        return All_Words_Found, 
               SectionStartLine[FirstLowestLevelSection], 
               SectionEndLine[FirstLowestLevelSection], 
               SpecialKeyWordLine[FirstLowestLevelSection]
      end
      --***************************************************************************************************

      local GroupsIndex = 1
      local Done = false
      repeat
        --let us find the Section pointed to by the SPECIAL_KEY_WORDS pairs
        for index=1,#spec_key_words,2 do
          pv("find the Section pointed to by the SPECIAL_KEY_WORDS pairs")
          All_SpecialWords_Found,GroupStartLine[GroupsIndex],GroupEndLine[GroupsIndex],SpecialKeyWordLine = 
                LocateSpecialKeywordsSection(TextFileTable,index,spec_key_words,GroupStartLine[GroupsIndex],GroupEndLine[GroupsIndex])
          pv(All_SpecialWords_Found)
          pv(GroupStartLine[GroupsIndex])
          pv(GroupEndLine[GroupsIndex])
          pv(SpecialKeyWordLine)
        end
        
        if All_SpecialWords_Found then
          pv("count > 1, Found SPECIAL_KEY_WORDS between lines "..GroupStartLine[GroupsIndex].." and "..GroupEndLine[GroupsIndex])
          FoundNum = FoundNum + 1
          All_Words_Found = false
          if prec_key_words[#prec_key_words] ~= "" then
            --    look for the last prec_key_words line in that range
            for n = GroupStartLine[GroupsIndex], GroupEndLine[GroupsIndex] do
              local line = TextFileTable[n]
              if string.find(line,[["]]..prec_key_words[#prec_key_words]..[["]],1,true) then
                --found the line, replace the Group Start/End lines
                SpecialKeyWordLine = n
                GroupStartLine[GroupsIndex] = n
                All_Words_Found = true
                pv("count > 1, Found last PRECEDING_KEY_WORDS "..[["]]..prec_key_words[#prec_key_words]..[["]].." at line "..GroupStartLine[1])
                break
              end
            end
            if All_Words_Found then
              --ok
            else
              --let us just do as if prec_key_words was not there
              print("")
              print("WARNING: PRECEDING_KEY_WORDS ".."["..prec_key_words[#prec_key_words].."] NOT found in the current section, IGNORING IT")
              Report("","PRECEDING_KEY_WORDS ".."["..prec_key_words[#prec_key_words].."] NOT found in the current section, IGNORING IT","WARNING")
              
              --we should check if this PrecedingKeyWord points to a range that includes our SpecialKeyWords
              --if yes we can ignore it
              --if not we should report it to the user as a WARNING
              All_Words_Found = true
            end
          else
            All_Words_Found = true
          end
          ReturnInfo = true -- return range info
          
        else
          if FoundNum == 0 then
            Report("",[[Should have found all SPECIAL_KEY_WORDS]],"ERROR")
            print("\n"..[[ERROR: Should have found all SPECIAL_KEY_WORDS]])
            ReturnInfo = true
          end
          Done = true
        end
        
        if not Done and IsReplaceALL then
          pv("we should find ALL sections, not just the first one!")
          GroupsIndex = GroupsIndex + 1
          GroupStartLine[GroupsIndex] = GroupEndLine[GroupsIndex - 1]
          GroupEndLine[GroupsIndex] = #TextFileTable
          pv("In not Done and IsReplaceALL")
          pv(GroupsIndex)
        else
          pv("finding first section only!")
          Done = true
        end
      until Done
      
    else
      --count = 0 >>> not found, problem (not a SCRIPTBUILDER script)
      --    user has a problem with his/her script spec_key_words (SCRIPTBUILDER guaranties it can be found)
      --    Report WARNING, skip this change
      Report("","SPECIAL_KEY_WORDS cannot be found.  Skipping this change!","WARNING")
      print("\nWARNING: SPECIAL_KEY_WORDS cannot be found.  Skipping this change!")
      ReturnInfo = true
    end
    
  else
    pv("Going below...")
    --  look for prec_key_words using the file tree map info...
    --  if does not work then
    --    try LastResort
    --    if does not work then
    --      Report WARNING, cannot find prec_key_words using tree map info
    --      Using Last_Resort algorithm...
    --    end
    --  end
  end
  
  local SearchPrec = false
  for i=1,#prec_key_words do
    if prec_key_words[i] ~= nil and prec_key_words[i] ~= "" then
      SearchPrec = true
      break
    end
  end

  if not SearchPrec then
    --no prec or special keywords supplied
    pv("No keywords supplied!")
    All_Words_Found = true
    ReturnInfo = true
  end
  
  local currentLine = 0
  local TopLine = 0
  local BottomLine = 0
  
  if not ReturnInfo and SearchPrec then
    --maybe we can locate the line with the prec_key_words using the Tree Map
    if IsReplaceALL or IsReplaceALLFOLLOWING then
      if #prec_key_words >= 1 then --was > wbertro
        --find ALL lines using TreeMap
        local StartLine = 1
        while true do
          All_Words_Found,TopLine,BottomLine = GetPrecKeywordsWithTreeMap(StartLine)
          pv("All section: Start-Bottom Line: "..TopLine.." - "..BottomLine)
          if All_Words_Found then
            FoundNum = FoundNum + 1
            GroupStartLine[FoundNum] = TopLine
            GroupEndLine[FoundNum] = BottomLine
            StartLine = BottomLine + 1
            ReturnInfo = true
            if StartLine >= #TextFileTable then
              break
            end
          else
            if ReturnInfo then
              All_Words_Found = true
            end
            break
          end
        end
      else
        --find ALL lines using LastResort
      end
    else
      --find first line only
      All_Words_Found,TopLine,BottomLine = GetPrecKeywordsWithTreeMap(1)
      pv("One section: Start-Bottom Line: "..TopLine.." - "..BottomLine)
      if All_Words_Found then
        FoundNum = 1
        GroupStartLine[FoundNum] = TopLine
        GroupEndLine[FoundNum] = BottomLine
        ReturnInfo = true
      end
    end
  end
  
  local SearchGroupRange = tostring(GroupStartLine[1]).." to "..tostring(GroupEndLine[1])
  pv("      A         >>> Searching in lines "..SearchGroupRange..[[...]])

  pv("FoundNum = "..FoundNum)
  if not ReturnInfo and not All_Words_Found and SearchPrec then
    --last resort!!!
    --look for the last KEY_WORD only
    LastResort = true
    FoundNum = 0
    All_SpecialWords_Found = false
    local Found = false
    
    local Info = ""
    for i = 1,#prec_key_words do
      Info = Info.."["..prec_key_words[i].."], "
    end
    Info = string.sub(Info,1,#Info - 2)
    Report("","  Processing file: "..FileName)
    Report("","    Based on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")
    print("\nBased on PRECEDING_KEY_WORDS: >>> "..Info.." <<< ")

    local word = prec_key_words[#prec_key_words]
    local word_before = ""
    if #prec_key_words > 1 then
      word_before = prec_key_words[#prec_key_words - 1]
    end
    
    Report("","    -- >>>>> Could not find [\"PRECEDING_KEY_WORDS\"] = ["..word.."] by following file tree map!!! <<<<<")
    Report("","    -- Looking up the last KEY_WORD only: ["..word.."]")
    print(  "    -- >>>>> Could not find [\"PRECEDING_KEY_WORDS\"] = ["..word.."] by following file tree map!!! <<<<<")
    print("\n-???- Using Last_Resort algorithm... (You may want to review your key_words) -???-")
    Report("","-???- Using Last_Resort algorithm... (You may want to review your key_words) -???-","WARNING")

    print("    -- Looking up the last KEY_WORD only: ["..word.."]")

    for i=1,#TextFileTable do
      local text = TextFileTable[i]
      
      if string.find(text,[[<Property name=]],1,true) ~= nil and string.find(text,[[ value=]],1,true) == nil then
        -- pv("just a [Property name=] by itself")
        local name = StripInfo(text,[[Property name="]],[[>]])
        if string.find(name,"/",1,true) then
          name = string.sub(name,1,#name-3)
        else
          name = string.sub(name,1,#name-1)
        end
        -- pv("name = ["..name.."]")
        
        if name == word then
          Report("","    -- Found KEY_WORD ["..word.."] as a [Property name] alone on line "..i)
          print("    -- Found KEY_WORD ["..word.."] as a [Property name] alone on line "..i)
          Found = true
        end
      elseif string.find(text,[[<Property name=]],1,true) == nil and string.find(text,[[ value=]],1,true) ~= nil then
        -- pv("just a [Property value=] by itself")
        if StripInfo(text,[[Property value="]],[[">]]) == word then
          Report("","    -- Found KEY_WORD ["..word.."] as a [Property value] alone on line "..i)
          print("    -- Found KEY_WORD ["..word.."] as a [Property value] alone on line "..i)
          Found = true
        end
      elseif string.find(text,[[<Property name=]],1,true) ~= nil and string.find(text,[[ value=]],1,true) ~= nil then
        -- pv("a [Property name=] with a [value=]")
        local value = StripInfo(text,[[ value="]],[[>]])
        if string.find(value,"/",1,true) then
          value = string.sub(value,1,#value-3)
        else
          value = string.sub(value,1,#value-1)
        end
        -- pv("value = ["..value.."]")
        
        if StripInfo(text,[[<Property name="]],[[" value=]]) == word then
          -- pv("the [Property name] is the KEY_WORD")
          if word_before == "" or value == word_before then
            Report("","    -- On line "..i..", found it as a PROPERTY NAME with a value of ["..value.."]")
            print("    -- On line "..i..", found it as a PROPERTY NAME with a value of ["..value.."]")
            Found = true
          else
            Report("","    -- On line "..i..", found it as a PROPERTY NAME with a value of ["..value.."], DISCARDED")
            print("    -- On line "..i..", found it as a PROPERTY NAME with a value of ["..value.."], DISCARDED")
          end
        elseif value == word then
          -- pv("the [value] is the KEY_WORD")
          Report("","    -- On line "..i..", found it as a VALUE with a Property name of ["
                  ..StripInfo(text,[[Property name="]],[[" value=]]).."]")
          print("    -- On line "..i..", found it as a VALUE with a Property name of ["
                  ..StripInfo(text,[[Property name="]],[[" value=]]).."]")
          Found = true
        else
          --not found yet
        end
      else
        --a header, Data or /Property line
        --skip it
      end
        
      if Found then
        --found one, GOOD!
        --record position, that line i
        All_Words_Found = true
        FoundNum = FoundNum + 1
        GroupStartLine[FoundNum] = GoUPToOwnerStart(i)
        if GroupStartLine[FoundNum] == i then
          --i is already a SoS, go find EoS
          GroupEndLine[FoundNum] = GoDownToOwnerEnd(i)
        else
          GroupEndLine[FoundNum] = #TextFileTable --ok to go down to the last line
        end
        Found = false
      end
    end --for i=1,#TextFileTable do    

    if IsSpecialKeyWords then
      --let us try to find these SpecialKeyWords inside the groups
      pv([[Trying to locate Group Start/End lines based on SPECIAL_KEY_WORDS "]]..spec_key_words[1]..[[" and "]]..spec_key_words[2]..[["]])
      for k = 1, #GroupStartLine do
        pv("Using SPECIAL_KEY_WORDS between lines "..GroupStartLine[k].." and "..GroupEndLine[k])
        for n = GroupStartLine[k], GroupEndLine[k] do
          local line = TextFileTable[n]
          if string.find(line,[["]]..spec_key_words[1]..[["]],1,true) 
              and string.find(line,[["]]..spec_key_words[2]..[["]],1,true) then
            --found the line, replace the Group Start/End lines
            SpecialKeyWordLine = n
            GroupStartLine[k] = GoUPToOwnerStart(n)
            GroupEndLine[k]   = GoDownToOwnerEnd(n)
            -- FoundNum = FoundNum + 1 --no need to add one more count
            All_Words_Found = true
            All_SpecialWords_Found = true
            break
          end
        end
      end
    end
  end --if not All_Words_Found then
  
  --if WhereKeyWords exist
  --here we could discard all section that do not meet the WhereKeyWords clause

  if TestNoNil("FindGroup()",All_Words_Found,GroupStartLine[1],GroupEndLine[1],FoundNum) then
    pv("Found all Key_Words: "..tostring(All_Words_Found)..", First line: "..GroupStartLine[1]..", Last line: "..GroupEndLine[1]..", Found: "..FoundNum)
    pv("Found all SPECIAL_KEY_WORDS: "..tostring(All_SpecialWords_Found))
  end
  pv(THIS.."Ending FindGroup()")
  return All_Words_Found, GroupStartLine, GroupEndLine, FoundNum, SpecialKeyWordLine, LastResort
end

function LocatePAK(filename)
  pv("In LocatePAK()")
	local TextFileTable = ParseTextFileIntoTable("pak_list.txt")  
  local Pak_FileName = ""
  
  filename = string.gsub(filename,[[.EXML]],[[.MBIN]])
  filename = string.gsub(filename,[[\]],[[/]])
  pv("["..filename.."]")
  pv(#TextFileTable.." lines")
  for i=1,#TextFileTable,1 do
		local line = TextFileTable[i]
		if (line ~= nil) then
      if string.find(line,"Listing ",1,true) ~= nil then
        local start,stop = string.find(line,"Listing ",1,true)
        Pak_FileName = string.sub(line, stop+1)
        pv("["..Pak_FileName.."]")
      else
        if string.find(line,filename,1,true) ~= nil then
          break
        end
      end
		end
	end
  return Pak_FileName
end

function DisplayMapFileTreeEXT(EXML,filename,Debug,Show)
  --******************************************************************
  --NOT THE SAME AS TestReCreatedScript.lua -> MapFileTree()
  --NOT THE SAME AS LoadAndExecuteModScript.lua -> MapFileTree()
  --this DisplayMapFileTree must only recreate all KEY_WORDS to display them in a tree
  --******************************************************************
  if Debug == nil then Debug = false end
  if Show == nil then Show = false end
  
  local KEY_WORDS = {}
  local TREE_LEVEL = {}
  local FILE_LINE = {}
  local level = 0
  
  if type(EXML) ~= "table" then return FILE_LINE,TREE_LEVEL,KEY_WORDS end

  --***************************************************************************************************  
  local function FindKeywordsInRange(TextFile,StartRange,EndRange)
    if EndRange == nil then EndRange = StartRange end
    local KeywordsInRangeTable = {}
    -- print(StartRange,EndRange)
    for i=StartRange,EndRange do
      local text = TextFile[i]
      -- print(text)
      if string.find(text,[[ />]],1,true) ~= nil and string.find(text,[[ue=]],1,true) ~= nil then
        --a line like <Property name="" value="" /> 
        --"name" is a potential special_keyword
        local value = StripInfo(text,[[value="]],[["]])
        if value ~= "" and value ~= "True" and value ~= "False" and tonumber(value) == nil and string.find(value,".",1,true) == nil then
          --could be one, if unique
          local name = StripInfo(text,[[name="]],[["]])
          table.insert(KeywordsInRangeTable,"[*"..string.format("%8u",i)..[[: ]]..name..[[="]]..value.."\"]")
          break
        end
      end --if string.find(
    end --for i=
    if #KeywordsInRangeTable == 0 then
      KeywordsInRangeTable[1] = ""
    end
    -- print("#KeywordsInRangeTable "..#KeywordsInRangeTable)
    -- for i=1,#KeywordsInRangeTable do
      -- if KeywordsInRangeTable[i] == nil then KeywordsInRangeTable[i] = [[*        : unknown="",]] end
    -- end
    --the nearest one
    -- print("one = ["..KeywordsInRangeTable[1].."]")
    return KeywordsInRangeTable[1]
  end
  --***************************************************************************************************  

  local Pak_FileName = LocatePAK(filename)
  local Pak_FileNamePath = NMS_PCBANKS_FOLDER_PATH..Pak_FileName
  local fileInfo = string.gsub(filename,[[\]],[[.]])
  local filepathname = "..\\MapFileTrees\\"..fileInfo..".txt"
  
  if IsFile2Newest(Pak_FileNamePath,filepathname) then
    --the MapFileTree file is newest than the NMS pak file
    --no need to update
    print("      MapFileTree is up-to-date!")
    Report("","      MapFileTree is up-to-date!")
    return FILE_LINE,TREE_LEVEL,KEY_WORDS
  end
  
  --skipping a few lines at start
  local j = 0
  repeat
    j = j + 1
  until string.find(EXML[j],[[<Data template=]],1,true) ~= nil
  
  for i=j,#EXML do
    local text = EXML[i]
    
    if string.find(text,[[/>]],1,true) ~= nil then
      local Name = ""
      if string.find(text,[[<Property name=]],1,true) ~= nil and string.find(text,[[value=]],1,true) ~= nil then
        Name = StripInfo(text,[[<Property name="]],[[" value=]])
      end
      if Name ~= "" then
        local result = FindKeywordsInRange(EXML,i)
        if result ~= "" then --like [*       6: Id="VEHICLE_SCAN"]
          --print("            Line "..i.." Name is ["..Name.."]")
          --like: <Property name="Filename" value="MODELS/PLANETS/BIOMES/BARREN/HQ/TREES/DRACAENA.SCENE.MBIN" />
          --like: <Property name="Id" value="DRONE" />
          --like: <Property name="CreatureType" value="Walker" />
          --like: ...
          --usually could be a SIGNIFICANT KEY_WORD
          table.insert(FILE_LINE,i)
          table.insert(TREE_LEVEL,level+1)
          -- table.insert(KEY_WORDS, [[SPECIALNAME: "]]..Name..[[", ]]..StripInfo(text,[[" value=]],[[ />]])) --remembers name and value
          table.insert(KEY_WORDS, [[SPECIALNAME: {"]]..StripInfo(result,[[: ]],[[=]])..[[",]]..StripInfo(result,[[=]],"]")..[[,},]]) --remembers name and value
        else
          --like: <Property name="Seed" value="0" />
          --skip it
        end
      end
      
    --from here, no lines with />
    elseif string.find(text,[[</Property>]],1,true) ~= nil then
      --like: </Property>
      --NOT a KEY_WORD but should remove preceding KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level+1)
      table.insert(KEY_WORDS, "<<<") --remembers end of section
      level = level - 1
      
    elseif string.find(text,[[<Property name=]],1,true) ~= nil and string.find(text,[[value=]],1,true) ~= nil then
      --like: <Property name="ProceduralTexture" value="TkProceduralTextureChosenOptionList.xml">
      --usually NOT a KEY_WORD but may be needed to match </Property> removing a KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[<Property name=]],[[ value=]])) --remembers name
      
    elseif string.find(text,[[Property name=]],1,true) ~= nil then
      --like: <Property name="Landmarks">
      --this is usually a SIGNIFICANT KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[Property name=]],[[>]])) --remembers name
      
    elseif string.find(text,[[Property value=]],1,true) ~= nil then
      --like: <Property value="TkProceduralTextureChosenOptionSampler.xml">
      --could be a SIGNIFICANT KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[Property value=]],[[>]])) --remembers value
      
    elseif string.find(text,[[<Data template=]],1,true) ~= nil then
      --like: <Data template="GcExternalObjectList">
      --encountered only once at first line
      --NEVER a KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[<Data template=]],[[>]])) --remembers template
      
    elseif string.find(text,[[</Data>]],1,true) ~= nil then
      --like: </Data>
      --encountered only once at end of file
      --NEVER a KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, "/Data") --remembers "/Data"
      
    end
  end  

  os.remove([["]]..filepathname..[["]])
  print("      Creating MapFileTree...")
  WriteToFile("MapFileTree: "..filename.." ("..Pak_FileName..")".."\n",filepathname)
  WriteToFileAppend("   LINE   LEVEL     KEYWORDS".."\n",filepathname)    
  for i=1,#KEY_WORDS do
    if KEY_WORDS[i] ~= "<<<" then
      local line = string.format("%8u",FILE_LINE[i])
      local level = string.format("%2u",TREE_LEVEL[i])
      local info = "["..line.."] ["..level.."]"..string.rep("  ",TREE_LEVEL[i]).."["..KEY_WORDS[i].."]"
      WriteToFileAppend(info.."\n",filepathname)
    end
  end
  print("                             done!")
  Report("","    Created MapFileTree")

  return FILE_LINE,TREE_LEVEL,KEY_WORDS
end

function MapFileTree(TextFileTable,file)
  --******************************************************************
  --NOT THE SAME AS LoadBothEXML.lua -> DisplayMapFileTree()
  --this MapFileTree must recreate the correct KEY_WORDS list for FindGroup() to work correctly
  --******************************************************************
  pv(THIS.."From MapFileTree()")
  
  local KEY_WORDS = {}
  local TREE_LEVEL = {}
  local FILE_LINE = {}
  local level = 0
  
  --skipping a few lines at start
  local j = 0
  repeat
    j = j + 1
  until string.find(TextFileTable[j],[[<Data template=]],1,true) ~= nil
  
  for i=j,#TextFileTable do
    local text = TextFileTable[i]
    
    if string.find(text,[[/>]],1,true) ~= nil then
      --it is never the start of a section
      --can be name or name + value
      
    --from here on, no lines with />
    --can be name, value or name + value    
    elseif string.find(text,[[</Property>]],1,true) ~= nil then
      --like: </Property>
      --NOT a KEY_WORD but should remove preceding KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, "<<<")
      level = level - 1
      
    elseif string.find(text,[[<Property name=]],1,true) ~= nil and string.find(text,[[value=]],1,true) ~= nil then
      --lines with BOTH name AND value
      --like: <Property name="ProceduralTexture" value="TkProceduralTextureChosenOptionList.xml">
      --usually NOT a KEY_WORD but may be needed to match </Property> removing a KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[<Property name=]],[[ value=]]))
      
    elseif string.find(text,[[Property name=]],1,true) ~= nil then
      --lines with name only
      --like: <Property name="Landmarks">
      --this is usually a SIGNIFICANT KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[Property name=]],[[>]]))
      
    elseif string.find(text,[[Property value=]],1,true) ~= nil then
      --lines with value only
      --like: <Property value="TkProceduralTextureChosenOptionSampler.xml">
      --could be a SIGNIFICANT KEY_WORD
      level = level + 1
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, StripInfo(text,[[Property value=]],[[>]]))
      
    elseif string.find(text,[[<Data template=]],1,true) ~= nil then
      --start line
      --like: <Data template="GcExternalObjectList">
      --encountered only once at first line
      --NEVER a KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, [[Data template]] )
      -- table.insert(KEY_WORDS,StripInfo(text,[[Data template=]],[[>]])) --wbertro
      
    elseif string.find(text,[[</Data>]],1,true) ~= nil then
      --ending line
      --like: </Data>
      --encountered only once at end of file
      --NEVER a KEY_WORD
      table.insert(FILE_LINE,i)
      table.insert(TREE_LEVEL,level)
      table.insert(KEY_WORDS, "/Data")
      
    end
  end  

  -- if file ~= nil then
    -- local fileInfo = string.gsub(file,[[\]],[[.]])
    -- os.remove([["]].."..\\MapFileTrees\\MapFileTree."..fileInfo..".txt"..[["]])
    -- print("    Creating MapFileTree."..fileInfo..".txt")
    -- WriteToFile("MapFileTree: "..file.."\n","..\\MapFileTrees\\MapFileTree."..fileInfo..".txt")
    -- WriteToFileAppend("LINE   LEVEL".."\n","..\\MapFileTrees\\MapFileTree."..fileInfo..".txt")    
    -- for i=1,#KEY_WORDS do
      -- if KEY_WORDS[i] ~= "<<<" then
        -- local spacer = "\t"
        -- if FILE_LINE[i] < 10 then spacer = "\t\t" end
        -- local info = "["..FILE_LINE[i].."]"..spacer.." ["..TREE_LEVEL[i].."]"..string.rep("  ",TREE_LEVEL[i]*1).."["..KEY_WORDS[i].."]"
        -- -- print(info)
        -- WriteToFileAppend(info.."\n","..\\MapFileTrees\\MapFileTree."..fileInfo..".txt")
      -- end
    -- end
  -- end
  
  pv(THIS.."From end of MapFileTree()")
  return FILE_LINE,TREE_LEVEL,KEY_WORDS
end

function TranslateMathOperatorCommandAndGetValue(TextFileTable, SearchKeyProperty, pos, direction)
	if direction == "forward" then
		for k=pos,#TextFileTable,1 do
    if (string.find(TextFileTable[k], [["]]..SearchKeyProperty..[["]]) or (SearchKeyProperty == "IGNORE")) then
				return StripInfo(TextFileTable[k],[[value="]],[["]])
			end
		end
	elseif direction == "backward" then
		for k=pos,1,-1 do
			if (string.find(TextFileTable[k], [["]]..SearchKeyProperty..[["]]) or (SearchKeyProperty == "IGNORE")) then
				return StripInfo(TextFileTable[k],[[value="]],[["]])
			end
		end		
	end
end

function CheckValueType(value,Isinteger_to_floatFORCE)
  local ValueTypeIsNumber = (type(tonumber(value)) == "number")
  local ValueIsInteger = false
  if not Isinteger_to_floatFORCE and ValueTypeIsNumber then
    ValueIsInteger = (string.find(value,".",1,true) == nil)
  end
  return ValueTypeIsNumber, ValueIsInteger
end

function IntegerIntegrity(number,valueIsInteger)
  --this needs MAINTENANCE !!!
	--if string.find(property,"Amount") or string.find(property,"Cost") or string.find(property,"Time") then return math.floor(number+0.5)

  --this one: no maintenance
  if valueIsInteger then
    return math.floor(number+0.5)
  end
	return number
end

function ExecuteMathOperation(math_operation,operand1,operand2)
	if math_operation == "*" then 
		return tonumber(operand1)*tonumber(operand2)
	elseif math_operation == "+" then 
		return tonumber(operand1)+tonumber(operand2)			
	elseif math_operation == "-" then 
		return tonumber(operand1)-tonumber(operand2)			
	elseif math_operation == "/" then 
		return tonumber(operand1)/tonumber(operand2)
	-- elseif math_operation == "=" then 
		-- return tonumber(operand2)
	else
    Report(math_operation,"Unknown MATH_OPERATION.  Please check your script!","WARNING")
    print("WARNING: Unknown MATH_OPERATION: ["..math_operation.."]  Please check your script!","WARNING")
		return 1
	end
end

-- ****************************************************
-- main (above like SCRIPTBUILDER\TestReCreatedScript.lua)
--      (below not at all)
-- ****************************************************

if gVerbose == nil then dofile("LoadHelpers.lua") end
pv(">>>     In LoadAndExecuteModScript.lua")
gfilePATH = "..\\" --for Report()

THIS = "In LoadAndExecuteModScript: "

NMS_PCBANKS_FOLDER_PATH = string.sub(LoadFileData("NMS_FOLDER.txt"),1,-2)..[[\GAMEDATA\PCBANKS\]] --to remove CRLF
MASTER_FOLDER_PATH = LoadFileData("MASTER_FOLDER_PATH.txt")
LocalFolder = [[MODBUILDER\MOD\]]

NumReplacements = 0
NumFilesAdded = 0

--the current EXML file in table format
TextFileTable = {}
TextFileTableLineCount = 0

dofile("LoadScriptAndFilenames.lua")
LuaStarting() --because it was ended by LoadScriptAndFilenames.lua

if type(NMS_MOD_DEFINITION_CONTAINER) == "table" then
  HandleModScript(NMS_MOD_DEFINITION_CONTAINER)
end

pv(THIS.."ending")
LuaEndedOk(THIS)
