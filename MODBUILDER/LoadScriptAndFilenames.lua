local function OpenUserScript(Show)
  do
    local Hash = ""
    
    --***************************************************************************************************  
    local function load_conf()
      local env = {
      string = string,
      math = math,
      table = table,
      tonumber = tonumber,
      tostring = tostring,
      type = type,
      print = print,
      assert = assert,
      io = {open=io.open,type=io.type,input=io.input,read=io.read,close=io.close,lines=io.lines,},
      os = {clock=os.clock,date=os.date,difftime=os.difftime,time=os.time,tmpname=os.tmpname,getenv=os.getenv,},
      pairs = pairs,
      ipairs = ipairs,
      } --user can use anything inside this new environment in the user script
      
      local script = LoadFileData(LoadFileData("CurrentModScript.txt"))
      
      --for backward compatibility
      script = string.gsub(script,[[REPLACE_AFTER_ENTRY]],[[PRECEDING_KEY_WORDS]])
      script = string.gsub(script,[[ADDSECTION]],[[ADDAFTERSECTION]])
      local script = string.gsub(script,[[\]],[[\\]])
      
      if string.find(script,[[:write]],1,true) ~= nil then
        local scriptFile = ParseTextFileIntoTable(LoadFileData("CurrentModScript.txt"))
        for i=1,#scriptFile do
          if string.find(scriptFile[i],[[:write]],1,true) ~= nil then
            if string.sub(trim(scriptFile[i]),1,2) ~= [[--]] then
              return {}, "XXXXX <not allowed> Lua keyword in used on line "..i.." of the script XXXXX"
            end
          end
        end
      end
      
      -- To be used if you want to inspect the loaded script
      if (io.open("..\\DEBUG.txt") ~= nil) then
        WriteToFile(script, "..\\TempScript.lua")
      end
      
      local sha1 = require 'sha1'
      Hash = sha1.hex(string.sub(script,1,#script - 40)) 

      SCRIPTBUILDERscript = (Hash == string.sub(script,#script - 39))
      if SCRIPTBUILDERscript then print("A SCRIPTBUILDER script!") end
      
      --***************************************************************************************************  
      local function MyErrHandler(x)
        print("")
        print("Lua Script error: "..x)
        Report("","Lua Script error: "..x,"ERR")
        -- print(debug.traceback(nil,0))
        -- Report("", debug.traceback(nil,0),"ERR")
        LuaEndedOk(THIS)
      end
      --***************************************************************************************************  
      
      local function GetScript()
        return load(script,"User Script",'t',env)
      end
      
      local success, chunk = xpcall(load(script,"User Script",'t',env),MyErrHandler) --better
      -- local chunk, failure = load(script,"User Script",'t',env)
      
      if success then
          -- chunk()
      elseif chunk ~= nil then
        print("")
        print("Lua is reporting: "..chunk)
        Report("","Lua is reporting: "..chunk,"ERR")
      end

      return env, chunk, success
    end
    --***************************************************************************************************  

    local conf,status,success = load_conf()

    -- if status == nil or status == false then --only use this if not using pcall above
    if success then --use this if using pcall above
      pv("Success getting script!")
      print("")
      pv("["..Hash.."]")
      NMS_MOD_DEFINITION_CONTAINER = conf.NMS_MOD_DEFINITION_CONTAINER
    else
      if Show then
        -- print("")
        -- print(status)
        print("XXXXX Error loading user script! XXXXX")
        print("")
        WriteToFile("", "LoadScriptAndFilenamesERROR.txt")
        Report(LoadFileData("CurrentModScript.txt"),"Error loading user script!","ERROR")
        if status ~= nil then
          Report(LoadFileData("CurrentModScript.txt"),tostring(status))
        end
      end
    end
  end
end

local function LocatePAK(file,first)
	local TextFileTable = ParseTextFileIntoTable("pak_list.txt")
  local TempMBIN = string.gsub(file,[[\]],[[/]])
  
  local Pak_File = ""
  local found = false
  
	for i=1,#TextFileTable,1 do
		local line = TextFileTable[i]
		if (line ~= nil) then
      if (string.find(line,"Listing ",1,true) ~= nil) then
        local start,stop = string.find(line,"Listing ",1,true)
        Pak_File = string.sub(line, stop+1)
        pv("["..Pak_File.."]")
      elseif (string.find(line,TempMBIN,1,true) ~= nil) then
        found = true
        if first then
          WriteToFile(Pak_File.."\n", "MOD_PAK_SOURCE.txt")
        else
          WriteToFileAppend(Pak_File.."\n", "MOD_PAK_SOURCE.txt")
        end
        break
      end
		end
	end
  return found,Pak_File
end

local function TestScript(Show,Conflicts)
  if type(NMS_MOD_DEFINITION_CONTAINER) == "table" then
    local msg1 = "user"
    if SCRIPTBUILDERscript then
      msg1 = "SCRIPTBUILDER"
    end
    
    local UserScriptName = LoadFileData("CurrentModScript.txt")
    UserScriptName = string.sub(UserScriptName,string.len(MASTER_FOLDER_PATH..[[ModScript\]])+1)
    
    if Show then
      print("********************************************************************")
      print("   >>>>>  GREAT --- The "..msg1.." script is now loaded!  <<<<<")
      print("********************************************************************")
    end
    
    WriteToFile(NMS_MOD_DEFINITION_CONTAINER["MOD_FILENAME"], "MOD_FILENAME.txt")

    if NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]~=nil then
      local WordWrap1 = "\n"
      local WordWrap2 = "\n"

      for n=1,#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"],1 do
        if n==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"] then WordWrap1 = "" end	

        for m=1,#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"],1 do	
          local mbin_file_source = NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"][m]["MBIN_FILE_SOURCE"]
          if type(mbin_file_source) == "table" then
          
            if type(mbin_file_source[1]) == "table" then
              pv("DETECTED a table of tables MBIN_FILE_SOURCE")
              for k=1,#mbin_file_source,1 do
                mbin_file_source[k][1] = string.gsub(mbin_file_source[k][1],[[/]],[[\]])
                mbin_file_source[k][1] = string.gsub(mbin_file_source[k][1],[[\\]],[[\]])
                pv(mbin_file_source[k][1])
                if m==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]
                      and n==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]
                      and k==#mbin_file_source then --last one of the table
                  WordWrap2 = ""
                end
                if n==1 and m==1 and k==1 then --first time only
                  WriteToFile(mbin_file_source[k][1]
                      .. WordWrap2, "MOD_MBIN_SOURCE.txt")
                else
                  WriteToFileAppend(mbin_file_source[k][1]
                      .. WordWrap2, "MOD_MBIN_SOURCE.txt")
                end
                if Conflicts then
                  WriteToFileAppend(mbin_file_source[k][1]..", "
                      ..UserScriptName..": "..NMS_MOD_DEFINITION_CONTAINER["MOD_FILENAME"].."\n", "MBIN_PAKS.txt")
                end
              end
            
            else
              pv("DETECTED a normal MBIN_FILE_SOURCE table")
              for k=1,#mbin_file_source,1 do
                mbin_file_source[k] = string.gsub(mbin_file_source[k],[[/]],[[\]])
                mbin_file_source[k] = string.gsub(mbin_file_source[k],[[\\]],[[\]])
                pv(mbin_file_source[k])
                if m==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]
                      and n==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"]
                      and k==#mbin_file_source then --last one of the table
                  WordWrap2 = ""
                end
                if n==1 and m==1 and k==1 then --first time only
                  WriteToFile(mbin_file_source[k]
                      .. WordWrap2, "MOD_MBIN_SOURCE.txt")
                else
                  WriteToFileAppend(mbin_file_source[k]
                      .. WordWrap2, "MOD_MBIN_SOURCE.txt")
                end
                if Conflicts then
                  WriteToFileAppend(mbin_file_source[k]..", "
                      ..UserScriptName..": "..NMS_MOD_DEFINITION_CONTAINER["MOD_FILENAME"].."\n", "MBIN_PAKS.txt")
                end
              end
            end

          else
            pv("DETECTED MBIN_FILE_SOURCE as a string")
            mbin_file_source = string.gsub(mbin_file_source,[[/]],[[\]])
            mbin_file_source = string.gsub(mbin_file_source,[[\\]],[[\]])
            pv(mbin_file_source)
            if m==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"][n]["MBIN_CHANGE_TABLE"]
                                   and n==#NMS_MOD_DEFINITION_CONTAINER["MODIFICATIONS"] then
              WordWrap2 = ""
            end
            if n==1 and m==1 then --first time only
              WriteToFile(mbin_file_source
                    .. WordWrap2, "MOD_MBIN_SOURCE.txt")
            else
              WriteToFileAppend(mbin_file_source
                    .. WordWrap2, "MOD_MBIN_SOURCE.txt")
            end		
            if Conflicts then
              WriteToFileAppend(mbin_file_source..", "
                  ..UserScriptName..": "..NMS_MOD_DEFINITION_CONTAINER["MOD_FILENAME"].."\n", "MBIN_PAKS.txt")
            end
          end		
        end
      end
      
      --Get PAK_SOURCE for each MBIN_FILE_SOURCE
      local MBIN_Source,_ = ParseTextFileIntoTable("MOD_MBIN_SOURCE.txt")
      for i=1,#MBIN_Source do
        local found,Pak_File = LocatePAK(MBIN_Source[i],(i==1))
        if not found then
          print("ERROR: PAK not found for "..MBIN_Source[i]..". Check your file path/name!")
          Report("","PAK not found for "..MBIN_Source[i]..". Check your file path/name!","ERROR")
        else
          if Show then
            print("  Found in "..Pak_File..": "..MBIN_Source[i])
            Report("","  Found in "..Pak_File..": "..MBIN_Source[i])
          end
        end
      end
      
      --CleanUP MOD_PAK_SOURCE.txt
      local PAK_Source,_ = ParseTextFileIntoTable("MOD_PAK_SOURCE.txt")
      for i=1,#PAK_Source do
        for j=i+1,#PAK_Source do
          if PAK_Source[i] == PAK_Source[j] then
            PAK_Source[j] = ""
          end
        end
      end
      local PAK_Source_temp = {}
      for i=1,#PAK_Source do
        if PAK_Source[i] ~= "" then
          table.insert(PAK_Source_temp,PAK_Source[i])
        end
      end
      WriteToFile(ConvertLineTableToText(PAK_Source_temp),"MOD_PAK_SOURCE.txt")
      
    else
      WriteToFile("", "MOD_MBIN_SOURCE.txt")
      WriteToFile("", "MOD_PAK_SOURCE.txt")
      -- WriteToFile("", "MOD_FILENAME.txt")
    end
  else
    WriteToFile("", "MOD_MBIN_SOURCE.txt")
    WriteToFile("", "MOD_PAK_SOURCE.txt")
    WriteToFile("", "MOD_FILENAME.txt")
    -- WriteToFile("", "MBIN_PAKS.txt")
    if os.getenv("SkipScriptFirstCheck") == nil then
      print(">>> ERROR: NMS_MOD_DEFINITION_CONTAINER is not a table, this script has a problem!")
      print("")
      WriteToFile("", "LoadScriptAndFilenamesERROR.txt")
      -- if Show then
        Report(LoadFileData("CurrentModScript.txt"),"NMS_MOD_DEFINITION_CONTAINER is not a table, this script has a problem!","ERROR")
      -- end
    end
  end
end

-- ****************************************************
-- main
-- ****************************************************

if gVerbose == nil then dofile("LoadHelpers.lua") end

pv(">>>     In LoadScriptAndFilenames.lua")
gfilePATH = "..\\" --for Report()

THIS = "In LoadScriptAndFilenames: "

MASTER_FOLDER_PATH = LoadFileData("MASTER_FOLDER_PATH.txt")
LocalFolder = [[MODBUILDER\MOD\]]

Show = (io.open("Show.txt") ~= nil) 
Conflicts = (io.open("Conflicts.txt") ~= nil)

SCRIPTBUILDERscript = false
  
--to print them
-- GetLuaCurrentKeyWordsAndAll(_G,"",false)

NMS_MOD_DEFINITION_CONTAINER = ""
OpenUserScript(Show)
if (io.open("..\\Wbertro.txt") ~= nil) and NMS_MOD_DEFINITION_CONTAINER ~= nil then SaveTable("..\\TempTable.txt",NMS_MOD_DEFINITION_CONTAINER) end

pv(THIS.."ending")
TestScript(Show,Conflicts)
LuaEndedOk(THIS)