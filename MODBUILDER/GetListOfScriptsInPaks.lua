function GetListOfScriptsInPaks(input,output)
  local LineTable = ParseTextFileIntoTable(input)
  local TempTable = {}
  
  for i=1,#LineTable do
    local text = LineTable[i]
    if string.find(text,[[.lua ]],1,true) ~= nil then
      table.insert(TempTable,string.sub(text,1,string.find(text,[[ (]],1,true)-1))
    end
  end
  
--..\psarc.exe extract "..\..\ModScript\%%~nxG" --to="..\..\ModScript\EXTRACTED_PAK" -y "/*.lua" 1>NUL 2>NUL
--..\psarc.exe --xml=%XML%

  local source = MASTER_FOLDER_PATH..[[\MODBUILDER\ModScript\]]..PakName
  local destination = MASTER_FOLDER_PATH..[[\MODBUILDER\ModScript\EXTRACTED]]
  local fileToExtract = ScriptName
  
  local text = 
[[
<psarc> 
    <extract archive="D:\NMS Info\Modding\packed\NMSARC.179341B.pak" to="E:\UNPACKED" overwrite="true" > 
        <file archivepath="MODELS/COMMON/CHARACTERS/BACKPACK.ANIM.MBIN" skipifmissing="true" /> 
        <file archivepath="MODELS/COMMON/CHARACTERS/ANIMATIONS/PLAYER_IDLE.ANIM.MBIN" skipifmissing="true" /> 
        <file archivepath="MODELS/COMMON/CHARACTERS/ASTRONAUT/ASTRONAUT01.ANIM.MBIN" skipifmissing="true" /> 
        <file archivepath="MODELS/COMMON/CHARACTERS/ASTRONAUT/HELMETHUD.ANIM.MBIN" skipifmissing="true" /> 
    </extract> 
</psarc> 
]]

  
  -- local text = ConvertLineTableToText(TempTable)
  WriteToFile(text,output)
end

-- ****************************************************
-- main
-- ****************************************************

--we are in MODBUILDER

LocalFolder = ""
if gVerbose == nil then dofile(LocalFolder.."LoadHelpers.lua") end
pv(">>>     In GetListOfScriptsInPaks.lua")
THIS = "In GetListOfScriptsInPaks: "

-- gfilePATH = "..\\" --for Report()

THIS = "In GetListOfScriptsInPaks: " --Check for THIS in code before changing this string

MASTER_FOLDER_PATH = LoadFileData(LocalFolder.."MASTER_FOLDER_PATH.txt")

--NOT COMPLETED
-- GetListOfScriptsInPaks(LocalFolder.."MODS_pak_list.txt","ScriptList.xml")
LuaEndedOk(THIS)

